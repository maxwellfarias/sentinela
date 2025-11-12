sealed class AppException implements Exception {
  AppException(this.code, this.message);
  final String code;
  final String message;

  @override
  String toString() => message;
}

//MARK: Auth
class UsuarioOuSenhaInvalidoException extends AppException {
  UsuarioOuSenhaInvalidoException()
      : super('usuario-ou-senha-invalido', 'Usuário ou senha inválidos. Verifique seus dados e tente novamente.');
}

/// Sessão expirada
class SessaoExpiradaException extends AppException {
  SessaoExpiradaException()
      : super('sessao-expirada', 'Sua sessão expirou. Por favor, faça login novamente para continuar.');
}

//MARK: Rede

/// Acesso negado ao recurso solicitado.
class AcessoNegadoException extends AppException {
  AcessoNegadoException()
      : super('acesso-negado', 'Você não tem permissão para acessar este recurso.');
}

/// O dispositivo não está conectado à internet.
class SemConexaoException extends AppException {
  SemConexaoException()
      : super('sem-conexao', 'Sem conexão com a internet. Por favor, verifique sua rede e tente novamente.');
}

//MARK: Erros servidor

/// A requisição para o servidor demorou demais para responder.
class CepNaoEncontradoException extends AppException {
  CepNaoEncontradoException()
      : super('cep-nao-encontrado', 'O CEP informado não foi encontrado.');
}

class WhatsAppApiException extends AppException {
  WhatsAppApiException()
      : super('whatsapp-api-exception', 'Ocorreu um erro durante o envio da mensagem via WhatsApp. Por favor, entre em contato com o suporte.');
}

/// A requisição para o servidor demorou demais para responder.
class TimeoutDeRequisicaoException extends AppException {
  TimeoutDeRequisicaoException()
      : super('timeout-de-requisicao', 'O servidor demorou para responder. Verifique sua conexão e tente novamente.');
}

/// Erro genérico para requisições inválidas (HTTP 400).
class RequisicaoInvalidaException extends AppException {
  RequisicaoInvalidaException()
      : super('requisicao-invalida', 'A requisição enviada é inválida. Verifique os dados e tente novamente.');
}

/// Erro de não autorizado (HTTP 401).
class NaoAutorizadoException extends AppException {
  NaoAutorizadoException()
      : super('nao-autorizado', 'Você não está autorizado a realizar esta ação. Por favor, verifique suas credenciais.');
}
/// Erro de acesso proibido (HTTP 403).
class AcessoProibidoException extends AppException {
  AcessoProibidoException()
      : super('acesso-proibido', 'Você não tem permissão para acessar este recurso. Verifique suas credenciais ou entre em contato com o suporte.');
}


/// Erro genérico do servidor (HTTP 500).
class ErroInternoServidorException extends AppException {
  ErroInternoServidorException()
      : super('erro-interno-servidor', 'Ocorreu um problema no servidor. Nossa equipe já foi notificada. Tente novamente mais tarde.');
}

/// O serviço ou servidor está temporariamente indisponível (HTTP 503).
class ServidorIndisponivelException extends AppException {
  ServidorIndisponivelException()
      : super('servidor-indisponivel', 'O serviço está temporariamente indisponível. Por favor, tente novamente em alguns minutos.');
}

/// Erro genérico para quando o recurso solicitado não foi encontrado (HTTP 404).
class RecursoNaoEncontradoException extends AppException {
  RecursoNaoEncontradoException()
      : super('recurso-nao-encontrado', 'O recurso solicitado não foi encontrado. Verifique o endereço ou tente novamente mais tarde.');
}



//MARK: Exceções genéricas

class ErroDeComunicacaoException extends AppException {
  ErroDeComunicacaoException()
      : super(
          'erro-de-comunicacao',
          'Houve um problema na comunicação com nossos servidores. Por favor, tente novamente mais tarde.',
        );
} 

class UnknownErrorException extends AppException {
  UnknownErrorException()
      : super(
          'unknown-error',
          'Ocorreu um erro inesperado. Por favor, tente novamente.',
        );
}

//MARK: Storage
class ErroAoSalvarTokenException extends AppException {
  ErroAoSalvarTokenException()
      : super('erro-ao-salvar-token', 'Erro ao salvar token de autenticação. Tente novamente.');
}

class ErroAoRecuperarTokenException extends AppException {
  ErroAoRecuperarTokenException()
      : super('erro-ao-recuperar-token', 'Erro ao recuperar token de autenticação.');
}

class ErroAoLimparDadosException extends AppException {
  ErroAoLimparDadosException()
      : super('erro-ao-limpar-dados', 'Erro ao limpar dados armazenados.');
}