/**
 * 
  Package: MAG - VistA Imaging
  WARNING: Per VHA Directive 2004-038, this routine should not be modified.
  Date Created: Oct 1, 2012
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
import gov.va.med.imaging.study.StudyFacadeRouter;
import gov.va.med.imaging.study.rest.translator.RestStudyTranslator;
import gov.va.med.imaging.study.rest.types.LoadedStudyType;
import gov.va.med.imaging.web.commands.WebserviceInputParameterTransactionContextField;

/**
 * @author VHAISWWERFEJ
 *
 */
public class StudyGetStudyCommand
extends AbstractStudyCommand<Study, LoadedStudyType> {
	
	private final String studyId;
	private final StudyFilter studyFilter;

	/**
	 * @param String 		study Id
	 */
	public StudyGetStudyCommand(String studyId) {
		
		this(studyId, null);
	}

	/**
	 * NEED THIS
	 * 
	 * @param String 		study Id
	 * @param StudyFilter   StudyFilter object
	 */
	public StudyGetStudyCommand(String studyId, StudyFilter studyFilter) {
		
		super("StudyGetStudyCommand");
		this.studyId = studyId;
		this.studyFilter = studyFilter;
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.web.commands.AbstractWebserviceCommand#executeRouterCommand()
	 */
	@Override
	protected Study executeRouterCommand() 
	throws MethodException, ConnectionException
	{
		checkCommandEnabled();
		StudyURN studyUrn = null;
		
		try {
			// create either a StudyURN or a BhieStudyURn depending on the community ID
			// found in the study ID string
			studyUrn = URNFactory.create(studyId, SERIALIZATION_FORMAT.CDTP, StudyURN.class);
		} catch (URNFormatException x) {
			String errMsg = "StudyGetStudyCommand -- > Encountered [URNFormatException] while trying to create a StudyURN from study Id [" + studyId + "]";
			getLogger().error(errMsg);
			throw new MethodException(errMsg);
		}
		
		StudyFacadeRouter router = getRouter();
		if(router == null) {
			String errMsg = "StudyGetStudyCommand --> Could not get an instance of StudyFacadeRouter. Can't proceed.";
			getLogger().error(errMsg);
			throw new MethodException(errMsg);
		}
		
		// VAI-1202: Always null. Better to create here than in the end point
		StudyFilter newStudyFilter = new StudyFilter(studyUrn);
		newStudyFilter.setIncludeMuseOrders(false);
		
		return router.getStudy((StudyURN) studyUrn, newStudyFilter);
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.web.commands.AbstractWebserviceCommand#getMethodParameterValuesString()
	 */
	@Override
	protected String getMethodParameterValuesString()
	{
		return "for study [" + getStudyId() + "]";
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.web.commands.AbstractWebserviceCommand#translateRouterResult(java.lang.Object)
	 */
	@Override
	protected LoadedStudyType translateRouterResult(Study routerResult)
	throws TranslationException, MethodException
	{
		return RestStudyTranslator.translateLoadedStudy(routerResult);
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.web.commands.AbstractWebserviceCommand#getResultClass()
	 */
	@Override
	protected Class<LoadedStudyType> getResultClass()
	{
		return LoadedStudyType.class;
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
			transactionContextFields.put(WebserviceInputParameterTransactionContextField.urn, getStudyId());
			transactionContextFields.put(WebserviceInputParameterTransactionContextField.queryFilter, transactionContextNaValue);

			return transactionContextFields;
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.web.commands.AbstractWebserviceCommand#getEntriesReturned(java.lang.Object)
	 */
	@Override
	public Integer getEntriesReturned(LoadedStudyType translatedResult) {
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
	 * @return String	the study Id
	 */
	public String getStudyId() {
		return studyId;
	}

	public StudyFilter getStudyFilter() {
		return this.studyFilter;
	}

}
