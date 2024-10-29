/**
 * 
 * Date Created: Mar 14, 2014
 * Developer: Julian Werfel
 */
package gov.va.med.imaging.tiu.router.commands.facade;

import gov.va.med.imaging.core.annotations.routerfacade.FacadeRouterInterface;
import gov.va.med.imaging.core.annotations.routerfacade.FacadeRouterInterfaceCommandTester;
import gov.va.med.imaging.core.annotations.routerfacade.FacadeRouterMethod;
import gov.va.med.imaging.core.interfaces.FacadeRouter;
import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.tiu.PatientTIUNoteURN;
import gov.va.med.imaging.tiu.TIUItemURN;

/**
 * @author Julian Werfel
 *
 */
@FacadeRouterInterface
@FacadeRouterInterfaceCommandTester
public interface TIUCommandsRouter
extends FacadeRouter
{
	@FacadeRouterMethod(asynchronous=false, isChildCommand=true, commandClassName="GetTIUNoteIsAdvanceDirectiveCommand")
	public abstract Boolean isTIUNoteAdvanceDirective(TIUItemURN noteUrn)
	throws MethodException, ConnectionException;

	@FacadeRouterMethod(asynchronous=false, isChildCommand=true, commandClassName="GetTIUPatientNoteAdvanceDirectiveCommand")
	public abstract Boolean isPatientNoteAdvanceDirective(PatientTIUNoteURN noteUrn)
	throws MethodException, ConnectionException;
}
