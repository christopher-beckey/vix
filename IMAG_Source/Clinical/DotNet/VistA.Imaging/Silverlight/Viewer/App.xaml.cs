//-----------------------------------------------------------------------
// <copyright file="App.xaml.cs" company="Department of Veterans Affairs">
//     Copyright (c) vhaiswgraver, Department of Veterans Affairs. All rights reserved.
// </copyright>
//-----------------------------------------------------------------------
namespace VistA.Imaging.Viewer
{
    using System;
    using System.Collections.Generic;
    using System.Net;
    using System.Net.Browser;
    using System.Text.RegularExpressions;
    using System.Windows;
    using Microsoft.Practices.ServiceLocation;
    using NLog;
    using VistA.Imaging.ComponentModel;
    using VistA.Imaging.DataSources;
    using VistA.Imaging.Facades;
    using VistA.Imaging.Models;
    using VistA.Imaging.Security.Cryptography;
    using VistA.Imaging.Security.Principal;
    using VistA.Imaging.Viewer.AWIV;
    using VistA.Imaging.Viewer.ViewModels;
    using VistA.Imaging.Viewer.Models;

    /// <summary>
    /// The Viewer application
    /// </summary>
    public partial class App : Application
    {
        /// <summary>
        /// The logger
        /// </summary>
        private Logger logger;

        /// <summary>
        /// SiteConnectionInfo Facade
        /// </summary>
        private ISiteConnectionInfoFacade siteConnectionInfoFacade;

        /// <summary>
        /// Initializes a new instance of the <see cref="App"/> class.
        /// </summary>
        public App()
        {
            this.Startup += this.Application_Startup;
            this.Exit += this.Application_Exit;
            this.UnhandledException += this.Application_UnhandledException;

            InitializeComponent();
        }

        /// <summary>
        /// Gets the App object for the current application.
        /// </summary>
        public static new App Current
        {
            get { return Application.Current as App; }
        }

        /// <summary>
        /// Gets the startup parameters.
        /// </summary>
        public AwivParameterDictionary AwivParameters { get; private set; }

        /// <summary>
        /// Handles the Startup event of the Application control.
        /// </summary>
        /// <param name="sender">The source of the event.</param>
        /// <param name="e">The <see cref="System.Windows.StartupEventArgs"/> instance containing the event data.</param>
        private void Application_Startup(object sender, StartupEventArgs e)
        {
            this.logger = LogManager.GetCurrentClassLogger();

            bool httpResult = WebRequest.RegisterPrefix("http://", WebRequestCreator.ClientHttp);
            bool httpsResult = WebRequest.RegisterPrefix("https://", WebRequestCreator.ClientHttp);

            // retrieve the input parameters
            AesBase64 aes = new AesBase64(@"MDEyMzQ1Njc4OWFiY2RlZg==");
            string clearParams = aes.DecryptToString(e.InitParams["ct"], e.InitParams["iv"]);
            this.AwivParameters = new AwivParameterDictionary(clearParams);

            // initialize the application
            Bootstrapper bootstrapper = new Bootstrapper();
            bootstrapper.Run();

            // setup the initial viewmodels based on the input parameters
            ArtifactSelectionViewModel asvm = ServiceLocator.Current.GetInstance<ArtifactSelectionViewModel>();

            asvm.ArtifactSets.Add(this.GenerateTestArtifactSet());
            //asvm.ArtifactSets.Add(this.AwivParameters.ArtifactSet);
            asvm.Patient = this.AwivParameters.Patient;
            BreadcrumbViewModel bvm = ServiceLocator.Current.GetInstance<BreadcrumbViewModel>();
            bvm.Trail.Add(new Breadcrumb()
            {
                Uri = this.AwivParameters.Patient.ICN,
                Text = this.AwivParameters.Patient.FullName
            });
            VistAPrincipal.Current = this.AwivParameters.VistAPrincipal;

            // kickoff startup process
            this.siteConnectionInfoFacade = ServiceLocator.Current.GetInstance<ISiteConnectionInfoFacade>();
            this.siteConnectionInfoFacade.GetByIdCompleted += new EventHandler<AsyncCompletedEventArgs<SiteConnectionInfo>>(this.SiteConnectionInfoFacade_GetByIdCompleted);
            this.siteConnectionInfoFacade.GetByIdAsync(this.AwivParameters.CVIXSiteNumber, this.AwivParameters.CVIXSiteNumber);
        }

