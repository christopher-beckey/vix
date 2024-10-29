/**
 * 
  Package: MAG - VistA Imaging
  WARNING: Per VHA Directive 2004-038, this routine should not be modified.
  Date Created: Sep 30, 2010
  Site Name:  Washington OI Field Office, Silver Spring, MD
  Developer:  vacotittoc
  Description: 

        ;; +--------------------------------------------------------------------+
        ;; Property of the US Government.
        ;; No permission to copy or redistribute this software is given.
        ;; Use of unreleased versions of this software requires the user
        ;;  to execute a written test agreement with the VistA Imaging
        ;;  Development Office of the Department of Veterans Affairs,
        ;;  telephone (301) 734-0100.
        ;;
        ;; The Food and Drug Administration classifies this software as
        ;; a Class II medical device.  As such, it may not be changed
        ;; in any way.  Modifications to this software may result in an
        ;; adulterated medical device under 21CFR820, the use of which
        ;; is considered to be a violation of US Federal Statutes.
        ;; +--------------------------------------------------------------------+

 */
package gov.va.med.imaging.mixdatasource;

import java.io.IOException;
import java.net.MalformedURLException;
import java.util.ArrayList;
import java.util.List;

import gov.va.med.logging.Logger;

import gov.va.med.GlobalArtifactIdentifier;
import gov.va.med.PatientIdentifier;
import gov.va.med.RoutingToken;
import gov.va.med.imaging.artifactsource.ResolvedArtifactSource;
import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.core.interfaces.exceptions.SecurityException;
import gov.va.med.imaging.datasource.AbstractVersionableDataSource;
import gov.va.med.imaging.datasource.StudyGraphDataSourceSpi;
import gov.va.med.imaging.datasource.exceptions.UnsupportedProtocolException;
import gov.va.med.imaging.datasource.exceptions.UnsupportedServiceMethodException;
import gov.va.med.imaging.dicom.ecia.scu.configuration.EciaDicomConfiguration;
import gov.va.med.imaging.dicom.ecia.scu.dto.StudyDTO;
import gov.va.med.imaging.dicom.ecia.scu.find.EciaFindSCU;
import gov.va.med.imaging.exchange.business.ResolvedSite;
import gov.va.med.imaging.exchange.business.Site;
import gov.va.med.imaging.exchange.business.SiteImpl;
import gov.va.med.imaging.exchange.business.StoredStudyFilter;
import gov.va.med.imaging.exchange.business.Study;
import gov.va.med.imaging.exchange.business.StudyFilter;
import gov.va.med.imaging.exchange.business.StudySetResult;
import gov.va.med.imaging.exchange.enums.StudyLoadLevel;
import gov.va.med.imaging.mix.proxy.MixDataSourceProxy;
import gov.va.med.imaging.mix.proxy.v1.ImageMixStudyProxyV1;
import gov.va.med.imaging.mix.proxy.v1.MixProxyUtilities;
import gov.va.med.imaging.proxy.exceptions.ProxyServiceNotFoundException;
import gov.va.med.imaging.proxy.services.ProxyServiceType;
import gov.va.med.imaging.proxy.services.ProxyServices;
import gov.va.med.imaging.transactioncontext.TransactionContextFactory;
import gov.va.med.imaging.url.mix.configuration.EciaDicomSiteConfiguration;
import gov.va.med.imaging.url.mix.configuration.MIXConfiguration;
import gov.va.med.imaging.url.mix.configuration.MIXSiteConfiguration;
import gov.va.med.imaging.url.mix.exceptions.MIXConfigurationException;
import gov.va.med.imaging.url.mix.exceptions.MIXMethodException;
import gov.va.med.imaging.url.mixs.MIXsConnection;

/**
 * @author vacotittoc
 *
 */
