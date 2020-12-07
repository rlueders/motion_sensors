import 'dart:math';

class Quanternion {
  double w;
  double x;
  double y;
  double z;

    void normalise() {
    double n = sqrt(x*x + y*y + z*z + w*w);
    x /= n;
    y /= n;
    z /= n;
    w /= n;
}

  void toQuanternion(double yaw, double pitch, double roll) {
    w = cr(roll) * cp(pitch) * cy(yaw) + sr(roll) * sp(pitch) * sy(yaw);
    x = sr(roll) * cp(pitch) * cy(yaw) - cr(roll) * sp(pitch) * sy(yaw);
    y = cr(roll) * sp(pitch) * cy(yaw) + sr(roll) * cp(pitch) * sy(yaw);
    z = cr(roll) * cp(pitch) * sy(yaw) - sr(roll) * sp(pitch) * cy(yaw);
  }

  double cy(double yaw) {
    return cos(yaw * 0.5);
  }

  double sy(double yaw) {
    return sin(yaw * 0.5);
  }

  double cp(double pitch) {
    return cos(pitch * 0.5);
  }

  double sp(double pitch) {
    return sin(pitch * 0.5);
  }

  double cr(double roll) {
    return cos(roll * 0.5);
  }

  double sr(double roll) {
    return sin(roll * 0.5);
  }

  static Quanternion multiply(Quanternion q1, Quanternion q2) {
    Quanternion qReturn = Quanternion();
    qReturn.x = q1.x * q2.w + q1.y * q2.z - q1.z * q2.y + q1.w * q2.x;
    qReturn.y = -q1.x * q2.z + q1.y * q2.w + q1.z * q2.x + q1.w * q2.y;
    qReturn.z = q1.x * q2.y - q1.y * q2.x + q1.z * q2.w + q1.w * q2.z;
    qReturn.w = -q1.x * q2.x - q1.y * q2.y - q1.z * q2.z + q1.w * q2.w;
    return qReturn;
  }
}
