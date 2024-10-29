/**
 * 
  Package: MAG - VistA Imaging
  WARNING: Per VHA Directive 2004-038, this routine should not be modified.
  Date Created: Apr 13, 2009
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
package gov.va.med.imaging.vistarad;

import java.io.OutputStream;
import java.util.List;

import gov.va.med.RoutingToken;
import gov.va.med.imaging.ImageURN;
import gov.va.med.imaging.StudyURN;
import gov.va.med.imaging.core.annotations.routerfacade.FacadeRouterInterface;
import gov.va.med.imaging.core.annotations.routerfacade.FacadeRouterInterfaceCommandTester;
import gov.va.med.imaging.core.annotations.routerfacade.FacadeRouterMethod;
import gov.va.med.imaging.core.interfaces.FacadeRouter;
import gov.va.med.imaging.core.interfaces.ImageMetadataNotification;
import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.exchange.business.PassthroughInputMethod;
import gov.va.med.imaging.exchange.business.vistarad.ActiveExams;
import gov.va.med.imaging.exchange.business.vistarad.Exam;
import gov.va.med.imaging.exchange.business.vistarad.ExamSite;
import gov.va.med.imaging.exchange.business.vistarad.ExamSiteCachedStatus;
import gov.va.med.imaging.exchange.business.vistarad.PatientEnterpriseExams;
import gov.va.med.imaging.exchange.enums.SiteConnectivityStatus;

/**
 * @author vhaiswwerfej
 *
 */
@FacadeRouterInterface()
@FacadeRouterInterfaceCommandTester
public interface VistaRadRouter 
extends FacadeRouter
{
	@FacadeRouterMethod(asynchronous=false, commandClassName="GetPatientEnterpriseExamsCommand")
	public abstract PatientEnterpriseExams getPatientEnterpriseExams(
		RoutingToken routingToken,
		String patientId, 
		Boolean fullyLoaded)
	throws MethodException, ConnectionException;
	
	@FacadeRouterMethod(asynchronous=false, commandClassName="GetExamCommand")
	public abstract Exam getExam(StudyURN studyUrn)
	throws MethodException, ConnectionException;
	
	@FacadeRouterMethod(asynchronous=false, commandClassName="GetExamReportCommand")
	public abstract String getExamReport(StudyURN studyUrn)
	throws MethodException, ConnectionException;
	
	@FacadeRouterMethod(asynchronous=false, commandClassName="GetExamRequisitionReportCommand")
	public abstract String getExamRequisitionReport(StudyURN studyUrn)
	throws MethodException, ConnectionException;
	
	@FacadeRouterMethod(asynchronous=false, commandClassName="GetActiveWorklistCommand")
	public abstract ActiveExams getActiveExamsWorklist(
		RoutingToken routingToken, String listDescriptor)
	throws MethodException, ConnectionException;
	
	@FacadeRouterMethod(asynchronous=false, commandClassName="GetExamTextFilesCommand")
	public abstract Long getExamTextFiles(
		StudyURN studyUrn, OutputStream output)
	throws MethodException, ConnectionException;
	
	@FacadeRouterMethod(asynchronous=false, commandClassName="GetExamTextFileByImageUrnCommand")
	public abstract Integer getExamTextFileByImageUrn(ImageURN imageUrn, 
			ImageMetadataNotification metadataCallback,
			OutputStream outStream)
	throws MethodException, ConnectionException;
	
	@FacadeRouterMethod(asynchronous=false, commandClassName="GetExamTextFileFromCacheByImageUrnCommand")
	public abstract Integer getExamTextFileFromCacheByImageUrn(ImageURN imageUrn, 
			ImageMetadataNotification metadataCallback,
			OutputStream outStream)
	throws MethodException, ConnectionException;
		
	@FacadeRouterMethod(asynchronous=false, commandClassName="GetExamSiteBySiteNumberCommand")
	public abstract ExamSite getExamSiteBySiteNumber(RoutingToken routingToken, String patientId, 
			Boolean forceRefresh, Boolean forceImagesFromJb)
	throws MethodException, ConnectionException;
	
	@FacadeRouterMethod(asynchronous=false, commandClassName="GetVistaRadSiteConnectivityStatusCommand")
	public abstract SiteConnectivityStatus getSiteConnectivityStatus(RoutingToken routingToken)
	throws MethodException, ConnectionException;	
	
	@FacadeRouterMethod(asynchronous=false, commandClassName="PostPassthroughMethodCommand")
	public abstract String postPassthroughMethod(
		RoutingToken routingToken, 
		PassthroughInputMethod inputMethod)
	throws MethodException, ConnectionException;
		
	@FacadeRouterMethod(asynchronous=false, commandClassName="GetExamSiteCachedBySiteNumberCommand")
	public abstract List<ExamSiteCachedStatus> getExamsCacheStatus(String patientIcn, RoutingToken[] routingTokens)
	throws MethodException, ConnectionException;
	
	@FacadeRouterMethod(asynchronous=false, commandClassName="PostExamAccessEventCommand")
	public abstract Boolean postExamAccessEvent(RoutingToken routingToken, String inputParameter)
	throws MethodException, ConnectionException;
	
	@FacadeRouterMethod(asynchronous=false, commandClassName="PrefetchExamImagesCommand")
	public abstract void prefetchExamImages(StudyURN studyUrn)
	throws MethodException, ConnectionException;
}
