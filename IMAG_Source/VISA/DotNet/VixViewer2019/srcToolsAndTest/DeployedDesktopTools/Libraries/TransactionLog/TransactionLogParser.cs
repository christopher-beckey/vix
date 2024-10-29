using DesktopCommon;
using System;
using System.Collections.Generic;
using System.IO;

namespace TransactionLog
{
    public class TransactionLogParser
    {
        public static List<TransactionLogEntry> ParseLogs(string siteNumber, DateTime startDate, DateTime endDate)
        {
            List<TransactionLogEntry> entries = new List<TransactionLogEntry>();
            DateTime curDate = startDate;
            while (!Utils.IsDateAfter(curDate, endDate))
            {
                string filename = Utils.GetLogFilename(siteNumber, curDate);
                entries.AddRange(ParseFile(filename, siteNumber));
                curDate = curDate.AddDays(1);
            }
            return entries;
        }

        public static List<TransactionLogEntry> ParseLogStream(Stream stream, string siteNumber)
        {
            List<TransactionLogEntry> entries = new List<TransactionLogEntry>();
            StreamReader reader = new StreamReader(stream);
            try
            {
                string headerLine = reader.ReadLine();
                string line = reader.ReadLine();
                while (line != null)
                {
                    TransactionLogEntry entry = TransactionLogEntry.parseTSVLine(siteNumber, headerLine, line);
                    if (entry != null)
                        entries.Add(entry);
                    line = reader.ReadLine();
                }
            }
            finally
            {
                reader.Close();
            }

            return entries;
        }

        private static List<TransactionLogEntry> ParseFile(string filename, string siteNumber)
        {
            List<TransactionLogEntry> entries = new List<TransactionLogEntry>();

            FileStream fStream = new FileStream(filename, FileMode.Open);
            try
            {
                entries = ParseLogStream(fStream, siteNumber);
            }
            catch (Exception)
            {
                // catch and do nothing
            }
            return entries;
        }
    }
}
