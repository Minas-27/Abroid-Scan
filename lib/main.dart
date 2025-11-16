import 'package:flutter/material.dart';
import 'pages/ocr_page.dart';

void main() => runApp(const OCRApp());

class OCRApp extends StatelessWidget {
  const OCRApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Image to Text OCR',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Roboto',
        useMaterial3: true,
      ),
      home: OCRPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
