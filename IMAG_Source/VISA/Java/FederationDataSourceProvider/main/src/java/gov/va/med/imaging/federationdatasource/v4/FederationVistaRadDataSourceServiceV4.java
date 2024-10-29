/**
 * 
  Package: MAG - VistA Imaging
  WARNING: Per VHA Directive 2004-038, this routine should not be modified.
  Date Created: May 24, 2010
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

import gov.va.med.RoutingToken;
import gov.va.med.imaging.StudyURN;
import gov.va.med.imaging.artifactsource.ResolvedArtifactSource;
import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.exchange.business.vistarad.ActiveExams;
import gov.va.med.imaging.exchange.business.vistarad.Exam;
import gov.va.med.imaging.exchange.business.vistarad.ExamImages;
import gov.va.med.imaging.exchange.business.vistarad.ExamListResult;
import gov.va.med.imaging.exchange.business.vistarad.PatientRegistration;
import gov.va.med.imaging.federation.proxy.v4.FederationRestVistaRadProxyV4;
import gov.va.med.imaging.federationdatasource.AbstractFederationVistaRadDataSourceService;
import gov.va.med.imaging.federationdatasource.FederationDataSourceProvider;
import gov.va.med.imaging.proxy.exceptions.ProxyServiceNotFoundException;
import gov.va.med.imaging.proxy.services.ProxyServiceType;
import gov.va.med.imaging.proxy.services.ProxyServices;
import gov.va.med.imaging.transactioncontext.TransactionContextFactory;
import gov.va.med.imaging.url.federation.exceptions.FederationConnectionException;
import gov.va.med.imaging.url.vftp.VftpConnection;

/**
 * @author vhaiswwerfej
 *
 */
