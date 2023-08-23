
using NetTopologySuite.Geometries;
using NetTopologySuite.IO;
using System.Text.RegularExpressions;

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
            ShapefileDataReader shapefileDataReader = new ShapefileDataReader("C:/Users/LENOVO/Documents/Jordan/geoBoundaries-JOR-ADM2.shp", geometryFactory);

            Coordinate coordinates = new Coordinate((double)lng, (double)lat);
            Point point = geometryFactory.CreatePoint(coordinates);

            while (shapefileDataReader.Read())
            {
                Geometry geometry = shapefileDataReader.Geometry;

                if (geometry.Contains(point))
                {

                    string attributeName = "shapeName";
                    object attributeValue = shapefileDataReader[attributeName];

                    if (attributeValue != null)
                    {
                        stateName = attributeValue.ToString();
                         stateName = Regex.Replace(stateName, "[^a-zA-Z]", "");
                    }

                }
            }

            shapefileDataReader.Close();
           
            return stateName;
        }
    }
}
