/**
 * 
  Package: MAG - VistA Imaging
  WARNING: Per VHA Directive 2004-038, this routine should not be modified.
  Date Created: Mar 16, 2012
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
package gov.va.med.imaging.study;

import gov.va.med.PatientIdentifier;
import gov.va.med.RoutingToken;
import gov.va.med.imaging.BhieStudyURN;
import gov.va.med.imaging.CprsIdentifier;
import gov.va.med.imaging.StudyURN;
import gov.va.med.imaging.core.annotations.routerfacade.FacadeRouterInterface;
import gov.va.med.imaging.core.annotations.routerfacade.FacadeRouterInterfaceCommandTester;
import gov.va.med.imaging.core.annotations.routerfacade.FacadeRouterMethod;
import gov.va.med.imaging.core.interfaces.FacadeRouter;
import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.exchange.business.ArtifactResults;
import gov.va.med.imaging.exchange.business.StoredStudyFilter;
import gov.va.med.imaging.exchange.business.Study;
import gov.va.med.imaging.exchange.business.StudyFilter;

import java.util.List;

/**
 * @author VHAISWWERFEJ
 *
 */
@FacadeRouterInterface
@FacadeRouterInterfaceCommandTester
public interface StudyFacadeRouter
extends FacadeRouter
{

	@FacadeRouterMethod(asynchronous=false, commandClassName="GetStudyOnlyArtifactResultsBySiteNumberCommand")
	public abstract ArtifactResults getShallowArtifactResultsForPatientFromSite(RoutingToken routingToken,
		PatientIdentifier patientIdentifier, 
		StudyFilter filter, 
		boolean includeRadiology, 
		boolean includeDocuments)
	throws MethodException, ConnectionException;
	
	/** VAI-1202: new methods for backward compatibility --> added StudyFilter type object to skip MUSE calls as appropriate */
	
	@FacadeRouterMethod(asynchronous=false, commandClassName="GetStudyCommand")
	public abstract Study getStudy(StudyURN studyUrn, StudyFilter filter)
	throws MethodException, ConnectionException;
	
	@FacadeRouterMethod(asynchronous=false, commandClassName="GetStudyCommand")
	public abstract Study getPatientStudy(BhieStudyURN studyUrn, StudyFilter filter)
	throws MethodException, ConnectionException;
	
	/* VAI-1202: ends */
	
	@FacadeRouterMethod(asynchronous=false, commandClassName="GetStudyCommand")
	public abstract Study getStudy(StudyURN studyUrn)
	throws MethodException, ConnectionException;
	
	@FacadeRouterMethod(asynchronous=false, commandClassName="GetStudyCommand")
	public abstract Study getPatientStudy(BhieStudyURN studyUrn)
	throws MethodException, ConnectionException;
	
	@FacadeRouterMethod(asynchronous=false, commandClassName="GetStudyOnlyArtifactResultsForPatientCommand")
	public abstract ArtifactResults getStudyOnlyArtifactResultsForPatient(RoutingToken patientTreatingSiteRoutingToken,
			PatientIdentifier patientIdentifier, StudyFilter studyFilter,
			boolean includeRadiology, boolean includeDocuments)
	throws MethodException, ConnectionException;
	
	@FacadeRouterMethod(asynchronous=false, commandClassName="GetStoredFiltersCommand")
	public abstract List<StoredStudyFilter> getStoredFilters(RoutingToken routingToken)
	throws MethodException, ConnectionException;
	
	@FacadeRouterMethod(asynchronous=false, commandClassName="GetStudiesByCprsIdentifierCommand")
	public abstract List<Study> getStudiesByCprsIdentifier(String patientIcn, 
		RoutingToken routingToken, CprsIdentifier cprsIdentifier)
	throws MethodException, ConnectionException;
	
	@FacadeRouterMethod(asynchronous=false, commandClassName="GetStudyWithReportArtifactResultsBySiteNumberCommand")
	public abstract ArtifactResults getStudyAndReportArtifactResultsForPatient(RoutingToken patientTreatingSiteRoutingToken,
			PatientIdentifier patientIdentifier, StudyFilter studyFilter,
			boolean includeRadiology, boolean includeDocuments)
	throws MethodException, ConnectionException;

	@FacadeRouterMethod(asynchronous=false, commandClassName="GetStudyListBySiteCommand")
	public abstract List<Study> getFullStudiesForPatientAtSite(RoutingToken routingToken,
																   PatientIdentifier patientIdentifier,
																   StudyFilter studyFilter)
			throws MethodException, ConnectionException;


}
