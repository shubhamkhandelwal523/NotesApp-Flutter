import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sqflite_database_example/model/note.dart';

final _lightColors = [
  Colors.cyanAccent.shade200,
  Colors.greenAccent.shade200,
  Colors.yellowAccent.shade200,
  Colors.grey.shade200,
  Colors.pink.shade200,
  Colors.tealAccent.shade200
];

class NoteCardWidget extends StatelessWidget {
  NoteCardWidget(
      {Key? key,
      required this.note,
      required this.index,
      required this.isImportant})
      : super(key: key);

  final Note note;
  final int index;
  final bool isImportant;

  @override
  Widget build(BuildContext context) {
    /// Pick colors from the accent colors based on index
    final color = _lightColors[index % _lightColors.length];
    final time = DateFormat.yMMMd().format(note.createdTime);
    final minHeight = getMinHeight(index);

    return Card(
      color: color,
      child: Stack(
        children: [
          Container(
            constraints: BoxConstraints(minHeight: minHeight),
            padding: EdgeInsets.all(8),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  time,
                  style: TextStyle(color: Colors.grey.shade700),
                ),
                Text(
                  note.title,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          Align(
              alignment: Alignment.topRight,
              child: Container(
                color: Colors.white,
                child: isImportant
                    ? Icon(
                        (Icons.star_rounded),
                        size: 20,
                        color: Colors.red,
                      )
                    : SizedBox(),
              ))
        ],
      ),
    );
  }

  /// To return different height for different widgets
  double getMinHeight(int index) {
    switch (index % 4) {
      case 0:
        return 150;
      case 1:
        return 200;
      case 2:
        return 200;
      case 3:
        return 150;
      default:
        return 100;
    }
  }
}
