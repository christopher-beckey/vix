/**
 * 
  Package: MAG - VistA Imaging
  WARNING: Per VHA Directive 2004-038, this routine should not be modified.
  Date Created: Jan 8, 2008
  Site Name:  Washington OI Field Office, Silver Spring, MD
  Developer:  VHAISWWERFEJ
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

import gov.va.med.GlobalArtifactIdentifier;
import gov.va.med.PatientIdentifier;
import gov.va.med.RoutingToken;
import gov.va.med.imaging.artifactsource.ResolvedArtifactSource;
import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.datasource.AbstractVersionableDataSource;
import gov.va.med.imaging.datasource.StudyGraphDataSourceSpi;
import gov.va.med.imaging.datasource.exceptions.UnsupportedProtocolException;
import gov.va.med.imaging.datasource.exceptions.UnsupportedServiceMethodException;
import gov.va.med.imaging.mix.proxy.MixDataSourceProxy;
import gov.va.med.imaging.exchange.business.*;
import gov.va.med.imaging.exchange.enums.StudyLoadLevel;
import gov.va.med.imaging.mix.proxy.v1.MixProxyUtilities;
import gov.va.med.imaging.mix.proxy.v1.ImageMixProxy;
import gov.va.med.imaging.mix.proxy.v1.ImageMixProxyFactory;
import gov.va.med.imaging.mix.proxy.v1.StudyResult;
import gov.va.med.imaging.mix.translator.MixTranslator;
import gov.va.med.imaging.proxy.exchange.StudyParameters;
import gov.va.med.imaging.transactioncontext.TransactionContextFactory;
// import gov.va.med.imaging.url.mix.MIXConnection;
import gov.va.med.imaging.url.mix.configuration.MIXSiteConfiguration;
import gov.va.med.imaging.url.mix.exceptions.MIXConfigurationException;
// import gov.va.med.imaging.url.mix.exceptions.MIXConnectionException;
import gov.va.med.imaging.url.mix.exceptions.MIXMethodException;
import gov.va.med.imaging.url.mixs.MIXsConnection;

import java.beans.XMLEncoder;
import java.io.BufferedOutputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.net.MalformedURLException;
import java.net.URL;
import java.util.Date;
import java.util.List;

import javax.xml.rpc.ServiceException;

import org.apache.commons.io.FilenameUtils;
import gov.va.med.logging.Logger;

/**
 * @author VHAISWWERFEJ
 *
 */
