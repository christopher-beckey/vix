/**
 * 
  Package: MAG - VistA Imaging
  WARNING: Per VHA Directive 2004-038, this routine should not be modified.
  Date Created: Mar 22, 2012
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
package gov.va.med.imaging.roi.commands;

import java.util.HashMap;
import java.util.Map;
import java.util.ArrayList;
import java.util.List;

import gov.va.med.PatientIdentifier;
import gov.va.med.SERIALIZATION_FORMAT;
import gov.va.med.StudyURNFactory;
import gov.va.med.URNFactory;
import gov.va.med.imaging.P34StudyURN;
import gov.va.med.imaging.StudyURN;
import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.exceptions.URNFormatException;
import gov.va.med.imaging.exchange.translation.exceptions.TranslationException;
import gov.va.med.imaging.roi.ROIWorkItem;
import gov.va.med.imaging.roi.queue.AbstractExportQueueURN;
import gov.va.med.imaging.roi.rest.translator.ROIRestTranslator;
import gov.va.med.imaging.roi.rest.types.ROIRequestType;
import gov.va.med.imaging.transactioncontext.TransactionContext;
import gov.va.med.imaging.url.vista.StringUtils;
import gov.va.med.imaging.web.commands.WebserviceInputParameterTransactionContextField;
import gov.va.med.imaging.roi.CCPHeader;

import com.thoughtworks.xstream.XStream;
import com.thoughtworks.xstream.XStreamException;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;


/**
 * @author VHAISWWERFEJ
 *
 */
