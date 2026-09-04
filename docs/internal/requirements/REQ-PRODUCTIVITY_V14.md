# REQ-PRODUCTIVITY V14 — Dictado en campos de texto

## Resumen

Michi Focus permite usar el micrófono como método opcional de entrada en los
campos de texto de tareas, objetivos, rutinas, actividades de rutina y notas
rápidas. El dictado solo transcribe voz a texto editable.

## REQ-V14-001 — Entrada de texto por voz

**Status: Implemented**

### Aprobación

- Aprobado explícitamente por el usuario: 2026-08-29.
- Dependencia autorizada: reconocimiento de voz para frases cortas.
- Destino físico solicitado: Realme mediante depuración inalámbrica.

### Objetivo

Reducir la escritura manual en formularios frecuentes sin convertir la voz en
comandos ni cambiar la lógica existente de guardado.

### Alcance

- Título de nueva tarea y edición de tarea.
- Nombre de nuevo objetivo y edición de objetivo.
- Nombre y descripción de rutina.
- Título de actividad dentro de una rutina.
- Contenido de nota rápida.

### Fuera de alcance

- Interpretar fechas, prioridades, colores, duraciones, estados o acciones.
- Guardar automáticamente un formulario.
- Conservar archivos o grabaciones de audio.
- Sincronizar audio o metadatos del reconocimiento.
- Dictado continuo o escucha en segundo plano.

### Criterios de aceptación

- Cada campo incluido expone una acción de micrófono accesible y coherente con
  el tema.
- El resultado reemplaza la selección actual o se inserta en la posición del
  cursor y continúa siendo editable antes de guardar.
- Solo un campo puede escuchar a la vez.
- La escucha permanece activa hasta que el usuario la detiene, con un límite de
  seguridad de cinco minutos y tolerancia amplia de silencio.
- La aplicación solicita permiso de micrófono mediante Android y explica los
  estados de permiso denegado, servicio no disponible y error de reconocimiento.
- Si falta el modelo local, la aplicación muestra si Android lo programó, el
  porcentaje real cuando está disponible, la finalización o el error, sin
  reiniciar silenciosamente una descarga ya activa.
- Cancelar o fallar el dictado conserva el contenido previo.
- El guardado, validación, persistencia y sincronización existentes no cambian.
- El reconocimiento usa el servicio de voz disponible en el dispositivo y no
  promete funcionamiento sin conexión cuando Android no lo ofrece.

### Checklist

- [x] Problema, alcance y no objetivos documentados.
- [x] Criterios de aceptación definidos.
- [x] Requisito aprobado.
- [x] Dependencia y permiso Android integrados.
- [x] Componente reutilizable y formularios implementados.
- [x] Pruebas, análisis, APK e instalación física completados.

### Evidencia de implementación — 2026-08-29

- `speech_to_text 7.4.0` integrado en modo exclusivamente local mediante
  Android, sin persistencia de audio en Michi Focus.
- Acción reutilizable añadida a los campos aprobados; el texto continúa siendo
  editable y el guardado sigue siendo explícito.
- Cancelación, error, reemplazo de selección y exclusión mutua cubiertos por
  pruebas automatizadas.
- Análisis de ``lib`` y ``test``: sin incidencias.
- Suite completa: 463 pruebas aprobadas tras la corrección del proveedor y los
  formularios actuales de Objetivos.
- APK de depuración compilado con Java 17, instalado y abierto correctamente en
  el Realme RMX3301 por depuración inalámbrica.
- Queda como validación manual posterior aceptar el permiso y pronunciar una
  frase en el teléfono; no bloquea el estado Implemented.

### Decisión de privacidad — 2026-08-29

- La autorización temporal del proveedor estándar quedó sustituida por la
  decisión posterior del usuario de usar reconocimiento exclusivamente local.
- Si falta el idioma, Michi Focus solicita a Android descargar oficialmente el
  modelo local correspondiente. La aplicación no conserva ni sincroniza audio.
- En dispositivos cuyo proveedor no ofrece un paquete `es-BO`, se usa `es-ES`
  como variante local compatible para evitar el cierre inmediato del micrófono.
- El reconocimiento local crea una sesión Android nueva después de preparar el
  modelo, evitando reutilizar una sesión que todavía conserve el estado previo.

### Corrección de estado de descarga — 2026-08-30

- Android comunica a la interfaz los estados programado, descargando, listo y
  error; en Android 14 o posterior también comunica el porcentaje real.
