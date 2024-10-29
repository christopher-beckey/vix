using Hydra.IX.Common;
using Hydra.IX.Configuration;
using Hydra.IX.Database.Common;
using Hydra.Log;
using Hydra.Security;
using System;
using System.Collections.Concurrent;
using System.Collections.Generic;
using System.Configuration;
using System.Globalization;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading;
using System.Threading.Tasks;

namespace Hydra.IX.Storage
{
    public class StorageManager
    {
        private static readonly ILogger _Logger = LogManager.GetCurrentClassLogger();

        private static readonly Lazy<StorageManager> _Instance = new Lazy<StorageManager>(() => new StorageManager());

        public List<ImageStore> ImageStoreCollection = new List<ImageStore>();

        private BackgroundWorker<string> _ImageGroupCleaner = new BackgroundWorker<string>(5, (job, threadId, threadIndex, token) => StorageManager.Instance.DeleteGroup(job, token));

        private readonly object _PrimaryImageStoreSyncLock = new object();

        private IHixDbContextFactory _HixDbContextFactory;

        public static StorageManager Instance
        {
            get
            {
                return StorageManager._Instance.Value;
            }
        }

        public string CryptoPassword { get; set; }
        public string CryptoSalt { get; set; }

        public StorageManager()
        {
        }


        public void Initialize(IHixDbContextFactory hixDbContextFactory)
        {
            _HixDbContextFactory = hixDbContextFactory;

            var imageStores = HixConfigurationSection.Instance.ImageStores;
            for (int i = 0; i < imageStores.Count; i++)
            {
                var imageStore = new ImageStore
                {
                    Id = imageStores[i].Id,
                    Path = imageStores[i].Path,
                    IsLocal = imageStores[i].IsLocal,
                    IsEnabled = imageStores[i].IsEnabled,
                    IsEncrypted = imageStores[i].IsEncrypted,
                    FolderLevels = imageStores[i].FolderLevels,
                    Type = imageStores[i].Type,
                    SourceId = imageStores[i].SourceId,
                    SearchOrder = imageStores[i].SearchOrder,
                    DiskFullThreshold = imageStores[i].DiskFullThreshold,
                    AutoCreate = imageStores[i].AutoCreate
                };

                if (!string.IsNullOrEmpty(imageStores.Path))
                {
                    imageStore.Path = Path.Combine(imageStores.Path, imageStore.Path);
                    imageStore.IsLocal = imageStores.IsLocal;
                }

                // map encrypted value to image store properties
                imageStores[i].SecureElements.SetProperties(imageStore);

                // resolve path if relative path is set
                ResolvePath(imageStore);

                ImageStoreCollection.Add(imageStore);

                if (imageStore.IsEnabled && _Logger.IsInfoEnabled)
                    _Logger.Info("ImageStore initialized", "Path", imageStore.Path, "Type", imageStore.Type, "IsEncrypted", imageStore.IsEncrypted); 
            }

            // check for duplicate ids
            if (ImageStoreCollection.GroupBy(x => x.Id).Any(c => (c.Count() > 1)))
                throw new ConfigurationErrorsException("Duplicate image store ids found");

            HixConfigurationSection.Instance.SecureElements.SetProperties(this);

            if (GetPrimaryImageStore() == null)
                throw new ConfigurationErrorsException("No valid primary image store found");

            CacheImageStore = ImageStoreCollection.FirstOrDefault(x => ((x.Type == ImageStoreType.Cache) && x.IsEnabled));
            if (CacheImageStore == null)
                throw new ConfigurationErrorsException("No valid cache image store found");

            TempImageStore = ImageStoreCollection.FirstOrDefault(x => (x.Type == ImageStoreType.Temporary));
            if ((TempImageStore == null) || !TempImageStore.IsEnabled)
                throw new ConfigurationErrorsException("No valid temporary image store found");

            OpenConnections();

            _ImageGroupCleaner.Start();
        }

        public void Uninitialize()
        {
            _ImageGroupCleaner.Stop();

            CloseConnections();
        }

