import 'dart:math';

import 'dart:typed_data';

class Quaternion {
  Float32List _qStorage = Float32List(4);

  num heading = 0; 
  num attitude = 0; 
  num bank = 0;

  Quaternion(double yaw, double pitch, double roll) {
    final halfYaw = yaw * 0.5;
    final halfPitch = pitch * 0.5;
    final halfRoll = roll * 0.5;
    final cy = cos(halfYaw);
    final sy = sin(halfYaw);
    final cp = cos(halfPitch);
    final sp = sin(halfPitch);
    final cr = cos(halfRoll);
    final sr = sin(halfRoll);
    // _qStorage[0] = sr * cp * cy - cr * sp * sy;
    // _qStorage[1] = cr * sp * cy + sr * cp * sy;
    // _qStorage[2] = cr * cp * sy - sr * sp * cy;
    // _qStorage[3] = cr * cp * cy + sr * sp * sy;

    // _qStorage[0] = sr * cp * cy - cr * sp * sy;
    // _qStorage[2] = cr * sp * cy + sr * cp * sy;
    // _qStorage[1] = cr * cp * sy - sr * sp * cy;
    // _qStorage[3] = cr * cp * cy + sr * sp * sy;

    
    //works for pitching up
    // _qStorage[1] = sr * cp * cy - cr * sp * sy;
    // _qStorage[0] = cr * sp * cy + sr * cp * sy;
    // _qStorage[2] = cr * cp * sy - sr * sp * cy;
    // _qStorage[3] = cr * cp * cy + sr * sp * sy;

    //Works for pitching up - Orig?
    _qStorage[2] = sr * cp * cy - cr * sp * sy;
    _qStorage[0] = cr * sp * cy + sr * cp * sy;
    _qStorage[1] = cr * cp * sy - sr * sp * cy;
    _qStorage[3] = cr * cp * cy + sr * sp * sy;

    // _qStorage[1] = sr * cp * cy - cr * sp * sy;
    // _qStorage[2] = cr * sp * cy + sr * cp * sy;
    // _qStorage[0] = cr * cp * sy - sr * sp * cy;
    // _qStorage[3] = cr * cp * cy + sr * sp * sy;

    // _qStorage[2] = sr * cp * cy - cr * sp * sy;
    // _qStorage[1] = cr * sp * cy + sr * cp * sy;
    // _qStorage[0] = cr * cp * sy - sr * sp * cy;
    // _qStorage[3] = cr * cp * cy + sr * sp * sy;


  }

  /// Length squared.
  double get length2 {
    final x = _qStorage[0];
    final y = _qStorage[1];
    final z = _qStorage[2];
    final w = _qStorage[3];
    return (x * x) + (y * y) + (z * z) + (w * w);
  }

  /// Length.
  double get length => sqrt(length2);

  /// Normalize this.
  double normalize() {
    final l = length;
    if (l == 0.0) {
      return 0.0;
    }
    final d = 1.0 / l;
    _qStorage[0] *= d;
    _qStorage[1] *= d;
    _qStorage[2] *= d;
    _qStorage[3] *= d;
    return l;
  }

  void toEuler() {
    double sqw = _qStorage[3] * _qStorage[3] ;
    double sqx = _qStorage[0] *_qStorage[0];
    double sqy = _qStorage[1] *_qStorage[1];
    double sqz = _qStorage[2] *_qStorage[2];
	double unit = sqx + sqy + sqz + sqw; // if normalised is one, otherwise is correction factor
	double test = _qStorage[0] *_qStorage[1] + _qStorage[2]*_qStorage[3];
	if (test > 0.499*unit) { // singularity at north pole
		heading = 2 * atan2(_qStorage[0],_qStorage[3]);
		attitude = 3.14159265359/2;
		bank = 0;
		return;
	}
	if (test < -0.499*unit) { // singularity at south pole
		heading = -2 * atan2(_qStorage[0],_qStorage[3]);
		attitude = -3.14159265359/2;
		bank = 0;
		return;
	}
    heading = atan2(2*_qStorage[1]*_qStorage[3]-2*_qStorage[0]*_qStorage[2] , sqx - sqy - sqz + sqw);
    attitude = asin(2*test/unit);
    bank = atan2(2*_qStorage[0]*_qStorage[3]-2*_qStorage[1]*_qStorage[2] , -sqx + sqy - sqz + sqw);
}

//     void normalise() {
//     double n = sqrt(x*x + y*y + z*z + w*w);
//     x /= n;
//     y /= n;
//     z /= n;
//     w /= n;
// }

//  void conjugate() {
//     x = -x;
//     y = -y;
//     z = -z;
//     w = w;
//   }

//     double getx(){
//     return 2 * (x * z - w * y); 
//   }

//   double gety(){
//     return 2 * (y * z + w * x);
//   }

//   double getz(){
//     return  1 - 2 * (x * x + y * y);
//   }

//   void toQuanternion(double yaw, double pitch, double roll) {
//     w = cr(roll) * cp(pitch) * cy(yaw) + sr(roll) * sp(pitch) * sy(yaw);
//     x = sr(roll) * cp(pitch) * cy(yaw) - cr(roll) * sp(pitch) * sy(yaw);
//     y = cr(roll) * sp(pitch) * cy(yaw) + sr(roll) * cp(pitch) * sy(yaw);
//     z = cr(roll) * cp(pitch) * sy(yaw) - sr(roll) * sp(pitch) * cy(yaw);
//   }

  

//   double cy(double yaw) {
//     return cos(yaw * 0.5);
//   }

//   double sy(double yaw) {
//     return sin(yaw * 0.5);
//   }

//   double cp(double pitch) {
//     return cos(pitch * 0.5);
//   }

//   double sp(double pitch) {
//     return sin(pitch * 0.5);
//   }

//   double cr(double roll) {
//     return cos(roll * 0.5);
//   }

//   double sr(double roll) {
//     return sin(roll * 0.5);
//   }

//   static Quanternion multiply(Quanternion q1, Quanternion q2) {
//     Quanternion qReturn = Quanternion();
//     qReturn.x = q1.x * q2.w + q1.y * q2.z - q1.z * q2.y + q1.w * q2.x;
//     qReturn.y = -q1.x * q2.z + q1.y * q2.w + q1.z * q2.x + q1.w * q2.y;
//     qReturn.z = q1.x * q2.y - q1.y * q2.x + q1.z * q2.w + q1.w * q2.z;
//     qReturn.w = -q1.x * q2.x - q1.y * q2.y - q1.z * q2.z + q1.w * q2.w;
//     return qReturn;
//   }
}
