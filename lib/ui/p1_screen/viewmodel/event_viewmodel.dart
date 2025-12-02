import 'package:flutter/widgets.dart';
import 'package:sentinela/domain/models/evento/event_model.dart';
import 'package:sentinela/domain/models/pagination/pagination.dart';
import '../../../utils/command.dart';
import '../../../utils/result.dart';

/// ViewModel para a tela de gerenciamento de eventos
///
/// Implementa o padrão MVVM com Command Pattern para separar a lógica de negócio
/// da interface do usuário com suporte a paginação, busca e ordenação.
final class EventViewModel extends ChangeNotifier {
  EventViewModel() {
    // Inicializa os comandos CRUD
    getAllEvents = Command0(_getAllEvents);
    createEvent = Command1(_createEvent);
    updateEvent = Command1(_updateEvent);
    deleteEvent = Command1(_deleteEvent);

    // Inicializa com dados fictícios
    _initializeMockData();
  }

  // ==================== COMMANDS ====================

  /// Comando para buscar todos os eventos com paginação
  late final Command0<PaginatedResponse<EventModel>> getAllEvents;

  /// Comando para criar um novo evento
  late final Command1<EventModel, EventModel> createEvent;

  /// Comando para atualizar um evento existente
  late final Command1<EventModel, EventModel> updateEvent;

  /// Comando para deletar um evento
  late final Command1<void, int> deleteEvent;

  // ==================== STATE ====================

  PaginatedResponse<EventModel>? _paginatedResponse;
  QueryParams _currentParams = const QueryParams(page: 1);
  String _currentFilter = 'Current year';

  // ==================== GETTERS ====================

  /// Lista de eventos da página atual
  List<EventModel> get events => _paginatedResponse?.data ?? [];

  /// Página atual
  int get currentPage => _paginatedResponse?.page ?? 1;

  /// Tamanho da página
  int get pageSize => _paginatedResponse?.pageSize ?? 10;

  /// Total de registros
  int get totalRecords => _paginatedResponse?.totalRecords ?? 0;

  /// Total de páginas
  int get totalPages => _paginatedResponse?.totalPages ?? 1;

  /// Verifica se há próxima página
  bool get hasNextPage => currentPage < totalPages;

  /// Verifica se há página anterior
  bool get hasPreviousPage => currentPage > 1;

  /// Filtro atual selecionado
  String get currentFilter => _currentFilter;

  // ==================== PRIVATE METHODS ====================

