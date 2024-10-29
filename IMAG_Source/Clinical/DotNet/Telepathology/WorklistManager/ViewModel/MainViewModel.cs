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

using GalaSoft.MvvmLight;
using VistA.Imaging.Telepathology.Worklist.DataSource;
using GalaSoft.MvvmLight.Command;
using VistA.Imaging.Telepathology.CCOW;
using VistA.Imaging.Telepathology.Worklist.Messages;

namespace VistA.Imaging.Telepathology.Worklist.ViewModel
{
	/// <summary>
	/// This class contains properties that the main View can data bind to.
	/// <para>
	/// Use the <strong>mvvminpc</strong> snippet to add bindable properties to this ViewModel.
	/// </para>
	/// <para>
	/// You can also use Blend to data bind with the tool's support.
	/// </para>
	/// <para>
	/// See http://www.galasoft.ch/mvvm
	/// </para>
	/// </summary>
	public class MainViewModel : WorkspaceViewModel
	{
		public WorklistsViewModel WorklistsViewModel { get; set; }

		/// <summary>
		/// Initializes a new instance of the MainViewModel class.
		/// </summary>
		public MainViewModel(IWorkListDataSource dataSource)
		{
			DataSource = dataSource;

			WorklistsViewModel = new WorklistsViewModel(dataSource);

			AppTitle = "VistA Imaging Telepathology Worklist";

			this.SuspendContextCommand = new RelayCommand(SuspendContext,
				() => (ViewModelLocator.ContextManager.ContextState == ContextState.Participating));

			this.ResumeContextCommand = new RelayCommand(ResumeContext,
				() => (ViewModelLocator.ContextManager.ContextState == ContextState.Suspended));
			
			this.ResumeGetContextCommand = new RelayCommand(ResumeContextGet,
				() => (( (ViewModelLocator.ContextManager.ContextState == ContextState.Participating) &&
						 (ViewModelLocator.ContextManager.CurrentContext == null) ) ||
					   (ViewModelLocator.ContextManager.ContextState == ContextState.Suspended))  );

			this.ResumeSetContextCommand = new RelayCommand(ResumeContextSet,
				() => ((ViewModelLocator.ContextManager.ContextState == ContextState.Suspended) &&
						 (ViewModelLocator.ContextManager.CurrentContext != null)));

			this.LogoutCommand = new RelayCommand(() => { AppMessages.ApplicationLogoutMessage.Send(); });

		}

		public IWorkListDataSource DataSource { get; set; }

		public string AppTitle { get; set; }

        public string SiteAbbr { get; set; }

        public string GeneralStatus { get; set; }

        public string UnreadListRefreshTime { get; set; }

        public string ReadListRefreshTime { get; set; }

#region Commands

		public RelayCommand LogoutCommand
		{
			get;
			private set;
		}
		
		public RelayCommand SuspendContextCommand
		{
			get;
			private set;
		}

		public RelayCommand ResumeContextCommand
		{
			get;
			private set;
		}
		
		public RelayCommand ResumeSetContextCommand
		{
			get;
			private set;
		}

		public RelayCommand ResumeGetContextCommand
		{
			get;
			private set;
		}
 
	#endregion    

		void SuspendContext()
		{
			ViewModelLocator.ContextManager.Suspend();
		}

		void ResumeContext()
		{
			ViewModelLocator.ContextManager.Resume();
		}
		
		void ResumeContextGet()
		{
			ViewModelLocator.ContextManager.ResumeGet();
		}

		void ResumeContextSet()
		{
			ViewModelLocator.ContextManager.ResumeSet(ViewModelLocator.ContextManager.CurrentContext);
		}
	}
}