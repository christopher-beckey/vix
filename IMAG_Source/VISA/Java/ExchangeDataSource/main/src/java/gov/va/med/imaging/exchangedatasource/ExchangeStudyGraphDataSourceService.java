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
package gov.va.med.imaging.exchangedatasource;

import gov.va.med.GlobalArtifactIdentifier;
import gov.va.med.PatientIdentifier;
import gov.va.med.RoutingToken;
import gov.va.med.imaging.StringUtil;
import gov.va.med.imaging.artifactsource.ResolvedArtifactSource;
import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodRemoteException;
import gov.va.med.imaging.datasource.AbstractVersionableDataSource;
import gov.va.med.imaging.datasource.StudyGraphDataSourceSpi;
import gov.va.med.imaging.datasource.exceptions.UnsupportedProtocolException;
import gov.va.med.imaging.datasource.exceptions.UnsupportedServiceMethodException;
import gov.va.med.imaging.exchange.business.*;
import gov.va.med.imaging.exchange.enums.StudyLoadLevel;
import gov.va.med.imaging.exchange.proxy.v1.ExchangeProxyUtilities;
import gov.va.med.imaging.exchange.proxy.v1.ImageXChangeProxy;
import gov.va.med.imaging.exchange.proxy.v1.ImageXChangeProxyFactory;
import gov.va.med.imaging.exchange.proxy.v1.StudyResult;
import gov.va.med.imaging.proxy.exchange.StudyParameters;
import gov.va.med.imaging.transactioncontext.TransactionContextFactory;
import gov.va.med.imaging.url.exchange.ExchangeConnection;
import gov.va.med.imaging.url.exchange.configuration.ExchangeSiteConfiguration;
import gov.va.med.imaging.url.exchange.exceptions.ExchangeConfigurationException;
import gov.va.med.imaging.url.exchange.exceptions.ExchangeConnectionException;
import gov.va.med.imaging.url.exchange.exceptions.ExchangeMethodException;
import gov.va.med.imaging.url.exchange.translator.ExchangeTranslator;
import java.beans.XMLEncoder;
import java.io.BufferedOutputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.net.URL;
import java.util.Date;
import java.util.List;

import javax.xml.rpc.ServiceException;
import gov.va.med.logging.Logger;

/**
 * @author VHAISWWERFEJ
 *
 */
