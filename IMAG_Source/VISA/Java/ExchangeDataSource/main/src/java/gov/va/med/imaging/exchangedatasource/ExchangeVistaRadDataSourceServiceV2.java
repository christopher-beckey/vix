/**
 * 
  Package: MAG - VistA Imaging
  WARNING: Per VHA Directive 2004-038, this routine should not be modified.
  Date Created: Oct 12, 2010
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
package gov.va.med.imaging.exchangedatasource;

import java.util.List;

import gov.va.med.logging.Logger;

import gov.va.med.GlobalArtifactIdentifier;
import gov.va.med.PatientIdentifier;
import gov.va.med.RoutingToken;
import gov.va.med.imaging.StudyURN;
import gov.va.med.imaging.artifactsource.ResolvedArtifactSource;
import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.datasource.VistaRadDataSourceSpi;
import gov.va.med.imaging.datasource.exceptions.UnsupportedProtocolException;
import gov.va.med.imaging.exceptions.URNFormatException;
import gov.va.med.imaging.exchange.business.ResolvedSite;
import gov.va.med.imaging.exchange.business.StudyFilter;
import gov.va.med.imaging.exchange.business.StudySetResult;
import gov.va.med.imaging.exchange.business.vistarad.ActiveExams;
import gov.va.med.imaging.exchange.business.vistarad.Exam;
import gov.va.med.imaging.exchange.business.vistarad.ExamImages;
import gov.va.med.imaging.exchange.business.vistarad.ExamListResult;
import gov.va.med.imaging.exchange.business.vistarad.PatientRegistration;
import gov.va.med.imaging.exchange.enums.StudyLoadLevel;
import gov.va.med.imaging.transactioncontext.TransactionContextFactory;
import gov.va.med.imaging.url.exchange.translator.ExchangeVistaRadTranslator;

/**
 * @author vhaiswwerfej
 *
 */
