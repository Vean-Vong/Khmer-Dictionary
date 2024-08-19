import 'package:flutter/material.dart';
import 'package:khmer_fonts/khmer_fonts.dart';

class ScannerPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        leading: IconButton(
          onPressed: () {},
          icon: Icon(
            Icons.font_download_outlined,
            color: Colors.white,
          ),
        ),
        title: Text(
          "វចនានុក្រមខ្មែរ",
          style: TextStyle(
            fontFamily: KhmerFonts.moul,
            fontSize: 26,
            package: 'khmer_fonts',
            color: Colors.white,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.grid_view_outlined,
              color: Colors.white,
            ),
          ),
        ],
      ),
      body: Center(
        child: Text(
          "No Scanner",
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
