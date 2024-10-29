/**
 * 
 * 
 * Date Created: Jan 26, 2014
 * Developer: Julian Werfel
 */
package gov.va.med.imaging.ingest;

import gov.va.med.PatientIdentifier;
import gov.va.med.RoutingToken;
import gov.va.med.imaging.AbstractImagingURN;
import gov.va.med.imaging.ImageURN;
import gov.va.med.imaging.consult.ConsultURN;
import gov.va.med.imaging.core.annotations.routerfacade.FacadeRouterInterface;
import gov.va.med.imaging.core.annotations.routerfacade.FacadeRouterInterfaceCommandTester;
import gov.va.med.imaging.core.annotations.routerfacade.FacadeRouterMethod;
import gov.va.med.imaging.core.interfaces.FacadeRouter;
import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.ingest.business.ImageIngestParameters;
import gov.va.med.imaging.tiu.PatientTIUNoteURN;
import gov.va.med.imaging.tiu.TIUItemURN;

import java.io.InputStream;
import java.util.Date;

/**
 * @author Julian Werfel
 *
 */
@FacadeRouterInterface
@FacadeRouterInterfaceCommandTester
public interface IngestRouter
extends FacadeRouter
{

	@FacadeRouterMethod(asynchronous=false, commandClassName="PostIngestImageCommand")
	public abstract ImageURN storeImage(RoutingToken routingToken, 
		InputStream imageInputStream, ImageIngestParameters imageIngestParameters,
		boolean createGroup)
	throws MethodException, ConnectionException;
	
	
	@FacadeRouterMethod(asynchronous=false, commandClassName="PostTIUNoteCommand")
	public abstract PatientTIUNoteURN postTIUNote(TIUItemURN noteUrn, PatientIdentifier patientIdentifier,
		TIUItemURN locationUrn, Date noteDate, ConsultURN consultUrn, String noteText, TIUItemURN authorUrn)
	throws MethodException, ConnectionException;

	@FacadeRouterMethod(asynchronous=false, commandClassName="PostTIUNoteWithImageCommand")
	public abstract Boolean associateImageWithNote(AbstractImagingURN imagingUrn, PatientTIUNoteURN tiuNoteUrn)
	throws MethodException, ConnectionException;
}
