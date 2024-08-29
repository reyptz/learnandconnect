import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../blocs/profile/profile_bloc.dart';
import '../../../blocs/profile/profile_event.dart';
import '../../../blocs/profile/profile_state.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_textfield.dart';

class ProfileScreen extends StatelessWidget {
  final TextEditingController _NameController = TextEditingController();

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
            _NameController.text = state.user.Name;

            return Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                children: [
                  CustomTextField(
                    label: 'Nom complet',
                    controller: _NameController,
                  ),
                  SizedBox(height: 16),
                  CustomButton(
                    label: 'Mettre à jour',
                    onPressed: () {
                      BlocProvider.of<ProfileBloc>(context).add(
                        UpdateUserProfile(
                          user: state.user.copyWith(
                            Name: _NameController.text,
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
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Accueil',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment),
            label: 'Ticket',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.notifications),
            label: 'Notifications',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: 'Chat',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profil',
          ),
        ],
        currentIndex: 0, // Assurez-vous de mettre à jour cet index pour les autres pages
        onTap: (index) {
          // Gérer la navigation entre les différentes pages
          switch (index) {
            case 0:
              Navigator.pushReplacementNamed(context, '/');
              break;
            case 1:
              Navigator.pushReplacementNamed(context, '/tickets');
              break;
            case 2:
              Navigator.pushReplacementNamed(context, '/notifications');
              break;
            case 3:
              Navigator.pushReplacementNamed(context, '/chat');
              break;
            case 4:
              Navigator.pushReplacementNamed(context, '/profile');
              break;
          }
        },
      ),
    );
  }
}