public class ROIQueueStudiesCommand
extends AbstractROICommand<ROIWorkItem, ROIRequestType>
{
	private final String [] studyIds;
	private final String queueId;
	private final String ccpHeadersXml;
	private final String includeNonDicom;
	private final String includeReport;
	private Logger logger = LogManager.getLogger(this.getClass());
	
	/**
	 * 
	 * @param studyIds Caret delimited string of study URNs
	 */
	public ROIQueueStudiesCommand(String studyIds, String queueId)
	{
		super("queueStudies");
		this.studyIds = StringUtils.Split(studyIds, StringUtils.CARET);
		this.queueId = queueId;
		this.ccpHeadersXml = null;
		this.includeNonDicom = null;
		this.includeReport = null;
	}
	
	public ROIQueueStudiesCommand(String studyIds)
	{
		this(studyIds, null);
	}
	
	public String getQueueId()
	{
		return queueId;
	}

	/**
	 * 
	 * @param patientId Patient ICN
	 * @param siteId Site Number
	 * @param studyIensString Caret delimited string of study IENs (not Study URNs)
	 * @throws MethodException
	 */
	public ROIQueueStudiesCommand(PatientIdentifier patientIdentifier, String siteId, String studyIensString, 
			String queueId, String ccpHeadersXml, String includeNonDicom, String includeReport)
	throws MethodException
	{
		super("queueStudies");
		try
		{
			// try to make a study URN out of each study IEN to validate the input
			String [] studyIens = StringUtils.Split(studyIensString, StringUtils.CARET);
			studyIds = new String[studyIens.length];
			StudyURN []urns = new StudyURN[studyIens.length];
			Boolean isNewDataStructure = false; 
			for(int i = 0; i < studyIens.length; i++)
			{
				isNewDataStructure =  studyIens[i].startsWith("N");
				if(isNewDataStructure){
					urns[i] = StudyURNFactory.create(siteId, studyIens[i].substring(1), patientIdentifier.getValue(), P34StudyURN.class);			
				} else {
					urns[i] = StudyURNFactory.create(siteId, studyIens[i], patientIdentifier.getValue(), StudyURN.class);
				}
				urns[i].setPatientIdentifierType(patientIdentifier.getPatientIdentifierType());
				studyIds[i] = urns[i].toStringCDTP();
			}			
		}
		catch(URNFormatException urnfX)
		{
			throw new MethodException("URNFormatException parsing studyIEN input, " + urnfX.getMessage());
		}
		this.queueId = queueId;
		this.ccpHeadersXml = ccpHeadersXml;
		this.includeNonDicom = includeNonDicom;
		this.includeReport = includeReport;
	}
	
	public ROIQueueStudiesCommand(PatientIdentifier patientIdentifier, String siteId, String studyIensString, String queueId)
	throws MethodException
	{
		this(patientIdentifier, siteId, studyIensString, queueId, null, null, null);
	}
	
	public ROIQueueStudiesCommand(PatientIdentifier patientIdentifier, String siteId, String studyIensString)
	throws MethodException
	{
		this(patientIdentifier, siteId, studyIensString, null);
	}

	public String[] getStudyIds()
	{
		return studyIds;
	}

	@Override
	protected ROIWorkItem executeRouterCommand() 
	throws MethodException, ConnectionException
	{
		List<CCPHeader> ccpHeaders = null;
		
		if (ccpHeadersXml != null)
		{
			XStream xstream = new XStream();
			xstream.alias("ccpHeaders", List.class);
			xstream.alias("ccpHeader", CCPHeader.class);
	    	ccpHeaders = (List<CCPHeader>)xstream.fromXML(ccpHeadersXml);
	    	for(CCPHeader header : ccpHeaders) {
	    		logger.debug("ccpHeader: " + header.getHeader());
	    	}
		}
		
		StudyURN []studyUrns = new StudyURN[getStudyIds().length];
		try
		{
			TransactionContext transactionContext = getTransactionContext();
			for(int i = 0; i < getStudyIds().length; i++)
			{
				studyUrns[i] = URNFactory.create(studyIds[i],SERIALIZATION_FORMAT.CDTP);
				if(i == 0)
					transactionContext.setPatientID(studyUrns[i].getPatientId());
			}
			if(getQueueId() != null && getQueueId().length() > 0)
			{
				AbstractExportQueueURN exportQueueUrn = URNFactory.create(getQueueId());
				if (ccpHeaders == null)
				{
					return getRouter().processReleaseOfInformationRequest(studyUrns, exportQueueUrn);
				}
				else
				{
					return getRouter().processReleaseOfInformationRequest(studyUrns, exportQueueUrn, ccpHeaders, includeNonDicom, includeReport);
				}
			}
			else
			{
				return getRouter().processReleaseOfInformationRequest(studyUrns);
			}
		}
		catch(URNFormatException iurnfX)
		{
			throw new MethodException("URNFormatException, unable to queue ROI request", iurnfX);
		}
	}

	@Override
	protected String getMethodParameterValuesString()
	{
		StringBuilder sb = new StringBuilder();
		for(int i = 0; i < getStudyIds().length; i++)
		{
			if(i > 0)
				sb.append(", ");
			sb.append(getStudyIds()[i]);
		}
		
		return "for studies '" + sb.toString() + "'.";
	}

	@Override
	protected ROIRequestType translateRouterResult(ROIWorkItem routerResult)
	throws TranslationException, MethodException
	{
		return ROIRestTranslator.translate(routerResult);
	}

	@Override
	protected Class<ROIRequestType> getResultClass()
	{
		return ROIRequestType.class;
	}

	@Override
	protected Map<WebserviceInputParameterTransactionContextField, String> getTransactionContextFields()
	{
		Map<WebserviceInputParameterTransactionContextField, String> transactionContextFields = 
			new HashMap<WebserviceInputParameterTransactionContextField, String>();
		
		transactionContextFields.put(WebserviceInputParameterTransactionContextField.quality, transactionContextNaValue);
		//transactionContextFields.put(WebserviceInputParameterTransactionContextField.urn, getStudyId());
		transactionContextFields.put(WebserviceInputParameterTransactionContextField.queryFilter, transactionContextNaValue);

		return transactionContextFields;
	}

	@Override
	public Integer getEntriesReturned(ROIRequestType translatedResult)
	{
		return translatedResult == null ? 0 : 1;
	}
}
