namespace Hydra.IX.Database
{
    using Hydra.IX.Database.Common;
    using System;
    using System.ComponentModel.DataAnnotations.Schema;
    using System.Data.Entity;
    using System.Data.Entity.Infrastructure.Annotations;
    using System.Linq;
    using System.Reflection;
    using System.Data.SQLite;
    using System.Threading;

    [DbConfigurationType(typeof(HixDbConfiguration))]
    internal class HixDbContext : DbContext, IHixDbContext
    {
        internal HixDbContext(string connectionString, int commandTimeout)
        : base(new SQLiteConnection(connectionString), true)
        {
            if (commandTimeout > 0)
            {
                this.Database.CommandTimeout = commandTimeout;
            }
        }
        public static void SetInitializeNoCreate()
        {
            //Setting the Database initializer to null prevents entity framework code-first behaviors from occurring
            System.Data.Entity.Database.SetInitializer<HixDbContext>(null);
        }
        public virtual DbSet<ImageFile> Images { get; set; }
        public virtual DbSet<ImageGroup> ImageGroups { get; set; }
        public virtual DbSet<ImagePart> ImageParts { get; set; }
        public virtual DbSet<ImageBackupRecord> ImageBackupRecords { get; set; }
        public virtual DbSet<StudyParentRecord> StudyParentRecords { get; set; }
        public virtual DbSet<StudyRecord> StudyRecords { get; set; }
        public virtual DbSet<SeriesRecord> SeriesRecords { get; set; }
        public virtual DbSet<Tag> Tags { get; set; }
        public virtual DbSet<TagMap> TagMap { get; set; }
        public virtual DbSet<DisplayContext> DisplayContexts { get; set; }
        public virtual DbSet<EventLogRecord> EventLogRecords { get; set; }
        public virtual DbSet<UserRecord> UserRecords { get; set; }
        public virtual DbSet<SettingRecord> SettingRecords { get; set; }
        public virtual DbSet<SettingsMap> SettingsMap { get; set; }
        public virtual DbSet<RuleRecord> RuleRecords { get; set; }
        public virtual DbSet<DictionaryRecord> DictionaryRecords { get; set; }
        //public virtual DbSet<VolumeFrame> VolumeFrames { get; set; }

        public void Reset()
        {
            ImageParts.RemoveRange(ImageParts);
            Images.RemoveRange(Images);
            ImageGroups.RemoveRange(ImageGroups);
            DisplayContexts.RemoveRange(DisplayContexts);

            SaveChanges();
        }

        public HixDbSpaceUsed GetSpaceUsed()
        {
            var spaceUsed = new HixDbSpaceUsed();

            try
            {
                int pageSize = 0;
                int pageCount = 0;
                SQLiteConnection sqlConn = (SQLiteConnection)Database.Connection;
                sqlConn.Open();

                using (SQLiteCommand cmd = new SQLiteCommand("PRAGMA page_size", sqlConn)) 
                {
                    var reader = cmd.ExecuteReader();
                    while (reader.Read())
                    {
                        pageSize = reader.GetInt32(0);
                    }

                }
                using (SQLiteCommand cmd2 = new SQLiteCommand("PRAGMA page_count", sqlConn))
                {
                    var reader = cmd2.ExecuteReader();
                    while (reader.Read())
                    {
                        pageCount = reader.GetInt32(0);
                    }
                }

                double dbSize = (pageCount * pageSize) / 1000;
                spaceUsed.DatabaseSize = dbSize.ToString() + "KB";
                sqlConn.Close(); //This probably is not necessary as the context will clean this up on disposal
            }
            catch (Exception)
            {
            }

            return spaceUsed;
        }
    }
}