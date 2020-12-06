import 'dart:math';
import 'package:scidart/numdart.dart';


import 'package:motion_sensors/quanternions.dart';

class Euler{

  double pitch;
  double roll;
  double yaw; 


  void toEulaer(Quanternion q){

    roll = atan2(sinr_cosp(q), cosr_cosp(q));

    if (sinp(q).abs() >= 1)
        pitch =  copySign(3.1415926535897932 / 2, sinp(q)); // use 90 degrees if out of range
    else
        pitch = asin(sinp(q));

  yaw = atan2(siny_cosp(q), cosy_cosp(q));      

  }

  double sinr_cosp  (Quanternion q){
    return 2 * (q.w * q.x + q.y * q.z);
  }

   double cosr_cosp   (Quanternion q){
    return 1 - 2 * (q.x * q.x + q.y * q.y);
  }
  
   double sinp    (Quanternion q){
    return 2 * (q.w * q.y - q.z * q.x);
  }
  
   double siny_cosp     (Quanternion q){
    return 2 * (q.w * q.z + q.x * q.y);
  }
  
   double cosy_cosp      (Quanternion q){
    return 1 - 2 * (q.y * q.y + q.z * q.z);
  }




 

}