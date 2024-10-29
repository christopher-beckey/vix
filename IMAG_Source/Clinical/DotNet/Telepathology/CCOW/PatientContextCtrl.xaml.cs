using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Data;
using System.Windows.Documents;
using System.Windows.Input;
using System.Windows.Media;
using System.Windows.Media.Imaging;
using System.Windows.Navigation;
using System.Windows.Shapes;

namespace VistA.Imaging.Telepathology.CCOW
{
    /// <summary>
    /// Interaction logic for PatientContextCtrl.xaml
    /// </summary>
    public partial class PatientContextCtrl : UserControl
    {
        public PatientContextCtrl()
        {
            InitializeComponent();
        }

        private void UserControl_Loaded(object sender, RoutedEventArgs e)
        {

        }

        public static readonly DependencyProperty ContextStateProperty = DependencyProperty.Register(
                "ContextState", typeof(PatientContextState), typeof(PatientContextCtrl), new FrameworkPropertyMetadata(PatientContextState.Broken,
                                        FrameworkPropertyMetadataOptions.AffectsRender | FrameworkPropertyMetadataOptions.AffectsMeasure));
        public PatientContextState ContextState
        {
            get
            {
                return (PatientContextState)GetValue(ContextStateProperty);
            }

            set
            {
                SetValue(ContextStateProperty, value);

                //string imageResource = "broken32.bmp";
                //switch (_contextState)
                //{
                //    case CCOW.PatientContextState.Broken: imageResource = "broken32.bmp"; break;
                //    case CCOW.PatientContextState.Changing: imageResource = "changing32.bmp"; break;
                //    case CCOW.PatientContextState.Linked: imageResource = "link32.bmp"; break;
                //}

                //this.imageControl.BeginInit();
                //BitmapImage bmp = new BitmapImage(new Uri(string.Format("Images/{0}", imageResource), UriKind.Relative));
                //bmp.CacheOption = BitmapCacheOption.OnLoad;
                //this.imageControl.Source = bmp;
                //this.imageControl.EndInit();
            }
        }
    }
}
