import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:school_pro/res/app_color.dart';
import 'package:school_pro/res/const_text.dart';
import 'package:easy_localization/easy_localization.dart';  // ← ADD THIS

import '../res/app_button.dart';
import '../view_model/auth_view_model/login_view_model.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isPasswordVisible = false;
  bool _rememberMe = false;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() {
    if (_formKey.currentState!.validate()) {
      print("Email: ${_emailController.text}");
      print("Password: ${_passwordController.text}");
      print("Remember Me: $_rememberMe");

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('login.login_success'.tr()),
          backgroundColor: Colors.green,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final String? role =
    ModalRoute.of(context)?.settings.arguments as String?;

    return Scaffold(
      body: Container(
        height: size.height,
        width: size.width,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColor.lightBlueColor.withOpacity(0.1),
              Colors.white,
              AppColor.lightBlueColor.withOpacity(0.05),
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  const SizedBox(height: 40),
                  _buildAnimatedLogo(),
                  const SizedBox(height: 30),
                  _buildWelcomeText(role),
                  const SizedBox(height: 30),
                  _buildLoginForm(),
                  const SizedBox(height: 20),
                  _buildRememberForgotRow(),
                  const SizedBox(height: 30),
                  _buildLoginButton(),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAnimatedLogo() {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Transform.scale(
          scale: _animationController.value,
          child: Opacity(opacity: _animationController.value, child: child),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(30),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AppColor.lightBlueColor,
              AppColor.lightBlueColor.withOpacity(0.8),
            ],
          ),
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: AppColor.lightBlueColor.withOpacity(0.4),
              blurRadius: 30,
              offset: const Offset(0, 15),
              spreadRadius: 5,
            ),
          ],
        ),
        child: const Icon(Icons.school_rounded, size: 80, color: Colors.white),
      ),
    );
  }

  Widget _buildWelcomeText(String? role) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, 30 * (1 - _animationController.value)),
          child: Opacity(opacity: _animationController.value, child: child),
        );
      },
      child: Column(
        children: [
          AppText.customText(
            'login.welcome_back'.tr(),
            size: 32,
            weight: FontWeight.bold,
            color: Colors.black87,
          ),
          const SizedBox(height: 8),
          AppText.customText(
            'login.login_as'.tr(namedArgs: {'role': role ?? ""}),
            size: 18,
            weight: FontWeight.bold,
            color: AppColor.lightBlueColor,
          ),
          const SizedBox(height: 8),
          AppText.customText(
            'login.sign_in_subtitle'.tr(),
            size: 15,
            color: Colors.grey[600]!,
          ),
        ],
      ),
    );
  }

  Widget _buildLoginForm() {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        final delay = 0.2;
        final animationValue = Curves.easeOut.transform(
          (_animationController.value - delay).clamp(0.0, 1.0) / (1.0 - delay),
        );

        return Transform.translate(
          offset: Offset(0, 30 * (1 - animationValue)),
          child: Opacity(opacity: animationValue, child: child),
        );
      },
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            // Email Field
            _buildTextField(
              controller: _emailController,
              label: 'login.email_address'.tr(),
              hint: 'login.email_hint'.tr(),
              icon: Icons.email_rounded,
              keyboardType: TextInputType.emailAddress,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'login.email_error_empty'.tr();
                }
                if (!value.contains('@')) {
                  return 'login.email_error_valid'.tr();
                }
                return null;
              },
            ),

            const SizedBox(height: 20),

            // Password Field
            _buildTextField(
              controller: _passwordController,
              label: 'login.password'.tr(),
              hint: 'login.password_hint'.tr(),
              icon: Icons.lock_rounded,
              isPassword: true,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'login.password_error_empty'.tr();
                }
                if (value.length < 6) {
                  return 'login.password_error_length'.tr();
                }
                return null;
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    bool isPassword = false,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColor.lightBlueColor.withOpacity(0.2),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColor.lightBlueColor.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        obscureText: isPassword && !_isPasswordVisible,
        keyboardType: keyboardType,
        validator: validator,
        style: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w600,
          color: Colors.black87,
        ),
        decoration: InputDecoration(
          constraints: const BoxConstraints(maxHeight: 55),
          labelText: label,
          hintText: hint,
          labelStyle: TextStyle(
            color: AppColor.lightBlueColor,
            fontWeight: FontWeight.w600,
          ),
          hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
          prefixIcon: Container(
            margin: const EdgeInsets.all(11),
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColor.lightBlueColor.withOpacity(0.2),
                  AppColor.lightBlueColor.withOpacity(0.1),
                ],
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: AppColor.lightBlueColor, size: 22),
          ),
          suffixIcon: isPassword
              ? IconButton(
            icon: Icon(
              _isPasswordVisible
                  ? Icons.visibility_rounded
                  : Icons.visibility_off_rounded,
              color: Colors.grey[600],
            ),
            onPressed: () {
              setState(() {
                _isPasswordVisible = !_isPasswordVisible;
              });
            },
          )
              : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide(color: AppColor.lightBlueColor, width: 2),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: const BorderSide(color: Colors.red, width: 2),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: const BorderSide(color: Colors.red, width: 2),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 16,
          ),
        ),
      ),
    );
  }

  Widget _buildRememberForgotRow() {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        final delay = 0.3;
        final animationValue = Curves.easeOut.transform(
          (_animationController.value - delay).clamp(0.0, 1.0) / (1.0 - delay),
        );

        return Opacity(opacity: animationValue, child: child);
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              SizedBox(
                height: 24,
                width: 24,
                child: Checkbox(
                  value: _rememberMe,
                  onChanged: (value) {
                    setState(() {
                      _rememberMe = value ?? false;
                    });
                  },
                  activeColor: AppColor.lightBlueColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(6),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              AppText.customText(
                'login.remember_me'.tr(),
                size: 14,
                color: Colors.grey[700]!,
                weight: FontWeight.w600,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLoginButton() {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        final delay = 0.4;
        final animationValue = Curves.easeOut.transform(
          (_animationController.value - delay).clamp(0.0, 1.0) / (1.0 - delay),
        );
        return Transform.scale(
          scale: animationValue,
          child: Opacity(opacity: animationValue, child: child),
        );
      },
      child: Consumer<LoginViewModel>(
        builder: (context, loginViewModel, _) {
          return AppButton(
            title: 'login.sign_in'.tr(),
            icon: Icons.arrow_forward_rounded,
            height: 50,
            radius: 20,
            loading: loginViewModel.loading,
            onTap: () {
              loginViewModel.loginApi(
                context,
                _emailController.text,
                _passwordController.text,
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildDivider() {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        final delay = 0.5;
        final animationValue = Curves.easeOut.transform(
          (_animationController.value - delay).clamp(0.0, 1.0) / (1.0 - delay),
        );

        return Opacity(opacity: animationValue, child: child);
      },
      child: Row(
        children: [
          Expanded(child: Divider(color: Colors.grey[300], thickness: 1)),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: AppText.customText(
              'login.or'.tr(),
              size: 13,
              color: Colors.grey[600]!,
              weight: FontWeight.w600,
            ),
          ),
          Expanded(child: Divider(color: Colors.grey[300], thickness: 1)),
        ],
      ),
    );
  }

  Widget _buildSocialLoginButtons() {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        final delay = 0.6;
        final animationValue = Curves.easeOut.transform(
          (_animationController.value - delay).clamp(0.0, 1.0) / (1.0 - delay),
        );

        return Transform.translate(
          offset: Offset(0, 20 * (1 - animationValue)),
          child: Opacity(opacity: animationValue, child: child),
        );
      },
      child: Row(
        children: [
          Expanded(
            child: _buildSocialButton(
              icon: Icons.g_mobiledata_rounded,
              label: 'login.google'.tr(),
              color: const Color(0xFFDB4437),
              onTap: () {},
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: _buildSocialButton(
              icon: Icons.facebook_rounded,
              label: 'login.facebook'.tr(),
              color: const Color(0xFF4267B2),
              onTap: () {},
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSocialButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Container(
      height: 55,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.3), width: 2),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.1),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, color: color, size: 28),
              const SizedBox(width: 8),
              AppText.customText(
                label,
                size: 14,
                weight: FontWeight.bold,
                color: color,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSignUpLink() {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        final delay = 0.7;
        final animationValue = Curves.easeOut.transform(
          (_animationController.value - delay).clamp(0.0, 1.0) / (1.0 - delay),
        );

        return Opacity(opacity: animationValue, child: child);
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AppText.customText(
            'login.no_account'.tr(),
            size: 14,
            color: Colors.grey[700]!,
          ),
          TextButton(
            onPressed: () {},
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
              minimumSize: const Size(0, 0),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: AppText.customText(
              'login.sign_up'.tr(),
              size: 14,
              color: AppColor.lightBlueColor,
              weight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}