import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sentinela/ui/core/extensions/build_context_extension.dart';
import 'package:sentinela/ui/patrol_map/viewmodel/patrol_map_viewmodel.dart';
import 'package:sentinela/ui/patrol_map/widget/componentes/patrol_alert_bottom_sheet.dart';
import 'package:sentinela/ui/patrol_map/widget/componentes/patrol_map_controls.dart';
import 'package:sentinela/ui/patrol_map/widget/componentes/patrol_map_top_bar.dart';
import 'package:sentinela/utils/command.dart';

/// Tela de mapa de patrulha com alertas de veículos
///
/// Esta tela exibe um mapa em tela cheia com marcadores de alertas de veículos,
/// controles de mapa, barra de busca e um bottom sheet com detalhes do alerta.
final class PatrolMapScreen extends StatefulWidget {
  final PatrolMapViewModel viewModel;

  const PatrolMapScreen({super.key, required this.viewModel});

  @override
  State<PatrolMapScreen> createState() => _PatrolMapScreenState();
}

class _PatrolMapScreenState extends State<PatrolMapScreen> {
  final TextEditingController _searchController = TextEditingController();
  bool isShowingModalBottomSheet = false;

  // Localização inicial (São Paulo)
  static const LatLng _initialPosition = LatLng(-23.5505, -46.6333);

  @override
  void initState() {
    super.initState();
    // Listeners obrigatórios para commands
    widget.viewModel.loadAlerts.addListener(_onLoadAlertsResult);
    widget.viewModel.loadUserLocation.addListener(_onLoadUserLocationResult);
    widget.viewModel.selectAlert.addListener(_onSelectAlertResult);

    // Carrega dados iniciais
    widget.viewModel.loadAlerts.execute();
    widget.viewModel.loadUserLocation.execute();
  }

  @override
  void dispose() {
    // Remove todos os listeners
    widget.viewModel.loadAlerts.removeListener(_onLoadAlertsResult);
    widget.viewModel.loadUserLocation.removeListener(_onLoadUserLocationResult);
    widget.viewModel.selectAlert.removeListener(_onSelectAlertResult);
    _searchController.dispose();
    super.dispose();
  }

  /// Callback para resultado do carregamento de alertas
  void _onLoadAlertsResult() {
    _onResult(
      command: widget.viewModel.loadAlerts,
      successMessage: 'Alertas carregados com sucesso!',
    );
  }

  /// Callback para resultado do carregamento de localização
  void _onLoadUserLocationResult() {
    _onResult(
      command: widget.viewModel.loadUserLocation,
      successMessage: 'Localização obtida!',
    );
  }

  /// Callback para resultado da seleção de alerta
  void _onSelectAlertResult() {
    final alert = widget.viewModel.selectedAlert;
    if (alert != null) {
      widget.viewModel.goToAlert(alert);
    }
  }

