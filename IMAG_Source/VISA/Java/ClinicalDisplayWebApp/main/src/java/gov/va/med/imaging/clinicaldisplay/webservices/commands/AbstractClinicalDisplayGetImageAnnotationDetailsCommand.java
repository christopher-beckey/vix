/**
 * 
  Package: MAG - VistA Imaging
  WARNING: Per VHA Directive 2004-038, this routine should not be modified.
  Date Created: Jun 17, 2011
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

import gov.va.med.SERIALIZATION_FORMAT;
import gov.va.med.URNFactory;
import gov.va.med.imaging.AbstractImagingURN;
import gov.va.med.imaging.ImageAnnotationURN;
import gov.va.med.imaging.clinicaldisplay.ClinicalDisplayRouter;
import gov.va.med.imaging.clinicaldisplay.webservices.ClinicalDisplayWebservices_v2;
import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.exchange.business.annotations.ImageAnnotationDetails;
import gov.va.med.imaging.web.commands.WebserviceInputParameterTransactionContextField;

import java.util.HashMap;
import java.util.Map;

import gov.va.med.logging.Logger;

/**
 * @author VHAISWWERFEJ
 *
 */
public abstract class AbstractClinicalDisplayGetImageAnnotationDetailsCommand<E extends Object>
extends AbstractClinicalDisplayWebserviceCommand<ImageAnnotationDetails, E>
{
	private final static Logger LOGGER = Logger.getLogger(AbstractClinicalDisplayGetImageAnnotationDetailsCommand.class);
	private final String imageAnnotationId;
	private final String imageId;
	
	public AbstractClinicalDisplayGetImageAnnotationDetailsCommand(String imageId, 
			String imageAnnotationId)
	{
		super("getImageAnnotationDetails");
		this.imageAnnotationId = imageAnnotationId;
		this.imageId = imageId;
	}

	public String getImageAnnotationId()
	{
		return imageAnnotationId;
	}

	public String getImageId()
	{
		return imageId;
	}

	@Override
	protected ImageAnnotationDetails executeRouterCommand()
	throws MethodException, ConnectionException
	{
		ImageAnnotationURN imageAnnotationUrn = null;
		AbstractImagingURN imagingUrn = null;
		try
		{
			// create either a StudyURN or a BhieStudyURn depending on the community ID
			// found in the study ID string
			imageAnnotationUrn = URNFactory.create(getImageAnnotationId(), 
					SERIALIZATION_FORMAT.CDTP, ImageAnnotationURN.class);
			imagingUrn = URNFactory.create(getImageId(),
					SERIALIZATION_FORMAT.CDTP, AbstractImagingURN.class);
		}
		catch (Throwable x)
		{
			String msg = "AbstractClinicalDisplayGetImageAnnotationDetailsCommand.executeRouterCommand() --> Encountered exception: " + x.getMessage();
			LOGGER.error(msg);
			throw new MethodException(msg, x);
		}		
		ClinicalDisplayRouter rtr = getRouter(); 
		getTransactionContext().setPatientID(imageAnnotationUrn.getPatientId());
		return rtr.getImageAnnotationDetails(imagingUrn, imageAnnotationUrn);
	}

	@Override
	protected String getMethodParameterValuesString()
	{
		return "for image annotation '" + getImageAnnotationId() + "'.";
	}

	@Override
	protected Map<WebserviceInputParameterTransactionContextField, String> getTransactionContextFields()
	{
		Map<WebserviceInputParameterTransactionContextField, String> transactionContextFields = 
			new HashMap<WebserviceInputParameterTransactionContextField, String>();
		
		transactionContextFields.put(WebserviceInputParameterTransactionContextField.quality, transactionContextNaValue);
		transactionContextFields.put(WebserviceInputParameterTransactionContextField.urn, getImageAnnotationId());
		transactionContextFields.put(WebserviceInputParameterTransactionContextField.queryFilter, transactionContextNaValue);

		return transactionContextFields;
	}
}
