/**
 * 
  Package: MAG - VistA Imaging
  WARNING: Per VHA Directive 2004-038, this routine should not be modified.
  Date Created: Dec 15, 2008
  Site Name:  Washington OI Field Office, Silver Spring, MD
  Developer:  vhaiswbeckec
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
package gov.va.med.imaging.clinicaldisplay;

import java.util.List;

import gov.va.med.RoutingToken;
import gov.va.med.imaging.AbstractImagingURN;
import gov.va.med.imaging.ImageAnnotationURN;
import gov.va.med.imaging.core.annotations.routerfacade.FacadeRouterInterface;
import gov.va.med.imaging.core.annotations.routerfacade.FacadeRouterInterfaceCommandTester;
import gov.va.med.imaging.core.annotations.routerfacade.FacadeRouterMethod;
import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.exchange.business.PatientSensitiveValue;
import gov.va.med.imaging.exchange.business.UserInformation;
import gov.va.med.imaging.exchange.business.annotations.ImageAnnotation;
import gov.va.med.imaging.exchange.business.annotations.ImageAnnotationDetails;
import gov.va.med.imaging.exchange.business.annotations.ImageAnnotationSource;

/**
 * 
 * @author vhaiswbeckec
 *
 */
@FacadeRouterInterface(extendsClassName="gov.va.med.imaging.ImagingBaseWebFacadeRouterImpl")
@FacadeRouterInterfaceCommandTester
public interface ClinicalDisplayRouter
extends gov.va.med.imaging.ImagingBaseWebFacadeRouter
{
	@FacadeRouterMethod(asynchronous=false, commandClassName="GetPatientSensitivityLevelCommand")
	public abstract PatientSensitiveValue getPatientSensitiveValue(RoutingToken routingToken, String patientIcn)
	throws MethodException, ConnectionException;
	
	@FacadeRouterMethod(asynchronous=false, commandClassName="GetImageAnnotationListByImageUrnCommand")
	public abstract List<ImageAnnotation> getImageAnnotations(AbstractImagingURN imagingUrn)
	throws MethodException, ConnectionException;
	
	@FacadeRouterMethod(asynchronous=false, commandClassName="GetImageAnnotationDetailsCommand")
	public abstract ImageAnnotationDetails getImageAnnotationDetails(AbstractImagingURN imagingUrn, 
			ImageAnnotationURN imageAnnotationUrn)
	throws MethodException, ConnectionException;
	
	@FacadeRouterMethod(asynchronous=false, commandClassName="PostImageAnnotationDetailsCommand")
	public abstract ImageAnnotation storeImageAnnotation(AbstractImagingURN imagingUrn, String annotationDetails,
			String annotationVersion, ImageAnnotationSource annotationSource)
	throws MethodException, ConnectionException;
	
	@FacadeRouterMethod(asynchronous=false, commandClassName="GetSiteAnnotationSupportedStatusCommand")
	public abstract Boolean isSiteAnnotationSupported(RoutingToken routingToken)
	throws MethodException, ConnectionException;
	
	@FacadeRouterMethod(asynchronous=false, commandClassName="GetUserInformationFromDataSourceCommand")
	public abstract UserInformation getUserInformation(RoutingToken routingToken)
	throws MethodException, ConnectionException;
	
}
