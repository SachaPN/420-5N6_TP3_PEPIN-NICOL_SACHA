import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:tp3/ecran_connexion.dart';
import 'package:tp3/ecran_creation.dart';

import 'ecran_accueil.dart';

class TirroirNavigation extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.deepPurpleAccent,
              ),
              child: Text('${FirebaseAuth.instance.currentUser?.email}'),
            ),
            ListTile(
              title: const Text('Accueil'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const EcranAccueil(),
                  ),
                );
              },
            ),
            ListTile(
              title: const Text('Ajout de tâche'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const EcranCreation(),
                  ),
                );
                ;;
              },
            ),
            ListTile(
              title: const Text('Déconnexion'),
              onTap: () async {
                await GoogleSignIn().signOut();
                await FirebaseAuth.instance.signOut();
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const EcranConnexion(),
                  ),
                );
                ;;
              },
            ),
          ],
        )
    );
  }
}