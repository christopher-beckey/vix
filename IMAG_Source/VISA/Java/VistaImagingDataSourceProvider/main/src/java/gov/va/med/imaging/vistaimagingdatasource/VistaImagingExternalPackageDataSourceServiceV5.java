/**
 * 
 */
package gov.va.med.imaging.vistaimagingdatasource;

import gov.va.med.PatientIdentifier;
import gov.va.med.RoutingToken;
import gov.va.med.imaging.CprsIdentifier;
import gov.va.med.imaging.StringUtil;
import gov.va.med.imaging.CprsIdentifier.CprsIdentifierType;
import gov.va.med.imaging.artifactsource.ResolvedArtifactSource;
import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.datasource.exceptions.InvalidCredentialsException;
import gov.va.med.imaging.exceptions.URNFormatException;
import gov.va.med.imaging.exchange.business.Image;
import gov.va.med.imaging.exchange.business.Series;
import gov.va.med.imaging.exchange.business.Site;
import gov.va.med.imaging.exchange.business.Study;
import gov.va.med.imaging.exchange.business.StudyFilter;
import gov.va.med.imaging.exchange.enums.StudyDeletedImageState;
import gov.va.med.imaging.exchange.enums.StudyLoadLevel;
import gov.va.med.imaging.exchange.translation.exceptions.TranslationException;
import gov.va.med.imaging.protocol.vista.VistaImagingTranslator;
import gov.va.med.imaging.transactioncontext.TransactionContextFactory;
import gov.va.med.imaging.url.vista.StringUtils;
import gov.va.med.imaging.url.vista.VistaQuery;
import gov.va.med.imaging.url.vista.exceptions.InvalidVistaCredentialsException;
import gov.va.med.imaging.url.vista.exceptions.VistaMethodException;
import gov.va.med.imaging.vistadatasource.common.VistaCommonUtilities;
import gov.va.med.imaging.vistadatasource.session.VistaSession;
import gov.va.med.imaging.vistaimagingdatasource.common.VistaImagingCommonUtilities;
import gov.va.med.imaging.vistaobjects.CprsIdentifierImages;
import gov.va.med.imaging.vistaobjects.VistaGroup;
import gov.va.med.imaging.vistaobjects.VistaImage;

import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.SortedSet;
import java.util.TreeSet;

/**
 * @author vhaisltjahjb
 *
 */