        private void ResolvePath(ImageStore imageStore)
        {
            if (!imageStore.IsLocal)
                return;

            string driveLetter = Path.GetPathRoot(imageStore.Path);
            if (!string.IsNullOrEmpty(driveLetter))
                return; // valid drive letter

            // append drive letter of install folder
            driveLetter = Path.GetPathRoot(AppDomain.CurrentDomain.BaseDirectory);
            imageStore.Path = Path.Combine(driveLetter, imageStore.Path);
        }

        private void OpenConnections()
        {
            foreach (var imageStore in ImageStoreCollection)
            {
                if (!imageStore.IsEnabled)
                    continue;

                if (imageStore.IsLocal)
                {
                    if (!Directory.Exists(imageStore.Path))
                    {
                        if (!imageStore.AutoCreate)
                            throw new ConfigurationErrorsException(string.Format("Image store path {0} does not exist", imageStore.Path));

                        Directory.CreateDirectory(imageStore.Path);
                    }
                }
                else
                {
                    int result = NetworkShareUtil.MapShare(imageStore.Path, imageStore.UserName, imageStore.Password, imageStore.Domain);
                    if (result != 0)
                    {
                        string msg = NetworkShareUtil.GetErrorMsg(result);
                        throw new ConfigurationErrorsException(string.Format("Failed to connect to network share {0}. {1}", imageStore.Path, msg));
                    }

                    imageStore.IsConnected = true;
                }
            }
        }

        private void CloseConnections()
        {
            foreach (var imageStore in ImageStoreCollection)
            {
                if (!imageStore.IsLocal && imageStore.IsConnected)
                {
                    int result = NetworkShareUtil.DisconnectShare(imageStore.Path);
                    if (result != 0)
                    {
                        string msg = NetworkShareUtil.GetErrorMsg(result);
                        //throw new ConfigurationErrorsException(string.Format("Failed to connect to network share {0}. {1}", imageStore.Path, msg));
                    }
                    imageStore.IsConnected = false;
                }
            }
        }

        public void StoreImage(ImageFile imageFile, ImageGroup imageGroup, Stream originalInputStream, string alternatePath)
        {
            ImageStore imageStore = ImageStoreCollection.FirstOrDefault(x => (x.Id == imageGroup.ImageStoreId));
            if (imageStore == null)
                throw new Exception("No image store id is either invalid or unavailable");

            // format file name
            string extension = Path.GetExtension(imageFile.FileName);
            string filename = string.Format("{0}{1}", imageFile.Id, string.IsNullOrEmpty(extension) ? ".org" : extension);
            imageFile.RelativePath = Path.Combine(imageGroup.RelativePath, filename);

            if (originalInputStream != null)
            {
                // format file path
                string folder = Path.Combine(imageStore.Path, imageGroup.RelativePath);
                if (!Directory.Exists(folder))
                    Directory.CreateDirectory(folder);

                string originalFilePath = Path.Combine(folder, filename);

                // write to image store
                using (Stream outputStream = new FileStream(originalFilePath, FileMode.Create))
                {
                    if (imageStore.IsEncrypted)
                    {
                        imageFile.IsEncrypted = true;
                        CryptoUtil.EncryptAES(originalInputStream, outputStream, CryptoPassword, CryptoSalt);
                    }
                    else
                    {
                        originalInputStream.CopyTo(outputStream);
                    }
                }
            }

            imageFile.IsUploaded = true;
            imageFile.DateUploaded = DateTime.UtcNow;
            imageFile.IsSucceeded = null;
            imageFile.AlternatePath = alternatePath;

            if (_Logger.IsInfoEnabled)
                _Logger.Info("File uploaded for image.", "ImageUid", imageFile.ImageUid, "FilePath", filename);
        }

        public string GetCacheFolder(ImageGroup imageGroup)
        {
            if (CacheImageStore == null)
                throw new Exception("Cache image store not configured");

            return (string.IsNullOrEmpty(CacheImageStore.Path) || string.IsNullOrEmpty(imageGroup.RelativePath)) ?
                null:
                Path.Combine(CacheImageStore.Path, imageGroup.RelativePath);
        }

        public string GetPrimaryFolder(ImageGroup imageGroup)
        {
            return GetPrimaryFolder(imageGroup.ImageStoreId, imageGroup.RelativePath);
        }

