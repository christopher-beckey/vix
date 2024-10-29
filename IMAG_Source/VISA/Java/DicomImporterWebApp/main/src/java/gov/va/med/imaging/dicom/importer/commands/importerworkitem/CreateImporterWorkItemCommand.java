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
import gov.va.med.imaging.dicom.importer.commands.AbstractDicomImporterCommand;
import gov.va.med.imaging.exchange.business.WorkItem;
import gov.va.med.imaging.exchange.business.dicom.importer.ImporterUtils;
import gov.va.med.imaging.exchange.business.dicom.importer.ImporterWorkItem;
import gov.va.med.imaging.exchange.translation.exceptions.TranslationException;

import com.thoughtworks.xstream.XStream;

/**
 * @author vhaiswlouthj
 *
 */
public class CreateImporterWorkItemCommand 
extends AbstractDicomImporterCommand<WorkItem, String>
{
	private final String interfaceVersion;
	private final ImporterWorkItem importerWorkItem;
	
	public CreateImporterWorkItemCommand(String importerWorkItemString, String interfaceVersion)
	{
		super("createImporterWorkItemCommand");
		
		XStream xstream = ImporterUtils.getXStream();
		this.importerWorkItem = (ImporterWorkItem)xstream.fromXML(importerWorkItemString);
		this.interfaceVersion = interfaceVersion;
	}

	@Override
	protected WorkItem executeRouterCommand() 
	throws MethodException, ConnectionException 
	{
		WorkListRouter router = WorkListContext.getRouter();		
		WorkItem workItem = router.createWorkItem(getImporterWorkItem().getRawWorkItem());
		return workItem;
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
	protected String translateRouterResult(WorkItem workItem) 
	throws TranslationException 
	{
		ImporterWorkItem importerWorkItem = ImporterWorkItem.buildShallowImporterWorkItem(workItem);
		XStream xstream = ImporterUtils.getXStream();
    	return xstream.toXML(importerWorkItem);
	}
	
	public ImporterWorkItem getImporterWorkItem() {
		return importerWorkItem;
	}


}
