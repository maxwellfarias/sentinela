/// Model de usuário para a tela P1Screen (dados fictícios)
class UserMock {
  final int id;
  final String name;
  final String email;
  final String avatarUrl;
  final UserRole role;
  final AccountType accountType;
  final double rating;
  final String country;
  final UserStatus status;

  const UserMock({
    required this.id,
    required this.name,
    required this.email,
    required this.avatarUrl,
    required this.role,
    required this.accountType,
    required this.rating,
    required this.country,
    required this.status,
  });
}

enum UserRole { administrator, moderator, viewer }

enum AccountType { pro, basic }

enum UserStatus { active, inactive }

extension UserRoleExtension on UserRole {
  String get displayName {
    switch (this) {
      case UserRole.administrator:
        return 'Administrator';
      case UserRole.moderator:
        return 'Moderator';
      case UserRole.viewer:
        return 'Viewer';
    }
  }

  String get description {
    switch (this) {
      case UserRole.administrator:
        return 'Full access to all features';
      case UserRole.moderator:
        return 'Moderators are responsible for the facilitation, review, and guidance of a discussion or a debate.';
      case UserRole.viewer:
        return 'Read-only access';
    }
  }
}

extension AccountTypeExtension on AccountType {
  String get displayName {
    switch (this) {
      case AccountType.pro:
        return 'PRO';
      case AccountType.basic:
        return 'Basic';
    }
  }
}

extension UserStatusExtension on UserStatus {
  String get displayName {
    switch (this) {
      case UserStatus.active:
        return 'Active';
      case UserStatus.inactive:
        return 'Inactive';
    }
  }
}

/// Dados fictícios de usuários
final List<UserMock> mockUsers = [
  const UserMock(
    id: 1,
    name: 'Jese Leos',
    email: 'jese@example.com',
    avatarUrl: 'https://i.pravatar.cc/150?img=1',
    role: UserRole.administrator,
    accountType: AccountType.pro,
    rating: 4.7,
    country: 'United States',
    status: UserStatus.active,
  ),
  const UserMock(
    id: 2,
    name: 'Bonnie Green',
    email: 'bonnie@example.com',
    avatarUrl: 'https://i.pravatar.cc/150?img=2',
    role: UserRole.moderator,
    accountType: AccountType.pro,
    rating: 3.9,
    country: 'United States',
    status: UserStatus.active,
  ),
  const UserMock(
    id: 3,
    name: 'Leslie Livingston',
    email: 'leslie@example.com',
    avatarUrl: 'https://i.pravatar.cc/150?img=3',
    role: UserRole.moderator,
    accountType: AccountType.pro,
    rating: 4.8,
    country: 'United States',
    status: UserStatus.inactive,
  ),
  const UserMock(
    id: 4,
    name: 'Micheal Gough',
    email: 'micheal@example.com',
    avatarUrl: 'https://i.pravatar.cc/150?img=4',
    role: UserRole.moderator,
    accountType: AccountType.basic,
    rating: 5.0,
    country: 'France',
    status: UserStatus.active,
  ),
  const UserMock(
    id: 5,
    name: 'Joseph McFall',
    email: 'joseph@example.com',
    avatarUrl: 'https://i.pravatar.cc/150?img=5',
    role: UserRole.viewer,
    accountType: AccountType.basic,
    rating: 4.2,
    country: 'England',
    status: UserStatus.active,
  ),
  const UserMock(
    id: 6,
    name: 'Robert Brown',
    email: 'robert@example.com',
    avatarUrl: 'https://i.pravatar.cc/150?img=6',
    role: UserRole.viewer,
    accountType: AccountType.basic,
    rating: 4.5,
    country: 'Canada',
    status: UserStatus.inactive,
  ),
  const UserMock(
    id: 7,
    name: 'Karen Nelson',
    email: 'karen@example.com',
    avatarUrl: 'https://i.pravatar.cc/150?img=7',
    role: UserRole.viewer,
    accountType: AccountType.pro,
    rating: 4.1,
    country: 'Canada',
    status: UserStatus.inactive,
  ),
  const UserMock(
    id: 8,
    name: 'Helene Engels',
    email: 'helene@example.com',
    avatarUrl: 'https://i.pravatar.cc/150?img=8',
    role: UserRole.moderator,
    accountType: AccountType.basic,
    rating: 3.8,
    country: 'Germany',
    status: UserStatus.active,
  ),
  const UserMock(
    id: 9,
    name: 'Lana Byrd',
    email: 'lana@example.com',
    avatarUrl: 'https://i.pravatar.cc/150?img=9',
    role: UserRole.viewer,
    accountType: AccountType.basic,
    rating: 4.8,
    country: 'Australia',
    status: UserStatus.active,
  ),
  const UserMock(
    id: 10,
    name: 'Neil Sims',
    email: 'neil@example.com',
    avatarUrl: 'https://i.pravatar.cc/150?img=10',
    role: UserRole.moderator,
    accountType: AccountType.pro,
    rating: 5.0,
    country: 'United States',
    status: UserStatus.inactive,
  ),
];