        public string GetPrimaryFolder(int imageStoreId, string relativePath)
        {
            ImageStore imageStore = ImageStoreCollection.FirstOrDefault(x => (x.Id == imageStoreId));
            if (imageStore == null)
                throw new Exception("Image store id is either invalid or unavailable");

            return (string.IsNullOrEmpty(imageStore.Path) || string.IsNullOrEmpty(relativePath)) ?
                null :
                Path.Combine(imageStore.Path, relativePath);
        }

        public string GetImagePath(ImageFile imageFile, ImageGroup imageGroup)
        {
            ImageStore imageStore = ImageStoreCollection.FirstOrDefault(x => (x.Id == imageGroup.ImageStoreId));
            if (imageStore == null)
                throw new Exception("Image store id is either invalid or unavailable");

            return (string.IsNullOrEmpty(imageStore.Path) || string.IsNullOrEmpty(imageFile.RelativePath))?
                null:
                Path.Combine(imageStore.Path, imageFile.RelativePath);
        }

        public string GetImagePath(int imageStoreId, string relativePath)
        {
            ImageStore imageStore = ImageStoreCollection.FirstOrDefault(x => (x.Id == imageStoreId));
            if (imageStore == null)
                throw new Exception("Image store id is either invalid or unavailable");

            return (string.IsNullOrEmpty(imageStore.Path) || string.IsNullOrEmpty(relativePath)) ?
                null :
                Path.Combine(imageStore.Path, relativePath);
        }

        public Stream GetImageStream(ImageFile imageFile, ImageGroup imageGroup, out string filePath)
        {
            ImageStore imageStore = ImageStoreCollection.FirstOrDefault(x => (x.Id == imageGroup.ImageStoreId));
            if (imageStore == null)
                throw new Exception("Image store id is either invalid or unavailable");

            filePath = Path.Combine(imageStore.Path, imageFile.RelativePath);
            using (var fileStream = new FileStream(filePath, FileMode.Open, FileAccess.ReadWrite))
            {
                return CryptoUtil.DecryptAES(fileStream, CryptoPassword, CryptoSalt);
            }
        }

        public Hydra.Common.IFileStorage GetFileStorage()
        {
            Hydra.Common.IFileStorage fileStorage = null;
            if (StorageManager.Instance.CacheImageStore.IsEncrypted)
            {
                // use encrypted file storage
                fileStorage = new HixCryptoFileStorage(CryptoPassword, CryptoSalt);
            }
            else
            {
                fileStorage = new Hydra.Common.DefaultFileStorage();
            }

            return fileStorage;
        }

        public void WriteStream(Stream outputStream, string absolutePath, bool isEncrypted, Hydra.Common.ImagePartTransform transformType)
        {
            if (transformType.IsText())
            {
                if (isEncrypted && transformType == Hydra.Common.ImagePartTransform.Html)
                {
                    using (var fileStream = File.Open(absolutePath, FileMode.Open, FileAccess.Read, FileShare.Read))
                    {
                        // decrypt binary content
                        CryptoUtil.DecryptAES(fileStream, outputStream, CryptoPassword, CryptoSalt);
                    }
                }
                else
                {
                    string text = GetText(absolutePath, isEncrypted);
                    using (StreamWriter writer = new StreamWriter(outputStream, Encoding.UTF8, 512, true))
                    {
                        writer.Write(text);
                    }
                }
            }
            else
            {
                if (File.Exists(absolutePath))
                {
                    using (var fileStream = File.Open(absolutePath, FileMode.Open, FileAccess.Read, FileShare.Read))
                    {
                        if (isEncrypted)
                        {
                            // decrypt binary content
                            CryptoUtil.DecryptAES(fileStream, outputStream, CryptoPassword, CryptoSalt);
                        }
                        else
                        {
                            fileStream.CopyTo(outputStream);
                        }
                    }
                }
            }
        }

        public void WriteStream(Stream outputStream, ImagePart imagePart, Hydra.Common.ImagePartTransform transformType)
        {
            WriteStream(outputStream, imagePart.AbsolutePath, imagePart.IsEncrypted, transformType);
        }

        public byte[] GetBytes(ImagePart imagePart)
        {
            return GetBytes(imagePart.AbsolutePath, imagePart.IsEncrypted);
        }

