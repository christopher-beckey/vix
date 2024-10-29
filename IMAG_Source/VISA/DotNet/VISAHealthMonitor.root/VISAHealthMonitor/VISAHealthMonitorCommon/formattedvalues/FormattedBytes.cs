using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace VISAHealthMonitorCommon.formattedvalues
{
    public class FormattedBytes : BaseFormattedValues, IComparable
    {
        public long Bytes { get; private set; }

        public static FormattedBytes MissingFormattedBytes = new FormattedBytes(FormattedValueState.missing);
        public static FormattedBytes UnknownFormattedBytes = new FormattedBytes(FormattedValueState.unknown);

        public FormattedBytes(long value)
        {
            this.Bytes = value;
            this.FormattedValueState = FormattedValueState.known;
            SetTooltip();
        }

        private FormattedBytes(FormattedValueState formattedValueState)
        {
            this.FormattedValueState = formattedValueState;
            this.Bytes = 0L;
            SetTooltip();
        }

        public override string Tooltip { get; protected set; }

        private void SetTooltip()
        {
            switch (FormattedValueState)
            {
                case formattedvalues.FormattedValueState.known:
                    Tooltip = Bytes.ToString() + " bytes";
                    break;
                default:
                    Tooltip = "unknown";
                    break;
            }
        }

        public override string ToString()
        {
            if (this.FormattedValueState == FormattedValueState.missing)
                return "?";
            else if (this.FormattedValueState == FormattedValueState.unknown)
                return "";
            return formatBytes(this.Bytes);
        }

        public override bool Equals(object obj)
        {
            if (obj is FormattedNumber)
            {
                FormattedBytes that = (FormattedBytes)obj;
                if (this.FormattedValueState != that.FormattedValueState)
                    return false;
                // empty values the same
                if (this.FormattedValueState != FormattedValueState.known)
                    return true; // both empty or unknown, they are the same
                return this.Bytes.Equals(that.Bytes);
            }
            return false;
        }

        public override int GetHashCode()
        {
            if (this.FormattedValueState != FormattedValueState.known)
                return this.FormattedValueState.GetHashCode();
            return Bytes.GetHashCode();
        }

        private string formatBytes(long bytes)
        {
            if (bytes < 1024)
            {
                return bytes + " bytes";
            }
            double kb = (double)bytes / 1024.0f;
            double mb = kb / 1024.0f;
            double gb = mb / 1024.0f;
            double tb = gb / 1024.0f;

            if (tb > 1.0)
            {
                return tb.ToString("N2") + " TB";
            }
            else if (gb > 1.0)
            {
                return gb.ToString("N2") + " GB";
            }
            else if (mb > 1.0)
            {
                return mb.ToString("N2") + " MB";
            }
            else
            {
                return kb.ToString("N2") + " KB";
            }
        }

        public int CompareTo(object obj)
        {
            if (obj is FormattedBytes)
            {
                FormattedBytes that = (FormattedBytes)obj;
                if (this.FormattedValueState == formattedvalues.FormattedValueState.known)
                {
                    if (that.FormattedValueState == formattedvalues.FormattedValueState.known)
                    {
                        // both have known values
                        return this.Bytes.CompareTo(that.Bytes);
                    }
                    // this has a value, that does not
                    return 1;
                }
                if (that.FormattedValueState == formattedvalues.FormattedValueState.known)
                    return -1; // this does not have a value, that does
                // neither of them have a value, they are the same
                return 0;
            }
            return 1;
        }
    }
}
