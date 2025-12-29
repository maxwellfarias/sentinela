import 'package:flutter/widgets.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sentinela/domain/models/veiculo/vehicle_alert_model.dart';
import 'package:sentinela/utils/command.dart';
import 'package:sentinela/utils/result.dart';

/// ViewModel para a tela de mapa de patrulha
///
/// Implementa o padrão MVVM com Command Pattern para separar a lógica de negócio
/// da interface do usuário com suporte a localização, alertas e controles do mapa.
final class PatrolMapViewModel extends ChangeNotifier {
  PatrolMapViewModel() {
    // Inicializa os comandos
    loadAlerts = Command0(_loadAlerts);
    loadUserLocation = Command0(_loadUserLocation);
    selectAlert = Command1(_selectAlert);
    clearSelectedAlert = Command0(_clearSelectedAlert);
  }

  // ==================== COMMANDS ====================

  /// Comando para carregar os alertas próximos
  late final Command0<List<VehicleAlertModel>> loadAlerts;

  /// Comando para carregar a localização do usuário
  late final Command0<LatLng> loadUserLocation;

  /// Comando para selecionar um alerta
  late final Command1<VehicleAlertModel?, int> selectAlert;

  /// Comando para limpar o alerta selecionado
  late final Command0<void> clearSelectedAlert;

  // ==================== STATE ====================

  List<VehicleAlertModel> _alerts = [];
  VehicleAlertModel? _selectedAlert;
  LatLng? _userLocation;
  String _searchQuery = '';
  bool _isOnline = true;
  String _currentSector = 'SETOR 04';
  GoogleMapController? _mapController;

  // ==================== GETTERS ====================

  /// Lista de alertas de veículos
  List<VehicleAlertModel> get alerts => _alerts;

  /// Alerta selecionado atualmente
  VehicleAlertModel? get selectedAlert => _selectedAlert;

  /// Localização atual do usuário/patrulha
  LatLng? get userLocation => _userLocation;

  /// Termo de busca atual
  String get searchQuery => _searchQuery;

  /// Status de conexão
  bool get isOnline => _isOnline;

  /// Setor atual da patrulha
  String get currentSector => _currentSector;

  /// Controller do mapa
  GoogleMapController? get mapController => _mapController;

  /// Verifica se há alertas
  bool get hasAlerts => _alerts.isNotEmpty;

  /// Alertas filtrados pela busca
  List<VehicleAlertModel> get filteredAlerts {
    if (_searchQuery.isEmpty) return _alerts;
    final query = _searchQuery.toLowerCase();
    return _alerts.where((alert) {
      return alert.placa.toLowerCase().contains(query) ||
          alert.marca.toLowerCase().contains(query) ||
          alert.modelo.toLowerCase().contains(query);
    }).toList();
  }

  // ==================== PRIVATE METHODS ====================

  /// Carrega os alertas próximos (mock data para demonstração)
  Future<Result<List<VehicleAlertModel>>> _loadAlerts() async {
    await Future.delayed(const Duration(milliseconds: 500));

    // Mock data - em produção viria de um repository
    _alerts = [
      VehicleAlertModel(
        id: 1,
        modelo: 'Civic EXL',
        marca: 'Honda',
        placa: 'ABC-1234',
        cor: 'Prata',
        tipo: VehicleAlertType.roubado,
        latitude: -23.5505,
        longitude: -46.6333,
        distanciaKm: 0.8,
        horaDeteccao: DateTime.now().subtract(const Duration(minutes: 2)),
        imagemUrl: null,
      ),
      VehicleAlertModel(
        id: 2,
        modelo: 'Corolla XEi',
        marca: 'Toyota',
        placa: 'XYZ-5678',
        cor: 'Preto',
        tipo: VehicleAlertType.furtado,
        latitude: -23.5515,
        longitude: -46.6343,
        distanciaKm: 1.2,
        horaDeteccao: DateTime.now().subtract(const Duration(minutes: 15)),
        imagemUrl: null,
      ),
    ];

    // Seleciona automaticamente o primeiro alerta
    if (_alerts.isNotEmpty && _selectedAlert == null) {
      _selectedAlert = _alerts.first;
    }

    notifyListeners();
    return Result.ok(_alerts);
  }

  /// Carrega a localização do usuário (mock para demonstração)
  Future<Result<LatLng>> _loadUserLocation() async {
    await Future.delayed(const Duration(milliseconds: 300));

    // Mock location - São Paulo centro
    _userLocation = const LatLng(-23.5505, -46.6333);
    notifyListeners();
    return Result.ok(_userLocation!);
  }

  /// Seleciona um alerta específico
  Future<Result<VehicleAlertModel?>> _selectAlert(int alertId) async {
    _selectedAlert = _alerts.firstWhere(
      (a) => a.id == alertId,
      orElse: () => _alerts.first,
    );
    notifyListeners();
    return Result.ok(_selectedAlert);
  }

  /// Limpa o alerta selecionado
  Future<Result<void>> _clearSelectedAlert() async {
    _selectedAlert = null;
    notifyListeners();
    return Result.ok(null);
  }

  // ==================== PUBLIC METHODS ====================

  /// Define o controller do mapa
  void setMapController(GoogleMapController controller) {
    _mapController = controller;
    notifyListeners();
  }

  /// Atualiza o termo de busca
  void updateSearch(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  /// Limpa a busca
  void clearSearch() {
    _searchQuery = '';
    notifyListeners();
  }

  /// Move a câmera para a localização do usuário
  void goToUserLocation() {
    if (_userLocation != null && _mapController != null) {
      _mapController!.animateCamera(
        CameraUpdate.newLatLngZoom(_userLocation!, 16),
      );
    }
  }

  /// Move a câmera para um alerta específico
  void goToAlert(VehicleAlertModel alert) {
    if (_mapController != null) {
      _mapController!.animateCamera(
        CameraUpdate.newLatLngZoom(LatLng(alert.latitude, alert.longitude), 17),
      );
    }
  }

  /// Atualiza o status de conexão
  void updateConnectionStatus(bool isOnline) {
    _isOnline = isOnline;
    notifyListeners();
  }

  /// Gera os markers para o mapa
  Set<Marker> generateMarkers({
    required BitmapDescriptor alertIcon,
    required BitmapDescriptor userIcon,
    Function(VehicleAlertModel)? onAlertTap,
  }) {
    final markers = <Marker>{};

    // Marker do usuário
    if (_userLocation != null) {
      markers.add(
        Marker(
          markerId: const MarkerId('user_location'),
          position: _userLocation!,
          icon: userIcon,
          anchor: const Offset(0.5, 0.5),
          infoWindow: const InfoWindow(title: 'Sua localização'),
        ),
      );
    }

    // Markers dos alertas
    for (final alert in _alerts) {
      markers.add(
        Marker(
          markerId: MarkerId('alert_${alert.id}'),
          position: LatLng(alert.latitude, alert.longitude),
          icon: alertIcon,
          infoWindow: InfoWindow(
            title: '${alert.marca} ${alert.modelo}',
            snippet: alert.placa,
          ),
          onTap: () {
            selectAlert.execute(alert.id);
            onAlertTap?.call(alert);
          },
        ),
      );
    }

    return markers;
  }

  @override
  void dispose() {
    _mapController?.dispose();
    super.dispose();
  }
}
