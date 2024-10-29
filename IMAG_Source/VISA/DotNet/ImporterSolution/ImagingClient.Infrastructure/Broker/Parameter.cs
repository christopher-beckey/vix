using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace ImagingClient.Infrastructure.Broker
{
    public class Parameter
    {
        private object value;
        private ParameterType type;

        public object Value
        {
            get { return this.value; }
            set { this.value = value; }
        }

        public ParameterType Type
        {
            get { return this.type; }
            set { this.type = value; }
        }

        public Parameter()
        {
            this.value = null;
            this.type = ParameterType.Literal;
        }
    }

    public enum ParameterType
    {
        Literal,
        Reference,
        List
    }
}
