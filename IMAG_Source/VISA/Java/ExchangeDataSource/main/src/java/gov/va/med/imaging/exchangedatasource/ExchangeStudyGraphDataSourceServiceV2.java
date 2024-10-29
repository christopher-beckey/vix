/**
 * 
  Package: MAG - VistA Imaging
  WARNING: Per VHA Directive 2004-038, this routine should not be modified.
  Date Created: Sep 30, 2010
  Site Name:  Washington OI Field Office, Silver Spring, MD
  Developer:  vhaiswwerfej
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
import gov.va.med.imaging.artifactsource.ResolvedArtifactSource;
import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.core.interfaces.exceptions.SecurityException;
import gov.va.med.imaging.datasource.AbstractVersionableDataSource;
import gov.va.med.imaging.datasource.StudyGraphDataSourceSpi;
import gov.va.med.imaging.datasource.exceptions.UnsupportedProtocolException;
import gov.va.med.imaging.datasource.exceptions.UnsupportedServiceMethodException;
import gov.va.med.imaging.exchange.business.*;
import gov.va.med.imaging.exchange.enums.StudyLoadLevel;
import gov.va.med.imaging.exchange.proxy.v1.ExchangeProxyUtilities;
import gov.va.med.imaging.exchange.proxy.v2.ImageXChangeStudyProxyV2;
import gov.va.med.imaging.proxy.exceptions.ProxyServiceNotFoundException;
import gov.va.med.imaging.proxy.services.ProxyServiceType;
import gov.va.med.imaging.proxy.services.ProxyServices;
import gov.va.med.imaging.transactioncontext.TransactionContext;
import gov.va.med.imaging.transactioncontext.TransactionContextFactory;
import gov.va.med.imaging.url.exchange.ExchangeConnection;
import gov.va.med.imaging.url.exchange.configuration.ExchangeSiteConfiguration;
import gov.va.med.imaging.url.exchange.exceptions.ExchangeConfigurationException;
import gov.va.med.imaging.url.exchange.exceptions.ExchangeConnectionException;
import gov.va.med.imaging.url.exchange.exceptions.ExchangeMethodException;

import java.io.IOException;
import java.util.List;
import java.util.SortedSet;
import gov.va.med.logging.Logger;

/**
 * @author vhaiswwerfej
 *
 */
