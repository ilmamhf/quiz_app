import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../components/my_appbar.dart';
import '../../components/my_button.dart';
import '../../components/my_dropdown.dart';
import '../../components/my_form_row.dart';
import '../../components/my_textfield.dart';
import '../../components/small_popup.dart';
import '../../models/profil.dart';
import '../../services/firestore.dart';
import 'evaluator_page.dart';

class PilihUserPage extends StatefulWidget {
  const PilihUserPage({super.key});

  @override
  State<PilihUserPage> createState() => _PilihUserPageState();
}

class _PilihUserPageState extends State<PilihUserPage> {

  final FirestoreService firestoreService = FirestoreService();

  String userSelectorController = "Pilih user di sini";
  final passwordController = TextEditingController();

  List<Profil> fetchedUsers = [];
  List<String> usernames = [];
  List<String> usernameList = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchUser();
  }

  Future<void> _fetchUser() async {
    setState(() {
      isLoading = true;
    });
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        print('User is not logged in');
        return;
      }

      fetchedUsers = await firestoreService.fetchUsersAsEvaluator(user.uid);
      setState(() {
        usernameList = fetchedUsers.map((user) => user.username ?? 'Tanpa Nama').toList();
      });
    } catch (e) {
      print('Error fetching users: $e');
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      backgroundColor: Color(0xFF00cfd6),
      resizeToAvoidBottomInset: false,

      appBar: MyAppBar(
        title: "Pilih User",
      ),

      body: isLoading
        ? Center(child: CircularProgressIndicator()) // Kondisi loading
      : SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20.0),
              // border: Border.all(color: Colors.black),
              color: Colors.white,
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              child: Column(
                children: [
                  // gambar
                  Container(
                    width: 300,
                    height: 300,
                    color: Colors.red,
                  ),
              
                  SizedBox(height: 20.0,),
              
                  // pilih user
                  MyFormRow(
                    labelText: 'Pilih User',
                    myWidget: DropdownField(
                      labelColor: Colors.grey,
                      hintText: '',
                      listString: usernameList,
                      selectedItem: userSelectorController,
                        onChange: (newValue) {
                          setState(() {
                            userSelectorController = newValue!;
                          });
                        },
                    )
                  ),
                  
                  const SizedBox(height: 5),

                  // password
                  MyFormRow(
                    labelText: 'Password',
                    myWidget: MyTextField(
                      controller: passwordController,
                      hintText: 'Ketik soal di sini',
                      obscureText: false,
                    ),
                  ),

                  const SizedBox(height: 20.0),

                  MyButton(
                    size: 5,
                    text: 'Monitor User',
                    paddingSize: 15,
                    onTap: () {     
                      // check apakah
                      if (userSelectorController != "Pilih user di sini") {

                        Profil? selectedUser = fetchedUsers.firstWhere(
                          (user) => user.username == userSelectorController,
                        );

                        // Cek apakah password cocok
                        if (selectedUser.password == passwordController.text) {
                          MySmallPopUp.showToast(message: 'Password benar!');
                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => EvaluatorPage(userTerpilih: selectedUser,)));
                        } else {
                          MySmallPopUp.showToast(message: 'Password salah!');
                        }
                      } else {
                        MySmallPopUp.showToast(message: 'Silahkan pilih user!');
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        )
      ),
    );
  }
}