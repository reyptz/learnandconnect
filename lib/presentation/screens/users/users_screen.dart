import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UsersScreen extends StatefulWidget {
  @override
  _ManageUsersScreenState createState() => _ManageUsersScreenState();
}

class _ManageUsersScreenState extends State<UsersScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String _selectedRole = 'Apprenant'; // Rôle par défaut

  void _createUser() async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );
      // Ajouter l'utilisateur à Firestore avec son rôle
      await _firestore.collection('users').doc(userCredential.user!.uid).set({
        'email': _emailController.text,
        'role': _selectedRole,
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Utilisateur créé avec succès!')));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Erreur: $e')));
    }
  }

  void _updateUserRole(String userId, String newRole) async {
    await _firestore.collection('users').doc(userId).update({'role': newRole});
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Rôle mis à jour!')));
  }

  void _deleteUser(String userId) async {
    await _firestore.collection('users').doc(userId).delete();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Utilisateur supprimé!')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gestion des utilisateurs'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Mot de passe'),
              obscureText: true,
            ),
            DropdownButton<String>(
              value: _selectedRole,
              items: ['Apprenant', 'Formateur', 'Administrateur'].map((role) {
                return DropdownMenuItem(value: role, child: Text(role));
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedRole = value!;
                });
              },
            ),
            ElevatedButton(
              onPressed: _createUser,
              child: Text('Créer un utilisateur'),
            ),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: _firestore.collection('users').snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator());
                  }

                  if (snapshot.hasError) {
                    return Center(child: Text('Erreur de chargement des utilisateurs'));
                  }

                  final users = snapshot.data?.docs ?? [];

                  return ListView.builder(
                    itemCount: users.length,
                    itemBuilder: (context, index) {
                      final user = users[index];
                      return ListTile(
                        title: Text(user['email']),
                        subtitle: Text('Rôle: ${user['role']}'),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            DropdownButton<String>(
                              value: user['role'],
                              items: ['Apprenant', 'Formateur', 'Administrateur'].map((role) {
                                return DropdownMenuItem(value: role, child: Text(role));
                              }).toList(),
                              onChanged: (value) {
                                _updateUserRole(user.id, value!);
                              },
                            ),
                            IconButton(
                              icon: Icon(Icons.delete),
                              onPressed: () {
                                _deleteUser(user.id);
                              },
                            ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
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
