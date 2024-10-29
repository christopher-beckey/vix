/**
 * 
  Package: MAG - VistA Imaging
  WARNING: Per VHA Directive 2004-038, this routine should not be modified.
  Date Created: Jun 20, 2011
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
package gov.va.med.imaging.federation.commands.imageannotations;

import java.util.HashMap;
import java.util.Map;

import gov.va.med.URNFactory;
import gov.va.med.imaging.AbstractImagingURN;
import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.exceptions.URNFormatException;
import gov.va.med.imaging.exchange.business.annotations.ImageAnnotation;
import gov.va.med.imaging.exchange.business.annotations.ImageAnnotationSource;
import gov.va.med.imaging.exchange.translation.exceptions.TranslationException;
import gov.va.med.imaging.federation.FederationRouter;
import gov.va.med.imaging.federation.commands.AbstractFederationCommand;
import gov.va.med.imaging.federation.rest.translator.FederationRestTranslator;
import gov.va.med.imaging.federation.rest.types.FederationImageAnnotationSourceType;
import gov.va.med.imaging.federation.rest.types.FederationImageAnnotationType;
import gov.va.med.imaging.web.commands.WebserviceInputParameterTransactionContextField;

/**
 * @author VHAISWWERFEJ
 *
 */
public class FederationImageAnnotationPostImageAnnotationCommand
extends AbstractFederationCommand<ImageAnnotation, FederationImageAnnotationType>
{
	private final String imageId;
	private final String version;
	private final String annotationDetails;
	private final FederationImageAnnotationSourceType annotationSource;
	private final String interfaceVersion;
	
	public FederationImageAnnotationPostImageAnnotationCommand(String imageId,
			String annotationDetails, String version, FederationImageAnnotationSourceType annotationSource, String interfaceVersion)
	{
		super("postImageAnnotation");
		this.imageId = imageId;
		this.annotationDetails = annotationDetails;
		this.version = version;
		this.annotationSource = annotationSource;
		this.interfaceVersion = interfaceVersion;
	}

	@Override
	protected ImageAnnotation executeRouterCommand() 
	throws MethodException, ConnectionException
	{
		try
		{
			AbstractImagingURN imagingUrn = 
				URNFactory.create(getImageId(), AbstractImagingURN.class);
			getTransactionContext().setPatientID(imagingUrn.getPatientId());
			FederationRouter router = getRouter();
			ImageAnnotationSource imageAnnotationSource = 
				FederationRestTranslator.translate(getAnnotationSource()); 
			ImageAnnotation result = 
				router.storeImageAnnotation(imagingUrn, getAnnotationDetails(), getVersion(), 
						imageAnnotationSource);
            getLogger().info("{}, transaction({}) got {} ImageAnnotation business object from router.", getMethodName(), getTransactionId(), result == null ? "null" : "not null");
			return result;
		}
		catch (URNFormatException urnfX)
		{
			throw new MethodException(urnfX);
		}
	}

	@Override
	protected String getMethodParameterValuesString()
	{
		return "image (" + getImageId() + ").";
	}

	@Override
	protected FederationImageAnnotationType translateRouterResult(
			ImageAnnotation routerResult) 
	throws TranslationException, MethodException
	{
		return FederationRestTranslator.translate(routerResult);
	}

	@Override
	protected Class<FederationImageAnnotationType> getResultClass()
	{
		return FederationImageAnnotationType.class;
	}

	@Override
	protected Map<WebserviceInputParameterTransactionContextField, String> getTransactionContextFields()
	{
		Map<WebserviceInputParameterTransactionContextField, String> transactionContextFields = 
			new HashMap<WebserviceInputParameterTransactionContextField, String>();
		
		transactionContextFields.put(WebserviceInputParameterTransactionContextField.quality, transactionContextNaValue);
		transactionContextFields.put(WebserviceInputParameterTransactionContextField.urn, getImageId());
		transactionContextFields.put(WebserviceInputParameterTransactionContextField.queryFilter, transactionContextNaValue);
		// patient ID set later

		return transactionContextFields;
	}

	@Override
	public void setAdditionalTransactionContextFields()
	{
		
	}

	@Override
	public String getInterfaceVersion()
	{
		return interfaceVersion;
	}

	@Override
	public Integer getEntriesReturned(
			FederationImageAnnotationType translatedResult)
	{
		return translatedResult == null ? 0 : 1;
	}

	public String getImageId()
	{
		return imageId;
	}

	public String getVersion()
	{
		return version;
	}

	public String getAnnotationDetails()
	{
		return annotationDetails;
	}

	public FederationImageAnnotationSourceType getAnnotationSource()
	{
		return annotationSource;
	}
}
