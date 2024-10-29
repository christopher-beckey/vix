/**
 * 
  Package: MAG - VistA Imaging
  WARNING: Per VHA Directive 2004-038, this routine should not be modified.
  Date Created: Jun 4, 2010
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
package gov.va.med.imaging.clinicaldisplay.webservices.commands;

import java.util.HashMap;
import java.util.Map;

import gov.va.med.logging.Logger;

import gov.va.med.SERIALIZATION_FORMAT;
import gov.va.med.URNFactory;
import gov.va.med.imaging.BhieStudyURN;
import gov.va.med.imaging.StudyURN;
import gov.va.med.imaging.clinicaldisplay.ClinicalDisplayRouter;
import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.exchange.business.Study;
import gov.va.med.imaging.web.commands.WebserviceInputParameterTransactionContextField;

/**
 * @author vhaiswwerfej
 *
 */
public abstract class AbstractClinicalDisplayGetStudyImageListCommand<E extends Object>
extends AbstractClinicalDisplayWebserviceCommand<Study, E>
{
	private final static Logger LOGGER = Logger.getLogger(AbstractClinicalDisplayGetStudyImageListCommand.class);
	private final String studyId;
	private final boolean includeDeletedmages;
	
	public AbstractClinicalDisplayGetStudyImageListCommand(String studyId)
	{
		this(studyId, false);
	}
	
	public AbstractClinicalDisplayGetStudyImageListCommand(String studyId, 
			boolean includeDeletedImages)
	{
		super("getStudyImageList");
		this.studyId = studyId;
		this.includeDeletedmages = includeDeletedImages;
	}

	@Override
	protected Study executeRouterCommand() 
	throws MethodException, ConnectionException
	{
		StudyURN studyUrn = null;
		try
		{
			// create either a StudyURN or a BhieStudyURn depending on the community ID
			// found in the study ID string
			studyUrn = URNFactory.create(studyId, SERIALIZATION_FORMAT.CDTP, StudyURN.class);
		}
		catch (Throwable x)
		{
			String msg = "AbstractClinicalDisplayGetStudyImageListCommand.executeRouterCommand() --> Encountered exception: " + x.getMessage();
			LOGGER.error(msg);
			throw new MethodException(msg, x);
		}
		Study study = null;
		
		ClinicalDisplayRouter rtr = getRouter(); 
		if(studyUrn instanceof StudyURN)
		{
			// update the transaction context with patientId
			getTransactionContext().setPatientID(((StudyURN)studyUrn).getPatientId());
			study = rtr.getPatientStudyWithDeletedImages((StudyURN)studyUrn, 
					isIncludeDeletedmages());
		}
		else if(studyUrn instanceof BhieStudyURN)
		{
			// update the transaction context with patientId
			getTransactionContext().setPatientID(((BhieStudyURN)studyUrn).getPatientId());
			study = rtr.getPatientStudy((BhieStudyURN)studyUrn);
		}
		
		return study;
	}

	@Override
	protected String getMethodParameterValuesString()
	{
		return "for study '" + getStudyId() + "'.";
	}

	@Override
	protected Map<WebserviceInputParameterTransactionContextField, String> getTransactionContextFields()
	{
		Map<WebserviceInputParameterTransactionContextField, String> transactionContextFields = 
			new HashMap<WebserviceInputParameterTransactionContextField, String>();
		
		transactionContextFields.put(WebserviceInputParameterTransactionContextField.quality, transactionContextNaValue);
		transactionContextFields.put(WebserviceInputParameterTransactionContextField.urn, getStudyId());
		transactionContextFields.put(WebserviceInputParameterTransactionContextField.queryFilter, transactionContextNaValue);

		return transactionContextFields;
	}

	public String getStudyId()
	{
		return studyId;
	}

	public boolean isIncludeDeletedmages()
	{
		return includeDeletedmages;
	}
}
