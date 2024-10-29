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
    using System.Windows.Controls;
    using VistA.Imaging.Telepathology.Common.Model;
    using System.Windows;
    using VistA.Imaging.Telepathology.Logging;

    public class LayoutPreferences
    {
        private static MagLogger Log = new MagLogger(typeof(LayoutPreferences));

        public List<WorklistColumnPreferences> WorklistColumnPreferencesList  { get; set; }

        public List<WindowSettings> WindowSettings{ get; set; }

        public bool SaveOnExit { get; set; }

        public LayoutPreferences()
        {
            this.WorklistColumnPreferencesList = new List<WorklistColumnPreferences>();
            this.WindowSettings = new List<WindowSettings>();

            this.SaveOnExit = true;
        }

        public void Restore(Window window, string label)
        {
            WindowSettings settings = this.WindowSettings.Where(x => (x.Label == label)).FirstOrDefault();
            if (settings != null)
            {
                settings.Restore(window);
            }
        }

        public void Save(Window window, string label)
        {
            WindowSettings settings = this.WindowSettings.Where(x => (x.Label == label)).FirstOrDefault();
            if (settings == null)
            {
                settings = new WindowSettings { Label = label };
                this.WindowSettings.Add(settings);
            }
                
            settings.Save(window);
        }

        public void SaveWorklistColumnPreferences(string name, GridView gridView)
        {
            WorklistColumnPreferences wlColumnPreferences = this.WorklistColumnPreferencesList.Where(x => (x.Name == name)).FirstOrDefault();
            if (wlColumnPreferences == null)
            {
                wlColumnPreferences = new WorklistColumnPreferences { Name = name };
                this.WorklistColumnPreferencesList.Add(wlColumnPreferences);
            }

            wlColumnPreferences.Columns.Clear();
            foreach (GridViewColumn col in gridView.Columns)
            {
                GridViewColumnHeader header = col.Header as GridViewColumnHeader;

                CaseListColumnType colType;
                if (Enum.TryParse<CaseListColumnType>(header.Tag as string, out colType))
                {
                    CaseListColumn wlCol = new CaseListColumn
                    {
                        Type = colType,
                        DesiredWidth = (int) col.ActualWidth
                    };

                    wlColumnPreferences.Columns.Add(wlCol);
                }
            }
        }

        public void ApplyWorklistColumnPreferences(string name, GridView gridView)
        {
            WorklistColumnPreferences wlColumnPreferences = this.WorklistColumnPreferencesList.Where(x => (x.Name == name)).FirstOrDefault();
            if (wlColumnPreferences != null)
            {
                if (wlColumnPreferences.Columns.Count != gridView.Columns.Count)
                {
                    Log.Error("User preferences column count not matched.");
                    return;
                }

                int newColumnIndex = 0;
                foreach (CaseListColumn wlCol in wlColumnPreferences.Columns)
                {
                    GridViewColumn col = gridView.Columns.Where(x => (((x.Header as GridViewColumnHeader).Tag as string) == wlCol.Type.ToString())).FirstOrDefault();
                    if (col != null)
                    {
                        // set width
                        if (wlCol.DesiredWidth > 0)
                        {
                            col.Width = wlCol.DesiredWidth;
                        }

                        int currentColumnIndex = gridView.Columns.IndexOf(col);
                        gridView.Columns.Move(currentColumnIndex, newColumnIndex);
                    }

                    newColumnIndex++;
                }
            }
        }
    }
}
