//-----------------------------------------------------------------------
// <copyright file="App.xaml.cs" company="Department of Veterans Affairs">
// Package: MAG - VistA Imaging
//   WARNING: Per VHA Directive 2004-038, this routine should not be modified.
//   Date Created: 11/30/2011
//   Site Name:  Washington OI Field Office, Silver Spring, MD
//   Developer: vhaiswgraver
//   Description: 
//         ;; +--------------------------------------------------------------------+
//         ;; Property of the US Government.
//         ;; No permission to copy or redistribute this software is given.
//         ;; Use of unreleased versions of this software requires the user
//         ;;  to execute a written test agreement with the VistA Imaging
//         ;;  Development Office of the Department of Veterans Affairs,
//         ;;  telephone (301) 734-0100.
//         ;;
//         ;; The Food and Drug Administration classifies this software as
//         ;; a Class II medical device.  As such, it may not be changed
//         ;; in any way.  Modifications to this software may result in an
//         ;; adulterated medical device under 21CFR820, the use of which
//         ;; is considered to be a violation of US Federal Statutes.
//         ;; +--------------------------------------------------------------------+
// </copyright>
// -----------------------------------------------------------------------
namespace VistA.Imaging.Shell
{
    using System.Windows;

    /// <summary>
    /// Interaction logic for App.xaml
    /// </summary>
    public partial class App : Application
    {
        /// <summary>
        /// Initializes a new instance of the <see cref="App"/> class.
        /// </summary>
        /// <exception cref="T:System.InvalidOperationException">More than one instance of the <see cref="T:System.Windows.Application"/> class is created per <see cref="T:System.AppDomain"/>.</exception>
        public App()
        {
            this.Startup += this.Application_Startup;
        }

        /// <summary>
        /// Handles the Startup event of the Application control.
        /// </summary>
        /// <param name="sender">The source of the event.</param>
        /// <param name="e">The <see cref="System.Windows.StartupEventArgs"/> instance containing the event data.</param>
        private void Application_Startup(object sender, StartupEventArgs e)
        {
            Bootstrapper bootstrapper = new Bootstrapper();
            bootstrapper.Run();
        }
    }
}
