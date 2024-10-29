using Hydra.Dicom;
using Hydra.IX.Database;
using Hydra.IX.Database.Common;
using Hydra.Log;
using Nancy.Json;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading;
using System.Threading.Tasks;

namespace Hydra.IX.Core
{
    class StudyBuilder : IStudyBuilder
    {
        private static readonly ILogger _Logger = LogManager.GetCurrentClassLogger();

        private string ImageGroupUid;

        private static object _StudyParentRecordsLock = new object();

        private static object _StudyRecordsLock = new object();

        private static object _SeriesRecordsLock = new object();

        private IHixDbContextFactory _HixDbContextFactory = new HixDbContextFactory();

        private bool _UseProcessLock = false;

        //this is a temporary placeholder we set in the database to flag the need for later cleanup 
        public const string BadSeriesId = "0.0.0.0.0.0.0.0.0.0";

        //private int _PatientLockCount = 0;
        //private int _StudyLockCount = 0;
        //private int _SeriesLockCount = 0;

        public StudyBuilder(ImageGroup imageGroup, string studyId, bool useProcessLock)
        {
            ImageGroupUid = imageGroup.GroupUid;
            StudyId = studyId;
            _UseProcessLock = useProcessLock;
        }

        public bool CreatePatient(string patientId)
        {
            if (_UseProcessLock)
            {
                using (new ProcessLock("HixWorker_CreatePatient"))
                {
                    //Interlocked.Increment(ref _PatientLockCount);
                    //_Logger.Debug("In CreatePatient", "LockCount", _PatientLockCount);

                    bool exists = InternalCreatePatient(patientId);

                    //Interlocked.Decrement(ref _PatientLockCount);
                    //_Logger.Debug("Out CreatePatient {0}", "LockCount", _PatientLockCount);

                    return exists;
                }
            }
            else
            {
                lock (_StudyParentRecordsLock)
                {
                    return InternalCreatePatient(patientId);
                }
            }
        }

        private bool InternalCreatePatient(string patientId)
        {
            using (var ctx = _HixDbContextFactory.Create())
            {
                if (ctx.StudyParentRecords.Where(x => ((x.GroupUid == ImageGroupUid) && (x.StudyParentId == patientId))).Any())
                    return false; // patient already exists

                // create patient
                var studyParentRecord = new StudyParentRecord
                {
                    GroupUid = ImageGroupUid,
                    StudyParentId = patientId
                };

                try
                {
                    ctx.StudyParentRecords.Add(studyParentRecord);
                    ctx.SaveChanges();

                    return true;
                }
                catch (Exception)
                {
                    // assume patient already exists
                    return false;
                }
            }
        }

        public bool CreateSeries(string seriesInstanceUid)
        {
            if (HixService.Instance.ServiceMode == HixServiceMode.Worker)
            {
                using (new ProcessLock("HixWorker_CreateSeries"))
                {
                    //_Logger.Debug("In CreateSeries", "LockCount", Interlocked.Increment(ref _SeriesLockCount));

                    bool exists = InternalCreateSeries(seriesInstanceUid);

                    //_Logger.Debug("Out CreateSeries", "LockCount", Interlocked.Decrement(ref _SeriesLockCount));

                    return exists;
                }
            }
            else
            {
                lock (_SeriesRecordsLock)
                {
                    return InternalCreateSeries(seriesInstanceUid);
                }
            }
        }

        private bool InternalCreateSeries(string seriesInstanceUid)
        {
            using (var ctx = _HixDbContextFactory.Create())
            {
                if (ctx.SeriesRecords.Where(x => ((x.GroupUid == ImageGroupUid) && (x.SeriesInstanceUid == seriesInstanceUid))).Any())
                    return false; // study already exists

                // create series
                var seriesRecord = new SeriesRecord
                {
                    GroupUid = ImageGroupUid,
                    SeriesInstanceUid = seriesInstanceUid,
                    SeriesNumber = -1
                };

                try
                {
                    ctx.SeriesRecords.Add(seriesRecord);
                    ctx.SaveChanges();

                    return true;
                }
                catch (Exception)
                {
                    // assume series already exists
                    return false;
                }
            }
        }

        public bool CreateStudy(string studyInstanceUid)
        {
            if (HixService.Instance.ServiceMode == HixServiceMode.Worker)
            {
                using (new ProcessLock("HixWorker_CreateStudy"))
                {
                    //_Logger.Debug("In CreateStudy", "LockCount", Interlocked.Increment(ref _StudyLockCount));

                    bool exists = InternalCreateStudy(studyInstanceUid);

                    //_Logger.Debug("Out CreateStudy", "LockCount", Interlocked.Decrement(ref _StudyLockCount));

                    return exists;
                }
            }
            else
            {
                lock (_StudyRecordsLock)
                {
                    return InternalCreateStudy(studyInstanceUid);
                }
            }
        }