public class FederationVistaRadDataSourceServiceV4 
extends AbstractFederationVistaRadDataSourceService 
{
	private final static String DATASOURCE_VERSION = "4";
	
	private final VftpConnection federationConnection;
	private FederationRestVistaRadProxyV4 proxy;
	
	/**
	 * @param resolvedArtifactSource
	 * @param protocol
	 * @throws UnsupportedOperationException
	 */
	public FederationVistaRadDataSourceServiceV4(ResolvedArtifactSource resolvedArtifactSource, String protocol)
		throws UnsupportedOperationException
	{
		super(resolvedArtifactSource, protocol);
		federationConnection = new VftpConnection(getMetadataUrl());
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.federationdatasource.AbstractFederationVistaRadDataSourceService#getDataSourceVersion()
	 */
	@Override
	public String getDataSourceVersion() 
	{
		return DATASOURCE_VERSION;
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.datasource.VistaRadDataSource#getExam(gov.va.med.imaging.StudyURN)
	 */
	@Override
	public Exam getExam(StudyURN studyUrn) 
	throws MethodException, ConnectionException 
	{
        getLogger().info("FederationVistaRadDataSourceServiceV4.getExam() --> For StudyURN [{}], transaction identity [{}]", studyUrn.toString(), TransactionContextFactory.get().getDisplayIdentity());
		try 
		{
			federationConnection.connect();			
		}
		catch(IOException ioX) 
		{
			String msg = "FederationVistaRadDataSourceServiceV4.getExam() --> Failed to connect: " + ioX.getMessage();
			getLogger().error(msg);
			throw new FederationConnectionException(msg, ioX);
		}
		Exam result = getProxy().getExam(studyUrn);
        getLogger().info("FederationVistaRadDataSourceServiceV4.getExam() --> Got [{}] exam for StudyURN [{}]", result == null ? "null" : "not null", studyUrn.toString());
		return result;	
	}
	
	@Override
	public ActiveExams getActiveExams(RoutingToken globalRoutingToken, String listDescriptor)
	throws MethodException, ConnectionException 
	{
        getLogger().info("FederationVistaRadDataSourceServiceV4.getActiveExams() --> For list descriptor [{}], transaction Id [{}]", listDescriptor, TransactionContextFactory.get().getDisplayIdentity());
		try 
		{
			federationConnection.connect();			
		}
		catch(IOException ioX) 
		{
			String msg = "FederationVistaRadDataSourceServiceV4.getActiveExams() --> Failed to connect: " + ioX.getMessage();
			getLogger().error(msg);
			throw new FederationConnectionException(msg, ioX);
		}
		
		ActiveExams activeExams = getProxy().getActiveExams(globalRoutingToken, listDescriptor);
        getLogger().info("FederationVistaRadDataSourceServiceV4.getActiveExams() --> Got [{}] active exams from site number [{}]", activeExams == null ? 0 : activeExams.size(), getSite().getSiteNumber());
		return activeExams;			
	}
	
	/* (non-Javadoc)
	 * @see gov.va.med.imaging.datasource.VistaRadDataSource#getExamReport(gov.va.med.imaging.StudyURN)
	 */
	@Override
	public String getExamReport(StudyURN studyUrn) 
	throws MethodException, ConnectionException 
	{
        getLogger().info("FederationVistaRadDataSourceServiceV4.getExamReport() --> For StudyURN [{}], transaction identity [{}]", studyUrn.toString(), TransactionContextFactory.get().getDisplayIdentity());
		try 
		{
			federationConnection.connect();			
		}
		catch(IOException ioX) 
		{
			String msg = "FederationVistaRadDataSourceServiceV4.getExamReport() --> Failed to connect: " + ioX.getMessage();
			getLogger().error(msg);
			throw new FederationConnectionException(msg, ioX);
		}
		String report = getProxy().getExamRadiologyReport(studyUrn);
		TransactionContextFactory.get().setDataSourceBytesReceived(report == null ? 0L : report.length());
		return report;
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.datasource.VistaRadDataSource#getExamRequisitionReport(gov.va.med.imaging.StudyURN)
	 */
	@Override
	public String getExamRequisitionReport(StudyURN studyUrn)
	throws MethodException, ConnectionException 
	{
        getLogger().info("FederationVistaRadDataSourceServiceV4.getExamRequisitionReport() --> For StudyURN [{}], transaction identity [{}]", studyUrn.toString(), TransactionContextFactory.get().getDisplayIdentity());
		try 
		{
			federationConnection.connect();			
		}
		catch(IOException ioX) 
		{
			String msg = "FederationVistaRadDataSourceServiceV4.getExamRequisitionReport() --> Failed to connect: " + ioX.getMessage();
			getLogger().error(msg);
			throw new FederationConnectionException(msg, ioX);
		}
		String report = getProxy().getExamRequisitionReport(studyUrn);
		TransactionContextFactory.get().setDataSourceBytesReceived(report == null ? 0L : report.length());
		return report;
	}
	
	protected FederationRestVistaRadProxyV4 getProxy()
	throws ConnectionException
	{
		if(proxy == null)
		{
			ProxyServices proxyServices = getFederationProxyServices();
			if(proxyServices == null)
				throw new ConnectionException("FederationVistaRadDataSourceServiceV4.getProxy() --> Did not receive any applicable services from IDS service for site [" + getSite().getSiteNumber() + "]");
			proxy = new FederationRestVistaRadProxyV4(proxyServices, FederationDataSourceProvider.getFederationConfiguration());
		}
		return proxy;
	}
	
	/* (non-Javadoc)
	 * @see gov.va.med.imaging.datasource.StudyGraphDataSource#isVersionCompatible()
	 */
	@Override
	public boolean isVersionCompatible() 
	{
		if(getFederationProxyServices() == null)
			return false;
		
		ProxyServiceType serviceType = ProxyServiceType.vistaRadMetadata;
		String siteNumber = getSite().getSiteNumber();

		try
		{
            getLogger().debug("FederationVistaRadDataSourceServiceV4.isVersionCompatible() --> Found FederationProxyServices, looking for [{}] service type at site number [{}]", serviceType, siteNumber);
			getFederationProxyServices().getProxyService(serviceType);
            getLogger().debug("FederationVistaRadDataSourceServiceV4.isVersionCompatible() --> Found service type [{}] at site number [{}], returning true for version compatible.", serviceType, siteNumber);
			return true;
		}
		catch(ProxyServiceNotFoundException psnfX)
		{
            getLogger().warn("FederationVistaRadDataSourceServiceV4.isVersionCompatible() --> Cannot find proxy service type [{}] at site number [{}]", serviceType, siteNumber);
			return false;
		}
	}
	
	/* (non-Javadoc)
	 * @see gov.va.med.imaging.datasource.VistaRadDataSource#getExamsForPatient(java.lang.String, boolean)
	 */
	@Override
	public ExamListResult getExamsForPatient(RoutingToken globalRoutingToken, String patientICN,
			boolean fullyLoadExams, boolean forceRefresh, boolean forceImagesFromJb) 
	throws MethodException, ConnectionException 
	{
        getLogger().info("FederationVistaRadDataSourceServiceV4.getExamsForPatient() --> For patient Id [{}], transaction identity [{}]", patientICN, TransactionContextFactory.get().getDisplayIdentity());
		try 
		{
			federationConnection.connect();			
		}
		catch(IOException ioX) 
		{
			String msg = "FederationVistaRadDataSourceServiceV4.getExamsForPatient() --> Failed to connect: " + ioX.getMessage();
			getLogger().error(msg);
			throw new FederationConnectionException(msg, ioX);
		}
		
		ExamListResult result = getProxy().getExamsForPatient(globalRoutingToken, patientICN, fullyLoadExams, forceRefresh, forceImagesFromJb);
        getLogger().info("FederationVistaRadDataSourceServiceV4.getExamsForPatient() --> Got [{}] patient exams from site number [{}]", result == null ? "null" : "not null", getSite().getSiteNumber());
		return result;		
	}
	
	/* (non-Javadoc)
	 * @see gov.va.med.imaging.datasource.VistaRadDataSource#postExamAccessEvent(java.lang.String)
	 */
	@Override
	public boolean postExamAccessEvent(RoutingToken globalRoutingToken, String inputParameter)
	throws MethodException, ConnectionException 
	{
        getLogger().info("FederationVistaRadDataSourceServiceV4.postExamAccessEvent() --> For input [{}], transaction identity [{}]", inputParameter, TransactionContextFactory.get().getDisplayIdentity());
		try 
		{
			federationConnection.connect();			
		}
		catch(IOException ioX) 
		{
			String msg = "FederationVistaRadDataSourceServiceV4.postExamAccessEvent() --> Failed to connect: " + ioX.getMessage();
			getLogger().error(msg);
			throw new FederationConnectionException(msg, ioX);
		}
		boolean result = getProxy().postExamAccess(globalRoutingToken, inputParameter);
        getLogger().info("FederationVistaRadDataSourceServiceV3.postExamAccessEvent() --> Got [{}] from site number [{}]", result, getSite().getSiteNumber());
		return result;	
	}
	
	/* (non-Javadoc)
	 * @see gov.va.med.imaging.datasource.VistaRadDataSource#getRelevantPriorCptCodes(java.lang.String)
	 */
	@Override
	public String[] getRelevantPriorCptCodes(RoutingToken globalRoutingToken, String cptCode)
	throws MethodException, ConnectionException 
	{
        getLogger().info("FederationVistaRadDataSourceServiceV4.getRelevantPriorCptCodes() --> For CPT Code [{}], transaction identity [{}]", cptCode, TransactionContextFactory.get().getDisplayIdentity());

		try 
		{
			federationConnection.connect();			
		}
		catch(IOException ioX) 
		{
			String msg = "FederationVistaRadDataSourceServiceV4.getRelevantPriorCptCodes() --> Failed to connect: " + ioX.getMessage();
			getLogger().error(msg);
			throw new FederationConnectionException(msg, ioX);
		}
		String [] result = getProxy().getRelevantPriorCptCodes(globalRoutingToken, cptCode);
        getLogger().info("FederationVistaRadDataSourceServiceV3.getRelevantPriorCptCodes() --> Got [{}] relevant CPT codes from site number [{}]", result == null ? 0 : result.length, getSite().getSiteNumber());
		return result;	
	}
	
	/* (non-Javadoc)
	 * @see gov.va.med.imaging.datasource.VistaRadDataSource#getNextPatientRegistration()
	 */
	@Override
	public PatientRegistration getNextPatientRegistration(RoutingToken globalRoutingToken)
	throws MethodException, ConnectionException 
	{
        getLogger().info("FederationVistaRadDataSourceServiceV4.getNextPatientRegistration() --> Transaction identity [{}]", TransactionContextFactory.get().getDisplayIdentity());
		
		try 
		{
			federationConnection.connect();			
		}
		catch(IOException ioX) 
		{
			String msg = "FederationVistaRadDataSourceServiceV4.getExamsForPatient() --> Failed to connect: " + ioX.getMessage();
			getLogger().error(msg);
			throw new FederationConnectionException(msg, ioX);
		}
		
		PatientRegistration patientRegistration = getProxy().getNextPatientRegistration(globalRoutingToken);
        getLogger().info("FederationVistaRadDataSourceServiceV4.getNextPatientRegistration() --> Got [{}] patient registration from site number [{}]", patientRegistration == null ? "null" : "not null", getSite().getSiteNumber());
		return patientRegistration;	
	}
	
	/* (non-Javadoc)
	 * @see gov.va.med.imaging.datasource.VistaRadDataSource#getExamImagesForExam(gov.va.med.imaging.StudyURN)
	 */
	@Override
	public ExamImages getExamImagesForExam(StudyURN studyUrn)
	throws MethodException, ConnectionException 
	{
        getLogger().info("FederationVistaRadDataSourceServiceV4.getExamImagesForExam() --> For StudyURN [{}], transaction identity [{}]", studyUrn.toString(), TransactionContextFactory.get().getDisplayIdentity());
		try 
		{
			federationConnection.connect();			
		}
		catch(IOException ioX) 
		{
			String msg = "FederationVistaRadDataSourceServiceV4.getExamImagesForExam() --> Failed to connect: " + ioX.getMessage();
			getLogger().error(msg);
			throw new FederationConnectionException(msg, ioX);
		}
		ExamImages images = getProxy().getExamImagesForExam(studyUrn);
        getLogger().info("FederationVistaRadDataSourceServiceV4.getExamImagesForExam() --> Ggot [{}] exam images from site number [{}]", images == null ? 0 : images.size(), getSite().getSiteNumber());
		return images;		
	}
}
