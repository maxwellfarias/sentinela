/// Model de militar para a tela CadastroMilitar (dados fictícios)
class PolicialMilitarModel {
  final int id;
  final String nomeGuerra;
  final Graduacao graduacao;
  final String nomeCompleto;
  final String matricula;
  final double pontosTotais;
  final String avatarUrl;

  const PolicialMilitarModel({
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
final List<PolicialMilitarModel> mockMilitares = [
  const PolicialMilitarModel(
    id: 1,
    nomeGuerra: 'Silva',
    graduacao: Graduacao.capitao,
    nomeCompleto: 'João Carlos da Silva',
    matricula: '1234567-8',
    pontosTotais: 4.7,
    avatarUrl: 'https://i.pravatar.cc/150?img=1',
  ),
  const PolicialMilitarModel(
    id: 2,
    nomeGuerra: 'Oliveira',
    graduacao: Graduacao.primeiro_tenente,
    nomeCompleto: 'Maria Fernanda Oliveira',
    matricula: '2345678-9',
    pontosTotais: 3.9,
    avatarUrl: 'https://i.pravatar.cc/150?img=5',
  ),
  const PolicialMilitarModel(
    id: 3,
    nomeGuerra: 'Santos',
    graduacao: Graduacao.segundo_tenente,
    nomeCompleto: 'Pedro Augusto Santos',
    matricula: '3456789-0',
    pontosTotais: 4.8,
    avatarUrl: 'https://i.pravatar.cc/150?img=3',
  ),
  const PolicialMilitarModel(
    id: 4,
    nomeGuerra: 'Costa',
    graduacao: Graduacao.primeiro_sargento,
    nomeCompleto: 'Ana Paula Costa Ferreira',
    matricula: '4567890-1',
    pontosTotais: 5.0,
    avatarUrl: 'https://i.pravatar.cc/150?img=9',
  ),
  const PolicialMilitarModel(
    id: 5,
    nomeGuerra: 'Pereira',
    graduacao: Graduacao.segundo_sargento,
    nomeCompleto: 'Carlos Eduardo Pereira',
    matricula: '5678901-2',
    pontosTotais: 4.2,
    avatarUrl: 'https://i.pravatar.cc/150?img=11',
  ),
  const PolicialMilitarModel(
    id: 6,
    nomeGuerra: 'Ferreira',
    graduacao: Graduacao.terceiro_sargento,
    nomeCompleto: 'Marcos Vinícius Ferreira',
    matricula: '6789012-3',
    pontosTotais: 4.5,
    avatarUrl: 'https://i.pravatar.cc/150?img=12',
  ),
  const PolicialMilitarModel(
    id: 7,
    nomeGuerra: 'Almeida',
    graduacao: Graduacao.cabo,
    nomeCompleto: 'Luciana Almeida de Souza',
    matricula: '7890123-4',
    pontosTotais: 4.1,
    avatarUrl: 'https://i.pravatar.cc/150?img=16',
  ),
  const PolicialMilitarModel(
    id: 8,
    nomeGuerra: 'Rocha',
    graduacao: Graduacao.subtenente,
    nomeCompleto: 'Roberto Carlos Rocha',
    matricula: '8901234-5',
    pontosTotais: 3.8,
    avatarUrl: 'https://i.pravatar.cc/150?img=14',
  ),
  const PolicialMilitarModel(
    id: 9,
    nomeGuerra: 'Lima',
    graduacao: Graduacao.soldado,
    nomeCompleto: 'Fernanda Lima de Castro',
    matricula: '9012345-6',
    pontosTotais: 4.8,
    avatarUrl: 'https://i.pravatar.cc/150?img=20',
  ),
  const PolicialMilitarModel(
    id: 10,
    nomeGuerra: 'Barbosa',
    graduacao: Graduacao.major,
    nomeCompleto: 'Antônio José Barbosa',
    matricula: '0123456-7',
    pontosTotais: 5.0,
    avatarUrl: 'https://i.pravatar.cc/150?img=17',
  ),
  const PolicialMilitarModel(
    id: 11,
    nomeGuerra: 'Sousa',
    graduacao: Graduacao.tenente_coronel,
    nomeCompleto: 'Beatriz Sousa Martins',
    matricula: '1234568-9',
    pontosTotais: 4.6,
    avatarUrl: 'https://i.pravatar.cc/150?img=2',
  ),
  const PolicialMilitarModel(
    id: 12,
    nomeGuerra: 'Gomes',
    graduacao: Graduacao.coronel,
    nomeCompleto: 'Diogo Gomes Cardoso',
    matricula: '2345679-0',
    pontosTotais: 4.9,
    avatarUrl: 'https://i.pravatar.cc/150?img=4',
  ),
  const PolicialMilitarModel(
    id: 13,
    nomeGuerra: 'Martins',
    graduacao: Graduacao.aspirante,
    nomeCompleto: 'Gabriela Martins Silva',
    matricula: '3456780-1',
    pontosTotais: 4.3,
    avatarUrl: 'https://i.pravatar.cc/150?img=6',
  ),
  const PolicialMilitarModel(
    id: 14,
    nomeGuerra: 'Neves',
    graduacao: Graduacao.capitao,
    nomeCompleto: 'Humberto Neves Costa',
    matricula: '4567891-2',
    pontosTotais: 4.4,
    avatarUrl: 'https://i.pravatar.cc/150?img=7',
  ),
  const PolicialMilitarModel(
    id: 15,
    nomeGuerra: 'Ribeiro',
    graduacao: Graduacao.primeiro_tenente,
    nomeCompleto: 'Isabela Ribeiro Soares',
    matricula: '5678902-3',
    pontosTotais: 4.7,
    avatarUrl: 'https://i.pravatar.cc/150?img=8',
  ),
  const PolicialMilitarModel(
    id: 16,
    nomeGuerra: 'Monteiro',
    graduacao: Graduacao.segundo_tenente,
    nomeCompleto: 'Jeferson Monteiro Lima',
    matricula: '6789013-4',
    pontosTotais: 3.9,
    avatarUrl: 'https://i.pravatar.cc/150?img=10',
  ),
  const PolicialMilitarModel(
    id: 17,
    nomeGuerra: 'Campos',
    graduacao: Graduacao.primeiro_sargento,
    nomeCompleto: 'Kátia Campos Duarte',
    matricula: '7890124-5',
    pontosTotais: 4.6,
    avatarUrl: 'https://i.pravatar.cc/150?img=13',
  ),
  const PolicialMilitarModel(
    id: 18,
    nomeGuerra: 'Vargas',
    graduacao: Graduacao.segundo_sargento,
    nomeCompleto: 'Leonardo Vargas Pereira',
    matricula: '8901235-6',
    pontosTotais: 4.2,
    avatarUrl: 'https://i.pravatar.cc/150?img=15',
  ),
  const PolicialMilitarModel(
    id: 19,
    nomeGuerra: 'Mota',
    graduacao: Graduacao.terceiro_sargento,
    nomeCompleto: 'Mariana Mota Ribeiro',
    matricula: '9012346-7',
    pontosTotais: 4.5,
    avatarUrl: 'https://i.pravatar.cc/150?img=18',
  ),
  const PolicialMilitarModel(
    id: 20,
    nomeGuerra: 'Braga',
    graduacao: Graduacao.cabo,
    nomeCompleto: 'Nuno Braga Ferreira',
    matricula: '0123457-8',
    pontosTotais: 4.0,
    avatarUrl: 'https://i.pravatar.cc/150?img=19',
  ),
  const PolicialMilitarModel(
    id: 21,
    nomeGuerra: 'Pinto',
    graduacao: Graduacao.subtenente,
    nomeCompleto: 'Olga Pinto Mendes',
    matricula: '1234569-0',
    pontosTotais: 3.7,
    avatarUrl: 'https://i.pravatar.cc/150?img=21',
  ),
  const PolicialMilitarModel(
    id: 22,
    nomeGuerra: 'Soares',
    graduacao: Graduacao.soldado,
    nomeCompleto: 'Paulo Soares Dias',
    matricula: '2345680-1',
    pontosTotais: 4.8,
    avatarUrl: 'https://i.pravatar.cc/150?img=22',
  ),
  const PolicialMilitarModel(
    id: 23,
    nomeGuerra: 'Vieira',
    graduacao: Graduacao.major,
    nomeCompleto: 'Queila Vieira Santos',
    matricula: '3456781-2',
    pontosTotais: 4.9,
    avatarUrl: 'https://i.pravatar.cc/150?img=23',
  ),
  const PolicialMilitarModel(
    id: 24,
    nomeGuerra: 'Castro',
    graduacao: Graduacao.tenente_coronel,
    nomeCompleto: 'Rafael Castro Oliveira',
    matricula: '4567892-3',
    pontosTotais: 4.7,
    avatarUrl: 'https://i.pravatar.cc/150?img=24',
  ),
  const PolicialMilitarModel(
    id: 25,
    nomeGuerra: 'Lopes',
    graduacao: Graduacao.coronel,
    nomeCompleto: 'Selena Lopes Silva',
    matricula: '5678903-4',
    pontosTotais: 5.0,
    avatarUrl: 'https://i.pravatar.cc/150?img=25',
  ),
  const PolicialMilitarModel(
    id: 26,
    nomeGuerra: 'Mendes',
    graduacao: Graduacao.aspirante,
    nomeCompleto: 'Tiago Mendes Carvalho',
    matricula: '6789014-5',
    pontosTotais: 4.4,
    avatarUrl: 'https://i.pravatar.cc/150?img=26',
  ),
  const PolicialMilitarModel(
    id: 27,
    nomeGuerra: 'Cavalcante',
    graduacao: Graduacao.capitao,
    nomeCompleto: 'Úrsula Cavalcante Rocha',
    matricula: '7890125-6',
    pontosTotais: 4.5,
    avatarUrl: 'https://i.pravatar.cc/150?img=27',
  ),
  const PolicialMilitarModel(
    id: 28,
    nomeGuerra: 'Moraes',
    graduacao: Graduacao.primeiro_tenente,
    nomeCompleto: 'Vanessa Moraes Costa',
    matricula: '8901236-7',
    pontosTotais: 4.6,
    avatarUrl: 'https://i.pravatar.cc/150?img=28',
  ),
  const PolicialMilitarModel(
    id: 29,
    nomeGuerra: 'Sena',
    graduacao: Graduacao.segundo_tenente,
    nomeCompleto: 'Wagner Sena Alves',
    matricula: '9012347-8',
    pontosTotais: 4.2,
    avatarUrl: 'https://i.pravatar.cc/150?img=29',
  ),
  const PolicialMilitarModel(
    id: 30,
    nomeGuerra: 'Fonseca',
    graduacao: Graduacao.primeiro_sargento,
    nomeCompleto: 'Ximena Fonseca Pinto',
    matricula: '0123458-9',
    pontosTotais: 4.8,
    avatarUrl: 'https://i.pravatar.cc/150?img=30',
  ),
];
