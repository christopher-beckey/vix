/**
 * 
  Package: MAG - VistA Imaging
  WARNING: Per VHA Directive 2004-038, this routine should not be modified.
  Date Created: Jan 2, 2013
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
package gov.va.med.imaging.study.commands;

import java.util.HashMap;
import java.util.Map;

import gov.va.med.SERIALIZATION_FORMAT;
import gov.va.med.URNFactory;
import gov.va.med.imaging.StudyURN;
import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.exceptions.URNFormatException;
import gov.va.med.imaging.exchange.business.Study;
import gov.va.med.imaging.exchange.business.StudyFilter;
import gov.va.med.imaging.exchange.translation.exceptions.TranslationException;
import gov.va.med.imaging.rest.types.RestStringType;
import gov.va.med.imaging.study.StudyFacadeRouter;
import gov.va.med.imaging.transactioncontext.TransactionContext;
import gov.va.med.imaging.web.commands.WebserviceInputParameterTransactionContextField;

/**
 * @author VHAISWWERFEJ
 * @author VHAISPNGUYEQ: reworked for VAI-1202
 *
 */
public class StudyGetStudyReportCommand
extends AbstractStudyCommand<String, RestStringType> {
	
	private final String studyId;
	private final StudyFilter studyFilter;

	/**
	 * @param String 		study Id
	 */
	public StudyGetStudyReportCommand(String studyId) {
		
		this(studyId, null);
	}

	/**
	 * NEED THIS
	 * 
	 * @param String 		study Id
	 * @param StudyFilter   StudyFilter object
	 */
	public StudyGetStudyReportCommand(String studyId, StudyFilter studyFilter) {
		
		super("StudyGetStudyReportCommand");
		this.studyId = studyId;
		this.studyFilter = studyFilter;
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.web.commands.AbstractWebserviceCommand#executeRouterCommand()
	 */
	@Override
	protected String executeRouterCommand() 
	throws MethodException, ConnectionException {
		
		checkCommandEnabled();
		StudyURN studyUrn = null;
		
		try {
			// create either a StudyURN or a BhieStudyURn depending on the community ID
			// found in the study ID string
			studyUrn = URNFactory.create(studyId, SERIALIZATION_FORMAT.CDTP, StudyURN.class);
		} catch (URNFormatException x) {
			String errMsg = "StudyGetStudyReportCommand --> Encountered [URNFormatException] while trying to create a StudyURN from study Id [" + studyId + "]";
			getLogger().error(errMsg);
			throw new MethodException(errMsg);
		}
		
		String reportResult = null;
		TransactionContext txContext = getTransactionContext();
		txContext.setPatientID(((StudyURN) studyUrn).getPatientId());

		StudyFacadeRouter router = getRouter();
		if(router == null) {
			String errMsg = "StudyGetStudyReportCommand --> Could not get an instance of StudyFacadeRouter. Can't proceed.";
			getLogger().error(errMsg);
			throw new MethodException(errMsg);
		}
		
		// VAI-1202: Always null. Better to create here than in the end point
		StudyFilter newStudyFilter = new StudyFilter(studyUrn);
		newStudyFilter.setIncludeMuseOrders(false);
		
		//Always lands in "if" and will go to the same method in the back end
		Study study = router.getStudy((StudyURN) studyUrn, newStudyFilter);
		
		if(study != null) {
			txContext.setFacadeBytesSent(study.getRadiologyReport() == null ? 0L : study.getRadiologyReport().length());
			reportResult = study.getRadiologyReport();
		} else {
			getLogger().info("StudyGetStudyReportCommand --> No study matched given study Id [" + studyId + "] from router. Return 'null' for report.");
		}
		
		return reportResult;
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.web.commands.AbstractWebserviceCommand#getMethodParameterValuesString()
	 */
	@Override
	protected String getMethodParameterValuesString() {
		
		return "for study Id [" + getStudyId() + "]";
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.web.commands.AbstractWebserviceCommand#translateRouterResult(java.lang.Object)
	 */
	@Override
	protected RestStringType translateRouterResult(String routerResult)
	throws TranslationException, MethodException {
		
		return new RestStringType(routerResult);
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.web.commands.AbstractWebserviceCommand#getResultClass()
	 */
	@Override
	protected Class<RestStringType> getResultClass() {
		
		return RestStringType.class;
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.web.commands.AbstractWebserviceCommand#getTransactionContextFields()
	 */
	@Override
	protected Map<WebserviceInputParameterTransactionContextField, String> getTransactionContextFields() {
		
		Map<WebserviceInputParameterTransactionContextField, String> txContextFields = 
				new HashMap<WebserviceInputParameterTransactionContextField, String>();
			
		txContextFields.put(WebserviceInputParameterTransactionContextField.quality, transactionContextNaValue);
		txContextFields.put(WebserviceInputParameterTransactionContextField.urn, getStudyId());
		txContextFields.put(WebserviceInputParameterTransactionContextField.queryFilter, transactionContextNaValue);

		return txContextFields;
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.web.commands.AbstractWebserviceCommand#getEntriesReturned(java.lang.Object)
	 */
	@Override
	public Integer getEntriesReturned(RestStringType translatedResult) {
		
		return null;
	}

	@Override
	protected boolean isRequiresEnterprise() {
		
		return false;
	}

	@Override
	protected boolean isRequiresLocal() {
		
		return false;
	}
	/**
	 * @return String the studyId
	 */
	public String getStudyId() {
		
		return this.studyId;
	}
	
	public StudyFilter getStudyFilter() {
		
		return this.studyFilter;
	}

}
