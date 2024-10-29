package gov.va.med.imaging.dicom.importer.rest.resources;

import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.dicom.importer.DicomImporterContext;
import gov.va.med.imaging.dicom.importer.commands.IsImporterVersionCompatibleCommand;
import gov.va.med.imaging.dicom.importer.commands.importerworkitem.CreateImporterWorkItemCommand;
import gov.va.med.imaging.dicom.importer.commands.importerworkitem.GetAndTransitionImporterWorkItemCommand;
import gov.va.med.imaging.dicom.importer.commands.importerworkitem.GetWorkItemListCommand;
import gov.va.med.imaging.dicom.importer.commands.importerworkitem.UpdateImporterWorkItemCommand;
import gov.va.med.imaging.dicom.importer.commands.order.GetOrderingProviderListCommand;
import gov.va.med.imaging.exchange.business.dicom.importer.ImporterUtils;
import gov.va.med.imaging.exchange.business.dicom.importer.ImporterWorkItemDetails;
import gov.va.med.imaging.exchange.business.dicom.importer.Reconciliation;
import gov.va.med.imaging.exchange.business.dicom.importer.Study;
import gov.va.med.imaging.xstream.FieldUpperCaseMapper;

import java.io.BufferedInputStream;
import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.util.ArrayList;
import java.util.List;

import javax.ws.rs.GET;
import javax.ws.rs.POST;
import javax.ws.rs.Path;
import javax.ws.rs.Produces;
import javax.ws.rs.QueryParam;

import com.thoughtworks.xstream.XStream;
import com.thoughtworks.xstream.mapper.MapperWrapper;

@Path("importerVersionCheck")
public class ImporterCompatibilityResource extends BaseImporterResource 
{

    @GET 
    @Path("isVersionCompatible")
    @Produces("application/text")
    public String isVersionCompatible(@QueryParam("version") int version) 
    throws MethodException, ConnectionException
    {
    	// Assum we're compatible. If any exception is raised, we're incompatible.
    	boolean isVersionCompatible = true;

    	try
    	{
        	IsImporterVersionCompatibleCommand command = new IsImporterVersionCompatibleCommand("1.0");
        	return command.execute();
    	}
    	catch (Exception e)
    	{
    		isVersionCompatible = false;
    	}
    	
    	return isVersionCompatible ? "true" : "false";
    }
}