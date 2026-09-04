# REQ-PRODUCTIVITY V18 — Continuidad exacta del plan de enfoque

## REQ-V18-001 — Reanudar únicamente el tiempo pendiente

**Status: Verified**

### Aprobación

- Aprobado explícitamente por el usuario el 2026-08-30.

### Objetivo

Impedir que cerrar y volver a abrir Michi Focus obligue a repetir tiempo de
enfoque que ya fue guardado para una tarea.

### Criterios de aceptación

- El tiempo pendiente se calcula en segundos como duración estimada menos todo
  el enfoque persistido de la tarea.
- Preparar un nuevo plan usa únicamente ese tiempo pendiente; el último bloque
  puede ser menor que un minuto.
- Salir después de una sesión parcial espera a que el runtime anterior quede
  eliminado de la persistencia local.
- Si un cierre interrumpe esa limpieza, el arranque compara el runtime con las
  sesiones guardadas y nunca repite un bloque ya registrado.
- Un bloque completo recuperado continúa en su descanso; una sesión parcial
  recuperada ofrece un nuevo bloque acotado al tiempo real pendiente.
- Llegar a la duración estimada finaliza el plan sin crear otro Pomodoro.
- No se modifica el esquema, la sincronización ni el significado histórico de
  las sesiones existentes.

### Verificación prevista

- Pruebas de plan de 60 minutos con 30 minutos completos y 25 parciales.
- Prueba de runtime antiguo posterior a una sesión completa.
- Prueba de espera transaccional al limpiar el runtime.
- Formato, análisis, suite completa, APK e instalación física.

### Evidencia de implementación

- Un escenario automatizado de 60 minutos completa 30, guarda 25 parciales,
  cierra el runtime y prepara únicamente los 5 minutos restantes.
- La restauración defensiva distingue una sesión completa de una parcial: la
  completa continúa en descanso y la parcial se replantea con el resto exacto.
- Una prueba con limpieza bloqueada demuestra que la salida espera a que el
  runtime anterior se elimine antes de terminar.
- La entrada desde Tareas detecta también un runtime del mismo elemento cuyo
  bloque supera el resto persistido, lo descarta sin guardar tiempo invisible y
  vuelve a preparar únicamente el remanente real.
- El análisis completo de `lib` y `test` está limpio y las 485 pruebas pasan.
- El APK de depuración compiló con Java 17 y se instaló/abrió por ADB
  inalámbrico en el Realme RMX3301 el 2026-08-31.
- La tarea física `aprendizaje supervisado parte 2` conservó 55/60 minutos; al
  elegir Empezar Pomodoro mostró `faltan 5 min` y preparó el reloj en `05:00`,
  con 0/1 bloques y sin iniciar la cuenta.
