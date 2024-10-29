/**
 * 
 * Package: MAG - VistA Imaging
 * WARNING: Per VHA Directive 2004-038, this routine should not be modified.
 * Date Created: 1/9/2012
 * Site Name:  Washington OI Field Office, Silver Spring, MD
 * Developer:  Paul Pentapaty
 * Description: 
 * 
 *       ;; +--------------------------------------------------------------------+
 *       ;; Property of the US Government.
 *       ;; No permission to copy or redistribute this software is given.
 *       ;; Use of unreleased versions of this software requires the user
 *       ;;  to execute a written test agreement with the VistA Imaging
 *       ;;  Development Office of the Department of Veterans Affairs,
 *       ;;  telephone (301) 734-0100.
 *       ;;
 *       ;; The Food and Drug Administration classifies this software as
 *       ;; a Class II medical device.  As such, it may not be changed
 *       ;; in any way.  Modifications to this software may result in an
 *       ;; adulterated medical device under 21CFR820, the use of which
 *       ;; is considered to be a violation of US Federal Statutes.
 *       ;; +--------------------------------------------------------------------+
 *       
 * 
 */

/*
  In App.xaml:
  <Application.Resources>
      <vm:ViewModelLocatorTemplate xmlns:vm="clr-namespace:VistA.Imaging.Telepathology.Worklist"
                                   x:Key="Locator" />
  </Application.Resources>
  
  In the View:
  DataContext="{Binding Source={StaticResource Locator}, Path=ViewModelName}"

  You can also use Blend to do all this with the tool's support.
  See http://www.galasoft.ch/mvvm
*/

using GalaSoft.MvvmLight;
using Microsoft.Practices.Unity;
using VistA.Imaging.Telepathology.Worklist.DataSource;
using VistA.Imaging.Telepathology.CCOW;

namespace VistA.Imaging.Telepathology.Worklist.ViewModel
{
    /// <summary>
    /// This class contains static references to all the view models in the
    /// application and provides an entry point for the bindings.
    /// </summary>
    public class ViewModelLocator
    {
        public static IUnityContainer Container
        {
            get;
            private set;
        }

        static ViewModelLocator()
        {
            Container = new UnityContainer();

            Container.RegisterType<IWorkListDataSource, WorkListDataSource>(new ContainerControlledLifetimeManager());
            Container.RegisterType<MainViewModel>(new ContainerControlledLifetimeManager(), new InjectionConstructor(new ResolvedParameter<IWorkListDataSource>()));
            Container.RegisterType<IContextManager, ContextManager>(new ContainerControlledLifetimeManager());
        }

        public ViewModelLocator()
        {
            ////if (ViewModelBase.IsInDesignModeStatic)
            ////{
            ////    // Create design time services and viewmodels
            ////}
            ////else
            ////{
            ////    // Create run time services and view models
            ////}
        }

        public MainViewModel MainWindowViewModel
        {
            get
            {
                return Container.Resolve<MainViewModel>();
            }
        }

        public static IWorkListDataSource DataSource
        {
            get
            {
                return Container.Resolve<IWorkListDataSource>();
            }
        }

        public static IContextManager ContextManager
        {
            get
            {
                return Container.Resolve<IContextManager>();
            }
        }
    }
}