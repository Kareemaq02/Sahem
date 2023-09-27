using Microsoft.AspNetCore.Http;

namespace Application.Seed.Images
{
    public class ImageLocalUpload : IFormFile
    {
        public static IFormFile CreateIFormFileFromLocalFile(string filePath)
        {
            byte[] fileBytes;
            using (var memoryStream = new MemoryStream())
            {
                using (var fileStream = new FileStream(filePath, FileMode.Open))
                {
                    fileStream.CopyTo(memoryStream);
                    fileBytes = memoryStream.ToArray();
                }
            }

            var stream = new MemoryStream(fileBytes);
            var file = new ImageLocalUpload(stream, stream.Length, Path.GetFileName(filePath));

            return file;
        }

        private readonly Stream _stream;
        private readonly long _length;
        private readonly string _fileName;

        public ImageLocalUpload(
            Stream stream,
            long length,
            string fileName,
            string contentType = null
        )
        {
            _stream = stream ?? throw new ArgumentNullException(nameof(stream));
            _length = length;
            _fileName = fileName ?? throw new ArgumentNullException(nameof(fileName));
            ContentType = contentType ?? "application/octet-stream";
        }

        public string ContentType { get; }

        public string ContentDisposition => $"form-data; name=\"{Name}\"; filename=\"{FileName}\"";

        public IHeaderDictionary Headers => new HeaderDictionary();

        public long Length => _length;

        public string Name => "image";

        public string FileName => _fileName;

        public Stream OpenReadStream()
        {
            return _stream;
        }

        public async Task CopyToAsync(Stream target, CancellationToken cancellationToken = default)
        {
            await _stream.CopyToAsync(target, cancellationToken);
        }

        public void CopyTo(Stream target)
        {
            _stream.CopyTo(target);
        }

        public Task CopyToAsync(
            Stream target,
            long length,
            CancellationToken cancellationToken = default
        )
        {
            return CopyToAsync(target, cancellationToken);
        }
    }
}