        public byte[] GetBytes(string absolutePath, bool isEncrypted)
        {
            if (isEncrypted)
            {
                using (var fileStream = File.Open(absolutePath, FileMode.Open, FileAccess.Read, FileShare.ReadWrite))
                {
                    return CryptoUtil.DecryptBytes(fileStream, CryptoPassword, CryptoSalt);
                }
            }
            else
                return GetBytes(absolutePath);
        }

        private byte[] GetBytes(string filePath)
        {
            using (var fileStream = File.Open(filePath, FileMode.Open, FileAccess.Read, FileShare.ReadWrite))
            {
                int length = Convert.ToInt32(fileStream.Length);
                byte[] buffer = new byte[length];
                fileStream.Read(buffer, 0, length);
                return buffer;
            }
        }

        public string GetText(string absolutePath, bool isEncrypted)
        {
            using (var fileStream = new FileStream(absolutePath, FileMode.Open, FileAccess.Read, FileShare.ReadWrite))
            {
                using (var textReader = new StreamReader(fileStream))
                {
                    var content = textReader.ReadToEnd();

                    return (isEncrypted) ?
                        CryptoUtil.DecryptAES(content, CryptoPassword, CryptoSalt) :
                        content;
                }
            }
        }

        public string GetText(ImagePart imagePart)
        {
            return GetText(imagePart.AbsolutePath, imagePart.IsEncrypted);
        }

        public Stream GetStream(ImagePart imagePart)
        {
            return GetStream(imagePart.AbsolutePath, imagePart.IsEncrypted);
        }

        public Stream GetStream(string absolutePath, bool isEncrypted)
        {
            if (isEncrypted)
            {
                using (var fileStream = new FileStream(absolutePath, FileMode.Open, FileAccess.Read, FileShare.ReadWrite))
                {
                    return CryptoUtil.DecryptAES(fileStream, CryptoPassword, CryptoSalt);
                }
            }
            else
            {
                return new FileStream(absolutePath, FileMode.Open, FileAccess.Read, FileShare.ReadWrite);
            }
        }

        public ImageStore PrimaryImageStore
        {
            get;
            private set;
        }

        public ImageStore CacheImageStore
        {
            get;
            private set;
        }

        public ImageStore TempImageStore
        {
            get;
            private set;
        }

        public ImageStore GetPrimaryImageStore()
        {
            lock (_PrimaryImageStoreSyncLock)
            {
                if (PrimaryImageStore == null)
                {
                    // search for first available image store
                    foreach (var imageStore in ImageStoreCollection)
                    {
                        if ((imageStore.Type == ImageStoreType.Primary) &&
                            imageStore.IsEnabled &&
                            (imageStore.IsLocal || imageStore.IsConnected) &&
                            !imageStore.IsDriveFull())
                        {
                            PrimaryImageStore = imageStore;
                            break;
                        }
                    }
                }
                else
                {
                    // check if current image store is full
                    if (PrimaryImageStore.IsDriveFull())
                    {
                        PrimaryImageStore.IsEnabled = false;
                        PrimaryImageStore = null;

                        // search again
                        PrimaryImageStore = GetPrimaryImageStore();
                    }
                }
            }

            if (PrimaryImageStore == null)
                throw new Exception("No primary image store available");

            return PrimaryImageStore;
        }

        public void DeleteImageGroups(List<ImageGroup> imageGroupList, bool deleteNow)
        {
            foreach (var imageGroup in imageGroupList)
            {
                if (deleteNow)
                {
                    DeleteGroup(imageGroup.GroupUid, null);
                }
                else
                {
                    // queue for deletion
                    _ImageGroupCleaner.QueueJob(imageGroup.GroupUid);
                }
            }
        }

