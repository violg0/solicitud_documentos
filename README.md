# Solicitud de documentos académicos

Aplicación móvil (Flutter) para que los estudiantes soliciten documentos
académicos y el personal de la institución los revise, apruebe y entregue.

| | |
|---|---|
| **Curso** | Desarrollo Móvil, G61-7 |
| **Integrantes** | Lenin Ospina Lamprea · Violeta Agudelo Carmona |
| **Versión** | 1.1.1+3 |
| **Plataforma probada** | Android (emulador, API 37) |

## Caso de uso

Un estudiante entra al catálogo de documentos (certificado de notas,
constancia de matrícula, paz y salvo, etc.), elige uno, indica el período
académico y envía la solicitud. La solicitud recorre un flujo de estados
(`solicitada → enRevision → aprobada → entregada`) en el que intervienen un
**revisor** y la **secretaria**. Cada cambio de estado queda registrado con un
mensaje (historial de motivos).

La app funciona **offline-first**: la solicitud se guarda primero en el
dispositivo y se sincroniza con la nube cuando hay conexión.

## Roles

Cualquier persona que se registre desde la app queda como **estudiante**. Los
roles `revisor` y `secretaria` solo se asignan a mano (ver
[Cómo asignar un rol](#cómo-asignar-un-rol-revisor-o-secretaria)).

| Rol | Qué puede hacer en la app |
|---|---|
| **estudiante** | Ver el catálogo, crear solicitudes de documentos habilitados (eligiendo período) y ver **sus** solicitudes en "Mis solicitudes", donde puede filtrarlas por estado y ver cuáles siguen pendientes de sincronizar. Al tocar una abre su **detalle** (todos los campos e historial); mientras esté `solicitada` puede cancelarla desde ahí (la app pide un motivo). |
| **revisor** | Abrir la **Bandeja** (todas las solicitudes agrupadas por estado), pasar `solicitada → enRevision` y decidir `enRevision → aprobada` o `rechazada`, con un mensaje en cada cambio. |
| **secretaria** | Abrir la **Bandeja** y marcar `aprobada → entregada`. |

## Cómo correr el proyecto

### Requisitos

- Flutter estable con Dart `^3.13.0` (desarrollado con Flutter 3.47.0).
- Android Studio / SDK de Android y un emulador o dispositivo.
- Conexión a internet (Firebase y mockapi).

### Pasos

```bash
flutter pub get
flutter run
```

El código generado de Drift (`lib/local/app_database.g.dart`) ya está incluido
en el repositorio. Solo si cambias las tablas de `lib/local/` hay que
regenerarlo: `dart run build_runner build --delete-conflicting-outputs`.

### Configuración de Firebase

El proyecto Firebase es **`solicitudes-documentos`**. La configuración ya viene
en el repositorio, así que no hace falta ninguna variable de entorno:

- `android/app/google-services.json`
- `lib/firebase_options.dart` (generado con FlutterFire CLI para android, ios,
  web y windows)

Servicios de Firebase que usa la app:

| Servicio | Uso |
|---|---|
| Authentication (correo y contraseña) | Registro e inicio de sesión |
| Cloud Firestore | Colecciones `Usuarios`, `Solicitudes` y `Motivos` |
| Crashlytics | Reporte de errores |

**Para usar tu propio proyecto de Firebase:** crea el proyecto, activa
Authentication con correo/contraseña y Firestore, y ejecuta
`flutterfire configure` para regenerar `firebase_options.dart` y
`google-services.json`.

### Reglas de seguridad de Firestore

Las reglas están en [`firestore.rules`](firestore.rules) y se despliegan con:

```bash
firebase deploy --only firestore:rules --project solicitudes-documentos
```

Se verifican con una suite automatizada contra el emulador local de Firestore
(125 casos) que **no** toca datos reales:

```bash
cd firestore-tests
npm install
npm test
```

Detalles en [`firestore-tests/README.md`](firestore-tests/README.md).

### Cómo asignar un rol (revisor o secretaria)

1. Registra la cuenta desde la app (queda como `estudiante`).
2. En la consola de Firebase abre **Firestore Database → `Usuarios` →** el
   documento cuyo id es el uid de esa cuenta.
3. Cambia el campo `rol` a `revisor` o `secretaria`.
4. Cierra sesión e ingresa de nuevo en la app.

Las reglas de Firestore impiden que la app (o cualquier cliente) se asigne
esos roles por sí sola.

### Emulador Android sin resolver DNS

Si en el emulador el catálogo no carga con errores de "Unable to resolve host",
ábrelo con DNS de Google usando `scripts/emulador.ps1` (PowerShell).

## Endpoint HTTP (mockapi)

El catálogo de documentos **no** está en Firestore: se obtiene de una API REST
de [mockapi.io](https://mockapi.io):

```
GET https://6aee1a6ca677fe0fc14fc05f.mockapi.io/documentos
```

- Devuelve un arreglo JSON con `id`, `nombre`, `descripcion` y `habilitado`
  (el campo `imagen` es opcional; si falta, la app usa cadena vacía).
- Es solo de lectura y no lleva datos del usuario ni autenticación.
- Timeout de 10 s. La app traduce el código HTTP: `404` → "No se encontró el
  catálogo", `500` → "Server does not exist", sin red → "No hay conexión a
  internet".
- Si la petición falla, el catálogo se sirve desde la copia local (SQLite). Si
  falla y no hay copia, se muestra el error con el botón "Reintentar".
- `habilitado: false` marca documentos que no se pueden solicitar (aparecen en
  gris con "No disponible").

Implementación: `lib/service/api/documento_service.dart`.

## Modelo de datos

Los nombres corresponden a las clases de `lib/models/`.

### Usuario — Firestore `Usuarios/{uid}`

| Campo | Tipo | Notas |
|---|---|---|
| `uid` | String | Es el id del documento (no se guarda como campo) |
| `nombre` | String | |
| `email` | String | |
| `rol` | `estudiante` \| `revisor` \| `secretaria` | El autorregistro siempre guarda `estudiante` |

### Documento — mockapi y caché local

| Campo | Tipo | Notas |
|---|---|---|
| `id` | String | |
| `nombre`, `descripcion` | String | |
| `imagen` | String | Opcional en la API; vacío si no viene |
| `habilitado` | bool | Solo se pueden solicitar los habilitados |

### Solicitud — Firestore `Solicitudes/{id}` y SQLite

| Campo | Tipo | Notas |
|---|---|---|
| `id` | String | UUID v4 generado en el dispositivo |
| `idDocumento` | String | Id del documento en mockapi |
| `idUsuario` | String | uid del estudiante dueño |
| `periodo` | String | Uno de `2025-1`, `2025-2`, `2026-1`, `2026-2` |
| `observacionEstudiante` | String | Texto opcional que escribe el estudiante al crearla (vacío si no escribe nada) |
| `estado` | `EstadoSolicitud` | Ver abajo |
| `fechaCreacion` | DateTime (UTC) | Se fija al crearla en el dispositivo |
| `fechaModificacion` | DateTime (UTC) | Se actualiza en cada cambio de estado |
| `observacionRevision` | String? | Mensaje del revisor al aprobar o rechazar (si lo escribe); `null` mientras tanto |
| `fechaEntrega` | DateTime? (UTC) | La escribe la secretaria al entregar; `null` antes |
| `entregadoPor` | String? | uid de la secretaria que entregó; `null` antes |

**Fechas.** Todas se guardan y se envían en **UTC** (cadenas ISO 8601 con `Z`
al final) y se muestran en la hora del dispositivo. Comparar local contra
Firestore para decidir qué copia se muestra no depende de la zona horaria.

`observacionRevision`, `fechaEntrega` y `entregadoPor` **sí se suben a
Firestore** (en la misma escritura que cambia el estado) y las reglas solo los
aceptan en su transición: la observación al aprobar/rechazar; la fecha y el uid
al entregar (y el uid debe ser el de quien escribe).

### Motivo — Firestore `Motivos/{id}` y SQLite

| Campo | Tipo | Notas |
|---|---|---|
| `id` | String | UUID v4 generado en el dispositivo; es el mismo en SQLite y en Firestore |
| `idSolicitud` | String | |
| `mensaje` | String | Texto escrito por quien cambia el estado |
| `estado` | `EstadoSolicitud` | Estado al que pasó la solicitud |
| `fechaCreacion` | DateTime | |

### Estados y transiciones

Definidos en `lib/models/estados.dart` y validados en
`lib/validators/solicitud_validators.dart`:

```
solicitada ──(revisor)──────► enRevision ──(revisor)──► aprobada ──(secretaria)──► entregada
    │                              │
    │(estudiante dueño)            └──(revisor)──► rechazada
    ▼
cancelada
```

| Desde | Hacia | Quién |
|---|---|---|
| `solicitada` | `cancelada` | estudiante dueño de la solicitud |
| `solicitada` | `enRevision` | revisor |
| `enRevision` | `aprobada` | revisor |
| `enRevision` | `rechazada` | revisor |
| `aprobada` | `entregada` | secretaria |

`rechazada`, `entregada` y `cancelada` son estados finales. Cualquier otra
transición se rechaza con "El cambio de estado no está permitido".

### Reglas de negocio principales

- Solo se puede solicitar un documento con `habilitado = true`.
- El período debe ser uno de los cuatro permitidos.
- Toda solicitud nace en estado `solicitada`.
- Un estudiante solo ve y toca sus propias solicitudes; revisor y secretaria
  ven todas.
- Cada cambio de estado pide un mensaje y crea un `Motivo` (el historial). La
  app acepta el mensaje vacío: no lo valida.

### Dónde se aplican las reglas

Las reglas anteriores se validan **en la app** (`SolicitudValidators`) y
además el servidor aplica las suyas en `firestore.rules`:

- `Usuarios`: cada usuario crea solo su perfil y únicamente con rol
  `estudiante`; solo lee el suyo; sin ediciones posteriores.
- `Documentos`: lectura para autenticados, sin escritura desde el cliente.
- `Solicitudes`: el estudiante crea y lee solo las suyas (en `solicitada`);
  puede cancelar la suya (`solicitada → cancelada`) pero ningún otro cambio de
  estado; revisor y secretaria leen todas y modifican solo `estado`,
  `fechaModificacion` y los campos propios de cada transición
  (`observacionRevision` al aprobar/rechazar; `fechaEntrega` y `entregadoPor`
  al entregar), y **el servidor exige la misma máquina de estados de la
  tabla de arriba**: cada transición solo la puede hacer su rol, y
  `entregada`, `rechazada` y `cancelada` son finales (no se puede entregar dos
  veces ni reabrir una solicitud cerrada, aunque la pantalla esté
  desactualizada); nadie borra.
- `Motivos`: los crean revisor y secretaria, y el estudiante únicamente el de
  la cancelación de su solicitud; leen el dueño de la solicitud, el revisor y la
  secretaria; sin edición ni borrado.

## Guardado offline-first

Pensado para que un estudiante pueda enviar una solicitud sin conexión.

1. **Validar.** `SolicitudRepository.crearSolicitud` comprueba que el documento
   esté habilitado y que el período sea válido.
2. **Guardar primero en local.** La solicitud se escribe en SQLite (Drift,
   archivo `solicitudes.sqlite`) con `pendingSync = true`. La pantalla confirma
   en cuanto termina este paso; no espera a la red.
3. **Sincronizar en segundo plano.** Sin bloquear la interfaz, se llama a
   `syncPending()`: por cada solicitud pendiente se consulta su documento y se
   escribe en Firestore (`Solicitudes/{uuid}`) con un timeout de 10 s.
4. **Confirmar.** Cuando Firestore responde bien se marca `pendingSync = false`.
   Si falla (sin red, timeout), la solicitud sigue pendiente y no se pierde.
5. **Reintentar.** Cada vez que se abre **"Mis solicitudes"** se vuelve a
   ejecutar `syncPending()` con las que sigan pendientes. Un candado interno
   evita dos sincronizaciones simultáneas.

Como el id es un UUID generado en el dispositivo, reintentar la misma solicitud
no crea duplicados.

**Lectura.** Al listar solicitudes se intenta Firestore y se refresca la copia
local; si falla, se muestra lo último guardado en SQLite. Lo mismo ocurre con el
catálogo y con los motivos (historial).

## Limitaciones conocidas

1. **Documento borrado de mockapi con solicitud pendiente.** Para sincronizar,
   la app vuelve a consultar el documento. Si la API responde bien pero el
   documento ya no existe, la solicitud se omite en silencio
   (`if (documento == null) continue;`): queda con `pendingSync = true` para
   siempre, se reintenta en cada apertura de "Mis solicitudes" y nunca se avisa
   al usuario ni se sube.
2. **La sincronización de pendientes solo se reintenta al abrir "Mis
   solicitudes".** Una solicitud guardada sin conexión aparece en la lista con
   el aviso "Pendiente de sincronizar" (reloj naranja) y sube sola la próxima
   vez que se abre esa pantalla con red; no hay un reintento periódico en
   segundo plano.
3. **El cambio de estado necesita conexión.** `cambiarEstado` escribe directo en
   Firestore; sin red falla a los 10 s con un mensaje de error (la escritura
   puede quedar encolada por el propio SDK de Firestore). Cuando sí se aplica,
   la copia local se actualiza al instante.
4. **Cancelar una solicitud que aún no se sincronizó no se puede.** Si el
   estudiante pulsa "Cancelar solicitud" en el detalle de una solicitud
   pendiente (todavía no existe en Firestore), la app avisa que aún no se
   sincronizó y que lo intente de nuevo. Funciona cuando ya subió.
5. **Los motivos no se reintentan.** Se guardan primero en SQLite y luego se
   suben a Firestore; si la subida falla, no hay reintento: la columna
   `pendingSync` de motivos y documentos existe pero nada la lee.
6. **Sin recuperación de contraseña ni verificación de correo.**
7. **El APK `release` se firma con la llave de debug** (configuración por
   defecto del proyecto en `android/app/build.gradle.kts`); sirve para la
   entrega y pruebas, no para publicar en una tienda.
8. **El catálogo depende de un servicio de terceros** (mockapi.io, plan gratuito)
   sin autenticación ni garantía de disponibilidad.
9. **Pruebas automáticas limitadas.** Hay 125 pruebas de las reglas de Firestore
   (`firestore-tests/`) y 6 pruebas de Dart (`flutter test`: aislamiento de
   Drift por cuenta y fechas en UTC); la verificación de la interfaz es manual
   (ver [`QA.md`](QA.md)).
10. **Código sin usar:** `lib/service/firebase/documento_service.dart` (la app
    lee el catálogo de mockapi, no de Firestore).
11. **Una solicitud sin sincronizar sobrevive al cierre de sesión.** Al cerrar
    sesión la app intenta subir lo pendiente (hasta 8 s) y borra la copia
    local; lo que no logró subir se conserva para no perderlo, aislado por
    cuenta: solo su dueño lo ve y lo sube al volver a entrar.
12. **El menú "QA" de Crashlytics está también en el APK release** (ícono de
    tres puntos de la barra superior: "Log non-fatal" y "Force fatal crash")
    para poder generar la evidencia con el APK entregado; en una app real se
    quitaría.

## Privacidad: datos que se recolectan

| Dato | Para qué | Dónde se guarda |
|---|---|---|
| Correo y contraseña | Crear la cuenta e iniciar sesión | Firebase Authentication. La contraseña la gestiona Firebase; la app no la almacena |
| Nombre, correo, rol y uid | Identificar al usuario y decidir qué puede hacer | Firestore (`Usuarios`) |
| Solicitudes: documento, período, observaciones, estado, fechas y uid del dueño, y uid de quien entrega | Gestionar el trámite | Firestore (`Solicitudes`) y copia en SQLite del dispositivo |
| Mensajes de cambio de estado | Historial de cada solicitud | Firestore (`Motivos`) y SQLite |
| Informes de fallos (Crashlytics): traza del error, datos técnicos del dispositivo y el uid del usuario | Detectar y corregir errores | Firebase Crashlytics |
| Filtro de solicitudes elegido | Recordar una preferencia | `SharedPreferences` (solo en el dispositivo) |

- El acceso a Firestore está limitado por las reglas de seguridad: cada
  estudiante lee únicamente sus solicitudes.
- La app **no** pide ubicación, contactos, cámara ni micrófono, y no incluye
  publicidad ni analítica de comportamiento.
- La consulta al catálogo (mockapi) no envía ningún dato del usuario.
- Cada cuenta solo ve su copia local: las consultas a SQLite filtran por el uid
  del usuario. Al cerrar sesión se borra la copia local de solicitudes ya
  sincronizadas y todos los motivos del dispositivo (ver limitación 11 para las
  pendientes).

## Estructura del proyecto

```
lib/
  main.dart            Arranque, inyección de dependencias
  models/              Usuario, Documento, Solicitud, Motivo, estados, roles
  validators/          Reglas de negocio de solicitudes
  repository/          Lógica offline-first (local + remoto)
  local/               SQLite con Drift (tablas y data sources)
  service/api/         Cliente HTTP de mockapi
  service/firebase/    Auth, Firestore y Crashlytics
  views/               Pantallas (login, catálogo, solicitudes, bandeja)
firestore.rules        Reglas de seguridad de Firestore
firestore-tests/       Pruebas de las reglas con el emulador
QA.md                  Matriz de pruebas manuales de la interfaz
```