  /// Inicializa dados fictícios
  void _initializeMockData() {
    final mockEvents = [
      EventModel(
        id: 1,
        name: 'AMTech Expo',
        speakerAvatars: [
          'https://lh3.googleusercontent.com/aida-public/AB6AXuCY9fsoJPVCStUoEZTFDie1lFIo9Veb9pn0CLNVQ3Oz4Ga94N5Mj1TvENNffzaakKGQ9TUvTvBXj4JvFa0JCgbPAIJDPcSQ4mcVaTnSieAwlUIP9NVM1ySKBqHnV79Q9qnAvMwLIHMPMPU1g4AoXyvUdxiFRlBnM8QNtEESkXE9nZteJM_qXIpZvx5Wtg7r9UKiC4XT0Y9VeNbq2j-hAMcb7bWeJ-zTpQv2B6FCKh26xMbtk9Y59r5sHi3zTab0Kp70x4ESPLaRpV37',
          'https://lh3.googleusercontent.com/aida-public/AB6AXuATT6DFaHXUQDHeyfku09BXhZjZaD5RJCWeYOgbsYs0lCwo1sjAWOqIk-F0Zp9yN2VDiT-QCl3peATPgtrhgAuWwj24dpsQVXutcntg3dXStEVZZLG2MJGsRMdF0icAWmLw5-swyW6hQIJz8exWHEhnqyxIuHJbDzjd3sCUGozZ6fhoKZakVKSsn4gs-D6eNQY0RotSEfqWUmyXVlAcOe1yJwpfgEWHA9GSjGZVx0f3Ble-3Ye2ACH-U3s36jSkZMiGOE6jEcK6pZit',
        ],
        speakerCount: 7,
        remainingSeats: 148,
        totalSeats: 1023,
        googleMeetLink: 'https://meet.google.com/vek-xyz-abc',
        date: DateTime(2022, 12, 2),
        duration: '3 days',
      ),
      EventModel(
        id: 2,
        name: 'Mobilefest',
        speakerAvatars: [
          'https://lh3.googleusercontent.com/aida-public/AB6AXuBEoyt0C3QsLj0AEcXa5_2uazT3AvhBprq6ub_Uknpu1bLTvMU-MH8P_kJVc08-lxkgaJN9Cj2lJCY7v7D9mRfAsstfO5g3gLB39UXokWAjeCGBm_hXF0Phcz1ryVDvXQvKGZ0oMZ4-Sf_E959asIHixzO7XYxl3NAsNAxjxLwPlgxIzArxD74IRVllMwFGF6f-wE5dGj9BbLAizh2O6MUArMegpxZoEIKze6JSJrOs8v17KoVdH0XXA_GcUBiiogWDlZVgAD1zJ45T',
          'https://lh3.googleusercontent.com/aida-public/AB6AXuDQCSZhQnvAUm9VSL9VHyO6ubMu6sd-0OIy0WB4nz3hBsXRc0w97D6U6PcH5gaoNRfRPeCgFm26RlEYJRPZQbzg6agM8hDBVPqt9oyrH0Ec-xlVhEvSw82gFR5TEaawM4hdKumP8OXHf43sUg8DiGyShtDDga5ml57PjSGGxBbFVkTFSwYCCjY9T13VnpfB4eXftAXH87Orbwzxnh-FPku5LG_ohbKZP6N7Udl0MtZ-qbxdQPAzMU_wWPf1KM_q0YTIpyJ1bH67mxjC',
        ],
        speakerCount: 22,
        remainingSeats: 0,
        totalSeats: 2000,
        googleMeetLink: 'https://meet.google.com/vek-xyz-abc',
        date: DateTime(2022, 12, 17),
        duration: '1 day',
      ),
      EventModel(
        id: 3,
        name: 'IFEX',
        speakerAvatars: [
          'https://lh3.googleusercontent.com/aida-public/AB6AXuC1I_ipSQTSPlmlBdlQzYUay2MABvilF4_Cqo5Yjr6g1l-jC-ArhuO1_nB2xObiwc5aCeQrQBFX_1zESjP5vrbyGjHTyed4dbKOAAvqZd70zQ1wh63d41ZpbAf0rmlEB3NJYBDt7f1ce0vcNrDjP9b2DwGCDnwIZcyWNCiyEtWE8cHH2Sg919XTQI9gxD9jHqwldfDGbYJ6klrY2Wewy5uBnl4fOmoGnOWmAntSBLsk-0jH4MY5UOdpbO4ahINsrTIU3rvd_WWL4pqP',
          'https://lh3.googleusercontent.com/aida-public/AB6AXuD2WnGOYLAPgTZAN4GExJu7AYIdA8H9N1CTIJ0yupRafCnE46j5p2_1PLvSNirWxbVm9U7mtQkzSFPGaBx_pK8jcSd-EESfKaJWT8_xIfxigIytC2PTyh909itDoVBrF3EzpoWWdZs2ceuUkFTHacsQJ7mv0loQh-oilEQI6NjOeGhMqLRwUBzBw2heOdig4GCMGlaSChwX-lX6R8npCvU4BoN768zOYiKfId2sH4A1cdyC9ZkZpV1k__6BXoYkDrudHBpyYbDACoFf',
          'https://lh3.googleusercontent.com/aida-public/AB6AXuCYz5mxZgDNNSEU5ei0edV8jooLCxgGtdzfhiGExdBasIxXhS63axqlRhPCkkEhUIMRbROhZyvLasJ9ve3n7R2lcgKKbbkxfsLczE9TG1hInPRFJr4yEcutm0QaVH3CjadPVuQ4KaUwfAAoGDbDnev4FAELsrQ-qkKxrkCRKfwpUSoNWuuNLFQZl262sRA0hXia0RdDWunXSOM-ynbIYISVdip0-4tBXMOYBWv0G3tW_8EKjDEHOCjZxiOjVsX7tQBCPIQotj6GwRYg',
        ],
        speakerCount: 3,
        remainingSeats: 260,
        totalSeats: 500,
        googleMeetLink: 'https://meet.google.com/vek-xyz-abc',
        date: DateTime(2022, 11, 8),
        duration: '5 days',
      ),
      EventModel(
        id: 4,
        name: 'Bio-IT World Conference & Expo',
        speakerAvatars: [
          'https://lh3.googleusercontent.com/aida-public/AB6AXuAo4iWs0mRLxFNMjmy1HTImAbTU-WfbKBmgoBC7NruUX8AJuazC_5T4gi2sAdGrCCgQEAOY52KEtPa6Q5VaMVSuSZI70xB1l-vnjYF5iwXc8mJrTtfVJBlo7Ym2luslB4WkJqrQOvy-ylTwGuXyvXhsBH8ojLJs8xOa1WYQfEUiZUsxnh1NphdOmJ3n6trp4OK-l5wgAaiZr2Ukry8FnbXTUUZ2W8glR6NGf_iDLK2ajUKTysTKT5EqY8602WMIK9EnxmzC-rT9v9Bg',
        ],
        speakerCount: 1,
        remainingSeats: 0,
        totalSeats: 756,
        googleMeetLink: null,
        date: DateTime(2022, 11, 9),
        duration: '8 hours',
      ),
      EventModel(
        id: 5,
        name: 'Value-Based Care Summit',
        speakerAvatars: [
          'https://lh3.googleusercontent.com/aida-public/AB6AXuBINefuEO_hsAVxvIS_J9Ptj17SxJM7vY_4QSfwEL5qsHAlLXiE2JOtINWO0wJxVM-t2905Q_1KeaENlwVKnbchIAuvM3znAoh_lHBX_cM665xZTxemPCt_sB3N8L2goTeT15BWBjvrOvH0c2rFjwmnHYTnwoVo0Bm3tDzQPuYTRJe8M8hnlKcfDvSfLjskurGoWBiSx9Urq4DiISatQqZjEjptexqkKUMLufXom2eALfsLlv6RTPLI9lf9n4ZGBedKoafTpbPwfWsJ',
          'https://lh3.googleusercontent.com/aida-public/AB6AXuDvtbLHu7xHdKzmgTpVRKRCwCERnCFtFGOQzjVPSSe0VQlDUeROlJL6x_j8bDNjezT5ZSQ0O_8CrRNOVN1eOvNuV12ZqrvTRN36TxlSBQiE0X107BNgrQ5PB5Y4PbBT-ZBoczjI0fQgetKAtN5hOB0lLWE_lWE9aZDGJwriVNcvARvlC-WxzRQWr9izlnHIYiCAUzhopM6dGK3hJjCUwj-L-6tGRJJqxWvzBiWBJTSoVjaZVrukgOrowPHDuOvBPvIDC7JQfCxCYauL',
        ],
        speakerCount: 2,
        remainingSeats: 874,
        totalSeats: 889,
        googleMeetLink: 'https://meet.google.com/vek-xyz-abc',
        date: DateTime(2022, 11, 28),
        duration: '1 day',
      ),
      EventModel(
        id: 6,
        name: 'Antibody Engineering & Therapeutics',
        speakerAvatars: [
          'https://lh3.googleusercontent.com/aida-public/AB6AXuBoxvIiGj7sIt4tJVwup3TTdN6wOYG_loHTTDpnDVLiObE164Lziln4mokqYcOvBGQO1w4vfC0PX0_rNCXlC5R15faWHD0Dgvw3EFjSqOE_kX8bZNJGM07E5JpMg_O-6ceifrW829Tyxej0T0_z1yPPwSJCFuSKcA2Z_HpjfkaIHa7jI2aiGNcHTfypMFGyUd7fLs0LSanLKv_cYZMo9_abKlFzvuJZJrX-nc5E3RMVIK8NIDIg-iQJKF8CnBfr0Z-DaC6YD1LRlSVe',
          'https://lh3.googleusercontent.com/aida-public/AB6AXuB3VO9Qf7dgoBOd6R2IkxFPvSTHCWbVHqsCe5VSnbolPkU1gd8Y3x2W3QWWNsKZxOZw17rF0YII6KcuVOxahhxUrqSk5tjY7Y3tjtiLzljtBJcA0e7nfYSjphr5Q0apxvmnxVJjQwdkbNbk-ABsHIAEw00D9svcjXnH0xbsO63gztHK0ZEQc8zoXGIXcAFsQfCsnT52LrD2DibaABOPk4KzYyH5sbyEjy7toXvM_J1c7ZfFJSrxyNbbcVsb2iSF1whespXGcPYuUVJz',
        ],
        speakerCount: 2,
        remainingSeats: 359,
        totalSeats: 789,
        googleMeetLink: 'https://meet.google.com/vek-xyz-abc',
        date: DateTime(2022, 11, 23),
        duration: '1 week',
      ),
    ];

    _paginatedResponse = PaginatedResponse(
      data: mockEvents,
      page: 1,
      pageSize: 10,
      totalRecords: 1567,
      totalPages: 157,
      hasNextPage: true,
      hasPreviousPage: false,
    );
  }

