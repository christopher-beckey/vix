using Hydra.Security;

namespace Hydra.IX.Core
{
    static class HipaaUtil
    {
        internal static T Decrypt<T>(string text)
        {
            return JsonUtil.Deserialize<T>(CryptoUtil.DecryptAES(text));
        }

        internal static string Encrypt(object obj)
        {
            return EncryptText(JsonUtil.Serialize(obj));
        }

        internal static string EncryptText(string text)
        {
            return (string.IsNullOrEmpty(text))? null : CryptoUtil.EncryptAES(text);
        }

        internal static string DescryptText(string text)
        {
            return (string.IsNullOrEmpty(text)) ? null : CryptoUtil.DecryptAES(text);
        }
    }
}
