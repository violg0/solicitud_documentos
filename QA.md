# Matriz de QA — pruebas manuales de la interfaz

App: **Solicitud de documentos académicos** · versión **1.1.1+3**
Las reglas de seguridad de Firestore se prueban aparte, de forma automática
(ver [`firestore-tests/`](firestore-tests/README.md)).

Rellena la columna **Resultado** con `OK`, `FALLA` o `N/A` y, si falla, una
nota breve.

## Preparación

| Elemento | Detalle |
|---|---|
| Dispositivo | Emulador o teléfono Android con la APK de esta versión |
| Cuenta **estudiante A** | Registrada desde la app (`estudiante.a@prueba.co`) |
| Cuenta **estudiante B** | Registrada desde la app (`estudiante.b@prueba.co`) |
| Cuenta **revisor** | Registrar y luego cambiar `rol` a `revisor` en Firestore → `Usuarios/{uid}` |
| Cuenta **secretaria** | Registrar y luego cambiar `rol` a `secretaria` de la misma forma |
| Catálogo | La API de mockapi devuelve 8 documentos; "Carta de recomendación" viene con `habilitado: false` |
| Sin conexión | Activar el modo avión en el dispositivo o emulador |

Tras cambiar un rol hay que cerrar sesión y volver a ingresar.

## Casos de prueba

### Registro

| ID | Caso | Pasos | Resultado esperado | Resultado |
|---|---|---|---|---|
| QA-01 | Registro exitoso (siempre como estudiante) | 1. En el login, tocar "Crear una cuenta".<br>2. Verificar que **no** hay selector de rol.<br>3. Escribir nombre, un correo nuevo y una contraseña de 6 o más caracteres.<br>4. Tocar "Registrarme". | La pantalla se cierra y se ve el Catálogo con la sesión iniciada. En la barra superior aparece el ícono "Mis solicitudes" (no el de Bandeja). En Firestore, `Usuarios/{uid}` tiene `rol: estudiante`. | |
| QA-02 | Registro con correo ya existente | Registrar un correo que ya tiene cuenta (p. ej. el de estudiante A). | Se queda en la pantalla y muestra "Ya existe una cuenta con este correo". | |
| QA-03 | Registro con datos inválidos | 1. Dejar el nombre vacío, o poner una contraseña de menos de 6 caracteres.<br>2. Tocar "Registrarme". | Muestra "Nombre obligatorio y contraseña de mínimo 6 caracteres". No se crea la cuenta. | |
| QA-04 | Registro con correo mal escrito | Poner `correo-sin-arroba` como correo, con nombre y contraseña válidos, y tocar "Registrarme". | Muestra "El correo no tiene un formato válido". | |

### Inicio de sesión

| ID | Caso | Pasos | Resultado esperado | Resultado |
|---|---|---|---|---|
| QA-05 | Login con credenciales correctas | Ingresar correo y contraseña de estudiante A y tocar "Ingresar". | Pasa al Catálogo. | |
| QA-06 | Login con contraseña incorrecta | Correo de estudiante A con una contraseña errada. | Muestra "Correo o contraseña incorrectos" (o "La contraseña es incorrecta" si el proyecto no tiene activada la protección contra enumeración de correos). No inicia sesión. | |
| QA-07 | Login con correo inexistente | Un correo que nunca se registró, con cualquier contraseña. | Muestra "Correo o contraseña incorrectos" (o "No existe una cuenta con este correo"). | |
| QA-08 | Login sin internet | Activar el modo avión, ingresar correo y contraseña válidos y tocar "Ingresar". | Muestra "Sin conexión o error inesperado. Intenta de nuevo". El botón vuelve a quedar activo. | |
| QA-09 | Sesión persistente y cierre de sesión | 1. Iniciar sesión y cerrar la app por completo.<br>2. Abrirla de nuevo.<br>3. Tocar el ícono "Cerrar sesión". | Al reabrir entra directo al Catálogo sin pedir credenciales. Al cerrar sesión vuelve a "Iniciar sesión". | |

