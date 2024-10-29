using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Web.Script.Serialization;

namespace Hydra.Dicom
{
    public class JsonUtil
    {
        public static string Serialize(object input)
        {
            var serializer = new JavaScriptSerializer { MaxJsonLength = Int32.MaxValue };
            return serializer.Serialize(input);
        }

        public static T Deserialize<T>(string input)
        {
            JavaScriptSerializer deserializer = new JavaScriptSerializer { MaxJsonLength = Int32.MaxValue };
            return deserializer.Deserialize<T>(input);
        }
    }
}
