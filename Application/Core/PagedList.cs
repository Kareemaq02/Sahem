using Microsoft.EntityFrameworkCore;

namespace Application.Core
{
    public class PagedList<T> : List<T>
    {
        public PagedList(IEnumerable<T> data, int count, int pageNumber, int pageSize)
        {
            CurrentPage = pageNumber;
            TotalPages = (int)Math.Ceiling(count / (double)pageSize);
            PageSize = pageSize;
            TotalCount = count;
            AddRange(data);
        }

        public int CurrentPage { get; set; }
        public int TotalPages { get; set; }
        public int PageSize { get; set; }
        public int TotalCount { get; set; }

        // Server-side paging with the database
        public static async Task<PagedList<T>> CreateAsync(
            IQueryable<T> source,
            int pageNumber,
            int pageSize
        )
        {
            var count = await source.CountAsync();
            var items = await source.Skip((pageNumber - 1) * pageSize).Take(pageSize).ToListAsync();
            return new PagedList<T>(items, count, pageNumber, pageSize);
        }

        // Perform in-memory paging
        public static async Task<PagedList<T>> CreateAsync(
            IEnumerable<T> source,
            int pageNumber,
            int pageSize
        )
        {
            var count = source.Count();
            var pagedItems = source.Skip((pageNumber - 1) * pageSize).Take(pageSize);
            var pagedList = new PagedList<T>(pagedItems, count, pageNumber, pageSize);
            return await Task.FromResult(pagedList);
        }
    }
}
