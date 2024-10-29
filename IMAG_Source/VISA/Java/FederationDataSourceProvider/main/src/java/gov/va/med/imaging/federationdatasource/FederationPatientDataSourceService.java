/**
 * 
  Package: MAG - VistA Imaging
  WARNING: Per VHA Directive 2004-038, this routine should not be modified.
  Date Created: Apr 11, 2008
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
package gov.va.med.imaging.federationdatasource;

import gov.va.med.HealthSummaryURN;
import gov.va.med.PatientIdentifier;
import gov.va.med.RoutingToken;
import gov.va.med.imaging.artifactsource.ResolvedArtifactSource;
import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.datasource.PatientDataSourceSpi;
import gov.va.med.imaging.datasource.exceptions.UnsupportedServiceMethodException;
import gov.va.med.imaging.exchange.business.HealthSummaryType;
import gov.va.med.imaging.exchange.business.Patient;
import gov.va.med.imaging.exchange.business.PatientMeansTestResult;
import gov.va.med.imaging.exchange.business.PatientPhotoID;
import gov.va.med.imaging.exchange.business.PatientPhotoIDInformation;
import gov.va.med.imaging.federation.proxy.FederationProxy;
import gov.va.med.imaging.federation.proxy.IFederationProxy;
import gov.va.med.imaging.federation.translator.FederationDatasourceTranslator;
import gov.va.med.imaging.proxy.services.ProxyServices;
import gov.va.med.imaging.transactioncontext.TransactionContextFactory;
import gov.va.med.imaging.url.federation.exceptions.FederationConnectionException;
import gov.va.med.imaging.url.federation.exceptions.FederationMethodException;
import gov.va.med.imaging.url.vftp.VftpConnection;

import java.io.IOException;
import java.util.List;
import java.util.SortedSet;

import javax.xml.rpc.ServiceException;

import gov.va.med.logging.Logger;

/**
 * @author VHAISWWERFEJ
 *
 */
public class FederationPatientDataSourceService 
extends AbstractFederationPatientDataSourceService 
{
	public final static String SUPPORTED_PROTOCOL = "vftp";
	
	private final static FederationDatasourceTranslator federationTranslator = new FederationDatasourceTranslator();
	private final static Logger LOGGER = Logger.getLogger(FederationPatientDataSourceService.class);
	
	// Versioning fields
	private final static String DATASOURCE_VERSION = "0";
	
	private final VftpConnection federationConnection;	
	private FederationProxy proxy;
	
	/**
	 * @param resolvedArtifactSource
	 * @param protocol
	 * @throws UnsupportedOperationException
	 */
	public FederationPatientDataSourceService(ResolvedArtifactSource resolvedArtifactSource, String protocol)
		throws UnsupportedOperationException
	{
		super(resolvedArtifactSource, protocol);
		federationConnection = new VftpConnection(getMetadataUrl());
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.federationdatasource.AbstractFederationPatientDataSourceService#getDataSourceVersion()
	 */
	@Override
	public String getDataSourceVersion() 
	{
		return DATASOURCE_VERSION;
	}
	
	@Override
	public SortedSet<Patient> findPatients(RoutingToken globalRoutingToken, String searchName)
	throws MethodException, ConnectionException 
	{
		// JMW 2/6/2012 - p122 - added sensitive status to result which is not part of v4 FederationPatient interface
		// make this method not used so the data source provider will fall back to using a non-Federation data source
		throw new UnsupportedServiceMethodException(PatientDataSourceSpi.class, "findPatients");
	}

	@Override
	public List<String> getTreatingSites(RoutingToken destinationRoutglobalRoutingTokeningToken, 
			PatientIdentifier patientIdentifier, boolean includeTrailingCharactersForSite200)
	throws MethodException, ConnectionException 
	{
        LOGGER.info("FederationPatientDataSourceService.getTreatingSites() --> For patient Id [{}], transaction identity [{}]", patientIdentifier, TransactionContextFactory.get().getDisplayIdentity());
		if(patientIdentifier.getPatientIdentifierType().isLocal())
			throw new MethodException("FederationPatientDataSourceService.getTreatingSites() --> Cannot use local patient identifier to retrieve remote patient information");
		try
		{
			federationConnection.connect();			
			String [] sites = getProxy().getPatientSitesVisited(getSite(), patientIdentifier.getValue());
            LOGGER.info("FederationPatientDataSourceService.getTreatingSites() --> Got [{}] sites from site number [{}]", sites == null ? 0 : sites.length, getSite().getSiteNumber());
			return federationTranslator.transformSiteNumbers(sites);		
		}
		catch(IOException ioX) 
		{
			String msg = "FederationPatientDataSourceService.getTreatingSites() --> Failed to connect OR cannot get treating sites: " + ioX.getMessage();
			LOGGER.error(msg);
			throw new FederationConnectionException(msg, ioX);
		}
		catch(ServiceException sX) 
		{
			String msg = "FederationPatientDataSourceService.getTreatingSites() --> Encountered ServiceException: " + sX.getMessage();
			LOGGER.error(msg);
			throw new FederationConnectionException(msg, sX);
		}
	}

	@Override	
	public boolean isVersionCompatible() 
	{
		return getFederationProxyServices() != null;
	}
	
	private FederationProxy getProxy()
	throws ConnectionException
	{		
		if(proxy == null)
		{
			ProxyServices proxyServices = getFederationProxyServices();
			if(proxyServices == null)
				throw new ConnectionException("FederationPatientDataSourceService.getProxy() --> Did not receive any applicable services from IDS service for site number [" + getSite().getSiteNumber() + "]");
			proxy = new FederationProxy(proxyServices, FederationDataSourceProvider.getFederationConfiguration());
		}
		return proxy;
	}

	@Override
	public boolean logPatientSensitiveAccess(RoutingToken globalRoutingToken,
			PatientIdentifier patientIdentifier) 
	throws MethodException, ConnectionException
	{
		throw new UnsupportedServiceMethodException(PatientDataSourceSpi.class, "logPatientSensitiveAccess");
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.federationdatasource.AbstractFederationPatientDataSourceService#getFederationProxy()
	 */
	@Override
	protected IFederationProxy getFederationProxy() 
	throws ConnectionException
	{
		return getProxy();
	}

	@Override
	public Patient getPatientInformation(RoutingToken globalRoutingToken,
			PatientIdentifier patientIdentifier) 
	throws MethodException, ConnectionException
	{
		throw new UnsupportedServiceMethodException(PatientDataSourceSpi.class, "getPatientInformation");
	}

	@Override
	public PatientMeansTestResult getPatientMeansTest(
			RoutingToken globalRoutingToken, PatientIdentifier patientIdentifier)
	throws MethodException, ConnectionException
	{
		throw new UnsupportedServiceMethodException(PatientDataSourceSpi.class, "getPatientMeansTest");
	}

	@Override
	public List<HealthSummaryType> getHealthSummaryTypes(
			RoutingToken globalRoutingToken) 
	throws MethodException, ConnectionException
	{
		throw new UnsupportedServiceMethodException(PatientDataSourceSpi.class, "getHealthSummaryTypes");
	}

	@Override
	public String getHealthSummary(HealthSummaryURN healthSummaryUrn,
			PatientIdentifier patientIdentifier) 
	throws MethodException, ConnectionException
	{
		throw new UnsupportedServiceMethodException(PatientDataSourceSpi.class, "getHealthSummary");
	}
}
