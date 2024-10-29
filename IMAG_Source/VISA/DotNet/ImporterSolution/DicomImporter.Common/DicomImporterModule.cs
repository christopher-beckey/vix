/**
 * 
 * Package: MAG - VistA Imaging
 * WARNING: Per VHA Directive 2004-038, this routine should not be modified.
 * Date Created: 03/01/2011
 * Site Name:  Washington OI Field Office, Silver Spring, MD
 * Developer:  Jon Louthian
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
 */
namespace DicomImporter.Common
{
    using System.Configuration;

    using Microsoft.Practices.Prism.Modularity;
    using Microsoft.Practices.Prism.Regions;
    using Microsoft.Practices.Unity;
    using Microsoft.Practices.Unity.Configuration;

    /// <summary>
    /// The dicom importer module.
    /// </summary>
    public class DicomImporterModule : IModule
    {
        /// <summary>
        /// The file name for the DicomImporter Unity config file
        /// </summary>
        private const string DicomImporterUnityConfigFile = "DicomImporter.unity.config";

        #region Constants and Fields

        /// <summary>
        /// The container.
        /// </summary>
        private readonly IUnityContainer container;

        /// <summary>
        /// The region manager.
        /// </summary>
        private IRegionManager regionManager;

        #endregion

        #region Constructors and Destructors

        /// <summary>
        /// Initializes a new instance of the <see cref="DicomImporterModule"/> class.
        /// </summary>
        /// <param name="regionManager">
        /// The region manager.
        /// </param>
        /// <param name="container">
        /// The container.
        /// </param>
        public DicomImporterModule(IRegionManager regionManager, IUnityContainer container)
        {
            this.regionManager = regionManager;
            this.container = container;
        }

        #endregion

        #region Public Methods

        /// <summary>
        /// The initialize.
        /// </summary>
        public void Initialize()
        {
            var fileMap = new ExeConfigurationFileMap { ExeConfigFilename = DicomImporterUnityConfigFile };
            Configuration config = ConfigurationManager.OpenMappedExeConfiguration(fileMap, ConfigurationUserLevel.None);
            var unitySection = (UnityConfigurationSection)config.GetSection("unity");
            this.container.LoadConfiguration(unitySection);
        }

        #endregion
    }
}