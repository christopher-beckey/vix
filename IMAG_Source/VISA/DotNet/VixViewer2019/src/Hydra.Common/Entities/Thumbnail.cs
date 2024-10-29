using System.IO;

namespace Hydra.Entities
{
    public class Thumbnail
    {
        public string ImageData { get; set; }

        public Thumbnail(string fileName)
        {
            this.ImageData = "data:image/png;base64," + System.Convert.ToBase64String(File.ReadAllBytes(fileName));
        }

        public Thumbnail(byte[] content)
        {
            this.ImageData = "data:image/png;base64," + System.Convert.ToBase64String(content);
        }
    }
}