import 'package:flutter/material.dart';

class SubscriptionScreen extends StatelessWidget {
  const SubscriptionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("New Subscription"),
      ),
      body: const Center(
        child: Text("This is the new subscription screen"),
      ),
    );
  }
}