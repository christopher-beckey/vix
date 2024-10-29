/**
 * 
  Package: MAG - VistA Imaging
  WARNING: Per VHA Directive 2004-038, this routine should not be modified.
  Date Created: Aug 6, 2010
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
package gov.va.med.imaging.clinicaldisplay.webservices;

import gov.va.med.imaging.clinicaldisplay.webservices.commands.v6.ClinicalDisplayGetImageDevFieldsCommandV6;
import gov.va.med.imaging.clinicaldisplay.webservices.commands.v6.ClinicalDisplayGetImageInformationCommandV6;
import gov.va.med.imaging.clinicaldisplay.webservices.commands.v6.ClinicalDisplayGetImageSystemGlobalNodesCommandV6;
import gov.va.med.imaging.clinicaldisplay.webservices.commands.v6.ClinicalDisplayGetPatientSensitivityCommandV6;
import gov.va.med.imaging.clinicaldisplay.webservices.commands.v6.ClinicalDisplayGetPatientShallowStudyListCommandV6;
import gov.va.med.imaging.clinicaldisplay.webservices.commands.v6.ClinicalDisplayGetStudyImageListCommandV6;
import gov.va.med.imaging.clinicaldisplay.webservices.commands.v6.ClinicalDisplayGetStudyReportCommandV6;
import gov.va.med.imaging.clinicaldisplay.webservices.commands.v6.ClinicalDisplayPingServerCommandV6;
import gov.va.med.imaging.clinicaldisplay.webservices.commands.v6.ClinicalDisplayPostImageAccessEventCommandV6;
import gov.va.med.imaging.clinicaldisplay.webservices.commands.v6.ClinicalDisplayRemoteMethodPassthroughCommandV6;
import gov.va.med.imaging.clinicaldisplay.webservices.soap.v6.UserCredentialsType;

import java.math.BigInteger;
import java.rmi.RemoteException;

/**
 * @author vhaiswwerfej
 *
 */
public class ClinicalDisplayWebservices_v6
extends AbstractClinicalDisplayWebservices
implements gov.va.med.imaging.clinicaldisplay.webservices.soap.v6.ImageClinicalDisplayMetadata
{

	@Override
	protected String getWepAppName()
	{
		return "Clinical Display WebApp V6";
	}

	@Override
	public String getImageDevFields(String id, String flags,
			String transactionId, 
			gov.va.med.imaging.clinicaldisplay.webservices.soap.v6.UserCredentialsType credentials)
	throws RemoteException
	{
		return new ClinicalDisplayGetImageDevFieldsCommandV6(id, flags, transactionId, 
				credentials).executeClinicalDisplayCommand();
	}

	@Override
	public String getImageInformation(String id, String transactionId,
			UserCredentialsType credentials, boolean includeDeletedImages)
			throws RemoteException
	{
		return new ClinicalDisplayGetImageInformationCommandV6(id, transactionId, 
				credentials, includeDeletedImages).executeClinicalDisplayCommand();
	}

	@Override
	public String getImageSystemGlobalNode(String id, String transactionId,
			gov.va.med.imaging.clinicaldisplay.webservices.soap.v6.UserCredentialsType credentials) 
	throws RemoteException
	{
		return new ClinicalDisplayGetImageSystemGlobalNodesCommandV6(id, transactionId, 
				credentials).executeClinicalDisplayCommand();
	}

	@Override
	public gov.va.med.imaging.clinicaldisplay.webservices.soap.v6.PatientSensitiveCheckResponseType getPatientSensitivityLevel(
			String transactionId, String siteId, String patientId,
			gov.va.med.imaging.clinicaldisplay.webservices.soap.v6.UserCredentialsType credentials) 
	throws RemoteException
	{
		return new ClinicalDisplayGetPatientSensitivityCommandV6(transactionId, siteId, 
				patientId, credentials).executeClinicalDisplayCommand();
	}

	@Override
	public gov.va.med.imaging.clinicaldisplay.webservices.soap.v6.ShallowStudiesType getPatientShallowStudyList(String transactionId,
			String siteId, String patientId, 
			gov.va.med.imaging.clinicaldisplay.webservices.soap.v6.FilterType filter,
			gov.va.med.imaging.clinicaldisplay.webservices.soap.v6.UserCredentialsType credentials,
			BigInteger authorizedSensitivityLevel, boolean includeArtifacts)
	throws RemoteException
	{
		return new ClinicalDisplayGetPatientShallowStudyListCommandV6(transactionId, siteId, patientId,
				filter, credentials, authorizedSensitivityLevel,
				includeArtifacts).executeClinicalDisplayCommand();
	}

	@Override
	public gov.va.med.imaging.clinicaldisplay.webservices.soap.v6.FatImageType[] getStudyImageList(String transactionId,
			String studyId, 
			gov.va.med.imaging.clinicaldisplay.webservices.soap.v6.UserCredentialsType credentials,
			boolean includeDeletedImages) 
	throws RemoteException
	{
		return new ClinicalDisplayGetStudyImageListCommandV6(transactionId, studyId, 
				credentials, includeDeletedImages).executeClinicalDisplayCommand();
	}

	@Override
	public String getStudyReport(String transactionId,
			gov.va.med.imaging.clinicaldisplay.webservices.soap.v6.UserCredentialsType credentials, String studyId)
	throws RemoteException
	{
		return new ClinicalDisplayGetStudyReportCommandV6(transactionId, credentials, 
				studyId).executeClinicalDisplayCommand();
	}

	@Override
	public gov.va.med.imaging.clinicaldisplay.webservices.soap.v6.PingServerTypePingResponse pingServerEvent(String transactionId,
			String clientWorkstation, String requestSiteNumber,
			gov.va.med.imaging.clinicaldisplay.webservices.soap.v6.UserCredentialsType credentials) 
	throws RemoteException
	{
		return new ClinicalDisplayPingServerCommandV6(transactionId, clientWorkstation, 
				requestSiteNumber, credentials).executeClinicalDisplayCommand();
	}

	@Override
	public boolean postImageAccessEvent(String transactionId,
			gov.va.med.imaging.clinicaldisplay.webservices.soap.v6.ImageAccessLogEventType logEvent) 
	throws RemoteException
	{
		return new ClinicalDisplayPostImageAccessEventCommandV6(transactionId, logEvent).executeClinicalDisplayCommand();
	}

	@Override
	public gov.va.med.imaging.clinicaldisplay.webservices.soap.v6.PrefetchResponseTypePrefetchResponse prefetchStudyList(
			String transactionId, String siteId, String patientId,
			gov.va.med.imaging.clinicaldisplay.webservices.soap.v6.FilterType filter, 
			gov.va.med.imaging.clinicaldisplay.webservices.soap.v6.UserCredentialsType credentials)
	throws RemoteException
	{
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public String remoteMethodPassthrough(String transactionId,
			gov.va.med.imaging.clinicaldisplay.webservices.soap.v6.UserCredentialsType credentials, 
			String siteId, String methodName,
			gov.va.med.imaging.clinicaldisplay.webservices.soap.v6.RemoteMethodInputParameterType inputParameters)
	throws RemoteException
	{
		return new ClinicalDisplayRemoteMethodPassthroughCommandV6(transactionId, credentials, 
				siteId, methodName, inputParameters).executeClinicalDisplayCommand();
	}

}
