// -----------------------------------------------------------------------
// <copyright file="FilemanEntryRepository.cs" company="Department of Veterans Affairs">
// TODO: Update copyright text.
// </copyright>
// -----------------------------------------------------------------------
namespace VistA.Imaging.DataNavigator.Repositories
{
    using System.Configuration;
    using System.Diagnostics.Contracts;
    using System.Linq;
    using ImagingClient.Infrastructure.Configuration;
    using ImagingClient.Infrastructure.User.Model;
    using RestSharp;
    using RestSharp.Deserializers;
    using RestSharp.Serializers;
    using VistA.Imaging.DataNavigator.Model;
    using VistaCommon;
    using VistaCommon.gov.va.med;

    /// <summary>
    /// Repository for FilemanEntry data access
    /// </summary>
    public class FilemanEntryRepository : IFilemanEntryRepository
    {
        #region Constants

        /// <summary>
        /// The REST path for a specific entry
        /// </summary>
        private const string EntryPath = "entry/{file}/{id}";

        /// <summary>
        /// The REST path for searching for an entry
        /// </summary>
        private const string SearchPath = "entry/{file}/{field}/{value}";

        /// <summary>
        /// The file segment of the URL
        /// </summary>
        private const string FileSegment = "file";

        /// <summary>
        /// The id segment of the URL
        /// </summary>
        private const string IdSegment = "id";

        /// <summary>
        /// The field segment of the URL
        /// </summary>
        private const string FieldSegment = "field";

        /// <summary>
        /// The value segment of the URL
        /// </summary>
        private const string ValueSegment = "value";

        #endregion

        /// <summary>
        /// Initializes a new instance of the <see cref="FilemanEntryRepository"/> class.
        /// </summary>
        public FilemanEntryRepository()
        {
        }

        #region Public Methods

        /// <summary>
        /// Gets the entry by id.
        /// </summary>
        /// <param name="file">The file containing the entry.</param>
        /// <param name="id">The id of the entry.</param>
        /// <returns>The entry with the specified id</returns>
        public FilemanEntry GetById(FilemanFile file, string id)
        {
            RestClient client = this.CreateRestClient();
            RestRequest request = this.CreateEntryRequest(file, id);
            IRestResponse<FilemanEntry> result = client.Execute<FilemanEntry>(request);
            if (result.ErrorException != null)
            {
                throw result.ErrorException;
            }

            if (result == null || result.Data == null || result.Data.Values == null || result.Data.Values.Length == 0)
            {
                return null;
            }

            this.MergeEntryWithFile(result.Data, file);
            return result.Data;
        }

        /// <summary>
        /// Gets the entry by pointer.
        /// </summary>
        /// <param name="pointerFieldValue">The pointer field value.</param>
        /// <returns>The entry pointed to by the specified pointerFiledValue</returns>
        public FilemanEntry GetByPointer(FilemanFieldValue pointerFieldValue)
        {
            FilemanEntry entry = null;
            if (pointerFieldValue.Field.Pointer is FilemanFieldPointer)
            {
                FilemanEntrySearchResult result = this.FindByIndexedField(
                    (pointerFieldValue.Field.Pointer as FilemanFieldPointer).TargetField,
                    pointerFieldValue.InternalValue);
                if (result.Entries != null && result.Entries.Length > 0)
                {
                    entry = result.Entries[0];
                }
            }
            else
            {
                entry = this.GetById(
                    (pointerFieldValue.Field.Pointer as FilemanFilePointer).TargetFile,
                    pointerFieldValue.InternalValue);
            }

            return entry;
        }

        /// <summary>
        /// Finds the entry by the specified indexed field.
        /// </summary>
        /// <param name="searchField">The search field.</param>
        /// <param name="value">The value.</param>
        /// <returns>The results of the search</returns>
        public FilemanEntrySearchResult FindByIndexedField(FilemanField searchField, string value)
        {
            RestClient client = this.CreateRestClient();
            RestRequest request = this.CreateSearchRequest(searchField, value);
            IRestResponse<FilemanEntrySearchResult> result = client.Execute<FilemanEntrySearchResult>(request);
            if (result.ErrorException != null)
            {
                throw result.ErrorException;
            }

            if (result.Data != null && result.Data.Entries != null)
            {
                foreach (FilemanEntry entry in result.Data.Entries)
                {
                    this.MergeEntryWithFile(entry, searchField.File);
                }
            }

            return result.Data;
        }

        /// <summary>
        /// Finds the by reverse pointer.
        /// </summary>
        /// <param name="entry">The entry.</param>
        /// <param name="pointer">The pointer.</param>
        /// <returns>The results of the search</returns>
        public FilemanEntrySearchResult FindByReversePointer(FilemanEntry entry, FilemanFilePointer pointer)
        {
            string searchValue;
            if (pointer is FilemanFieldPointer)
            {
                searchValue = entry[(pointer as FilemanFieldPointer).TargetField.Number].InternalValue;
            }
            else
            {
                searchValue = entry.Ien;
            }

            return this.FindByIndexedField(pointer.SourceField, searchValue);
        } 

        #endregion

        #region Private Methods

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
        /// Creates the entry request.
        /// </summary>
        /// <param name="file">The file containing the entry.</param>
        /// <param name="id">The id of the entry.</param>
        /// <returns>The entry request</returns>
        private RestRequest CreateEntryRequest(FilemanFile file, string id)
        {
            RestRequest request = new RestRequest();
            request.Resource = EntryPath;
            request.AddParameter(FileSegment, file.Number, ParameterType.UrlSegment);
            request.AddParameter(IdSegment, id, ParameterType.UrlSegment);
            return request;
        }

        /// <summary>
        /// Creates the search request.
        /// </summary>
        /// <param name="searchField">The search field.</param>
        /// <param name="value">The value.</param>
        /// <returns>The search request</returns>
        private RestRequest CreateSearchRequest(FilemanField searchField, string value)
        {
            RestRequest request = new RestRequest();
            request.Resource = SearchPath;
            request.AddParameter(FileSegment, searchField.File.Number, ParameterType.UrlSegment);
            request.AddParameter(FieldSegment, searchField.Number, ParameterType.UrlSegment);
            request.AddParameter(ValueSegment, value, ParameterType.UrlSegment);
            return request;
        }

        /// <summary>
        /// Merges the entry with the file.
        /// </summary>
        /// <param name="entry">The entry to merge.</param>
        /// <param name="file">The file to merge.</param>
        private void MergeEntryWithFile(FilemanEntry entry, FilemanFile file)
        {
            Contract.Requires(entry != null);
            Contract.Requires(file != null);
            entry.File = file;
            if (entry.Values != null)
            {
                foreach (FilemanFieldValue fieldValue
                    in entry.Values.Where(v => !string.IsNullOrWhiteSpace(v.FieldNumber)))
                {
                    fieldValue.Field = file[fieldValue.FieldNumber];
                }
            }
        } 

        #endregion
    }
}
