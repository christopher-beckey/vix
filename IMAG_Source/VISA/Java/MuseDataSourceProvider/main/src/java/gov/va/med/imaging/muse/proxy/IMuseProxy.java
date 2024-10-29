package gov.va.med.imaging.muse.proxy;

import gov.va.med.PatientIdentifier;
import gov.va.med.RoutingToken;
import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.InsufficientPatientSensitivityException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.exchange.business.ArtifactResults;
import gov.va.med.imaging.exchange.business.Site;
import gov.va.med.imaging.exchange.business.StudyFilter;
import gov.va.med.imaging.exchange.enums.StudyLoadLevel;


/**
 *  @author William Peterson
 **/
public interface IMuseProxy {


	public ArtifactResults getPatientArtifacts(Site site, PatientIdentifier patientIdentifier, StudyFilter filter, 
			RoutingToken routingToken, StudyLoadLevel studyLoadLevel, boolean includeImages, boolean includeDocuments)
			throws InsufficientPatientSensitivityException, MethodException, ConnectionException;

}
