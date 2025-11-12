import 'package:flutter/material.dart';
import 'package:w3_diploma/ui/core/extensions/build_context_extension.dart';
import 'package:w3_diploma/ui/login/widget/viewmodel/login_viewmodel.dart';

/// Tela de login profissional do W3Diploma
///
/// Apresenta formulário de autenticação com campos de CPF e senha,
/// opção de manter sessão logada e design responsivo seguindo
/// a paleta de cores e tipografia do aplicativo.
class LoginScreen extends StatefulWidget {
  final LoginViewmodel viewModel;

  const LoginScreen({super.key, required this.viewModel});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();
  bool _manterConectado = false;
  bool _senhaVisivel = false;
  bool _carregando = false;

  /// Valida o formato do email
  String? _validarEmail(String? valor) {
    if (valor == null || valor.isEmpty) {
      return 'Por favor, informe o email';
    }

    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(valor)) {
      return 'Email inválido';
    }

    return null;
  }

  /// Valida o campo de senha
  String? _validarSenha(String? valor) {
    if (valor == null || valor.isEmpty) {
      return 'Por favor, informe a senha';
    }

    if (valor.length < 6) {
      return 'Senha deve ter no mínimo 6 caracteres';
    }

    return null;
  }

  @override
  void initState() {
    super.initState();
    // Adiciona listener para o comando de login
    widget.viewModel.loginCommand.addListener(_onLoginStateChanged);
  }

  @override
  void dispose() {
    widget.viewModel.loginCommand.removeListener(_onLoginStateChanged);
    _emailController.dispose();
    _senhaController.dispose();
    super.dispose();
  }

  /// Callback chamado quando o estado do login muda
  void _onLoginStateChanged() {
    if (!mounted) return;

    // Atualiza o estado de carregamento
    setState(() {
      _carregando = widget.viewModel.loginCommand.running;
    });

    // Se o comando completou com sucesso
    if (widget.viewModel.loginCommand.completed) {
      // O GoRouter vai redirecionar automaticamente via route guards
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Login realizado com sucesso!',
            style: context.customTextTheme.textSmMedium.copyWith(
              color: context.customColorTheme.successForeground,
            ),
          ),
          backgroundColor: context.customColorTheme.success,
        ),
      );
    }

    // Se o comando completou com erro
    if (widget.viewModel.loginCommand.error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            widget.viewModel.loginCommand.errorMessage ?? 'Erro ao fazer login',
            style: context.customTextTheme.textSmMedium.copyWith(
              color: context.customColorTheme.destructiveForeground,
            ),
          ),
          backgroundColor: context.customColorTheme.destructive,
        ),
      );
    }
  }

  /// Realiza o login
  Future<void> _realizarLogin() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    // Executa o comando de login
    await widget.viewModel.loginCommand.execute((
      cpf: _emailController.text,
      password: _senhaController.text,
    ));
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = context.screenSize.width;
    final isMobile = screenWidth < 768;
    final isTablet = screenWidth >= 768 && screenWidth < 1024;

    return Scaffold(
      body: Stack(
        children: [
          // Fundo com gradiente moderno
          _buildModernBackground(),

          // Conteúdo da tela
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(
                  horizontal: isMobile ? 24 : (isTablet ? 48 : 64),
                  vertical: 32,
                ),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 440),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Logo e título
                      _buildHeader(),

                      SizedBox(height: isMobile ? 40 : 56),

                      // Card de login
                      _buildLoginCard(),

                      const SizedBox(height: 24),

                      // Link de recuperação de senha
                      _buildRecuperarSenhaLink(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Constrói o fundo moderno com gradiente e elementos decorativos
  Widget _buildModernBackground() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            context.customColorTheme.background,
            context.customColorTheme.accent,
            context.customColorTheme.primaryLight.withValues(alpha: 0.3),
          ],
          stops: const [0.0, 0.5, 1.0],
        ),
      ),
      child: Stack(
        children: [
          // Círculo decorativo superior direito
          Positioned(
            top: -100,
            right: -100,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    context.customColorTheme.primary.withValues(alpha: 0.15),
                    context.customColorTheme.primary.withValues(alpha: 0.0),
                  ],
                ),
              ),
            ),
          ),

          // Círculo decorativo inferior esquerdo
          Positioned(
            bottom: -150,
            left: -150,
            child: Container(
              width: 400,
              height: 400,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    context.customColorTheme.primaryLight.withValues(
                      alpha: 0.2,
                    ),
                    context.customColorTheme.primaryLight.withValues(
                      alpha: 0.0,
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Círculo decorativo meio direito
          Positioned(
            top: 200,
            right: -80,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    context.customColorTheme.accent.withValues(alpha: 0.3),
                    context.customColorTheme.accent.withValues(alpha: 0.0),
                  ],
                ),
              ),
            ),
          ),

          // Formas geométricas sutis
          Positioned(
            top: 150,
            left: 50,
            child: Transform.rotate(
              angle: 0.5,
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  gradient: LinearGradient(
                    colors: [
                      context.customColorTheme.primary.withValues(alpha: 0.08),
                      context.customColorTheme.primary.withValues(alpha: 0.0),
                    ],
                  ),
                ),
              ),
            ),
          ),

          Positioned(
            bottom: 250,
            right: 100,
            child: Transform.rotate(
              angle: -0.3,
              child: Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  gradient: LinearGradient(
                    colors: [
                      context.customColorTheme.primaryShade.withValues(
                        alpha: 0.06,
                      ),
                      context.customColorTheme.primaryShade.withValues(
                        alpha: 0.0,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Constrói o cabeçalho com logo e título
  Widget _buildHeader() {
    return Column(
      children: [
        // Logo (ícone de diploma/certificado)
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: context.customColorTheme.primary,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: context.customColorTheme.shadowElegant,
                blurRadius: 24,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Icon(
            Icons.security,
            size: 40,
            color: context.customColorTheme.primaryForeground,
          ),
        ),

        const SizedBox(height: 24),

        // Título
        Text(
          'Sentilela',
          style: context.customTextTheme.text3xlBold.copyWith(
            color: context.customColorTheme.foreground,
          ),
          textAlign: TextAlign.center,
        ),

        const SizedBox(height: 8),

        // Subtítulo
        Text(
          'Gestão Acadêmica Inteligente',
          style: context.customTextTheme.textBaseMedium.copyWith(
            color: context.customColorTheme.mutedForeground,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  /// Constrói o card de login com formulário
  Widget _buildLoginCard() {
    return Container(
      decoration: BoxDecoration(
        color: context.customColorTheme.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: context.customColorTheme.border, width: 1),
        boxShadow: [
          BoxShadow(
            color: context.customColorTheme.shadowCard,
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(32),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Título do formulário
            Text(
              'Entrar na sua conta',
              style: context.customTextTheme.textXlSemibold.copyWith(
                color: context.customColorTheme.cardForeground,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              'Informe suas credenciais para acessar',
              style: context.customTextTheme.textSm.copyWith(
                color: context.customColorTheme.mutedForeground,
              ),
            ),

            const SizedBox(height: 32),

            // Campo Email
            _buildEmailField(),

            const SizedBox(height: 20),

            // Campo Senha
            _buildSenhaField(),

            const SizedBox(height: 16),

            // Checkbox manter conectado
            _buildManterConectadoCheckbox(),

            const SizedBox(height: 32),

            // Botão de login
            _buildLoginButton(),
          ],
        ),
      ),
    );
  }

  /// Constrói o campo de Email
  Widget _buildEmailField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Email',
          style: context.customTextTheme.textSmMedium.copyWith(
            color: context.customColorTheme.cardForeground,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _emailController,
          keyboardType: TextInputType.emailAddress,
          validator: _validarEmail,
          decoration: InputDecoration(
            hintText: 'seu@email.com',
            hintStyle: context.customTextTheme.textBase.copyWith(
              color: context.customColorTheme.mutedForeground,
            ),
            prefixIcon: Icon(
              Icons.email_outlined,
              color: context.customColorTheme.mutedForeground,
            ),
            filled: true,
            fillColor: context.customColorTheme.background,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: context.customColorTheme.border,
                width: 1,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: context.customColorTheme.border,
                width: 1,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: context.customColorTheme.ring,
                width: 2,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: context.customColorTheme.destructive,
                width: 1,
              ),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: context.customColorTheme.destructive,
                width: 2,
              ),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
          ),
          style: context.customTextTheme.textBase.copyWith(
            color: context.customColorTheme.cardForeground,
          ),
        ),
      ],
    );
  }

  /// Constrói o campo de senha
  Widget _buildSenhaField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Senha',
          style: context.customTextTheme.textSmMedium.copyWith(
            color: context.customColorTheme.cardForeground,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: _senhaController,
          obscureText: !_senhaVisivel,
          validator: _validarSenha,
          decoration: InputDecoration(
            hintText: 'Digite sua senha',
            hintStyle: context.customTextTheme.textBase.copyWith(
              color: context.customColorTheme.mutedForeground,
            ),
            prefixIcon: Icon(
              Icons.lock_outline_rounded,
              color: context.customColorTheme.mutedForeground,
            ),
            suffixIcon: IconButton(
              icon: Icon(
                _senhaVisivel
                    ? Icons.visibility_outlined
                    : Icons.visibility_off_outlined,
                color: context.customColorTheme.mutedForeground,
              ),
              onPressed: () {
                setState(() {
                  _senhaVisivel = !_senhaVisivel;
                });
              },
            ),
            filled: true,
            fillColor: context.customColorTheme.background,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: context.customColorTheme.border,
                width: 1,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: context.customColorTheme.border,
                width: 1,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: context.customColorTheme.ring,
                width: 2,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: context.customColorTheme.destructive,
                width: 1,
              ),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: context.customColorTheme.destructive,
                width: 2,
              ),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
          ),
          style: context.customTextTheme.textBase.copyWith(
            color: context.customColorTheme.cardForeground,
          ),
        ),
      ],
    );
  }

  /// Constrói o checkbox de manter conectado
  Widget _buildManterConectadoCheckbox() {
    return Row(
      children: [
        SizedBox(
          width: 20,
          height: 20,
          child: Checkbox(
            value: _manterConectado,
            onChanged: (valor) {
              setState(() {
                _manterConectado = valor ?? false;
              });
            },
            activeColor: context.customColorTheme.primary,
            side: BorderSide(
              color: context.customColorTheme.border,
              width: 1.5,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            'Manter-me conectado',
            style: context.customTextTheme.textSm.copyWith(
              color: context.customColorTheme.cardForeground,
            ),
          ),
        ),
      ],
    );
  }

  /// Constrói o botão de login
  Widget _buildLoginButton() {
    return SizedBox(
      height: 48,
      child: ElevatedButton(
        onPressed: _carregando ? null : _realizarLogin,
        style: ElevatedButton.styleFrom(
          backgroundColor: context.customColorTheme.primary,
          foregroundColor: context.customColorTheme.primaryForeground,
          disabledBackgroundColor: context.customColorTheme.muted,
          disabledForegroundColor: context.customColorTheme.mutedForeground,
          elevation: 0,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: _carregando
            ? SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    context.customColorTheme.primaryForeground,
                  ),
                ),
              )
            : Text(
                'Entrar',
                style: context.customTextTheme.textBaseMedium.copyWith(
                  color: context.customColorTheme.primaryForeground,
                ),
              ),
      ),
    );
  }

  /// Constrói o link de recuperação de senha
  Widget _buildRecuperarSenhaLink() {
    return Center(
      child: TextButton(
        onPressed: () {
          // TODO: Implementar recuperação de senha
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Funcionalidade em desenvolvimento',
                style: context.customTextTheme.textSmMedium.copyWith(
                  color: context.customColorTheme.cardForeground,
                ),
              ),
              backgroundColor: context.customColorTheme.muted,
            ),
          );
        },
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        ),
        child: Text(
          'Esqueceu sua senha?',
          style: context.customTextTheme.textSmMedium.copyWith(
            color: context.customColorTheme.primary,
          ),
        ),
      ),
    );
  }
}
