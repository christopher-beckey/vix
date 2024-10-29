/**
 * 
  Package: MAG - VistA Imaging
  WARNING: Per VHA Directive 2004-038, this routine should not be modified.
  Date Created: Jun 16, 2011
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
package gov.va.med.imaging.clinicaldisplay.webservices;

import gov.va.med.imaging.clinicaldisplay.webservices.commands.v7.ClinicalDisplayGetAnnotationsAvailableCommandV7;
import gov.va.med.imaging.clinicaldisplay.webservices.commands.v7.ClinicalDisplayGetImageAnnotationDetailsCommandV7;
import gov.va.med.imaging.clinicaldisplay.webservices.commands.v7.ClinicalDisplayGetImageAnnotationsCommandV7;
import gov.va.med.imaging.clinicaldisplay.webservices.commands.v7.ClinicalDisplayGetImageDevFieldsCommandV7;
import gov.va.med.imaging.clinicaldisplay.webservices.commands.v7.ClinicalDisplayGetImageInformationCommandV7;
import gov.va.med.imaging.clinicaldisplay.webservices.commands.v7.ClinicalDisplayGetImageSystemGlobalNodesCommandV7;
import gov.va.med.imaging.clinicaldisplay.webservices.commands.v7.ClinicalDisplayGetPatientSensitivityCommandV7;
import gov.va.med.imaging.clinicaldisplay.webservices.commands.v7.ClinicalDisplayGetPatientShallowStudyListCommandV7;
import gov.va.med.imaging.clinicaldisplay.webservices.commands.v7.ClinicalDisplayGetStudyImageListCommandV7;
import gov.va.med.imaging.clinicaldisplay.webservices.commands.v7.ClinicalDisplayGetStudyReportCommandV7;
import gov.va.med.imaging.clinicaldisplay.webservices.commands.v7.ClinicalDisplayGetUserInformationCommandV7;
import gov.va.med.imaging.clinicaldisplay.webservices.commands.v7.ClinicalDisplayPingServerCommandV7;
import gov.va.med.imaging.clinicaldisplay.webservices.commands.v7.ClinicalDisplayPostImageAccessEventCommandV7;
import gov.va.med.imaging.clinicaldisplay.webservices.commands.v7.ClinicalDisplayRemoteMethodPassthroughCommandV7;
import gov.va.med.imaging.clinicaldisplay.webservices.commands.v7.ClinicalDisplayStoreImageAnnotationDetailsCommandV7;

import java.math.BigInteger;
import java.rmi.RemoteException;

/**
 * @author VHAISWWERFEJ
 *
 */
