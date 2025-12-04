import 'package:flutter/material.dart';
import 'package:sentinela/ui/core/extensions/build_context_extension.dart';
import 'package:sentinela/ui/core/themes/flowbite_colors.dart';
import 'user_model_mock.dart';
import 'user_role_badge.dart';
import 'user_status_badge.dart';
import 'rating_indicator.dart';
import 'user_action_menu.dart';

/// Tabela de usuários com checkbox, avatar, role, email, etc.
class UsersTable extends StatefulWidget {
  final List<UserMock> users;
  final Set<int> selectedUserIds;
  final ValueChanged<Set<int>>? onSelectionChanged;
  final ValueChanged<UserMock>? onUserDetails;
  final ValueChanged<UserMock>? onUserEdit;
  final ValueChanged<UserMock>? onUserDelete;

  const UsersTable({
    super.key,
    required this.users,
    this.selectedUserIds = const {},
    this.onSelectionChanged,
    this.onUserDetails,
    this.onUserEdit,
    this.onUserDelete,
  });

  @override
  State<UsersTable> createState() => _UsersTableState();
}

class _UsersTableState extends State<UsersTable> {
  late Set<int> _selectedIds;

  @override
  void initState() {
    super.initState();
    _selectedIds = Set.from(widget.selectedUserIds);
  }

  @override
  void didUpdateWidget(UsersTable oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedUserIds != widget.selectedUserIds) {
      _selectedIds = Set.from(widget.selectedUserIds);
    }
  }

  void _toggleSelection(int userId) {
    setState(() {
      if (_selectedIds.contains(userId)) {
        _selectedIds.remove(userId);
      } else {
        _selectedIds.add(userId);
      }
    });
    widget.onSelectionChanged?.call(_selectedIds);
  }

  void _toggleSelectAll() {
    setState(() {
      if (_selectedIds.length == widget.users.length) {
        _selectedIds.clear();
      } else {
        _selectedIds = widget.users.map((u) => u.id).toSet();
      }
    });
    widget.onSelectionChanged?.call(_selectedIds);
  }

  @override
  Widget build(BuildContext context) {
    final allSelected =
        _selectedIds.length == widget.users.length && widget.users.isNotEmpty;

    return Container(
      decoration: BoxDecoration(
        color: context.colorTheme.bgNeutralPrimary,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: context.colorTheme.borderDefault),
      ),
      child: Column(
        children: [
          // Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: context.colorTheme.bgNeutralSecondary,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(8),
                topRight: Radius.circular(8),
              ),
            ),
            child: Row(
              children: [
                _buildHeaderCheckbox(context, allSelected),
                _buildHeaderCell(context, 'USER', flex: 3),
                _buildHeaderCell(context, 'USER ROLE', flex: 2, sortable: true),
                _buildHeaderCell(context, 'EMAIL', flex: 3),
                _buildHeaderCell(
                  context,
                  'ACCOUNT TYPE',
                  flex: 2,
                  sortable: true,
                ),
                _buildHeaderCell(context, 'RATING', flex: 1, sortable: true),
                _buildHeaderCell(context, 'COUNTRY', flex: 2),
                _buildHeaderCell(context, 'STATUS', flex: 2, sortable: true),
                _buildHeaderCell(context, 'ACTION', flex: 1),
              ],
            ),
          ),
          // Rows
          ...widget.users.map((user) => _buildUserRow(context, user)),
        ],
      ),
    );
  }

  Widget _buildHeaderCheckbox(BuildContext context, bool allSelected) {
    return SizedBox(
      width: 40,
      child: Checkbox(
        value: allSelected,
        onChanged: (_) => _toggleSelectAll(),
        activeColor: FlowbiteColors.blue600,
        side: BorderSide(color: context.colorTheme.borderDefault),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
      ),
    );
  }

  Widget _buildHeaderCell(
    BuildContext context,
    String label, {
    int flex = 1,
    bool sortable = false,
  }) {
    return Expanded(
      flex: flex,
      child: Row(
        children: [
          Text(
            label,
            style: context.customTextTheme.textXsSemibold.copyWith(
              color: context.colorTheme.fgBodySubtle,
              letterSpacing: 0.5,
            ),
          ),
          if (sortable) ...[
            const SizedBox(width: 4),
            Icon(
              Icons.unfold_more,
              size: 14,
              color: context.colorTheme.fgBodySubtle,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildUserRow(BuildContext context, UserMock user) {
    final isSelected = _selectedIds.contains(user.id);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: isSelected
            ? FlowbiteColors.blue50
            : context.colorTheme.bgNeutralPrimary,
        border: Border(
          bottom: BorderSide(color: context.colorTheme.borderDefault),
        ),
      ),
      child: Row(
        children: [
          // Checkbox
          SizedBox(
            width: 40,
            child: Checkbox(
              value: isSelected,
              onChanged: (_) => _toggleSelection(user.id),
              activeColor: FlowbiteColors.blue600,
              side: BorderSide(color: context.colorTheme.borderDefault),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
          // User (Avatar + Name)
          Expanded(
            flex: 3,
            child: Row(
              children: [
                CircleAvatar(
                  radius: 18,
                  backgroundImage: NetworkImage(user.avatarUrl),
                  onBackgroundImageError: (_, __) {},
                  backgroundColor: FlowbiteColors.gray200,
                  child: Text(
                    user.name.substring(0, 1),
                    style: context.customTextTheme.textSmSemibold.copyWith(
                      color: FlowbiteColors.gray600,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Flexible(
                  child: Text(
                    user.name,
                    style: context.customTextTheme.textSmSemibold.copyWith(
                      color: context.colorTheme.fgHeading,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          // User Role
          Expanded(flex: 2, child: UserRoleBadge(role: user.role)),
          // Email
          Expanded(
            flex: 3,
            child: Text(
              user.email,
              style: context.customTextTheme.textSm.copyWith(
                color: context.colorTheme.fgBodySubtle,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          // Account Type
          Expanded(
            flex: 2,
            child: Text(
              user.accountType.displayName,
              style: context.customTextTheme.textSmMedium.copyWith(
                color: context.colorTheme.fgBody,
              ),
            ),
          ),
          // Rating
          Expanded(flex: 1, child: RatingIndicator(rating: user.rating)),
          // Country
          Expanded(
            flex: 2,
            child: Text(
              user.country,
              style: context.customTextTheme.textSm.copyWith(
                color: context.colorTheme.fgBody,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          // Status
          Expanded(flex: 2, child: UserStatusBadge(status: user.status)),
          // Action
          Expanded(
            flex: 1,
            child: UserActionMenu(
              user: user,
              onDetails: () => widget.onUserDetails?.call(user),
              onEdit: () => widget.onUserEdit?.call(user),
              onDelete: () => widget.onUserDelete?.call(user),
            ),
          ),
        ],
      ),
    );
  }
}
