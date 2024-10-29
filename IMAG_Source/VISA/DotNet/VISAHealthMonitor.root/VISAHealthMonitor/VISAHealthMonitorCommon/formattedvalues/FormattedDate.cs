using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace VISAHealthMonitorCommon.formattedvalues
{
    public class FormattedDate : BaseFormattedValues, IComparable
    {
        public long Ticks { get; private set; }
        private readonly bool longFormat;

        public static FormattedDate MissingFormattedDate = new FormattedDate(FormattedValueState.missing);
        public static FormattedDate UnknownFormattedDate = new FormattedDate(FormattedValueState.unknown);

        public FormattedDate(long ticks, bool longFormat)
        {
            this.Ticks = ticks;
            this.longFormat = longFormat;
            this.FormattedValueState = FormattedValueState.known;
            SetTooltip();
        }

        private FormattedDate(FormattedValueState formattedValueState)
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

        public static FormattedDate createFromJavaTime(long ticksFrom1970, bool longFormat)
        {
            DateTime seventies = new DateTime(1970, 1, 1, 0, 0, 0, DateTimeKind.Utc);
            DateTime d = seventies.AddMilliseconds(ticksFrom1970);

            return new FormattedDate(d.Ticks, longFormat);
        }

        public override string ToString()
        {
            if (this.FormattedValueState == FormattedValueState.missing)
                return "?";
            else if (this.FormattedValueState == FormattedValueState.unknown)
                return "";
            return new DateTime(Ticks).ToLocalTime().ToString();
        }

        public override bool Equals(object obj)
        {
            if (obj is FormattedNumber)
            {
                FormattedDate that = (FormattedDate)obj;
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

        public int CompareTo(object obj)
        {
            if (obj is FormattedDate)
            {
                FormattedDate that = (FormattedDate)obj;
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
            return 1;
        }
    }
}
