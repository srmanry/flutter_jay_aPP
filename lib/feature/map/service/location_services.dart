import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

class LocationServices{


  Future<Position>getUserLocation()async{

    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if(!serviceEnabled){
      showDialog("Location are disabled", "Please enable GPS from setting");
      throw Exception("Location services is disabled");
    }

    permission = await Geolocator.checkPermission();
    if(permission == LocationPermission.denied){
      permission = await Geolocator.requestPermission();
    }
    if(permission ==LocationPermission.denied){
      showDialog("Permission Denied", "Need to Location");
      //throw Exception("Location  permission are denied.");
    }


    if(permission== LocationPermission.deniedForever){
      showDialog("Permission Permanently Denied","Please enable location permission from settings.");
      // throw Exception("Location parmission are denied  enable from settings");

    }

    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high
    );




  }

}
void showDialog(String title,String massage){
  Get.defaultDialog(title: title,middleText: massage,
  textConfirm: "OK",
    onCustom: (){}
      
  );
}