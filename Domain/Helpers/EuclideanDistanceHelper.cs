
namespace Domain.Helpers
{
    public class EuclideanDistanceHelper
    {
        public static double radiusInDegrees = ToDegrees(25);
        public static double EuclideanDistance(LatLng latLng1, LatLng latLng2)
        {


            // EuclideanDistance formula
            double a = Math.Pow((double)(latLng1.decLat - latLng2.decLat),2);
               
            double b = Math.Pow((double)(latLng1.decLng - latLng2.decLng), 2);

            double distance = Math.Sqrt(a+b);

            return distance;
        }

        public static double ToDegrees(double meters)
        {
            return meters / 111320;
        }

    }
}
