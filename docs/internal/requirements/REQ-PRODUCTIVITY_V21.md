# REQ-PRODUCTIVITY V21 — Protección de la base de datos y copias portátiles

## Decisión de producto

Michi Focus protegerá los datos en dos capas independientes. Las copias que
salen del espacio privado de Android usarán contraseña y cifrado autenticado.
La base de datos viva migrará después a un motor SQLite cifrado con una clave
aleatoria protegida por Android Keystore, únicamente cuando la migración con
retroceso haya sido probada contra bases reales existentes.

La contraseña nunca se guarda. El usuario puede conservarla en Buttercup. La
huella, PIN o patrón de Android autoriza la operación sensible, pero no sustituye
la contraseña necesaria para abrir la copia en otro dispositivo.

## REQ-V21-001 — Copia portátil cifrada

**Status: Implemented**

Implementación aprobada por el usuario el 2026-09-07.

### Criterios de aceptación

- Exportar e importar desde Ajustes exige autenticación del dispositivo.
- Exportar pide una contraseña de al menos 12 caracteres y su confirmación.
- Importar siempre pide la contraseña contenida únicamente en la memoria del
  formulario durante la operación.
- Cada archivo público usa un nombre único `michifocus-backup-<fecha>.michi`,
  no sobrescribe copias anteriores y nunca contiene un
  encabezado SQLite ni texto de tareas, objetivos, rutinas o notas en claro.
- La clave se deriva con Argon2id y una sal aleatoria por copia.
- El contenido se cifra y autentica con AES-256-GCM, nonce aleatorio y datos
  asociados versionados.
- Una contraseña incorrecta, archivo alterado o formato futuro se rechaza antes
  de crear una importación pendiente o reemplazar la base viva.
- El SQLite temporal descifrado permanece dentro del almacenamiento privado de
  la aplicación, se valida integralmente y se elimina ante cualquier fallo.
- La restauración conserva el reemplazo atómico y la recuperación de la base
  anterior ya existentes.
- La interfaz normal deja de producir o aceptar `michifocus.sqlite` público sin
  cifrar. El lector antiguo permanece solo como compatibilidad interna mientras
  se define una migración explícita.

### Evidencia de implementación

- El análisis completo de `lib` y `test` está limpio.
- Las 515 pruebas pasan, incluidos cifrado/descifrado, contraseña incorrecta,
  manipulación, ausencia de texto claro y restauración integral.
- El empaquetado Android queda pendiente: Gradle falla antes de compilar con
  `Unable to establish loopback connection` en el entorno de ejecución actual.
- La exportación e importación física se mantienen como puerta para `Verified`.

## REQ-V21-002 — Base viva cifrada con clave del dispositivo

**Status: Approved**

### Criterios de aceptación

- La base viva usa un motor SQLite cifrado mantenido y compatible con Drift.
- Cada instalación genera una clave aleatoria de 256 bits; la contraseña humana
  no se usa directamente como clave diaria de SQLite.
- Android Keystore protege la clave y exige credencial segura del dispositivo.
- La aplicación no abre datos productivos antes de desbloquear la clave.
- La migración desde SQLite en claro crea una copia recuperable, valida todas
  las tablas e índices, conmuta de forma atómica y revierte ante fallos.
- Actualización, cierre inesperado, contraseña de backup incorrecta y pérdida de
  autenticación nunca destruyen la única copia válida.
- La implementación no se marcará terminada hasta probar actualización sobre
  datos existentes y una restauración real en Realme y Poco.

## Fuera de alcance

- Sincronizar la contraseña mediante Syncthing.
- Guardar la contraseña en preferencias, SQLite, logs o archivos externos.
- Usar la contraseña de Buttercup de manera automática.
- Cifrar ajustes visuales que no contienen productividad.
