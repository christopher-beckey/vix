/**
 * 
 * Property of ISI Group, LLC
 * Date Created: Jan 10, 2014
 * Developer: Administrator
 */
package gov.va.med.imaging.data.commands;

import gov.va.med.URNFactory;
import gov.va.med.imaging.AbstractImagingURN;
import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.data.ImagingDataRouter;
import gov.va.med.imaging.exceptions.URNFormatException;
import gov.va.med.imaging.exchange.translation.exceptions.TranslationException;
import gov.va.med.imaging.web.commands.WebserviceInputParameterTransactionContextField;

import java.util.HashMap;
import java.util.Map;


/**
 * @author Budy Tjahjo
 *
 */
public class GetImageSystemGlobalNodeCommand
extends AbstractImagingDataCommands<String, String>
{
	private final String siteNumber;
	private final String studyUrn;
	private final String interfaceVersion;

	public GetImageSystemGlobalNodeCommand(String siteNumber,
		String studyUrn, String interfaceVersion)
	{
		super("getImageSystemGlobalNode");
		this.siteNumber = siteNumber;
		this.studyUrn = studyUrn;
		this.interfaceVersion = interfaceVersion;
	}

	/**
	 * @return the siteNumber
	 */
	public String getSiteNumber()
	{
		return siteNumber;
	}

	/**
	 * @return the studyUrn
	 */
	public String getStudyUrn()
	{
		return studyUrn;
	}


	@Override
	protected String executeRouterCommand() 
	throws MethodException, ConnectionException
	{
		getLogger().info("execute getImageSystemGlobalNode");
		AbstractImagingURN urn = null;
		try
		{
			urn = URNFactory.create(studyUrn, AbstractImagingURN.class);
			ImagingDataRouter router = getRouter();
			getTransactionContext().setPatientID(urn.getPatientId());
			String response = router.getImageSystemGlobalNode(urn);
			getTransactionContext().setFacadeBytesSent(response == null ? 0L : response.length());
			return response;
		}
		catch (ClassCastException e)
        {
			String msg = "'" + studyUrn + "' is not a valid image identifier (ImageURN).";
			getLogger().info(msg);
			throw new MethodException("ClassCaseException, unable to translate image Id", e);
        } 
		catch(URNFormatException iurnfX)
		{
            getLogger().info("FAIlED getImageInformation transaction ({}), unable to translate image Id", getTransactionId(), iurnfX);
			throw new MethodException("URNFormatException, unable to translate image Id", iurnfX);
		}
	}

	@Override
	public Integer getEntriesReturned(String translatedResult)
	{
		return null;
	}
	
	/* (non-Javadoc)
	 * @see gov.va.med.imaging.web.commands.AbstractWebserviceCommand#getMethodParameterValuesString()
	 */
	@Override
	protected String getMethodParameterValuesString()
	{
		return "from site [" + getSiteNumber() + "] studyUrn [" + getStudyUrn() + "]";
	}


	@Override
	protected String translateRouterResult(String routerResult)
	throws TranslationException
	{
		return routerResult;
	}

	

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.web.commands.AbstractWebserviceCommand#getTransactionContextFields()
	 */
	@Override
	protected Map<WebserviceInputParameterTransactionContextField, String> getTransactionContextFields()
	{
		Map<WebserviceInputParameterTransactionContextField, String> transactionContextFields = 
			new HashMap<WebserviceInputParameterTransactionContextField, String>();
		
		transactionContextFields.put(WebserviceInputParameterTransactionContextField.quality, transactionContextNaValue);
		transactionContextFields.put(WebserviceInputParameterTransactionContextField.queryFilter, transactionContextNaValue);
	
		return transactionContextFields;
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.web.commands.AbstractWebserviceCommand#getInterfaceVersion()
	 */
	@Override
	public String getInterfaceVersion()
	{
		return interfaceVersion;
	}

	@Override
	protected Class<String> getResultClass()
	{
		return String.class;
	}
	

}
