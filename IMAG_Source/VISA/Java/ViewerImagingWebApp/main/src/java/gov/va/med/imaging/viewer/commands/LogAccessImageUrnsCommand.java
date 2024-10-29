package gov.va.med.imaging.viewer.commands;


import gov.va.med.PatientIdentifier;
import gov.va.med.RoutingToken;
import gov.va.med.SERIALIZATION_FORMAT;
import gov.va.med.URNFactory;
import gov.va.med.imaging.AbstractImagingURN;
import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.exceptions.URNFormatException;
import gov.va.med.imaging.exchange.ImageAccessLogEvent;
import gov.va.med.imaging.exchange.RoutingTokenHelper;
import gov.va.med.imaging.exchange.ImageAccessLogEvent.ImageAccessLogEventType;
import gov.va.med.imaging.exchange.translation.exceptions.TranslationException;
import gov.va.med.imaging.rest.types.RestBooleanReturnType;
import gov.va.med.imaging.viewer.ViewerImagingContext;
import gov.va.med.imaging.viewer.business.FlagSensitiveImageUrn;
import gov.va.med.imaging.viewer.business.FlagSensitiveImageUrnResult;
import gov.va.med.imaging.viewer.business.LogAccessImageUrn;
import gov.va.med.imaging.viewer.business.LogAccessImageUrnResult;
import gov.va.med.imaging.viewer.rest.translator.ViewerImagingRestTranslator;
import gov.va.med.imaging.viewer.rest.types.FlagSensitiveImageUrnResultsType;
import gov.va.med.imaging.viewer.rest.types.LogAccessImageUrnResultsType;
import gov.va.med.imaging.viewer.rest.types.LogAccessImageUrnType;
import gov.va.med.imaging.viewer.rest.types.LogAccessImageUrnsType;
import gov.va.med.imaging.web.commands.WebserviceInputParameterTransactionContextField;

import java.util.HashMap;
import java.util.List;
import java.util.Map;



/**
 * @author vhaisltjahjb
 * @param List<LogAccessImageUrnResult>
 * @param LogAccessImageUrnResultsType
 *
 */
public class LogAccessImageUrnsCommand
extends AbstractViewerImagingCommands<List<LogAccessImageUrnResult>, LogAccessImageUrnResultsType>
{
	private String siteNumber;
	private String interfaceVersion;
	private String patientIcn;
	private String patientDfn;
	private final LogAccessImageUrnsType imageUrns;

	public LogAccessImageUrnsCommand(
			String siteNumber,
			String patientIcn,
			String patientDfn,
			LogAccessImageUrnsType imageUrns,
			String interfaceVersion)
	{
		super("logAccessImageUrnsCommand");
		this.siteNumber = siteNumber;
		this.patientIcn = patientIcn;
		this.patientDfn = patientDfn;
		this.imageUrns = imageUrns;
		this.interfaceVersion = interfaceVersion;
	}

	@Override
	protected List<LogAccessImageUrnResult> executeRouterCommand() 
	throws MethodException, ConnectionException
	{
		//If empty or null, set access reason with default
		String defaultReason = imageUrns.getDefaultLogAccessReason();
		if (defaultReason == null)
		{
			defaultReason = "";
		}
		
		for (LogAccessImageUrnType log : imageUrns.getLogAccessImageUrns())
		{
			String reason = log.getReason();
			if ((reason == null) || (reason.equals(""))) 
			{
				log.setReason(defaultReason);
			}
		}
		
		try
		{
			RoutingToken routingToken = 
					RoutingTokenHelper.createSiteAppropriateRoutingToken(getSiteNumber());
			return getRouter().logImageAccessByUrns(
					routingToken, 
					getPatientIcn(),
					getPatientDfn(),
					getImageUrns()
					);
		}
		catch(Exception e)
		{
			// logging and transaction context setting handled by calling method
			throw new MethodException(e);
		}
	}


	/**
	 * @return the siteNumber
	 */
	public String getSiteNumber()
	{
		return this.siteNumber;
	}
	
	/**
	 * @return the patientDfn
	 */
	public String getPatientDfn()
	{
		return this.patientDfn;
	}

	/**
	 * @return the patientIcn
	 */
	public String getPatientIcn()
	{
		return this.patientIcn;
	}

	/**
	 * @return the imageUrns Size
	 */
	public int getImageUrnsSize()
	{
		LogAccessImageUrnType[] logAccessImageUrns = imageUrns.getLogAccessImageUrns();
		return logAccessImageUrns.length;
	}
	
	/**
	 * @return the imageUrns
	 */
	public List<LogAccessImageUrn> getImageUrns()
	{
		return ViewerImagingRestTranslator.translateImageUrns(imageUrns);
	}
	

	@Override
	public String getInterfaceVersion()
	{
		return this.interfaceVersion;
	}

	
	/* (non-Javadoc)
	 * @see gov.va.med.imaging.web.commands.AbstractWebserviceCommand#getMethodParameterValuesString()
	 */
	@Override
	protected String getMethodParameterValuesString()
	{
		return "from site [" + getSiteNumber() + "] " +
				"imageUrns size [" + this.getImageUrnsSize() + "] ";
	}


	@Override
	protected Map<WebserviceInputParameterTransactionContextField, String> getTransactionContextFields()
	{
		Map<WebserviceInputParameterTransactionContextField, String> transactionContextFields = 
			new HashMap<WebserviceInputParameterTransactionContextField, String>();
		
		transactionContextFields.put(WebserviceInputParameterTransactionContextField.quality, transactionContextNaValue);
		transactionContextFields.put(WebserviceInputParameterTransactionContextField.queryFilter, transactionContextNaValue);

		return transactionContextFields;
	}
	

	@Override
	public Integer getEntriesReturned(LogAccessImageUrnResultsType res) 
	{
		return res.getImageUrns().length; 
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.web.commands.AbstractWebserviceCommand#translateRouterResult(java.lang.Object)
	 */
	@Override
	protected LogAccessImageUrnResultsType translateRouterResult(
			List<LogAccessImageUrnResult> routerResult)
	throws TranslationException, MethodException 
	{
		return ViewerImagingRestTranslator.translateLogAccessImageUrnResults(routerResult);
	}

	@Override
	protected Class<LogAccessImageUrnResultsType> getResultClass() {
		return LogAccessImageUrnResultsType.class;
	}

	


}