//WFP-Need to add this to appropriate resource gatherer.
public class VistaImagingExternalPackageDataSourceServiceV5 
extends VistaImagingExternalPackageDataSourceServiceV4 
{

	public final static String MAG_REQUIRED_VERSION = "3.0P185";

	/**
	 * @param resolvedArtifactSource
	 * @param protocol
	 */
	public VistaImagingExternalPackageDataSourceServiceV5(
			ResolvedArtifactSource resolvedArtifactSource, String protocol) {
		super(resolvedArtifactSource, protocol);
	}
	
	/* (non-Javadoc)
	 * @see gov.va.med.imaging.vistadatasource.AbstractBaseVistaExternalPackageDataSourceService#getRequiredVistaImagingVersion()
	 */
	@Override
	protected String getRequiredVistaImagingVersion() 
	{
		return VistaImagingCommonUtilities.getVistaDataSourceImagingVersion(
				VistaImagingDataSourceProvider.getVistaConfiguration(), this.getClass(), 
				MAG_REQUIRED_VERSION);
	}

	@Override
	protected String getDataSourceVersion()
	{
		return "5";
	}


	/* (non-Javadoc)
	 * @see gov.va.med.imaging.datasource.ExternalPackageDataSourceSpi#getViewerStudiesForQaReviewgov.va.med.RoutingToken, gov.va.med.imaging.exchange.business.StudyFilter)
	 */
	@Override
	public List<Study> postViewerStudiesForQaReview(
			RoutingToken globalRoutingToken,
			StudyFilter filter) 
	throws MethodException,ConnectionException
	{
		getLogger().debug("...executing postViewerStudiesForQaReview method in V5.");
		VistaCommonUtilities.setDataSourceMethodAndVersion("postViewerStudiesForQaReview", getDataSourceVersion());
		VistaSession vistaSession;
		try {
			vistaSession = getVistaSession();
		} catch (IOException e) {
            getLogger().error("getVistaSession error: {}", e.getMessage());
			throw new ConnectionException(e.getMessage());
		}

		// Note: a Study has 1.. Groups and a Group can have 1.. Series!
		SortedSet<VistaGroup> groups = getPatientGroups(vistaSession, getSite(), filter);
        getLogger().info("Found {} groups for qareview", groups.size());
		// no groups is not an exception scenario but it does mean we don't need to bother getting more 
		// information about each study
		if(groups.size() == 0)
			return null;
		
		// JMW 12/17/2008, call the filter to remove studies from the groups, this way
		// the datasource doesn't need to have knowledge of the filter details
		if(filter != null)
			filter.preFilter(groups);
		
		// if we filtered everything out return now, and don't bother making the call
		// to populate the entire Studies tree
		if(groups.size() == 0)
			return null;
		
		getLogger().info("Loading study graph data for filtered groups");

		//Sorted by patient
		Map<PatientIdentifier, SortedSet<VistaGroup>> patientVistaGroupMap = new HashMap<PatientIdentifier, SortedSet<VistaGroup>>();
		for(VistaGroup group : groups)
		{
			PatientIdentifier pid = group.getPatientIdentifier();
			SortedSet<VistaGroup> patientGroups = patientVistaGroupMap.get(pid);
			if (patientGroups == null)
				patientGroups = new TreeSet<VistaGroup>();
			patientGroups.add(group);
			patientVistaGroupMap.put(group.getPatientIdentifier(), patientGroups);
		}

		List<Study> result = new ArrayList<Study>();
		try 
		{
			for(PatientIdentifier patientIdentifier : patientVistaGroupMap.keySet())
			{
				String dfn = VistaCommonUtilities.getPatientDfn(
							vistaSession, 
							patientIdentifier);
				SortedSet<VistaGroup> pgroups = patientVistaGroupMap.get(patientIdentifier);
				List<Study> studies = getPatientStudies(vistaSession, dfn, pgroups, filter);
				if (studies != null) 
					result.addAll(studies);
			}
		} 
		catch (IOException e) 
		{
            getLogger().error("getVistaSession error: {}", e.getMessage());
			throw new MethodException(e.getMessage());
		}
		
		return result;
	}
		
	private List<Study> getPatientStudies(
			VistaSession vistaSession,
			String patientDfn, 
			SortedSet<VistaGroup> groups, 
			StudyFilter filter) 
	{
		// Warning: if this filter (and studyIen) is not null, reducedGroup might truncate multiple group studies!!!
		Map<String, String> studyMap = new HashMap<String, String>();

		// Build a list of Study IEN
		// The use of a Map is an artifact of VistA, which needs an index of the list elements.
		// The Map ends up as something like {"0", "662576753"},{"1", "761576512"} ...
		StringBuilder groupMessage = new StringBuilder();
		groupMessage.append('{');
		for(VistaGroup group : groups)
		{
			// CTB 29Nov2009
			//studyMap.put("" + studyMap.size(), Base32ConversionUtility.base32Decode(group.getIen()));
			studyMap.put( Integer.toString(studyMap.size()), group.getIen() );

			if(groupMessage.length() > 1)
				groupMessage.append(',');
			groupMessage.append(group.getIen());
		}
		groupMessage.append('}');
		
		//
		boolean includesDeletedImages = (filter == null ? false : filter.isIncludeDeleted());
		boolean canIncludeDeletedImages = canRetrieveDeletedImages(); // if this data source cannot support getting deleted images, then it is not an option
		StudyDeletedImageState studyDeletedImageState = StudyDeletedImageState.cannotIncludeDeletedImages;
		if(canIncludeDeletedImages) // if the DS supports getting deleted images, set appropriately based on user request
			studyDeletedImageState = (includesDeletedImages ? StudyDeletedImageState.includesDeletedImages : StudyDeletedImageState.doesNotIncludeDeletedImages);
		
		SortedSet<Study> studies;
		try {
			studies = getPatientStudyGraph(vistaSession, studyMap, patientDfn, 
					StudyLoadLevel.STUDY_AND_IMAGES, studyDeletedImageState);
		} catch (MethodException e) {
            getLogger().error("getPatientStudies Method Exception: {}", e.getMessage());
			return null;

		} catch (ConnectionException e) {
            getLogger().error("getPatientStudies Connection Exception: {}", e.getMessage());
			return null;
		}
        getLogger().info("getPatientStudyGraph for studies {} returned {} studies.", groupMessage.toString(), studies.size());
		
		SortedSet<Study> result = 
			VistaImagingCommonUtilities.mergeStudyLists(vistaSession, studies, groups, StudyLoadLevel.STUDY_AND_IMAGES);
        getLogger().info("Merging studies and groups results in {} studies.", result.size());
		
		// JMW 12/17/2008, call the filter to remove studies from the groups, this way
		// the datasource doesn't need to have knowledge of the filter details
		if(filter != null)
		{
			filter.postFilter(result);
		}

        getLogger().info("Completed getPatientStudies(), returning '{}' studies.", result.size());
		return new ArrayList<Study>(result);
    }
	
	
	private SortedSet<VistaGroup> getPatientGroups(
			VistaSession vistaSession,
			Site site,
			StudyFilter filter) 
	throws MethodException
	{
		String rtn = null;
		try
		{
			VistaQuery vm = VistaImagingQueryFactory.createMagImageListQuery(filter);
			rtn = vistaSession.call(vm);

			// check to be sure first character is a 1 (means result is ok)
			// if no images for patient, response is [0^No images for filter: All Images]
			
			if(rtn.charAt(0) == '1') 
			{			
				boolean includesDeletedImages = (filter == null ? false : filter.isIncludeDeleted());
				boolean canIncludeDeletedImages = canRetrieveDeletedImages(); // if this data source cannot support getting deleted images, then it is not an option
				StudyDeletedImageState studyDeletedImageState = StudyDeletedImageState.cannotIncludeDeletedImages;
				if(canIncludeDeletedImages) // if the DS supports getting deleted images, set appropriately based on user request
					studyDeletedImageState = (includesDeletedImages ? StudyDeletedImageState.includesDeletedImages : StudyDeletedImageState.doesNotIncludeDeletedImages);
				return VistaImagingTranslator.createGroupsFromGroupLines(getSite(), rtn, studyDeletedImageState);
			}
			else if(rtn.startsWith("0^No images for filter")) 
			{
				getLogger().info("0 response from getPatientGroupsVistaQuery() rpc, no images found");
				throw new VistaMethodException(rtn);
			}
			else if(rtn.startsWith("0^No Such Patient:")) 
			{
				getLogger().info("0 response from getPatientGroupsVistaQuery() rpc");
				throw new VistaMethodException(rtn);
			}
			else 
			{
				getLogger().info("0 response from getPatientGroupsVistaQuery() rpc");
				throw new VistaMethodException(rtn);
			}
		}
		catch (Exception ex)
		{
			getLogger().error(ex);
			throw new MethodException(ex);
		}
	}
	
    private SortedSet<Study> getPatientStudyGraph(
        	VistaSession localVistaSession, 
        	Map<String, String> studyMap, 
        	String patientDfn, 
        	StudyLoadLevel studyLoadLevel,
        	StudyDeletedImageState studyDeletedImageState)
    throws MethodException, ConnectionException
    {    	
    	try
    	{
	    	VistaQuery query = getPatientStudyGraphVistaQuery(studyMap, patientDfn, studyLoadLevel, 
	    			studyDeletedImageState);
            getLogger().info("Retrieving study graph for patient containing '{}' groups", studyMap.size());
			String vistaResponse = localVistaSession.call(query);
			getLogger().debug("Completed study graph RPC call, parsing response...");
			
			SortedSet<Study> studies = VistaImagingTranslator.createStudiesFromGraph(getSite(), 
					vistaResponse, studyLoadLevel, studyDeletedImageState);
            getLogger().info("Converted response into '{}' studies", (studies == null) ? 0 : studies.size());
			return studies;
    	}
		catch (Exception ex)
		{
			getLogger().error(ex);
			throw new MethodException(ex);
		}
    }

	private VistaQuery getPatientStudyGraphVistaQuery(Map<String, String> studyMap, String patientDfn,
			StudyLoadLevel studyLoadLevel, StudyDeletedImageState studyDeletedImageState) 
	{
		// this version does uses the studyDeletedImageState
    	return VistaImagingQueryFactory.createGetStudiesByIenVistaQuery(studyMap, 
    			patientDfn, studyLoadLevel, studyDeletedImageState);
    	}

	
}