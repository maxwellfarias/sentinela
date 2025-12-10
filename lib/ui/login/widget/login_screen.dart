import 'package:flutter/material.dart';
import 'package:sentinela/ui/core/extensions/build_context_extension.dart';
import 'package:sentinela/ui/core/themes/flowbite_colors.dart';
import 'package:sentinela/ui/login/widget/viewmodel/login_viewmodel.dart';

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
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _rememberMe = false;
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.colorTheme.bgNeutralPrimary,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 665),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Logo Aura
                _buildLogo(),
                const SizedBox(height: 48),

                // Welcome back heading
                Text(
                  'Welcome back',
                  textAlign: TextAlign.center,
                  style: context.customTextTheme.text4xlBold.copyWith(
                    color: context.colorTheme.fgHeading,
                  ),
                ),
                const SizedBox(height: 12),

                // Subtitle
                Text(
                  'Please enter your details to sign in',
                  textAlign: TextAlign.center,
                  style: context.customTextTheme.textBase.copyWith(
                    color: context.colorTheme.fgBodySubtle,
                  ),
                ),
                const SizedBox(height: 32),

                // Social login buttons
                _buildSocialLoginButtons(),
                const SizedBox(height: 32),

                // OR divider
                _buildOrDivider(),
                const SizedBox(height: 32),

                // Email field
                _buildEmailField(),
                const SizedBox(height: 20),

                // Password field
                _buildPasswordField(),
                const SizedBox(height: 20),

                // Remember me and Forgot password
                _buildRememberMeAndForgotPassword(),
                const SizedBox(height: 32),

                // Sign in button
                _buildSignInButton(),
                const SizedBox(height: 32),

                // Sign up link
                _buildSignUpLink(),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLogo() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              colors: [
                context.colorTheme.bgBrandMedium,
                context.colorTheme.bgBrand,
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Text(
          'Aura',
          style: context.customTextTheme.text2xlBold.copyWith(
            color: context.colorTheme.fgHeading,
          ),
        ),
      ],
    );
  }

  Widget _buildSocialLoginButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildSocialButton(
          icon: Icons.g_mobiledata,
          onPressed: () {
            // Google login
          },
        ),
        const SizedBox(width: 16),
        _buildSocialButton(
          icon: Icons.apple,
          onPressed: () {
            // Apple login
          },
        ),
        const SizedBox(width: 16),
        _buildSocialButton(
          icon: Icons.close, // X icon
          onPressed: () {
            // X/Twitter login
          },
        ),
      ],
    );
  }

  Widget _buildSocialButton({
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return Container(
      width: 64,
      height: 64,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: context.colorTheme.borderDefault, width: 1),
        color: context.colorTheme.bgNeutralPrimary,
      ),
      child: IconButton(
        icon: Icon(icon, size: 28, color: context.colorTheme.fgHeading),
        onPressed: onPressed,
      ),
    );
  }

  Widget _buildOrDivider() {
    return Row(
      children: [
        Expanded(
          child: Divider(color: context.colorTheme.borderDefault, thickness: 1),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            'OR',
            style: context.customTextTheme.textSm.copyWith(
              color: context.colorTheme.fgBodySubtle,
            ),
          ),
        ),
        Expanded(
          child: Divider(color: context.colorTheme.borderDefault, thickness: 1),
        ),
      ],
    );
  }

  Widget _buildEmailField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Your Email Address',
          style: context.customTextTheme.textSmMedium.copyWith(
            color: context.colorTheme.fgHeading,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _emailController,
          keyboardType: TextInputType.emailAddress,
          style: context.customTextTheme.textBase.copyWith(
            color: context.colorTheme.fgHeading,
          ),
          decoration: InputDecoration(
            hintText: 'Your Email Address',
            hintStyle: context.customTextTheme.textBase.copyWith(
              color: context.colorTheme.fgBodySubtle,
            ),
            filled: true,
            fillColor: context.colorTheme.bgNeutralPrimary,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: context.colorTheme.borderDefault),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: context.colorTheme.borderDefault),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: context.colorTheme.borderBrandLight,
                width: 2,
              ),
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPasswordField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Password',
          style: context.customTextTheme.textSmMedium.copyWith(
            color: context.colorTheme.fgHeading,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _passwordController,
          obscureText: _obscurePassword,
          style: context.customTextTheme.textBase.copyWith(
            color: context.colorTheme.fgHeading,
          ),
          decoration: InputDecoration(
            hintText: '•••••••••',
            hintStyle: context.customTextTheme.textBase.copyWith(
              color: context.colorTheme.fgBodySubtle,
            ),
            filled: true,
            fillColor: context.colorTheme.bgNeutralPrimary,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: context.colorTheme.borderDefault),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: context.colorTheme.borderDefault),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: context.colorTheme.borderBrandLight,
                width: 2,
              ),
            ),
            suffixIcon: IconButton(
              icon: Icon(
                _obscurePassword
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined,
                color: context.colorTheme.fgBodySubtle,
              ),
              onPressed: () {
                setState(() {
                  _obscurePassword = !_obscurePassword;
                });
              },
            ),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRememberMeAndForgotPassword() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            SizedBox(
              width: 20,
              height: 20,
              child: Checkbox(
                value: _rememberMe,
                onChanged: (value) {
                  setState(() {
                    _rememberMe = value ?? false;
                  });
                },
                activeColor: context.colorTheme.bgBrand,
                side: BorderSide(
                  color: context.colorTheme.borderDefault,
                  width: 1.5,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              'Remember me',
              style: context.customTextTheme.textSm.copyWith(
                color: context.colorTheme.fgHeading,
              ),
            ),
          ],
        ),
        TextButton(
          onPressed: () {
            // Forgot password
          },
          style: TextButton.styleFrom(
            padding: EdgeInsets.zero,
            minimumSize: Size.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          child: Text(
            'Forgot password?',
            style: context.customTextTheme.textSm.copyWith(
              color: context.colorTheme.fgHeading,
              decoration: TextDecoration.underline,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSignInButton() {
    return SizedBox(
      height: 48,
      child: ElevatedButton(
        onPressed: () {
          // Sign in action
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: context.colorTheme.bgBrand,
          foregroundColor: FlowbiteColors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          elevation: 0,
        ),
        child: Text(
          'Sign in',
          style: context.customTextTheme.textBaseMedium.copyWith(
            color: FlowbiteColors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildSignUpLink() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Don't have an account? ",
          style: context.customTextTheme.textSm.copyWith(
            color: context.colorTheme.fgBodySubtle,
          ),
        ),
        TextButton(
          onPressed: () {
            // Navigate to sign up
          },
          style: TextButton.styleFrom(
            padding: EdgeInsets.zero,
            minimumSize: Size.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          child: Text(
            'Sign up',
            style: context.customTextTheme.textSmMedium.copyWith(
              color: context.colorTheme.fgHeading,
              decoration: TextDecoration.underline,
            ),
          ),
        ),
      ],
    );
  }
}
