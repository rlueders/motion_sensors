import 'dart:math';

class Quanternion{
  

double w;
double x;
double y;
double z;

void toQuanternion(double yaw, double pitch, double roll){

  w = cr(roll) * cp(pitch) * cy(yaw) + sr(roll) * sp(pitch) * sy(yaw);
  x = sr(roll) * cp(pitch) * cy(yaw) - cr(roll) * sp(pitch) * sy(yaw);
  y = cr(roll) * sp(pitch) * cy(yaw) + sr(roll) * cp(pitch) * sy(yaw);
  z = cr(roll) * cp(pitch) * sy(yaw) - sr(roll) * sp(pitch) * cy(yaw);




}

double cy(double yaw){
 return  cos(yaw * 0.5);
}

double sy(double yaw){
 return  sin(yaw * 0.5);
}


double cp(double pitch){
 return  cos(pitch * 0.5);
}

double sp(double pitch){
 return  sin(pitch * 0.5);
}

double cr(double roll){
 return  cos(roll * 0.5);
}

double sr(double roll){
 return  sin(roll * 0.5);
}


 

}