        private bool InternalCreateStudy(string studyInstanceUid)
        {
            using (var ctx = _HixDbContextFactory.Create())
            {
                if (ctx.StudyRecords.Where(x => ((x.GroupUid == ImageGroupUid) && (x.StudyInstanceUid == studyInstanceUid))).Any())
                    return false; // study already exists

                // create study
                var studyRecord = new StudyRecord
                {
                    GroupUid = ImageGroupUid,
                    StudyInstanceUid = studyInstanceUid
                };

                try
                {
                    ctx.StudyRecords.Add(studyRecord);
                    ctx.SaveChanges();

                    return true;
                }
                catch (Exception)
                {
                    // assume study already exists
                    return false;
                }
            }
        }

        public void UpdateSeries(Entities.Series series)
        {
            try
            {
                using (var ctx = _HixDbContextFactory.Create())
                {
                    var seriesRecord = ctx.SeriesRecords.Where(x => (x.GroupUid == ImageGroupUid) && (x.SeriesInstanceUid == series.SeriesInstanceUID)).FirstOrDefault();
                    if (seriesRecord != null)
                    {
                        var serializer = new JavaScriptSerializer { MaxJsonLength = Int32.MaxValue };
                        seriesRecord.SeriesXml = serializer.Serialize(series);
                        seriesRecord.SeriesNumber = series.SeriesNumber;
                        seriesRecord.DicomDirXml = series.DicomDirXml;
                        seriesRecord.StudyInstanceUid = series.StudyInstanceUID;

                        ctx.Entry(seriesRecord).State = System.Data.Entity.EntityState.Modified;
                        ctx.SaveChanges();
                    }
                }
            }
            catch (Exception ex)
            {
                _Logger.Error("Error adding series to database.", "Exception", ex.Message);
            }
        }

        public void UpdateStudy(Entities.Study study)
        {
            try
            {
                using (var ctx = _HixDbContextFactory.Create())
                {
                    var studyRecord = ctx.StudyRecords.Where(x => (x.GroupUid == ImageGroupUid) && (x.StudyInstanceUid == study.StudyUid)).FirstOrDefault();
                    if (studyRecord != null)
                    {
                        studyRecord.DicomStudyId = study.DicomStudyId;
                        studyRecord.StudyXml = HipaaUtil.Encrypt(study);
                        studyRecord.DicomDirXml = study.DicomDirXml;
                        studyRecord.PatientId = study.Patient.ICN;

                        ctx.Entry(studyRecord).State = System.Data.Entity.EntityState.Modified;
                        ctx.SaveChanges();
                    }
                }
            }
            catch (Exception ex)
            {
                _Logger.Error("Error adding series to database.", "Exception", ex.Message);
            }
        }

        //this sets the SeriesInstanceUid to the temporary placeholder in the database to flag the need for later cleanup 
        public void SetBadSeriesId (string SeriesInstanceUID)
        {
            try
            {
                using (var ctx = _HixDbContextFactory.Create())
                {
                    var seriesRecord = ctx.SeriesRecords.Where(x => (x.GroupUid == ImageGroupUid) && (x.SeriesInstanceUid == SeriesInstanceUID)).FirstOrDefault();
                    if (seriesRecord != null)
                    {
                        seriesRecord.SeriesInstanceUid = BadSeriesId;

                        ctx.Entry(seriesRecord).State = System.Data.Entity.EntityState.Modified;
                        ctx.SaveChanges();
                    }
                }
            }
            catch (Exception ex)
            {
                _Logger.Info("Error setting bad series ID to database.", "Exception", ex.Message);
            }
        }

        public void UpdatePatient(Entities.Patient patient)
        {
            try
            {
                using (var ctx = _HixDbContextFactory.Create())
                {
                    var patientRecord = ctx.StudyParentRecords.Where(x => (x.GroupUid == ImageGroupUid) && (x.StudyParentId == patient.ICN)).FirstOrDefault();
                    if (patientRecord != null)
                    {
                        var serializer = new JavaScriptSerializer { MaxJsonLength = Int32.MaxValue };
                        patientRecord.StudyParentXml = HipaaUtil.Encrypt(patient);
                        patientRecord.DicomDirXml = HipaaUtil.EncryptText(patient.DicomDirXml);

                        ctx.Entry(patientRecord).State = System.Data.Entity.EntityState.Modified;
                        ctx.SaveChanges();
                    }
                }
            }
            catch (Exception ex)
            {
                _Logger.Error("Error adding patient to database.", "Exception", ex.ToString());
            }
        }

        public string StudyId { get; private set; }
    }
}
