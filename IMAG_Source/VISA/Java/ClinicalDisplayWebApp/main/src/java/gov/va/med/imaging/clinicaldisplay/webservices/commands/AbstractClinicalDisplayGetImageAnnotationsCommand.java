/**
 * 
  Package: MAG - VistA Imaging
  WARNING: Per VHA Directive 2004-038, this routine should not be modified.
  Date Created: Jun 16, 2011
  Site Name:  Washington OI Field Office, Silver Spring, MD
  Developer:  VHAISWWERFEJ
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
package gov.va.med.imaging.clinicaldisplay.webservices.commands;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import gov.va.med.logging.Logger;

import gov.va.med.SERIALIZATION_FORMAT;
import gov.va.med.URNFactory;
import gov.va.med.imaging.AbstractImagingURN;
import gov.va.med.imaging.clinicaldisplay.ClinicalDisplayRouter;
import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.exchange.business.annotations.ImageAnnotation;
import gov.va.med.imaging.web.commands.WebserviceInputParameterTransactionContextField;

/**
 * @author VHAISWWERFEJ
 *
 */
public abstract class AbstractClinicalDisplayGetImageAnnotationsCommand<E extends Object>
extends AbstractClinicalDisplayWebserviceCommand<List<ImageAnnotation>, E>
{
	private final static Logger LOGGER = Logger.getLogger(AbstractClinicalDisplayGetImageAnnotationsCommand.class);
	private final String imageId;
	
	public AbstractClinicalDisplayGetImageAnnotationsCommand(String imageId)
	{
		super("getImageAnnotations");
		this.imageId = imageId;
	}

	public String getImageId()
	{
		return imageId;
	}

	@Override
	protected List<ImageAnnotation> executeRouterCommand()
	throws MethodException, ConnectionException
	{
		AbstractImagingURN imagingUrn = null;
		try
		{
			// create either a StudyURN or a BhieStudyURn depending on the community ID
			// found in the study ID string
			imagingUrn = URNFactory.create(getImageId(), SERIALIZATION_FORMAT.CDTP, AbstractImagingURN.class);
		}
		catch (Throwable x)
		{
			String msg = "AbstractClinicalDisplayGetImageAnnotationsCommand.executeRouterCommand() --> --> Encountered exception: " + x.getMessage();
			LOGGER.error(msg);
			throw new MethodException(msg, x);
		}		
		ClinicalDisplayRouter rtr = getRouter(); 
		getTransactionContext().setPatientID(imagingUrn.getPatientId());
		return rtr.getImageAnnotations(imagingUrn);
	}

	@Override
	protected String getMethodParameterValuesString()
	{
		return "for image '" + getImageId() + "'.";
	}

	@Override
	protected Map<WebserviceInputParameterTransactionContextField, String> getTransactionContextFields()
	{
		Map<WebserviceInputParameterTransactionContextField, String> transactionContextFields = 
			new HashMap<WebserviceInputParameterTransactionContextField, String>();
		
		transactionContextFields.put(WebserviceInputParameterTransactionContextField.quality, transactionContextNaValue);
		transactionContextFields.put(WebserviceInputParameterTransactionContextField.urn, getImageId());
		transactionContextFields.put(WebserviceInputParameterTransactionContextField.queryFilter, transactionContextNaValue);

		return transactionContextFields;
	}
}