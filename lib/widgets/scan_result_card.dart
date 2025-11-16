import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ScanResultCard extends StatelessWidget {
  final String text;
  final VoidCallback onCopy;
  final VoidCallback onShare;
  final bool dark;

  const ScanResultCard({
    required this.text,
    required this.onCopy,
    required this.onShare,
    this.dark = false,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: dark ? Colors.grey[900] : Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      elevation: 14,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(18, 18, 18, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Result",
              style: GoogleFonts.poppins(
                color: dark ? Colors.white : Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: dark ? Colors.grey[800] : Colors.grey[100],
                borderRadius: BorderRadius.circular(12),
              ),
              child: SelectableText(
                text,
                style: GoogleFonts.robotoMono(
                  fontSize: 15,
                  color: dark ? Colors.white : Colors.black87,
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton.icon(
                  icon: Icon(
                    Icons.copy,
                    color: dark ? Colors.white70 : Colors.indigo.shade700,
                  ),
                  label: const Text('Copy'),
                  onPressed: onCopy,
                ),
                const SizedBox(width: 10),
                TextButton.icon(
                  icon: Icon(
                    Icons.share,
                    color: dark ? Colors.white54 : Colors.blueAccent,
                  ),
                  label: const Text('Share'),
                  onPressed: onShare,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
