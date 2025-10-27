import 'package:flutter/material.dart';


class ReponsiveScreen extends StatelessWidget {
  const ReponsiveScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          var shortestSide = MediaQuery.of(context).size.shortestSide;
          bool isMobile = shortestSide < 600;
          if (isMobile) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(child: Column(children: [
                  ],      
      )),
            );
          }
          return Center(child: Text("Other  Screen View"));
        },
      ),
    );
  }
}
