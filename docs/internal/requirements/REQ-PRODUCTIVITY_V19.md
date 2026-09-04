# REQ-PRODUCTIVITY V19 — Navegación persistente y actualización coordinada

## REQ-V19-001 — Pestañas rápidas con datos vigentes

**Status: Verified**

### Aprobación

- Aprobado explícitamente por el usuario el 2026-08-30.
- La precarga segura de Tareas, Rutinas y Notas fue aprobada explícitamente por
  el usuario el 2026-08-31 como parte de este mismo milestone de rendimiento.

### Objetivo

Evitar que cambiar entre las pestañas principales reconstruya las pantallas y
vuelva a consultar todos los datos, sin dejar información desactualizada.

### Criterios de aceptación

- Inicio, Tareas, Enfoque, Objetivos y Ajustes conservan su árbol, estado local,
  filtros y desplazamiento mientras la aplicación permanece abierta.
- Cada rama principal se crea como máximo la primera vez que se visita; cambiar
  de pestaña no ejecuta otra carga completa por sí mismo.
- Después de una autenticación correcta, Tareas, Rutinas y Notas se cargan una
  sola vez y en paralelo durante el arranque; ningún dato se consulta antes de
  superar el bloqueo del dispositivo.
- La rama visual de Tareas se precarga al entrar al shell principal para evitar
  el costo de construirla en el primer toque; las demás ramas no se precargan.
- Solicitudes directas simultáneas de Tareas o Notas comparten la carga local en
  curso, y el arranque no repite las cargas desde la configuración de
  dependencias.
- Crear, editar, completar o eliminar datos actualiza las demás vistas mediante
  los controladores y señales compartidos existentes.
- La aplicación ejecuta una sola recarga coordinada después de aplicar cambios
  sincronizados.
- Inicio, Tareas y Objetivos ofrecen deslizar hacia abajo para actualizar los
  datos de productividad; Reportes se actualiza dentro de Inicio.
- Solicitudes manuales o automáticas simultáneas comparten la misma operación en
  curso en lugar de duplicar consultas.
- La actualización conserva la pantalla visible y sus selecciones locales.
- Los enlaces de notificaciones a objetivos/tareas y las rutas públicas actuales
  mantienen su comportamiento.
- No se cambia el esquema SQLite, el formato de sincronización ni los datos.

### Verificación prevista

- Prueba de conservación de un borrador o filtro al salir y volver a Tareas.
- Prueba de una sola operación para actualizaciones simultáneas.
- Pruebas de destino contextual y navegación inferior.
- Formato, análisis completo y suite Flutter completa.

### Evidencia de implementación — 2026-08-31

- Las cinco ramas principales usan un shell indexado persistente y solo Tareas
  tiene precarga visual anticipada.
- La precarga posterior a autenticación ejecuta Rutinas, Tareas, Notas y
  preferencias del temporizador en paralelo, después de preparar la identidad y
  configuración de sincronización.
- Los controladores de Tareas y Notas deduplican solicitudes locales
  simultáneas.
- Pasaron 32 pruebas enfocadas de autenticación, navegación, Tareas y Notas.
- `flutter analyze lib test` terminó sin observaciones.
- La suite completa pasó con 482 pruebas.
- El APK de depuración compiló con Java 17, se instaló y abrió correctamente en
  el Realme RMX3301 por depuración inalámbrica.
- La primera entrada a Tareas mostró los datos sin otra carga visible; Rutinas y
  Notas también estaban listas, el gesto de actualización terminó sin error y
  la selección Notas se conservó al salir y volver.
- El análisis sin alcance encontró únicamente una observación preexistente en
  `tmp/verify_physical_database_round_trip.dart`, fuera del código de la app y
  de sus pruebas.
