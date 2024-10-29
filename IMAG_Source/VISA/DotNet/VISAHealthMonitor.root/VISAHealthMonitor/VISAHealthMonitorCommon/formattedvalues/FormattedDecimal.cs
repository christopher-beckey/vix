using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace VISAHealthMonitorCommon.formattedvalues
{
    public class FormattedDecimal : BaseFormattedValues, IComparable
    {
        public static string decimalFormat = "###,###,###,###.00";

        public double Decimal { get; private set; }

        public static FormattedDecimal MissingFormattedDecimal = new FormattedDecimal(FormattedValueState.missing);
        public static FormattedDecimal UnknownFormattedDecimal = new FormattedDecimal(FormattedValueState.unknown);

        public FormattedDecimal(double value)
        {
            this.Decimal = value;
            this.FormattedValueState = FormattedValueState.known;
            SetTooltip();
        }

        private FormattedDecimal(FormattedValueState formattedValueState)
        {
            this.FormattedValueState = formattedValueState;
            this.Decimal = 0.0f;
            SetTooltip();
        }

        public override string Tooltip { get; protected set; }

        private void SetTooltip()
        {
            switch (FormattedValueState)
            {
                case formattedvalues.FormattedValueState.known:
                    Tooltip = Decimal.ToString();
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
            return this.Decimal.ToString(decimalFormat);
        }

        public override bool Equals(object obj)
        {
            if (obj is FormattedNumber)
            {
                FormattedDecimal that = (FormattedDecimal)obj;
                if (this.FormattedValueState != that.FormattedValueState)
                    return false;
                // empty values the same
                if (this.FormattedValueState != FormattedValueState.known)
                    return true; // both empty or unknown, they are the same
                return this.Decimal.Equals(that.Decimal);
            }
            return false;
        }

        public override int GetHashCode()
        {
            if (this.FormattedValueState != FormattedValueState.known)
                return this.FormattedValueState.GetHashCode();
            return Decimal.GetHashCode();
        }

        public int CompareTo(object obj)
        {
            if (obj is FormattedDecimal)
            {
                FormattedDecimal that = (FormattedDecimal)obj;
                if (this.FormattedValueState == formattedvalues.FormattedValueState.known)
                {
                    if (that.FormattedValueState == formattedvalues.FormattedValueState.known)
                    {
                        // both have known values
                        return this.Decimal.CompareTo(that.Decimal);
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
