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
package gov.va.med.imaging.user.commands;

import gov.va.med.imaging.core.interfaces.FacadeRouter;
import gov.va.med.imaging.user.UserContext;
import gov.va.med.imaging.web.commands.AbstractWebserviceCommand;
import gov.va.med.imaging.web.commands.WebserviceInputParameterTransactionContextField;
import gov.va.med.imaging.xstream.FieldUpperCaseMapper;

import java.util.HashMap;
import java.util.Map;

import com.thoughtworks.xstream.XStream;
import com.thoughtworks.xstream.mapper.MapperWrapper;

/**
 * @author vhaiswlouthj
 *
 */
public abstract class AbstractUserCommand<D, E extends Object>
extends AbstractWebserviceCommand<D, E>
{
	private final String routingTokenString = "";
	private final String interfaceVersion = "1.0";
	private int entriesReturned = 0;
	
	public AbstractUserCommand(String methodName)
	{
		super(methodName);
	}
	
	@Override
	public String getInterfaceVersion() 
	{
		return this.interfaceVersion;
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
	public Integer getEntriesReturned(E translatedResult)
	{
		return entriesReturned;
	}

	public void setEntriesReturned(int entriesReturned)
	{
		this.entriesReturned = entriesReturned;
	}
	
	@Override
	protected String getWepAppName() {
		return "UserWebApp";
	}
	
	@Override
	protected String getRequestTypeAdditionalDetails() {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	protected FacadeRouter getRouter() {
		return UserContext.getRouter();
	}

	@Override
	public void setAdditionalTransactionContextFields() {
		// TODO Auto-generated method stub
		
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


}
