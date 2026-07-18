# Manual técnico

MichiFocus es una aplicación Flutter offline-first. La app guarda la información localmente y no requiere backend para las funciones entregadas.

## Plataforma y tecnologías

| Área | Implementación |
|---|---|
| Aplicación | Flutter / Dart |
| Interfaz | Material 3 |
| Navegación | Navegación local por pestañas y rutas internas |
| Estado | Controladores locales reactivos |
| Persistencia | SQLite local mediante Drift y archivo JSON para preferencias |
| Reportes | Generación local de PDF |

## Módulos principales

| Módulo | Función |
|---|---|
| Home | Resumen diario, semanal y mensual; acceso a planificación y reportes |
| Tasks | Tareas rápidas y planificadas, estados y asignación a objetivos |
| Goals | Objetivos y avance por tareas |
| Calendar | Planificación por fecha y mapa de avance |
| Focus | Temporizador Pomodoro, descansos y manejo de interrupciones |
| Settings | Preferencias de tiempo, apariencia, alertas y carpeta de reportes |

## Datos locales

La app guarda localmente:

- tareas;
- objetivos;
- eventos de calendario;
- sesiones Pomodoro completadas;
- preferencias de temporizador;
- carpeta de exportación de reportes.

## Reportes

Los reportes PDF se generan en el dispositivo. La ruta de salida se resuelve así:

1. Carpeta configurada en **Settings > Reportes**.
2. Carpeta **Descargas** del sistema, cuando está disponible.
3. Ubicación local segura de la aplicación como respaldo.

## Validación

La entrega fue verificada con:

- análisis estático de Flutter sin errores;
- pruebas automatizadas completas;
- pruebas enfocadas de configuración, tareas, Pomodoro y vista principal.

## Consideraciones

En Android moderno, el acceso directo a carpetas públicas puede depender de permisos y políticas de almacenamiento del dispositivo. Si Descargas no está disponible, la app usa una ubicación local alternativa para no perder el reporte.