  /// Busca todos os eventos com os parâmetros atuais
  Future<Result<PaginatedResponse<EventModel>>> _getAllEvents() async {
    // Simula delay de API
    await Future.delayed(const Duration(milliseconds: 500));

    // Retorna dados fictícios
    return Result.ok(_paginatedResponse!);
  }

  /// Cria um novo evento
  Future<Result<EventModel>> _createEvent(EventModel event) async {
    await Future.delayed(const Duration(milliseconds: 500));

    _paginatedResponse?.data.add(event);
    notifyListeners();
    return Result.ok(event);
  }

  /// Atualiza um evento existente
  Future<Result<EventModel>> _updateEvent(EventModel event) async {
    await Future.delayed(const Duration(milliseconds: 500));

    final index = _paginatedResponse?.data.indexWhere((e) => e.id == event.id);
    if (index != null && index != -1) {
      _paginatedResponse?.data[index] = event;
      notifyListeners();
    }
    return Result.ok(event);
  }

  /// Deleta um evento
  Future<Result<void>> _deleteEvent(int eventId) async {
    await Future.delayed(const Duration(milliseconds: 500));

    _paginatedResponse?.data.removeWhere((e) => e.id == eventId);
    notifyListeners();
    return Result.ok(null);
  }

  // ==================== PAGINATION METHODS ====================

