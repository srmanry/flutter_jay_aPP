import 'package:flutter/material.dart';

class NotificationView extends StatelessWidget {
  const NotificationView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Notification"), elevation: 0,),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(children: [
           Text("Alert 3"),

          Expanded(
            child: ListView.builder(
              itemCount: 10,
              itemBuilder: (_,index){
                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 20, backgroundColor: Colors.grey[400],
                          child: Icon(Icons.notifications),
                        ),
                        Text("Alert $index"),
                      ],
                    ),
                  ),
                );


              },
            ),
          )

        ],),
      ),

    );
  }
}
