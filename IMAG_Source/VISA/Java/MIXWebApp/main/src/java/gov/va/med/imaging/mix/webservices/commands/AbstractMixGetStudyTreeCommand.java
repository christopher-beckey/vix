/**
 * 
  Package: MAG - VistA Imaging
  WARNING: Per VHA Directive 2004-038, this routine should not be modified.
  Date Created: Dec 2, 2016
  Site Name:  Washington OI Field Office, Silver Spring, MD
  Developer:  vacotittoc
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
package gov.va.med.imaging.mix.webservices.commands;

import java.text.ParseException;
import java.util.HashMap;
import java.util.Map;

import gov.va.med.GlobalArtifactIdentifier;
import gov.va.med.GlobalArtifactIdentifierFactory;
// import gov.va.med.PatientIdentifier;
import gov.va.med.RoutingToken;
import gov.va.med.exceptions.RoutingTokenFormatException;
import gov.va.med.imaging.BhieStudyURN; // go DODImageURN!!!
import gov.va.med.imaging.StudyURN;
import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.mix.MixRouter;
import gov.va.med.imaging.exceptions.URNFormatException;
import gov.va.med.imaging.exchange.RoutingTokenHelper;
import gov.va.med.imaging.exchange.business.Study;
import gov.va.med.imaging.exchange.business.StudyFilter;
import gov.va.med.imaging.exchange.business.StudySetResult;
import gov.va.med.imaging.exchange.translation.exceptions.TranslationException;
import gov.va.med.imaging.mix.webservices.rest.types.v1.ImagingStudy;
import gov.va.med.imaging.mix.webservices.rest.types.v1.StudyType;
import gov.va.med.imaging.mix.webservices.translator.v1.MixTranslator;
// import gov.va.med.imaging.mix.webservices.translator.v1.MixTranslatorV1;
// import gov.va.med.imaging.tomcat.vistarealm.PreemptiveAuthorization.Result;
import gov.va.med.imaging.web.commands.WebserviceInputParameterTransactionContextField;

/**
 * @author vacotittoc
 *
 */
public abstract class AbstractMixGetStudyTreeCommand<E extends Object>
extends AbstractMixWebserviceCommand<Study, E>
//extends AbstractMixWebserviceCommand<ImagingStudy, E>
{
	private final String studyId; // the MIX interface passes the VA studyURN in the studyUid field!
	
	public AbstractMixGetStudyTreeCommand(String studyUid)
	{
		super("GetStudySetResultWithImagesBySiteNumberCommand");
		this.studyId = studyUid;
	}

	@Override
	protected Study executeRouterCommand() 
//	protected ImagingStudy executeRouterCommand() 
	throws MethodException, ConnectionException
	{
		GlobalArtifactIdentifier studyUrn;
		try
		{
			// create either a StudyURN or a BhieStudyURn depending on the community ID
			// found in the study ID string
			studyUrn = GlobalArtifactIdentifierFactory.create(studyId, StudyURN.class, BhieStudyURN.class);
		}
		catch (Throwable x)
		{
			getLogger().error(x);
			throw new MethodException(x);
		}
		RoutingToken routingToken=null;
		try {
			routingToken = RoutingTokenHelper.createSiteAppropriateRoutingToken(((StudyURN) studyUrn).getOriginatingSiteId());
		}
		catch (RoutingTokenFormatException rtfe) {
			throw new MethodException("Error creating RoutingToken for " + ((StudyURN) studyUrn).getOriginatingSiteId());
		}
		StudySetResult studyTree = null;
		StudyFilter studyFilter = new StudyFilter();
		studyFilter.setStudyId(((StudyURN)studyUrn));
		MixRouter rtr = getRouter(); 
		if(studyUrn instanceof StudyURN)
		{
			// update the transaction context with patientId
			getTransactionContext().setPatientID(((StudyURN)studyUrn).getPatientId());
			
			studyTree = rtr.getPatientStudySetResultWithImages(routingToken,
				((StudyURN)studyUrn).getThePatientIdentifier(),	studyFilter);
//			throws MethodException, ConnectionException;
		}
//		else if(studyUrn instanceof BhieStudyURN) -- not a case for DOD servimg!
//		{
//			// update the transaction context with patientId
//			getTransactionContext().setPatientID(((BhieStudyURN)studyUrn).getPatientId());
//			//TODO: change to use a command that does not require a fully loaded study (when that is supported from the cache)
//			study = rtr.getPatientStudy((BhieStudyURN)studyUrn);
//		}
		
		// return the first Study
		
		// Fortify change: check for null first
    	// OLD:
		//Study study = studyTree.getArtifacts().first();
		//return study;
		
		return (studyTree != null && studyTree.getArtifacts() != null ? studyTree.getArtifacts().first() : null);
		
//		Study study = studyTree.getArtifacts().first();
//		StudyType studyType = new StudyType();
//		try {
//			studyType = translateRouterResult(study);
//		}
//		catch (TranslationException te) {
//			throw new MethodException("StudyType conversion to ImagingStudy failed: " + te.getMessage());
//		}
//		return studyType;
		
//		// convert StudySetResult info to Study Type
//		Study study = studyTree.getArtifacts().first();
//		ImagingStudy imagingStudy = new ImagingStudy();
//		try {
//			imagingStudy = translateStudyTypeToImagingStudy(study);
//		}
//		catch (TranslationException te) {
//			throw new MethodException("StudyType conversion to ImagingStudy failed: " + te.getMessage());
//		}
//		return imagingStudy;
	}

	@Override
	protected String getMethodParameterValuesString()
	{
		return "for study '" + studyId + "'.";
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
	
//	protected StudyType translateRouterResult(Study routerResult)
//	throws TranslationException
//	{
//		StudyType studyType = null;
//		try {
//			studyType = MixTranslator.transformStudy(routerResult);
//		}
//		catch (URNFormatException ufe) {
//			throw new TranslationException(ufe.getMessage());
//		}
//		catch (ParseException pe) {
//			throw new TranslationException(pe.getMessage());
//		}
//		return studyType;
//	}

//	protected ImagingStudy translateStudyTypeToImagingStudy(Study study)
//	throws TranslationException
//	{
//		ImagingStudy imagingStudy = null;
//		try {
//			imagingStudy = MixTranslator.translateStudy(study);
//		}
//		catch (URNFormatException ufe) {
//			throw new TranslationException(ufe.getMessage());
//		}
//		catch (ParseException pe) {
//			throw new TranslationException(pe.getMessage());
//		}
//		return imagingStudy;
//	}
}