  /// Navega para uma página específica
  void goToPage(int page) {
    if (page < 1 || page > totalPages) return;

    _currentParams = _currentParams.copyWith(page: page);
    getAllEvents.execute();
  }

  /// Vai para a próxima página
  void goToNextPage() {
    if (hasNextPage) {
      goToPage(currentPage + 1);
    }
  }

  /// Volta para a página anterior
  void goToPreviousPage() {
    if (hasPreviousPage) {
      goToPage(currentPage - 1);
    }
  }

  /// Atualiza o termo de busca e reseta para a primeira página
  void updateSearch(String searchTerm) {
    _currentParams = _currentParams.copyWith(
      search: searchTerm.isEmpty ? null : searchTerm,
      page: 1,
    );
    getAllEvents.execute();
  }

  /// Atualiza o filtro de período
  void updateFilter(String filter) {
    _currentFilter = filter;
    _currentParams = _currentParams.copyWith(page: 1);
    notifyListeners();
    getAllEvents.execute();
  }

  /// Limpa todos os filtros
  void clearAllFilters() {
    _currentParams = const QueryParams(page: 1);
    _currentFilter = 'Current year';
    getAllEvents.execute();
  }

  @override
  void dispose() {
    getAllEvents.dispose();
    createEvent.dispose();
    updateEvent.dispose();
    deleteEvent.dispose();
    super.dispose();
  }
}
