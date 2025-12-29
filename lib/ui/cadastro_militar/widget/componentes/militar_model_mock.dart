/// Model de militar para a tela CadastroMilitar (dados fictícios)
class MilitarMock {
  final int id;
  final String nomeGuerra;
  final Graduacao graduacao;
  final String nomeCompleto;
  final String matricula;
  final double pontosTotais;
  final String avatarUrl;

  const MilitarMock({
    required this.id,
    required this.nomeGuerra,
    required this.graduacao,
    required this.nomeCompleto,
    required this.matricula,
    required this.pontosTotais,
    required this.avatarUrl,
  });
}

/// Graduações militares da PM
enum Graduacao {
  soldado,
  cabo,
  terceiro_sargento,
  segundo_sargento,
  primeiro_sargento,
  subtenente,
  aspirante,
  segundo_tenente,
  primeiro_tenente,
  capitao,
  major,
  tenente_coronel,
  coronel,
}

extension GraduacaoExtension on Graduacao {
  String get displayName {
    switch (this) {
      case Graduacao.soldado:
        return 'Soldado';
      case Graduacao.cabo:
        return 'Cabo';
      case Graduacao.terceiro_sargento:
        return '3º Sargento';
      case Graduacao.segundo_sargento:
        return '2º Sargento';
      case Graduacao.primeiro_sargento:
        return '1º Sargento';
      case Graduacao.subtenente:
        return 'Subtenente';
      case Graduacao.aspirante:
        return 'Aspirante';
      case Graduacao.segundo_tenente:
        return '2º Tenente';
      case Graduacao.primeiro_tenente:
        return '1º Tenente';
      case Graduacao.capitao:
        return 'Capitão';
      case Graduacao.major:
        return 'Major';
      case Graduacao.tenente_coronel:
        return 'Ten. Coronel';
      case Graduacao.coronel:
        return 'Coronel';
    }
  }

  String get sigla {
    switch (this) {
      case Graduacao.soldado:
        return 'SD';
      case Graduacao.cabo:
        return 'CB';
      case Graduacao.terceiro_sargento:
        return '3º SGT';
      case Graduacao.segundo_sargento:
        return '2º SGT';
      case Graduacao.primeiro_sargento:
        return '1º SGT';
      case Graduacao.subtenente:
        return 'ST';
      case Graduacao.aspirante:
        return 'ASP';
      case Graduacao.segundo_tenente:
        return '2º TEN';
      case Graduacao.primeiro_tenente:
        return '1º TEN';
      case Graduacao.capitao:
        return 'CAP';
      case Graduacao.major:
        return 'MAJ';
      case Graduacao.tenente_coronel:
        return 'TEN CEL';
      case Graduacao.coronel:
        return 'CEL';
    }
  }

  /// Ordem hierárquica (maior = mais alto na hierarquia)
  int get ordemHierarquica {
    switch (this) {
      case Graduacao.soldado:
        return 1;
      case Graduacao.cabo:
        return 2;
      case Graduacao.terceiro_sargento:
        return 3;
      case Graduacao.segundo_sargento:
        return 4;
      case Graduacao.primeiro_sargento:
        return 5;
      case Graduacao.subtenente:
        return 6;
      case Graduacao.aspirante:
        return 7;
      case Graduacao.segundo_tenente:
        return 8;
      case Graduacao.primeiro_tenente:
        return 9;
      case Graduacao.capitao:
        return 10;
      case Graduacao.major:
        return 11;
      case Graduacao.tenente_coronel:
        return 12;
      case Graduacao.coronel:
        return 13;
    }
  }
}

/// Dados fictícios de militares
final List<MilitarMock> mockMilitares = [
  const MilitarMock(
    id: 1,
    nomeGuerra: 'Silva',
    graduacao: Graduacao.capitao,
    nomeCompleto: 'João Carlos da Silva',
    matricula: '1234567-8',
    pontosTotais: 4.7,
    avatarUrl: 'https://i.pravatar.cc/150?img=1',
  ),
  const MilitarMock(
    id: 2,
    nomeGuerra: 'Oliveira',
    graduacao: Graduacao.primeiro_tenente,
    nomeCompleto: 'Maria Fernanda Oliveira',
    matricula: '2345678-9',
    pontosTotais: 3.9,
    avatarUrl: 'https://i.pravatar.cc/150?img=5',
  ),
  const MilitarMock(
    id: 3,
    nomeGuerra: 'Santos',
    graduacao: Graduacao.segundo_tenente,
    nomeCompleto: 'Pedro Augusto Santos',
    matricula: '3456789-0',
    pontosTotais: 4.8,
    avatarUrl: 'https://i.pravatar.cc/150?img=3',
  ),
  const MilitarMock(
    id: 4,
    nomeGuerra: 'Costa',
    graduacao: Graduacao.primeiro_sargento,
    nomeCompleto: 'Ana Paula Costa Ferreira',
    matricula: '4567890-1',
    pontosTotais: 5.0,
    avatarUrl: 'https://i.pravatar.cc/150?img=9',
  ),
  const MilitarMock(
    id: 5,
    nomeGuerra: 'Pereira',
    graduacao: Graduacao.segundo_sargento,
    nomeCompleto: 'Carlos Eduardo Pereira',
    matricula: '5678901-2',
    pontosTotais: 4.2,
    avatarUrl: 'https://i.pravatar.cc/150?img=11',
  ),
  const MilitarMock(
    id: 6,
    nomeGuerra: 'Ferreira',
    graduacao: Graduacao.terceiro_sargento,
    nomeCompleto: 'Marcos Vinícius Ferreira',
    matricula: '6789012-3',
    pontosTotais: 4.5,
    avatarUrl: 'https://i.pravatar.cc/150?img=12',
  ),
  const MilitarMock(
    id: 7,
    nomeGuerra: 'Almeida',
    graduacao: Graduacao.cabo,
    nomeCompleto: 'Luciana Almeida de Souza',
    matricula: '7890123-4',
    pontosTotais: 4.1,
    avatarUrl: 'https://i.pravatar.cc/150?img=16',
  ),
  const MilitarMock(
    id: 8,
    nomeGuerra: 'Rocha',
    graduacao: Graduacao.subtenente,
    nomeCompleto: 'Roberto Carlos Rocha',
    matricula: '8901234-5',
    pontosTotais: 3.8,
    avatarUrl: 'https://i.pravatar.cc/150?img=14',
  ),
  const MilitarMock(
    id: 9,
    nomeGuerra: 'Lima',
    graduacao: Graduacao.soldado,
    nomeCompleto: 'Fernanda Lima de Castro',
    matricula: '9012345-6',
    pontosTotais: 4.8,
    avatarUrl: 'https://i.pravatar.cc/150?img=20',
  ),
  const MilitarMock(
    id: 10,
    nomeGuerra: 'Barbosa',
    graduacao: Graduacao.major,
    nomeCompleto: 'Antônio José Barbosa',
    matricula: '0123456-7',
    pontosTotais: 5.0,
    avatarUrl: 'https://i.pravatar.cc/150?img=17',
  ),
];
