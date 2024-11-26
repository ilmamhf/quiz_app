import 'package:flutter/material.dart';

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  const MyAppBar({
    super.key,
    required this.title,
  });

  @override
  PreferredSizeWidget build(BuildContext context) {
    return AppBar(
        title: Text(title),
        backgroundColor: const Color(0xFF00cfd6),
        foregroundColor: Colors.white,
        scrolledUnderElevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle
            ),
            child: const BackButton(
              color: Color(0xFF00cfd6),
            ),
          ),
        ), 
      );
  }
  
  @override
  // TODO: implement preferredSize
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}