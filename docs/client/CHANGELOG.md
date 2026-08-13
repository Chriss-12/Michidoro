# Changelog

## Unreleased

### Agregado

- Vista **Rutinas** dentro de Tareas, con filtros por estado y editor guiado de
  información, días, actividades y revisión de horarios.
- Acciones para duplicar, pausar, reactivar, archivar y restaurar rutinas sin
  alterar las tareas existentes.

- Introducción de primera apertura con cuatro pantallas, progreso, retroceso,
  omisión y contenido en español o inglés.
- Planificación por calendario integrada en Objetivos.
- Objetivos por fecha con edición y eliminación.
- Tareas rápidas sin fecha desde Tasks.
- Tareas planificadas asociadas a día y opcionalmente a objetivo.
- Estados de tarea: pendiente, en progreso y completada.
- Inicio de Pomodoro desde una tarea.
- Selector de duración antes de iniciar Focus.
- Pantalla Focus con tarea y objetivo activos.
- Manejo de interrupciones: descartar, reiniciar y finalizar antes.
- Descansos cortos y largos dentro del flujo Pomodoro.
- Métricas de tareas en Home y Goals.
- Colores de avance diario/semanal en Home.
- Mapa de avance en Calendario.
- Acción **Terminar día**.
- Recordatorios locales para tareas planificadas del día mientras la app está abierta.
- Selector local de foto de perfil desde Settings.
- Reportes PDF por día, semana, mes, año y rango personalizado.
- Selección de gráficos visibles en Home para decidir qué se incluye en los reportes.
- Carpeta configurable para guardar reportes.
- Selector de carpeta para reportes, exportación e importación de backup local.
- Preferencias locales de temporizador y reportes.
- Opción protegida en Ajustes para borrar todos los datos de la base local,
  con confirmación escrita y conservación de preferencias y archivos exportados.

### Cambiado

- Objetivos ahora reúne el calendario, el listado de objetivos y la agenda de
  tareas, rutinas y eventos. Incluye filtros por todos, día, semana, mes, año y
  rango de fechas; el acceso separado de Planificación se retiró de Inicio.
- El filtro por rango ahora usa un calendario compacto dentro de la app, con
  fechas de inicio y fin visibles y el intervalo seleccionado resaltado.

- **Crear rutina** ahora abre el editor guiado en una ventana dentro de Tareas,
  con fondo desenfocado, adaptación al teclado y confirmación antes de descartar
  cambios. La edición de rutinas existentes continúa en pantalla completa.
- Corregido el regreso desde una rutina nueva con cambios sin guardar: el
  diálogo de descarte se cierra de forma segura y vuelve a la lista sin error.
- Las alertas de finalización ahora usan el motor de vibración real de Android,
  con duración e intensidad diferenciadas para Suave, Normal, Doble e Intensa.
- Home ahora usa datos reales de tareas y Pomodoros para el rendimiento.
- Goals calcula el progreso desde las tareas asociadas.
- Goals presenta el bloque **Progreso general** por filas para mejorar la lectura de objetivos y tareas.
- Calendar conserva objetivos y tareas planificadas junto con el color de avance.
- Los reportes se guardan en Descargas cuando está disponible o en la carpeta configurada.
- Los reportes ahora incluyen nombre, correo y solo los gráficos habilitados por el usuario.
- El arranque inicial ya no muestra el logo cuadrado; usa el fondo visual de la app antes de la pantalla de carga.

### Verificado

- Análisis estático sin errores.
- Suite automatizada completa aprobada.
- Documentación de usuario, instalación, técnica, guía rápida y entrega final actualizada.
