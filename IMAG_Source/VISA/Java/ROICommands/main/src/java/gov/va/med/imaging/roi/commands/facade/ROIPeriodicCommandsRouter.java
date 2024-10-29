/**
 * 
  Package: MAG - VistA Imaging
  WARNING: Per VHA Directive 2004-038, this routine should not be modified.
  Date Created: Mar 29, 2012
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
package gov.va.med.imaging.roi.commands.facade;

import gov.va.med.imaging.core.annotations.routerfacade.FacadeRouterInterface;
import gov.va.med.imaging.core.annotations.routerfacade.FacadeRouterInterfaceCommandTester;
import gov.va.med.imaging.core.annotations.routerfacade.FacadeRouterMethod;
import gov.va.med.imaging.core.interfaces.FacadeRouter;

/**
 * @author VHAISWWERFEJ
 *
 */
@FacadeRouterInterface
@FacadeRouterInterfaceCommandTester
public interface ROIPeriodicCommandsRouter
extends FacadeRouter
{
	/**
	 * Find incomplete ROI work items to process, run every 1 hour
	 */
	@FacadeRouterMethod(asynchronous=true, isChildCommand=false, commandClassName="ProcessROIPeriodicRequestsCommand", isPeriodic=true, periodicExecutionDelay=3600000)
	public abstract void processROIPeriodicRequests();
	
	/**
	 * Purge completed ROI work items, run every 12 hours. The initial purge is run 10 minutes after start
	 */
	@FacadeRouterMethod(asynchronous=true, isChildCommand=false, commandClassName="DeleteOldCompletedROIWorkItemsCommand", isPeriodic=true, periodicExecutionDelay=43200000, delay=60000)
	public abstract void purgeCompletedROIWorkItems();

}
