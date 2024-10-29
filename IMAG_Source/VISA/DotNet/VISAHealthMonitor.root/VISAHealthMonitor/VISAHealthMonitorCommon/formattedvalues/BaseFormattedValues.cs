using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace VISAHealthMonitorCommon.formattedvalues
{
    public abstract class BaseFormattedValues
    {
        public FormattedValueState FormattedValueState { get; protected set; }

        public bool IsValueSet
        {
            get
            {
                return this.FormattedValueState == FormattedValueState.known;
            }
        }

        public abstract string Tooltip { get; protected set; }
    }

    public enum FormattedValueState
    {
        /// <summary>
        /// 
        /// </summary>
        unknown, missing, known
    }
}
