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
package gov.va.med.imaging.ax;

import gov.va.med.RoutingToken;
import gov.va.med.imaging.DocumentURN;
import gov.va.med.imaging.access.TransactionLogEntry;
import gov.va.med.imaging.core.annotations.routerfacade.FacadeRouterInterface;
import gov.va.med.imaging.core.annotations.routerfacade.FacadeRouterInterfaceCommandTester;
import gov.va.med.imaging.core.annotations.routerfacade.FacadeRouterMethod;
import gov.va.med.imaging.core.interfaces.FacadeRouter;
import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.exchange.ImageAccessLogEvent;
import gov.va.med.imaging.exchange.business.DocumentFilter;
import gov.va.med.imaging.exchange.business.PatientSensitiveValue;
import gov.va.med.imaging.exchange.business.documents.DocumentRetrieveResult;
import gov.va.med.imaging.exchange.business.documents.DocumentSetResult;

/**
 * 
 * @author vhaiswbeckec
 *
 */
@FacadeRouterInterface()
@FacadeRouterInterfaceCommandTester
public interface AxWebAppRouter
extends FacadeRouter
{
	@FacadeRouterMethod(asynchronous=false, commandClassName="GetPatientSensitivityLevelCommand")
	public abstract PatientSensitiveValue getPatientSensitiveValue(RoutingToken routingToken, String patientIcn)
	throws MethodException, ConnectionException;	

	@FacadeRouterMethod()
	public abstract DocumentRetrieveResult getDocument(DocumentURN documentUrn)
	throws MethodException, ConnectionException;
	
	/**
	 * Asynchronously store a TransactionLog record using a TransactionLogEntry object.
	 * @param entry The TransactionLogEntry object to store a TransactionLog record.
	 */
	@FacadeRouterMethod(asynchronous = true, commandClassName = "PostTransactionLogEntryCommand")
	public abstract void postTransactionLogEntry(TransactionLogEntry entry);

	/**
	 * Synchronously store a TransactionLog record using a TransactionLogEntry object.
	 * @param entry The TransactionLogEntry object to store a TransactionLog record.
	 * @throws MethodException
	 * @throws ConnectionException
	 */
	@FacadeRouterMethod(asynchronous = false, commandClassName = "PostTransactionLogEntryCommand")
	public abstract void postTransactionLogEntryImmediate(
			TransactionLogEntry entry) throws MethodException,
			ConnectionException;
	
	@FacadeRouterMethod(asynchronous=false, commandClassName="GetDocumentSetResultForPatientCommand")
	public abstract DocumentSetResult getDocumentSetResultForPatient(RoutingToken routingToken, DocumentFilter documentFilter)
	throws MethodException, ConnectionException;
	
	/**
	 * Call an async command to post an image access event
	 * @param event
	 */
	@FacadeRouterMethod(asynchronous=true, commandClassName="PostImageAccessEventRetryableCommand")
	public abstract void postDocumentAccessEventRetryable(ImageAccessLogEvent event);
	
}
