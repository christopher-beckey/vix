using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace VISAHealthMonitorCommon.formattedvalues
{
    public class FormattedTime : BaseFormattedValues, IComparable
    {
        public long Ticks { get; private set; }
        private readonly bool longFormat;

        public static FormattedTime MissingFormattedTime = new FormattedTime(FormattedValueState.missing);
        public static FormattedTime UnknownFormattedTime = new FormattedTime(FormattedValueState.unknown);

        public FormattedTime(long ticks, bool longFormat)
        {
            this.Ticks = ticks;
            this.longFormat = longFormat;
            this.FormattedValueState = FormattedValueState.known;
            SetTooltip();
        }

        private FormattedTime(FormattedValueState formattedValueState)
        {
            this.Ticks = 0L;
            this.longFormat = false;
            this.FormattedValueState = formattedValueState;
            SetTooltip();
        }

        public override string Tooltip { get; protected set; }

        private void SetTooltip()
        {
            switch (FormattedValueState)
            {
                case formattedvalues.FormattedValueState.known:
                    Tooltip = Ticks.ToString() + " ticks";
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
            return ticksToTime(longFormat);
        }

        public override bool Equals(object obj)
        {
            if (obj is FormattedNumber)
            {
                FormattedTime that = (FormattedTime)obj;
                if (this.FormattedValueState != that.FormattedValueState)
                    return false;
                // empty values the same
                if (this.FormattedValueState != FormattedValueState.known)
                    return true; // both empty or unknown, they are the same
                return this.Ticks.Equals(that.Ticks);
            }
            return false;
        }

        public override int GetHashCode()
        {
            if (this.FormattedValueState != FormattedValueState.known)
                return this.FormattedValueState.GetHashCode();
            return Ticks.GetHashCode();
        }

        private string ticksToTime(bool longFormat)
        {
            TimeSpan span = ToTimespan();

            StringBuilder sb = new StringBuilder();
            string prefix = "";
            if (span.Days > 0)
            {
                sb.Append(span.Days);
                sb.Append(" days");
                prefix = ", ";
            }
            if (span.Hours > 0)
            {
                sb.Append(prefix);
                sb.Append(span.Hours);
                sb.Append(" hrs");
                prefix = ", ";
            }
            if (span.Minutes > 0)
            {
                sb.Append(prefix);
                sb.Append(span.Minutes);
                sb.Append(" mins");
                prefix = ", ";
            }
            if (longFormat)
            {
                if (span.Seconds > 0)
                {
                    sb.Append(prefix);
                    sb.Append(span.Seconds);
                    sb.Append(" sec");
                    prefix = ", ";
                }
                if (span.Milliseconds > 0)
                {
                    sb.Append(prefix);
                    sb.Append(span.Milliseconds);
                    sb.Append(" ms");
                    prefix = ", ";
                }
            }

            return sb.ToString();
        }

        public TimeSpan ToTimespan()
        {
            int sec = (int)(Ticks / 1000.0f);
            int ms = (int)(Ticks % 1000);
            return new TimeSpan(0, 0, 0, sec, ms);
        }

        public int CompareTo(object obj)
        {
            if (obj is FormattedTime)
            {
                FormattedTime that = (FormattedTime)obj;
                if (this.FormattedValueState == formattedvalues.FormattedValueState.known)
                {
                    if (that.FormattedValueState == formattedvalues.FormattedValueState.known)
                    {
                        // both have known values
                        return this.Ticks.CompareTo(that.Ticks);
                    }
                    // this has a value, that does not
                    return 1;
                }
                if (that.FormattedValueState == formattedvalues.FormattedValueState.known)
                    return -1; // this does not have a value, that does
                // neither of them have a value, they are the same
                return 0;
            }
            return -1;
        }
    }
}
