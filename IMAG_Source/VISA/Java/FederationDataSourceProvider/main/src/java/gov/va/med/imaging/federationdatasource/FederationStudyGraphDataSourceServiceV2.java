/**
 * 
  Package: MAG - VistA Imaging
  WARNING: Per VHA Directive 2004-038, this routine should not be modified.
  Date Created: May 4, 2009
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
package gov.va.med.imaging.federationdatasource;

import java.io.IOException;
import java.util.SortedSet;

import gov.va.med.logging.Logger;

import gov.va.med.PatientIdentifier;
import gov.va.med.RoutingToken;
import gov.va.med.imaging.artifactsource.ResolvedArtifactSource;
import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.exchange.business.Study;
import gov.va.med.imaging.exchange.business.StudyFilter;
import gov.va.med.imaging.exchange.business.StudySetResult;
import gov.va.med.imaging.exchange.enums.StudyLoadLevel;
import gov.va.med.imaging.federation.proxy.FederationProxyV2;
import gov.va.med.imaging.proxy.services.ProxyServices;
import gov.va.med.imaging.transactioncontext.TransactionContextFactory;
import gov.va.med.imaging.url.federation.exceptions.FederationConnectionException;
import gov.va.med.imaging.url.vftp.VftpConnection;

/**
 * @author vhaiswwerfej
 *
 */
public class FederationStudyGraphDataSourceServiceV2 
extends AbstractFederationStudyGraphDataSourceService 
{	
	private final VftpConnection federationConnection;
	
	private final static String DATASOURCE_VERSION = "2";
	public final static String SUPPORTED_PROTOCOL = "vftp";
	private FederationProxyV2 proxy;

	
	/**
	 * @param resolvedArtifactSource
	 * @param protocol
	 * @throws UnsupportedOperationException
	 */
	public FederationStudyGraphDataSourceServiceV2(ResolvedArtifactSource resolvedArtifactSource, String protocol)
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
	 * @see gov.va.med.imaging.datasource.StudyGraphDataSource#getPatientStudies(java.lang.String, gov.va.med.imaging.exchange.business.StudyFilter)
	 */
	@Override
	public StudySetResult getPatientStudies(RoutingToken globalRoutingToken, PatientIdentifier patientIdentifier, 
			StudyFilter filter, StudyLoadLevel studyLoadLevel) 
	throws MethodException, ConnectionException 
	{
        getLogger().info("FederationStudyGraphDataSourceServiceV2.getPatientStudies() --> For patient Id [{}], StudyLoadLevel [{}], transaction identity [{}]", patientIdentifier.toString(), studyLoadLevel, TransactionContextFactory.get().getDisplayIdentity());
		if(patientIdentifier.getPatientIdentifierType().isLocal())
			throw new MethodException("FederationStudyGraphDataSourceServiceV2.getPatientStudies() --> Cannot use local patient identifier to retrieve remote patient information");
		
		try 
		{
			federationConnection.connect();			
		}
		catch(IOException ioX) 
		{
			String msg = "FederationStudyGraphDataSourceServiceV2.getPatientStudies() --> Failed to connect: " + ioX.getMessage();
			getLogger().error(msg);
			throw new FederationConnectionException(msg, ioX);
		}
		
		if(filter != null)
		{
			if(filter.isStudyIenSpecified())
			{
                getLogger().info("FederationStudyGraphDataSourceServiceV2.getPatientStudies() --> Filtering study by study Id [{}]", filter.getStudyId());
			}
		}
		SortedSet<Study> studies = getProxy().getStudies(patientIdentifier.getValue(), filter, getSite().getSiteNumber(), studyLoadLevel);
        getLogger().info("FederationStudyGraphDataSourceServiceV2.getPatientStudies() --> Got [{}] studies from site number [{}]", studies == null ? 0 : studies.size(), getSite().getSiteNumber());
		return StudySetResult.createFullResult(studies);			
	}
	
	private FederationProxyV2 getProxy()
	throws ConnectionException
	{
		if(proxy == null)
		{
			ProxyServices proxyServices = getFederationProxyServices();
			if(proxyServices == null)
				throw new ConnectionException("FederationStudyGraphDataSourceServiceV2.getProxy() --> Did not receive any applicable services from IDS service for site number [" + getSite().getSiteNumber() + "]");
			proxy = new FederationProxyV2(proxyServices, FederationDataSourceProvider.getFederationConfiguration());
		}
		return proxy;
	}
}
