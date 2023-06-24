namespace Domain.Helpers
{
    public class HaversineHelper
    {
        public static double HaversineDistance(LatLng latLng1, LatLng latLng2)
        {
            // Radius of the Earth in meters
            double R = 6371000;

            // Convert coordinates from degrees to radians
            double lat1Rad = ToRadians((double)latLng1.decLat);
            double lng1Rad = ToRadians((double)latLng1.decLng);
            double lat2Rad = ToRadians((double)latLng2.decLat);
            double lng2Rad = ToRadians((double)latLng2.decLng);

            // Calculate differences
            double dlat = lat2Rad - lat1Rad;
            double dlng = lng2Rad - lng1Rad;

            // Haversine formula
            double a =
                Math.Sin(dlat / 2) * Math.Sin(dlat / 2)
                + Math.Cos(lat1Rad) * Math.Cos(lat2Rad) * Math.Sin(dlng / 2) * Math.Sin(dlng / 2);
            double c = 2 * Math.Atan2(Math.Sqrt(a), Math.Sqrt(1 - a));
            double distance = R * c;

            return distance;
        }

        public static double ToRadians(double degrees)
        {
            return degrees * Math.PI / 180;
        }
    }
}
