import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../blocs/role/role_bloc.dart';
import '../../../blocs/role/role_event.dart';
import '../../../blocs/role/role_state.dart';
import '../../widgets/role_card.dart';
import '../../../data/models/user_model.dart'; // Assurez-vous que l'énumération Role est importée

class RoleManagementScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gestion des Rôles'),
      ),
      body: BlocBuilder<RoleBloc, RoleState>(
        builder: (context, state) {
          if (state is RoleLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is RoleLoaded) {
            return ListView.builder(
              itemCount: state.roles.length,
              itemBuilder: (context, index) {
                final role = state.roles[index];
                return RoleCard(
                  role: role,
                  onEdit: () {
                    _showEditRoleDialog(context, role);
                  },
                  onDelete: () {
                    BlocProvider.of<RoleBloc>(context).add(DeleteRole(role: role));
                  },
                );
              },
            );
          } else if (state is RoleError) {
            return Center(child: Text(state.message));
          } else {
            return Center(child: Text('Aucun rôle disponible.'));
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _showAddRoleDialog(context);
        },
        child: Icon(Icons.add),
      ),
    );
  }

  void _showEditRoleDialog(BuildContext context, Role role) {
    final roleBloc = BlocProvider.of<RoleBloc>(context);
    Role? selectedRole = role; // Initial value for the dropdown

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Modifier le rôle'),
          content: DropdownButton<Role>(
            value: selectedRole,
            items: Role.values.map((Role role) {
              return DropdownMenuItem<Role>(
                value: role,
                child: Text(role.toString().split('.').last),
              );
            }).toList(),
            onChanged: (Role? newRole) {
              selectedRole = newRole;
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                if (selectedRole != null && selectedRole != role) {
                  roleBloc.add(UpdateRole(oldRole: role, newRole: selectedRole!));
                }
                Navigator.of(context).pop();
              },
              child: Text('Enregistrer'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Annuler'),
            ),
          ],
        );
      },
    );
  }

  void _showAddRoleDialog(BuildContext context) {
    final roleBloc = BlocProvider.of<RoleBloc>(context);
    Role? selectedRole; // Initial value for the dropdown

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Ajouter un rôle'),
          content: DropdownButton<Role>(
            value: selectedRole,
            hint: Text('Sélectionner un rôle'),
            items: Role.values.map((Role role) {
              return DropdownMenuItem<Role>(
                value: role,
                child: Text(role.toString().split('.').last),
              );
            }).toList(),
            onChanged: (Role? newRole) {
              selectedRole = newRole;
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                if (selectedRole != null) {
                  roleBloc.add(AddRole(role: selectedRole!));
                }
                Navigator.of(context).pop();
              },
              child: Text('Ajouter'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Annuler'),
            ),
          ],
        );
      },
    );
  }
}