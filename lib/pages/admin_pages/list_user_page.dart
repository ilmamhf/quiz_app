import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demensia_app/components/my_form_row.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../../components/big_popup.dart';
import '../../components/date_picker.dart';
import '../../components/loading_popup.dart';
import '../../components/my_appbar.dart';
import '../../components/my_checkbox_row.dart';
import '../../components/my_textfield.dart';
import '../../components/page_navigator_button.dart';
import '../../components/small_popup.dart';
import '../../components/soal_crud_button.dart';
import '../../components/sub_judul.dart';
import '../../models/profil.dart';
import '../../services/firestore.dart';

import 'package:intl/intl.dart';

class ListUserPage extends StatefulWidget {
  final String tipe;
  final String? evaluatorID;

  const ListUserPage({
    super.key,
    required this.tipe,
    this.evaluatorID,
  });

  @override
  State<ListUserPage> createState() => _ListUserPageState();
}

class _ListUserPageState extends State<ListUserPage> {

  final FirestoreService _firestoreService = FirestoreService();

  List<Profil> listUser = [];

  PageController _controller = PageController();
  int currentPageIndex = 0;
  bool isLoading = true;
  bool canEdit = false;

  List<TextEditingController> namaLengkapControllers = [];
  List<TextEditingController> usernameControllers = [];
  List<TextEditingController> tglLahirControllers= [];
  List<TextEditingController> noHpControllers = [];
  List<TextEditingController> passwordControllers = [];
  List<ValueNotifier<int>> selectedAnswerNotifiers = [];
  List<String> jenisKelamin = ['Pria', 'Wanita'];
  int originalSelectedAnswer = 0;

  String dateFormatter(timestamp){
    DateTime date = timestamp.toDate(); // Konversi Timestamp ke DateTime
  return DateFormat('dd/MM/yyyy').format(date); // Format DateTime ke dd/MM/yyyy
  }