        private void DeleteGroup(string imageGroupUid, CancellationToken? token)
        {
            try
            {
                ImageGroup imageGroup = null;
                List<ImageFile> imageList = null;

                using (var ctx = _HixDbContextFactory.Create())
                {
                    imageGroup = ctx.ImageGroups.Where(x => (x.GroupUid == imageGroupUid)).FirstOrDefault();
                    if (imageGroup == null)
                    {
                        _Logger.Error("Error deleting image group. Does not exist", "GroupUid", imageGroupUid);
                        return;
                    }
    
                    imageList = ctx.Images.Where(x => (x.GroupUid == imageGroupUid)).ToList();
                }

                if (imageList != null)
                {
                    foreach (var image in imageList)
                    {
                        if (token.HasValue && token.Value.IsCancellationRequested)
                            break;

                        // delete images by combining image store path with relative path
                        DeleteImage(image.ImageUid, imageGroup.ImageStoreId);

                        // delete image parts using their absolute image path
                        DeleteImageParts(image.ImageUid);
                    }

                    // try deleting image group folders
                    SafeDeleteFolder(GetPrimaryFolder(imageGroup));
                    SafeDeleteFolder(GetCacheFolder(imageGroup));
                }

                if (token.HasValue && token.Value.IsCancellationRequested)
                    return;

                // delete image group only if all images have been deleted
                using (var ctx = _HixDbContextFactory.Create())
                {
                    imageGroup = ctx.ImageGroups.Where(x => (x.GroupUid == imageGroupUid)).FirstOrDefault();
                    if (imageGroup != null)
                    {
                        imageList = ctx.Images.Where(x => (x.GroupUid == imageGroupUid)).ToList();
                        if ((imageList == null) || (imageList.Count == 0))
                        {
                            ctx.ImageGroups.Remove(imageGroup);
                            ctx.SaveChanges();

                            if (_Logger.IsInfoEnabled)
                                _Logger.Info("Image group deleted.", "GroupUid", imageGroupUid);
                        }
                    }
                }

            }
            catch (Exception ex)
            {
                _Logger.Error("Error deleting group", "Exception", ex.Message);
            }
            finally
            {
            }
        }

        private void DeleteImage(string imageUid, int imageStoreId)
        {
            try
            {
                using (var ctx = _HixDbContextFactory.Create())
                {
                    var imageFile = ctx.Images.Where(x => (x.ImageUid == imageUid)).FirstOrDefault();
                    if (imageFile == null)
                        throw new ArgumentException(string.Format("Image {0} not found. Cannot delete.", imageUid));
                    
                    // delete original image if owner
                    if (imageFile.IsOwner)
                    {
                        try
                        {
                            string path = GetImagePath(imageStoreId, imageFile.RelativePath);
                            if (!String.IsNullOrEmpty(path) && File.Exists(path))
                            {
                                if (_Logger.IsDebugEnabled)
                                    _Logger.Debug("Deleting image file", "ImageUid", imageUid, "Path", path);

                                File.Delete(path);
                            }
                            else
                            {
                                if (_Logger.IsDebugEnabled)
                                    _Logger.Debug("File path not valid or file does not exist.", "ImageUid", imageUid, "Path", path);
                            }
                        }
                        catch (Exception ex)
                        {
                            _Logger.Error("Error deleting image", "Exception", ex.ToString());
                        }
                    }

                    ctx.Images.Remove(imageFile);
                    ctx.SaveChanges();

                    if (_Logger.IsDebugEnabled)
                        _Logger.Debug("Image deleted.", "ImageUid", imageFile.ImageUid);
                }
            }
            catch (Exception ex)
            {
                _Logger.Error("Error deleting image", "Exception", ex.ToString());
            }
            finally
            {
            }
        }        

