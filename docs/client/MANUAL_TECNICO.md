# Manual técnico

La app es una aplicación Flutter offline-first. Usa arquitectura limpia, organización por feature y almacenamiento local cuando corresponde.

## Componentes actuales

- Interfaz Material 3.
- Navegación local.
- Estado local de la aplicación.
- Persistencia SQLite para tareas mediante Drift.

## Persistencia de tareas

Las tareas se guardan en una base SQLite local. La capa visual usa un controlador de estado y no accede directamente a la base de datos.

Datos guardados por tarea:

- Identificador local.
- Título.
- Estado de completado.
- Fecha de creación.
- Fecha de última actualización.
