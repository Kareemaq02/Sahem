
using NetTopologySuite.Geometries;
using NetTopologySuite.IO;


namespace Application.Handlers.Complaints
{
    public class GetStateNameTemp

    {
        public  static string getStateNameByLatLng(
            decimal lat,
            decimal lng
        )
        {
            string stateName = "Not Found";
            
            
            GeometryFactory geometryFactory = new GeometryFactory();
            ShapefileDataReader shapefileDataReader = new ShapefileDataReader("C:/Users/LENOVO/Documents/Usa/USA_States.shp", geometryFactory);

            Coordinate coordinates = new Coordinate((double)lng, (double)lat);
            Point point = geometryFactory.CreatePoint(coordinates);

            while (shapefileDataReader.Read())
            {
                Geometry geometry = shapefileDataReader.Geometry;

                if (geometry.Contains(point))
                {

                    string attributeName = "STATE_NAME";
                    object attributeValue = shapefileDataReader[attributeName];

                    if (attributeValue != null)
                    {
                        stateName = attributeValue.ToString();
                    }

                }
            }

            shapefileDataReader.Close();

            return stateName;
        }
    }
}
