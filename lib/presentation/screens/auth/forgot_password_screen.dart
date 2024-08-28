import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../blocs/auth/auth_bloc.dart';
import '../../../blocs/auth/auth_event.dart';
import '../../../blocs/auth/auth_state.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_textfield.dart';

class ForgotPasswordScreen extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mot de passe oublié'),
      ),
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          } else if (state is PasswordResetSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Un email de réinitialisation a été envoyé.')),
            );
            // Rediriger vers la page de confirmation après l'envoi de l'email
            Navigator.pushReplacementNamed(context, '/password-reset-confirmation');
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
              CustomButton(
                label: 'Envoyer un lien de réinitialisation',
                onPressed: () {
                  BlocProvider.of<AuthBloc>(context).add(
                    AuthForgotPassword(email: _emailController.text),
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
