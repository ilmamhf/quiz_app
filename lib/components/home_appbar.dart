import 'package:flutter/material.dart';

import '../models/profil.dart';
import '../pages/common_pages/profil_page.dart';

class HomeAppbar extends StatelessWidget implements PreferredSizeWidget {
  // final String nama;
  // final String role;
  final List<Widget>? actions;
  // final String userID;
  final Profil profil;
 
  const HomeAppbar({
    super.key,
    this.actions = null,
    required this.profil,
  });

  @override
  Widget build(BuildContext context) {

    // Batasi panjang nama yang ditampilkan
    String displayName = profil.nama.length > 10 ? profil.nama.substring(0, 7) + '...' : profil.nama;

    return AppBar(
      backgroundColor: Color(0xFF00cfd6),
      toolbarHeight: 200,
      leadingWidth: 100,
      titleSpacing: 0,
      scrolledUnderElevation: 0,
      // bottom: PreferredSize(
      //   preferredSize: const Size.fromHeight(4.0),
      //   child: Container(
      //       color: Color(0xAF00A8AD),
      //       height: 1.0,
      //   )),
      leading: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GestureDetector(
          onTap: () {Navigator.push(context, MaterialPageRoute(builder: (context) => ProfilPage(profil: profil,)));},
          child: CircleAvatar(
            backgroundColor: Colors.white, 
            child: Icon(Icons.person, size: 60, color: Colors.black,)
          ),
        ),
      ),
      title: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Halo👋', style: TextStyle(fontSize: 14),),

              const SizedBox(height: 5),

              Text(displayName, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),)
            ],
          ),

          const SizedBox(width: 14),

          Container(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 2.0),
              child: Text(profil.role, style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold),),
            ),
            decoration: BoxDecoration(
              color: Color(0xFF99FCFF),
              borderRadius: BorderRadius.all(Radius.circular(20)),
              boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.2), offset: Offset(0, 0), blurRadius: 4, spreadRadius: 2)]
            ),
          )
        ],
      ),

      actions: actions,
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size.fromHeight(100);
}