using System;

namespace Hydra.Common
{
    public static class UrlBase64
    {
        private static readonly char[] TwoPads = { '=', '=' };

        public static string Encode(byte[] bytes)
        {
            return Convert.ToBase64String(bytes).TrimEnd('=').Replace('+', '-').Replace('/', '_');
        }

        public static byte[] Decode(string encoded)
        {
            if (encoded == null || encoded == "")
            {
                return null;
            }

            encoded.Replace('-', '+');
            encoded.Replace('_', '/');

            int paddings = encoded.Length % 4;
            if (paddings > 0)
            {
                encoded += new string('=', 4 - paddings);
            }

            byte[] encodedDataAsBytes = System.Convert.FromBase64String(encoded);
            return encodedDataAsBytes;

            //var chars = new List<char>(encoded.ToCharArray());

            //for (int i = 0; i < chars.Count; ++i)
            //{
            //    if (chars[i] == '_')
            //    {
            //        chars[i] = '/';
            //    }
            //    else if (chars[i] == '-')
            //    {
            //        chars[i] = '+';
            //    }
            //}

            //switch (encoded.Length % 4)
            //{
            //    case 2:
            //        chars.Add('=');
            //        chars.AddRange(TwoPads);
            //        break;
            //    case 3:
            //        chars.Add('=');
            //        break;
            //}

            //var array = chars.ToArray();

            //return Convert.FromBase64CharArray(array, 0, array.Length);
        }
    }
}