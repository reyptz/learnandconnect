import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../blocs/role/role_bloc.dart';
import '../../widgets/role_card.dart';

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
                return RoleCard(role: role);
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
          // Logique pour ajouter un nouveau rôle
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
