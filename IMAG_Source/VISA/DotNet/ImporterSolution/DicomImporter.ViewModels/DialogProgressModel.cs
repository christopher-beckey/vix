/*
Project: ImporterSolution
Date Created: 2/7/2023
Site Name:  Field Office (Remote)
Developer:  Gary Pham (oitlonphamg)
Description: P346 - This is code for a dialog progress for display of time duration of how long a task has taken to process/complete.

: ----------
: Property of the US Government.
: No permission to copy or redistribute this software is given.
: Use of unreleased versions of this software requires the user
: to execute a written test agreement with the VistA Imaging
: Development Office of the Department of Veterans Affairs,
: telephone (301) 734-0100.
: 
: The Food and Drug Administration classifies this software as
: a Class II medical device.  As such, it may not be changed
: in any way.  Modifications to this software may result in an
: adulterated medical device under 21CFR820, the use of which
: is considered to be a violation of US Federal Statutes.
: ----------
 */

using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DicomImporter.ViewModels
{
   public class DialogProgressModel :  INotifyPropertyChanged
   {
      public bool m_bStatus;
      public event PropertyChangedEventHandler PropertyChanged;

      public DialogProgressModel()
      {
         BackgroundWorker threadTimeSpan = new BackgroundWorker();
         threadTimeSpan.DoWork += new DoWorkEventHandler(TimeSpanThread);
         threadTimeSpan.RunWorkerAsync(this);
         m_bStatus = true;
         m_strTimer = new string[]{string.Empty, string.Empty, string.Empty, string.Empty};
         m_bTimerVisible = new bool[]{false, false, false, false};
      }

      public void InitializeVisibility()
      {
         TimerDayVisible = false;
         TimerHourVisible = false;
         TimerMinuteVisible = false;
         TimerSecondVisible = false;
      }

      private string m_strStatusTimer;
      public string StatusTimer
      {
         get
         {
            return m_strStatusTimer;
         }
         set
         {
            m_strStatusTimer = value;
            PropertyChangedEventHandler handler = this.PropertyChanged;

            if (handler != null)
            {
               handler.Invoke(this, new PropertyChangedEventArgs("StatusTimer"));
            }
         }
      }

      private string[] m_strTimer;
      public string TimerSecond
      {
         get
         {
            return m_strTimer[3];
         }
         set
         {
            m_strTimer[3] = value;
            PropertyChangedEventHandler handler = this.PropertyChanged;

            if (handler != null)
            {
               handler.Invoke(this, new PropertyChangedEventArgs("TimerSecond"));
            }
         }
      }

      public string TimerMinute
      {
         get
         {
            return m_strTimer[2];
         }
         set
         {
            m_strTimer[2] = value;
            PropertyChangedEventHandler handler = this.PropertyChanged;

            if (handler != null)
            {
               handler.Invoke(this, new PropertyChangedEventArgs("TimerMinute"));
            }
         }
      }

      public string TimerHour
      {
         get
         {
            return m_strTimer[1];
         }
         set
         {
            m_strTimer[1] = value;
            PropertyChangedEventHandler handler = this.PropertyChanged;

            if (handler != null)
            {
               handler.Invoke(this, new PropertyChangedEventArgs("TimerHour"));
            }
         }
      }

      public string TimerDay
      {
         get
         {
            return m_strTimer[0];
         }
         set
         {
            m_strTimer[0] = value;
            PropertyChangedEventHandler handler = this.PropertyChanged;

            if (handler != null)
            {
               handler.Invoke(this, new PropertyChangedEventArgs("TimerDay"));
            }
         }
      }

      private bool[] m_bTimerVisible;
      public bool TimerDayVisible
      {
         get
         {
            return m_bTimerVisible[0];
         }
         set
         {
            m_bTimerVisible[0] = value;
            PropertyChangedEventHandler handler = this.PropertyChanged;

            if (handler != null)
            {
               handler.Invoke(this, new PropertyChangedEventArgs("TimerDayVisible"));
            }
         }
      }

      public bool TimerHourVisible
      {
         get
         {
            return m_bTimerVisible[1];
         }
         set
         {
            m_bTimerVisible[1] = value;
            PropertyChangedEventHandler handler = this.PropertyChanged;

            if (handler != null)
            {
               handler.Invoke(this, new PropertyChangedEventArgs("TimerHourVisible"));
            }
         }
      }

      public bool TimerMinuteVisible
      {
         get
         {
            return m_bTimerVisible[2];
         }
         set
         {
            m_bTimerVisible[2] = value;
            PropertyChangedEventHandler handler = this.PropertyChanged;

            if (handler != null)
            {
               handler.Invoke(this, new PropertyChangedEventArgs("TimerMinuteVisible"));
            }
         }
      }

      public bool TimerSecondVisible
      {
         get
         {
            return m_bTimerVisible[3];
         }
         set
         {
            m_bTimerVisible[3] = value;
            PropertyChangedEventHandler handler = this.PropertyChanged;

            if (handler != null)
            {
               handler.Invoke(this, new PropertyChangedEventArgs("TimerSecondVisible"));
            }
         }
      }

      private void TimeSpanThread(object sender, DoWorkEventArgs e)
      {
         TimerDayVisible = false;
         TimerHourVisible = false;
         TimerMinuteVisible = false;
         TimerSecondVisible = false;
         DateTime dtStart = DateTime.Now;

         while (((DialogProgressModel)(e.Argument)).m_bStatus)
         {
            TimeSpan tsNow = DateTime.Now - dtStart;
            ((DialogProgressModel)(e.Argument)).StatusTimer = string.Format("{0} days:: {1} hours:: {2} minutes:: {3} seconds",
                                                                            tsNow.Days,
                                                                            tsNow.Hours,
                                                                            tsNow.Minutes,
                                                                            tsNow.Seconds);

            if (tsNow.Days > 0)
            {
               TimerDay = string.Format("{0}", tsNow.Days);
               TimerHour = string.Format("{0}", tsNow.Hours);
               TimerMinute = string.Format("{0}", tsNow.Minutes);
               TimerSecond = string.Format("{0}", tsNow.Seconds);
               TimerDayVisible = true;
            }

            else if (tsNow.Hours > 0)
            {
               TimerHour = string.Format("{0}", tsNow.Hours);
               TimerMinute = string.Format("{0}", tsNow.Minutes);
               TimerSecond = string.Format("{0}", tsNow.Seconds);
               TimerHourVisible = true;
            }

            else if (tsNow.Minutes > 0)
            {
               TimerMinute = string.Format("{0}", tsNow.Minutes);
               TimerSecond = string.Format("{0}", tsNow.Seconds);
               TimerMinuteVisible = true;
            }

            else
            {
               TimerSecond = string.Format("{0}", tsNow.Seconds);
               TimerSecondVisible = true;
            }

            System.Threading.Thread.Sleep(1000);
         }
      }
   }
}