public class ClinicalDisplayWebservices_v7
extends AbstractClinicalDisplayWebservices
implements gov.va.med.imaging.clinicaldisplay.webservices.soap.v7.ImageClinicalDisplayMetadata
{

	@Override
	public gov.va.med.imaging.clinicaldisplay.webservices.soap.v7.ShallowStudiesType getPatientShallowStudyList(String transactionId,
			String siteId, String patientId, 
			gov.va.med.imaging.clinicaldisplay.webservices.soap.v7.FilterType filter,
			gov.va.med.imaging.clinicaldisplay.webservices.soap.v7.UserCredentialsType credentials,
			BigInteger authorizedSensitivityLevel, boolean includeArtifacts)
	throws RemoteException
	{
		return new ClinicalDisplayGetPatientShallowStudyListCommandV7(transactionId, siteId, patientId,
				filter, credentials, authorizedSensitivityLevel,
				includeArtifacts).executeClinicalDisplayCommand();
	}

	@Override
	public gov.va.med.imaging.clinicaldisplay.webservices.soap.v7.FatImageType[] getStudyImageList(String transactionId,
			String studyId, 
			gov.va.med.imaging.clinicaldisplay.webservices.soap.v7.UserCredentialsType credentials,
			boolean includeDeletedImages) 
	throws RemoteException
	{
		return new ClinicalDisplayGetStudyImageListCommandV7(transactionId, 
				studyId, credentials, includeDeletedImages).executeClinicalDisplayCommand();
	}

	@Override
	public boolean postImageAccessEvent(String transactionId,
			gov.va.med.imaging.clinicaldisplay.webservices.soap.v7.ImageAccessLogEventType logEvent) 
	throws RemoteException
	{
		return new ClinicalDisplayPostImageAccessEventCommandV7(transactionId, 
				logEvent).executeClinicalDisplayCommand();
	}

	@Override
	public gov.va.med.imaging.clinicaldisplay.webservices.soap.v7.PingServerTypePingResponse pingServerEvent(String transactionId,
			String clientWorkstation, String requestSiteNumber,
			gov.va.med.imaging.clinicaldisplay.webservices.soap.v7.UserCredentialsType credentials) 
	throws RemoteException
	{
		return new ClinicalDisplayPingServerCommandV7(transactionId, clientWorkstation, 
				requestSiteNumber, credentials).executeClinicalDisplayCommand();
	}

	@Override
	public gov.va.med.imaging.clinicaldisplay.webservices.soap.v7.PrefetchResponseTypePrefetchResponse prefetchStudyList(
			String transactionId, String siteId, String patientId,
			gov.va.med.imaging.clinicaldisplay.webservices.soap.v7.FilterType filter, 
			gov.va.med.imaging.clinicaldisplay.webservices.soap.v7.UserCredentialsType credentials)
	throws RemoteException
	{
		return null;
	}

	@Override
	public String getImageInformation(String id, String transactionId,
			gov.va.med.imaging.clinicaldisplay.webservices.soap.v7.UserCredentialsType credentials, 
			boolean includeDeletedImages)
	throws RemoteException
	{
		return new ClinicalDisplayGetImageInformationCommandV7(id, 
				transactionId, credentials, includeDeletedImages).executeClinicalDisplayCommand();
	}

	@Override
	public String getImageSystemGlobalNode(String id, String transactionId,
			gov.va.med.imaging.clinicaldisplay.webservices.soap.v7.UserCredentialsType credentials) 
	throws RemoteException
	{
		return new ClinicalDisplayGetImageSystemGlobalNodesCommandV7(id, 
				transactionId, credentials).executeClinicalDisplayCommand();
	}

	@Override
	public String getImageDevFields(String id, String flags,
			String transactionId, 
			gov.va.med.imaging.clinicaldisplay.webservices.soap.v7.UserCredentialsType credentials)
	throws RemoteException
	{
		return new ClinicalDisplayGetImageDevFieldsCommandV7(id, 
				flags, transactionId, credentials).executeClinicalDisplayCommand();
	}

	@Override
	public gov.va.med.imaging.clinicaldisplay.webservices.soap.v7.PatientSensitiveCheckResponseType getPatientSensitivityLevel(
			String transactionId, String siteId, String patientId,
			gov.va.med.imaging.clinicaldisplay.webservices.soap.v7.UserCredentialsType credentials) 
	throws RemoteException
	{
		return new ClinicalDisplayGetPatientSensitivityCommandV7(transactionId, siteId, 
				patientId, credentials).executeClinicalDisplayCommand();
	}

	@Override
	public String getStudyReport(String transactionId,
			gov.va.med.imaging.clinicaldisplay.webservices.soap.v7.UserCredentialsType credentials, 
			String studyId)
	throws RemoteException
	{
		return new ClinicalDisplayGetStudyReportCommandV7(transactionId, 
				credentials, studyId).executeClinicalDisplayCommand();
	}

	@Override
	public String remoteMethodPassthrough(String transactionId,
			gov.va.med.imaging.clinicaldisplay.webservices.soap.v7.UserCredentialsType credentials, 
			String siteId, String methodName,
			gov.va.med.imaging.clinicaldisplay.webservices.soap.v7.RemoteMethodInputParameterType inputParameters)
	throws RemoteException
	{
		return new ClinicalDisplayRemoteMethodPassthroughCommandV7(transactionId, 
				credentials, siteId, methodName, inputParameters).executeClinicalDisplayCommand();
	}

	@Override
	public gov.va.med.imaging.clinicaldisplay.webservices.soap.v7.AnnotationType[] getImageAnnotations(String transactionId,
			gov.va.med.imaging.clinicaldisplay.webservices.soap.v7.UserCredentialsType credentials, 
			String imageId)
	throws RemoteException
	{
		return new ClinicalDisplayGetImageAnnotationsCommandV7(imageId, 
				transactionId, credentials).executeClinicalDisplayCommand();
	}

	@Override
	public gov.va.med.imaging.clinicaldisplay.webservices.soap.v7.AnnotationDetailsType getAnnotationDetails(String transactionId,
			gov.va.med.imaging.clinicaldisplay.webservices.soap.v7.UserCredentialsType credentials, 
			String imageId, String annotationId)
	throws RemoteException
	{
		return new ClinicalDisplayGetImageAnnotationDetailsCommandV7(imageId, annotationId, 
				transactionId, credentials).executeClinicalDisplayCommand();
	}

	@Override
	public gov.va.med.imaging.clinicaldisplay.webservices.soap.v7.AnnotationType postAnnotationDetails(String transactionId,
			gov.va.med.imaging.clinicaldisplay.webservices.soap.v7.UserCredentialsType credentials, 
			String imageId, String details, String version, String source) 
	throws RemoteException
	{
		return new ClinicalDisplayStoreImageAnnotationDetailsCommandV7(imageId, details, 
				version, source, transactionId, credentials).executeClinicalDisplayCommand();
	}

	@Override
	public gov.va.med.imaging.clinicaldisplay.webservices.soap.v7.UserType getUserDetails(String transactionId, 
			gov.va.med.imaging.clinicaldisplay.webservices.soap.v7.UserCredentialsType credentials,
			String siteId) 
	throws RemoteException
	{
		return new ClinicalDisplayGetUserInformationCommandV7(siteId, 
				transactionId, credentials).executeClinicalDisplayCommand();
	}

	@Override
	protected String getWepAppName()
	{
		return "Clinical Display WebApp V7";
	}

	@Override
	public boolean isAnnotationsSupported(String transactionId,
			gov.va.med.imaging.clinicaldisplay.webservices.soap.v7.UserCredentialsType credentials, 
			String siteId)
	throws RemoteException
	{
		return new ClinicalDisplayGetAnnotationsAvailableCommandV7(siteId, 
				transactionId, credentials).executeClinicalDisplayCommand();
	}

}
