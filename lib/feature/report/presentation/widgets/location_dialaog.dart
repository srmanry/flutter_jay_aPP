import 'package:flutter/material.dart';

class LocationDialog {
  static Future<bool?> show(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.location_on, size: 80, color: Colors.blue),
            SizedBox(height: 15),
            Text(
              "Allow Location Access?",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              "To track real-time activity in your area",
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: Text("Don't allow"),
                ),
                SizedBox(width: 20),
                TextButton(
                  onPressed: () => Navigator.pop(context, true),
                  child: Text("Allow", style: TextStyle(color: Colors.blue)),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
