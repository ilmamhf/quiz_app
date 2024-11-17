import 'package:flutter/material.dart';

class MyMenuCard extends StatelessWidget {
  final String text;
  final double size;
  final Function()? onTap;
  final Widget cardIcon;

  const MyMenuCard({
    super.key,
    required this.text,
    required this.size,
    required this.onTap,
    required this.cardIcon,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: InkWell(
        onLongPress: () => {},
        onTap: onTap,
        borderRadius: BorderRadius.circular(20), 
        child: Ink(
          decoration:  BoxDecoration(
            borderRadius: BorderRadius.circular(20), 
            color: Colors.white,
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.2), offset: Offset(0, 4), blurRadius: 4, spreadRadius: 2)]
          ),
          child: Container(
            constraints: BoxConstraints(maxHeight: size, maxWidth: size),
            child: Center(
              child: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    cardIcon,
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text(text, textAlign: TextAlign.center,),
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