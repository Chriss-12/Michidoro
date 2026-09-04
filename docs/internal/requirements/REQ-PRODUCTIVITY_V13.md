# REQ-PRODUCTIVITY V13 — Objetivos y notificaciones contextuales

## Resumen

Esta versión conecta el centro de notificaciones con la planificación por objetivos. Las alertas de tareas dejan de presentarse como un total genérico cuando pertenecen a un objetivo y permiten abrir directamente el objetivo y sus tareas.

## Aprobación

- Aprobado por el usuario: 2026-08-28.
- Alcance: interfaz, estado de presentación, recordatorios internos y navegación.
- Fuera de alcance: cambios de esquema de base de datos, nuevas dependencias y modificaciones nativas de Android.

## REQ-V13-001 — Notificaciones agrupadas por objetivo

**Status: Implemented**

### Requisitos

1. Una alerta de tareas asociadas a un objetivo debe mostrar el nombre del objetivo en lugar del texto genérico “Tareas pendientes”.
2. La tarjeta debe mostrar los recuentos de tareas pendientes, en progreso y completadas mediante los mismos iconos visuales usados por las tareas.
3. La hora debe permanecer alineada a la izquierda y la fecha a la derecha.
4. Las alertas de rutinas deben conservar su comportamiento actual.
5. Al tocar una alerta de objetivo, la aplicación debe abrir la sección Objetivos y revelar el objetivo correspondiente.
6. Si la alerta identifica una tarea concreta, esa tarea debe resaltarse dentro del objetivo.
7. Las tareas sin objetivo deben conservar una alternativa genérica segura.

### Criterios de aceptación

- Cada objetivo alertado genera una tarjeta independiente con sus tres recuentos.
- La navegación incluye identificadores estables, no nombres visibles.
- Un filtro previo no impide revelar el objetivo abierto desde una alerta.
- El comportamiento queda cubierto por pruebas de estado y widgets.

## REQ-V13-002 — Objetivos desplegables y creación contextual

**Status: In Progress**

### Requisitos

1. Los objetivos de la planificación deben poder desplegarse de uno en uno para mostrar sus tareas.
2. El contenido desplegado debe diferenciar tareas pendientes, en progreso y completadas.
3. Debe existir un botón “+ Crear” de ancho completo en la parte superior de la tarjeta de Objetivos, inmediatamente después de su encabezado.
4. El menú de ese botón debe contener únicamente “Nueva tarea” y “Nuevo objetivo”, reutilizando los formularios existentes.
5. La entrada desde una notificación debe seleccionar el filtro universal, desplegar el objetivo, desplazarlo a una zona visible y resaltar la tarea cuando corresponda.
6. La tarjeta independiente de agenda diaria debe retirarse junto con sus acciones duplicadas y su estado vacío.

### Criterios de aceptación

- Tocar el encabezado de un objetivo alterna su contenido sin perder las acciones existentes.
- Solo un objetivo permanece desplegado a la vez.
- El botón contextual abre los flujos existentes y no duplica lógica de guardado.
- El botón Crear pertenece visualmente a la tarjeta de Objetivos y ocupa el mismo ancho disponible que el selector del periodo.
- No aparecen la fecha de agenda, “Agenda local de planificación”, “Nueva tarea”, el menú de tres puntos ni “Sin eventos” fuera del menú Crear.
- La navegación normal a Objetivos continúa funcionando sin parámetros.

### Evidencia de implementación

- Crear se renderiza en la parte superior de `goal-period-card`, antes del selector de periodo y de la lista de objetivos.
- Su ancho coincide con el control principal del periodo y conserva Nueva tarea y Nuevo objetivo.
- Se retiraron la agenda independiente, sus tarjetas de eventos, el menú de tres puntos y el flujo duplicado de asignación rápida.
- Pasan las pruebas bilingües/en pantalla estrecha, el recorrido integral, el análisis limpio y las 472 pruebas del proyecto.

## REQ-V13-004 — Filtro de tareas por objetivo

**Status: Implemented**

### Aprobación

- Aprobado por el usuario: 2026-08-28.

### Requisitos

1. La sección Tareas debe permitir filtrar la lista por un objetivo concreto.
2. “Todos los objetivos” debe ser la selección predeterminada al iniciar la
   aplicación.
3. El filtro debe componerse con el período seleccionado y con Todas, Activas
   y Hechas.
4. “Todos los objetivos” debe conservar también las tareas sin objetivo.
5. El filtro no requiere persistencia, cambios de esquema ni sincronización.

### Criterios de aceptación

- Cada objetivo disponible aparece como una opción identificada por su ID
  estable.
- Al seleccionar un objetivo solo aparecen sus tareas dentro del período y
  estado activos.
- Los recuentos de Todas, Activas y Hechas reflejan el objetivo seleccionado.
- Una nueva instancia del controlador comienza en “Todos los objetivos”.

### Evidencia de implementación

- El controlador compone el objetivo con el período y el estado sin modificar
  la lista fuente.
- El selector usa IDs estables, muestra “Todos los objetivos” inicialmente y
  vuelve a esa selección si el objetivo activo se elimina.
- El análisis enfocado está limpio, las 23 pruebas enfocadas y la suite completa
  pasan. El análisis global conserva un aviso informativo preexistente en
  `tmp/verify_physical_database_round_trip.dart`.

## REQ-V13-003 — Ejecución diaria de tareas en su sección propia

**Status: Implemented**

### Aprobación

- Aprobado por el usuario: 2026-08-28.

### Requisitos

1. La lista de tareas seleccionada por el filtro temporal debe vivir en la sección Tareas y no repetirse en la agenda de Objetivos.
2. Cada tarjeta de Tareas debe mostrar estado, duración planificada, objetivo asociado y progreso de enfoque cuando corresponda.
3. Las acciones existentes de iniciar Pomodoro, editar y eliminar deben conservarse, y el estado debe poder cambiar entre pendiente, en progreso y completada.
4. Los filtros Todas, Activas y Hechas deben seguir componiéndose con el filtro universal de fecha.
5. Objetivos debe conservar calendario, horario semanal, notas, objetivos desplegables, eventos y navegación desde notificaciones, sin repetir una sección administrable de rutinas.
6. Las rutinas programadas pueden seguir apareciendo como bloques dentro del horario semanal, pero su estado diario y progreso deben vivir en Tareas → Rutinas.

### Criterios de aceptación

- La misma tarea no aparece simultáneamente en la lista de Tareas y en la agenda de Objetivos.
- Una tarea con duración y objetivo muestra ambos datos en Tareas.
- Una tarea con sesiones asociadas muestra minutos enfocados y porcentaje.
- La agenda de Objetivos no presenta tarjetas independientes de rutinas.
- Tareas → Rutinas muestra el estado de hoy y un progreso válido cuando existe una ejecución, sin presentar `0/0`.
- El cambio no modifica persistencia, sincronización ni rutas existentes.

### Evidencia de implementación

- Las tarjetas enriquecidas y el diálogo de planificación pertenecen ahora a `features/tasks`.
- La agenda de Objetivos conserva eventos y controles de creación, sin repetir listas de ejecución de tareas o rutinas; el horario semanal mantiene sus bloques de rutina.
- Tareas → Rutinas muestra estado diario y avance, usando el total de pasos cuando una rutina solo contiene pasos opcionales y ocultando progresos sin denominador.
- Pasan las pruebas enfocadas de Tareas y Objetivos, el recorrido integral y la suite completa de 451 pruebas.
- El análisis de los archivos modificados está limpio; el análisis global conserva una advertencia informativa preexistente en `tmp/verify_physical_database_round_trip.dart`.
