import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:solicitud_documentos/local/app_database.dart';
import 'package:solicitud_documentos/local/motivo_local_data_source.dart';
import 'package:solicitud_documentos/local/solicitud_local_data_source.dart';
import 'package:solicitud_documentos/models/estados.dart';
import 'package:solicitud_documentos/models/motivo.dart';
import 'package:solicitud_documentos/models/solicitud.dart';

Solicitud _solicitud(String id, String uid) => Solicitud(
  id: id,
  idDocumento: 'd1',
  idUsuario: uid,
  periodo: '2026-1',
  estado: EstadoSolicitud.solicitada,
  fechaCreacion: DateTime.utc(2026, 1, 1),
  fechaModificacion: DateTime.utc(2026, 1, 1),
);

void main() {
  late AppDatabase db;
  late SolicitudLocalDataSource local;

  setUp(() {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    local = SolicitudLocalDataSource(db);
  });
  tearDown(() => db.close());

  group('aislamiento por cuenta en Drift', () {
    test('getSolicitudes y getPendingSolicitudes filtran por idUsuario', () async {
      await local.saveSolicitud(_solicitud('a1', 'ana'));
      await local.saveSolicitud(_solicitud('b1', 'beto'));

      final deAna = await local.getSolicitudes(idUsuario: 'ana');
      expect(deAna.map((s) => s.id), ['a1']);
      final pendientesBeto = await local.getPendingSolicitudes(
        idUsuario: 'beto',
      );
      expect(pendientesBeto.map((s) => s.id), ['b1']);
      expect(await local.getIdsPendientes(idUsuario: 'ana'), {'a1'});

      // Sin idUsuario (revisor / secretaria) se ve toda la copia local.
      expect((await local.getSolicitudes()).length, 2);
    });

    test('borrarSincronizadas conserva las pendientes', () async {
      await local.saveSolicitud(_solicitud('sinc', 'ana'));
      await local.markSynced('sinc');
      await local.saveSolicitud(_solicitud('pend', 'ana'));

      await local.borrarSincronizadas();

      final quedan = await local.getSolicitudes(idUsuario: 'ana');
      expect(quedan.map((s) => s.id), ['pend']);
    });

    test('borrarTodos vacía los motivos', () async {
      final motivos = MotivoLocalDataSource(db);
      await motivos.saveMotivo(
        Motivo(
          id: 'm1',
          idSolicitud: 'a1',
          mensaje: 'hola',
          estado: EstadoSolicitud.enRevision,
          fechaCreacion: DateTime.utc(2026, 1, 2),
        ),
      );
      await motivos.borrarTodos();
      expect(await motivos.getMotivosPorSolicitud('a1'), isEmpty);
    });
  });

  group('fechas en UTC', () {
    test('toJson escribe siempre con Z, aunque la fecha sea local', () {
      final s = Solicitud(
        id: 'x',
        idDocumento: 'd1',
        idUsuario: 'ana',
        periodo: '2026-1',
        estado: EstadoSolicitud.entregada,
        fechaCreacion: DateTime(2026, 3, 1, 8, 30), // hora local
        fechaModificacion: DateTime(2026, 3, 1, 9, 0),
        fechaEntrega: DateTime(2026, 3, 1, 9, 0),
      );
      final json = s.toJson();
      for (final k in ['fechaCreacion', 'fechaModificacion', 'fechaEntrega']) {
        expect((json[k] as String).endsWith('Z'), isTrue, reason: k);
      }
    });

    test('ida y vuelta conserva el mismo instante', () {
      final original = _solicitud('x', 'ana');
      final copia = Solicitud.fromJson(original.toJson());
      expect(copia.fechaModificacion.isAtSameMomentAs(original.fechaModificacion), isTrue);
      expect(copia.fechaModificacion.isUtc, isTrue);
    });
  });
}