        private ArtifactSet GenerateTestArtifactSet()
        {
            ArtifactSet root = new ArtifactSet("Artifact Set Root");
            root.Artifacts.Add(new Artifact("X-Ray", DateTime.Now, "SLC", new Uri("http://content.sportslogos.net/logos/7/177/thumbs/kwth8f1cfa2sch5xhjjfaof90.gif")));
            root.Artifacts.Add(new Artifact("Checkup", DateTime.Now, "SLC", new Uri("http://content.sportslogos.net/logos/7/173/thumbs/299.gif")));
            root.Artifacts.Add(new Artifact("Long Name for Procedure", DateTime.Now, "SLC", new Uri("http://content.sportslogos.net/logos/7/153/thumbs/318.gif")));

            ArtifactSet setOne = new ArtifactSet("Artifact Set Child 1");
            setOne.Artifacts.Add(new Artifact("Procedure 4", DateTime.Now, "SLC", new Uri("http://content.sportslogos.net/logos/7/149/thumbs/n0fd1z6xmhigb0eej3323ebwq.gif")));
            setOne.Artifacts.Add(new Artifact("Procedure 5", DateTime.Now, "SLC", new Uri("http://content.sportslogos.net/logos/7/174/thumbs/f1wggq2k8ql88fe33jzhw641u.gif")));

            setOne.ArtifactSets.Add(new ArtifactSet("Artifact Set Child 1.2"));
            setOne.ArtifactSets.Add(new ArtifactSet("Artifact Set Child 1.2"));
            setOne.ArtifactSets.Add(new ArtifactSet("Artifact Set Child 1.3"));
            root.ArtifactSets.Add(setOne);
            
            ArtifactSet setTwo = new ArtifactSet("Artifact Set Child 2");

            ArtifactSet setTwoOne = new ArtifactSet("Artifact Set Child 2.1");
            setTwoOne.ArtifactSets.Add(new ArtifactSet("Artifact Set Child 2.1.1"));
            setTwoOne.ArtifactSets.Add(new ArtifactSet("Artifact Set Child 2.1.2"));
            setTwo.ArtifactSets.Add(setTwoOne);
            setTwo.ArtifactSets.Add(new ArtifactSet("Artifact Set Child 2.2"));
            root.ArtifactSets.Add(setTwo);

            ArtifactSet setThree = new ArtifactSet("Artifact Set Child 3");

            root.ArtifactSets.Add(setThree);

            return root;
        }

        /// <summary>
        /// Handles the GetByIdCompleted event of the SiteConnectionInfoFacade control.
        /// </summary>
        /// <param name="sender">The source of the event.</param>
        /// <param name="e">The <see cref="VistA.Imaging.ComponentModel.AsyncCompletedEventArgs&lt;VistA.Imaging.Models.SiteConnectionInfo&gt;"/> instance containing the event data.</param>
        private void SiteConnectionInfoFacade_GetByIdCompleted(object sender, AsyncCompletedEventArgs<SiteConnectionInfo> e)
        {
            this.AwivParameters.Patient.PhotoUri = ServiceLocator.Current.GetInstance<IPatientFacade>().BuildPatientPhotoUri(
                e.Result,
                this.AwivParameters.ArtifactSet.SiteId,
                this.AwivParameters.Patient.ICN);
            ServiceLocator.Current.GetInstance<ArtifactSelectionViewModel>().LoadPhoto();
        }

        /// <summary>
        /// Handles the Exit event of the Application control.
        /// </summary>
        /// <param name="sender">The source of the event.</param>
        /// <param name="e">The <see cref="System.EventArgs"/> instance containing the event data.</param>
        private void Application_Exit(object sender, EventArgs e)
        {
        }

        /// <summary>
        /// Handles the UnhandledException event of the Application control.
        /// </summary>
        /// <param name="sender">The source of the event.</param>
        /// <param name="e">The <see cref="System.Windows.ApplicationUnhandledExceptionEventArgs"/> instance containing the event data.</param>
        private void Application_UnhandledException(object sender, ApplicationUnhandledExceptionEventArgs e)
        {
            Messages.ErrorMessage(e.ExceptionObject.Message);
            this.logger.ErrorException(e.ExceptionObject.Message, e.ExceptionObject);

            // If the app is running outside of the debugger then report the exception using
            // the browser's exception mechanism. On IE this will display it a yellow alert 
            // icon in the status bar and Firefox will display a script error.
            if (!System.Diagnostics.Debugger.IsAttached)
            {
                // NOTE: This will allow the application to continue running after an exception has been thrown
                // but not handled. 
                // For production applications this error handling should be replaced with something that will 
                // report the error to the website and stop the application.
                e.Handled = true;
                Deployment.Current.Dispatcher.BeginInvoke(delegate { this.ReportErrorToDOM(e); });
            }
        }

        /// <summary>
        /// Reports the error to DOM.
        /// </summary>
        /// <param name="e">The <see cref="System.Windows.ApplicationUnhandledExceptionEventArgs"/> instance containing the event data.</param>
        private void ReportErrorToDOM(ApplicationUnhandledExceptionEventArgs e)
        {
            try
            {
                string errorMsg = e.ExceptionObject.Message + e.ExceptionObject.StackTrace;
                errorMsg = errorMsg.Replace('"', '\'').Replace("\r\n", @"\n");
                System.Windows.Browser.HtmlPage.Window.Eval("throw new Error(\"Unhandled Error in Silverlight Application " + errorMsg + "\");");
            }
            catch (Exception)
            {
            }
        }
    }
}