        public void PurgePdf(string imageUid, string imagePartsPath) // VAI-307
        {
            string pdfFile = string.Empty;
            string baseFolder = string.Empty;
            if ((imageUid == null) || (imagePartsPath == null)) return;
            try
            {
                String[] strlist = imagePartsPath.Split('\\');
                string prepend = imagePartsPath.Substring(imagePartsPath.IndexOf(strlist[strlist.Length - 6]), imagePartsPath.LastIndexOf('\\') - imagePartsPath.IndexOf(strlist[strlist.Length - 6])).Replace("\\", string.Empty);

                baseFolder = AppDomain.CurrentDomain.BaseDirectory.Replace("VIX.Render.Service", "VIX.Viewer.Service");
                pdfFile = $@"{baseFolder}Viewer\files\pdffiles\{prepend}_{imageUid}_PRT.pdf";
                _Logger.Info("Purging pdf for print/export.", "imageUid", imageUid, "pdfFile", pdfFile);

                if (File.Exists(pdfFile))
                    File.Delete(pdfFile);
                
                //VAI-1284 purge the servePdf file
                pdfFile = $@"{baseFolder}Viewer\files\pdffiles\{prepend}_{imageUid}_SPU.pdf";
                _Logger.Info("Purging pdf for servePdf.", "imageUid", imageUid, "pdfFile", pdfFile);

                if (File.Exists(pdfFile))
                    File.Delete(pdfFile);
            }
            catch (Exception ex)
            {
                _Logger.Error("Error deleting pdf part file", "pdfFile", pdfFile, "ImageUid", imageUid, "Exception", ex.ToString());
            }
            using (var ctx = _HixDbContextFactory.Create())
            {
                string pdfFolder = string.Empty;
                try
                {
                    pdfFolder = $@"{baseFolder}Viewer\files\pdffiles\";
                    if (Directory.Exists(pdfFolder))
                    {
                        string[] pdfFiles = Directory.GetFiles(pdfFolder, "*_PRT.pdf", SearchOption.TopDirectoryOnly);
                        _Logger.Info("Purging pdf folder.", "PdfFolder", pdfFolder);
                        foreach (var filePath in pdfFiles)
                        {
                            if (Path.GetFileName(filePath).Substring(10, 1) == "_" && Path.GetFileName(filePath).Substring(19, 1) == "-" && Path.GetFileName(filePath).Substring(24, 1) == "-" && Path.GetFileName(filePath).Substring(29, 1) == "-" && Path.GetFileName(filePath).Length == 55)
                            {
                                string imagePartId = Path.GetFileName(filePath).Substring(11);
                                var imageParts = ctx.ImageParts.Where(x => (x.ImageUid == imagePartId));
                                if (imageParts.Count() == 0 && imagePartId.Length == 44 && File.Exists(filePath))
                                {
                                    _Logger.Info("Purging pdf folder file.", "filePath", filePath);
                                    File.Delete(filePath);
                                }
                            }
                        }
                        //VAI-1284 purge the pdfUrl files
                        pdfFiles = Directory.GetFiles(pdfFolder, "*_SPU.pdf", SearchOption.TopDirectoryOnly);
                        _Logger.Info("Purging servePdf folder.", "PdfFolder", pdfFolder);
                        foreach (var filePath in pdfFiles)
                        {
                            if (Path.GetFileName(filePath).Substring(10, 1) == "_" && Path.GetFileName(filePath).Substring(19, 1) == "-" && Path.GetFileName(filePath).Substring(24, 1) == "-" && Path.GetFileName(filePath).Substring(29, 1) == "-" && Path.GetFileName(filePath).Length == 55)
                            {
                                string imagePartId = Path.GetFileName(filePath).Substring(11);
                                var imageParts = ctx.ImageParts.Where(x => (x.ImageUid == imagePartId));
                                if (imageParts.Count() == 0 && imagePartId.Length == 44 && File.Exists(filePath))
                                {
                                    _Logger.Info("Purging servePdf folder file.", "filePath", filePath);
                                    File.Delete(filePath);
                                }
                            }
                        }
                    }
                }
                catch (Exception ex)
                {
                    _Logger.Error("Error purging pdf folder.", "pdfFolder", pdfFolder, "Exception", ex.ToString());
                }
            }
        }

