import 'package:flutter/material.dart';

import '../../components/text_display.dart';
import '../../models/profil.dart';
import '../../services/firestore.dart';

import 'package:intl/intl.dart';

class ListUserPage extends StatefulWidget {
  const ListUserPage({super.key});

  @override
  State<ListUserPage> createState() => _ListUserPageState();
}

class _ListUserPageState extends State<ListUserPage> {

  final FirestoreService _firestoreService = FirestoreService();

  List<Profil> listUser = [
    // Profil(
    //   nama: '',
    //   tgl lahir: "",
    //   jenis kelamin: "pria",
    //   no hp: "3",
    // ),
  ];

  PageController _controller = PageController();
  int currentPageIndex = 0;
  bool isLoading = true;

  String dateFormatter(timestamp){
    DateTime date = timestamp.toDate(); // Konversi Timestamp ke DateTime
  return DateFormat('dd/MM/yyyy').format(date); // Format DateTime ke dd/MM/yyyy
  }

   // Fungsi untuk mengambil user dari Firestore
  Future<void> _fetchListUser() async {

    setState(() {
      isLoading = true;
    });

    List<Profil> fetchedListUser = await _firestoreService.fetchAllUserAsAdmin();
    setState(() {
      listUser = fetchedListUser;
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _fetchListUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF00CFD6),
      appBar: AppBar(
        title: Text("List All User"),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator()) // Kondisi loading
        : listUser.isEmpty
          ? Center(child: Text("Tidak ada user")) // Kondisi kosong
        : SafeArea(
        child: Center(
          child: Container(
            width: 400,
            height: 400,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black, width: 2.0),
              color: Colors.white,
              borderRadius: BorderRadius.circular(16)
              ),
            child: Column(
              children: [
                Expanded(
                  child: PageView.builder(
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
                  )
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Visibility(
                      visible: currentPageIndex > 0,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton(
                          onPressed: () {
                            _controller.previousPage(
                              duration: Duration(milliseconds: 300), 
                              curve: Curves.easeInOut,
                            );
                          }, child: Text("Soal sebelumnya"),
                        ),
                      ),
                    ),
            
                    Visibility(
                      visible: currentPageIndex < listUser.length - 1,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton(
                          onPressed: () {
                            _controller.nextPage(
                              duration: Duration(milliseconds: 300), 
                              curve: Curves.easeInOut,
                            );
                          }, child: Text("Soal selanjutnya"),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildListUserPage(Profil user, int index) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black, width: 2.0),
          color: Colors.white
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            // nama akun
            TextDisplay(
              judul: 'Nama Lengkap :',
              text: user.nama,
            ),

            SizedBox(height: 5.0,),

            // tanggal lahir
            
            TextDisplay(
              judul: 'Tanggal Lahir :',
              text: dateFormatter(user.tglLahir),
            ),
            
            SizedBox(height: 5.0,),

            // jenis kelamin
            TextDisplay(
              judul: 'Jenis Kelamin :',
              text: user.jenisKelamin,
            ),
            
            SizedBox(height: 5.0,),

            // no hp
            TextDisplay(
              judul: 'No HP :',
              text: user.noHP,
            ),
          ],
        ),
      ),
    );
  }
}