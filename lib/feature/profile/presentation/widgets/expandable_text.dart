import 'package:flutter/material.dart';

class ExpandableTile extends StatefulWidget {
  final String title;
  final String description;

  const ExpandableTile({
    super.key,
    required this.title,
    required this.description,
  });

  @override
  State<ExpandableTile> createState() => _ExpandableTileState();
}

class _ExpandableTileState extends State<ExpandableTile> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Column(
        children: [
          ListTile(
            title: Text(widget.title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),),
            trailing: Icon(isExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,),
            onTap: () {
              setState(() {isExpanded = !isExpanded;});
            },
          ),
          if (isExpanded)
            Padding(
              padding:
              const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Text(
                widget.description,
                style: const TextStyle(fontSize: 14, color: Colors.black87),
              ),
            ),
        ],
      ),
    );
  }
}
