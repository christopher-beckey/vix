using Hydra.Web.Common;
using Ionic.Zip;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace VIX.Viewer.Service.Client.Test
{
    public partial class Form1 : Form
    {
        DisplayContext DisplayContext;
        Settings Settings;
        StudyQuery StudyQuery;

        Task CacheDisplayContextTask;
        CancellationTokenSource CacheDisplayContextTaskCancelToken;

        Task CreateDicomDirTask;
        CancellationTokenSource CreateDicomDirTaskCancelToken;

        object _SyncObject = new object();

        public Form1()
        {
            InitializeComponent();

            Settings = new Settings
            {
                // server
                HostName = "localhost",
                PortNumber = 9911,

                // user
                UserCredentials = new UserCredentials
                {
                    DUZ = "20095",
                    FullName = "FRANK,STUART",
                    SiteName = "CAMP MASTER",
                    SiteNumber = "500",
                    SSN = "123456789",
                    SecurityToken = "1XWBAS1620-423141_3"
                },

                // client
                AETitle = "MYAETitle"
            };

            StudyQuery = new StudyQuery();
            StudyQuery.PatientICN = "10121";
            StudyQuery.SiteNumber = "500";
            StudyQuery.Studies = null;

            DisplayContext = new DisplayContext
            {
                PatientICN = "10121",
                SiteNumber = "500",
                ContextId = "RPT^CPRS^419^RA^6838988.8477-1^70^CAMP MASTER^^^^^^0"
            };

        }

        private void Form1_Load(object sender, EventArgs e)
        {
            ServerSettingsPropertyGrid.SelectedObject = Settings;
            StudyQueryPropertyGrid.SelectedObject = StudyQuery;
        }

        private void DisplayStatusMessage(string message)
        {
            this.InvokeIfRequired((c) =>
            {
                DisplayContextStatusTextBox.AppendText(message + "\r\n");
            });
        }

        private void CacheDisplayContextButton_Click(object sender, EventArgs e)
        {
            if (QueryResultsListView.SelectedItems.Count == 0)
            {
                MessageBox.Show("Select one or more items from the Query Results list", "Cache Display Context", MessageBoxButtons.OK, MessageBoxIcon.Exclamation);
                return;
            }

            //DisplayContextStatusTextBox.Text = "";

            lock (_SyncObject)
            {
                // cancel current task
                if (CacheDisplayContextTask != null)
                {
                    CacheDisplayContextTaskCancelToken.Cancel();
                    CacheDisplayContextTask.Wait();
                    CacheDisplayContextTask = null;
                    CacheDisplayContextTaskCancelToken = null;
                }

                // create a list of selected display contexts
                var selectedItems = QueryResultsListView.SelectedItems.Cast<ListViewItem>().ToList();
                var displayContexts = (from c in selectedItems select c.Tag as DisplayContext).ToList();

                CacheDisplayContextTaskCancelToken = new CancellationTokenSource();
                CacheDisplayContextTask = Task.Factory.StartNew(() =>
                    {
                        try
                        {
                            DisplayStatusMessage("Caching display context...");

                            var serviceClient = new ServiceClient
                            {
                                BaseAddress = Settings.Url,
                                UserCredentials = Settings.UserCredentials
                            };

                            // cache selected display contexts
                            serviceClient.CacheDisplayContext(displayContexts, TimeSpan.FromMilliseconds(2000.0), CacheDisplayContextTaskCancelToken.Token, (displayContext, status) =>
                            {
                                this.InvokeIfRequired((c) =>
                                {
                                    var item = selectedItems.Where(x => (x.Tag == displayContext)).FirstOrDefault();
                                    if (item != null)
                                    {
                                        string text = (status.ImagesUploadFailed > 0) ?
                                            string.Format("{0} - Uploaded {1}({2}); ", status.StatusCode, status.ImagesUploaded, status.ImagesUploadFailed) :
                                            string.Format("{0} - Uploaded {1}; ", status.StatusCode, status.ImagesUploaded);

                                        text += (status.ImagesFailed > 0) ?
                                            string.Format("Processed {0}({1}); ", status.ImagesProcessed, status.ImagesFailed) :
                                            string.Format("Processed {0}; ", status.ImagesProcessed);

                                        item.SubItems[3].Text = text;
                                    }
                                });
                            });

                            DisplayStatusMessage("Caching display context...complete");
                        }
                        catch (Exception ex)
                        {
                            DisplayStatusMessage(ex.ToString());
                        }
                        finally
                        {
                            this.CacheDisplayContextTask = null;
                            this.InvokeIfRequired((c) =>
                                {
                                    CacheDisplayContextButton.Enabled = true;
                                    CancelCacheDisplayContextButton.Enabled = false;
                                });
                        }
                    });

                CacheDisplayContextButton.Enabled = false;
                CancelCacheDisplayContextButton.Enabled = true;
            }
        }

        private void CancelCacheDisplayContextButton_Click(object sender, EventArgs e)
        {
            lock (_SyncObject)
            {
                if (CacheDisplayContextTask != null)
                {
                    CacheDisplayContextTaskCancelToken.Cancel();
                    CacheDisplayContextTask.Wait();
                    CacheDisplayContextTask = null;
                    CacheDisplayContextTaskCancelToken = null;
                    CancelCacheDisplayContextButton.Enabled = false;
                    CacheDisplayContextButton.Enabled = true;
                    DisplayStatusMessage("Caching display context...cancelled");
                }
            }
        }

        private void CreateDicomDirButton_Click(object sender, EventArgs e)
        {
            // cancel current task
            if (CreateDicomDirTask != null)
            {
                CreateDicomDirTaskCancelToken.Cancel();
                CreateDicomDirTask.Wait();
                CreateDicomDirTask = null;
                CreateDicomDirTaskCancelToken = null;
            }

            if (QueryResultsListView.SelectedItems.Count == 0)
            {
                MessageBox.Show("Select one or more items from the Query Results list", "Create DicomDir", MessageBoxButtons.OK, MessageBoxIcon.Exclamation);
                return;
            }

            // select dicomdir file
            var dlg = new SaveFileDialog();
            dlg.DefaultExt = "zip";
            dlg.Filter = "Zip files (*.zip)|*.zip|All files (*.*)|*.*";
            if (dlg.ShowDialog() != System.Windows.Forms.DialogResult.OK)
                return;

            // create a list of selected display contexts
            var selectedItems = QueryResultsListView.SelectedItems.Cast<ListViewItem>().ToList();
            var displayContexts = (from c in selectedItems select c.Tag as DisplayContext).ToList();

            CacheDisplayContextTaskCancelToken = new CancellationTokenSource();
            CacheDisplayContextTask = Task.Factory.StartNew(() =>
            {
                try
                {
                    var serviceClient = new ServiceClient
                    {
                        BaseAddress = Settings.Url,
                        UserCredentials = Settings.UserCredentials
                    };

                    // first check if all display contexts are cached
                    bool isCached = true;
                    foreach (var displayContext in displayContexts)
                    {
                        var status = serviceClient.CacheDisplayContext(displayContext);
                        if (status.StatusCode != ContextStatusCode.Cached)
                            isCached = false;
                    }

                    // create dicomdir only if all display context are cached
                    if (isCached)
                    {
                        CreateDicomDirZip(displayContexts, Settings.AETitle, dlg.FileName, CacheDisplayContextTaskCancelToken.Token);
                    }
                    else
                    {
                        DisplayStatusMessage("Cannot create DicomDir. Selected display contexts are not cached.");
                    }
                }
                catch (Exception ex)
                {
                    DisplayStatusMessage(ex.ToString());
                }
                finally
                {
                    this.CacheDisplayContextTask = null;
                    this.InvokeIfRequired((c) =>
                    {
                        CreateDicomDirButton.Enabled = true;
                        CancelCreateDicomDirButton.Enabled = false;
                    });
                }
            });

            CreateDicomDirButton.Enabled = false;
            CancelCreateDicomDirButton.Enabled = true;
        }

        private void StudyQueryButton_Click(object sender, EventArgs e)
        {
            var serviceClient = new ServiceClient
            {
                BaseAddress = Settings.Url,
                UserCredentials = Settings.UserCredentials
            };

            try
            {
                QueryResultsListView.Items.Clear();
                DisplayStatusMessage("Performing study query...");

                // note: cancellation not supported for now
                var token = new CancellationTokenSource();
                var result = serviceClient.StudyQuery(StudyQuery);

                string text = string.Format("Performing study query...complete.\r\nStudies found: {0}",
                    (result.Studies != null)? result.Studies.Count() : 0);
                DisplayStatusMessage(text);

                if (result.Studies != null)
                {
                    foreach (var item in result.Studies)
                    {
                        var listViewItem = new ListViewItem(item.ContextId);
                        listViewItem.SubItems.Add(item.StudyDescription);
                        listViewItem.SubItems.Add(item.ImageCount.ToString());
                        listViewItem.SubItems.Add("");
                        listViewItem.Tag = new DisplayContext
                        {
                            ContextId = item.ContextId,
                            PatientICN = item.PatientICN,
                            SiteNumber = item.SiteNumber
                        };
                        QueryResultsListView.Items.Add(listViewItem);
                    }
                }
            }
            catch (Exception ex)
            {
                DisplayStatusMessage(ex.ToString());
            }
        }

        private void LoadStudyTestDataButton_Click(object sender, EventArgs e)
        {
            StudyQuery.PatientICN = "10121";
            StudyQuery.SiteNumber = "500";

            var studies = new List<DisplayContext>();
            studies.Add(new DisplayContext { ContextId = "RPT^CPRS^3^RA^6839581.8353-1^70^CAMP MASTER^^^^^^1" });
            studies.Add(new DisplayContext { ContextId = "RPT^CPRS^3^RA^6839581.8364-1^70^CAMP MASTER^^^^^^1" });
            studies.Add(new DisplayContext { ContextId = "RPT^CPRS^3^RA^6849870.8462-1^70^CAMP MASTER^^^^^^1" });
            studies.Add(new DisplayContext { ContextId = "RPT^CPRS^3^RA^6839581.8486-1^70^CAMP MASTER^^^^^^1" });
            studies.Add(new DisplayContext { ContextId = "RPT^CPRS^3^RA^6899798.8451-1^70^CAMP MASTER^^^^^^1" });
            studies.Add(new DisplayContext { ContextId = "RPT^CPRS^3^RA^6839581.8392-1^70^CAMP MASTER^^^^^^1" });
            studies.Add(new DisplayContext { ContextId = "RPT^CPRS^3^RA^6839398.7995-1^70^CAMP MASTER^^^^^^1" });
            studies.Add(new DisplayContext { ContextId = "RPT^CPRS^3^RA^6839581.8291-1^70^CAMP MASTER^^^^^^1" });
            studies.Add(new DisplayContext { ContextId = "RPT^CPRS^3^RA^6849796.8287-1^70^CAMP MASTER^^^^^^1" });
            studies.Add(new DisplayContext { ContextId = "RPT^CPRS^3^RA^6839398.7969-1^70^CAMP MASTER^^^^^^1" });
            studies.Add(new DisplayContext { ContextId = "RPT^CPRS^3^RA^6839398.7997-1^70^CAMP MASTER^^^^^^1" });

            StudyQuery.Studies = studies.ToArray();
        }

        private void LoadPatientTestDataButton_Click(object sender, EventArgs e)
        {
            StudyQuery.PatientICN = "10121";
            StudyQuery.SiteNumber = "500";
            StudyQuery.Studies = null;
        }

        private void CreateDicomDirZip(IEnumerable<DisplayContext> displayContexts, string AETitle, string fileName, CancellationToken token)
        {
            // Note: Instead of the code below, you could use ServiceClient::CreateDicomDirZip method which
            // does the same thing in a single call

            // Note: I have used CodeClock class to measure execution time. Its usage is optional

            CodeClock.LogDelegate = (s) => DisplayStatusMessage(s);

            try
            {
                using (new CodeClock("Creating DicomDir..."))
                {
                    var serviceClient = new ServiceClient
                    {
                        BaseAddress = Settings.Url,
                        UserCredentials = Settings.UserCredentials
                    };

                    // get dicomdir manifest
                    DicomDirManifest dicomDirManifest = null;

                    using (new CodeClock("Getting manifest..."))
                    {
                        dicomDirManifest = serviceClient.GetDicomDirManifest(displayContexts, AETitle);
                    }

                    if (token != null)
                        token.ThrowIfCancellationRequested();

                    using (var zipOutputStream = new ZipOutputStream(fileName))
                    {
                        // save raw manifest as DicomDir
                        if (!string.IsNullOrEmpty(dicomDirManifest.Base64Manifest))
                        {
                            using (new CodeClock("Writing manifest..."))
                            {
                                byte[] rawManifest = Convert.FromBase64String(dicomDirManifest.Base64Manifest);
                                zipOutputStream.PutNextEntry("DICOMDIR");
                                zipOutputStream.Write(rawManifest, 0, rawManifest.Length);
                            }
                        }

                        if (dicomDirManifest.FileList != null)
                        {
                            foreach (var file in dicomDirManifest.FileList)
                            {
                                // Note: FileName is imageUrn
                                using (var inputStream = new MemoryStream())
                                {
                                    if (token != null)
                                        token.ThrowIfCancellationRequested();

                                    using (new CodeClock("Getting image {0}...", file.DestinationFilePath))
                                    {
                                        serviceClient.GetImage(file.FileName, inputStream);
                                    }

                                    using (new CodeClock("Writing image {0}...", file.DestinationFilePath))
                                    {
                                        zipOutputStream.PutNextEntry(file.DestinationFilePath);
                                        inputStream.CopyTo(zipOutputStream);
                                    }
                                }
                            }
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                if (File.Exists(fileName))
                    File.Delete(fileName);

                DisplayStatusMessage(ex.ToString());
            }
        }

        private void CancelCreateDicomDirButton_Click(object sender, EventArgs e)
        {
            lock (_SyncObject)
            {
                if (CreateDicomDirTask != null)
                {
                    CreateDicomDirTaskCancelToken.Cancel();
                    CreateDicomDirTask.Wait();
                    CreateDicomDirTask = null;
                    CreateDicomDirTaskCancelToken = null;
                    CancelCreateDicomDirButton.Enabled = false;
                    CreateDicomDirButton.Enabled = true;
                    DisplayStatusMessage("Create DicomDir...cancelled");
                }
            }
        }
    }
}
