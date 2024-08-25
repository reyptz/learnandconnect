import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../blocs/profile/profile_bloc.dart';
import '../../../blocs/profile/profile_event.dart';
import '../../../blocs/profile/profile_state.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_textfield.dart';

class ProfileScreen extends StatelessWidget {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mon Profil'),
      ),
      body: BlocBuilder<ProfileBloc, ProfileState>(
        builder: (context, state) {
          if (state is ProfileLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is ProfileLoaded) {
            _firstNameController.text = state.user.firstName;
            _lastNameController.text = state.user.lastName;

            return Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                children: [
                  CustomTextField(
                    label: 'Prénom',
                    controller: _firstNameController,
                  ),
                  SizedBox(height: 16),
                  CustomTextField(
                    label: 'Nom',
                    controller: _lastNameController,
                  ),
                  SizedBox(height: 16),
                  CustomButton(
                    label: 'Mettre à jour',
                    onPressed: () {
                      BlocProvider.of<ProfileBloc>(context).add(
                        UpdateUserProfile(
                          user: state.user.copyWith(
                            firstName: _firstNameController.text,
                            lastName: _lastNameController.text,
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            );
          } else {
            return Center(child: Text('Impossible de charger le profil.'));
          }
        },
      ),
    );
  }
}
