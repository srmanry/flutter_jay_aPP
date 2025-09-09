

import 'package:flutter/material.dart';


 Text appName =  Text("Spot'em365",style: TextStyle(fontSize: 28,fontWeight: FontWeight.w800,color: Color(0xFF000000)),);


 Widget fieldName( String fieldName){
  return Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Text(fieldName,style: TextStyle(fontSize:14,fontWeight: FontWeight.w500,color: Colors.black ),),
  );
 }


/*

 Widget BottonText(){
 return  Padding(
     padding: const EdgeInsets.only(bottom: 20,),
     child: Column(children: [
       const Text(
         'Your Profile helps us customize your experience',
         style: TextStyle(fontSize: 16, color:Color(0xFF9CA3AF),),
         textAlign: TextAlign.center,
       ),
       SizedBox(height: 8,),
       Row(mainAxisAlignment: MainAxisAlignment.center,
         children: [
           Icon(Icons.lock_open_outlined,size: 20,color: Color(0xFF9CA3AF),),
           const Text('Your data is secure and private',style: TextStyle(fontSize: 16, color: Color(0xFF9CA3AF)),),
         ],
       ),
     ],),
   );
 }
*/

class BottonText extends StatelessWidget {
  const BottonText({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
      color: Colors.white, // optional, background color
      child: Column(
        mainAxisSize: MainAxisSize.min, // ensures only needed height
        children: [
          const Text(
            'Your Profile helps us customize your experience',
            style: TextStyle(fontSize: 16, color: Color(0xFF9CA3AF)),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Icon(Icons.lock_open_outlined, size: 20, color: Color(0xFF9CA3AF)),
              SizedBox(width: 5),
              Text(
                'Your data is secure and private',
                style: TextStyle(fontSize: 16, color: Color(0xFF9CA3AF)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
