package gov.va.med.imaging.datasource;

import java.util.List;

import gov.va.med.RoutingToken;
import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.datasource.annotations.SPI;
import gov.va.med.imaging.exchange.business.WorkItem;
import gov.va.med.imaging.exchange.business.dicom.DicomAE;


/**
 * This interface represents abstract methods for DICOM Services.
 * 
 * @author William Peterson
 *
 */

@SPI(description="The service provider interface for DICOM Service operations")
public interface DicomServicesDataSourceSpi 
extends VersionableDataSourceSpi {
	
	abstract void postToAE(RoutingToken routingToken, DicomAE dicomAE, List<String> dicomFileList)
			throws MethodException, ConnectionException;
	
	abstract List<DicomAE> getAEList(RoutingToken routingToken)
			throws MethodException, ConnectionException;
	
	abstract String getDicomReportText(RoutingToken routingToken, WorkItem workItem) 
			throws MethodException, ConnectionException;
	
}
