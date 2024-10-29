package gov.va.med.imaging.vistaimagingdatasource;

import gov.va.med.PatientIdentifier;
import gov.va.med.RoutingToken;
import gov.va.med.imaging.artifactsource.ResolvedArtifactSource;
import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.datasource.PatientArtifactDataSourceSpi;
import gov.va.med.imaging.exchange.business.ArtifactResults;
import gov.va.med.imaging.exchange.business.StudyFilter;
import gov.va.med.imaging.exchange.business.StudySetResult;
import gov.va.med.imaging.exchange.enums.StudyLoadLevel;

public class VistaImagingPatientArtifactDataSourceServiceV4 
extends VistaImagingStudyGraphDataSourceServiceV3
implements PatientArtifactDataSourceSpi {

	public VistaImagingPatientArtifactDataSourceServiceV4(ResolvedArtifactSource resolvedArtifactSource,
			String protocol) {
		super(resolvedArtifactSource, protocol);
	}

	@Override
	public ArtifactResults getPatientArtifacts(RoutingToken globalRoutingToken, PatientIdentifier patientIdentifier,
			StudyFilter studyFilter, StudyLoadLevel studyLoadLevel, boolean includeImages, boolean includeDocuments)
			throws MethodException, ConnectionException {
		StudySetResult studySetResult = getPatientStudies(globalRoutingToken, patientIdentifier, 
				studyFilter, studyLoadLevel);
		return ArtifactResults.createStudySetResult(studySetResult);
	}

}
