
using Domain.DataModels.Complaints;
using Domain.Helpers;
using NetTopologySuite.Geometries;
using NetTopologySuite.IO;
using System.Text;
using System.Text.RegularExpressions;

namespace Application.Core
{
    public class GetRegionName

    {
        public  static RegionNames getRegionNameByLatLng(
            decimal lat,
            decimal lng
        )
        {
            RegionNames regionNames = new RegionNames {
            strRegionAr = "مجهول",
            strRegionEn = "Unknown",
            };

            try
            {
                GeometryFactory geometryFactory = new GeometryFactory();
                string baseDirectory = AppDomain.CurrentDomain.BaseDirectory;
                string shapefileRelativePath = "..\\..\\..\\..\\Domain\\Helpers\\JordanShapeFiles\\geoBoundaries-JOR-ADM2.shp";
                string shapefilePath = Path.GetFullPath(Path.Combine(baseDirectory, shapefileRelativePath));
                var encoding = Encoding.UTF8;
                ShapefileDataReader shapefileDataReader = new ShapefileDataReader(shapefilePath, geometryFactory, encoding);

                Coordinate coordinates = new Coordinate((double)lng, (double)lat);
                Point point = geometryFactory.CreatePoint(coordinates);

                while (shapefileDataReader.Read())
                {
                    Geometry geometry = shapefileDataReader.Geometry;

                    if (geometry.Contains(point))
                    {

                        string regionEn = "shapeName";
                        object enRegionAttribute = shapefileDataReader[regionEn];
                        string regionAr = "regionAr";
                        object arRegionAttribute = shapefileDataReader[regionAr];
                        if (enRegionAttribute != null)
                        {
                            regionNames.strRegionEn = enRegionAttribute.ToString();
                            regionNames.strRegionAr = arRegionAttribute.ToString();
                        }

                    }
                }

                shapefileDataReader.Close();
            }
            catch (IndexOutOfRangeException)
            {
                var regionNames2 = new RegionNames
                {
                    strRegionAr = "خارج الحدود",
                    strRegionEn = "Out of Bounds"
                };
                return regionNames2;
            }

            return regionNames;
        }
    }
}
