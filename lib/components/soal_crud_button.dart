import 'package:flutter/material.dart';

import 'big_popup.dart';

class MySoalCRUDButton extends StatefulWidget {
  final bool canEdit;
  final Function deleteFunc;
  final Function editFunc;
  final Function simpanFunc;
  final Function batalFunc;

  const MySoalCRUDButton({
    super.key,
    required this.canEdit,
    required this.deleteFunc,
    required this.editFunc,
    required this.simpanFunc,
    required this.batalFunc,
  });

  @override
  State<MySoalCRUDButton> createState() => _MySoalCRUDButtonState();
}

class _MySoalCRUDButtonState extends State<MySoalCRUDButton> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: !widget.canEdit ? [
    
        // delete soal
        ElevatedButton.icon(
          onPressed: () {
            MyBigPopUp.showAlertDialog(
              teks: "Apakah anda yakin ingin menghapus?",
              context: context,
              additionalButtons: [
                // batal
                TextButton(
                  onPressed: () => Navigator.pop(context), 
                  child: Text('Batal')),
                // hapus  
                TextButton(
                  onPressed: () {
                    widget.deleteFunc();
                    Navigator.pop(context);
                  }, 
                  child: Text('Hapus')),
              ],
            );
          },
          icon: const Icon(Icons.delete, color: Colors.white,),
          label: const Text("Hapus", style: TextStyle(color: Colors.white),),
          style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
        ),

        // edit soal
        ElevatedButton.icon(
          onPressed: () {
            widget.editFunc();
          },
          icon: const Icon(Icons.edit, color: Colors.white,),
          label: const Text("Edit", style: TextStyle(color: Colors.white),),
          style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
        ),
      ] : [
        // batal
        ElevatedButton.icon(
          onPressed: () {
           widget.batalFunc();
          },
          icon: const Icon(Icons.cancel, color: Colors.white,),
          label: const Text("Batal", style: TextStyle(color: Colors.white),),
          style: ElevatedButton.styleFrom(backgroundColor: Colors.yellow),
        ),
    
        // save soal
        ElevatedButton.icon(
          onPressed: () {
            widget.simpanFunc();
          },
          icon: const Icon(Icons.save, color: Colors.white,),
          label: const Text("Simpan", style: TextStyle(color: Colors.white),),
          style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
        ),
      ],
    );
  }
}