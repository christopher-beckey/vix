using Hydra.IX.Common;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data.SQLite;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Hydra.IX.Configuration
{
    public class DatabaseElement : ConfigurationElement
    {
        private string FormatConnectionString(bool includeDatabaseName = true)
        {
            SQLiteConnectionStringBuilder sqlBuilder = new SQLiteConnectionStringBuilder();
            sqlBuilder.DataSource = DataSource;
            sqlBuilder.JournalMode = SQLiteJournalModeEnum.Wal;
            sqlBuilder.FailIfMissing = true;
            sqlBuilder.SyncMode = SynchronizationModes.Normal;

            //var secureElement = SecureElements["Password"];
            //if (secureElement != null)
            //    sqlBuilder.Password = secureElement.Value;

            return sqlBuilder.ToString();
        }

        public string DbConnectionString
        {
            get
            {
                return FormatConnectionString(true);
            }
        }

        public string Password
        {
            get
            {
                var secureElement = SecureElements["Password"];
                return (secureElement != null) ? secureElement.Value : null;
            }
        }

        [ConfigurationProperty("DataSource", IsRequired = true)]
        public string DataSource
        {
            get { return (string)base["DataSource"]; }
        }

        [ConfigurationProperty("CommandTimeout", IsRequired = false, DefaultValue = 0)]
        public int CommandTimeout
        {
            get { return (int)base["CommandTimeout"]; }
        }
     
        [ConfigurationProperty("SecureElements")]
        public SecureElementCollection SecureElements
        {
            get
            {
                return ((SecureElementCollection)(base["SecureElements"]));
            }

            set
            {
                base["SecureElements"] = value;
            }
        }
    }
}
