/**
 * 
  Package: MAG - VistA Imaging
  WARNING: Per VHA Directive 2004-038, this routine should not be modified.
  Date Created: May 25, 2010
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
package gov.va.med.imaging.patient.commands;

import java.util.HashMap;
import java.util.Map;

import com.thoughtworks.xstream.XStream;
import com.thoughtworks.xstream.mapper.MapperWrapper;

import gov.va.med.RoutingToken;
import gov.va.med.RoutingTokenImpl;
import gov.va.med.exceptions.RoutingTokenFormatException;
import gov.va.med.imaging.patient.PatientContext;
import gov.va.med.imaging.patient.PatientRouter;
import gov.va.med.imaging.web.commands.AbstractWebserviceCommand;
import gov.va.med.imaging.web.commands.WebserviceInputParameterTransactionContextField;
import gov.va.med.imaging.xstream.FieldUpperCaseMapper;

/**
 * @author vhaiswlouthj
 *
 */
public abstract class AbstractPatientCommand<D, E extends Object>
extends AbstractWebserviceCommand<D, E>
{

	private int entriesReturned;


	public AbstractPatientCommand(String methodName)
	{
		super(methodName);
	}
	
	/**
	 * 
	 * @return
	 */
	@Override
	protected PatientRouter getRouter()
	{
		return PatientContext.getRouter();
	}
		
	@Override
	protected String getWepAppName() 
	{
		return "Patient WebApp";
	}
	
	@Override
	protected String getRequestTypeAdditionalDetails()
	{
		return null;
	}
	
	public static RoutingToken translateRoutingToken(String serializedRoutingToken)
	throws RoutingTokenFormatException
	{
		return RoutingTokenImpl.parse(serializedRoutingToken);
	}
	

	protected void setEntriesReturned(int entriesReturned) 
	{
		this.entriesReturned = entriesReturned;
	}
	
	@Override
	public Integer getEntriesReturned(E translatedResult)
	{
		return this.entriesReturned;
	}

	protected XStream getXStream()
	{
    	XStream xstream = new XStream() {
            protected MapperWrapper wrapMapper(MapperWrapper next) {
                return new FieldUpperCaseMapper(next);
            }
    	};
    	
    	return xstream;

	}
	
	@Override
	protected Map<WebserviceInputParameterTransactionContextField, String> getTransactionContextFields() 
	{
		Map<WebserviceInputParameterTransactionContextField, String> transactionContextFields = 
			new HashMap<WebserviceInputParameterTransactionContextField, String>();
		
		transactionContextFields.put(WebserviceInputParameterTransactionContextField.quality, transactionContextNaValue);
		transactionContextFields.put(WebserviceInputParameterTransactionContextField.urn, transactionContextNaValue);
		transactionContextFields.put(WebserviceInputParameterTransactionContextField.queryFilter, transactionContextNaValue);

		return transactionContextFields;
	}

	@Override
	public void setAdditionalTransactionContextFields() 
	{
		
	}




}
