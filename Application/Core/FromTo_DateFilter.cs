namespace Application.Core
{
    public class FromTo_DateFilter : PagingParams
    {
        public DateTime dtmDatefrom { get; set; } = DateTime.MinValue;
        public DateTime dtmDateTo { get; set; } = DateTime.MinValue;
    }
}
