import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../blocs/user/user_bloc.dart';
import '../../../blocs/user/user_event.dart';
import '../../../blocs/user/user_state.dart';
import '../../widgets/user_card.dart';

class UserManagementScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gestion des Utilisateurs'),
      ),
      body: BlocBuilder<UserBloc, UserState>(
        builder: (context, state) {
          if (state is UserLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is UserLoaded) {
            return ListView.builder(
              itemCount: state.users.length,
              itemBuilder: (context, index) {
                final user = state.users[index];
                  return UserCard(
                    user: user,
                    onEdit: () {
                      // Logique pour éditer l'utilisateur
                      Navigator.pushNamed(context, '/edit-user', arguments: user);
                    },
                    onDelete: () {
                      // Logique pour supprimer l'utilisateur
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: Text('Confirmer la suppression'),
                            content: Text('Voulez-vous vraiment supprimer cet utilisateur ?'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop(); // Fermer la boîte de dialogue
                                },
                                child: Text('Annuler'),
                              ),
                              TextButton(
                                onPressed: () {
                                  // Action pour supprimer l'utilisateur
                                  BlocProvider.of<UserBloc>(context).add(DeleteUser(user.userId));
                                  Navigator.of(context).pop(); // Fermer la boîte de dialogue
                                },
                                child: Text('Supprimer', style: TextStyle(color: Colors.red)),
                              ),
                            ],
                          );
                        },
                      );
                    },
                  );
                },
            );
          } else if (state is UserError) {
            return Center(child: Text(state.message));
          } else {
            return Center(child: Text('Aucun utilisateur disponible.'));
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Logique pour ajouter un nouvel utilisateur
          Navigator.pushNamed(context, '/add-user');
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
