import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_fonts/google_fonts.dart';

import '../widgets/scan_result_card.dart';
import '../widgets/history_bottom_sheet.dart';

class OCRPage extends StatefulWidget {
  @override
  State<OCRPage> createState() => _OCRPageState();
}

class _OCRPageState extends State<OCRPage> {
  File? _image;
  String _recognizedText = '';
  bool _loading = false;
  List<String> _history = [];

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  void _reset() {
    setState(() {
      _image = null;
      _recognizedText = '';
      _loading = false;
    });
  }

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: source);
    if (picked != null) {
      setState(() {
        _image = File(picked.path);
        _recognizedText = '';
      });
    }
  }

  Future<void> _scanText() async {
    if (_image == null) return;
    setState(() => _loading = true);
    final inputImage = InputImage.fromFile(_image!);
    final recognizer = TextRecognizer();
    final result = await recognizer.processImage(inputImage);
    setState(() {
      _recognizedText = result.text;
      _loading = false;
    });
    recognizer.close();
    _saveToHistory(result.text);
  }

  void _copyText() {
    if (_recognizedText.isNotEmpty) {
      Clipboard.setData(ClipboardData(text: _recognizedText));
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Copied to clipboard!'),
          backgroundColor: Colors.grey[800],
        ),
      );
    }
  }

  void _shareText() {
    if (_recognizedText.isNotEmpty) {
      Share.share(_recognizedText);
    }
  }

  void _showHistory() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      builder:
          (_) => HistoryBottomSheet(
            history: _history,
            onCopy: (text) {
              Clipboard.setData(ClipboardData(text: text));
              Navigator.pop(context);
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text('Copied to clipboard')));
            },
            onSelect: (text) {
              setState(() {
                _recognizedText = text;
              });
              Navigator.pop(context);
            },
          ),
    );
  }

  Future<void> _saveToHistory(String text) async {
    if (text.trim().isEmpty) return;
    setState(() {
      _history.insert(0, text);
      _history = _history.take(20).toList();
    });
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('ocr_history', _history);
  }

  Future<void> _loadHistory() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _history = prefs.getStringList('ocr_history') ?? [];
    });
  }

  ButtonStyle _mainButtonStyle({bool dark = false}) => ElevatedButton.styleFrom(
    backgroundColor: dark ? Colors.black : Colors.white,
    foregroundColor: dark ? Colors.white : Colors.black,
    padding: EdgeInsets.symmetric(horizontal: 28, vertical: 14),
    shape: StadiumBorder(),
    shadowColor: Colors.black,
    elevation: 12,
    textStyle: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600),
  );

  Widget _animatedImage() => AnimatedSwitcher(
    duration: Duration(milliseconds: 400),
    child:
        _image != null
            ? Container(
              margin: const EdgeInsets.symmetric(vertical: 18),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(28),
                child: Image.file(_image!, height: 170),
              ),
            )
            : SizedBox.shrink(),
  );

  Widget _resultCard(String text) => ScanResultCard(
    text: text,
    onCopy: _copyText,
    onShare: _shareText,
    dark: true,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // VIP black background
      body: Container(
        color: Colors.black,
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 16,
                  horizontal: 20,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Abroid Scan',
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold,
                        fontSize: 26,
                        color: Colors.white,
                        letterSpacing: 1.2,
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.history_edu,
                        color: Colors.white,
                        size: 28,
                      ),
                      onPressed: _showHistory,
                      tooltip: "History",
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Center(
                  child: AnimatedSwitcher(
                    duration: Duration(milliseconds: 500),
                    child:
                        _image == null
                            ? Column(
                              key: ValueKey('empty'),
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.document_scanner,
                                  size: 92,
                                  color: Colors.white24,
                                ),
                                const SizedBox(height: 36),
                                ElevatedButton.icon(
                                  icon: Icon(Icons.photo),
                                  label: Text('Pick Image'),
                                  style: _mainButtonStyle(dark: false),
                                  onPressed:
                                      () => _pickImage(ImageSource.gallery),
                                ),
                                const SizedBox(height: 16),
                                ElevatedButton.icon(
                                  icon: Icon(Icons.camera_alt),
                                  label: Text('Use Camera'),
                                  style: _mainButtonStyle(dark: true),
                                  onPressed:
                                      () => _pickImage(ImageSource.camera),
                                ),
                              ],
                            )
                            : SingleChildScrollView(
                              key: ValueKey('selected'),
                              padding: EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 20,
                              ),
                              child: Column(
                                children: [
                                  _animatedImage(),
                                  AnimatedSwitcher(
                                    duration: Duration(milliseconds: 300),
                                    child:
                                        _recognizedText.isEmpty
                                            ? ElevatedButton.icon(
                                              key: ValueKey('scan'),
                                              icon: Icon(Icons.text_snippet),
                                              label: Text(
                                                _loading
                                                    ? 'Scanning...'
                                                    : 'Scan Text',
                                              ),
                                              style: _mainButtonStyle(
                                                dark: true,
                                              ),
                                              onPressed:
                                                  _loading ? null : _scanText,
                                            )
                                            : _resultCard(_recognizedText),
                                  ),
                                  SizedBox(height: 12),
                                  TextButton(
                                    onPressed: _reset,
                                    child: Text(
                                      'Pick Another Image',
                                      style: TextStyle(
                                        color: Colors.white38,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
