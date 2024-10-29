namespace SCIP_Tool //Hydra.Common
{
    public class Util
    {
        public static string Base64Encode(string plainText)
        {
            var plainTextBytes = System.Text.Encoding.UTF8.GetBytes(plainText);
            return System.Convert.ToBase64String(plainTextBytes);
        }

        public static string Base64Decode(string base64EncodedData)
        {
            var base64EncodedBytes = System.Convert.FromBase64String(base64EncodedData);
            return System.Text.Encoding.UTF8.GetString(base64EncodedBytes);
        }

        public static string Base64EncodeUrl(string plainText)
        {
            var plainTextBytes = System.Text.Encoding.UTF8.GetBytes(plainText);
            return System.Convert.ToBase64String(plainTextBytes);
            //var plainTextBytes = System.Text.Encoding.UTF8.GetBytes(plainText);
            //return UrlBase64.Encode(plainTextBytes); // url safe
        }

        public static string Base64DecodeUrl(string base64EncodedData)
        {
            var base64EncodedBytes = System.Convert.FromBase64String(base64EncodedData);
            return System.Text.Encoding.UTF8.GetString(base64EncodedBytes);
            //var base64EncodedBytes = UrlBase64.Decode(base64EncodedData); // url safe
            //return System.Text.Encoding.UTF8.GetString(base64EncodedBytes);
        }
    }
}