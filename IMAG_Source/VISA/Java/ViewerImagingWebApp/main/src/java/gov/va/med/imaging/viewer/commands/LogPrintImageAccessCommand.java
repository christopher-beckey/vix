package gov.va.med.imaging.viewer.commands;

import gov.va.med.PatientIdentifier;
import gov.va.med.RoutingToken;
import gov.va.med.SERIALIZATION_FORMAT;
import gov.va.med.URNFactory;
import gov.va.med.exceptions.RoutingTokenFormatException;
import gov.va.med.imaging.AbstractImagingURN;
import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.exceptions.URNFormatException;
import gov.va.med.imaging.exchange.ImageAccessLogEvent;
import gov.va.med.imaging.exchange.RoutingTokenHelper;
import gov.va.med.imaging.exchange.ImageAccessLogEvent.ImageAccessLogEventType;
import gov.va.med.imaging.rest.types.RestBooleanReturnType;
import gov.va.med.imaging.viewer.ViewerImagingContext;
import gov.va.med.imaging.viewer.datasource.ViewerImagingTranslator;
import gov.va.med.imaging.viewer.rest.translator.ViewerImagingRestTranslator;
import gov.va.med.imaging.web.commands.WebserviceInputParameterTransactionContextField;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import gov.va.med.logging.Logger;

/**
 * @author vhaisltjahjb
 *
 */
public class LogPrintImageAccessCommand 
extends AbstractViewerImagingCommands<Boolean, RestBooleanReturnType>
{
	private Logger logger = Logger.getLogger(this.getClass());

	private final String interfaceVersion;
	private final String siteId;
	private final String imageUrn;
	private final String printReason;
	
	public LogPrintImageAccessCommand(String siteId, String imageUrn, String printReason, String interfaceVersion)
	{
		super("LogPrintImageAccessCommand");
		
		this.siteId = siteId;
		this.imageUrn = imageUrn;
		this.printReason = printReason;
		this.interfaceVersion = interfaceVersion;
	}

	@Override
	protected Boolean executeRouterCommand() 
	throws MethodException, ConnectionException 
	{
		try {
			AbstractImagingURN urn = URNFactory.create(
						getImageUrn(), SERIALIZATION_FORMAT.CDTP, AbstractImagingURN.class);

			boolean isDodImage = urn.isOriginDOD();		
			
			ImageAccessLogEvent event = 			
				new ImageAccessLogEvent(urn.getImagingIdentifier(), "", 
						PatientIdentifier.icnPatientIdentifier(urn.getPatientIdentifier()), 
						urn.getOriginatingSiteId(), System.currentTimeMillis(), 
						"P", getPrintReason(), ImageAccessLogEventType.IMAGE_PRINT, isDodImage, 
						getSiteId());
			
			ViewerImagingContext.getRouter().logImageAccessEvent(event);
			return true;
		} catch (URNFormatException e) {
			throw new MethodException(e);
		}
	}

	@Override
	protected String getMethodParameterValuesString()
	{
		return getSiteId() + "," + getImageUrn() + "," + getPrintReason();
	}

	@Override
	protected Class<RestBooleanReturnType> getResultClass() 
	{
		return RestBooleanReturnType.class;
	}

	@Override
	protected RestBooleanReturnType translateRouterResult(Boolean routerResult)
	{
    	return new RestBooleanReturnType(routerResult);
	}

	public String getSiteId()
	{
		return siteId;
	}

	public String getPrintReason()
	{
		return printReason;
	}

	public String getImageUrn()
	{
		return imageUrn;
	}

	@Override
	protected Map<WebserviceInputParameterTransactionContextField, String> getTransactionContextFields() {
		return null;
	}

	@Override
	public String getInterfaceVersion() {
		return interfaceVersion;
	}

	@Override
	public Integer getEntriesReturned(RestBooleanReturnType translatedResult) {
		return 1;
	}

}
