namespace Application.Core
{
    public class UsersFilter : PagingParams
    {
        public Boolean blnIsVerified { get; set; }
        public Boolean blnIsBlacklisted { get; set; }
    }
}
