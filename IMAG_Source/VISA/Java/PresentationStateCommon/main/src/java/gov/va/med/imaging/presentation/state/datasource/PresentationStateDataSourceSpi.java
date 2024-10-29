/**
 * 
 */
package gov.va.med.imaging.presentation.state.datasource;

import gov.va.med.RoutingToken;
import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.datasource.VersionableDataSourceSpi;
import gov.va.med.imaging.datasource.annotations.SPI;
import gov.va.med.imaging.presentation.state.PresentationStateRecord;

import java.io.IOException;
import java.util.List;


/**
 * @author William Peterson
 *
 */
@SPI(description="Defines the interface for retrieving VistA Imaging User Presentation States.")
public interface PresentationStateDataSourceSpi 
extends VersionableDataSourceSpi {
	
	public abstract Boolean deletePSRecord(RoutingToken globalRoutingToken, PresentationStateRecord pStateRecord)
	throws MethodException, ConnectionException;
	
	public abstract List<PresentationStateRecord> getPSDetails(RoutingToken globalRoutingToken, List<PresentationStateRecord> pStateRecords)
	throws MethodException, ConnectionException;
	
	public abstract List<String> getStudyPSDetails(RoutingToken globalRoutingToken, String studyContext)
	throws MethodException, ConnectionException;

	public abstract List<PresentationStateRecord> getPSRecords(RoutingToken globalRoutingToken, PresentationStateRecord pStateRecord)
	throws MethodException, ConnectionException;
	
	public abstract Boolean postPSDetail(RoutingToken globalRoutingToken, PresentationStateRecord pStateRecord)
	throws MethodException, ConnectionException;
	
	public abstract Boolean postPSRecord(RoutingToken globalRoutingToken, PresentationStateRecord pStateRecord)
	throws MethodException, ConnectionException;
}
