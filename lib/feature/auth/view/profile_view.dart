import 'package:flutter/material.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(


      body: ListView.builder(itemBuilder: (_,index){
        return Column(children: [


           Stack(
             children: [
               CircleAvatar(
                 radius: 30,
               ),
             ],
           )
        ],);

      }),

    );
  }
}