public class MixStudyGraphDataSourceService 
extends AbstractVersionableDataSource 
implements StudyGraphDataSourceSpi
{
	private final static Logger logger = Logger.getLogger(MixStudyGraphDataSourceService.class);
	
	private final MIXsConnection mixConnection;
	private ImageMixProxy proxy = null;
	protected static MixTranslator translator = new MixTranslator();
	private final static String MIX_PROXY_SERVICE_NAME = "MIX";
	private final static String DATASOURCE_VERSION = "1";
	private MIXSiteConfiguration mixConfiguration = null;
	public final static String SUPPORTED_PROTOCOL = "mix";
	
	/**
     * The Provider will use the create() factory method preferentially
     * over a constructor.  This allows for caching of VistaStudyGraphDataSourceService
     * instances according to the criteria set here.
     * 
     * @param url
     * @param site
     * @return
     * @throws ConnectionException
     * @throws UnsupportedProtocolException 
     */
    public static MixStudyGraphDataSourceService create(ResolvedArtifactSource resolvedArtifactSource, String protocol)
    throws ConnectionException, UnsupportedProtocolException
    {
    	return new MixStudyGraphDataSourceService(resolvedArtifactSource, protocol);
    }
	
	public MixStudyGraphDataSourceService(ResolvedArtifactSource resolvedArtifactSource, String protocol)
	throws UnsupportedProtocolException
	{
		super(resolvedArtifactSource, protocol);
		if(! (resolvedArtifactSource instanceof ResolvedSite) )
			throw new UnsupportedOperationException("The artifact source must be an instance of ResolvedSite and it is a '" + resolvedArtifactSource.getClass().getSimpleName() + "'.");
		
		mixConnection = new MIXsConnection(getMetadataUrl());
	}
	
	/**
	 * The artifact source must be checked in the constructor to assure that it is an instance
	 * of ResolvedSite.
	 * 
	 * @return
	 */
//	private ResolvedSite getResolvedSite()
//	{
//		return (ResolvedSite)getResolvedArtifactSource();
//	}
//	
	private  Site getMixSite()
	{
		Site site = null;
		try {
			site = new SiteImpl("200", "DOD", "DOD", null, 0, "", 8080, "200");
		} 
		catch (MalformedURLException mue)
		{
            logger.info("getMixSite exception: {}", mue.getMessage());
		}
		return site;
	}
	
	private Site getSite()
	{
		return getMixSite(); // getResolvedSite().getSite();
	}
	
	@Override
	public boolean isVersionCompatible() {
		MIXSiteConfiguration siteConfig = null;
		try
		{
			siteConfig = getMixSiteConfiguration();
		}
		catch(IOException ioX)
		{
			logger.error("Error reading configuration for datasource", ioX);
			return false;
		}
		// if versioning is turned on for this site configuration
		if(siteConfig.isUseVersioning())
		{
			MixProxyUtilities.isMixSiteServiceAvailable(getSite(), MIX_PROXY_SERVICE_NAME, DATASOURCE_VERSION);
		}
		return true;
	}

	private ImageMixProxy getProxy()
	throws IOException
	{
		if(proxy == null)
		{
			MIXSiteConfiguration mixSiteConfiguration = null;
			try 
			{
				mixSiteConfiguration = 
					MixDataSourceProvider.getMixConfiguration().getSiteConfiguration(getSite().getSiteNumber(), null);
			}
			catch(MIXConfigurationException ecX)
			{
				throw new IOException(ecX);
			}
			proxy = ImageMixProxyFactory.getSingleton().get(
					mixConnection.getURL().getHost(), 
					mixConnection.getURL().getPort(), 
					mixSiteConfiguration, null,
					MixDataSourceProvider.getMixConfiguration());
		}
		return proxy;
	}

	

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.datasource.StudyGraphDataSourceSpi#getUrl()
	 */
	public URL getUrl() {
		return mixConnection.getURL();
	}	

	@SuppressWarnings("boxing")
	@Override
	public StudySetResult getPatientStudies(RoutingToken globalRoutingToken, 
		PatientIdentifier patientIdentifier, 
		StudyFilter filter, 
		StudyLoadLevel studyLoadLevel)
	throws UnsupportedOperationException, MIXMethodException, ConnectionException 
	{
		MixDataSourceCommon.setDataSourceMethodAndVersion("getPatientStudies", DATASOURCE_VERSION);
        logger.info("getPatientStudies for patient ({}) TransactionContext ({}).", patientIdentifier, TransactionContextFactory.get().getDisplayIdentity());
		if(patientIdentifier.getPatientIdentifierType().isLocal())
			throw new MIXMethodException("Cannot use local patient identifier to retrieve remote patient information");
		String patientIcn = patientIdentifier.getValue();

		// validate protocol registration!
		try {
			new MixDataSourceProxy(MixDataSourceProvider.getMixConfiguration());
		} 
		catch (ConnectionException e)
		{
			if(logger.isDebugEnabled()){logger.debug(e.getMessage());}
			throw new MIXMethodException("Mix protocol registration failed: ", e);
		}

		// now get metadata for ICN and date range ((MIX Pass 1, level 1&2)

//		try 
//		{
//			mixConnection.connect();			
//		}
//		catch(IOException ioX) 
//		{
//			logger.error("Error getting patient studies", ioX);
//			throw new MIXConnectionException(ioX);
//		}
		try 
		{			
			StudyParameters parameters = 
				new StudyParameters(
					patientIcn, 
					filter == null ? new Date(0l) : filter.getFromDate(), 
					filter == null ? new Date() : filter.getToDate(), 
					filter == null ? null : filter.getStudyId()
				);			
			StudyResult studyResult = getProxy().getStudies(parameters);			
			gov.va.med.imaging.mix.webservices.rest.types.v1.ReportStudyListResponseType mixStudies = studyResult.getStudies();
            logger.info("getPatientStudies got [{}] studies from site [{}]", mixStudies == null ? "0" : "" + mixStudies.getStudies().length, getSite().getSiteNumber());
			if (mixStudies != null)
			{
				String dumpExchangeGraphs = System.getenv("dumpdodexchangegraphs");
				if (dumpExchangeGraphs != null && dumpExchangeGraphs.equalsIgnoreCase("true"))
				{
					dumpDodStudyGraph(patientIcn, mixStudies.getStudies());
				}
			}
			return StudySetResult.createFullResult(translator.transformStudies(getSite(), mixStudies.getStudies(), 
					filter, MixDataSourceProvider.getMixConfiguration().getEmptyStudyModalities()));	
		}
		catch(IOException ioX) 
		{
			logger.error("Error getting patient studies", ioX);
			throw new MIXMethodException(ioX);
		}
		catch(ServiceException sX) {
			logger.error("Error getting patient studies", sX);
			throw new MIXMethodException(sX);
		}
	}

	private void dumpDodStudyGraph(String patientIcn, gov.va.med.imaging.mix.webservices.rest.types.v1.StudyType[] exchangeStudies)
	{
		String vixcache = System.getenv("vixcache");
		
		if (vixcache != null)
		{
			// Fortify change: added try-with-resources and normalized paths
			try ( FileOutputStream outStream = new FileOutputStream(FilenameUtils.normalize(vixcache + "/dodexchange" + patientIcn + ".xml"));
				  BufferedOutputStream bufferOut = new BufferedOutputStream(outStream);
					XMLEncoder xmlEncoder = new XMLEncoder(bufferOut) )
			{
				xmlEncoder.writeObject(exchangeStudies);
			}
			catch (Exception ex)
			{
                logger.error("Error dumping study graph: {}", ex.getMessage());
			}
		}
	}
	
	private MIXSiteConfiguration getMixSiteConfiguration()
	throws IOException
	{
		if(mixConfiguration == null)
		{
			try 
			{
				mixConfiguration = 
					MixDataSourceProvider.getMixConfiguration().getSiteConfiguration(getSite().getSiteNumber(), null);
			}
			catch(MIXConfigurationException ecX)
			{
				throw new IOException(ecX);
			}
		}
		return mixConfiguration;
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.datasource.StudyGraphDataSourceSpi#getStudy(java.lang.String, gov.va.med.GlobalArtifactIdentifier)
	 */
	@Override
	public Study getStudy(PatientIdentifier patientIdentifier, GlobalArtifactIdentifier studyId) 
	throws MethodException, ConnectionException
	{
		throw new UnsupportedServiceMethodException(StudyGraphDataSourceSpi.class, "getStudy");
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.datasource.StudyGraphDataSourceSpi#getStudyReport(java.lang.String, gov.va.med.GlobalArtifactIdentifier)
	 */
	@Override
	public String getStudyReport(PatientIdentifier patientIdentifier, GlobalArtifactIdentifier studyId) 
	throws MethodException, ConnectionException
	{
		throw new UnsupportedServiceMethodException(StudyGraphDataSourceSpi.class, "getStudyReport");
	}

	@Override
	public List<StoredStudyFilter> getStoredFilters(RoutingToken globalRoutingToken)
			throws MethodException, ConnectionException {
		throw new UnsupportedServiceMethodException(StudyGraphDataSourceSpi.class, "getStoredFilters");
	}
	
}
