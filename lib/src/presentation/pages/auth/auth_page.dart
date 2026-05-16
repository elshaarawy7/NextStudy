import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/gradient_scaffold.dart';
import '../../blocs/auth/auth_bloc.dart';
import '../../widgets/section_card.dart';
import '../home/home_page.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController(text: 'student@nexstudy.ai');
  final _passwordController = TextEditingController(text: '123456');
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submit(BuildContext context, bool isLogin) {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    context.read<AuthBloc>().add(
      AuthSubmitted(
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state.status == AuthStatus.authenticated) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (_) => const HomePage()),
          );
        }
        if (state.errorMessage != null && state.status == AuthStatus.failure) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(state.errorMessage!)));
        }
      },
      child: GradientScaffold(
        body: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 32),
                  Container(
                    height: 64,
                    width: 64,
                    decoration: BoxDecoration(
                      gradient: AppTheme.heroGradient(),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Icon(
                      Icons.school_rounded,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    state.isLogin
                        ? 'Welcome back to smarter studying'
                        : 'Create your study copilot',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Upload lectures, generate clear notes, and review faster with AI study flows.',
                    style: Theme.of(
                      context,
                    ).textTheme.bodyLarge?.copyWith(color: AppTheme.muted),
                  ),
                  const SizedBox(height: 28),
                  SectionCard(
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          if (!state.isLogin) ...[
                            TextFormField(
                              controller: _nameController,
                              validator: (value) =>
                                  value == null || value.isEmpty
                                  ? 'Enter your name'
                                  : null,
                              decoration: const InputDecoration(
                                hintText: 'Full name',
                              ),
                            ),
                            const SizedBox(height: 14),
                          ],
                          TextFormField(
                            controller: _emailController,
                            keyboardType: TextInputType.emailAddress,
                            validator: (value) =>
                                value == null || !value.contains('@')
                                ? 'Enter a valid email'
                                : null,
                            decoration: const InputDecoration(
                              hintText: 'Email address',
                            ),
                          ),
                          const SizedBox(height: 14),
                          TextFormField(
                            controller: _passwordController,
                            obscureText: true,
                            validator: (value) =>
                                value == null || value.length < 6
                                ? 'Use at least 6 characters'
                                : null,
                            decoration: const InputDecoration(
                              hintText: 'Password',
                            ),
                          ),
                          const SizedBox(height: 18),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: state.status == AuthStatus.loading
                                  ? null
                                  : () => _submit(context, state.isLogin),
                              child: Text(
                                state.status == AuthStatus.loading
                                    ? 'Please wait...'
                                    : state.isLogin
                                    ? 'Login'
                                    : 'Create account',
                              ),
                            ),
                          ),
                          const SizedBox(height: 18),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                state.isLogin
                                    ? 'New to NexStudy?'
                                    : 'Already have an account?',
                              ),
                              TextButton(
                                onPressed: () => context.read<AuthBloc>().add(
                                  AuthModeChanged(!state.isLogin),
                                ),
                                child: Text(
                                  state.isLogin ? 'Register' : 'Login',
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
