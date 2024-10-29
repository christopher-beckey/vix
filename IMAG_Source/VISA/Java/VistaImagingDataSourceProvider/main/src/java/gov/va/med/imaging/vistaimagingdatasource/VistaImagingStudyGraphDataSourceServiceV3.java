package gov.va.med.imaging.vistaimagingdatasource;

import java.io.IOException;
import java.util.Map;
import java.util.SortedSet;

import gov.va.med.logging.Logger;

import gov.va.med.imaging.artifactsource.ResolvedArtifactSource;
import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.datasource.exceptions.UnsupportedProtocolException;
import gov.va.med.imaging.exchange.business.Study;
import gov.va.med.imaging.exchange.business.StudyFilter;
import gov.va.med.imaging.exchange.enums.StudyDeletedImageState;
import gov.va.med.imaging.exchange.enums.StudyLoadLevel;
import gov.va.med.imaging.protocol.vista.VistaImagingTranslator;
import gov.va.med.imaging.url.vista.StringUtils;
import gov.va.med.imaging.url.vista.VistaQuery;
import gov.va.med.imaging.url.vista.exceptions.InvalidVistaCredentialsException;
import gov.va.med.imaging.url.vista.exceptions.VistaMethodException;
import gov.va.med.imaging.vistadatasource.session.VistaSession;
import gov.va.med.imaging.vistaimagingdatasource.common.VistaImagingCommonUtilities;

public class VistaImagingStudyGraphDataSourceServiceV3 
extends VistaImagingStudyGraphDataSourceService {

	public final static String MAG_REQUIRED_VERSION = "3.0P197";
	private Logger logger = Logger.getLogger(VistaImagingStudyGraphDataSourceServiceV3.class);

	
	public VistaImagingStudyGraphDataSourceServiceV3(ResolvedArtifactSource resolvedArtifactSource, String protocol) {
		super(resolvedArtifactSource, protocol);
	}
	
	public static VistaImagingStudyGraphDataSourceServiceV3 create(ResolvedArtifactSource resolvedArtifactSource, String protocol)
	throws ConnectionException, UnsupportedProtocolException
	{
		return new VistaImagingStudyGraphDataSourceServiceV3(resolvedArtifactSource, protocol);
	}
	
    /**
     * 
     * @param localVistaSession
     * @param studyMap
     * @param patientDfn
     * @param studyLoadLevel
     * @return
     * @throws MethodException
     * @throws ConnectionException
     */
	@Override
    protected SortedSet<Study> getPatientStudyGraphFromBothDataStructures(
    	VistaSession localVistaSession, 
    	Map<String, String> studyMap, 
    	String patientDfn, 
    	StudyFilter filter,
    	StudyLoadLevel studyLoadLevel,
    	StudyDeletedImageState studyDeletedImageState)
	throws MethodException, ConnectionException
    {    	
    	try
    	{
	    	VistaQuery query = getPatientStudyGraphFromBothDataStructuresVistaQuery(studyMap, patientDfn, filter, studyLoadLevel, studyDeletedImageState);

            logger.info("Retrieving study graph for patient containing [{}] groups", studyMap.size());
			
			String vistaResponse = localVistaSession.call(query);
			logger.info("Completed study graph RPC call, parsing response...");				
			
			SortedSet<Study> studies = VistaImagingTranslator.createFilteredStudiesFromGraph(getSite(), 
					vistaResponse, studyLoadLevel, filter, studyDeletedImageState);

            logger.info("Converted response into [{}] study(ies)", (studies == null) ? 0 : studies.size());
			
			return studies;
    	}
		catch (Exception ex)
		{
			logger.error(ex);
			ex.printStackTrace();
			throw new MethodException(ex);
		}
    }
	
	
	@Override
	protected String getRequiredVistaImagingVersion()
	{
		return VistaImagingCommonUtilities.getVistaDataSourceImagingVersion(
				VistaImagingDataSourceProvider.getVistaConfiguration(), 
				this.getClass(), 
				MAG_REQUIRED_VERSION);
	}

	@Override
	protected VistaQuery getPatientGroupsVistaQuery(VistaSession vistaSession, String patientDfn, StudyFilter studyFilter)
	throws IOException, InvalidVistaCredentialsException, VistaMethodException
	{
		// JMW 4/20/2012 P119
		// include the option for deleted images
		if(studyFilter != null)
			studyFilter.clearStoredStudyFilterIfNecessary(getSite().getSiteNumber());
		
		return VistaImagingCommonUtilities.createMagImageListQuery(vistaSession, patientDfn, studyFilter, true);
	}
	
	

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.vistaimagingdatasource.VistaImagingStudyGraphDataSourceService#getPatientStudyGraphVistaQuery(java.util.Map, java.lang.String, gov.va.med.imaging.exchange.enums.StudyLoadLevel, gov.va.med.imaging.exchange.enums.StudyDeletedImageState)
	 */
	@Override
	protected VistaQuery getPatientStudyGraphVistaQuery(
			Map<String, String> studyMap, String patientDfn,
			StudyLoadLevel studyLoadLevel,
			StudyDeletedImageState studyDeletedImageState) 
	{
		// override to include the study deleted image state to use to determine if deleted images should be included in the result
		// this version does uses the studyDeletedImageState
    	return VistaImagingQueryFactory.createGetStudiesByIenVistaQuery(studyMap, 
    			patientDfn, studyLoadLevel, studyDeletedImageState);
    
	}

	@Override
	protected boolean canRetrieveDeletedImages()
	{
		return true;
	}

	@Override
	protected String getDataSourceVersion()
	{
		return "4";
	}
}
