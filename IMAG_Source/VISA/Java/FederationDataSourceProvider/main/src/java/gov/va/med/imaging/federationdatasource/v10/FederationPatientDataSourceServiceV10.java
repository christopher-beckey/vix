/**
 * 
  Package: MAG - VistA Imaging
  WARNING: Per VHA Directive 2004-038, this routine should not be modified.
  Date Created: Aug 22, 2017
  Developer:  vhaisltjahjb
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
package gov.va.med.imaging.federationdatasource.v10;

import java.io.IOException;
import java.io.InputStream;

import gov.va.med.PatientIdentifier;
import gov.va.med.RoutingToken;
import gov.va.med.imaging.SizedInputStream;
import gov.va.med.imaging.artifactsource.ResolvedArtifactSource;
import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.exceptions.URNFormatException;
import gov.va.med.imaging.exchange.business.PatientPhotoIDInformation;
import gov.va.med.imaging.federation.proxy.FederationProxyUtilities;
import gov.va.med.imaging.federation.proxy.v10.FederationRestPatientProxyV10;
import gov.va.med.imaging.federationdatasource.v8.FederationPatientDataSourceServiceV8;
import gov.va.med.imaging.proxy.services.ProxyServices;
import gov.va.med.imaging.transactioncontext.TransactionContextFactory;
import gov.va.med.imaging.url.federation.exceptions.FederationConnectionException;

/**
 * @author vhaisltjahjb
 *
 */
public class FederationPatientDataSourceServiceV10
extends FederationPatientDataSourceServiceV8
{
	private final static String DATASOURCE_VERSION = "10";
	private ProxyServices federationProxyServices;
	private FederationRestPatientProxyV10 proxy;
	
	/**
	 * @param resolvedArtifactSource
	 * @param protocol
	 * @throws UnsupportedOperationException
	 */
	public FederationPatientDataSourceServiceV10(ResolvedArtifactSource resolvedArtifactSource, String protocol)
	throws UnsupportedOperationException
	{
		super(resolvedArtifactSource, protocol);
	}

	@Override
	protected FederationRestPatientProxyV10 getProxy()
	throws ConnectionException
	{
		if(proxy == null)
		{
			ProxyServices proxyServices = getCurrentFederationProxyServices();
			if(proxyServices == null)
				throw new ConnectionException("FederationPatientDataSourceServiceV10.getProxy() --> Did not receive any applicable services from IDS service for site number [" + getSite().getSiteNumber() + "]");
			proxy = new FederationRestPatientProxyV10(proxyServices, 
					getFederationConfiguration());
		}
		return proxy;
	}

	/**
	 * Returns the current version of proxy services, if none are available then null is returned
	 */
	private ProxyServices getCurrentFederationProxyServices()
	{
		if(federationProxyServices == null)
		{
			federationProxyServices = 
				FederationProxyUtilities.getCurrentFederationProxyServices(getSite(), 
						getFederationProxyName(), getDataSourceVersion());
		}
		return federationProxyServices;
	}

	@Override
	public String getDataSourceVersion() 
	{
		return DATASOURCE_VERSION;
	}
	
	@Override
	public InputStream getPatientIdentificationImage(
			RoutingToken globalRoutingToken, PatientIdentifier patientIdentifier) 
	throws MethodException,	ConnectionException
	{
        getLogger().info("FederationPatientDataSourceServiceV10.getPatientIdentificationImage() --> Transaction Id [{}]", TransactionContextFactory.get().getTransactionId());
		try 
		{
			federationConnection.connect();			
		}
		catch(IOException ioX) 
		{
			String msg = "FederationPatientDataSourceServiceV10.getPatientIdentificationImage() -->  Failed to connect: " + ioX.getMessage();
			getLogger().error(msg);
			throw new FederationConnectionException(msg, ioX);
		}

		SizedInputStream photoIdStream = getProxy().getPatientIdentifierImage(patientIdentifier.getValue(), globalRoutingToken.getRepositoryUniqueId());
		return photoIdStream.getInStream();
	}
	
	@Override
	public PatientPhotoIDInformation getPatientIdentificationImageInformation(RoutingToken globalRoutingToken, 
			PatientIdentifier patientIdentifier)
	throws MethodException, ConnectionException
	{
		//return getRemotePatientIdentificationImageInformation(globalRoutingToken, patientIdentifier);
        getLogger().info("FederationPatientDataSourceServiceV10.getPatientIdentificationImageInformation() --> Transaction Id [{}]", TransactionContextFactory.get().getTransactionId());
		try 
		{
			federationConnection.connect();			
		}
		catch(IOException ioX) 
		{
			String msg = "FederationPatientDataSourceServiceV10.getPatientIdentificationImageInformation() -->  Failed to connect: " + ioX.getMessage();
			getLogger().error(msg);
			throw new FederationConnectionException(msg, ioX);
		}

		try {
			return getProxy().getPatientIdentificationImageInformation(patientIdentifier.getValue(), globalRoutingToken);
		} catch (URNFormatException e) {
			throw new FederationConnectionException(e);
		}
	}
}
