import 'package:flutter/material.dart';

class MyPageNavigatorButton extends StatelessWidget {
  final bool canEdit;
  final int currentPageIndex;
  final PageController pagesController;
  final int pageLength;

  const MyPageNavigatorButton({
    super.key,
    required this.canEdit,
    required this.currentPageIndex,
    required this.pagesController,
    required this.pageLength
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // tombol ke soal sebelum dan selanjutnya
        !canEdit ? Flexible(
          child: Container(
            padding: const EdgeInsets.all(0.0),
            // color: Color(0xFFEEF3FC),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // tombol ke soal sebelumnya
                Visibility(
                  visible: true,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Color(0xFF00A8AD),
                      ),
                      onPressed: currentPageIndex > 0 ? () {
                        print(currentPageIndex);
                        pagesController.previousPage(
                          duration: Duration(milliseconds: 1),
                          curve: Curves.linear,
                        ); 
                      } : null,
                            
                      child: Icon(Icons.navigate_before),
                    ),
                  ),
                ),

                pageLength > 0
                  ? Text("${currentPageIndex+1}/$pageLength", 
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20
                      ),
                    )
                  : SizedBox.shrink(),
                            
                // tombol ke soal selanjutnya
                Visibility(
                  visible: true,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Color(0xFF00A8AD),
                      ),
                      onPressed: currentPageIndex < pageLength - 1 ? () {
                        pagesController.nextPage(
                          duration: Duration(milliseconds: 1),
                          curve: Curves.linear,
                        );
                      } : null,
                      child: Icon(Icons.navigate_next),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ) : Flexible(child: SizedBox()),
      ],
    );
  }
}