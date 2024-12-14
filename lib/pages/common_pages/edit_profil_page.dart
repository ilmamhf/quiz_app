import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../components/big_popup.dart';
import '../../components/date_picker.dart';
import '../../components/loading_popup.dart';
import '../../components/my_appbar.dart';
import '../../components/my_button.dart';
import '../../components/my_dropdown.dart';
import '../../components/my_form_row.dart';
import '../../components/my_textfield.dart';
import '../../components/small_popup.dart';
import '../../components/sub_judul.dart';
import '../../models/profil.dart';
import '../../services/firestore.dart';

class EditProfilePage extends StatefulWidget {
  final Profil profil;
  const EditProfilePage({
    super.key,
    required this.profil,
  });

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final FirestoreService firestoreService = FirestoreService();

  final namaLengkapController = TextEditingController();
  final tglLahirController = TextEditingController();
  String kelaminController = 'Jenis Kelamin';
  final noHPController = TextEditingController();

  String dateFormatter(timestamp){
    DateTime date = timestamp.toDate(); // Konversi Timestamp ke DateTime
  return DateFormat('dd/MM/yyyy').format(date); // Format DateTime ke dd/MM/yyyy
  }

  @override
  void dispose() {
    // Bebaskan semua TextEditingController
    namaLengkapController.dispose();
    tglLahirController.dispose();
    noHPController.dispose();
    
    super.dispose(); // Panggil super.dispose() di akhir
  }

  @override
  Widget build(BuildContext context) {
    
    namaLengkapController.text = widget.profil.nama;
    tglLahirController.text = dateFormatter(widget.profil.tglLahir);
    kelaminController = widget.profil.jenisKelamin;
    noHPController.text = widget.profil.noHP;
    
    return Scaffold(
      appBar: MyAppBar(title: 'Edit Profil'),
      backgroundColor: Color(0xFF00cfd6),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 40.0),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.white
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 13.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                  MySubJudul(text: 'Profil Baru :',),
                
                  const SizedBox(height: 20),
                    
                  // nama
                  MyFormRow(
                    labelText: 'Nama Lengkap',
                    myWidget: MyTextField(
                      hintText: 'Isi nama lengkap di sini',
                      controller: namaLengkapController,
                      obscureText: false,
                    ),
                  ),
                  const SizedBox(height: 20),
                
                  // tgl lahir
                  MyFormRow(
                    labelText: 'Tanggal Lahir',
                    myWidget: DatePicker(
                      dateController: tglLahirController,
                      text: 'Isi tanggal lahir di sini',
                      labelColor: Colors.black,
                    ),
                  ),  
                  const SizedBox(height: 20),
                    
                  // Jenis Kelamin
                  MyFormRow(
                    labelText: 'Jenis Kelamin',
                    myWidget: DropdownField(
                      hintText: '',
                      labelColor: Colors.black,
                      listString: const [
                        'Pria',
                        'Wanita',
                      ],
                      selectedItem: kelaminController,
                      onChange: (newValue) {
                        setState(() {
                          kelaminController = newValue!;
                        });
                      },
                    ),
                  ),
                    
                  const SizedBox(height: 20),
                    
                  // No HP
                  MyFormRow(
                    labelText: 'No HP',
                    myWidget: MyTextField(
                      hintText: 'Isi nomor HP di sini',
                      controller: noHPController,
                      obscureText: false,
                      digitOnly: true,
                    ),
                  ),

                  const SizedBox(height: 40),

                  // save profil
                  MyButton(
                    size: 5,
                    paddingSize: 20,
                    text: 'Perbarui profil',
                    onTap: () {
                      if (namaLengkapController.text.isEmpty ||
                          tglLahirController.text.isEmpty ||
                          kelaminController.isEmpty ||
                          noHPController.text.isEmpty) {
                        MySmallPopUp.showToast(message: "Tidak boleh ada yang kosong");
                      } else {
                        try {
                          LoadingDialog.show(context);

                          // Parsing teks dari dateController ke DateTime
                          DateTime parsedDate = DateFormat('dd/MM/yyyy').parse(tglLahirController.text);

                          // Konversi DateTime ke Timestamp
                          Timestamp timestamp = Timestamp.fromDate(parsedDate);
                          
                          Profil userProfile = Profil(
                            nama: namaLengkapController.text,
                            tglLahir: timestamp,
                            jenisKelamin: kelaminController,
                            noHP: noHPController.text,
                            role: widget.profil.role,
                          );
                          
                          firestoreService.updateAccount(userProfile);
                          LoadingDialog.hide(context);
                          Navigator.pop(context);
                          MyBigPopUp.showAlertDialog(context: context, teks: 'Profil berhasil diperbarui');
                        } catch (e) {
                          LoadingDialog.hide(context);
                          MyBigPopUp.showAlertDialog(context: context, teks: 'Profil gagal diperbarui');
                        }
                        
                      }
                    },
                  )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}