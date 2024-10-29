using Hydra.Log;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Hydra.VistA.Commands
{
    public class StudyQueryCommand
    {
        private static readonly ILogger _Logger = LogManager.GetCurrentClassLogger();
        private static readonly ILogger _AccessLogger = LogManager.GetAccessLogger();

        public static void Execute(StudyQuery studyQuery)
        {
            try
            {
                string studyQueryText = null;

                if (_Logger.IsDebugEnabled)
                {
                    studyQueryText = studyQuery.ToJsonLog();
                    _Logger.Debug("Performing study query.", "StudyQuery", studyQueryText);
                }

                VixServiceUtil.Authenticate(studyQuery);

                if (!string.IsNullOrEmpty(studyQuery.AccessContext))
                {
                    if (string.IsNullOrEmpty(studyQueryText))
                        studyQueryText = studyQuery.ToJsonLog();

                    _AccessLogger.Info("Study query request", "UserId", studyQuery.AccessContext, "StudyQuery", studyQueryText);
                }

                bool enableBulkStudyQuery = PolicyUtil.IsPolicyEnabled("StudyQuery.EnableBulkStudyQuery", true);
                bool maximizeRequestThreads = PolicyUtil.IsPolicyEnabled("StudyQuery.MaximizeRequestThreads", true);
                var codeClock = Hydra.Common.CodeClock.Start(); 

                if (studyQuery.Studies != null)
                {
                    // update all study items
                    foreach (var studyItem in studyQuery.Studies)
                    {
                        studyItem.SiteNumber = string.IsNullOrEmpty(studyItem.SiteNumber) ? studyQuery.SiteNumber : studyItem.SiteNumber;
                        studyItem.PatientICN = string.IsNullOrEmpty(studyItem.PatientICN) ? studyQuery.PatientICN : studyItem.PatientICN;
                        studyItem.PatientDFN = string.IsNullOrEmpty(studyItem.PatientDFN) ? studyQuery.PatientDFN : studyItem.PatientDFN;
                    }

                    if (!enableBulkStudyQuery || (VixServiceUtil.LocalVix.Flavor == VixFlavor.Isix))
                    {
                        int requestThreadCount = (int)Math.Min(VistAConfigurationSection.Instance.QueryThreadPoolSize, studyQuery.Studies.Length);

                        // update status for the selected studies
                        Hydra.IX.Common.BackgroundWorker<StudyItem>.Execute((studyItem, workerId, workerIndex, token) => 
                                                                                {
                                                                                    if (_Logger.IsDebugEnabled)
                                                                                        _Logger.Debug(@"Getting image status", "ThreadIndex", workerIndex, "ThreadCount", requestThreadCount, "workerId", workerId, "ContextId", studyItem.ContextId);

                                                                                    VixServiceUtil.GetStudyImageStatus(studyItem, studyQuery.VixJavaSecurityToken);
                                                                                },
                                                                            studyQuery.Studies,
                                                                            requestThreadCount,
                                                                            maximizeRequestThreads);
                    }
                    else // perform multi-context id query
                    {
                        // create nest group - patient->sitenumber->contextid
                        var studyItemGroups = studyQuery.Studies.GroupBy(x => new { x.PatientICN, x.PatientDFN, x.SiteNumber })
                                                             .Select(x => new StudyItemGroup { SiteNumber = x.Key.SiteNumber, Studies = x.ToList() })
                                                             .ToList();

                        // check which sites support bulk query
                        VixServiceUtil.CheckServerStatus(studyItemGroups);

                        Hydra.IX.Common.BackgroundWorker<StudyItemGroup>.Execute((studyItemGroup, workerId, workerIndex, token) => VixServiceUtil.GetPatientStudiesImageStatus(studyItemGroup, studyQuery.VixJavaSecurityToken),
                                                                                 studyItemGroups,
                                                                                 (int)Math.Min(VistAConfigurationSection.Instance.QueryThreadPoolSize, studyItemGroups.Count()));
                    }
                }
                else
                {
                    PatientStudyQueryJob[] jobArray = null;

                    if (!string.IsNullOrEmpty(studyQuery.SiteNumber))
                        studyQuery.SiteNumbers = new string[1] { studyQuery.SiteNumber };
                    else
                    {
                        if ((studyQuery.SiteNumbers == null) || (studyQuery.SiteNumbers.Length == 0))
                        {
                            // use treating facilities list to get site numbers
                            var treatingFacilities = VixServiceUtil.GetTreatingFacilities(studyQuery);
                            if (treatingFacilities != null)
                            {
                                studyQuery.SiteNumbers = treatingFacilities.Select(x => x.SiteNumber).ToArray();
                            }
                        }
                    }

                    if ((studyQuery.SiteNumbers != null) && (studyQuery.SiteNumbers.Length > 0))
                    {
                        jobArray = new PatientStudyQueryJob[studyQuery.SiteNumbers.Length];
                        int index = 0;
                        foreach (var siteNumber in studyQuery.SiteNumbers)
                        {
                            jobArray[index++] = new PatientStudyQueryJob
                            {
                                StudyQuery = studyQuery,
                                SiteNumber = siteNumber
                            };
                        }
                    }

                    if (jobArray == null)
                        throw new ArgumentException("No valid site number found");

                    // get studies for patient from each site
                    Hydra.IX.Common.BackgroundWorker<PatientStudyQueryJob>.Execute((job, workerId, workerIndex, token) => 
                                                                                        { 
                                                                                            job.Studies = 
                                                                                                VixServiceUtil.GetPatientStudies(job.StudyQuery.PatientICN,
                                                                                                                                 job.StudyQuery.PatientDFN,
                                                                                                                                 job.SiteNumber,
                                                                                                                                 job.StudyQuery.VixJavaSecurityToken,
                                                                                                                                 job.StudyQuery.ImageFilter); 
                                                                                        },
                                                                                   jobArray,
                                                                                   (int)Math.Min(10, jobArray.Length));

                    // combine all studies
                    foreach (var job in jobArray)
                    {
                        if (job.Studies == null)
                            continue;

                        if (studyQuery.Studies == null)
                            studyQuery.Studies = job.Studies;
                        else
                            studyQuery.Studies = studyQuery.Studies.Concat(job.Studies).ToArray();
                    }
                }

                // prepare response
                if (studyQuery.Studies != null)
                {
                    // update urls
                    var urlFormatter = VixServiceUtil.CreateUrlFormatter(studyQuery);
                    Array.ForEach(studyQuery.Studies, studyItem =>
                    {
                        urlFormatter.FormatUrl(studyItem);
                        studyItem.SecurityToken = studyQuery.SecurityToken;
                    });
                }

                if (_Logger.IsDebugEnabled)
                {
                    var logEvent = _Logger.WithDebug("Studies found.", "Count", (studyQuery.Studies != null) ? studyQuery.Studies.Count() : 0, "Time", codeClock.ElapsedMilliseconds);
                    if (_Logger.IsTraceEnabled)
                        logEvent.AddFields("Studies", (studyQuery.Studies != null) ? JsonConvert.SerializeObject(studyQuery.Studies, Formatting.None) : null);
                    logEvent.Log();
                }
            }
            catch (Exception ex)
            {
                _Logger.Error("Error performing study query.", "Exception", ex.ToString());
                throw;
            }
        }
    }
}
