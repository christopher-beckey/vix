using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace VISAHealthMonitorCommon.formattedvalues
{
    /// <summary>
    /// Formatting for a number (long)
    /// </summary>
    public class FormattedNumber : BaseFormattedValues, IComparable// IComparable needed for sorting in CollectionViewSource
    {
        public static string numberFormat = "###,###,###,##0";

        public long Number { get; private set; }

        public static FormattedNumber MissingFormattedNumber = new FormattedNumber(FormattedValueState.missing);
        public static FormattedNumber UnknownFormattedNumber = new FormattedNumber(FormattedValueState.unknown);

        public FormattedNumber(long number)
        {
            this.Number = number;
            this.FormattedValueState = FormattedValueState.known;
            SetTooltip();
        }

        private FormattedNumber(FormattedValueState formattedValueState)
        {
            this.Number = 0L;
            this.FormattedValueState = formattedValueState;
            SetTooltip();
        }

        public override string Tooltip { get; protected set; }

        private void SetTooltip()
        {
            switch (FormattedValueState)
            {
                case formattedvalues.FormattedValueState.known:
                    Tooltip = Number.ToString();
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
            return this.Number.ToString(numberFormat);
        }

        public override bool Equals(object obj)
        {
            if (obj is FormattedNumber)
            {
                FormattedNumber that = (FormattedNumber)obj;
                if (this.FormattedValueState != that.FormattedValueState)
                    return false;
                // empty values the same
                if (this.FormattedValueState != FormattedValueState.known)
                    return true; // both empty or unknown, they are the same
                return this.Number.Equals(that.Number);
            }
            return false;
        }

        public override int GetHashCode()
        {
            if (this.FormattedValueState != FormattedValueState.known)
                return this.FormattedValueState.GetHashCode();
            return Number.GetHashCode();
        }

        /*
        public int CompareTo(FormattedNumber that)
        {
            if (this.FormattedValueState != that.FormattedValueState)
                return -1;
            // empty values the same
            if (this.FormattedValueState != FormattedValueState.known)
                return 1; // both empty or unknown, they are the same
            return this.Number.CompareTo(that.Number);
        }

        public int Compare(FormattedNumber x, FormattedNumber y)
        {
            if (x.FormattedValueState != y.FormattedValueState)
                return -1;
            // empty values the same
            if (x.FormattedValueState != FormattedValueState.known)
                return 1; // both empty or unknown, they are the same
            return x.Number.CompareTo(y.Number);
        }*/

        public int CompareTo(object obj)
        {
            if (obj is FormattedNumber)
            {
                FormattedNumber that = (FormattedNumber)obj;
                if (this.FormattedValueState == formattedvalues.FormattedValueState.known)
                {
                    if (that.FormattedValueState == formattedvalues.FormattedValueState.known)
                    {
                        // both have known values
                        return this.Number.CompareTo(that.Number);
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