public class ExchangeStudyGraphDataSourceServiceV2
extends AbstractVersionableDataSource
implements StudyGraphDataSourceSpi
{
	private final static Logger LOGGER = Logger.getLogger(ExchangeStudyGraphDataSourceServiceV2.class);
	
	private final ExchangeConnection exchangeConnection;
	private ImageXChangeStudyProxyV2 proxy;
	
	private final static String EXCHANGE_PROXY_SERVICE_NAME = "Exchange";
	private final static String DATASOURCE_VERSION = "2";
	private ExchangeSiteConfiguration exchangeConfiguration;
	public final static String SUPPORTED_PROTOCOL = "exchange";
	private ProxyServices exchangeProxyServices;
	
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
    public static ExchangeStudyGraphDataSourceServiceV2 create(ResolvedArtifactSource resolvedArtifactSource, String protocol)
    throws ConnectionException, UnsupportedProtocolException
    {
    	return new ExchangeStudyGraphDataSourceServiceV2(resolvedArtifactSource, protocol);
    }
	
	public ExchangeStudyGraphDataSourceServiceV2(ResolvedArtifactSource resolvedArtifactSource, String protocol)
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

	@SuppressWarnings("boxing")
	@Override
	public StudySetResult getPatientStudies(RoutingToken globalRoutingToken, PatientIdentifier patientIdentifier,
			StudyFilter filter, StudyLoadLevel studyLoadLevel)
	throws MethodException, ConnectionException
	{
		// if the study load level is full, then also need to get the study reports for each study returned!
		ExchangeDataSourceCommon.setDataSourceMethodAndVersion("getPatientStudies", DATASOURCE_VERSION);

        LOGGER.info("ExchangeStudyGraphDataSourceServiceV2.getPatientStudies() --> Given for patient Id [{}], TransactionContext identify [{}]", patientIdentifier.getValue(), TransactionContextFactory.get().getDisplayIdentity());
		
		String patientIcn = patientIdentifier.getValue();

		if(patientIdentifier.getPatientIdentifierType().isLocal())
			throw new ExchangeMethodException("ExchangeStudyGraphDataSourceServiceV2.getPatientStudies() --> Cannot use local patient identifier [" + patientIcn + "] to retrieve remote patient information");
		
		try 
		{
			exchangeConnection.connect();			
		}
		catch(IOException ioX) 
		{
			String msg = "ExchangeStudyGraphDataSourceServiceV2.getPatientStudies() --> Couldn't connect to Exchange: " + ioX.getMessage();
			LOGGER.error(msg);
			throw new ExchangeConnectionException(msg, ioX);
		}
		
		StudySetResult studySetResult = getProxy().getPatientStudies(patientIcn, filter, studyLoadLevel);

        LOGGER.info("ExchangeStudyGraphDataSourceServiceV2.getPatientStudies() --> Got [{}] study(ies) from site [{}]", studySetResult == null ? "null" : (studySetResult.getArtifacts() == null ? "null studies" : studySetResult.getArtifacts().size()), getSite().getSiteNumber());
		
		// if the requestor wanted reports along with the studies, they are not already included so they need to be added 
		if(studyLoadLevel.isIncludeReport())
		{
			TransactionContext transactionContext = TransactionContextFactory.get();
			
			if(studySetResult != null)
			{
				SortedSet<Study> studies = studySetResult.getArtifacts();
				if(studies != null)
				{
					for(Study study : studies)
					{
						// if the study does not have the report, then need to get it
						if(!study.getStudyLoadLevel().isIncludeReport())
						{
							try
							{
								transactionContext.addDebugInformation("Getting report for study '" + study.getGlobalArtifactIdentifier().toString() + "'.");
								String report = getStudyReportInternal(patientIcn, 
										study.getGlobalArtifactIdentifier());
								// this will update the study load level
								study.setRadiologyReport(report);
							}
							catch(MethodException mX)
							{
                                LOGGER.warn("ExchangeStudyGraphDataSourceServiceV2.getPatientStudies() --> MethodException getting report for study [{}]: {}", study.getStudyUrn().toString(), mX.getMessage());
							}
							catch(ConnectionException cX)
							{
                                LOGGER.warn("ExchangeStudyGraphDataSourceServiceV2.getPatientStudies() --> ConnectionException getting report for study [{}]: {}", study.getStudyUrn().toString(), cX.getMessage());
							}
						}
					}
				}
			}
		}
		
		return studySetResult;
	}

	@Override
	public String getStudyReport(PatientIdentifier patientIdentifier,
			GlobalArtifactIdentifier studyId) 
	throws MethodException, ConnectionException
	{
		ExchangeDataSourceCommon.setDataSourceMethodAndVersion("getStudyReport", DATASOURCE_VERSION);
		String patientIcn = patientIdentifier.getValue();
		
		if(patientIdentifier.getPatientIdentifierType().isLocal())
			throw new MethodException("ExchangeStudyGraphDataSourceServiceV2.getStudyReport() --> Cannot use local patient identifier [" + patientIcn + "] to retrieve remote patient information");
		
		return getStudyReportInternal(patientIcn, studyId);
	}
	
	private String getStudyReportInternal(String patientIcn,
			GlobalArtifactIdentifier studyId) 
	throws MethodException, ConnectionException
	{
        LOGGER.info("ExchangeStudyGraphDataSourceServiceV2.getStudyReportInternal() --> For patient Id [{}], TransactionContext identity [{}]", patientIcn, TransactionContextFactory.get().getDisplayIdentity());
		
		try 
		{
			exchangeConnection.connect();			
		}
		catch(IOException ioX) 
		{
			String msg = "ExchangeStudyGraphDataSourceServiceV2.getPatientStudies() --> Couldn't connect to Exchange: " + ioX.getMessage();
			LOGGER.error(msg);
			throw new ExchangeConnectionException(msg, ioX);
		}
		
		return getProxy().getStudyReport(patientIcn, studyId);		
	}

	@Override
	public boolean isVersionCompatible() 
	throws SecurityException
	{
		ProxyServiceType serviceType = ProxyServiceType.metadata;
		String siteNumber = getSite().getSiteNumber();
		
		try
		{
			ProxyServices proxyServices = getExchangeProxyServices();	
			if(proxyServices == null)
			{
                LOGGER.warn("ExchangeStudyGraphDataSourceServiceV2.isVersionCompatible() --> Got null proxy services back, indicates site [{}] for version [" + DATASOURCE_VERSION + "] is not version compatible.", siteNumber);
				return false;
			}
			proxyServices.getProxyService(serviceType);
		}
		catch(IOException ioX)
		{
            LOGGER.error("ExchangeStudyGraphDataSourceServiceV2.isVersionCompatible() --> Error finding proxy services from site [{}]", siteNumber);
			return false;
		}
		catch(ProxyServiceNotFoundException psnfX)
		{
            LOGGER.warn("ExchangeStudyGraphDataSourceServiceV2.isVersionCompatible() --> Could not find proxy service type [{}] from site [{}]", serviceType, siteNumber);
		}
		
		return true;
	}
	
	protected ProxyServices getExchangeProxyServices()
	throws IOException
	{
		if(exchangeProxyServices == null)
		{
			exchangeProxyServices = 
				ExchangeProxyUtilities.getExchangeProxyServices(getExchangeSiteConfiguration(), getSite().getSiteNumber(), 
						EXCHANGE_PROXY_SERVICE_NAME, DATASOURCE_VERSION, exchangeConnection.getURL().getHost(), 
						exchangeConnection.getURL().getPort(), null);
		}
		return exchangeProxyServices;
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
				String msg = "ExchangeStudyGraphDataSourceServiceV2.getExchangeSiteConfiguration() --> Error reading configuration for datasource: " + ecX.getMessage(); 
				LOGGER.warn(msg);
				throw new IOException(msg, ecX);
			}
		}
		return exchangeConfiguration;
	}
	
	private ImageXChangeStudyProxyV2 getProxy()
	throws ConnectionException
	{
		if(proxy == null)
		{
			try
			{
				proxy = new ImageXChangeStudyProxyV2(getExchangeProxyServices(), getSite(), 
						ExchangeDataSourceProvider.getExchangeConfiguration());
			}
			catch(IOException ioX)
			{
				String msg = "ExchangeStudyGraphDataSourceServiceV2.getProxy() --> Error getting proxy: " + ioX.getMessage(); 
				LOGGER.warn(msg);
				throw new ConnectionException(ioX);
			}						
		}
		return proxy;
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.datasource.StudyGraphDataSourceSpi#getStudy(java.lang.String, gov.va.med.GlobalArtifactIdentifier)
	 */
	@Override
	public Study getStudy(PatientIdentifier patientIdentifier, GlobalArtifactIdentifier studyId) throws MethodException,
		ConnectionException
	{
		throw new UnsupportedServiceMethodException(StudyGraphDataSourceSpi.class, "getStudy");
	}

	@Override
	public List<StoredStudyFilter> getStoredFilters(RoutingToken globalRoutingToken)
	throws MethodException, ConnectionException {
		throw new UnsupportedServiceMethodException(StudyGraphDataSourceSpi.class, "getStoredFilters");
	}
}
