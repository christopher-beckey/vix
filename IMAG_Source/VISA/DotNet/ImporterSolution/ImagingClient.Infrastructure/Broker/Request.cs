using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace ImagingClient.Infrastructure.Broker
{
    public class Request
    {
        private List<Parameter> parameterList;
        private string methodName;

        public string MethodName
        {
            get { return this.methodName; }
            set { this.methodName = value; }
        }

        public List<Parameter> Parameters
        {
            get { return this.parameterList; }
            set { this.parameterList = value; }
        }

        public Request()
        {
            this.parameterList = new List<Parameter>();
            this.methodName = string.Empty;
        }

        public Request AddParameter(string value)
        {
            Parameter param = new Parameter();
            param.Type = ParameterType.Literal;
            param.Value = value;
            this.parameterList.Add(param);

            return this;
        }

        public Request AddParameter(List<string> value)
        {
            Parameter param = new Parameter();
            param.Type = ParameterType.List;
            param.Value = value;
            this.parameterList.Add(param);

            return this;
        }

        public Request AddParameter(Parameter value)
        {
            Parameter param = new Parameter();
            param.Type = value.Type;
            param.Value = value.Value;
            this.parameterList.Add(param);

            return this;
        }

        public void ClearParameters()
        {
            this.parameterList.Clear();
        }
    }
}
