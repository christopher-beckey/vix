using Hydra.Entities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Hydra.Dicom
{
    public interface IStudyBuilder
    {
        bool CreateSeries(string seriesInstanceUid);
        bool CreateStudy(string studyInstanceUid);
        bool CreatePatient(string patientId);
        void SetBadSeriesId(string SeriesInstanceUID);
        void UpdateSeries(Series series);
        void UpdateStudy(Study study);
        void UpdatePatient(Patient patient);        
        string StudyId { get; }
    }
}
