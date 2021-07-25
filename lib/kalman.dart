 import 'dart:math';

class KalmanLatdouble {
      double minAccuracy = 1;

     double q_metres_per_second;    
     double timeStamp_milliseconds;
     double lat;
     double lng;
     double variance; // P matrix.  Negative means object uninitialised.  NB: units irrelevant, as double as same units used throughout

     KalmanLatdouble(double Q_metres_per_second) { this.q_metres_per_second = Q_metres_per_second; variance = -1; }

     double getTimeStamp() { return timeStamp_milliseconds; }
     double getlat() { return lat; }
     double getlng() { return lng; }
     double getaccuracy() { return sqrt(variance); }

     void setState(double lat, double lng, double accuracy, double TimeStamp_milliseconds) {
        this.lat=lat; this.lng=lng; variance = accuracy * accuracy; this.timeStamp_milliseconds=TimeStamp_milliseconds;
    }

    /// <summary>
    /// Kalman filter processing for lattitude and doubleitude
    /// </summary>
    /// <param name="lat_measurement_degrees">new measurement of lattidude</param>
    /// <param name="lng_measurement">new measurement of doubleitude</param>
    /// <param name="accuracy">measurement of 1 standard deviation error in metres</param>
    /// <param name="TimeStamp_milliseconds">time of measurement</param>
    /// <returns>new state</returns>
     void process(double lat_measurement, double lng_measurement, double accuracy, double timeStamp_millisecondsIn) {
        if (accuracy < minAccuracy){
          accuracy = minAccuracy;

        } 
        if (variance == null || variance < 0) {
            // if variance < 0, object is unitialised, so initialise with current values
            this.timeStamp_milliseconds = timeStamp_millisecondsIn;
            lat=lat_measurement; lng = lng_measurement; variance = accuracy*accuracy; 
        } else {
            // else apply Kalman filter methodology

            double timeInc_milliseconds = timeStamp_millisecondsIn - this.timeStamp_milliseconds;
            if (timeInc_milliseconds > 0) {
                // time has moved on, so the uncertainty in the current position increases
                variance += timeInc_milliseconds * q_metres_per_second * q_metres_per_second / 1000;
                this.timeStamp_milliseconds = timeStamp_millisecondsIn;
                // TO DO: USE VELOCITY INFORMATION HERE TO GET A BETTER ESTIMATE OF CURRENT POSITION
            }

            // Kalman gain matrix K = Covarariance * Inverse(Covariance + MeasurementVariance)
            // NB: because K is dimensionless, it doesn't matter that variance has different units to lat and lng
            double K = variance / (variance + accuracy * accuracy);
            // apply K
            lat += K * (lat_measurement - lat);
            lng += K * (lng_measurement - lng);
            // new Covarariance  matrix is (IdentityMatrix - K) * Covarariance 
            variance = (1 - K) * variance;
        }
    }
}