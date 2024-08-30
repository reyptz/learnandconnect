import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../blocs/profile/profile_bloc.dart';
import '../../../blocs/profile/profile_event.dart';
import '../../../blocs/profile/profile_state.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_textfield.dart';
import 'package:intl/intl.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String _role = 'User'; // Par défaut, ne sera pas modifiable

  User? currentUser;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool isEditingProfile = true;

  @override
  void initState() {
    super.initState();
    currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser != null) {
      _loadUserData();
    }
  }

  Future<void> _loadUserData() async {
    if (currentUser != null) {
      DocumentSnapshot userDoc =
      await _firestore.collection('users').doc(currentUser!.uid).get();

      setState(() {
        _nameController.text = userDoc['name'] ?? '';
        _emailController.text = userDoc['email'] ?? '';
        _role = userDoc['role'] ?? 'User';
      });
    }
  }

  Future<void> _updateProfile() async {
    if (currentUser != null) {
      await _firestore.collection('users').doc(currentUser!.uid).update({
        'name': _nameController.text,
        'email': _emailController.text,
        // Le rôle n'est pas modifiable donc pas de mise à jour ici
      });

      if (_passwordController.text.isNotEmpty) {
        currentUser!.updatePassword(_passwordController.text);
      }

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Profil mis à jour avec succès!'),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mon Profil'),
        actions: [
          IconButton(
            icon: Icon(isEditingProfile ? Icons.history : Icons.edit),
            onPressed: () {
              setState(() {
                isEditingProfile = !isEditingProfile;
              });
            },
          ),
        ],
      ),
      body: isEditingProfile ? _buildEditProfile() : _buildActivityLog(),
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
        currentIndex: 4, // Index de la page actuelle
        onTap: (index) {
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

  Widget _buildEditProfile() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Nom Complet'),
          TextField(
            controller: _nameController,
            decoration: InputDecoration(hintText: 'Nom complet'),
          ),
          SizedBox(height: 16),
          Text('Email'),
          TextField(
            controller: _emailController,
            decoration: InputDecoration(hintText: 'Email'),
            readOnly: true, // L'utilisateur ne peut pas modifier son email
          ),
          SizedBox(height: 16),
          Text('Mot de passe'),
          TextField(
            controller: _passwordController,
            decoration: InputDecoration(hintText: 'Mot de passe'),
            obscureText: true,
          ),
          SizedBox(height: 16),
          Text('Rôle'),
          TextField(
            controller: TextEditingController(text: _role),
            readOnly: true, // Bloquer la modification du rôle
            decoration: InputDecoration(
              hintText: 'Rôle',
              suffixIcon: Icon(Icons.lock), // Icône indiquant que c'est bloqué
            ),
          ),
          SizedBox(height: 24),
          ElevatedButton(
            onPressed: _updateProfile,
            child: Text('Sauvegarder'),
          ),
        ],
      ),
    );
  }

  Widget _buildActivityLog() {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore
          .collection('activities')
          .where('userId', isEqualTo: currentUser?.uid)
          .orderBy('timestamp', descending: true)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(child: Text('Erreur de chargement des activités'));
        }

        final activities = snapshot.data?.docs ?? [];

        return ListView.builder(
          itemCount: activities.length,
          itemBuilder: (context, index) {
            final activity = activities[index].data() as Map<String, dynamic>;

            return ListTile(
              leading: CircleAvatar(
                backgroundImage: AssetImage('assets/avatar_placeholder.png'),
              ),
              title: Text(activity['action']),
              subtitle: Text(activity['metadata']),
              trailing: Text(
                _formatTimestamp(activity['timestamp']),
                style: TextStyle(color: Colors.grey),
              ),
            );
          },
        );
      },
    );
  }

  String _formatTimestamp(Timestamp? timestamp) {
    if (timestamp == null) {
      return '';
    }
    final dateTime = timestamp.toDate();
    return DateFormat('dd/MM/yyyy à HH:mm').format(dateTime);
  }
}
