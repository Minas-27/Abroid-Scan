import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HistoryBottomSheet extends StatelessWidget {
  final List<String> history;
  final void Function(String) onCopy;
  final void Function(String) onSelect;

  const HistoryBottomSheet({
    required this.history,
    required this.onCopy,
    required this.onSelect,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 6,
              margin: EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(
                color: Colors.grey[800],
                borderRadius: BorderRadius.circular(6),
              ),
            ),
            Text(
              'Scan History',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Colors.white,
              ),
            ),
            Divider(color: Colors.grey[700]),
            if (history.isEmpty)
              Column(
                children: [
                  Icon(Icons.inbox, size: 80, color: Colors.white24),
                  const SizedBox(height: 18),
                  Text(
                    'No history yet!',
                    style: TextStyle(color: Colors.white38),
                  ),
                ],
              )
            else
              Flexible(
                child: ListView(
                  physics: BouncingScrollPhysics(),
                  shrinkWrap: true,
                  children:
                      history
                          .map(
                            (text) => Card(
                              color: Colors.grey[850],
                              margin: const EdgeInsets.only(top: 12),
                              child: ListTile(
                                title: Text(
                                  text.length > 60
                                      ? text.substring(0, 60) + '...'
                                      : text,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(color: Colors.white),
                                ),
                                trailing: IconButton(
                                  icon: Icon(Icons.copy, color: Colors.white54),
                                  onPressed: () => onCopy(text),
                                ),
                                onTap: () => onSelect(text),
                              ),
                            ),
                          )
                          .toList(),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
