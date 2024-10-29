/**
 * 
  Package: MAG - VistA Imaging
  WARNING: Per VHA Directive 2004-038, this routine should not be modified.
  Date Created: May 15, 2010
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
package gov.va.med.imaging.federationdatasource.v4;

import java.io.IOException;
import java.util.List;
import java.util.SortedSet;

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
import gov.va.med.imaging.exchange.business.PatientSensitiveValue;
import gov.va.med.imaging.exchange.business.ResolvedSite;
import gov.va.med.imaging.federation.proxy.IFederationProxy;
import gov.va.med.imaging.federation.proxy.v4.FederationRestPatientProxyV4;
import gov.va.med.imaging.federationdatasource.AbstractFederationPatientDataSourceService;
import gov.va.med.imaging.federationdatasource.FederationDataSourceProvider;
import gov.va.med.imaging.proxy.services.ProxyServiceType;
import gov.va.med.imaging.proxy.services.ProxyServices;
import gov.va.med.imaging.transactioncontext.TransactionContextFactory;
import gov.va.med.imaging.url.federation.exceptions.FederationConnectionException;
import gov.va.med.imaging.url.vftp.VftpConnection;

/**
 * @author vhaiswwerfej
 *
 */
public class FederationPatientDataSourceServiceV4 
extends AbstractFederationPatientDataSourceService 
{
	protected final VftpConnection federationConnection;
	
	private final static String DATASOURCE_VERSION = "4";
	private FederationRestPatientProxyV4 proxy;
	public final static String SUPPORTED_PROTOCOL = "vftp";

	/**
	 * @param resolvedArtifactSource
	 * @param protocol
	 * @throws UnsupportedOperationException
	 */
	public FederationPatientDataSourceServiceV4(ResolvedArtifactSource resolvedArtifactSource, String protocol)
	throws UnsupportedOperationException
	{
		super(resolvedArtifactSource, protocol);
		federationConnection = new VftpConnection(getMetadataUrl());

		if(! (resolvedArtifactSource instanceof ResolvedSite) )
			throw new UnsupportedOperationException("The artifact source must be an instance of ResolvedSite and it is a [" + resolvedArtifactSource.getClass().getSimpleName() + "]");
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
	public PatientSensitiveValue getPatientSensitivityLevel(RoutingToken globalRoutingToken, 
			PatientIdentifier patientIdentifier)
	throws MethodException, ConnectionException 
	{
        getLogger().info("FederationPatientDataSourceServiceV4.getPatientSensitivityLevel() --> For patient Id [{}], transaction Id [{}]", patientIdentifier, TransactionContextFactory.get().getTransactionId());
		verifyPatientIdentifierIsIcn(patientIdentifier);
		try 
		{
			federationConnection.connect();			
		}
		catch(IOException ioX) 
		{
			String msg = "FederationPatientDataSourceServiceV4.getPatientSensitivityLevel() --> Failed to connect: " + ioX.getMessage();
			getLogger().error(msg);
			throw new FederationConnectionException(msg, ioX);
		}
		return getProxy().getPatientSensitivityLevel(globalRoutingToken, patientIdentifier.getValue());
	}

	protected FederationRestPatientProxyV4 getProxy()
	throws ConnectionException
	{
		if(proxy == null)
		{
			ProxyServices proxyServices = getFederationProxyServices();
			if(proxyServices == null)
				throw new ConnectionException("FederationPatientDataSourceServiceV4.getProxy() --> Did not receive any applicable services from IDS service for site number [" + getSite().getSiteNumber() + "]");
			proxy = new FederationRestPatientProxyV4(proxyServices, 
					FederationDataSourceProvider.getFederationConfiguration());
		}
		return proxy;
	}

	@Override
	public List<String> getTreatingSites(RoutingToken globalRoutingToken, PatientIdentifier patientIdentifier, 
			boolean includeTrailingCharactersForSite200)
	throws MethodException, ConnectionException 
	{
        getLogger().info("FederationPatientDataSourceServiceV4.getTreatingSites() --> For patient Id [{}], transaction Id [{}]", patientIdentifier, TransactionContextFactory.get().getTransactionId());

		if(patientIdentifier.getPatientIdentifierType().isLocal())
			throw new MethodException("FederationPatientDataSourceServiceV4.getTreatingSites() --> Cannot use local patient identifier to retrieve remote patient information");
		
		try 
		{
			federationConnection.connect();
		}
		catch(IOException ioX)
		{
			String msg = "FederationPatientDataSourceServiceV4.getTreatingSites() --> Failed to connect: " + ioX.getMessage();
			getLogger().error(msg);
			throw new FederationConnectionException(msg, ioX);
		}
		return getProxy().getPatientSitesVisited(globalRoutingToken, patientIdentifier.getValue(), includeTrailingCharactersForSite200);
	}
	
	@Override
	public boolean isVersionCompatible()
	{
		if(getFederationProxyServices() == null)
			return false;
		
		ProxyServiceType serviceType = ProxyServiceType.metadata;
		String siteNumber = getSite().getSiteNumber();

		try
		{
            getLogger().debug("FederationPatientDataSourceServiceV4.isVersionCompatible() --> Found FederationProxyServices, looking for [{}] service type at site number [{}]", serviceType, siteNumber);
			getFederationProxyServices().getProxyService(serviceType);
            getLogger().debug("FederationPatientDataSourceServiceV4.isVersionCompatible() --> Found service type [{}] at site number [{}], returning true for version compatible.", serviceType, getSite().getSiteNumber());
			return true;
		}
		catch(gov.va.med.imaging.proxy.exceptions.ProxyServiceNotFoundException psnfX)
		{
            getLogger().warn("FederationPatientDataSourceServiceV4.isVersionCompatible() --> Cannot find proxy service type [{}] at site number [{}]", serviceType, getSite().getSiteNumber());
			return false;
		}
	}

	@Override
	public boolean logPatientSensitiveAccess(RoutingToken globalRoutingToken,
			PatientIdentifier patientIdentifier) 
	throws MethodException, ConnectionException
	{
        getLogger().info("FederationPatientDataSourceServiceV4.logPatientSensitiveAccess() --> For patient Id [{}], transaction Id [{}]", patientIdentifier, TransactionContextFactory.get().getTransactionId());
		verifyPatientIdentifierIsIcn(patientIdentifier);
		try 
		{
			federationConnection.connect();
		}
		catch(IOException ioX)
		{
			String msg = "FederationPatientDataSourceServiceV4.logPatientSensitiveAccess() --> Failed to connect: " + ioX.getMessage();
			getLogger().error(msg);
			throw new FederationConnectionException(msg, ioX);
		}
		return getProxy().logPatientSensitiveAccess(globalRoutingToken, patientIdentifier.getValue());
	}

	@Override
	public String getDataSourceVersion() 
	{
		return DATASOURCE_VERSION;
	}

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