public class ExchangeVistaRadDataSourceServiceV2
extends ExchangeStudyGraphDataSourceServiceV2
implements VistaRadDataSourceSpi
{
	private final static Logger logger = Logger.getLogger(ExchangeVistaRadDataSourceServiceV2.class);
	
	/**
     * The Provider will use the create() factory method preferentially
     * over a constructor.  This allows for caching of VistaStudyGraphDataSourceService
     * instances according to the criteria set here.
     * 
     * @param url
     * @param site
     * @return
     * @throws ConnectionException
     * @throws UnsupportedProtocolException 
     */
    public static ExchangeVistaRadDataSourceServiceV2 create(ResolvedArtifactSource resolvedArtifactSource, String protocol)
    throws ConnectionException, UnsupportedProtocolException
    {
    	return new ExchangeVistaRadDataSourceServiceV2(resolvedArtifactSource, protocol);
    }
	
	public ExchangeVistaRadDataSourceServiceV2(ResolvedArtifactSource resolvedArtifactSource, String protocol)
	throws UnsupportedProtocolException
	{
		super(resolvedArtifactSource, protocol);
		if(! (resolvedArtifactSource instanceof ResolvedSite) )
			throw new UnsupportedOperationException("The artifact source must be an instance of ResolvedSite and it is a '" + resolvedArtifactSource.getClass().getSimpleName() + "'.");
	}
	
	/* (non-Javadoc)
	 * @see gov.va.med.imaging.datasource.VistaRadDataSourceSpi#getActiveExams(java.lang.String)
	 */
	@Override
	public ActiveExams getActiveExams(RoutingToken globalRoutingToken, String listDescriptor)
	throws MethodException, ConnectionException 
	{	
		return null;
	}
	
	/* (non-Javadoc)
	 * @see gov.va.med.imaging.datasource.VistaRadDataSourceSpi#getExamImagesForExam(gov.va.med.imaging.StudyURN)
	 */
	@Override
	public ExamImages getExamImagesForExam(StudyURN studyUrn)
	throws MethodException, ConnectionException 
	{
        logger.info("getExamImagesForExam({}, {}) started", studyUrn.toString(), TransactionContextFactory.get().getDisplayIdentity());
		
		Exam exam = getExam(studyUrn.getPatientId(), studyUrn);
		return exam.getImages();
	}	

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.datasource.VistaRadDataSourceSpi#getExam(gov.va.med.imaging.StudyURN)
	 */
	@Override
	public Exam getExam(StudyURN studyUrn) 
	throws MethodException, ConnectionException 
	{
        logger.info("getExam({}, {}) started", studyUrn.toString(), TransactionContextFactory.get().getDisplayIdentity());
		
		Exam exam = getExam(studyUrn.getPatientId(), studyUrn);
		return exam;
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.datasource.VistaRadDataSourceSpi#getExamReport(gov.va.med.imaging.StudyURN)
	 */
	@Override
	public String getExamReport(StudyURN studyUrn) 
	throws MethodException, ConnectionException 
	{
        logger.info("getExamReport({}, {}) started", studyUrn.toString(), TransactionContextFactory.get().getDisplayIdentity());
		PatientIdentifier patientIdentifier = PatientIdentifier.icnPatientIdentifier(studyUrn.getPatientId());
		return this.getStudyReport(patientIdentifier, studyUrn);
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.datasource.VistaRadDataSourceSpi#getExamRequisitionReport(gov.va.med.imaging.StudyURN)
	 */
	@Override
	public String getExamRequisitionReport(StudyURN studyUrn)
	throws MethodException, ConnectionException 
	{
		return "";
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.datasource.VistaRadDataSourceSpi#getExamsForPatient(java.lang.String, boolean)
	 */
	@Override
	public ExamListResult getExamsForPatient(RoutingToken globalRoutingToken, String patientICN,
		boolean fullyLoadExams, boolean forceRefresh, boolean forceImagesFromJb, final String ... genericParameters)
	throws MethodException, ConnectionException 
	{
        logger.info("getExamsForPatient({}, {}) started", patientICN, TransactionContextFactory.get().getDisplayIdentity());
		return getExams(patientICN, null, fullyLoadExams);		
	}
	
	private Exam getExam(String patientIcn, GlobalArtifactIdentifier studyId)
	throws MethodException, ConnectionException
	{	
		ExamListResult result = getExams(patientIcn, studyId, true);
		if((result != null) && (result.getArtifacts() != null))
		{
			List<Exam> exams = result.getArtifacts();
			if(exams.size() > 1)
			{
				logger.warn("Got more than 1 study from DoD when specified study Id, should not happen!");
				for(Exam exam : exams)
				{				
					if(exam.getExamId().equals(studyId))
					{
						return exam;
					}
				}
				throw new MethodException("Did not find exam '" + studyId + "' in result set from DoD.");
			}
			return exams.get(0);
		}
		throw new MethodException("null studies returned for study Id '" + studyId + "'");
	}
	
	private ExamListResult getExams(String patientIcn, GlobalArtifactIdentifier studyId, boolean fullyLoadExams)
	throws MethodException, ConnectionException 
	{
		StudyFilter filter = null;
		if(studyId != null)
		{
			filter = new StudyFilter(studyId);
		}
		else
		{
			filter = new StudyFilter();
		}
		// study load level matters a bit now since ExchangeV2 doesn't alwasy get the report. If not fully loaded
		// then get study  and image data without reports.  If fullyLoadExams then get reports
		StudyLoadLevel studyLoadLevel = StudyLoadLevel.STUDY_AND_IMAGES;
		if(fullyLoadExams)
			studyLoadLevel = StudyLoadLevel.FULL;
		PatientIdentifier patientIdentifier = PatientIdentifier.icnPatientIdentifier(patientIcn);
		StudySetResult result = this.getPatientStudies(studyId, patientIdentifier, filter, studyLoadLevel);
		try
		{
			return ExchangeVistaRadTranslator.translate(result);
		}
		catch(URNFormatException urnfX)
		{
			throw new MethodException("Error translating URN", urnfX);
		}	
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.datasource.VistaRadDataSourceSpi#getNextPatientRegistration()
	 */
	@Override
	public PatientRegistration getNextPatientRegistration(RoutingToken globalRoutingToken)
	throws MethodException, ConnectionException 
	{
		return null;
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.datasource.VistaRadDataSourceSpi#getRelevantPriorCptCodes(java.lang.String)
	 */
	@Override
	public String[] getRelevantPriorCptCodes(RoutingToken globalRoutingToken, String cptCode)
	throws MethodException, ConnectionException 
	{
		return new String [0];
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.datasource.VistaRadDataSourceSpi#postExamAccessEvent(java.lang.String)
	 */
	@Override
	public boolean postExamAccessEvent(RoutingToken globalRoutingToken, String inputParameter)
	throws MethodException, ConnectionException 
	{
		logger.info("image accessed to DoD, not logging.");
		return false;
	}
}
