/**
 * 
  Package: MAG - VistA Imaging
  WARNING: Per VHA Directive 2004-038, this routine should not be modified.
  Date Created: Dec 15, 2008
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
package gov.va.med.imaging.user;

import java.util.List;

import gov.va.med.RoutingToken;
import gov.va.med.imaging.core.annotations.routerfacade.FacadeRouterInterface;
import gov.va.med.imaging.core.annotations.routerfacade.FacadeRouterInterfaceCommandTester;
import gov.va.med.imaging.core.annotations.routerfacade.FacadeRouterMethod;
import gov.va.med.imaging.core.interfaces.FacadeRouter;
import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.exchange.business.ApplicationTimeoutParameters;
import gov.va.med.imaging.exchange.business.Division;
import gov.va.med.imaging.exchange.business.ElectronicSignatureResult;
import gov.va.med.imaging.exchange.business.WelcomeMessage;

/**
 * @author vhaiswlouthj
 *
 */
@FacadeRouterInterface()
@FacadeRouterInterfaceCommandTester
public interface UserRouter 
extends FacadeRouter
{
    // Get Welcome Message
	@FacadeRouterMethod(asynchronous=false)
	public abstract WelcomeMessage getWelcomeMessage()
	throws ConnectionException, MethodException;

	// Get User Keys
	@FacadeRouterMethod(asynchronous=false)
	public abstract List<String> getUserKeys(RoutingToken routingToken)
	throws ConnectionException, MethodException;

	// Get Divisions
	@FacadeRouterMethod(asynchronous=false)
	public abstract List<Division> getDivisionList(String accessCode, RoutingToken routingToken)
	throws ConnectionException, MethodException;
	
	@FacadeRouterMethod(asynchronous=false, commandClassName="GetVerifyElectronicSignatureCommand")
	public abstract ElectronicSignatureResult verifyElectronicSignature(RoutingToken routingToken, String electronicSignature)
	throws ConnectionException, MethodException;
	
	@FacadeRouterMethod(asynchronous=false)
	public abstract ApplicationTimeoutParameters getApplicationTimeoutParameters(String siteId, String applicationName) 
	throws MethodException, ConnectionException;
	
}
