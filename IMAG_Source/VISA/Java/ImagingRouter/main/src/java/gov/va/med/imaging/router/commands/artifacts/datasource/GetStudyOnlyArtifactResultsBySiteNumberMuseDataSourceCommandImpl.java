package gov.va.med.imaging.router.commands.artifacts.datasource;

import java.net.URL;

import gov.va.med.PatientIdentifier;
import gov.va.med.RoutingToken;
import gov.va.med.imaging.exchange.business.StudyFilter;
import gov.va.med.imaging.exchange.enums.StudyLoadLevel;

/**
 * 	@author William Peterson
 * 
 * 
 */
public class GetStudyOnlyArtifactResultsBySiteNumberMuseDataSourceCommandImpl
		extends AbstractArtifactResultsBySiteNumberDataSourceCommandImpl {

	
	private static final long serialVersionUID = 1L;
	
	private final static StudyLoadLevel studyLoadLevel = StudyLoadLevel.STUDY_ONLY;
	
	private final static String MUSE_PROTOCOL = "muse";

	
	public GetStudyOnlyArtifactResultsBySiteNumberMuseDataSourceCommandImpl(
			RoutingToken routingToken, 
			PatientIdentifier patientIdentifier, 
			StudyFilter filter, 
			boolean includeRadiology,
			boolean includeDocuments)	
		{
			super(routingToken, patientIdentifier, filter, studyLoadLevel, includeRadiology, includeDocuments);
			getLogger().debug("hitting GetStudyOnlyArtifactResultsBySiteNumberMuseDataSourceCommand.");
		}
	
	@Override
    protected String getProtocol(URL url){
		getLogger().debug("Hitting the overridden getProtocol method for Muse.");
    	return MUSE_PROTOCOL;
    }


}
