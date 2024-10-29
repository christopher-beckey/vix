/**
 * 
  Package: MAG - VistA Imaging
  WARNING: Per VHA Directive 2004-038, this routine should not be modified.
  Date Created: May 26, 2010
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
package gov.va.med.imaging.dicom.importer.commands.importerworkitem;

import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.core.router.worklist.WorkListContext;
import gov.va.med.imaging.core.router.worklist.WorkListRouter;
import gov.va.med.imaging.dicom.importer.DicomImporterRouter;
import gov.va.med.imaging.dicom.importer.commands.AbstractDicomImporterCommand;
import gov.va.med.imaging.exchange.business.WorkItem;
import gov.va.med.imaging.exchange.business.dicom.importer.ImporterUtils;
import gov.va.med.imaging.exchange.business.dicom.importer.ImporterWorkItem;
import gov.va.med.imaging.exchange.business.dicom.importer.OrderingProvider;
import gov.va.med.imaging.exchange.translation.exceptions.TranslationException;

import java.util.List;

import com.thoughtworks.xstream.XStream;

/**
 * @author vhaiswlouthj
 *
 */
public class UpdateImporterWorkItemCommand 
extends AbstractDicomImporterCommand<Boolean, String>
{
	private final String interfaceVersion;
	private final int workItemId;
	private final String expectedStatus;
	private final String newStatus;
	private final ImporterWorkItem importerWorkItem;
	private final String updatingUser;
	private final String updatingApplication;
	
	public UpdateImporterWorkItemCommand(int workItemId, String expectedStatus, String newStatus, String importerWorkItemString, String updatingUser, String updatingApplication, String interfaceVersion)
	{
		super("updateImporterWorkItemCommand");
		
		XStream xstream = ImporterUtils.getXStream();
		this.importerWorkItem = (ImporterWorkItem)xstream.fromXML(importerWorkItemString);
		this.workItemId = workItemId;
		this.expectedStatus = expectedStatus;
		this.newStatus = newStatus;
		this.updatingUser = updatingUser;
		this.updatingApplication = updatingApplication;
		this.interfaceVersion = interfaceVersion;
	}

	@Override
	protected Boolean executeRouterCommand() 
	throws MethodException, ConnectionException 
	{
		WorkListRouter router = WorkListContext.getRouter();		
		boolean result = router.updateWorkItem(getWorkItemId(), getExpectedStatus(), getNewStatus(), getNewMessage(), getUpdatingUser(), getUpdatingApplication());
		return result;
	}


	@Override
	public String getInterfaceVersion() 
	{
		return this.interfaceVersion;
	}

	@Override
	protected String getMethodParameterValuesString()
	{
		return "";
	}

	@Override
	protected Class<String> getResultClass() 
	{
		return String.class;
	}

	@Override
	protected String translateRouterResult(Boolean result) 
	throws TranslationException 
	{
    	return result ? "0" : "-1";
	}
	
	public int getWorkItemId()
	{
		return workItemId;
	}

	public String getExpectedStatus() {
		return expectedStatus;
	}

	public String getNewStatus() {
		return newStatus;
	}

	public ImporterWorkItem getImporterWorkItem() {
		return importerWorkItem;
	}

	public String getNewMessage() {
		return importerWorkItem.getRawWorkItem().getMessage();
	}

	public String getUpdatingUser() {
		return updatingUser;
	}

	public String getUpdatingApplication() {
		return updatingApplication;
	}

}
