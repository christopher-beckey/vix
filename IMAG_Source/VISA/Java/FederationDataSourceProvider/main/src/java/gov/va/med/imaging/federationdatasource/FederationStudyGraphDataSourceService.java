/**
 * 
  Package: MAG - VistA Imaging
  WARNING: Per VHA Directive 2004-038, this routine should not be modified.
  Date Created: Mar 3, 2008
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

import java.io.IOException;

import javax.xml.rpc.ServiceException;

import gov.va.med.logging.Logger;

import gov.va.med.PatientIdentifier;
import gov.va.med.RoutingToken;
import gov.va.med.imaging.artifactsource.ResolvedArtifactSource;
import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.exchange.business.StudyFilter;
import gov.va.med.imaging.exchange.business.StudySetResult;
import gov.va.med.imaging.exchange.enums.StudyLoadLevel;
import gov.va.med.imaging.federation.proxy.FederationProxy;
import gov.va.med.imaging.federation.proxy.StudyResult;
import gov.va.med.imaging.federation.translator.FederationDatasourceTranslator;
import gov.va.med.imaging.proxy.exchange.StudyParameters;
import gov.va.med.imaging.proxy.services.ProxyServices;
import gov.va.med.imaging.transactioncontext.TransactionContextFactory;
import gov.va.med.imaging.url.federation.exceptions.FederationConnectionException;
import gov.va.med.imaging.url.federation.exceptions.FederationMethodException;
import gov.va.med.imaging.url.vftp.VftpConnection;

/**
 * @author VHAISWWERFEJ
 *
 */
public class FederationStudyGraphDataSourceService 
extends AbstractFederationStudyGraphDataSourceService
{
	private final VftpConnection federationConnection;
	private final static FederationDatasourceTranslator federationTranslator = new FederationDatasourceTranslator();
	private final static Logger LOGGER = Logger.getLogger(FederationStudyGraphDataSourceService.class);
	
	// Versioning fields
	
	private final static String DATASOURCE_VERSION = "0";
	public final static String SUPPORTED_PROTOCOL = "vftp";
	
	private FederationProxy proxy;

	/**
	 * @param resolvedArtifactSource
	 * @param protocol
	 * @throws UnsupportedOperationException
	 */
	public FederationStudyGraphDataSourceService(ResolvedArtifactSource resolvedArtifactSource, String protocol)
		throws UnsupportedOperationException
	{
		super(resolvedArtifactSource, protocol);
		federationConnection = new VftpConnection(getMetadataUrl());
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.federationdatasource.AbstractFederationStudyGraphDataSourceService#getDataSourceVersion()
	 */
	@Override
	public String getDataSourceVersion() 
	{
		return DATASOURCE_VERSION;
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.datasource.StudyGraphDataSourceSpi#getPatientStudies(java.lang.String, gov.va.med.imaging.exchange.business.StudyFilter)
	 */
	@Override
	public StudySetResult getPatientStudies(RoutingToken globalRoutingToken, PatientIdentifier patientIdentifier,
			StudyFilter filter, StudyLoadLevel studyLoadLevel) 
	throws UnsupportedOperationException, MethodException, ConnectionException 
	{
        LOGGER.info("FederationStudyGraphDataSourceService.getPatientStudies() --> For patient Id [{}], transaction Id [{}]", patientIdentifier.toString(), TransactionContextFactory.get().getDisplayIdentity());
		if(patientIdentifier.getPatientIdentifierType().isLocal())
			throw new MethodException("FederationStudyGraphDataSourceService.getPatientStudies() --> Cannot use local patient identifier to retrieve remote patient information");
		
		if(filter != null)
		{
			if(filter.isStudyIenSpecified())
			{
                LOGGER.info("FederationStudyGraphDataSourceService.getPatientStudies() --> Filtering study by study Id [{}]", filter.getStudyId());
			}
		}					

		try 
		{
			federationConnection.connect();			
			
			StudyParameters parameters = new StudyParameters(patientIdentifier.getValue(), filter.getFromDate(), filter.getToDate(), filter.getStudyId());			
			StudyResult studyResult = getProxy().getStudies(parameters, getSite().getSiteNumber());
			gov.va.med.imaging.federation.webservices.types.FederationStudyType[] federationStudies = studyResult.getStudies();
            LOGGER.info("FederationStudyGraphDataSourceService.getPatientStudies() --> Got [{}] study(ies) from site number [{}]", federationStudies == null ? 0 : federationStudies.length, getSite().getSiteNumber());
			return StudySetResult.createFullResult(federationTranslator.transformStudies(federationStudies, filter));	
		}
		catch(IOException ioX) 
		{
			String msg = "FederationStudyGraphDataSourceService.getPatientStudies() --> Failed to connect OR cannot get studies: " + ioX.getMessage();
			getLogger().error(msg);
			throw new FederationConnectionException(msg, ioX);
		}
		catch(ServiceException sX) 
		{
			String msg = "FederationStudyGraphDataSourceService.getPatientStudies() --> Encountered ServiceException: " + sX.getMessage();
			getLogger().error(msg);
			throw new FederationConnectionException(msg, sX);
		}
	}

	private FederationProxy getProxy()
	throws ConnectionException
	{
		if(proxy == null)
		{
			ProxyServices proxyServices = getFederationProxyServices();
			if(proxyServices == null)
				throw new ConnectionException("FederationStudyGraphDataSourceService.getProxy() --> Did not receive any applicable services from IDS service for site number [" + getSite().getSiteNumber() + "]");
			proxy = new FederationProxy(proxyServices, FederationDataSourceProvider.getFederationConfiguration());
		}
		return proxy;
	}

}
