using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Windows.Forms;
using System.Windows.Interop;

namespace VistA.Imaging.Telepathology.Worklist.Controls
{
    public class ShutdownTimer
    {
        static Timer timer = null;

        static public int Duration { get; set; }

        public delegate void DoShutdown();

        static public event DoShutdown DoShutdownEvent;

        public ShutdownTimer()
        {
            Duration = 0;
        }

        static public void StartTimer()
        {
            ComponentDispatcher.ThreadIdle += new EventHandler(DispatcherQueueHandler);
        }

        static void DispatcherQueueHandler(object sender, EventArgs e)
        {
            if (timer == null)
            {
                timer = new Timer();
                timer.Interval = Duration * 60 * 1000;  // in miliseconds
                timer.Tick += new EventHandler(TimerTick);
                timer.Enabled = true;
            }
            else if (!timer.Enabled)
            {
                timer.Enabled = true;
            }
        }

        static void TimerTick(object sender, EventArgs e)
        {
            if (timer != null)
            {
                ComponentDispatcher.ThreadIdle -= new EventHandler(DispatcherQueueHandler);
                timer.Stop();
                //timer = null;
                if (DoShutdownEvent != null)
                {
                    DoShutdownEvent();
                }
            }
        }

        static public void ResetTimer()
        {
            if (timer != null)
            {
                timer.Enabled = false;
                timer.Enabled = true;
            }
        }

        static public void StopTimer()
        {
            if (timer != null)
            {
                timer.Enabled = false;
            }
        }
    }
}
