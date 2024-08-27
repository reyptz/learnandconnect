import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../blocs/auth/auth_bloc.dart';
import '../../../blocs/auth/auth_event.dart';
import '../../../blocs/auth/auth_state.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_textfield.dart';

class LoginScreen extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Connexion'),
      ),
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          } else if (state is AuthSuccess) {
            Navigator.pushReplacementNamed(context, '/');
          }
        },
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: [
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
              CustomButton(
                label: 'Se connecter',
                onPressed: () {
                  BlocProvider.of<AuthBloc>(context).add(
                    AuthSignIn(
                      email: _emailController.text,
                      password: _passwordController.text,
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
