namespace Application.Core
{
    public class PagingParams
    {
        private const int MaxPageSize = 200;
        public int PageNumber { get; set; } = 1;

        private int pageSize = 25;
        public int PageSize
        {
            get => pageSize;
            set => pageSize = value > MaxPageSize ? MaxPageSize : value;
        }
    }
}
