const fs = require('fs');
const path = require('path');
const { initializeTestEnvironment, assertSucceeds, assertFails } = require('@firebase/rules-unit-testing');
const { doc, getDoc, setDoc, updateDoc, deleteDoc, collection, getDocs, query, where, addDoc, writeBatch } = require('firebase/firestore');

// Por defecto prueba las reglas del repo; RULES_PATH permite apuntar a otro archivo.
const RULES = path.resolve(process.env.RULES_PATH || path.join(__dirname, '..', 'firestore.rules'));
let pass = 0, fail = 0;
async function t(nombre, promesa) {
  try { await promesa; pass++; console.log('  ok   ' + nombre); }
  catch (e) { fail++; console.log('  FAIL ' + nombre + '  -> ' + String(e.message).split('\n')[0]); }
}
const ok = (n, p) => t(n, assertSucceeds(p));
const no = (n, p) => t(n, assertFails(p));

(async () => {
  const env = await initializeTestEnvironment({
    projectId: 'demo-solicitudes',
    firestore: { rules: fs.readFileSync(RULES, 'utf8'), host: '127.0.0.1', port: Number(process.env.FS_PORT || 8080) },
  });

  // Datos semilla sin reglas
  await env.withSecurityRulesDisabled(async (ctx) => {
    const db = ctx.firestore();
    await setDoc(doc(db, 'Usuarios/est1'), { nombre: 'Ana', email: 'a@x.co', rol: 'estudiante' });
    await setDoc(doc(db, 'Usuarios/est2'), { nombre: 'Beto', email: 'b@x.co', rol: 'estudiante' });
    await setDoc(doc(db, 'Usuarios/rev1'), { nombre: 'Rev', email: 'r@x.co', rol: 'revisor' });
    await setDoc(doc(db, 'Usuarios/sec1'), { nombre: 'Sec', email: 's@x.co', rol: 'secretaria' });
    await setDoc(doc(db, 'Documentos/d1'), { nombre: 'Cert', descripcion: 'x', habilitado: true });
    await setDoc(doc(db, 'Solicitudes/s1'), { idDocumento: 'd1', idUsuario: 'est1', periodo: '2025-1', estado: 'solicitada', fechaModificacion: '2026-01-01T00:00:00.000' });
    await setDoc(doc(db, 'Solicitudes/s2'), { idDocumento: 'd1', idUsuario: 'est2', periodo: '2025-1', estado: 'solicitada', fechaModificacion: '2026-01-01T00:00:00.000' });
    const base = { idDocumento: 'd1', periodo: '2025-1', fechaModificacion: '2026-01-01T00:00:00.000' };
    await setDoc(doc(db, 'Solicitudes/c1'), { ...base, idUsuario: 'est1', estado: 'solicitada' }); // cancelar OK
    await setDoc(doc(db, 'Solicitudes/c2'), { ...base, idUsuario: 'est1', estado: 'solicitada' }); // aprobar
    await setDoc(doc(db, 'Solicitudes/c3'), { ...base, idUsuario: 'est1', estado: 'solicitada' }); // rechazar
    await setDoc(doc(db, 'Solicitudes/c4'), { ...base, idUsuario: 'est1', estado: 'solicitada' }); // enRevision
    await setDoc(doc(db, 'Solicitudes/c5'), { ...base, idUsuario: 'est1', estado: 'solicitada' }); // cancelar + otro campo
    await setDoc(doc(db, 'Solicitudes/c6'), { ...base, idUsuario: 'est1', estado: 'enRevision' }); // cancelar desde enRevision
    await setDoc(doc(db, 'Solicitudes/c7'), { ...base, idUsuario: 'est1', estado: 'solicitada' }); // batch cancelar + motivo
    await setDoc(doc(db, 'Solicitudes/c8'), { ...base, idUsuario: 'est1', estado: 'solicitada' }); // motivo sin cancelar
    await setDoc(doc(db, 'Solicitudes/c9'), { ...base, idUsuario: 'est2', estado: 'cancelada' }); // ajena ya cancelada
    await setDoc(doc(db, 'Solicitudes/c10'), { ...base, idUsuario: 'est1', estado: 'solicitada' }); // cancelar y reasignar dueño
    await setDoc(doc(db, 'Solicitudes/c11'), { ...base, idUsuario: 'est1', estado: 'cancelada' }); // ya cancelada: revertir
    await setDoc(doc(db, 'Solicitudes/c12'), { ...base, idUsuario: 'est1', estado: 'aprobada' }); // revisor/secretaria
    await setDoc(doc(db, 'Motivos/m1'), { idSolicitud: 's1', mensaje: 'hola', estado: 'enRevision', fechaCreacion: '2026-01-02T00:00:00.000' });
    await setDoc(doc(db, 'Motivos/m2'), { idSolicitud: 's2', mensaje: 'otro', estado: 'enRevision', fechaCreacion: '2026-01-02T00:00:00.000' });
  });

  const est1 = env.authenticatedContext('est1').firestore();
  const est2 = env.authenticatedContext('est2').firestore();
  const rev = env.authenticatedContext('rev1').firestore();
  const sec = env.authenticatedContext('sec1').firestore();
  const nuevo = env.authenticatedContext('nuevo1').firestore(); // autenticado, aun sin perfil
  const anon = env.unauthenticatedContext().firestore();

  console.log('\nUsuarios');
  await ok('crear propio perfil con rol estudiante', setDoc(doc(nuevo, 'Usuarios/nuevo1'), { nombre: 'N', email: 'n@x.co', rol: 'estudiante' }));
  const otro = env.authenticatedContext('nuevo2').firestore();
  await no('auto-asignarse rol revisor', setDoc(doc(otro, 'Usuarios/nuevo2'), { nombre: 'N', email: 'n@x.co', rol: 'revisor' }));
  await no('auto-asignarse rol secretaria', setDoc(doc(otro, 'Usuarios/nuevo2'), { nombre: 'N', email: 'n@x.co', rol: 'secretaria' }));
  await no('crear perfil con uid ajeno', setDoc(doc(otro, 'Usuarios/alguien'), { nombre: 'N', email: 'n@x.co', rol: 'estudiante' }));
  await no('crear perfil con campos extra', setDoc(doc(otro, 'Usuarios/nuevo2'), { nombre: 'N', email: 'n@x.co', rol: 'estudiante', admin: true }));
  await no('crear perfil sin autenticar', setDoc(doc(anon, 'Usuarios/x'), { nombre: 'N', email: 'n@x.co', rol: 'estudiante' }));
  await ok('leer su propio perfil', getDoc(doc(est1, 'Usuarios/est1')));
  await no('leer perfil ajeno', getDoc(doc(est1, 'Usuarios/est2')));
  await no('estudiante no lista Usuarios', getDocs(collection(est1, 'Usuarios')));
  await no('autenticado sin perfil no lee perfil ajeno', getDoc(doc(nuevo, 'Usuarios/est1')));
  await no('sin autenticar no lee perfiles', getDoc(doc(anon, 'Usuarios/est1')));
  await ok('revisor lee el perfil de un estudiante', getDoc(doc(rev, 'Usuarios/est1')));
  await ok('secretaria lee el perfil de un estudiante', getDoc(doc(sec, 'Usuarios/est1')));
  await ok('revisor lee el perfil de la secretaria', getDoc(doc(rev, 'Usuarios/sec1')));
  await no('revisor no edita el perfil de otro', updateDoc(doc(rev, 'Usuarios/est1'), { nombre: 'X' }));
  await no('revisor no cambia el rol de otro', updateDoc(doc(rev, 'Usuarios/est1'), { rol: 'revisor' }));
  await no('secretaria no borra el perfil de otro', deleteDoc(doc(sec, 'Usuarios/est1')));
  await no('secretaria no crea perfil ajeno', setDoc(doc(sec, 'Usuarios/otroNuevo'), { nombre: 'N', email: 'n@x.co', rol: 'revisor' }));
  await no('escalar su rol (update)', updateDoc(doc(est1, 'Usuarios/est1'), { rol: 'secretaria' }));
  await no('borrar su perfil', deleteDoc(doc(est1, 'Usuarios/est1')));

  console.log('\nDocumentos');
  await ok('leer autenticado', getDoc(doc(est1, 'Documentos/d1')));
  await ok('listar catalogo autenticado', getDocs(collection(est1, 'Documentos')));
  await no('leer sin autenticar', getDoc(doc(anon, 'Documentos/d1')));
  await no('escribir (estudiante)', setDoc(doc(est1, 'Documentos/d9'), { nombre: 'x' }));
  await no('escribir (secretaria)', setDoc(doc(sec, 'Documentos/d9'), { nombre: 'x' }));

  console.log('\nSolicitudes');
  const nueva = (uid, extra = {}) => ({ idDocumento: 'd1', idUsuario: uid, periodo: '2025-2', estado: 'solicitada', fechaModificacion: '2026-02-01T00:00:00.000', ...extra });
  await ok('estudiante crea la suya', setDoc(doc(est1, 'Solicitudes/n1'), nueva('est1')));
  await no('estudiante crea a nombre de otro', setDoc(doc(est1, 'Solicitudes/n2'), nueva('est2')));
  await no('estudiante crea ya aprobada', setDoc(doc(est1, 'Solicitudes/n3'), nueva('est1', { estado: 'aprobada' })));
  await no('revisor no crea solicitudes', setDoc(doc(rev, 'Solicitudes/n4'), nueva('rev1')));
  const sinPerfil = env.authenticatedContext('fantasma').firestore(); // autenticado, sin doc en Usuarios
  await no('usuario sin perfil no crea', setDoc(doc(sinPerfil, 'Solicitudes/n5'), nueva('fantasma')));
  await no('usuario sin perfil no lee solicitudes ajenas', getDoc(doc(sinPerfil, 'Solicitudes/s1')));
  await no('usuario sin perfil no crea motivos', addDoc(collection(sinPerfil, 'Motivos'), { idSolicitud: 's1', mensaje: 'm', estado: 'aprobada', fechaCreacion: 'x' }));
  await ok('estudiante lee la suya', getDoc(doc(est1, 'Solicitudes/s1')));
  await no('estudiante lee ajena', getDoc(doc(est1, 'Solicitudes/s2')));
  await ok('estudiante lista las suyas (where idUsuario==uid)', getDocs(query(collection(est1, 'Solicitudes'), where('idUsuario', '==', 'est1'))));
  await no('estudiante lista TODA la coleccion', getDocs(collection(est1, 'Solicitudes')));
  await ok('revisor lee cualquiera', getDoc(doc(rev, 'Solicitudes/s2')));
  await ok('revisor lista toda la coleccion', getDocs(collection(rev, 'Solicitudes')));
  await ok('secretaria lista toda la coleccion', getDocs(collection(sec, 'Solicitudes')));
  await ok('revisor cambia estado', updateDoc(doc(rev, 'Solicitudes/s2'), { estado: 'enRevision', fechaModificacion: '2026-03-01T00:00:00.000' }));
  await no('secretaria NO inicia la revision (es del revisor)', updateDoc(doc(sec, 'Solicitudes/s1'), { estado: 'enRevision', fechaModificacion: '2026-03-01T00:00:00.000' }));
  await no('revisor cambia otro campo (periodo)', updateDoc(doc(rev, 'Solicitudes/s2'), { periodo: '2026-2' }));
  await no('revisor reasigna idUsuario', updateDoc(doc(rev, 'Solicitudes/s2'), { idUsuario: 'rev1' }));
  await no('estudiante cambia estado a aprobada', updateDoc(doc(est1, 'Solicitudes/n1'), { estado: 'aprobada' }));
  const f = '2026-03-02T00:00:00.000';
  console.log('  -- cancelacion por el estudiante');
  await ok('estudiante cancela la suya (solicitada -> cancelada)', updateDoc(doc(est1, 'Solicitudes/c1'), { estado: 'cancelada', fechaModificacion: f }));
  await no('estudiante intenta APROBAR la suya', updateDoc(doc(est1, 'Solicitudes/c2'), { estado: 'aprobada', fechaModificacion: f }));
  await no('estudiante intenta RECHAZAR la suya', updateDoc(doc(est1, 'Solicitudes/c3'), { estado: 'rechazada', fechaModificacion: f }));
  await no('estudiante intenta pasarla a enRevision', updateDoc(doc(est1, 'Solicitudes/c4'), { estado: 'enRevision', fechaModificacion: f }));
  await no('estudiante intenta marcarla entregada', updateDoc(doc(est1, 'Solicitudes/c4'), { estado: 'entregada', fechaModificacion: f }));
  await no('estudiante cancela la solicitud de OTRO', updateDoc(doc(est1, 'Solicitudes/s2'), { estado: 'cancelada', fechaModificacion: f }));
  await no('otro estudiante cancela una que no es suya', updateDoc(doc(est2, 'Solicitudes/c2'), { estado: 'cancelada', fechaModificacion: f }));
  await no('estudiante cancela y cambia ademas el periodo', updateDoc(doc(est1, 'Solicitudes/c5'), { estado: 'cancelada', fechaModificacion: f, periodo: '2026-2' }));
  await no('estudiante cancela y reasigna idUsuario', updateDoc(doc(est1, 'Solicitudes/c10'), { estado: 'cancelada', fechaModificacion: f, idUsuario: 'est2' }));
  await no('estudiante cancela una que ya esta enRevision', updateDoc(doc(est1, 'Solicitudes/c6'), { estado: 'cancelada', fechaModificacion: f }));
  await no('estudiante revierte una cancelada a solicitada', updateDoc(doc(est1, 'Solicitudes/c11'), { estado: 'solicitada', fechaModificacion: f }));
  await no('usuario autenticado sin perfil no cancela solicitud ajena', updateDoc(doc(sinPerfil, 'Solicitudes/c5'), { estado: 'cancelada', fechaModificacion: f }));
  await no('revisor NO aprueba directo desde solicitada', updateDoc(doc(rev, 'Solicitudes/c2'), { estado: 'aprobada', fechaModificacion: f }));
  await ok('revisor inicia la revision (solicitada -> enRevision)', updateDoc(doc(rev, 'Solicitudes/c2'), { estado: 'enRevision', fechaModificacion: f }));
  await ok('revisor aprueba (enRevision -> aprobada)', updateDoc(doc(rev, 'Solicitudes/c2'), { estado: 'aprobada', fechaModificacion: f }));
  await ok('revisor inicia la revision de otra', updateDoc(doc(rev, 'Solicitudes/c3'), { estado: 'enRevision', fechaModificacion: f }));
  await ok('revisor rechaza (enRevision -> rechazada)', updateDoc(doc(rev, 'Solicitudes/c3'), { estado: 'rechazada', fechaModificacion: f }));
  const entrega = { fechaEntrega: f, entregadoPor: 'sec1' }; // datos de entrega que escribe la app
  await ok('secretaria entrega una aprobada (aprobada -> entregada)', updateDoc(doc(sec, 'Solicitudes/c12'), { estado: 'entregada', fechaModificacion: f, ...entrega }));
  await no('revisor NO cancela solicitudes (solo el estudiante dueño)', updateDoc(doc(rev, 'Solicitudes/c4'), { estado: 'cancelada', fechaModificacion: f }));
  await ok('estudiante reenvia solicitud identica (reintento offline)', setDoc(doc(est1, 'Solicitudes/n1'), nueva('est1')));
  await no('estudiante reenvia cambiando periodo', setDoc(doc(est1, 'Solicitudes/n1'), nueva('est1', { periodo: '2026-1' })));
  await no('estudiante actualiza solicitud ajena', updateDoc(doc(est2, 'Solicitudes/n1'), { estado: 'cancelada' }));
  await no('borrar solicitud (estudiante)', deleteDoc(doc(est1, 'Solicitudes/n1')));
  await no('borrar solicitud (secretaria)', deleteDoc(doc(sec, 'Solicitudes/s1')));

  console.log('\nMaquina de estados (el servidor impone el orden)');
  const ESTADOS = ['solicitada', 'enRevision', 'aprobada', 'rechazada', 'entregada', 'cancelada'];
  let seq = 0;
  const sembrar = async (estado, extra = {}) => {
    const id = 'mx' + (seq++);
    await env.withSecurityRulesDisabled(async (ctx) => {
      await setDoc(doc(ctx.firestore(), 'Solicitudes/' + id), { idDocumento: 'd1', idUsuario: 'est1', periodo: '2025-1', estado, fechaModificacion: '2026-01-01T00:00:00.000', ...extra });
    });
    return id;
  };
  // Tabla de verdad del negocio: unica fuente de lo que DEBE estar permitido.
  const permitida = (actual, nuevo, rol) =>
    (rol === 'revisor' && ((actual === 'solicitada' && nuevo === 'enRevision') || (actual === 'enRevision' && (nuevo === 'aprobada' || nuevo === 'rechazada')))) ||
    (rol === 'secretaria' && actual === 'aprobada' && nuevo === 'entregada') ||
    (rol === 'estudiante' && actual === 'solicitada' && nuevo === 'cancelada');
  const matriz = async (rol, db, uid) => {
    const errores = [];
    for (const actual of ESTADOS) {
      for (const nuevo of ESTADOS) {
        const id = await sembrar(actual);
        let paso = true;
        // Para "entregada" la app siempre manda tambien los datos de entrega.
        const cambios = { estado: nuevo, fechaModificacion: '2026-04-01T00:00:00.000', ...(nuevo === 'entregada' ? { fechaEntrega: '2026-04-01T00:00:00.000', entregadoPor: uid } : {}) };
        try { await assertSucceeds(updateDoc(doc(db, 'Solicitudes/' + id), cambios)); } catch { paso = false; }
        if (paso !== permitida(actual, nuevo, rol)) errores.push(`${actual} -> ${nuevo}: ${paso ? 'PERMITIDO' : 'bloqueado'}`);
      }
    }
    if (errores.length) throw new Error('mal controladas: ' + errores.join('; '));
  };
  await t('matriz 36 combinaciones: revisor (solo sus 3 transiciones)', matriz('revisor', rev, 'rev1'));
  await t('matriz 36 combinaciones: secretaria (solo aprobada -> entregada)', matriz('secretaria', sec, 'sec1'));
  await t('matriz 36 combinaciones: estudiante dueño (solo solicitada -> cancelada)', matriz('estudiante', est1, 'est1'));
  const ent = await sembrar('entregada');
  await no('entregada NO se puede entregar otra vez (secretaria)', updateDoc(doc(sec, 'Solicitudes/' + ent), { estado: 'entregada', fechaModificacion: f, ...entrega }));
  await no('entregada NO se "re-entrega" tocando solo la fecha', updateDoc(doc(sec, 'Solicitudes/' + ent), { fechaModificacion: f }));
  await no('entregada NO se reabre (revisor -> solicitada)', updateDoc(doc(rev, 'Solicitudes/' + ent), { estado: 'solicitada', fechaModificacion: f }));
  await no('entregada NO se cancela (estudiante dueño)', updateDoc(doc(est1, 'Solicitudes/' + ent), { estado: 'cancelada', fechaModificacion: f }));
  for (const cerrada of ['rechazada', 'cancelada']) {
    const id = await sembrar(cerrada);
    await no(`${cerrada} NO se puede aprobar`, updateDoc(doc(rev, 'Solicitudes/' + id), { estado: 'aprobada', fechaModificacion: f }));
    await no(`${cerrada} NO se puede entregar`, updateDoc(doc(sec, 'Solicitudes/' + id), { estado: 'entregada', fechaModificacion: f, ...entrega }));
  }
  const sinAprobar = await sembrar('enRevision');
  await no('secretaria NO entrega una solicitud sin aprobacion', updateDoc(doc(sec, 'Solicitudes/' + sinAprobar), { estado: 'entregada', fechaModificacion: f, ...entrega }));
  const flujo = await sembrar('solicitada');
  await ok('flujo completo 1/3: revisor inicia la revision', updateDoc(doc(rev, 'Solicitudes/' + flujo), { estado: 'enRevision', fechaModificacion: f }));
  await ok('flujo completo 2/3: revisor aprueba', updateDoc(doc(rev, 'Solicitudes/' + flujo), { estado: 'aprobada', fechaModificacion: f }));
  await ok('flujo completo 3/3: secretaria entrega', updateDoc(doc(sec, 'Solicitudes/' + flujo), { estado: 'entregada', fechaModificacion: f, ...entrega }));
  await no('flujo completo: una SEGUNDA entrega es rechazada', updateDoc(doc(sec, 'Solicitudes/' + flujo), { estado: 'entregada', fechaModificacion: '2026-05-01T00:00:00.000', ...entrega }));
  const rev2 = await sembrar('enRevision');
  await ok('reintento de creacion identico sigue permitido al dueño', setDoc(doc(est1, 'Solicitudes/' + rev2), { idDocumento: 'd1', idUsuario: 'est1', periodo: '2025-1', estado: 'enRevision', fechaModificacion: '2026-01-01T00:00:00.000' }));
  await no('reintento de creacion NO pisa una revision posterior', setDoc(doc(est1, 'Solicitudes/' + rev2), { idDocumento: 'd1', idUsuario: 'est1', periodo: '2025-1', estado: 'solicitada', fechaModificacion: '2026-01-01T00:00:00.000' }));

  console.log('\nObservacion de revision y datos de entrega');
  // Documento tal como lo crea la app: los campos opcionales existen con null.
  const real = { observacionEstudiante: '', fechaCreacion: '2026-01-01T00:00:00.000Z', observacionRevision: null, fechaEntrega: null, entregadoPor: null };
  const fz = '2026-06-01T10:00:00.000Z'; // UTC, como las escribe la app
  const upd = (db, id, cambios) => updateDoc(doc(db, 'Solicitudes/' + id), { fechaModificacion: fz, ...cambios });
  let o = await sembrar('enRevision', real);
  await ok('revisor aprueba con observacionRevision', upd(rev, o, { estado: 'aprobada', observacionRevision: 'Documentos en orden' }));
  o = await sembrar('enRevision', real);
  await ok('revisor rechaza con observacionRevision (el motivo)', upd(rev, o, { estado: 'rechazada', observacionRevision: 'Falta el soporte de pago' }));
  o = await sembrar('enRevision', real);
  await ok('revisor aprueba sin observacion (los campos null no estorban)', upd(rev, o, { estado: 'aprobada' }));
  o = await sembrar('solicitada', real);
  await no('revisor NO escribe observacionRevision al iniciar la revision', upd(rev, o, { estado: 'enRevision', observacionRevision: 'x' }));
  o = await sembrar('enRevision', real);
  await no('revisor aprueba pero escribe fechaEntrega', upd(rev, o, { estado: 'aprobada', fechaEntrega: fz }));
  o = await sembrar('enRevision', real);
  await no('revisor aprueba pero escribe entregadoPor', upd(rev, o, { estado: 'aprobada', entregadoPor: 'rev1' }));
  o = await sembrar('enRevision', real);
  await no('observacionRevision debe ser texto', upd(rev, o, { estado: 'aprobada', observacionRevision: 123 }));
  o = await sembrar('aprobada', real);
  await ok('secretaria entrega con fechaEntrega y entregadoPor propios', upd(sec, o, { estado: 'entregada', fechaEntrega: fz, entregadoPor: 'sec1' }));
  o = await sembrar('aprobada', real);
  await no('secretaria NO entrega sin registrar los datos de entrega', upd(sec, o, { estado: 'entregada' }));
  o = await sembrar('aprobada', real);
  await no('secretaria NO entrega a nombre de otro usuario', upd(sec, o, { estado: 'entregada', fechaEntrega: fz, entregadoPor: 'rev1' }));
  o = await sembrar('aprobada', real);
  await no('secretaria NO entrega sin fechaEntrega', upd(sec, o, { estado: 'entregada', entregadoPor: 'sec1' }));
  o = await sembrar('aprobada', real);
  await no('fechaEntrega debe ser texto', upd(sec, o, { estado: 'entregada', fechaEntrega: 123, entregadoPor: 'sec1' }));
  o = await sembrar('aprobada', real);
  await no('secretaria entrega pero escribe observacionRevision', upd(sec, o, { estado: 'entregada', fechaEntrega: fz, entregadoPor: 'sec1', observacionRevision: 'x' }));
  o = await sembrar('aprobada', real);
  await no('secretaria entrega pero cambia el periodo', upd(sec, o, { estado: 'entregada', fechaEntrega: fz, entregadoPor: 'sec1', periodo: '2026-2' }));
  o = await sembrar('solicitada', real);
  await no('estudiante cancela pero escribe observacionRevision', upd(est1, o, { estado: 'cancelada', observacionRevision: 'x' }));
  o = await sembrar('solicitada', real);
  await no('estudiante cancela pero escribe entregadoPor', upd(est1, o, { estado: 'cancelada', entregadoPor: 'est1' }));
  o = await sembrar('solicitada', real);
  await ok('estudiante cancela documento real (campos null intactos)', upd(est1, o, { estado: 'cancelada' }));

  console.log('\nMotivos');
  const mot =(idSol, extra = {}) => ({ idSolicitud: idSol, mensaje: 'm', estado: 'aprobada', fechaCreacion: '2026-03-01T00:00:00.000', ...extra });
  await ok('revisor crea motivo', addDoc(collection(rev, 'Motivos'), mot('s1')));
  await ok('secretaria crea motivo', addDoc(collection(sec, 'Motivos'), mot('s1')));
  await no('estudiante crea motivo (su solicitud NO esta cancelada)', addDoc(collection(est1, 'Motivos'), mot('s1', { estado: 'cancelada' })));
  console.log('  -- motivos del estudiante al cancelar');
  await ok('estudiante crea motivo tras cancelar la suya (c1 ya cancelada)', addDoc(collection(est1, 'Motivos'), mot('c1', { estado: 'cancelada', mensaje: 'ya no lo necesito' })));
  await no('estudiante crea motivo con estado aprobada en su cancelada', addDoc(collection(est1, 'Motivos'), mot('c1', { estado: 'aprobada' })));
  await no('estudiante crea motivo cancelada pero su solicitud sigue solicitada', addDoc(collection(est1, 'Motivos'), mot('c8', { estado: 'cancelada' })));
  await no('estudiante crea motivo en solicitud cancelada de OTRO', addDoc(collection(est1, 'Motivos'), mot('c9', { estado: 'cancelada' })));
  await no('estudiante crea motivo de solicitud inexistente', addDoc(collection(est1, 'Motivos'), mot('no-existe', { estado: 'cancelada' })));
  await no('estudiante crea motivo con campos extra', addDoc(collection(est1, 'Motivos'), mot('c1', { estado: 'cancelada', extra: 1 })));
  await no('usuario sin perfil no crea motivo de cancelacion', addDoc(collection(sinPerfil, 'Motivos'), mot('c1', { estado: 'cancelada' })));
  await ok('estudiante cancela + crea motivo en un mismo batch', (async () => {
    const b = writeBatch(est1);
    b.update(doc(est1, 'Solicitudes/c7'), { estado: 'cancelada', fechaModificacion: f });
    b.set(doc(collection(est1, 'Motivos')), mot('c7', { estado: 'cancelada' }));
    await b.commit();
  })());
  await ok('revisor sigue creando motivos en cualquier caso', addDoc(collection(rev, 'Motivos'), mot('c8', { estado: 'enRevision' })));
  await no('motivo con campos extra', addDoc(collection(rev, 'Motivos'), mot('s1', { extra: 1 })));
  await ok('dueño lee motivo de su solicitud (get)', getDoc(doc(est1, 'Motivos/m1')));
  await no('estudiante lee motivo de solicitud ajena', getDoc(doc(est1, 'Motivos/m2')));
  await ok('dueño consulta where idSolicitud==s1', getDocs(query(collection(est1, 'Motivos'), where('idSolicitud', '==', 's1'))));
  await no('estudiante consulta motivos de solicitud ajena', getDocs(query(collection(est1, 'Motivos'), where('idSolicitud', '==', 's2'))));
  await ok('revisor consulta motivos de cualquiera', getDocs(query(collection(rev, 'Motivos'), where('idSolicitud', '==', 's2'))));
  await ok('secretaria lee cualquier motivo', getDoc(doc(sec, 'Motivos/m2')));
  await no('actualizar motivo', updateDoc(doc(rev, 'Motivos/m1'), { mensaje: 'x' }));
  await no('borrar motivo', deleteDoc(doc(rev, 'Motivos/m1')));
  await no('leer motivo sin autenticar', getDoc(doc(anon, 'Motivos/m1')));

  await env.cleanup();
  console.log(`\nResultado: ${pass} ok, ${fail} fallos`);
  process.exit(fail ? 1 : 0);
})().catch((e) => { console.error(e); process.exit(2); });
