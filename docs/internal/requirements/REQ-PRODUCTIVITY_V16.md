# REQ-PRODUCTIVITY V16 — Visualización de enfoque

## REQ-V16-001 — Estilos Claro y OLED en Máxima concentración

**Status: Implemented**

### Aprobación

- Aprobado explícitamente por el usuario el 2026-08-30.

### Objetivo

Permitir elegir una presentación clara o de bajo consumo OLED sin alterar el
temporizador ni las salidas seguras de Máxima concentración.

### Criterios de aceptación

- OLED conserva el comportamiento inicial para no cambiar sesiones existentes.
- El menú de visualización ofrece `Claro` y `OLED` cuando Máxima concentración
  está habilitada.
- Claro usa fondo blanco puro, reloj y controles negros, con grises legibles.
- OLED restaura la presentación original de fondo negro puro con reloj,
  controles, aro y textos en grises neutros.
- OLED ofrece una barra horizontal de `Opacidad AMOLED` entre 20% y 100%; el
  valor inicial es 100% y el cambio atenúa todo el contenido de Máxima
  concentración sin introducir superficies transparentes.
- La opacidad elegida se conserva como preferencia local del dispositivo; no
  forma parte de SQLite, copias de la base de datos ni sincronización.
- Al elegir OLED, el menú muestra un switch independiente `Protección AMOLED`,
  activado por defecto.
- Con la protección activa, todo el conjunto visible —reloj, aro, textos y
  controles— cambia suavemente entre posiciones verticales acotadas cada 60
  segundos para reducir contenido estático.
- Desactivar la protección devuelve todo el conjunto a su posición central.
- Claro no aplica desplazamientos aunque la preferencia AMOLED esté activa.
- Cambiar el estilo no inicia, pausa, reinicia ni finaliza el Pomodoro.
- La selección Claro/OLED y el switch de protección son efímeros; únicamente
  la opacidad AMOLED se guarda en el archivo local de ajustes.
- Los dos estilos conservan el menú, los controles indispensables y la salida
  mediante doble toque.

## REQ-V16-002 — Pomodoros completados del plan

**Status: Implemented**

### Aprobación

- Aprobado explícitamente por el usuario el 2026-08-30.

### Objetivo

Mostrar cuántos Pomodoros del plan actual ya finalizaron y cuántos existen en
total sin abrir los detalles del plan.

### Criterios de aceptación

- Un plan activo muestra un icono de check y `X/Y` fuera del reloj, centrado
  inmediatamente encima de los controles.
- Durante un bloque de enfoque, X cuenta únicamente bloques anteriores.
- Durante el descanso posterior, el bloque recién terminado ya forma parte de X.
- X permanece entre cero y Y.
- El dato aparece en enfoque normal, pantalla completa y Máxima concentración.
- Un temporizador sin plan activo no muestra un contador artificial.
- La semántica accesible describe el conteo en español o inglés, sin añadir el
  texto “Pomodoros completados” a la interfaz visible.

### Fuera de alcance

- Cambiar la planificación, duración, historial o significado de una sesión.
- Añadir otras preferencias persistentes o cambios de base de datos; la única
  excepción de este alcance es la opacidad AMOLED local.
- Cambiar acciones de pausa, reinicio, descarte o cierre.

## REQ-V16-003 — Mantener la pantalla encendida durante el Pomodoro

**Status: Implemented**

### Aprobación

- Aprobado explícitamente por el usuario el 2026-09-03.

### Objetivo

Evitar que Android apague la pantalla mientras corre un Pomodoro cuando el
usuario lo solicita, con activación automática al entrar en Máxima
concentración y control manual independiente.

### Criterios de aceptación

- El menú de tres puntos ofrece `Mantener pantalla encendida` en enfoque normal,
  pantalla completa y Máxima concentración.
- Activar Máxima concentración enciende automáticamente esta opción.
- El usuario puede apagarla sin salir de Máxima concentración ni alterar el
  temporizador.
- La bandera nativa se aplica únicamente mientras el contador está corriendo;
  al pausar, terminar, descartar o cerrar la aplicación se libera.
- Reanudar el contador vuelve a aplicarla si el switch continúa encendido.
- No requiere permisos, dependencias, persistencia, cambios de base de datos ni
  sincronización.

## Evidencia de implementación

- OLED conserva negro puro, recupera los grises originales y permite atenuar
  todo el contenido entre 20% y 100% mediante colores sólidos; Claro usa blanco
  puro con contenido negro/gris.
- Protección AMOLED inicia activa, mueve suavemente el conjunto completo cada
  60 segundos entre posiciones verticales acotadas y lo centra al desactivarse.
- El menú mantiene una superficie sólida y ofrece una barra interactiva que no
  lo cierra mientras se arrastra; el valor se restaura desde ajustes locales.
- El contador usa el estado derivado del controlador: enfoque cuenta bloques
  anteriores y descanso incluye el bloque recién terminado; se presenta como
  check más `X/Y` fuera del reloj.
- Las pruebas enfocadas de ajustes, el controlador y la prueba integral con
  referencias visuales pasan; las 468 pruebas del proyecto también pasan.
- El análisis completo de `lib` y `test` está limpio.
- El APK de depuración compiló con Java 17 y se instaló/abrió por ADB
  inalámbrico en el Realme RMX3301 el 2026-08-30.
- La inspección física de legibilidad y movimiento queda pendiente antes de
  promover estos requisitos a `Verified`.
- El control de pantalla encendida usa `FLAG_KEEP_SCREEN_ON` mediante el puente
  Android existente. El análisis completo, las 497 pruebas, la compilación con
  Java 17 y la instalación/apertura inalámbrica en el RMX3301 pasan; la
  comprobación física del tiempo de espera queda pendiente.