public class ExchangeStudyGraphDataSourceService 
extends AbstractVersionableDataSource 
implements StudyGraphDataSourceSpi
{
	private final static Logger LOGGER = Logger.getLogger(ExchangeStudyGraphDataSourceService.class);
	
	private final ExchangeConnection exchangeConnection;
	private ImageXChangeProxy proxy;
	protected static ExchangeTranslator translator = new ExchangeTranslator();
	private final static String EXCHANGE_PROXY_SERVICE_NAME = "Exchange";
	private final static String DATASOURCE_VERSION = "1";
	private ExchangeSiteConfiguration exchangeConfiguration;
	public final static String SUPPORTED_PROTOCOL = "exchange";
	
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
    public static ExchangeStudyGraphDataSourceService create(ResolvedArtifactSource resolvedArtifactSource, String protocol)
    throws ConnectionException, UnsupportedProtocolException
    {
    	return new ExchangeStudyGraphDataSourceService(resolvedArtifactSource, protocol);
    }
	
	public ExchangeStudyGraphDataSourceService(ResolvedArtifactSource resolvedArtifactSource, String protocol)
	throws UnsupportedProtocolException
	{
		super(resolvedArtifactSource, protocol);
		if(! (resolvedArtifactSource instanceof ResolvedSite) )
			throw new UnsupportedOperationException("The artifact source must be an instance of ResolvedSite and it is a '" + resolvedArtifactSource.getClass().getSimpleName() + "'.");
		
		exchangeConnection = new ExchangeConnection(getMetadataUrl());
	}
	
	/**
	 * The artifact source must be checked in the constructor to assure that it is an instance
	 * of ResolvedSite.
	 * 
	 * @return
	 */
	private ResolvedSite getResolvedSite()
	{
		return (ResolvedSite)getResolvedArtifactSource();
	}
	
	private Site getSite()
	{
		return getResolvedSite().getSite();
	}
	
	@Override
	public boolean isVersionCompatible() {
		ExchangeSiteConfiguration siteConfig = null;
		try
		{
			siteConfig = getExchangeSiteConfiguration();
		}
		catch(IOException ioX)
		{
            LOGGER.warn("ExchangeStudyGraphDataSourceService.isVersionCompatible() --> Error reading configuration for datasource: {}", ioX.getMessage());
			return false;
		}
		// if versioning is turned on for this site configuration
		if(siteConfig.isUseVersioning())
		{
			ExchangeProxyUtilities.isExchangeSiteServiceAvailable(getSite(), EXCHANGE_PROXY_SERVICE_NAME, DATASOURCE_VERSION);
		}
		return true;
	}

	private ImageXChangeProxy getProxy()
	throws IOException
	{
		if(proxy == null)
		{
			ExchangeSiteConfiguration exchangeSiteConfiguration = null;
			try 
			{
				exchangeSiteConfiguration = 
					ExchangeDataSourceProvider.getExchangeConfiguration().getSiteConfiguration(getSite().getSiteNumber(), null);
			}
			catch(ExchangeConfigurationException ecX)
			{
				String msg = "ExchangeStudyGraphDataSourceService.getProxy() --> Error reading configuration for datasource: " + ecX.getMessage(); 
				LOGGER.warn(msg);
				throw new IOException(msg, ecX);
			}
			proxy = ImageXChangeProxyFactory.getSingleton().get(
					exchangeConnection.getURL().getHost(), 
					exchangeConnection.getURL().getPort(), 
					exchangeSiteConfiguration, null,
					ExchangeDataSourceProvider.getExchangeConfiguration());
		}
		return proxy;
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.datasource.StudyGraphDataSourceSpi#getUrl()
	 */
	public URL getUrl() {
		return exchangeConnection.getURL();
	}	

	@SuppressWarnings("boxing")
	@Override
	public StudySetResult getPatientStudies(RoutingToken globalRoutingToken, 
		PatientIdentifier patientIdentifier, 
		StudyFilter filter, 
		StudyLoadLevel studyLoadLevel)
	throws UnsupportedOperationException, ExchangeMethodException, ConnectionException 
	{
		ExchangeDataSourceCommon.setDataSourceMethodAndVersion("getPatientStudies", DATASOURCE_VERSION);
        LOGGER.info("ExchangeStudyGraphDataSourceService.getPatientStudies() --> Given for patient Id [{}], TransactionContext identify [{}]", patientIdentifier.getValue(), TransactionContextFactory.get().getDisplayIdentity());
		
		String patientIcn = patientIdentifier.getValue();
		
		if(patientIdentifier.getPatientIdentifierType().isLocal())
			throw new ExchangeMethodException("ExchangeStudyGraphDataSourceService.getPatientStudies() --> Cannot use local patient identifier [" + patientIcn + "] to retrieve remote patient information");
		
		try 
		{
			exchangeConnection.connect();			
		}
		catch(IOException ioX) 
		{
			String msg = "ExchangeStudyGraphDataSourceService.getPatientStudies() --> Couldn't connect to Exchange: " + ioX.getMessage();
			LOGGER.error(msg);
			throw new ExchangeConnectionException(msg, ioX);
		}
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
			gov.va.med.imaging.exchange.webservices.soap.types.v1.StudyType[] exchangeStudies = studyResult.getStudies();

            LOGGER.info("ExchangeStudyGraphDataSourceService.getPatientStudies() --> Got [{}] study(ies) from site [{}]", exchangeStudies == null ? "0" : exchangeStudies.length, getSite().getSiteNumber());
			
			if (exchangeStudies != null)
			{
				String dumpExchangeGraphs = System.getenv("dumpdodexchangegraphs");
				if (dumpExchangeGraphs != null && dumpExchangeGraphs.equalsIgnoreCase("true"))
				{
					dumpDodStudyGraph(patientIcn, exchangeStudies);
				}
			}
			return StudySetResult.createFullResult(translator.transformStudies(getSite(), exchangeStudies, 
					filter, ExchangeDataSourceProvider.getExchangeConfiguration().getEmptyStudyModalities()));	
		}
		catch(Exception sX) {
			String msg = "ExchangeStudyGraphDataSourceService.getPatientStudies() --> Couldn't get study(ies) for patient ICN [" + patientIcn + "]: " + sX.getMessage();
			LOGGER.error(msg);
			throw new ExchangeMethodException(msg, sX);
		}
	}

	private void dumpDodStudyGraph(String patientIcn, gov.va.med.imaging.exchange.webservices.soap.types.v1.StudyType[] exchangeStudies)
	{
		String vixcache = System.getenv("vixcache");
		
		if (vixcache != null)
		{
			// Fortify change: added clean string and moved here to enable try-with-resources
			String fileSpec = StringUtil.cleanString(vixcache + "/dodexchange" + patientIcn + ".xml");
			
			// Fortify change: added try-with-resources
			try ( FileOutputStream fileOut = new FileOutputStream(fileSpec); 
				  BufferedOutputStream bufferOut = new BufferedOutputStream(fileOut);
				  XMLEncoder xmlEncoder = new XMLEncoder(bufferOut) )
			{
				xmlEncoder.writeObject(exchangeStudies);
			}
			catch (Exception ex)
			{
                LOGGER.warn("ExchangeStudyGraphDataSourceService.dumpDodStudyGraph() --> Error dumping study graph: {}", ex.getMessage());
			}
		}
	}
	
	private ExchangeSiteConfiguration getExchangeSiteConfiguration()
	throws IOException
	{
		if(exchangeConfiguration == null)
		{
			try 
			{
				exchangeConfiguration = 
					ExchangeDataSourceProvider.getExchangeConfiguration().getSiteConfiguration(getSite().getSiteNumber(), null);
			}
			catch(ExchangeConfigurationException ecX)
			{
				String msg = "ExchangeStudyGraphDataSourceService.getExchangeSiteConfiguration() --> Error reading configuration for datasource: " + ecX.getMessage(); 
				LOGGER.warn(msg);
				throw new IOException(msg, ecX);
			}
		}
		return exchangeConfiguration;
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
