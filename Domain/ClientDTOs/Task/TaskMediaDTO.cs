using Domain.Helpers;

public class TaskMediaDTO
{
    public int intComplaintId { get; set; }
    public string Data { get; set; }
    public bool blnIsVideo { get; set; }
    public LatLng decLatLng { get; set; }
    public RegionNames region { get; set; }
}