  /// Método _onResult obrigatório para feedback visual
  void _onResult({required Command command, required String successMessage}) {
    if (command.error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Erro: ${command.errorMessage ?? 'Ocorreu um erro desconhecido.'}',
          ),
          backgroundColor: context.colorTheme.bgDanger,
        ),
      );
    }
    // Sucesso silencioso para operações de carregamento de mapa
  }

  /// Abre o menu lateral
  void _openMenu() {
    setState(() {
      isShowingModalBottomSheet = !isShowingModalBottomSheet;
    });
  }

  /// Abre as notificações
  void _openNotifications() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Notificações'),
        backgroundColor: context.colorTheme.bgBrand,
      ),
    );
  }

  /// Mostra opções de camadas do mapa
  void _showLayersOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: context.colorTheme.bgNeutralSecondaryStrongest,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Tipo de Mapa',
              style: context.customTextTheme.textLgBold.copyWith(
                color: context.colorTheme.fgHeading,
              ),
            ),
            const SizedBox(height: 16),
            _MapTypeOption(
              title: 'Normal',
              icon: Icons.map_outlined,
              onTap: () => Navigator.pop(context),
            ),
            _MapTypeOption(
              title: 'Satélite',
              icon: Icons.satellite_alt_outlined,
              onTap: () => Navigator.pop(context),
            ),
            _MapTypeOption(
              title: 'Híbrido',
              icon: Icons.layers_outlined,
              onTap: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }

  /// Inicia interceptação do veículo
  void _interceptVehicle() {
    final alert = widget.viewModel.selectedAlert;
    if (alert != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Iniciando interceptação de ${alert.placa}...'),
          backgroundColor: context.colorTheme.bgBrand,
        ),
      );
    }
  }

  /// Mostra detalhes do veículo
  void _showVehicleDetails() {
    final alert = widget.viewModel.selectedAlert;
    if (alert != null) {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: context.colorTheme.bgNeutralSecondaryStrongest,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
        builder: (context) => DraggableScrollableSheet(
          initialChildSize: 0.7,
          minChildSize: 0.5,
          maxChildSize: 0.95,
          expand: false,
          builder: (context, scrollController) => SingleChildScrollView(
            controller: scrollController,
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 48,
                    height: 6,
                    decoration: BoxDecoration(
                      color: context.colorTheme.bgGray,
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  alert.nomeCompleto,
                  style: context.customTextTheme.text2xlBold.copyWith(
                    color: context.colorTheme.fgHeading,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Placa: ${alert.placa}',
                  style: context.customTextTheme.textLg.copyWith(
                    color: context.colorTheme.fgBodySubtle,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Cor: ${alert.cor}',
                  style: context.customTextTheme.textBase.copyWith(
                    color: context.colorTheme.fgBodySubtle,
                  ),
                ),
                const SizedBox(height: 16),
                _DetailRow(
                  icon: Icons.warning_amber_rounded,
                  label: 'Status',
                  value: alert.tipo.label,
                  valueColor: context.colorTheme.fgDanger,
                ),
                _DetailRow(
                  icon: Icons.straighten,
                  label: 'Distância',
                  value: alert.distanciaFormatada,
                ),
                _DetailRow(
                  icon: Icons.schedule,
                  label: 'Detectado',
                  value: alert.tempoDesdeDeteccao,
                ),
                _DetailRow(
                  icon: Icons.access_time,
                  label: 'Hora',
                  value: alert.horaFormatada,
                ),
              ],
            ),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListenableBuilder(
        listenable: Listenable.merge([
          widget.viewModel,
          widget.viewModel.loadAlerts,
          widget.viewModel.loadUserLocation,
        ]),
        builder: (context, _) {
          // Estado Loading
          if (widget.viewModel.loadAlerts.running &&
              widget.viewModel.alerts.isEmpty) {
            return Container(
              color: context.colorTheme.bgNeutralSecondaryStrongest,
              child: const Center(
                child: CupertinoActivityIndicator(radius: 16),
              ),
            );
          }

          // Estado de Erro
          if (widget.viewModel.loadAlerts.error) {
            return Container(
              color: context.colorTheme.bgNeutralSecondaryStrongest,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.error_outline,
                        size: 48,
                        color: context.colorTheme.fgDanger,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Erro ao carregar mapa',
                        style: context.customTextTheme.textLgBold.copyWith(
                          color: context.colorTheme.fgHeading,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        widget.viewModel.loadAlerts.errorMessage ??
                            'Tente novamente',
                        style: context.customTextTheme.textBase.copyWith(
                          color: context.colorTheme.fgBodySubtle,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton(
                        onPressed: () => widget.viewModel.loadAlerts.execute(),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: context.colorTheme.bgBrand,
                        ),
                        child: Text(
                          'Tentar novamente',
                          style: context.customTextTheme.textBaseMedium
                              .copyWith(
                                color: context.colorTheme.bgNeutralPrimary,
                              ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }

          // Estado Success - Mapa com overlay
          return Stack(
            children: [
              // Mapa em tela cheia
              _buildMap(context),

              // Gradiente para legibilidade
              _buildGradientOverlay(context),

              // Top Bar
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: PatrolMapTopBar(
                  searchController: _searchController,
                  isOnline: widget.viewModel.isOnline,
                  onMenuPressed: _openMenu,
                  onNotificationsPressed: _openNotifications,
                  onSearchChanged: widget.viewModel.updateSearch,
                ),
              ),

              // Chip de contexto (setor da patrulha)
              Positioned(
                top: MediaQuery.of(context).padding.top + 72,
                left: 0,
                right: 0,
                child: Center(
                  child: PatrolContextChip(
                    sector: widget.viewModel.currentSector,
                  ),
                ),
              ),

              // Controles do mapa (direita)
              Positioned(
                right: 16,
                bottom: MediaQuery.of(context).size.height * 0.4,
                child: PatrolMapControls(
                  onLayersPressed: _showLayersOptions,
                  onMyLocationPressed: widget.viewModel.goToUserLocation,
                ),
              ),

              // Bottom Sheet com alerta
              if(isShowingModalBottomSheet)
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: PatrolAlertBottomSheet(
                  alert: widget.viewModel.selectedAlert,
                  onInterceptPressed: _interceptVehicle,
                  onCardTap: _showVehicleDetails,
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  /// Constrói o widget do mapa
  Widget _buildMap(BuildContext context) {
    return GoogleMap(
      initialCameraPosition: CameraPosition(
        target: widget.viewModel.userLocation ?? _initialPosition,
        zoom: 15,
      ),
      mapType: MapType.normal,
      onMapCreated: widget.viewModel.setMapController,
      myLocationEnabled: false,
      myLocationButtonEnabled: false,
      zoomControlsEnabled: false,
      mapToolbarEnabled: false,
      compassEnabled: false,
      markers: _buildMarkers(),
      circles: _buildCircles(),
    );
  }

  /// Constrói os markers do mapa
  Set<Marker> _buildMarkers() {
    final markers = <Marker>{};

    // Marker do usuário
    final userLocation = widget.viewModel.userLocation;
    if (userLocation != null) {
      markers.add(
        Marker(
          markerId: const MarkerId('user_location'),
          position: userLocation,
          icon: BitmapDescriptor.defaultMarkerWithHue(
            BitmapDescriptor.hueAzure,
          ),
          anchor: const Offset(0.5, 0.5),
        ),
      );
    }

    // Markers dos alertas
    for (final alert in widget.viewModel.alerts) {
      markers.add(
        Marker(
          markerId: MarkerId('alert_${alert.id}'),
          position: LatLng(alert.latitude, alert.longitude),
          icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
          infoWindow: InfoWindow(
            title: '${alert.marca} ${alert.modelo}',
            snippet: '${alert.placa} - ${alert.tipo.label}',
          ),
          onTap: () => widget.viewModel.selectAlert.execute(alert.id),
        ),
      );
    }

    return markers;
  }

  /// Constrói os círculos do mapa (campo de visão do usuário)
  Set<Circle> _buildCircles() {
    final circles = <Circle>{};

    final userLocation = widget.viewModel.userLocation;
    if (userLocation != null) {
      circles.add(
        Circle(
          circleId: const CircleId('user_fov'),
          center: userLocation,
          radius: 100,
          fillColor: context.colorTheme.bgBrand.withValues(alpha: 0.1),
          strokeColor: context.colorTheme.bgBrand.withValues(alpha: 0.3),
          strokeWidth: 2,
        ),
      );
    }

    return circles;
  }

  /// Overlay de gradiente para legibilidade
  Widget _buildGradientOverlay(BuildContext context) {
    return Positioned.fill(
      child: IgnorePointer(
        child: DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                context.colorTheme.bgNeutralSecondaryStrongest.withValues(
                  alpha: 0.8,
                ),
                Colors.transparent,
                Colors.transparent,
                context.colorTheme.bgNeutralSecondaryStrongest.withValues(
                  alpha: 0.9,
                ),
              ],
              stops: const [0.0, 0.15, 0.5, 1.0],
            ),
          ),
        ),
      ),
    );
  }

  /// Estilo dark do mapa (JSON style)
  static const String _darkMapStyle = '''
[
  {
    "elementType": "geometry",
    "stylers": [{"color": "#1d2c4d"}]
  },
  {
    "elementType": "labels.text.fill",
    "stylers": [{"color": "#8ec3b9"}]
  },
  {
    "elementType": "labels.text.stroke",
    "stylers": [{"color": "#1a3646"}]
  },
  {
    "featureType": "administrative.country",
    "elementType": "geometry.stroke",
    "stylers": [{"color": "#4b6878"}]
  },
  {
    "featureType": "administrative.land_parcel",
    "elementType": "labels.text.fill",
    "stylers": [{"color": "#64779e"}]
  },
  {
    "featureType": "administrative.province",
    "elementType": "geometry.stroke",
    "stylers": [{"color": "#4b6878"}]
  },
  {
    "featureType": "landscape.man_made",
    "elementType": "geometry.stroke",
    "stylers": [{"color": "#334e87"}]
  },
  {
    "featureType": "landscape.natural",
    "elementType": "geometry",
    "stylers": [{"color": "#023e58"}]
  },
  {
    "featureType": "poi",
    "elementType": "geometry",
    "stylers": [{"color": "#283d6a"}]
  },
  {
    "featureType": "poi",
    "elementType": "labels.text.fill",
    "stylers": [{"color": "#6f9ba5"}]
  },
  {
    "featureType": "poi",
    "elementType": "labels.text.stroke",
    "stylers": [{"color": "#1d2c4d"}]
  },
  {
    "featureType": "poi.park",
    "elementType": "geometry.fill",
    "stylers": [{"color": "#023e58"}]
  },
  {
    "featureType": "poi.park",
    "elementType": "labels.text.fill",
    "stylers": [{"color": "#3C7680"}]
  },
  {
    "featureType": "road",
    "elementType": "geometry",
    "stylers": [{"color": "#304a7d"}]
  },
  {
    "featureType": "road",
    "elementType": "labels.text.fill",
    "stylers": [{"color": "#98a5be"}]
  },
  {
    "featureType": "road",
    "elementType": "labels.text.stroke",
    "stylers": [{"color": "#1d2c4d"}]
  },
  {
    "featureType": "road.highway",
    "elementType": "geometry",
    "stylers": [{"color": "#2c6675"}]
  },
  {
    "featureType": "road.highway",
    "elementType": "geometry.stroke",
    "stylers": [{"color": "#255763"}]
  },
  {
    "featureType": "road.highway",
    "elementType": "labels.text.fill",
    "stylers": [{"color": "#b0d5ce"}]
  },
  {
    "featureType": "road.highway",
    "elementType": "labels.text.stroke",
    "stylers": [{"color": "#023e58"}]
  },
  {
    "featureType": "transit",
    "elementType": "labels.text.fill",
    "stylers": [{"color": "#98a5be"}]
  },
  {
    "featureType": "transit",
    "elementType": "labels.text.stroke",
    "stylers": [{"color": "#1d2c4d"}]
  },
  {
    "featureType": "transit.line",
    "elementType": "geometry.fill",
    "stylers": [{"color": "#283d6a"}]
  },
  {
    "featureType": "transit.station",
    "elementType": "geometry",
    "stylers": [{"color": "#3a4762"}]
  },
  {
    "featureType": "water",
    "elementType": "geometry",
    "stylers": [{"color": "#0e1626"}]
  },
  {
    "featureType": "water",
    "elementType": "labels.text.fill",
    "stylers": [{"color": "#4e6d70"}]
  }
]
''';
}

/// Opção de tipo de mapa
class _MapTypeOption extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;

  const _MapTypeOption({
    required this.title,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: context.colorTheme.fgBodySubtle),
      title: Text(
        title,
        style: context.customTextTheme.textBaseMedium.copyWith(
          color: context.colorTheme.fgHeading,
        ),
      ),
      onTap: onTap,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
    );
  }
}

/// Linha de detalhe
class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color? valueColor;

  const _DetailRow({
    required this.icon,
    required this.label,
    required this.value,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, size: 20, color: context.colorTheme.fgBodySubtle),
          const SizedBox(width: 12),
          Text(
            '$label:',
            style: context.customTextTheme.textBaseMedium.copyWith(
              color: context.colorTheme.fgBodySubtle,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            value,
            style: context.customTextTheme.textBaseMedium.copyWith(
              color: valueColor ?? context.colorTheme.fgHeading,
            ),
          ),
        ],
      ),
    );
  }
}
