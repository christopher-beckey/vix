using System;

namespace Hydra.IX.Common
{
    public class ImagePartRequestBinder : Nancy.ModelBinding.IModelBinder
    {
        public bool CanBind(Type modelType)
        {
            return (modelType == typeof(Hydra.IX.Common.ImagePartRequest));
        }

        public object Bind(Nancy.NancyContext context, Type modelType, object instance, Nancy.ModelBinding.BindingConfig configuration, params string[] blackList)
        {
            if (context.Request.Query != null)
            {
                var dict = context.Request.Query as Nancy.DynamicDictionary;
                if (dict != null)
                {
                    var imagePartRequest = new Hydra.IX.Common.ImagePartRequest()
                    {
                        FrameNumber = -1,
                        Transform = Hydra.Common.ImagePartTransform.Default
                    };

                    foreach (var item in dict.ToDictionary())
                    {
                        string key = item.Key.ToLower();
                        switch (key)
                        {
                            case "imageuid":
                                imagePartRequest.ImageUid = item.Value as string;
                                break;

                            case "groupuid":
                                imagePartRequest.GroupUid = item.Value as string;
                                break;

                            case "format":
                                imagePartRequest.Type = EnumUtil<Hydra.Common.ImagePartType>.ParseDefined(item.Value as string);
                                break;

                            case "transform":
                                imagePartRequest.Transform = EnumUtil<Hydra.Common.ImagePartTransform>.Parse(item.Value as string, Hydra.Common.ImagePartTransform.Default); break;

                            case "framenumber":
                                {
                                    int value = 0;
                                    if (int.TryParse(item.Value as string, out value))
                                        imagePartRequest.FrameNumber = value;
                                    else
                                        imagePartRequest.FrameNumber = -1;
                                }
                                break;

                            case "overlayindex":
                                {
                                    int value = 0;
                                    if (int.TryParse(item.Value as string, out value))
                                        imagePartRequest.OverlayIndex = value;
                                }
                                break;

                            case "cachelocator":
                                imagePartRequest.CacheLocator = item.Value as string;
                                break;

                            case "excludeimageinfo":
                                {
                                    bool value = false;
                                    if (bool.TryParse(item.Value as string, out value))
                                        imagePartRequest.ExcludeImageInfo = value;
                                    else
                                        imagePartRequest.ExcludeImageInfo = false;
                                }
                                break;

                            default:
                                SetECGParameter(ref imagePartRequest, key, item.Value);
                                break;
                        }
                    }

                    return imagePartRequest;
                }
            }

            return null;
        }

        private void SetECGParameter(ref Hydra.IX.Common.ImagePartRequest imagePartRequest, string name, object value)
        {
            switch (name)
            {
                case "drawtype":
                    imagePartRequest.SafeECGParams().DrawType = ParseInt(value as string); break;

                case "gridtype":
                    imagePartRequest.SafeECGParams().GridType = ParseInt(value as string); break;

                case "gridcolor":
                    imagePartRequest.SafeECGParams().GridColor = ParseInt(value as string); break;

                case "signalthickness":
                    imagePartRequest.SafeECGParams().SignalThickness = ParseInt(value as string); break;

                case "gain":
                    imagePartRequest.SafeECGParams().Gain = ParseInt(value as string); break;

                case "extraleads":
                    imagePartRequest.SafeECGParams().ExtraLeads = value as string; break;
            }
        }

        private int ParseInt(string text, int defaultValue = 0)
        {
            int value = 0;
            return int.TryParse(text, out value) ? value : defaultValue;
        }
    }
}