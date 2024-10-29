using Excel;
using Hydra.Common.Entities;
using Hydra.Log;
using Hydra.VistA;
using System;
using System.Collections.Generic;
using System.Data;
using System.IO;
using System.Linq;
using System.Reflection;
using System.Text;
using System.Threading.Tasks;

namespace Hydra.Web
{
    class ReleaseHistory
    {
        private static readonly ILogger _Logger = LogManager.GetCurrentClassLogger();

        public static List<ReleaseHistoryItem> Build(string rootFolder)
        {
            var list = new List<ReleaseHistoryItem>();

            try
            {
                using (var stream = new FileStream(Path.Combine(rootFolder, "ReleaseHistory.xlsx"), FileMode.Open))
                {
                    IExcelDataReader reader = ExcelReaderFactory.CreateOpenXmlReader(stream);
                    reader.IsFirstRowAsColumnNames = true;
                    var ds = reader.AsDataSet();
                    ReleaseHistoryItem parentReleaseItem = null;
                    bool updateBuildVersion = true;

                    foreach (DataRow row in ds.Tables[0].Rows)
                    {
                        if (row.ItemArray.Length > 2)
                        {
                            ReleaseHistoryType type;
                            if (!Enum.TryParse<ReleaseHistoryType>(row.ItemArray[2].ToString(), out type))
                                continue;
                            
                            var releaseItem = new ReleaseHistoryItem
                            {
                                Type = type,
                            };

                            if (row.ItemArray.Length > 3)
                            {
                                releaseItem.Text = row.ItemArray[3].ToString();
                            }

                            if (!string.IsNullOrEmpty(row.ItemArray[1].ToString()))
                            {
                                DateTime timeStamp;
                                if (DateTime.TryParse(row.ItemArray[1].ToString(), out timeStamp))
                                {
                                    releaseItem.TimeStamp = timeStamp;
                                }
                            }

                            releaseItem.Name = row.ItemArray[0].ToString();
                            if (updateBuildVersion && (releaseItem.Name.Equals("Current", StringComparison.CurrentCultureIgnoreCase)))
                            {
                                //Updated for VAI-300 Version History
                                releaseItem.Name = Hydra.VistA.VixServiceUtil.GetVixVersion();
                                releaseItem.TimeStamp = File.GetLastWriteTime(Assembly.GetExecutingAssembly().Location); //gets the modified date/time from Hydra.Web.dll;

                                updateBuildVersion = false;
                            }
                            
                            if (type == ReleaseHistoryType.Release)
                            {
                                parentReleaseItem = releaseItem;
                                list.Add(parentReleaseItem);
                            }
                            else if (parentReleaseItem != null)
                            {
                                if (parentReleaseItem.Items == null)
                                    parentReleaseItem.Items = new List<ReleaseHistoryItem>();

                                parentReleaseItem.Items.Add(releaseItem);
                            }
                        }
                    }
                }                
            }
            catch (Exception ex)
            {
                _Logger.Error("Error building release history.", "Exception", ex.ToString());
            }

            return list;
        }
    }
}
