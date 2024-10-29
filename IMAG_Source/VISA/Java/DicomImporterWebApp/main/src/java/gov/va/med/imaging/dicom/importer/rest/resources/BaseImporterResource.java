package gov.va.med.imaging.dicom.importer.rest.resources;

import java.io.BufferedInputStream;
import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.InputStream;

import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.dicom.importer.DicomImporterContext;
import gov.va.med.imaging.dicom.importer.DicomImporterRouter;

public class BaseImporterResource {

    
    protected DicomImporterRouter getRouter()
    {
    	DicomImporterRouter router = DicomImporterContext.getRouter();
    	return router;
    }   
    
    protected String readInputStreamAsString(InputStream in) throws MethodException 
    {
    	try
    	{
			BufferedInputStream bis = new BufferedInputStream(in);
			ByteArrayOutputStream buf = new ByteArrayOutputStream();
			int result = bis.read();
			while (result != -1) {
				byte b = (byte) result;
				buf.write(b);
				result = bis.read();
			}
			return buf.toString();
		}
    	catch (IOException ioe)
    	{
    		throw new MethodException(ioe);
    	}
	}
    

}