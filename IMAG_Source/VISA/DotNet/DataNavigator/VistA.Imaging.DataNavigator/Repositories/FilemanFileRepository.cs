// -----------------------------------------------------------------------
// <copyright file="FilemanFileRepository.cs" company="Department of Veterans Affairs">
// TODO: Update copyright text.
// </copyright>
// -----------------------------------------------------------------------
namespace VistA.Imaging.DataNavigator.Repositories
{
    using System;
    using System.Configuration;
    using System.Runtime.Caching;
    using ImagingClient.Infrastructure.Configuration;
    using ImagingClient.Infrastructure.User.Model;
    using RestSharp;
    using RestSharp.Deserializers;
    using VistA.Imaging.DataNavigator.Model;
    using VistaCommon;
    using VistaCommon.gov.va.med;

    /// <summary>
    /// Repository for getting fileman files
    /// </summary>
    public class FilemanFileRepository : CachingRepository<FilemanFile, string>, IFilemanFileRepository
    {
        /// <summary>
        /// The path to the file service
        /// </summary>
        private const string FilePath = "file/{file}";

        /// <summary>
        /// The file segment of the URL
        /// </summary>
        private const string FileSegment = "file";

        /// <summary>
        /// Initializes a new instance of the <see cref="FilemanFileRepository"/> class.
        /// </summary>
        /// <param name="cache">The cache.</param>
        public FilemanFileRepository(ObjectCache cache)
            : base(cache)
        {
        }

        /// <summary>
        /// Gets the by id.
        /// </summary>
        /// <param name="id">The id of the FilemanFile</param>
        /// <returns>The FilemanFile with the specified id</returns>
        public override FilemanFile GetById(string id)
        {
            FilemanFile file = Cache[id] as FilemanFile;
            if (file == null)
            {
                RestClient client = this.CreateRestClient();
                RestRequest request = this.CreateFileRequest(id);
                IRestResponse<FilemanFile> result = client.Execute<FilemanFile>(request);
                if (result.ErrorException != null)
                {
                    // Handles the case where a user logged in does not have the correct keys.
                    if (result.ErrorException is System.Xml.XmlException)
                    {
                        throw new Exception("This user does not have the proper keys to continue. The Data Navigator requires MAG VIX ADMIN. \n", result.ErrorException);
                    } 
                    else
                    {
                        throw result.ErrorException;
                    }
                }

                file = result.Data;
                this.Cache.Add(id, file, new CacheItemPolicy() { SlidingExpiration = new TimeSpan(1, 0, 0) });
                foreach (FilemanField field in file.Fields)
                {
                    field.File = file;
                    if (!String.IsNullOrEmpty(field.PointerFileNumber))
                    {
                        field.IsIndexed = true;
                        field.Pointer = new FilemanFilePointer(this, field, field.PointerFileNumber);
                    }
                }
            }

            return file;
        }

        public void GetByIdAsync(string id, Action<FilemanFile> callback)
        {
            FilemanFile file = Cache[id] as FilemanFile;
            if (file == null)
            {
                RestClient client = this.CreateRestClient();
                RestRequest request = this.CreateFileRequest(id);
                client.ExecuteAsync<FilemanFile>(request, (result) =>
                {
                    if (result.ErrorException != null)
                    {
                        throw result.ErrorException;
                    }

                    file = result.Data;
                    this.Cache.Add(id, file, new CacheItemPolicy() { SlidingExpiration = new TimeSpan(1, 0, 0) });
                    foreach (FilemanField field in file.Fields)
                    {
                        field.File = file;
                        if (!String.IsNullOrEmpty(field.PointerFileNumber))
                        {
                            field.IsIndexed = true;
                            field.Pointer = new FilemanFilePointer(this, field, field.PointerFileNumber);
                        }
                    }

                    callback(file);
                });
            }
            else
            {
                callback(file);
            }
        }

        /// <summary>
        /// Creates the rest client.
        /// </summary>
        /// <returns>The rest client</returns>
        private RestClient CreateRestClient()
        {
            RestClient client;
            client = new RestClient();
            client.BaseUrl = DataNavigatorModule.DataDictionaryServicesRootUrl.ToString();
            client.AddHandler("application/xml", new DotNetXmlDeserializer());
            if (UserContext.UserCredentials != null)
            {
                client.Authenticator = new HttpBasicAuthenticator(UserContext.UserCredentials.AccessCode, UserContext.UserCredentials.VerifyCode);
            }

            return client;
        }

        /// <summary>
        /// Creates the file request.
        /// </summary>
        /// <param name="id">The id of the file.</param>
        /// <returns>The file request</returns>
        private RestRequest CreateFileRequest(string id)
        {
            RestRequest request = new RestRequest();
            request.Resource = FilePath;
            request.AddParameter(FileSegment, id, ParameterType.UrlSegment);
            return request;
        }
    }
}
