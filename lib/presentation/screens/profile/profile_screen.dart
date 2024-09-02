import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import '../../../core/constants/app_colors.dart';

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
  int _currentIndex = 0;

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
      try {
        DocumentSnapshot userDoc =
        await _firestore.collection('users').doc(currentUser!.uid).get();

        if (userDoc.exists) {
          setState(() {
            _nameController.text = userDoc['name'] ?? '';
            _emailController.text = userDoc['email'] ?? '';
            _role = userDoc['role'] ?? 'User';
          });
        } else {
          print("Le document utilisateur n'existe pas.");
        }
      } catch (e) {
        print("Erreur lors du chargement des données utilisateur : $e");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur lors du chargement des données utilisateur.'),
          ),
        );
      }
    } else {
      print("Aucun utilisateur connecté.");
    }
  }

  Future<void> _updateProfile() async {
    if (currentUser != null) {
      try {
        await _firestore.collection('users').doc(currentUser!.uid).update({
          'name': _nameController.text,
          'email': _emailController.text,
          // Le rôle n'est pas modifiable donc pas de mise à jour ici
        });

        if (_passwordController.text.isNotEmpty) {
          await currentUser!.updatePassword(_passwordController.text);
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Profil mis à jour avec succès!')),
        );
      } catch (e) {
        print("Erreur lors de la mise à jour du profil : $e");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erreur lors de la mise à jour du profil.'),
          ),
        );
      }
    } else {
      print("Aucun utilisateur connecté pour mettre à jour le profil.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mon Profil'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: _logout, // Fonction pour gérer la déconnexion
          ),
        ],
      ),
      body: _buildEditProfile(),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home, color: _currentIndex == 0 ? AppColors.primaryColor : AppColors.Colorabs),
            label: 'Accueil',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment, color: _currentIndex == 1 ? AppColors.primaryColor : AppColors.Colorabs),
            label: 'Ticket',
          ),
          BottomNavigationBarItem(
            backgroundColor: AppColors.primaryColor,
            icon: Icon(Icons.notifications, color: _currentIndex == 2 ? AppColors.backgroundColor : AppColors.Colorabs),
            label: 'Notifications',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person, color: _currentIndex == 3 ? AppColors.primaryColor : AppColors.Colorabs),
            label: 'Profil',
          ),
        ],
        currentIndex: _currentIndex, // Utilisez la variable d'état pour l'index actif
        onTap: (index) {
          setState(() {
            _currentIndex = index; // Mettre à jour l'index sélectionné
          });
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

  void _logout() async {
    try {
      await FirebaseAuth.instance.signOut();
      Navigator.pushReplacementNamed(context, '/login');
    } catch (e) {
      print('Erreur lors de la déconnexion : $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erreur lors de la déconnexion. Veuillez réessayer.'),
        ),
      );
    }
  }

  String _formatTimestamp(Timestamp? timestamp) {
    if (timestamp == null) {
      return '';
    }
    final dateTime = timestamp.toDate();
    return DateFormat('dd/MM/yyyy à HH:mm').format(dateTime);
  }
}
