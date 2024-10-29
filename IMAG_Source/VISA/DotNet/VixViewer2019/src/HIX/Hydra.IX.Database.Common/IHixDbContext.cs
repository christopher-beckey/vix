using System;
using System.Collections.Generic;
using System.Data.Entity;
using System.Data.Entity.Infrastructure;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Hydra.IX.Database.Common
{
    public interface IHixDbContext : IDisposable
    {
        DbSet<ImageFile> Images { get; set; }
        DbSet<ImageGroup> ImageGroups { get; set; }
        DbSet<ImagePart> ImageParts { get; set; }
        DbSet<ImageBackupRecord> ImageBackupRecords { get; set; }
        DbSet<StudyParentRecord> StudyParentRecords { get; set; }
        DbSet<StudyRecord> StudyRecords { get; set; }
        DbSet<SeriesRecord> SeriesRecords { get; set; }
        DbSet<Tag> Tags { get; set; }
        DbSet<TagMap> TagMap { get; set; }
        DbSet<DisplayContext> DisplayContexts { get; set; }
        DbSet<EventLogRecord> EventLogRecords { get; set; }

        // Settings
        DbSet<UserRecord> UserRecords { get; set; }
        DbSet<SettingRecord> SettingRecords { get; set; }
        DbSet<SettingsMap> SettingsMap { get; set; }

        // Rules
        DbSet<RuleRecord> RuleRecords { get; set; }

        // dictionary
        DbSet<DictionaryRecord> DictionaryRecords { get; set; }

        // 3D
        //DbSet<VolumeFrame> VolumeFrames { get; set; }

        DbEntityEntry Entry(object entity);
        System.Data.Entity.Database Database { get; }
        int SaveChanges();
        void Reset();
        HixDbSpaceUsed GetSpaceUsed();
    }
}
