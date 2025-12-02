import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:sentinela/ui/core/extensions/build_context_extension.dart';
import 'package:sentinela/ui/p1_screen/viewmodel/event_viewmodel.dart';
import 'package:sentinela/ui/p1_screen/widget/componentes/event_card.dart';
import 'package:sentinela/ui/p1_screen/widget/componentes/event_table_header.dart';
import 'package:sentinela/ui/p1_screen/widget/componentes/filter_bar.dart';
import 'package:sentinela/ui/p1_screen/widget/componentes/pagination_bar.dart';

final class P1Screen extends StatefulWidget {
  final EventViewModel viewModel;

  const P1Screen({Key? key, required this.viewModel}) : super(key: key);

  @override
  State<P1Screen> createState() => _P1ScreenState();
}

class _P1ScreenState extends State<P1Screen> {
  final Set<int> _selectedEventIds = {};
  bool _allSelected = false;

  @override
  void initState() {
    super.initState();
    // LISTENERS OBRIGATÓRIOS PARA 3 COMMANDS
    widget.viewModel.updateEvent.addListener(
      () => _onResult(
        command: widget.viewModel.updateEvent,
        successMessage: 'Evento atualizado com sucesso!',
      ),
    );
    widget.viewModel.deleteEvent.addListener(
      () => _onResult(
        command: widget.viewModel.deleteEvent,
        successMessage: 'Evento excluído com sucesso!',
      ),
    );
    widget.viewModel.createEvent.addListener(
      () => _onResult(
        command: widget.viewModel.createEvent,
        successMessage: 'Evento criado com sucesso!',
      ),
    );
    // EXECUTAR GET ALL OBRIGATÓRIO
    widget.viewModel.getAllEvents.execute();
  }

  @override
  void dispose() {
    // DISPOSE DE TODOS OS LISTENERS OBRIGATÓRIO
    widget.viewModel.updateEvent.removeListener(
      () => _onResult(
        command: widget.viewModel.updateEvent,
        successMessage: 'Evento atualizado com sucesso!',
      ),
    );
    widget.viewModel.deleteEvent.removeListener(
      () => _onResult(
        command: widget.viewModel.deleteEvent,
        successMessage: 'Evento excluído com sucesso!',
      ),
    );
    widget.viewModel.createEvent.removeListener(
      () => _onResult(
        command: widget.viewModel.createEvent,
        successMessage: 'Evento criado com sucesso!',
      ),
    );
    super.dispose();
  }

