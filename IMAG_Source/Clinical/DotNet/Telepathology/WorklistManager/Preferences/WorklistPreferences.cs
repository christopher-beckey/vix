/**
 * 
 * Package: MAG - VistA Imaging
 * WARNING: Per VHA Directive 2004-038, this routine should not be modified.
 * Date Created: 4/25/2012
 * Site Name:  Washington OI Field Office, Silver Spring, MD
 * Developer:  Paul Pentapaty
 * Description: 
 * 
 *       ;; +--------------------------------------------------------------------+
 *       ;; Property of the US Government.
 *       ;; No permission to copy or redistribute this software is given.
 *       ;; Use of unreleased versions of this software requires the user
 *       ;;  to execute a written test agreement with the VistA Imaging
 *       ;;  Development Office of the Department of Veterans Affairs,
 *       ;;  telephone (301) 734-0100.
 *       ;;
 *       ;; The Food and Drug Administration classifies this software as
 *       ;; a Class II medical device.  As such, it may not be changed
 *       ;; in any way.  Modifications to this software may result in an
 *       ;; adulterated medical device under 21CFR820, the use of which
 *       ;; is considered to be a violation of US Federal Statutes.
 *       ;; +--------------------------------------------------------------------+
 *       
 * 
 */

 
namespace VistA.Imaging.Telepathology.Worklist.Preferences
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using System.Text;
    using System.Collections.ObjectModel;
    using VistA.Imaging.Telepathology.Common.Model;
    using VistA.Imaging.Telepathology.Worklist.Messages;
    using System.Xml;

    public class WorklistPreferences
    {
        ObservableCollection<WorkListFilter> _worklistFilters = new ObservableCollection<WorkListFilter>();
        public ObservableCollection<WorkListFilter> WorklistFilters { get { return _worklistFilters; } }

        public void AddUpdateWorklistFilter(WorkListFilter filter)
        {
            if (!WorklistFilters.Contains(filter))
            {
                // add to collection
                WorklistFilters.Add(filter);
            }

            // broadcast change
            AppMessages.WorklistFilterListChangedMessage.Send(filter);

            //Save();
        }

        public void DeleteWorklistFilter(WorkListFilter filter)
        {
            if (WorklistFilters.Contains(filter))
            {
                // remove from collection
                WorklistFilters.Remove(filter);

                // broadcast change
                AppMessages.WorklistFilterListChangedMessage.Send(filter);

                //Save();
            }
        }

        public System.Xml.Schema.XmlSchema GetSchema()
        {
            return null;
        }

        public void ReadXml(System.Xml.XmlReader reader)
        {
            reader.Read();
            if ((reader.MoveToContent() == XmlNodeType.Element) && (reader.LocalName == "WorklistFilters"))
            {
                reader.Read();
                while ((reader.MoveToContent() == XmlNodeType.Element) && (reader.LocalName == "WorkListFilter"))
                {
                    WorkListFilter item = new WorkListFilter();
                    item.ReadXml(reader);

                    // set as stored
                    item.Kind = WorkListFilter.WorkListFilterKind.Stored;

                    WorklistFilters.Add(item);

                    reader.Read();
                }
            }
        }

        public void WriteXml(System.Xml.XmlWriter writer)
        {
            writer.WriteStartElement("WorklistFilters");
            foreach (WorkListFilter item in WorklistFilters)
            {
                // do not save adhoc filer
                if (item.Kind != WorkListFilter.WorkListFilterKind.AdHoc)
                {
                    writer.WriteStartElement("WorklistFilter");
                    item.WriteXml(writer);
                    writer.WriteEndElement();
                }
            }
            writer.WriteEndElement();
        }

    }
}