- Nueve pruebas enfocadas, las 465 pruebas del proyecto y el análisis estático
  de los archivos modificados pasan sin incidencias. El análisis completo solo
  conserva un aviso previo de un script temporal de verificación SQLite.
- El código Android compiló con Java 17 y el APK actualizado se instaló y abrió
  en el Realme RMX3301 con Android 15 mediante depuración inalámbrica.
- Falta únicamente pronunciar una frase y observar la transición real del modelo
  en el teléfono; requiere interacción del usuario con el micrófono.

### Corrección de proveedor local — 2026-08-30

- El diagnóstico físico confirmó que Android descargaba `es-ES` mediante Google
  TTS, pero la grabación abría el servicio local AiAi, cuyo paquete seguía
  ausente. Descarga y reconocimiento ahora usan el mismo servicio configurado
  por Android, siempre con preferencia sin conexión.
- Los límites de silencio se envían con el tipo entero esperado por el proveedor
  para que Android no los descarte.
- El APK corregido compiló con Java 17, las nueve pruebas enfocadas pasaron y la
  actualización se instaló en el RMX3301. Queda la prueba hablada final.

### Corrección de descarga programada en Android 13 — 2026-08-31

- El Poco M4 Pro 2201117PG usa Android 13/API 33 y el mismo servicio configurado
  de Google que el Realme, pero esa versión de Android no ofrece callbacks de
  progreso para la descarga del modelo. Mostrar una espera indefinida era
  incorrecto.
- Michi Focus consulta primero si Español está instalado o pendiente, libera el
  reconocedor cuando Android solo programa la descarga y reserva porcentaje y
  barra de progreso para descargas realmente activas.
- El estado programado ofrece `Administrar idiomas` y `Probar ahora`. En el
  Poco, la primera acción abre la actividad instalada de Servicios de voz de
  Google y muestra una descarga explícita de Español (España) de 49,31 MB.
- Once pruebas enfocadas y la suite completa de 491 pruebas pasan. El análisis
  del cambio queda limpio; el análisis global conserva únicamente el aviso
  previo del script temporal SQLite.
- El APK compiló con Java 17 y se instaló por ADB en el Poco. Instalar el paquete
  y pronunciar una frase permanecen como interacción física del usuario.

### Corrección de ajuste multilínea — 2026-09-01

- Los doce campos con micrófono de tareas, objetivos, calendario, rutinas,
  actividades de rutina, notas rápidas y búsqueda de objetivo ajustan palabras
  en vertical en lugar de desplazar el contenido horizontalmente.
- Cada campo crece de una a dos líneas visibles y conserva ese alto desde la
  segunda línea; el cursor continúa visible mediante desplazamiento vertical
  interno. Enter añade una línea y el guardado permanece en la acción explícita.
- Los mismos doce campos muestran una goma inmediatamente a la derecha del
  micrófono. La acción se desactiva cuando no hay contenido, borra todo el texto
  y actualiza también el estado del formulario o de la búsqueda correspondiente.
- El análisis completo quedó limpio, las 19 pruebas enfocadas y las 495 pruebas
  del proyecto pasaron; el APK compiló con Java 17 y se instaló y abrió en el
  Realme RMX3301 conservando los datos existentes.
- La cobertura incluye creación y edición: tarea, objetivo, rutina y sus
  actividades reutilizan los controles completos; la nota rápida usa el mismo
  editor para ambos casos. La etiqueta vacía o de una línea queda centrada
  verticalmente y solo adopta el flujo multilínea cuando el contenido lo exige.
- La revisión final pasó con análisis completo limpio, 23 pruebas enfocadas y
  las 495 pruebas del proyecto. El APK se recompiló con Java 17 y se instaló y
  abrió en el Realme RMX3301 sin eliminar los datos locales.
- Ajuste solicitado el 2026-09-03: Tareas, Rutinas y Notas recuperan su
  alineación visual previa. Se conservan micrófono, goma y ajuste de una a dos
  líneas; Objetivos mantiene la etiqueta centrada.
- La restauración pasó análisis enfocado y 20 pruebas relevantes; el APK
  compiló con Java 17 y se instaló y abrió en el Realme RMX3301 conservando los
  datos locales.
- El análisis de los seis archivos modificados quedó limpio, las referencias
  visuales de Rutinas se actualizaron y las 495 pruebas del proyecto pasaron.
- El APK de depuración compiló con Java 17 y se instaló correctamente en el
  Realme RMX3301 mediante depuración inalámbrica, conservando sus datos.
