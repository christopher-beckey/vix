using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Windows.Input;

namespace VISAHealthMonitorCommon.messages
{
    public class CursorChangeMessage
    {
        public Cursor Cursor { get; set; }

        public CursorChangeMessage(Cursor cursor)
        {
            this.Cursor = cursor;
        }
    }
}
