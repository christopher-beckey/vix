/**
 * 
 */
package gov.va.med.imaging.ihe.request;

import java.util.Date;
import gov.va.med.imaging.ihe.FindDocumentStoredQueryParameterNames;
import gov.va.med.imaging.ihe.TransactionType;
import gov.va.med.imaging.ihe.exceptions.ParameterFormatException;
import gov.va.med.imaging.ihe.request.filter.FilterTerm;

/**
 * @author vhaiswbeckec
 *
 */
public class CrossGatewayQueryRequest
extends FindDocumentStoredQueryRequest
{
	/**
	 * @param transactionType
	 * @param queryUUID
	 * @param homeCommunityId 
	 * @param maxResults
	 * @param returnComposedObject
	 * @param parameters
	 */
	public CrossGatewayQueryRequest(
		long maxResults, 
		boolean returnComposedObject,
		StoredQueryParameterList parameters)
	{
		super(TransactionType.CrossGatewayQuery, maxResults, returnComposedObject, parameters);
	}

	/**
	 * Must be a single value.
	 * 
	 * @return
	 * @throws ParameterFormatException
	 */
	public String getPatientId()
	throws ParameterFormatException
	{ 
		return getParameters().getParameterAsString( FindDocumentStoredQueryParameterNames.patientId.toString() ); 
	}
	
	public String[] getClassCode()
	throws ParameterFormatException
	{ 
		return getParameters().getParameterRawValue( FindDocumentStoredQueryParameterNames.classCode.toString() )[0]; 
	}

	public FilterTerm getPracticeSettingCode()
	throws ParameterFormatException
	{ 
		return getParameters().getParameterFilterTerm( FindDocumentStoredQueryParameterNames.practiceSettingCode.toString() ); 
	}
	
	public Date getCreationTimeFrom()
	throws ParameterFormatException
	{ 
		return getParameters().getParameterAsDate( FindDocumentStoredQueryParameterNames.creationTimeFrom.toString() ); 
	}
	public Date getCreationTimeTo()
	throws ParameterFormatException
	{ 
		return getParameters().getParameterAsDate( FindDocumentStoredQueryParameterNames.creationTimeTo.toString() ); 
	}
	public Date getServiceStartTimeFrom()
	throws ParameterFormatException
	{ 
		return getParameters().getParameterAsDate( FindDocumentStoredQueryParameterNames.serviceStartTimeFrom.toString() ); 
	}
	public Date getServiceStartTimeTo()
	throws ParameterFormatException
	{ 
		return getParameters().getParameterAsDate( FindDocumentStoredQueryParameterNames.serviceStartTimeTo.toString() ); 
	}
	public Date getServiceStopTimeFrom()
	throws ParameterFormatException
	{ 
		return getParameters().getParameterAsDate( FindDocumentStoredQueryParameterNames.serviceStopTimeFrom.toString() ); 
	}
	public Date getServiceStopTimeTo()
	throws ParameterFormatException
	{ 
		return getParameters().getParameterAsDate( FindDocumentStoredQueryParameterNames.serviceStopTimeTo.toString() ); 
	}
	
	public FilterTerm getHealthcareFacilityTypeCode()
	throws ParameterFormatException
	{ 
		return getParameters().getParameterFilterTerm(FindDocumentStoredQueryParameterNames.healthcareFacilityTypeCode.toString() ); 
	}
	
	public FilterTerm getEventCodeList()
	throws ParameterFormatException
	{ 
		return getParameters().getParameterFilterTerm( FindDocumentStoredQueryParameterNames.eventCodeList.toString() ); 
	}
	
	public FilterTerm getConfidentialityCodeList()
	throws ParameterFormatException
	{ 
		return getParameters().getParameterFilterTerm( FindDocumentStoredQueryParameterNames.confidentialityCodeList.toString() ); 
	}
	
	public String getAuthor()
	throws ParameterFormatException
	{ 
		return getParameters().getParameterAsString( FindDocumentStoredQueryParameterNames.author.toString() ); 
	}
	
	public String getFormatCode()
	throws ParameterFormatException
	{ 
		return getParameters().getParameterAsString( FindDocumentStoredQueryParameterNames.formatCode.toString() ); 
	}
	
	public String getEntryStatus()
	throws ParameterFormatException
	{ 
		return getParameters().getParameterAsString( FindDocumentStoredQueryParameterNames.entryStatus.toString() ); 
	}
	
}
