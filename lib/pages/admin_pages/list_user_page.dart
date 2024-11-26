import 'package:demensia_app/components/my_form_row.dart';
import 'package:flutter/material.dart';

import '../../components/my_appbar.dart';
import '../../components/page_navigator_button.dart';
import '../../components/text_display.dart';
import '../../components/user_data_display.dart';
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
      appBar: MyAppBar(title: 'List User',),
      body: isLoading
          ? Center(child: CircularProgressIndicator()) // Kondisi loading
        : listUser.isEmpty
          ? Center(child: Text("Tidak ada user")) // Kondisi kosong
        : SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(right: 20.0, left: 20.0, top: 100.0, bottom: 200.0),
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
    return Container(
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
            "User ${index + 1}",
            style: TextStyle(fontSize: 60.0),
            textAlign: TextAlign.center,
          ),

          SizedBox(height: 20.0,),
    
          // nama
          MyUserDataDisplay(
            text1: 'Nama Lengkap',
            text2: user.nama,
          ),
    
          const SizedBox(height: 10),
          
          // tgl lahir
          MyUserDataDisplay(
            text1: 'Tanggal Lahir', 
            text2: dateFormatter(user.tglLahir)
          ),
    
          const SizedBox(height: 10),
    
          // Jenis Kelamin
          MyUserDataDisplay(
            text1: 'Jenis Kelamin', 
            text2: user.jenisKelamin
          ),
    
          const SizedBox(height: 10),
    
          // No HP
          MyUserDataDisplay(
            text1: 'No HP', 
            text2: user.noHP
          ),
    
          // const SizedBox(height: 5),
        ],
      ),
    );
  }
}