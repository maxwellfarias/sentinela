import 'package:flutter/material.dart';
import 'package:w3_diploma/ui/core/extensions/build_context_extension.dart';

/// Dropdown customizado com funcionalidade de busca
///
/// Este componente permite ao usuário selecionar um item de uma lista
/// filtrando os itens através de um campo de busca.
///
/// Tipo genérico [T] representa o tipo do item a ser selecionado.
class SearchableDropdown<T> extends StatefulWidget {
  /// Controller para gerenciar o valor selecionado
  final ValueNotifier<T?> controller;

  /// Label do campo
  final String label;

  /// Lista de itens disponíveis para seleção
  final List<T> items;

  /// Função para converter o item em uma string exibível
  final String Function(T) itemAsString;

  /// Função para extrair o ID do item (usado para comparação)
  final dynamic Function(T) itemId;

  /// Placeholder do campo de busca
  final String? searchHint;

  /// Indica se o campo é obrigatório
  final bool isRequired;

  /// Função de validação personalizada
  final String? Function(T?)? validator;

  /// Callback quando um item é selecionado
  final void Function(T?)? onChanged;

  const SearchableDropdown({
    super.key,
    required this.controller,
    required this.label,
    required this.items,
    required this.itemAsString,
    required this.itemId,
    this.searchHint,
    this.isRequired = false,
    this.validator,
    this.onChanged,
  });

  @override
  State<SearchableDropdown<T>> createState() => _SearchableDropdownState<T>();
}