  /// MÉTODO _onResult OBRIGATÓRIO PARA FEEDBACK VISUAL
  void _onResult({required dynamic command, required String successMessage}) {
    if (command.error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Erro: ${command.errorMessage ?? 'Ocorreu um erro desconhecido.'}',
          ),
          backgroundColor: context.customColorTheme.destructive,
        ),
      );
    } else if (command.completed) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(successMessage),
          backgroundColor: context.customColorTheme.success,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.customColorTheme.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Breadcrumb
              _buildBreadcrumb(),
              const SizedBox(height: 16),

              // Header com título e ações
              _buildHeader(),
              const SizedBox(height: 24),

              // Card principal com tabela
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                    color: context.customColorTheme.card,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: context.customColorTheme.border),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      // Filtros
                      FilterBar(
                        currentFilter: widget.viewModel.currentFilter,
                        onFilterChanged: (filter) {
                          widget.viewModel.updateFilter(filter);
                        },
                        onMoreOptions: () {
                          // TODO: Implementar modal de filtros avançados
                        },
                        onActions: () {
                          // TODO: Implementar menu de ações
                        },
                      ),

                      // Conteúdo com estados
                      Expanded(
                        child: ListenableBuilder(
                          listenable: Listenable.merge([
                            widget.viewModel,
                            widget.viewModel.getAllEvents,
                          ]),
                          builder: (context, _) {
                            /// ESTADO LOADING OBRIGATÓRIO
                            if (widget.viewModel.getAllEvents.running) {
                              return Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const CupertinoActivityIndicator(
                                      radius: 20,
                                    ),
                                    const SizedBox(height: 16),
                                    Text(
                                      'Carregando eventos...',
                                      style: context.customTextTheme.textBase
                                          .copyWith(
                                            color: context
                                                .customColorTheme
                                                .mutedForeground,
                                          ),
                                    ),
                                  ],
                                ),
                              );
                            }

                            /// ESTADO ERROR OBRIGATÓRIO
                            if (widget.viewModel.getAllEvents.error) {
                              return Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(24.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.error_outline,
                                        size: 64,
                                        color: context
                                            .customColorTheme
                                            .destructive,
                                      ),
                                      const SizedBox(height: 16),
                                      Text(
                                        'Erro ao carregar eventos',
                                        style: context
                                            .customTextTheme
                                            .textLgSemibold
                                            .copyWith(
                                              color: context
                                                  .customColorTheme
                                                  .foreground,
                                            ),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        widget
                                                .viewModel
                                                .getAllEvents
                                                .errorMessage ??
                                            'Ocorreu um erro desconhecido',
                                        style: context.customTextTheme.textBase
                                            .copyWith(
                                              color: context
                                                  .customColorTheme
                                                  .mutedForeground,
                                            ),
                                        textAlign: TextAlign.center,
                                      ),
                                      const SizedBox(height: 24),
                                      ElevatedButton.icon(
                                        onPressed: () {
                                          widget.viewModel.getAllEvents
                                              .execute();
                                        },
                                        icon: const Icon(Icons.refresh),
                                        label: const Text('Tentar novamente'),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                              context.customColorTheme.primary,
                                          foregroundColor: context
                                              .customColorTheme
                                              .primaryForeground,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }

                            /// ESTADO EMPTY OBRIGATÓRIO
                            if (widget.viewModel.events.isEmpty) {
                              return Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(24.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.event_busy,
                                        size: 64,
                                        color: context
                                            .customColorTheme
                                            .mutedForeground,
                                      ),
                                      const SizedBox(height: 16),
                                      Text(
                                        'Nenhum evento encontrado',
                                        style: context
                                            .customTextTheme
                                            .textLgMedium
                                            .copyWith(
                                              color: context
                                                  .customColorTheme
                                                  .foreground,
                                            ),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        'Crie um novo evento para começar',
                                        style: context.customTextTheme.textBase
                                            .copyWith(
                                              color: context
                                                  .customColorTheme
                                                  .mutedForeground,
                                            ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }

                            /// ESTADO SUCCESS - LISTA DE DADOS
                            return Column(
                              children: [
                                // Header da tabela
                                EventTableHeader(
                                  allSelected: _allSelected,
                                  onSelectAll: (value) {
                                    setState(() {
                                      _allSelected = value ?? false;
                                      if (_allSelected) {
                                        _selectedEventIds.addAll(
                                          widget.viewModel.events.map(
                                            (e) => e.id,
                                          ),
                                        );
                                      } else {
                                        _selectedEventIds.clear();
                                      }
                                    });
                                  },
                                  onSort: (column) {
                                    // TODO: Implementar ordenação
                                  },
                                ),

                                // Lista de eventos
                                Expanded(
                                  child: ListView.builder(
                                    itemCount: widget.viewModel.events.length,
                                    itemBuilder: (context, index) {
                                      final event =
                                          widget.viewModel.events[index];
                                      final isSelected = _selectedEventIds
                                          .contains(event.id);

                                      return EventCard(
                                        event: event,
                                        isSelected: isSelected,
                                        onCheckboxChanged: (value) {
                                          setState(() {
                                            if (value ?? false) {
                                              _selectedEventIds.add(event.id);
                                            } else {
                                              _selectedEventIds.remove(
                                                event.id,
                                              );
                                            }
                                            _allSelected =
                                                _selectedEventIds.length ==
                                                widget.viewModel.events.length;
                                          });
                                        },
                                        onEdit: () {
                                          // TODO: Implementar edição
                                        },
                                        onPreview: () {
                                          // TODO: Implementar preview
                                        },
                                        onDelete: () {
                                          _showDeleteConfirmation(event.id);
                                        },
                                      );
                                    },
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ),

                      // Paginação
                      ListenableBuilder(
                        listenable: widget.viewModel,
                        builder: (context, _) {
                          return PaginationBar(
                            currentPage: widget.viewModel.currentPage,
                            totalPages: widget.viewModel.totalPages,
                            totalRecords: widget.viewModel.totalRecords,
                            pageSize: widget.viewModel.pageSize,
                            onPreviousPage: () {
                              widget.viewModel.goToPreviousPage();
                            },
                            onNextPage: () {
                              widget.viewModel.goToNextPage();
                            },
                            onPageSelected: (page) {
                              widget.viewModel.goToPage(page);
                            },
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBreadcrumb() {
    return Row(
      children: [
        Text(
          'Home',
          style: context.customTextTheme.textSm.copyWith(
            color: context.customColorTheme.mutedForeground,
          ),
        ),
        Icon(
          Icons.chevron_right,
          size: 16,
          color: context.customColorTheme.mutedForeground,
        ),
        Text(
          'Events',
          style: context.customTextTheme.textSm.copyWith(
            color: context.customColorTheme.mutedForeground,
          ),
        ),
        Icon(
          Icons.chevron_right,
          size: 16,
          color: context.customColorTheme.mutedForeground,
        ),
        Text(
          'All events',
          style: context.customTextTheme.textSmMedium.copyWith(
            color: context.customColorTheme.foreground,
          ),
        ),
      ],
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Text(
              'All Events',
              style: context.customTextTheme.text3xlBold.copyWith(
                color: context.customColorTheme.foreground,
              ),
            ),
            const SizedBox(width: 12),
            Text(
              '${widget.viewModel.totalRecords} results',
              style: context.customTextTheme.textBase.copyWith(
                color: context.customColorTheme.mutedForeground,
              ),
            ),
            const SizedBox(width: 8),
            Icon(
              Icons.info_outline,
              size: 20,
              color: context.customColorTheme.mutedForeground,
            ),
          ],
        ),
        Row(
          children: [
            ElevatedButton.icon(
              onPressed: () {
                // TODO: Implementar criação de evento
              },
              icon: const Icon(Icons.add, size: 20),
              label: const Text('Create event'),
              style: ElevatedButton.styleFrom(
                backgroundColor: context.customColorTheme.primary,
                foregroundColor: context.customColorTheme.primaryForeground,
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(width: 8),
            OutlinedButton.icon(
              onPressed: () {
                // TODO: Implementar exportação
              },
              icon: const Icon(Icons.ios_share, size: 20),
              label: const Text('Export'),
              style: OutlinedButton.styleFrom(
                foregroundColor: context.customColorTheme.foreground,
                side: BorderSide(color: context.customColorTheme.border),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  void _showDeleteConfirmation(int eventId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: context.customColorTheme.card,
        title: Text(
          'Excluir evento',
          style: context.customTextTheme.textLgSemibold.copyWith(
            color: context.customColorTheme.foreground,
          ),
        ),
        content: Text(
          'Tem certeza que deseja excluir este evento? Esta ação não pode ser desfeita.',
          style: context.customTextTheme.textBase.copyWith(
            color: context.customColorTheme.mutedForeground,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(
              'Cancelar',
              style: context.customTextTheme.textSmMedium.copyWith(
                color: context.customColorTheme.mutedForeground,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              widget.viewModel.deleteEvent.execute(eventId);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: context.customColorTheme.destructive,
              foregroundColor: context.customColorTheme.destructiveForeground,
            ),
            child: const Text('Excluir'),
          ),
        ],
      ),
    );
  }
}
