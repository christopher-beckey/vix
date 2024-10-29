/**
 * 
  Package: MAG - VistA Imaging
  WARNING: Per VHA Directive 2004-038, this routine should not be modified.
  Date Created: Oct 15, 2010
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
package gov.va.med.imaging.datasource;

import gov.va.med.PatientIdentifier;
import gov.va.med.RoutingToken;
import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.datasource.annotations.SPI;
import gov.va.med.imaging.exchange.business.ArtifactResults;
import gov.va.med.imaging.exchange.business.StudyFilter;
import gov.va.med.imaging.exchange.enums.StudyLoadLevel;

/**
 * @author vhaiswwerfej
 *
 */
@SPI(description="Get patient artifacts (documents and images).")
public interface PatientArtifactDataSourceSpi
extends VersionableDataSourceSpi
{
	
	/**
	 * 
	 * @param patientIcn
	 * @param studyFilter
	 * @param studyLoadLevel
	 * @param includeImages Determines if Radiology images should be included in the result
	 * @param includeDocuments Determines if Documents should be included in the result
	 * @return
	 * @throws MethodException
	 * @throws ConnectException
	 */
	public abstract ArtifactResults getPatientArtifacts(RoutingToken globalRoutingToken,
			PatientIdentifier patientIdentifier, StudyFilter studyFilter, StudyLoadLevel studyLoadLevel, 
			boolean includeImages, boolean includeDocuments)
	throws MethodException, ConnectionException;

}