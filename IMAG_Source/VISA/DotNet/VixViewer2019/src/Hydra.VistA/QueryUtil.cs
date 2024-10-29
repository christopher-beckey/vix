using Nancy; //VAI-707
using System.Collections.Generic; //VAI-1284
using System.Collections.Specialized; //VAI-1284
using System.Reflection;

namespace Hydra.VistA
{
    public class QueryUtil
    {
        public static T Create<T>(NancyContext ctx) where T : new()
        {
            var requestParams = (ctx.Request.Query as Nancy.DynamicDictionary).ToDictionary();
            var queryObject = new T();
            var type = queryObject.GetType();

            foreach (var item in requestParams)
            {
                if ((item.Value != null) && (item.Value is string))
                {
                    var prop = type.GetProperty(item.Key, BindingFlags.IgnoreCase | BindingFlags.Public | BindingFlags.Instance);
                    if (prop != null)
                        if (prop.PropertyType == typeof(string))
                            prop.SetValue(queryObject, item.Value);
                        else if (prop.PropertyType == typeof(bool))
                            prop.SetValue(queryObject, bool.Parse(item.Value.ToString()));
                }
            }

            return queryObject;
        }

        /// <summary>
        /// Convert a NameValueCollection to a Dictionary
        /// </summary>
        /// <param name="nvc"></param>
        /// <returns>The Dictionary</returns>
        /// <remarks>Created initially for VAI-1284</remarks>
        public static IDictionary<string, string> ToDictionary(NameValueCollection nvc)
        {
            IDictionary<string, string> dict = new Dictionary<string, string>();
            foreach (var k in nvc.AllKeys)
            {
                dict.Add(k, nvc[k]);
            }
            return dict;
        }
    }
}
