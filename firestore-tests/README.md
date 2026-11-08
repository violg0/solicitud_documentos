# Pruebas de las reglas de Firestore

Prueban `../firestore.rules` contra el **emulador local de Firestore**. No tocan
el proyecto real de Firebase ni datos de producción.

## Requisitos

- Node.js 18 o superior
- Java 11 o superior (lo usa el emulador de Firestore)
- Firebase CLI: `npm install -g firebase-tools`

No hace falta iniciar sesión en Firebase: el proyecto usado es `demo-solicitudes`
(los proyectos `demo-*` solo funcionan con emuladores).

## Cómo correrlas

```bash
cd firestore-tests
npm install        # una sola vez
npm test
```

`npm test` es un atajo de:

```bash
firebase emulators:exec --only firestore --project demo-solicitudes "node test.js"
```

La primera vez, la CLI descarga el emulador de Firestore (unos 60 MB).
Al terminar debe verse `Resultado: 77 ok, 0 fallos`; si alguna regla se rompe,
el comando sale con código 1 y marca la prueba con `FAIL`.

Para probar otro archivo de reglas: `RULES_PATH=ruta/al/archivo.rules npm test`.

## Qué cubren

| Colección | Casos |
|---|---|
| `Usuarios` | Solo se crea el propio perfil y siempre con rol `estudiante`; no se puede auto-asignar `revisor`/`secretaria`, ni escalar el rol después, ni leer perfiles ajenos |
| `Documentos` | Lectura para autenticados; escritura denegada a todos |
| `Solicitudes` | El estudiante crea y lee solo las suyas (siempre en estado `solicitada`); no puede listar toda la colección; revisor y secretaria leen todas y cambian solo `estado` y `fechaModificacion`; el estudiante solo puede cancelar la suya (`solicitada` → `cancelada`) y no puede aprobar, rechazar ni tocar otra cosa; nadie borra |
| `Motivos` | Revisor y secretaria crean; el estudiante solo crea el motivo de la cancelación de su propia solicitud (también dentro de un mismo batch); lectura para el dueño de la solicitud, revisor y secretaria; sin edición ni borrado |

Las pruebas que esperan un rechazo (`PERMISSION_DENIED`) imprimen en pantalla
un aviso del SDK de Firestore: es normal y no indica un fallo.
