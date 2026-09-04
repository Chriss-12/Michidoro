# REQ-PRODUCTIVITY V15 — Asignación de objetivo al crear tareas

## REQ-V15-001 — Selector buscable de objetivo

**Status: Implemented**

### Aprobación

- Aprobado explícitamente por el usuario el 2026-08-30.

### Objetivo

Permitir que una tarea creada desde Tareas quede asociada desde el inicio a
un objetivo actual o futuro, sin recorrer manualmente listas largas.

### Alcance

- El formulario de nueva tarea muestra un selector de objetivo debajo del
  título.
- El valor inicial es “Sin objetivo”.
- Solo se ofrecen objetivos con fecha igual o posterior al día local actual.
- Los objetivos sin fecha y los objetivos de días anteriores no se ofrecen.
- El selector permite buscar por título mediante teclado o dictado local.
- Al elegir un objetivo, la tarea hereda su fecha y se guarda con su identificador.
- “Sin objetivo” conserva la creación de una tarea rápida sin fecha.

### Fuera de alcance

- Crear o editar objetivos desde el selector.
- Interpretar por voz qué objetivo quiso seleccionar el usuario.
- Cambiar los selectores de objetivos de otros formularios en esta entrega.
- Cambiar esquema, sincronización o formato de respaldo.

### Criterios de aceptación

- El selector ocupa el ancho disponible y comunica claramente la selección.
- “Sin objetivo” está seleccionado por defecto y puede recuperarse después de
  elegir otro objetivo.
- Un objetivo de ayer no aparece; uno de hoy y uno futuro sí aparecen.
- La búsqueda reduce la lista sin distinguir mayúsculas ni tildes comunes.
- El campo de búsqueda tiene el micrófono compartido y actualiza los resultados
  con el texto dictado editable.
- Guardar con objetivo crea una tarea planificada en la fecha del objetivo.
- Guardar sin objetivo conserva el comportamiento actual de tarea rápida.
- El selector sigue siendo usable con listas vacías, pantalla estrecha y teclado.

### Verificación prevista

- Pruebas del filtro de objetivos por fecha.
- Prueba de widget para búsqueda, descarte de objetivos pasados, selección,
  creación planificada y retorno a “Sin objetivo”.
- Formato, análisis, pruebas enfocadas, suite completa, APK e instalación física.

### Evidencia de implementación

- El 2026-08-30 pasaron las pruebas enfocadas del controlador y la vista.
- La suite completa pasó con 467 pruebas.
- El análisis enfocado no reportó problemas; el análisis global conserva un
  aviso preexistente en `tmp/verify_physical_database_round_trip.dart`.
- El APK de depuración compiló con Java 17, se instaló y se abrió en el Realme
  RMX3301 mediante depuración inalámbrica.
- Queda pendiente la inspección visual y una frase dictada por el usuario antes
  de promover el requisito a `Verified`.

## REQ-V15-002 — Duración al crear la tarea

**Status: Implemented**

### Aprobación

- Aprobado explícitamente por el usuario el 2026-08-30.

### Objetivo

Permitir que la duración estimada quede definida al crear una tarea, con una
selección rápida y consistente con la planificación existente.

### Alcance

- El formulario de nueva tarea muestra la duración debajo del objetivo.
- El valor inicial es 25 minutos.
- Las opciones disponibles son 25, 30, 45, 60, 90 y 120 minutos.
- La duración elegida se guarda tanto con “Sin objetivo” como con un objetivo.
- Después de crear una tarea, el formulario vuelve a 25 minutos.

### Fuera de alcance

- Introducir una duración libre o dictarla por voz.
- Cambiar el esquema de SQLite o el formato de sincronización.
- Alterar la fecha o el objetivo según la duración.

### Criterios de aceptación

- La opción de 25 minutos aparece seleccionada al abrir el formulario.
- Solo una duración puede estar seleccionada a la vez.
- Las seis opciones caben mediante ajuste de línea en una pantalla estrecha.
- La tarea creada conserva exactamente la duración elegida.
- Una tarea sin objetivo permanece sin fecha y guarda su duración.
- Una tarea con objetivo conserva su objetivo, fecha y duración.

### Evidencia de implementación

- El selector adaptable muestra 25, 30, 45, 60, 90 y 120 minutos y vuelve a
  25 después de una creación correcta.
- Las pruebas confirman la creación con objetivo a 60 minutos y sin objetivo a
  90 minutos, además de la persistencia de una tarea rápida a 25 minutos.
- El análisis enfocado está limpio y las 467 pruebas del proyecto pasan.
- Build Runner, el APK de depuración con Java 17 y la instalación/apertura por
  ADB inalámbrico en el Realme RMX3301 finalizaron correctamente.
- La inspección visual física queda pendiente antes de promover a `Verified`.
