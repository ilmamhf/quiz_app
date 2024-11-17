import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../components/my_button.dart';
import '../../services/auth_service.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                  'Hello👋',
                  style: GoogleFonts.raleway(
                    textStyle: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 20
                    )
                  ),
                ),
                const SizedBox(height: 10,),
                Text(
                  FirebaseAuth.instance.currentUser!.email!.toString(),
                  style: GoogleFonts.raleway(
                    textStyle: const TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 20
                    )
                  ),
                ),
                 const SizedBox(height: 30,),
                _logout(context),

              const SizedBox(height: 20),
                
              // sign in button
              MyButton(
                text: "Admin Page",
                onTap: () => Navigator.pushReplacementNamed(context, '/adminpage'),
                size: 15,
              ),

              const SizedBox(height: 20),
                
              // sign in button
              MyButton(
                text: "User Page",
                onTap: () => Navigator.pushReplacementNamed(context, '/userpage'),
                size: 15,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _logout(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xff0D6EFD),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
        minimumSize: const Size(double.infinity, 60),
        elevation: 0,
      ),
      onPressed: () async {
        await AuthService().signout(context: context);
      },
      child: const Text("Sign Out"),
    );
  }
}