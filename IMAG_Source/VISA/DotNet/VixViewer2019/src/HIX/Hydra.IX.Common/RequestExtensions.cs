namespace Hydra.IX.Common
{
    public static class RequestExtensions
    {
        public static Hydra.Common.ECGParams SafeECGParams(this Hydra.IX.Common.ImagePartRequest imagePartRequest)
        {
            if (imagePartRequest.ECGParams == null)
                imagePartRequest.ECGParams = new Hydra.Common.ECGParams();

            return imagePartRequest.ECGParams;
        }
    }
}