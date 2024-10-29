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
package gov.va.med.imaging.roi.commands;

import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.exchange.translation.exceptions.TranslationException;
import gov.va.med.imaging.roi.commands.AbstractROICommand;

import java.util.List;
import java.util.Map;
import java.util.HashMap;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import com.thoughtworks.xstream.XStream;
import com.thoughtworks.xstream.mapper.MapperWrapper;

import gov.va.med.imaging.web.commands.WebserviceInputParameterTransactionContextField; 
import gov.va.med.imaging.xstream.FieldUpperCaseMapper;

/**
 * @author vhaisltjahjb
 *
 */
public class ROIGetCommunityCareProvidersCommand 
extends AbstractROICommand<List<String>, String>
{
	private static Logger logger = LogManager.getLogger(ROIGetCommunityCareProvidersCommand.class);

	public ROIGetCommunityCareProvidersCommand()
	{
		super("getCommunityCareProviders");
	}

	@Override
	protected List<String> executeRouterCommand() 
			throws MethodException, ConnectionException 
	{
		return getRouter().getCommunityCareProviders();
	}


	/* (non-Javadoc)
	 * @see gov.va.med.imaging.web.commands.AbstractWebserviceCommand#getMethodParameterValuesString()
	 */
	@Override
	protected String getMethodParameterValuesString()
	{
		return "";
	}

	@Override
	protected String translateRouterResult(List<String> result) 
	throws TranslationException 
	{
		XStream xstream = new XStream() {
            protected MapperWrapper wrapMapper(MapperWrapper next) {
                return new FieldUpperCaseMapper(next);
            }
    	};
		xstream.alias("ArrayOfCommunityCareProvider", List.class);
		xstream.alias("CommunityCareProvider", String.class);
    	return xstream.toXML(result);
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.web.commands.AbstractWebserviceCommand#getResultClass()
	 */
	@Override
	protected Class<String> getResultClass()
	{
		return String.class;
	}

	@Override
	protected Map<WebserviceInputParameterTransactionContextField, String> getTransactionContextFields()
	{
		Map<WebserviceInputParameterTransactionContextField, String> transactionContextFields = 
				new HashMap<WebserviceInputParameterTransactionContextField, String>();
			
		return transactionContextFields;
	}
	
	/* (non-Javadoc)
	 * @see gov.va.med.imaging.web.commands.AbstractWebserviceCommand#getEntriesReturned(java.lang.Object)
	 */
	@Override
	public Integer getEntriesReturned(String translatedResult)
	{
		return (translatedResult == null ? 0 : 1);
	}

}