        public void DeleteImageParts(string imageUid) 
        {
            string directoryName = "";//VAI-307
            try
            {
                using (var ctx = _HixDbContextFactory.Create())
                {
                    var imageParts = ctx.ImageParts.Where(x => (x.ImageUid == imageUid));
                    foreach (var imagePart in imageParts)
                    {
                        try
                        {
                            if (File.Exists(imagePart.AbsolutePath))
                                File.Delete(imagePart.AbsolutePath);
                            directoryName = Path.GetDirectoryName(imagePart.AbsolutePath);//VAI-307
                            
                            if (imagePart.Frame == 0)//VAI-307
                                PurgePdf(imageUid, imagePart.AbsolutePath);
                            else if (imagePart.Frame == -1 && imagePart.Transform== ((int)Hydra.Common.ImagePartTransform.Pdf))//VAI-1284
                            {
                                PurgePdf(imageUid, imagePart.AbsolutePath);
                            }
                        }
                        catch (Exception ex)
                        {
                            _Logger.Error("Error deleting image part file", "FilePath", imagePart.AbsolutePath, "ImageUid", imagePart.ImageUid, "Exception", ex.ToString());
                        }

                        ctx.ImageParts.Remove(imagePart);

                        if (_Logger.IsDebugEnabled)
                            _Logger.Debug("Image part deleted.", "FilePath", imagePart.AbsolutePath, "ImageUid", imagePart.ImageUid);
                    }

                    ctx.SaveChanges();
                }
            }
            catch (Exception ex)
            {
                _Logger.Error("Error deleting image part", "Exception", ex.Message);
            }
            finally
            {
            }


            try
            {
                using (var ctx = _HixDbContextFactory.Create())
                {
                    var imageParts = ctx.ImageParts.Where(x => (x.ImageUid != imageUid));
                    //Clean up any stray files from user abandiment not found in the database
                    string[] fileEntries = Directory.GetFiles(directoryName);
                    foreach (string fileName in fileEntries)
                    {
                        bool found = false;
                        foreach (var imagePart in imageParts) {
                            if(fileName== imagePart.AbsolutePath)
                            {
                                found = true;
                                break;
                            }
                        }
                        if (found == false) {
                            if (File.Exists(fileName)) 
                                File.Delete(fileName);
                        }
                    }
  
                }
            }
            catch (Exception ex)
            {
                _Logger.Error("Error deleting image part", "Exception", ex.Message);
            }
            finally
            {
            }




        }

        private void SafeDeleteFolder(string path)
        {
            try
            {
                if (!string.IsNullOrEmpty(path) && Directory.Exists(path) && IsDirectoryEmpty(path))
                {
                    Directory.Delete(path);
                }
            }
            catch (Exception ex)
            {
                _Logger.Error("Failed to delete folder", "Path", path, "Exception", ex.ToString());
            }
        }

        private bool IsDirectoryEmpty(string path)
        {
            IEnumerable<string> items = Directory.EnumerateFileSystemEntries(path);
            using (IEnumerator<string> en = items.GetEnumerator())
            {
                return !en.MoveNext();
            }
        }

        public bool IsImageGroupCleanerIdle
        {
            get
            {
                return _ImageGroupCleaner.IsIdle;
            }
        }

        public bool IsCacheFull(double minDiskSpaceMB)
        {
            double dirSizeMB = GetDirectorySize(CacheImageStore);
            return (dirSizeMB > minDiskSpaceMB);
        }

        public bool IsCacheFull(double minDiskSpaceMB, out double dirSizeMB)
        {
            dirSizeMB = GetDirectorySize(CacheImageStore);
            return (dirSizeMB > minDiskSpaceMB);
        }

        public double GetDirectorySize(ImageStore imageStore)
        {
            var dirInfo = new DirectoryInfo(imageStore.Path);
            double dirSizeMB = ((double)DirectorySize(dirInfo, true) / (1024 * 1024));
            return dirSizeMB;
        }

        public double GetDiskFreeSpaceMB()
        {
            FileInfo fileInfo = new FileInfo(CacheImageStore.Path);
            DriveInfo driveInfo = new DriveInfo(fileInfo.Directory.Root.FullName);

            return driveInfo.TotalFreeSpace / (Math.Pow(1024, 2));
        }

        private long DirectorySize(DirectoryInfo dirInfo, bool includeSubDir)
        {
            long totalSize = dirInfo.EnumerateFiles().Sum(file => file.Length);
            
            if (includeSubDir)
                totalSize += dirInfo.EnumerateDirectories().Sum(dir => DirectorySize(dir, true));

            return totalSize;
        }

        public int DeleteEmptyFolders()
        {
            int folderCount = 0;

            if ((CacheImageStore != null) && Directory.Exists(CacheImageStore.Path))
            {
                var directories = Directory.GetDirectories(CacheImageStore.Path);
                if (directories != null)
                {
                    foreach (var item in directories)
                    {
                        DeleteEmptyFolders(new DirectoryInfo(item), ref folderCount);
                    }
                }
            }

            return folderCount;
        }

        private void DeleteEmptyFolders(DirectoryInfo tree, ref int folderCount)
        {
            foreach (DirectoryInfo di in tree.EnumerateDirectories())
            {
                DeleteEmptyFolders(di, ref folderCount);
            }

            tree.Refresh();

            if (!tree.EnumerateFileSystemInfos().Any())
            {
                tree.Delete();

                folderCount++;
            }
        }
    }
}