### Catálogo

| ID | Caso | Pasos | Resultado esperado | Resultado |
|---|---|---|---|---|
| QA-10 | Catálogo con internet | Iniciar sesión con conexión. | Muestra los 8 documentos. "Carta de recomendación" aparece en gris con la etiqueta "No disponible". | |
| QA-11 | Documento no habilitado | Tocar "Carta de recomendación". | No pasa nada: no abre la pantalla de crear solicitud. | |
| QA-12 | Catálogo con caché sin conexión | 1. Abrir el catálogo con internet al menos una vez.<br>2. Cerrar la app y activar el modo avión.<br>3. Abrir la app. | Se muestra la misma lista de documentos (desde la copia local), sin error. | |
| QA-13 | Catálogo sin conexión y sin caché | Requiere sesión iniciada con la base local vacía, solo reproducible con la APK de **debug**:<br>1. Iniciar sesión con internet y cerrar la app.<br>2. Activar el modo avión.<br>3. Borrar la base local: `adb shell run-as com.example.solicitud_documentos sh -c "rm -f app_flutter/solicitudes.sqlite*"`.<br>4. Abrir la app y entrar al catálogo. | Muestra "Error: …" con el botón "Reintentar" (no "No hay documentos disponibles"). Al desactivar el modo avión y tocar "Reintentar", aparece la lista. | |

### Crear solicitud (estudiante)

| ID | Caso | Pasos | Resultado esperado | Resultado |
|---|---|---|---|---|
| QA-14 | Crear solicitud con internet | 1. Como estudiante A, tocar "Certificado de notas".<br>2. Elegir un período académico.<br>3. Tocar "Enviar solicitud".<br>4. Abrir "Mis solicitudes". | Vuelve al catálogo. La lista muestra "Período …" con estado `solicitada`. En Firestore aparece un documento en `Solicitudes` con el `idUsuario` de estudiante A y estado `solicitada`. | |
| QA-15 | Crear solicitud sin elegir período | Abrir un documento habilitado y tocar "Enviar solicitud" sin elegir período. | Muestra el aviso "Debes seleccionar el periodo académico" y no envía nada. | |
| QA-16 | Crear solicitud sin internet | 1. Activar el modo avión.<br>2. Crear una solicitud de "Paz y salvo" con un período.<br>3. Desactivar el modo avión.<br>4. Abrir "Mis solicitudes" (esto dispara la sincronización); si hace falta, salir y volver a entrar. | Con el avión activo la pantalla se cierra normalmente: la solicitud se guardó en el dispositivo y no se pierde. Al recuperar la red y abrir "Mis solicitudes", se sincroniza: el documento aparece en `Solicitudes` de Firestore (una sola vez, sin duplicados) y en la lista. Mientras está sin sincronizar puede no verse en la lista (ver limitación 2 del README). | |

### Mis solicitudes (estudiante)

