
class SolicitudValidators {
    static const List<String> periodos_aceptados = ["2025-1", "2025-2", "2026-1", "2026-2"];
    static String? validarHabilitado (bool habilitado){
        if (!habilitado) {
        return 'Este tipo de documento no está disponible para solicitar';
        }
        return null;
    }


    static String? validarPeriodo (String periodo, List<String> periodos_aceptados){
        if (!periodos_aceptados.contains(periodo)) {
        return 'Seleccionar un período académico válido (2025-1 a 2026-2)';
        }
        return null;
    }
}