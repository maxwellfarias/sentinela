import 'package:flutter/material.dart';
import 'package:sentinela/ui/core/extensions/build_context_extension.dart';

/// Barra de paginação para navegação entre páginas
class PaginationBar extends StatelessWidget {
  final int currentPage;
  final int totalPages;
  final int totalRecords;
  final int pageSize;
  final VoidCallback? onPreviousPage;
  final VoidCallback? onNextPage;
  final ValueChanged<int>? onPageSelected;

  const PaginationBar({
    Key? key,
    required this.currentPage,
    required this.totalPages,
    required this.totalRecords,
    required this.pageSize,
    this.onPreviousPage,
    this.onNextPage,
    this.onPageSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final startRecord = ((currentPage - 1) * pageSize) + 1;
    final endRecord = (currentPage * pageSize).clamp(1, totalRecords);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: context.customColorTheme.card,
        border: Border(
          top: BorderSide(color: context.customColorTheme.border, width: 1),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Texto de informação
          Text(
            'Showing $startRecord-$endRecord of $totalRecords',
            style: context.customTextTheme.textSm.copyWith(
              color: context.customColorTheme.mutedForeground,
            ),
          ),

          // Controles de paginação
          Row(
            children: [
              // Botão anterior
              IconButton(
                onPressed: currentPage > 1 ? onPreviousPage : null,
                icon: const Icon(Icons.chevron_left),
                style: IconButton.styleFrom(
                  backgroundColor: context.customColorTheme.card,
                  side: BorderSide(color: context.customColorTheme.border),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(8),
                      bottomLeft: Radius.circular(8),
                    ),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                ),
              ),

              // Números de página
              ..._buildPageNumbers(context),

              // Botão próximo
              IconButton(
                onPressed: currentPage < totalPages ? onNextPage : null,
                icon: const Icon(Icons.chevron_right),
                style: IconButton.styleFrom(
                  backgroundColor: context.customColorTheme.card,
                  side: BorderSide(color: context.customColorTheme.border),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(8),
                      bottomRight: Radius.circular(8),
                    ),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  List<Widget> _buildPageNumbers(BuildContext context) {
    final List<Widget> pageButtons = [];

    // Lógica para mostrar páginas (1, 2, 3, ..., última)
    if (totalPages <= 5) {
      // Mostra todas as páginas
      for (int i = 1; i <= totalPages; i++) {
        pageButtons.add(_buildPageButton(context, i));
      }
    } else {
      // Mostra: 1, 2, 3, ..., última
      pageButtons.add(_buildPageButton(context, 1));

      if (currentPage > 3) {
        pageButtons.add(_buildPageButton(context, 2));
      }

      if (currentPage == totalPages) {
        pageButtons.add(_buildPageButton(context, currentPage - 1));
      } else if (currentPage > 2 && currentPage < totalPages - 1) {
        pageButtons.add(_buildPageButton(context, currentPage));
      } else {
        pageButtons.add(_buildPageButton(context, 3));
      }

      // Ellipsis
      if (currentPage < totalPages - 2) {
        pageButtons.add(_buildEllipsis(context));
      }

      // Última página
      pageButtons.add(_buildPageButton(context, totalPages));
    }

    return pageButtons;
  }

  Widget _buildPageButton(BuildContext context, int page) {
    final isCurrentPage = page == currentPage;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 0),
      child: TextButton(
        onPressed: isCurrentPage ? null : () => onPageSelected?.call(page),
        style: TextButton.styleFrom(
          backgroundColor: isCurrentPage
              ? context.customColorTheme.primary.withOpacity(0.1)
              : context.customColorTheme.card,
          foregroundColor: isCurrentPage
              ? context.customColorTheme.primary
              : context.customColorTheme.mutedForeground,
          side: BorderSide(
            color: isCurrentPage
                ? context.customColorTheme.primary
                : context.customColorTheme.border,
          ),
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          minimumSize: const Size(40, 36),
        ),
        child: Text(
          page.toString(),
          style: context.customTextTheme.textSm.copyWith(
            color: isCurrentPage
                ? context.customColorTheme.primary
                : context.customColorTheme.mutedForeground,
            fontWeight: isCurrentPage ? FontWeight.w500 : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  Widget _buildEllipsis(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 0),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: context.customColorTheme.card,
        border: Border.all(color: context.customColorTheme.border),
      ),
      child: Text(
        '...',
        style: context.customTextTheme.textSm.copyWith(
          color: context.customColorTheme.mutedForeground,
        ),
      ),
    );
  }
}