   // Fungsi untuk mengambil user dari Firestore
  Future<void> _fetchListUser() async {

    setState(() {
      isLoading = true;
    });

    List<Profil> fetchedListUser = [];

    if (widget.evaluatorID != null) {
      fetchedListUser = await _firestoreService.fetchUsersAsEvaluator(widget.evaluatorID!);
    } else {
      fetchedListUser = await _firestoreService.fetchAllUserAsAdmin(widget.tipe, null);
    }

    if (fetchedListUser.isEmpty) {
      setState(() {
        listUser = [];
      });
    } else {
      setState(() {
      listUser = fetchedListUser;
      usernameControllers = List.generate(fetchedListUser.length, (index) => TextEditingController());
      namaLengkapControllers = List.generate(fetchedListUser.length, (index) => TextEditingController());
      tglLahirControllers = List.generate(fetchedListUser.length, (index) => TextEditingController());
      passwordControllers = List.generate(fetchedListUser.length, (index) => TextEditingController());
      noHpControllers = List.generate(fetchedListUser.length, (index) => TextEditingController());
      selectedAnswerNotifiers = List.generate(fetchedListUser.length, (index) => ValueNotifier<int>(-1)); // Inisialisasi ValueNotifier
      
      // Inisialisasi controller dengan data user
      for (int i = 0; i < fetchedListUser.length; i++) {
        if (widget.tipe == 'User') {
          passwordControllers[i].text = fetchedListUser[i].password ?? '';
        }
        usernameControllers[i].text = fetchedListUser[i].username!;
        namaLengkapControllers[i].text = fetchedListUser[i].nama;
        tglLahirControllers[i].text = dateFormatter(fetchedListUser[i].tglLahir);
        noHpControllers[i].text = fetchedListUser[i].noHP;

        // Set ValueNotifier untuk jenis kelamini
        for (int j = 0; j < 2; j++) {
          if (jenisKelamin[j] == fetchedListUser[i].jenisKelamin) {
            selectedAnswerNotifiers[i].value = j; // Set indeks jawaban yang benar
            break;
          }
        }
      }


      isLoading = false;
    });
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchListUser();
  }

  @override
  void dispose() {
    // Bebaskan semua controller
    for (var controller in namaLengkapControllers) {
      controller.dispose();
    }
    for (var controller in usernameControllers) {
      controller.dispose();
    }
    for (var controller in tglLahirControllers) {
      controller.dispose();
    }
    for (var controller in noHpControllers) {
      controller.dispose();
    }
    for (var controller in passwordControllers) {
      controller.dispose();
    }
    for (var notifier in selectedAnswerNotifiers) {
      notifier.dispose(); // Bebaskan ValueNotifier
    }
    // Bebaskan PageController
    _controller.dispose();
    super.dispose(); // Panggil super.dispose() di akhir
  }

  void _deleteUser(String userName) async {
    final userId = '${await FirebaseAuth.instance.currentUser!.uid}${userName}';
    await _firestoreService.deleteUser(userId);

    Fluttertoast.showToast(
      msg: "User berhasil dihapus",
      backgroundColor: Colors.green,
      textColor: Colors.white,
    );
    _fetchListUser(); // Refresh user setelah dihapus
  }

  void _saveUser(Profil user, int index) async {
    LoadingDialog.show(context);

    // Parsing teks dari dateController ke DateTime
    DateTime parsedDate = DateFormat('dd/MM/yyyy').parse(tglLahirControllers[index].text);
    // Konversi DateTime ke Timestamp
    Timestamp timestamp = Timestamp.fromDate(parsedDate);
    
    // Buat objek soal baru dengan data yang telah diubah
    Profil updatedUser = Profil(
      nama: namaLengkapControllers[index].text,
      tglLahir: timestamp,
      jenisKelamin: jenisKelamin[selectedAnswerNotifiers[index].value],
      noHP: noHpControllers[index].text,
      password: passwordControllers[index].text,
      // kalo gadikasih ngebug
      role: user.role,
      username: user.username,
      evaluatorID: user.evaluatorID,
    );

    // Panggil fungsi untuk memperbarui user di Firestore
      // String combinedUserID = user.evaluatorID! + user.username!;
      await _firestoreService.updateUserByEvaluator(updatedUser, user.username!);

    // Perbarui data lokal
    setState(() {
      _saveLocal(updatedUser, index);
      canEdit = false;
    });

    LoadingDialog.hide(context);
    MyBigPopUp.showAlertDialog(
      context: context, teks: 'User berhasil diperbarui!');
  }
  

  void _editUser(Profil soal, int answerValue) {
    setState(() {
      canEdit = true;
      // Simpan nilai asli dari selectedAnswerNotifier
      originalSelectedAnswer = answerValue;
    });
  }

  void _saveLocal(Profil profilUserBaru, int index) {
    listUser[index] = profilUserBaru;
  }

  void _exitEdit() {
    setState(() {
      canEdit = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF00CFD6),
      appBar: MyAppBar(title: 'List User',),
      body: isLoading
          ? Center(child: CircularProgressIndicator()) // Kondisi loading
        : listUser.isEmpty
          ? Center(child: Text("Tidak ada ${widget.tipe}", style: TextStyle(color: Colors.white),),) // Kondisi kosong
        : SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            children: [

              Flexible(
                child: Container(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.0),
                      color: Colors.white,
                    ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: PageView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      controller: _controller,
                      itemCount: listUser.length,
                      onPageChanged: (index) {
                        setState(() {
                          currentPageIndex = index;
                        });
                      },
                      itemBuilder: (context, index) {
                        return buildListUserPage(listUser[index], index);
                      }
                    ),
                  ),
                )
              ),
              
              MyPageNavigatorButton(
                canEdit: false,
                currentPageIndex: currentPageIndex,
                pageLength: listUser.length,
                pagesController: _controller,
                // _controller: _controller,
                // currentPageIndex: currentPageIndex,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildListUserPage(Profil user, int index) {
    return SingleChildScrollView(
      child: Container(
        // constraints: BoxConstraints(maxHeight: 200),
        decoration: BoxDecoration(
          // border: Border.all(color: Colors.black, width: 2.0),
          // color: Colors.red,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // judul
            Text(
              "${widget.tipe} ${index + 1}",
              style: TextStyle(fontSize: 40.0),
              textAlign: TextAlign.center,
            ),
      
            SizedBox(height: 20.0,),
      
            MySubJudul(text: 'Akun :',),
      
            const SizedBox(height: 5),

            //username
            MyFormRow(
              labelText: 'Nama Akun',
              myWidget: MyTextField(
                hintText: '',
                controller: usernameControllers[index],
                obscureText: false,
                enabled: false,
              ),
            ),
            
            const SizedBox(height: 5),
            
            // password
            widget.tipe == 'User' ? MyFormRow(
              labelText: 'Password',
              myWidget: MyTextField(
                hintText: 'Isi password di sini',
                controller: passwordControllers[index],
                obscureText: false,
                enabled: canEdit,
              ),
            ) : SizedBox.shrink(),
            
            const SizedBox(height: 20),
      
            MySubJudul(text: 'Profil :',),
      
            const SizedBox(height: 5),
      
            // nama
            MyFormRow(
              labelText: 'Nama Lengkap',
              myWidget: MyTextField(
                hintText: 'Isi nama lengkap di sini',
                controller: namaLengkapControllers[index],
                obscureText: false,
                enabled: canEdit,
              ),
            ),
            const SizedBox(height: 20),
            
            // tgl lahir
            MyFormRow(
              labelText: 'Tanggal Lahir',
              myWidget: DatePicker(
                dateController: tglLahirControllers[index],
                text: 'Isi tanggal lahir di sini',
                labelColor: Colors.black,
                enabled: canEdit,
              ),
            ),  
            const SizedBox(height: 20),
              
            // Jenis Kelamin
            MyFormRow(
                labelText: 'Jawaban Benar',
                myWidget: MyCheckboxRow(
                  abcd: jenisKelamin,
                  selectedAnswerNotifier: selectedAnswerNotifiers[index],
                  enabled: canEdit
                )
              ),
              
            const SizedBox(height: 20),
              
            // No HP
            MyFormRow(
              labelText: 'No HP',
              myWidget: MyTextField(
                hintText: 'Isi nomor HP di sini',
                controller: noHpControllers[index],
                obscureText: false,
                digitOnly: true,
                enabled: canEdit
              ),
            ),
      
            widget.tipe == 'User' && widget.evaluatorID != null ? const SizedBox(height: 20) : SizedBox.shrink(),
            widget.tipe == 'User' && widget.evaluatorID != null ? MySoalCRUDButton(
              canEdit: canEdit,
              deleteFunc: () {
                _deleteUser(user.username!);
                if (currentPageIndex > 0) {
                  setState(() {
                    _controller.previousPage(
                      duration: Duration(milliseconds: 1),
                      curve: Curves.linear,
                    );
                  });
                }
              },
              editFunc: () {
                _editUser(user, selectedAnswerNotifiers[index].value);
              },
              batalFunc: () {
                // balikkan value
                namaLengkapControllers[index].text = user.nama;
                tglLahirControllers[index].text = dateFormatter(user.tglLahir);
                passwordControllers[index].text = user.password!;
                noHpControllers[index].text = user.noHP;
                selectedAnswerNotifiers[index].value = originalSelectedAnswer;
                _exitEdit();
              },
              simpanFunc: () {
                if (namaLengkapControllers[index].text.isEmpty ||
                    tglLahirControllers[index].text.isEmpty ||
                    passwordControllers[index].text.isEmpty ||
                    noHpControllers[index].text.isEmpty ||
                    selectedAnswerNotifiers[index].value == -1) {
                  print(user.username);
                  MySmallPopUp.showToast(message: "Tidak boleh ada yang kosong");
                } else {
                  _saveUser(user, index);
                }
              },
            ) : SizedBox.shrink(),
          ],
        ),
      ),
    );
  }
}