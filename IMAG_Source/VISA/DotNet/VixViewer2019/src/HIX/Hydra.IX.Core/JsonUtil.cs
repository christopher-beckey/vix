using Nancy.Json;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Hydra.IX.Core
{
    public class JsonUtil
    {
        public static string Serialize(object obj)
        {
            var serializer = new JavaScriptSerializer { MaxJsonLength = Int32.MaxValue };
            return serializer.Serialize(obj);
        }

        public static T Deserialize<T>(string input)
        {
            var serializer = new JavaScriptSerializer { MaxJsonLength = Int32.MaxValue };
            return serializer.Deserialize<T>(input);
        }
    }
}