| ID | Caso | Pasos | Resultado esperado | Resultado |
|---|---|---|---|---|
| QA-17 | Solo se ven las solicitudes propias | 1. Con estudiante A, crear una solicitud.<br>2. Cerrar sesión e ingresar como estudiante B.<br>3. Crear una solicitud de otro documento.<br>4. Abrir "Mis solicitudes" con B y luego con A. | Cada estudiante ve únicamente las suyas. | |
| QA-18 | Lista vacía | Con una cuenta recién registrada, abrir "Mis solicitudes". | Muestra "No tienes solicitudes". | |
| QA-19 | Filtro de "Mis solicitudes" | 1. Con estudiante A, que tenga solicitudes en distintos estados (p. ej. tras QA-14 y QA-23), abrir "Mis solicitudes".<br>2. Revisar la fila de chips que hay arriba de la lista.<br>3. Tocar el chip `aprobada` y luego "Todas".<br>4. Elegir un estado, salir de la pantalla y volver a entrar. | Arriba de la lista hay chips con "Todas", `solicitada`, `enRevision`, `aprobada`, `rechazada`, `entregada` y `cancelada`, con uno seleccionado. Al elegir un estado solo se listan las solicitudes en ese estado (si no hay ninguna: "No tienes solicitudes"); "Todas" las muestra todas. El filtro elegido se recuerda al volver a abrir la pantalla. | |
| QA-20 | Cancelar como estudiante | 1. Con una solicitud propia en estado `solicitada`, tocar su fila en "Mis solicitudes".<br>2. Comprobar el diálogo "¿Cancelar esta solicitud?" con el campo "Motivo".<br>3. Tocar "Volver" y comprobar que nada cambia.<br>4. Volver a tocar la fila, escribir un motivo y tocar "Confirmar".<br>5. Tocar una fila cuyo estado no sea `solicitada`. | Con "Volver" no cambia el estado ni se crea ningún motivo. Con "Confirmar" la lista se recarga y la fila pasa a `cancelada`; en Firestore la solicitud queda `cancelada` y aparece un documento nuevo en `Motivos` (con su propio id) con el texto escrito y estado `cancelada`. Al tocar una fila que no está `solicitada` no ocurre nada. Si la solicitud aún no se sincronizó con Firestore, la cancelación falla mostrando el error técnico (limitación 4 del README). | |

### Bandeja y cambio de estado (revisor y secretaria)

| ID | Caso | Pasos | Resultado esperado | Resultado |
|---|---|---|---|---|
| QA-21 | Acceso a la bandeja por rol | Iniciar sesión como estudiante, luego como revisor y luego como secretaria, mirando la barra superior del Catálogo. | Estudiante: ícono "Mis solicitudes", sin Bandeja. Revisor y secretaria: ícono "Bandeja" (y no "Mis solicitudes"). | |
| QA-22 | Ver la bandeja | Como revisor, abrir "Bandeja" teniendo solicitudes de estudiantes A y B. | Título "Bandeja de solicitudes". Las solicitudes de todos los estudiantes aparecen agrupadas por estado, con un contador de color por grupo; el grupo `aprobada` aparece expandido. Cada fila muestra el nombre del documento, el período y la fecha. Al arrastrar hacia abajo se recarga. | |
| QA-23 | Revisor: solicitada → enRevision | 1. En la bandeja, abrir una solicitud `solicitada`.<br>2. Tocar el botón "enRevision".<br>3. Escribir un mensaje y tocar "Confirmar". | El estado cambia a `enRevision` y el historial muestra el mensaje. Al volver, la solicitud aparece en el grupo `enRevision`. Solo se ofrece ese botón (no "aprobada" ni "entregada"). | |
| QA-24 | Revisor: aprobar y rechazar | 1. Abrir una solicitud `enRevision` y tocar "aprobada" con un mensaje.<br>2. Repetir con otra solicitud `enRevision` y tocar "rechazada". | La primera pasa a `aprobada`; la segunda a `rechazada`. Cada una guarda su mensaje en el historial. Las solicitudes `rechazada` ya no ofrecen botones de cambio. | |
| QA-25 | Secretaria: aprobada → entregada | Como secretaria, abrir una solicitud `aprobada` y tocar "entregada" con un mensaje. | Pasa a `entregada` y se registra el mensaje. Es el único botón disponible. | |
| QA-26 | Permisos por rol en el detalle | 1. Como secretaria, abrir una solicitud `solicitada` o `enRevision`.<br>2. Como revisor, abrir una `aprobada`. | En ambos casos no hay botones de cambio de estado; solo se ve el detalle y el historial. | |
| QA-27 | Salir del diálogo sin cambiar | Abrir una solicitud, tocar un botón de estado y en el diálogo "Mensaje del cambio" tocar "Volver". | No cambia el estado ni se crea ningún motivo. | |
| QA-28 | El estudiante ve el resultado | Tras QA-23 y QA-24, ingresar como el estudiante dueño y abrir "Mis solicitudes" (con internet). | La fila muestra el estado actualizado (`enRevision`, `aprobada`, etc.). | |
