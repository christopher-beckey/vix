// -----------------------------------------------------------------------
// <copyright file="EnumToImageConverter.cs" company="Patriot Technologies">
// TODO: Update copyright text.
// </copyright>
// -----------------------------------------------------------------------

namespace VistA.Imaging.Telepathology.CCOW
{
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using System.Text;
    using System.Windows.Data;
    using System.Windows.Media;
    using System.Windows.Media.Imaging;

    /// <summary>
    /// TODO: Update summary.
    /// </summary>
    internal class EnumToImageConverter : IValueConverter
    {
        #region IValueConverter Members

        private BitmapImage GetImage(string resourcePath)
        {
            var image = new BitmapImage();

            string moduleName = this.GetType().Assembly.GetName().Name;
            string resourceLocation =
                string.Format("pack://application:,,,/{0};component/{1}", moduleName,
                              resourcePath);

            try
            {
                image.BeginInit();
                image.CacheOption = BitmapCacheOption.OnLoad;
                image.CreateOptions = BitmapCreateOptions.IgnoreImageCache;
                image.UriSource = new Uri(resourceLocation);
                image.EndInit();
            }
            catch (Exception e)
            {
                System.Diagnostics.Trace.WriteLine(e.ToString());
            }

            return image;
        }

        public object Convert(object value, Type targetType, object parameter, System.Globalization.CultureInfo culture)
        {
            if (targetType != typeof(ImageSource))
                throw new InvalidOperationException("The target must be ImageSource or derived types");

            if (value != null && value is PatientContextState)
            {
                PatientContextState state = (PatientContextState) value;
                string imageResource = "broken32.bmp";
                switch (state)
                {
                    case CCOW.PatientContextState.Broken: imageResource = "broken32.bmp"; break;
                    case CCOW.PatientContextState.Changing: imageResource = "changing32.bmp"; break;
                    case CCOW.PatientContextState.Linked: imageResource = "link32.bmp"; break;
                }

                BitmapImage bmp = GetImage(string.Format(@"Images/{0}", imageResource));
                return bmp;

            }
            return null;
        }

        public object ConvertBack(object value, Type targetType, object parameter, System.Globalization.CultureInfo culture)
        {
            throw new NotImplementedException();
        }

        #endregion
    }
}
