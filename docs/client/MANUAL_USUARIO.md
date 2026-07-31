# Manual de usuario

MichiFocus es una app Pomodoro offline-first para planificar objetivos, organizar tareas, trabajar con foco y revisar el avance sin depender de internet.

## Inicio

La pantalla **Home** resume el estado del día y del mes:

- tareas pendientes, en progreso y completadas;
- rendimiento del mes actual;
- historial semanal;
- progreso diario y semanal por colores;
- acceso a planificación y exportación de reportes.

## Planificación

Desde **Home > Planificación** podés:

- elegir una fecha en el calendario;
- crear objetivos para el día seleccionado;
- renombrar o eliminar objetivos;
- crear tareas planificadas con fecha;
- asignar tareas a un objetivo;
- mover tareas rápidas a una fecha;
- cambiar el estado de las tareas;
- eliminar tareas desde la planificación.

Las tareas creadas desde planificación siempre quedan asociadas a la fecha seleccionada.

## Tareas

La sección **Tasks** permite crear tareas rápidas sin fecha. También podés:

- editar el título;
- marcar una tarea como pendiente, en progreso o completada;
- asignarla luego a una fecha;
- asociarla o separarla de un objetivo;
- eliminarla.

No se pueden guardar tareas sin título.

## Focus

Cada tarea puede iniciar un Pomodoro con **Empezar Pomodoro**. La acción
**Iniciar/Continuar tarea** divide el tiempo pendiente en bloques de enfoque y
descanso, acorta el último bloque para no exceder los minutos planificados y
continúa automáticamente hasta completar la tarea.

También se puede ejecutar un único Pomodoro predefinido. La opción recomendada
minimiza tiempo extra de descanso y evita un último bloque demasiado corto. En
**Personalizado** se eligen minutos de enfoque y descanso y se decide entre
**Solo este Pomodoro** o **Usar para todo el plan**.

El anillo representa una sola vuelta sobre el avance total de la tarea y dentro
solo muestra la cuenta regresiva y el modo actual. El botón de información
debajo del anillo abre el bloque, porcentaje, siguiente descanso y tiempo de
reloj aproximado. Al salir de la app, el estado se guarda y el tiempo
transcurrido se reconcilia al volver.

Durante la sesión podés:

- pausar o continuar;
- descartar una sesión interrumpida;
- reiniciar desde cero;
- terminar antes y guardar solo el tiempo realmente enfocado;
- completar la tarea activa;
- pasar por descansos cortos o largos.

## Objetivos

La sección **Goals** muestra:

- total de objetivos;
- progreso general organizado por filas para leer cada métrica con claridad;
- progreso de cada objetivo según sus tareas;
- tareas pendientes, en progreso y completadas;
- resumen de tareas sin objetivo.

## Calendario

El calendario muestra objetivos y tareas planificadas. Los días usan colores según el porcentaje de tareas completadas:

- rojo: sin tareas o hasta 20%;
- amarillo: hasta 50%;
- verde: hasta 70%;
- verde fuerte: hasta 100%.

Desde Home se puede usar **Terminar día** para confirmar el avance del día.

## Reportes PDF

En **Home > Descargar estadísticas** podés exportar reportes por:

- día;
- semana;
- mes;
- año;
- rango personalizado.

El PDF incluye nombre de usuario, correo electrónico, calendario, tareas por estado, Pomodoros completados, minutos enfocados y una frase de avance.

Los gráficos que se oculten en **Home > Rendimiento** también se excluyen del reporte. Esto permite preparar un PDF más limpio, mostrando solo los indicadores que se quieren compartir.

## Carpeta de reportes

En **Settings > Reportes** podés seleccionar dónde guardar los PDF. Si no configurás una carpeta, la app usa **Descargas** cuando el sistema lo permite. Si la carpeta configurada no está disponible, la app usa una ubicación local segura como respaldo.

Desde la misma sección podés exportar un único archivo `michifocus.sqlite` con
toda la base de datos e importar una copia previa. La app valida y migra la
copia antes de aplicarla en el siguiente inicio. Las preferencias visuales y
del temporizador no se agregan como un archivo JSON separado al backup.

## Configuración

En **Settings** podés ajustar:

- nombre, correo y foto de perfil local;
- duración de enfoque;
- descanso corto;
- descanso largo;
- tema visual;
- tamaño de texto;
- carpeta de reportes;
- alertas y preferencias locales disponibles.

Cuando la app está abierta, las tareas planificadas para el día pueden generar un recordatorio local con el tono seleccionado. Las notificaciones se acumulan en la parte superior derecha y, al abrirlas, llevan al calendario para revisar la planificación.

Toda la información se mantiene localmente en el dispositivo.
