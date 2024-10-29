using Hydra.IX.Storage;
using Nancy;
using System;
using System.Collections.Generic;
using System.Globalization;
using System.IO;
using System.Linq;
using System.Text;
using System.Text.RegularExpressions;

namespace Hydra.IX.Core.Modules
{
    public static class FormatterExtensions
    {
        public const int ReadStreamBufferSize = 1024 * 1024;

        public static string AsContentType(this Hydra.Common.ImagePartTransform transformType)
        {
            switch (transformType)
            {
                case Hydra.Common.ImagePartTransform.DicomData: return "application/dicom";
                case Hydra.Common.ImagePartTransform.Html: return "application/html";
                case Hydra.Common.ImagePartTransform.Jpeg: return "application/jpeg";
                case Hydra.Common.ImagePartTransform.Json: return "application/json";
                case Hydra.Common.ImagePartTransform.Pdf: return "application/pdf";
                case Hydra.Common.ImagePartTransform.Png: return "application/png";
                case Hydra.Common.ImagePartTransform.Mp3: return "audio/mp3";
                case Hydra.Common.ImagePartTransform.Mp4: return "video/mp4";
                case Hydra.Common.ImagePartTransform.Webm: return "video/webm";
                case Hydra.Common.ImagePartTransform.Avi: return "video/avi";
                case Hydra.Common.ImagePartTransform.DicomHeader: return "application/octet-stream";
                default: return "application/octet-stream";
            }
        }

        public static string AsAVContentType(this Hydra.IX.Database.Common.ImagePart imagePart)
        {
            switch (Path.GetExtension(imagePart.AbsolutePath).ToLower())
            {
                case ".mp4":
                case ".m4v":
                    return "video/mp4";

                case ".mp1":
                case ".mp2":
                case ".mpg":
                case ".mpeg":
                    return "video/mpeg";

                case ".webm":
                    return "video/mpeg";

                case ".mp3":
                    return "audio/mp3";

                case ".avi":
                    return "video/avi";

                case ".wmv":
                    return "video/x-ms-wmv";

                case ".wav":
                    return "audio/wav";

                default:
                    return "application/octet-stream";
            }
        }

        public static Response AsMedia(this IResponseFormatter formatter, 
                                       Hydra.IX.Database.Common.ImagePart imagePart, 
                                       Hydra.Common.ImagePartTransform transformType, 
                                       Request request)
        {
            if ((transformType == Hydra.Common.ImagePartTransform.Mp4) ||
                (transformType == Hydra.Common.ImagePartTransform.Webm) ||
                (transformType == Hydra.Common.ImagePartTransform.Avi))
            {
                string contentType = imagePart.AsAVContentType();

                // read unecrypted content into memory
                var stream = new MemoryStream();
                Hydra.IX.Storage.StorageManager.Instance.WriteStream(stream, imagePart, Hydra.Common.ImagePartTransform.Default);
                stream.Seek(0, SeekOrigin.Begin);

                var len = stream.Length;
                //VAI-582: Header names must be lowercase when sending and case-insensitive when reading
                var response = formatter.FromStream(stream, contentType)
                                   .WithHeader("connection", "keep-alive")
                                   .WithHeader("cache-control", "no-cache")
                                   .WithHeader("expires", "-1")
                                   .WithHeader("pragma", "no-cache")
                                   .WithHeader("accept-ranges", "bytes");

                // Use the partial status code
                if (request.Headers.Keys.Contains("range"))
                {
                    response.StatusCode = HttpStatusCode.PartialContent;
                    long startI = 0;
                    //VAI-582: Header names must be lowercase when sending and case-insensitive when reading
                    foreach (var s in request.Headers["range"])
                    {
                        var start = s.Split('=')[1];
                        var m = Regex.Match(start, @"(\d+)-(\d+)?");
                        start = m.Groups[1].Value;
                        var end = len - 1;
                        if (m.Groups[2] != null && !string.IsNullOrWhiteSpace(m.Groups[2].Value))
                        {
                            end = Convert.ToInt64(m.Groups[2].Value);
                        }

                        startI = Convert.ToInt64(start);
                        var length = len - startI;

                        //VAI-582: Header names must be lowercase when sending and case-insensitive when reading
                        response.WithHeader("content-range", "bytes " + start + "-" + end + "/" + len);
                        response.WithHeader("content-length", length.ToString(CultureInfo.InvariantCulture));
                    }

                    stream.Seek(startI, SeekOrigin.Begin);
                }
                else
                {
                    response.StatusCode = HttpStatusCode.OK;
                    //Commented out in P284 (do not use): response.StatusCode = HttpStatusCode.PartialContent;

                    //VAI-582: Header names must be lowercase when sending and case-insensitive when reading
                    response.WithHeader("content-range", "bytes " + 0 + "-" + (len - 1) + "/" + len);
                    response.WithHeader("content-length", len.ToString(CultureInfo.InvariantCulture));
                }

                return response;
            }
            else
            {
                return new Response
                {
                    Contents = stream =>
                    {
                        Hydra.IX.Storage.StorageManager.Instance.WriteStream(stream, imagePart, transformType);
                    },
                    ContentType = transformType.AsContentType(),
                    StatusCode = HttpStatusCode.OK
                };
            }
        }
    }

    public static class ResponseHelper
    {
        public static Response FromFile(int imagePartType, string absolutePath, bool isEncrypted, Hydra.Common.ImagePartTransform transformType, IDictionary<string, string> responseHeaders = null)
        {
            if (transformType == Hydra.Common.ImagePartTransform.Default)
            {
                if (imagePartType == (int)Hydra.Common.ImageType.Pdf)
                    transformType = Hydra.Common.ImagePartTransform.Pdf;
            }

            return new Response
            {
                Contents = stream =>
                {
                    Hydra.IX.Storage.StorageManager.Instance.WriteStream(stream, absolutePath, isEncrypted, transformType);
                },
                ContentType = transformType.AsContentType(),
                StatusCode = HttpStatusCode.OK,
                Headers = (responseHeaders == null ? new Dictionary<string, string>() : responseHeaders) 
            };
        }

        public static Response FromFile(Hydra.IX.Database.Common.ImagePart imagePart, Hydra.Common.ImagePartTransform transformType)
        {
            return FromFile(imagePart.Type, imagePart.AbsolutePath, imagePart.IsEncrypted, transformType);
        }

        public static Response FromStream(Hydra.Common.ImagePartTransform transformType, Action<Stream> action)
        {
            return new Response
            {
                Contents = stream =>
                {
                    action(stream);
                },
                ContentType = transformType.AsContentType(),
                StatusCode = HttpStatusCode.OK
            };
        }
    }
}