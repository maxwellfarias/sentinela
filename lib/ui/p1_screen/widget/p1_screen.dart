import 'package:flutter/material.dart';
import 'package:sentinela/ui/core/extensions/build_context_extension.dart';
import 'package:sentinela/ui/core/themes/flowbite_colors.dart';
import 'componentes/breadcrumb.dart';
import 'componentes/user_model_mock.dart';
import 'componentes/users_filter_bar.dart';
import 'componentes/users_table.dart';

/// Tela de gerenciamento de usuários
///
/// Exibe uma tabela com lista de usuários, filtros e ações de CRUD.
/// Implementada seguindo os padrões do custom_screen.md.
final class P1Screen extends StatefulWidget {
  const P1Screen({super.key});

  @override
  State<P1Screen> createState() => _P1ScreenState();
}

class _P1ScreenState extends State<P1Screen> {
  // ==================== STATE ====================

  /// IDs dos usuários selecionados na tabela
  Set<int> _selectedUserIds = {};

  /// Filtros selecionados
  String? _selectedUserRole;
  String? _selectedStatus;
  String? _selectedAccountType;
  String? _selectedRating;
  String? _selectedCountry;
  String _selectedShowOnly = 'All';

  /// Lista de usuários (dados fictícios)
  List<UserMock> get _filteredUsers {
    var users = List<UserMock>.from(mockUsers);

    // Aplicar filtro "Show only"
    switch (_selectedShowOnly) {
      case 'PRO Accounts':
        users = users.where((u) => u.accountType == AccountType.pro).toList();
        break;
      case 'Admin':
        users = users.where((u) => u.role == UserRole.administrator).toList();
        break;
      case 'Moderators':
        users = users.where((u) => u.role == UserRole.moderator).toList();
        break;
      case 'Viewer':
        users = users.where((u) => u.role == UserRole.viewer).toList();
        break;
    }

    // Aplicar filtros de dropdown
    if (_selectedUserRole != null) {
      users = users
          .where((u) => u.role.displayName == _selectedUserRole)
          .toList();
    }
    if (_selectedStatus != null) {
      users = users
          .where((u) => u.status.displayName == _selectedStatus)
          .toList();
    }
    if (_selectedAccountType != null) {
      users = users
          .where((u) => u.accountType.displayName == _selectedAccountType)
          .toList();
    }
    if (_selectedCountry != null) {
      users = users.where((u) => u.country == _selectedCountry).toList();
    }

    return users;
  }

  // ==================== CALLBACKS ====================

  void _onSelectionChanged(Set<int> selectedIds) {
    setState(() {
      _selectedUserIds = selectedIds;
    });
  }

  void _onUserDetails(UserMock user) {
    _showSnackBar('Detalhes de ${user.name}');
  }

  void _onUserEdit(UserMock user) {
    _showSnackBar('Editando ${user.name}');
  }

  void _onUserDelete(UserMock user) {
    _showSnackBar('Deletando ${user.name}', isError: true);
  }

  void _onAddNewUser() {
    _showSnackBar('Adicionar novo usuário');
  }

  void _onDownloadCSV() {
    _showSnackBar('Download CSV iniciado');
  }

  void _showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError
            ? context.colorTheme.bgDanger
            : context.colorTheme.bgSuccess,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  // ==================== BUILD ====================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colorTheme.bgNeutralSecondary,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header com breadcrumb e botão Add
            _buildHeader(context),
            const SizedBox(height: 24),

            // Container principal
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: context.colorTheme.bgNeutralPrimary,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: FlowbiteColors.gray900.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Filtros
                  UsersFilterBar(
                    selectedUserRole: _selectedUserRole,
                    selectedStatus: _selectedStatus,
                    selectedAccountType: _selectedAccountType,
                    selectedRating: _selectedRating,
                    selectedCountry: _selectedCountry,
                    selectedShowOnly: _selectedShowOnly,
                    onUserRoleChanged: (value) =>
                        setState(() => _selectedUserRole = value),
                    onStatusChanged: (value) =>
                        setState(() => _selectedStatus = value),
                    onAccountTypeChanged: (value) =>
                        setState(() => _selectedAccountType = value),
                    onRatingChanged: (value) =>
                        setState(() => _selectedRating = value),
                    onCountryChanged: (value) =>
                        setState(() => _selectedCountry = value),
                    onShowOnlyChanged: (value) =>
                        setState(() => _selectedShowOnly = value),
                  ),
                  const SizedBox(height: 24),

                  // Tabela de usuários
                  UsersTable(
                    users: _filteredUsers,
                    selectedUserIds: _selectedUserIds,
                    onSelectionChanged: _onSelectionChanged,
                    onUserDetails: _onUserDetails,
                    onUserEdit: _onUserEdit,
                    onUserDelete: _onUserDelete,
                  ),
                  const SizedBox(height: 24),

                  // Footer com botão Download e contador
                  _buildFooter(context),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Breadcrumb
            Breadcrumb(
              items: [
                BreadcrumbItem(
                  label: 'Dashboard',
                  icon: Icons.home_outlined,
                  onTap: () {},
                ),
                BreadcrumbItem(label: '2022', onTap: () {}),
                const BreadcrumbItem(label: 'All Users'),
              ],
            ),
            const SizedBox(height: 8),
            // Título
            Text(
              'Users',
              style: context.customTextTheme.text2xlBold.copyWith(
                color: context.colorTheme.fgHeading,
              ),
            ),
          ],
        ),
        // Botão Add new user
        ElevatedButton.icon(
          onPressed: _onAddNewUser,
          icon: const Icon(Icons.add, size: 18),
          label: Text(
            'Add new user',
            style: context.customTextTheme.textSmSemibold.copyWith(
              color: FlowbiteColors.white,
            ),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: FlowbiteColors.blue600,
            foregroundColor: FlowbiteColors.white,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            elevation: 0,
          ),
        ),
      ],
    );
  }

  Widget _buildFooter(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Botão Download CSV
        ElevatedButton.icon(
          onPressed: _onDownloadCSV,
          icon: const Icon(Icons.download, size: 18),
          label: Text(
            'Download CSV',
            style: context.customTextTheme.textSmSemibold.copyWith(
              color: FlowbiteColors.white,
            ),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: FlowbiteColors.blue600,
            foregroundColor: FlowbiteColors.white,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            elevation: 0,
          ),
        ),
        // Total de usuários
        Text(
          'Total users: ${mockUsers.length}',
          style: context.customTextTheme.textSmMedium.copyWith(
            color: context.colorTheme.fgBodySubtle,
          ),
        ),
      ],
    );
  }
}