public class MixStudyGraphDataSourceServiceV1
extends AbstractVersionableDataSource
implements StudyGraphDataSourceSpi
{
	private final static Logger logger = Logger.getLogger(MixStudyGraphDataSourceServiceV1.class);
	
	private final static String MIX_PROXY_SERVICE_NAME = "MIX";
	private final static String DATASOURCE_VERSION = "1";
	public final static String SUPPORTED_PROTOCOL = "mix";

	private final MIXsConnection mixConnection;
	private MIXConfiguration mixConfiguration;
	private MIXSiteConfiguration mixSiteConfiguration = null;
	private ImageMixStudyProxyV1 proxy = null;
	private ProxyServices mixProxyServices = null;
	
	/**
     * The Provider will use the create() factory method preferentially
     * over a constructor.  This allows for caching of VistaStudyGraphDataSourceService
     * instances according to the criteria set here.
     * 
     * @param ResolvedArtifactSource				object to create from
     * @param String								protocol to create from
     * @return MixStudyGraphDataSourceServiceV1		created object
     * @throws ConnectionException					required exception
     * @throws UnsupportedProtocolException			required exception
     * 
     */
    public static MixStudyGraphDataSourceServiceV1 create(ResolvedArtifactSource resolvedArtifactSource, String protocol)
    throws ConnectionException, UnsupportedProtocolException
    {
    	return new MixStudyGraphDataSourceServiceV1(resolvedArtifactSource, protocol);
    }
	
    /**
     * Default constructor 
     * 
     * @param ResolvedArtifactSource				object to create from
     * @param String								protocol to create from
     * @return MixStudyGraphDataSourceServiceV1		created object
     * @throws UnsupportedProtocolException			required exception
     * 
     */
	public MixStudyGraphDataSourceServiceV1(ResolvedArtifactSource resolvedArtifactSource, String protocol)
	throws UnsupportedProtocolException
	{
		super(resolvedArtifactSource, protocol);
		if(! (resolvedArtifactSource instanceof ResolvedSite) )
			throw new UnsupportedOperationException("MixStudyGraphDataSourceServiceV1 constructor --> The artifact source must be an instance of ResolvedSite and it is a [" + resolvedArtifactSource.getClass().getSimpleName() + "].");
		
		mixConnection = new MIXsConnection(getMetadataUrl());
		mixConfiguration = MixDataSourceProvider.getMixConfiguration(); // load once for performance enhancement
	}
	
	/**
	 * Helper method to get/create Site object
	 * 
	 * @return Site		created Site object
	 * 
	 */
	private Site getSite()
	{
		try {
			return new SiteImpl("200", "DOD", "DOD", null, 0, "", 8080, "200");
		} 
		catch (MalformedURLException mue)
		{
			// Shouldn't fail but the SiteImpl class throws it for no apparent reason.
			// Leave it as is b/c SiteImpl is in a totally unrelated package.
            logger.error("getMixSite() --> exception: {}", mue.getMessage(), mue);
		}
		return null;
	}

	/**
	 * Update given filter's origin to get appropriate black list to filter by based on it
	 * 
	 * @param StudyFilter		Given filter to change
	 * 
	 */
	private void updateFilterOriginForBlacklist(StudyFilter filter) {
		
		if(logger.isDebugEnabled()){
            logger.debug("updateFilterOriginForBlacklist() --> Original filter [{}]", filter);}
		
		//if ((filter.getOrigin() != null) && (filter.getOrigin().length() != 0)) {
			// Do nothing; should be VistARad already
		
		// Quoc's change: we knew from the start that based on the thread name is iffy at best
		// and turns out to be wrong. Not iron-clad but based on the "identity" from the TransactionContext
		// seems a little less "iffy".
		/*} else if (Thread.currentThread().getName().contains("AsynchronousCommandExecutor")) {
			filter.setOrigin(MIXConfiguration.VIEWER_VIX);
		} else {
			filter.setOrigin(MIXConfiguration.VIEWER_CLINICAL_DISPLAY);
		}
		// Still ran into troubles for Vix Viewer with auth site other than 200.
		// Reworked below
		} else if (TransactionContextFactory.get().getDisplayIdentity().contains("O=VeteransAdministration")) {
			filter.setOrigin(MIXConfiguration.VIEWER_CLINICAL_DISPLAY);
		} else {
			filter.setOrigin(MIXConfiguration.VIEWER_VIX);
		}
		
		*/
			
		// origin: no need to check for null. Always empty or has a value.
		
		// there's a case that the origin that comes in has a value other than "VistARad" (not always empty)
		// Already set to VistA Rad = do nothing
		if(!filter.getOrigin().equals(MIXConfiguration.VIEWER_VISTA_RAD)) { // remains VistA Rad
			if(filter.getStudyId() == null) { // First query
				filter.setOrigin(TransactionContextFactory.get().getDisplayIdentity().startsWith("C") ? MIXConfiguration.VIEWER_CLINICAL_DISPLAY : MIXConfiguration.VIEWER_VIX);
			} else { // Second query: The StudyFilter objects are pretty much identical.  Have to rely on thread name to differentiate
				filter.setOrigin(Thread.currentThread().getName().startsWith("h") ?  MIXConfiguration.VIEWER_CLINICAL_DISPLAY : MIXConfiguration.VIEWER_VIX);
			}
		}

		if(logger.isDebugEnabled()){
            logger.debug("updateFilterOriginForBlacklist() --> Updated filter [{}]", filter);}
	}
	
	@SuppressWarnings("boxing")
	public StudySetResult getPatientStudies(RoutingToken globalRoutingToken, PatientIdentifier patientIdentifier,
			StudyFilter filter, StudyLoadLevel studyLoadLevel)
	throws MethodException, ConnectionException
	{
		// Update filter origin
		updateFilterOriginForBlacklist(filter);
		
		// if the study load level is full, then also need to get the study reports for each study returned!
		MixDataSourceCommon.setDataSourceMethodAndVersion("getPatientStudies()", DATASOURCE_VERSION);

        logger.info("getPatientStudies() --> for patient Id [{}] in TransactionContext [{}].", patientIdentifier, TransactionContextFactory.get().getDisplayIdentity());
		
		if(patientIdentifier.getPatientIdentifierType().isLocal())
			throw new MethodException("MixStudyGraphDataSourceServiceV1.getPatientStudies() --> Cannot use local patient id to retrieve remote patient information");
		
		String patientIcn = patientIdentifier.getValue();
		
		if(patientIcn == null || patientIcn.equals("")) {
			String msg = "MixStudyGraphDataSourceServiceV1.getPatientStudies() --> Invalid patient ICN -- > either null or empty. Can't proceed.";
			if(logger.isDebugEnabled()){logger.debug(msg);}
			throw new MIXMethodException(msg);
		}

		// validate protocol registration!  // Is this necessary???
		try {
			new MixDataSourceProxy(this.mixConfiguration);
		} 
		catch (ConnectionException ce)
		{
			logger.error(ce.getMessage(), ce);
			throw new MIXMethodException("MixStudyGraphDataSourceServiceV1.getPatientStudies() --> Mix protocol registration failed: ", ce);
		}

		// now get metadata for ICN and date range ((MIX Pass 1, level 1&2)

		// for MIX studyloadlevel must be FULL (MIX FHIR level 1 & 2)!!! -- that's taken care of directly on lower level (not using studyLoadLevel)
        logger.info("getPatientStudies() --> called from site [{}] for patient [{}] with studyloadlevel [{}] --> FULL is forced for MIX !!!", getSite().getSiteNumber(), patientIcn, studyLoadLevel.toString());

		// QN - Forced to "FULL" but not used in ImageMixStudyProxyV1 at all
		// hard-coded with StudyLoadLevel.STUDY_AND_IMAGES while creating = not caching 
		
		return getProxy().getPatientStudies(patientIcn, filter, StudyLoadLevel.FULL);	
	}
	
	// TODO MIX should not get here !!! but VistaRad calls it, so internally buffer data tree if needed and pick from there!!!
	public String getStudyReport(PatientIdentifier patientIdentifier,
			GlobalArtifactIdentifier studyId) throws MethodException, ConnectionException
	{
		// Determine if we need to hit ECIA directly or use the previous mechanism
		if (this.mixConfiguration.useEcia()) {
			if(logger.isDebugEnabled()){logger.debug("getStudyReport() --> Getting study report from ECIA");}
			return getStudyReportFromECIA(patientIdentifier.getValue(), studyId);
		} else {
			// Previous mechanism (non-ECIA) for fetching out data
			MixDataSourceCommon.setDataSourceMethodAndVersion("getStudyReport", DATASOURCE_VERSION);
			
			if(patientIdentifier.getPatientIdentifierType().isLocal())
				throw new MethodException("MixStudyGraphDataSourceServiceV1.getStudyReport() --> Cannot use local patient identifier to retrieve remote patient information");
			
			return getStudyReportInternal(patientIdentifier.getValue(), studyId);
		}
	}
	
	/**
	 * Returns a study report from ECIA provided the patient identifier (which may not really be used) and the study identifier
	 * 
	 * @param patientIcn The patient identifier
	 * @param studyId The study identifier we expect to find the report under
	 * @return The study report or "no study is available" in the event none could be located
	 * @throws MethodException In the event of any method invocation errors
	 * @throws ConnectionException In the event of any connectivity errors
	 */
	private String getStudyReportFromECIA(String patientIcn, GlobalArtifactIdentifier studyId) throws MethodException, ConnectionException
	{
		try {
			// Initialize the ECIA query class
			if(logger.isDebugEnabled()){logger.debug("getStudyReportFromECIA() --> Initializing EciaFindSCU");}
		
			// Load configuration for ECIA (could potentially cache this as a local field)
			EciaDicomSiteConfiguration eciaSiteConfig = (EciaDicomSiteConfiguration) this.mixConfiguration.getSiteConfiguration(MIXConfiguration.DEFAULT_ECIA_DICOM_SITE, MIXConfiguration.DEFAULT_ECIA_DICOM_SITE);
			EciaFindSCU eciaFindScu = new EciaFindSCU(new EciaDicomConfiguration(eciaSiteConfig.getHost(), eciaSiteConfig.getPort(), eciaSiteConfig.getCallingAE(), eciaSiteConfig.getCalledAE(), eciaSiteConfig.getConnectTimeOut(), eciaSiteConfig.getCfindRspTimeOut()));
		
			// Get the study UID string
			// QN 10/29/2020 - use studyUID instead of studyIdentifier b/c the latter is an object = avoid confusion
			String studyUID = studyId.getDocumentUniqueId().replaceAll("([^-]*)-.*", "$1");
			
			// Get the study object
			if(logger.isDebugEnabled()){
                logger.debug("getStudyReportFromECIA() --> Getting the study report for study UID [{}]", studyUID);}
			List<StudyDTO> studyDTOResults;
			try {
				studyDTOResults = eciaFindScu.getStudyByStudyUID(studyUID, null, MixDataSourceProvider.getMixConfiguration());
			} catch (Exception e) {
				logger.error(e.getMessage(), e);
				throw new ConnectionException(e.getMessage(), e);
			}
			
			// Handle no study being found
			if ((studyDTOResults == null) || (studyDTOResults.size() == 0)) {
				if(logger.isDebugEnabled()){
                    logger.debug("getStudyReportFromECIA() --> No study report found for sutdy UID [{}]", studyUID);}
				return "1^^\nNo study was found and no report is available"; 
			}
			
			// Fetch first entry
			StudyDTO studyDTO = studyDTOResults.get(0);
			
			// Return the report contents with carets (^) replaced
			String reportText = (studyDTO.getReportTextValue() == null) ? ("No study report is available") : (studyDTO.getReportTextValue());
			return "1^^\n" + reportText.replaceAll("\\^", ",");
		} catch (Exception e) {
			logger.error("getStudyReportFromECIA() --> Error retrieving studyreport", e);
			throw new ConnectionException("getStudyReportFromECIA() --> Error retrieving studyreport", e);
		}
	}
	
	private String getStudyReportInternal(String patientIcn, GlobalArtifactIdentifier studyId) throws MethodException, ConnectionException
	{
        logger.info("getStudyReportInternal() --> Getting study report for patient Id [{}] in TransactionContext [{}].", patientIcn, TransactionContextFactory.get().getDisplayIdentity());

		// validate protocol registration!
		try {
			new MixDataSourceProxy(this.mixConfiguration);
		} 
		catch (ConnectionException ce)
		{
			logger.error(ce.getMessage(), ce);
			throw new MIXMethodException(ce.getMessage(), ce);
		}
		
		return getProxy().getStudyReport(patientIcn, studyId);	// MIX should not get here but !!!
	}

	@Override
	public boolean isVersionCompatible() 
	throws SecurityException
	{
		ProxyServiceType serviceType = ProxyServiceType.metadata;
		try
		{
			ProxyServices proxyServices = getMixProxyServices();	
			if(proxyServices == null)
			{
                logger.warn("isVersionCompatible() --> Got null proxy services back, indicates site '{}' for version '" + DATASOURCE_VERSION + "' is not version compatible.", getSite().getSiteNumber());
				return false;
			}
			proxyServices.getProxyService(serviceType);
		}
		catch(IOException ioX)
		{
            logger.error("isVersionCompatible() --> Error finding proxy services from site '{}'.", getSite().getSiteNumber(), ioX);
			return false;
		}
		catch(ProxyServiceNotFoundException psnfX)
		{
            logger.error("isVersionCompatible() --> Could not find proxy service type [{}] from site [{}].", serviceType, getSite().getSiteNumber(), psnfX);
		}
		
		return true;
	}
	
	protected ProxyServices getMixProxyServices() throws IOException
	{
		if(mixProxyServices == null)
		{
			mixProxyServices = 
				MixProxyUtilities.getMixProxyServices(getMixSiteConfiguration(), getSite().getSiteNumber(), 
						MIX_PROXY_SERVICE_NAME, DATASOURCE_VERSION, mixConnection.getURL().getHost(), 
						mixConnection.getURL().getPort(), null);
		}
		return mixProxyServices;
	}
	
	private MIXSiteConfiguration getMixSiteConfiguration()	throws IOException
	{
		if(mixSiteConfiguration == null)
		{
			try 
			{
				mixSiteConfiguration = this.mixConfiguration.getSiteConfiguration(getSite().getSiteNumber(), null);
			}
			catch(MIXConfigurationException ecX)
			{
				throw new IOException(ecX);
			}
		}
		return mixSiteConfiguration;
	}
	
	private ImageMixStudyProxyV1 getProxy()	throws ConnectionException
	{
		if(proxy == null)
		{
			try
			{
				proxy = new ImageMixStudyProxyV1(getMixProxyServices(), getSite(), this.mixConfiguration);
			}
			catch(IOException ioX)
			{
				throw new ConnectionException(ioX);
			}						
		}
		return proxy;
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.datasource.StudyGraphDataSourceSpi#getStudy(java.lang.String, gov.va.med.GlobalArtifactIdentifier)
	 */
	public Study getStudy(PatientIdentifier patientIdentifier, GlobalArtifactIdentifier studyId) throws MethodException,
		ConnectionException
	{
		throw new UnsupportedServiceMethodException(StudyGraphDataSourceSpi.class, "getStudy");
	}

	public List<StoredStudyFilter> getStoredFilters(RoutingToken globalRoutingToken)
			throws MethodException, ConnectionException {
		//FIXME Implement method.
		// TODO Auto-generated method stub
		return null;
	}
	
}
