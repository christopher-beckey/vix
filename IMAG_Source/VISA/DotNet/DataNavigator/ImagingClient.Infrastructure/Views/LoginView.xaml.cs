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
using ImagingClient.Infrastructure.Prism.Mvvm;
using ImagingClient.Infrastructure.ViewModels;
using VistaCommon.gov.va.med.Security;

namespace ImagingClient.Infrastructure.Views
{
    /// <summary>
    /// Interaction logic for LoginView.xaml
    /// </summary>
    public partial class LoginView : View<LoginViewModel>
    {
        public LoginView()
        {
            InitializeComponent();
        }

        private void Button_Click(object sender, RoutedEventArgs e)
        {
            VistACredentials credentials = new VistACredentials(AccessCodePasswordBox.SecurePassword, VerifyCodePasswordBox.SecurePassword);
            ViewModel.LoginCommand.Execute(credentials);
        }
    }
}
