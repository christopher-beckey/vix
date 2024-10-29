package gov.va.med.imaging.dicom.importer.rest.resources;

import java.util.List;

import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.dicom.importer.commands.order.GetDiagnosticCodeListCommand;
import gov.va.med.imaging.dicom.importer.commands.order.GetImagingLocationListCommand;
import gov.va.med.imaging.dicom.importer.commands.order.GetOrderingLocationListCommand;
import gov.va.med.imaging.dicom.importer.commands.order.GetOrderingProviderListCommand;
import gov.va.med.imaging.dicom.importer.commands.order.GetProcedureListCommand;
import gov.va.med.imaging.dicom.importer.commands.order.GetProcedureModifierListCommand;
import gov.va.med.imaging.dicom.importer.commands.order.GetStandardReportListCommand;
import gov.va.med.imaging.exchange.business.dicom.importer.ImporterUtils;
import gov.va.med.imaging.exchange.business.dicom.importer.Order;
import gov.va.med.imaging.exchange.business.dicom.importer.OrderFilter;
import gov.va.med.imaging.exchange.business.dicom.importer.Procedure;

import javax.ws.rs.GET;
import javax.ws.rs.Path;
import javax.ws.rs.PathParam;
import javax.ws.rs.Produces;
import javax.ws.rs.QueryParam;

import com.thoughtworks.xstream.XStream;

@Path("/order")
public class OrderResource extends BaseImporterResource
{
    // and implement the following GET method 
    @GET 
    @Path("/getOrdersForPatient")
    @Produces("application/xml")
    public String getOrdersForPatient(
    		@QueryParam("patientDfn") String patientDfn,
    		@QueryParam("siteId") String siteId) 
    throws MethodException, ConnectionException 
    {

    	OrderFilter orderFilter = new OrderFilter();
    	orderFilter.setDfn(patientDfn);
    	orderFilter.setSiteId(siteId);
    	
    	List<Order> orders = getRouter().getOrderListForPatient(orderFilter);
    	XStream xstream = ImporterUtils.getXStream();
    	xstream.alias("ArrayOfOrder", List.class);
        return xstream.toXML(orders);

    }

    @GET 
    @Path("/getOrderingProviderList")
    @Produces("application/xml")
    public String getOrderingProviderList(@QueryParam("siteId") String siteId, @QueryParam("searchString") String searchString) 
    throws MethodException, ConnectionException 
    {
    	GetOrderingProviderListCommand command = new GetOrderingProviderListCommand(siteId, searchString, "1.0");
    	return command.execute();
    }

    @GET 
    @Path("/getOrderingLocationList")
    @Produces("application/xml")
    public String getOrderingLocationList(@QueryParam("siteId") String siteId) 
    throws MethodException, ConnectionException 
    {
    	GetOrderingLocationListCommand command = new GetOrderingLocationListCommand(siteId, "1.0");
    	return command.execute();
    }

    @GET 
    @Path("/getImagingLocationList")
    @Produces("application/xml")
    public String getImagingLocationList(@QueryParam("siteId") String siteId) 
    throws MethodException, ConnectionException 
    {
    	GetImagingLocationListCommand command = new GetImagingLocationListCommand(siteId, "1.0");
    	return command.execute();
    }

    @GET 
    @Path("/getProcedureList")
    @Produces("application/xml")
    public String getProcedureList(@QueryParam("siteId") String siteId, 
    		@QueryParam("imagingLocationIen") String imagingLocationIen,
    		@QueryParam("procedureIen") String procedureIen) 
    throws MethodException, ConnectionException, Exception 
    {
    	imagingLocationIen = imagingLocationIen + "";
    	procedureIen = procedureIen + "";
    	GetProcedureListCommand command = new GetProcedureListCommand(siteId, imagingLocationIen, procedureIen, "1.0");
    	
    	return command.execute();
    }

    @GET 
    @Path("/getProcedureModifierList")
    @Produces("application/xml")
    public String getProcedureModifierList(@QueryParam("siteId") String siteId) 
    throws MethodException, ConnectionException 
    {
    	GetProcedureModifierListCommand command = new GetProcedureModifierListCommand(siteId, "1.0");
    	return command.execute();
    }
    
    @GET 
    @Path("/getStandardReportList")
    @Produces("application/xml")
    public String getStandardReportList(@QueryParam("siteId") String siteId) 
    throws MethodException, ConnectionException 
    {
    	GetStandardReportListCommand command = new GetStandardReportListCommand(siteId, "1.0");
    	return command.execute();
    }

    @GET 
    @Path("/getDiagnosticCodeList")
    @Produces("application/xml")
    public String getDiagnosticCodeList(@QueryParam("siteId") String siteId) 
    throws MethodException, ConnectionException 
    {
    	GetDiagnosticCodeListCommand command = new GetDiagnosticCodeListCommand(siteId, "1.0");
    	return command.execute();
    }

}
