import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../blocs/auth/auth_bloc.dart';
import '../../../blocs/auth/auth_state.dart';
import '../../../blocs/auth/auth_event.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_textfield.dart';

class RegisterScreen extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _roleController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Inscription'),
      ),
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          } else if (state is AuthSuccess) {
            Navigator.pushReplacementNamed(context, '/login');
          }
        },
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: [
              CustomTextField(
                label: 'Nom complet',
                controller: _nameController,
              ),
              SizedBox(height: 16),
              CustomTextField(
                label: 'Email',
                controller: _emailController,
              ),
              SizedBox(height: 16),
              CustomTextField(
                label: 'Mot de passe',
                controller: _passwordController,
                obscureText: true,
              ),
              SizedBox(height: 16),
              CustomTextField(
                label: 'Rôle',
                controller: _roleController,
              ),
              SizedBox(height: 16),
              CustomButton(
                label: 'S\'inscrire',
                onPressed: () {
                  // Action d'inscription avec AuthBloc
                  BlocProvider.of<AuthBloc>(context).add(
                    AuthSignUp(
                      email: _emailController.text,
                      password: _passwordController.text,
                      name: _nameController.text,
                      role: _roleController.text,
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
