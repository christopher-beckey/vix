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
import gov.va.med.imaging.exchange.translation.exceptions.TranslationException;

/**
 * @author vhaisltjahjb
 *
 */
public class UpdateServiceCommand 
extends AbstractDicomImporterCommand<String, String>
{
	private final String interfaceVersion;
	private final String newService;
	private final String procedure;
	private final String modality;
	private final String service;
	
	public UpdateServiceCommand(String service, String modality, String procedure, String newService, String interfaceVersion)
	{
		super("UpdateServiceCommand");
		this.service = service;
		this.modality = modality;
		this.procedure = procedure;
		this.newService = newService;
		this.interfaceVersion = interfaceVersion;
	}

	@Override
	protected String executeRouterCommand() 
	throws MethodException, ConnectionException 
	{
		WorkListRouter router = WorkListContext.getRouter();		
		setEntriesReturned(1);
		return router.updateWorkItemService(getService(), getModality(), getProcedure(), getNewService());
	}


	@Override
	public String getInterfaceVersion() 
	{
		return this.interfaceVersion;
	}

	@Override
	protected String getMethodParameterValuesString()
	{
		return getService() + " " + getModality() + " " + getProcedure() + " " + getNewService();
	}

	@Override
	protected Class<String> getResultClass() 
	{
		return String.class;
	}

	@Override
	protected String translateRouterResult(String routerResult) 
	throws TranslationException 
	{
    	return routerResult;
	}
	

	public String getNewService()
	{
		return newService;
	}
	
	public String getModality() {
		return modality;
	}

	public String getProcedure() {
		return procedure;
	}

	public String getService() {
		return service;
	}


}