class _SearchableDropdownState<T> extends State<SearchableDropdown<T>> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;
  List<T> _filteredItems = [];
  bool _isOpen = false;

  @override
  void initState() {
    super.initState();
    _filteredItems = widget.items;
    widget.controller.addListener(_onControllerChanged);
    _focusNode.addListener(_onFocusChanged);
  }

  @override
  void didUpdateWidget(SearchableDropdown<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Atualiza a lista de itens se ela mudou
    if (oldWidget.items != widget.items) {
      setState(() {
        _filteredItems = widget.items;
      });
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    _focusNode.dispose();
    widget.controller.removeListener(_onControllerChanged);
    _removeOverlay();
    super.dispose();
  }

  void _onControllerChanged() {
    if (mounted) setState(() {});
  }

  void _onFocusChanged() {
    if (!_focusNode.hasFocus && _isOpen) {
      // Adiciona um pequeno delay para permitir que o onTap seja processado primeiro
      Future.delayed(const Duration(milliseconds: 150), () {
        if (mounted && _isOpen) {
          _closeDropdown();
        }
      });
    }
  }

  void _toggleDropdown() {
    if (_isOpen) {
      _closeDropdown();
    } else {
      _openDropdown();
    }
  }

  void _openDropdown() {
    _overlayEntry = _createOverlayEntry();
    Overlay.of(context).insert(_overlayEntry!);
    setState(() => _isOpen = true);
    _focusNode.requestFocus();
  }

  void _closeDropdown() {
    _removeOverlay();
    setState(() {
      _isOpen = false;
      _searchController.clear();
      _filteredItems = widget.items;
    });
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  void _filterItems(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredItems = widget.items;
      } else {
        final lowerQuery = query.toLowerCase();
        _filteredItems = widget.items.where((item) {
          return widget.itemAsString(item).toLowerCase().contains(lowerQuery);
        }).toList();
      }
    });
    // Atualiza o overlay
    _overlayEntry?.markNeedsBuild();
  }

  void _selectItem(T item) {
    widget.controller.value = item;
    widget.onChanged?.call(item);
    _closeDropdown();
  }

  OverlayEntry _createOverlayEntry() {
    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;
    final offset = renderBox.localToGlobal(Offset.zero);

    return OverlayEntry(
      builder: (overlayContext) => GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          // Fecha o dropdown ao clicar fora
          _closeDropdown();
        },
        child: Stack(
          children: [
            // Área transparente que captura cliques fora do dropdown
            Positioned.fill(
              child: Container(
                color: Colors.transparent,
              ),
            ),
            // O dropdown em si
            Positioned(
              left: offset.dx,
              top: offset.dy + size.height + 4,
              width: size.width,
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: () {
                  // Previne que cliques dentro do dropdown o fechem
                },
                child: Material(
                  elevation: 8,
                  borderRadius: BorderRadius.circular(8),
                  color: context.customColorTheme.background,
                  child: Container(
                    constraints: const BoxConstraints(maxHeight: 300),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: context.customColorTheme.border,
                        width: 1,
                      ),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Campo de busca
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextField(
                            controller: _searchController,
                            focusNode: _focusNode,
                            onChanged: _filterItems,
                            style: context.customTextTheme.textSm.copyWith(
                              color: context.customColorTheme.foreground,
                            ),
                            decoration: InputDecoration(
                              hintText: widget.searchHint ?? 'Buscar...',
                              hintStyle: context.customTextTheme.textSm.copyWith(
                                color: context.customColorTheme.mutedForeground,
                              ),
                              prefixIcon: Icon(
                                Icons.search,
                                size: 20,
                                color: context.customColorTheme.mutedForeground,
                              ),
                              suffixIcon: _searchController.text.isNotEmpty
                                  ? IconButton(
                                      icon: Icon(
                                        Icons.clear,
                                        size: 20,
                                        color: context.customColorTheme.mutedForeground,
                                      ),
                                      onPressed: () {
                                        _searchController.clear();
                                        _filterItems('');
                                      },
                                    )
                                  : null,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(6),
                                borderSide: BorderSide(
                                  color: context.customColorTheme.border,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(6),
                                borderSide: BorderSide(
                                  color: context.customColorTheme.border,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(6),
                                borderSide: BorderSide(
                                  color: context.customColorTheme.ring,
                                  width: 2,
                                ),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 8,
                              ),
                              isDense: true,
                            ),
                          ),
                        ),
                        const Divider(height: 1),
                        // Lista de itens filtrados
                        Flexible(
                          child: _filteredItems.isEmpty
                              ? Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Text(
                                    'Nenhum item encontrado',
                                    style: context.customTextTheme.textSm.copyWith(
                                      color: context.customColorTheme.mutedForeground,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                )
                              : ListView.builder(
                                  shrinkWrap: true,
                                  padding: EdgeInsets.zero,
                                  itemCount: _filteredItems.length,
                                  itemBuilder: (context, index) {
                                    final item = _filteredItems[index];
                                    final isSelected = widget.controller.value != null &&
                                        widget.itemId(item) ==
                                            widget.itemId(widget.controller.value as T);

                                    return Material(
                                      color: Colors.transparent,
                                      child: InkWell(
                                        onTap: () {
                                          // Remove o foco do campo de busca antes de selecionar
                                          _focusNode.unfocus();
                                          _selectItem(item);
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 16,
                                            vertical: 12,
                                          ),
                                          decoration: BoxDecoration(
                                            color: isSelected
                                                ? context.customColorTheme.primary
                                                    .withValues(alpha: 0.1)
                                                : null,
                                          ),
                                          child: Row(
                                            children: [
                                              Expanded(
                                                child: Text(
                                                  widget.itemAsString(item),
                                                  style: context.customTextTheme.textSm
                                                      .copyWith(
                                                    color: isSelected
                                                        ? context.customColorTheme.primary
                                                        : context.customColorTheme.foreground,
                                                    fontWeight: isSelected
                                                        ? FontWeight.w600
                                                        : FontWeight.normal,
                                                  ),
                                                ),
                                              ),
                                              if (isSelected)
                                                Icon(
                                                  Icons.check,
                                                  size: 20,
                                                  color: context.customColorTheme.primary,
                                                ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: ValueListenableBuilder<T?>(
        valueListenable: widget.controller,
        builder: (context, selectedValue, _) {
          final displayText = selectedValue != null
              ? widget.itemAsString(selectedValue)
              : 'Selecione ${widget.label}';

          return FormField<T>(
            initialValue: selectedValue,
            validator: (_) => widget.validator?.call(widget.controller.value),
            autovalidateMode: AutovalidateMode.onUserInteraction,
            builder: (formFieldState) {
              // Atualiza o valor do FormField quando o controller mudar
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (formFieldState.value != widget.controller.value) {
                  formFieldState.didChange(widget.controller.value);
                }
              });

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InkWell(
                    onTap: _toggleDropdown,
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: context.customColorTheme.background,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: formFieldState.hasError
                              ? context.customColorTheme.destructive
                              : _isOpen
                                  ? context.customColorTheme.ring
                                  : context.customColorTheme.border,
                          width: _isOpen ? 2 : 1,
                        ),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${widget.label}${widget.isRequired ? ' *' : ''}',
                                  style: context.customTextTheme.textXs.copyWith(
                                    color: context.customColorTheme.mutedForeground,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  displayText,
                                  style: context.customTextTheme.textSm.copyWith(
                                    color: selectedValue != null
                                        ? context.customColorTheme.foreground
                                        : context.customColorTheme.mutedForeground,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                          Icon(
                            _isOpen ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                            color: context.customColorTheme.mutedForeground,
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (formFieldState.hasError)
                    Padding(
                      padding: const EdgeInsets.only(left: 16, top: 8),
                      child: Text(
                        formFieldState.errorText ?? '',
                        style: context.customTextTheme.textXs.copyWith(
                          color: context.customColorTheme.destructive,
                        ),
                      ),
                    ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
