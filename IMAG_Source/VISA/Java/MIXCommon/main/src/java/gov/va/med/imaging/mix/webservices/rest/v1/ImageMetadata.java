/**
 * ImageMetadata.java
 *
 * in Exchange this interface file was auto-generated from WSDL
 * by the Apache Axis 1.4 Apr 22, 2006 (06:55:48 PDT) WSDL2Java emitter.
 * 
 * for MIX FHIR RESTfull metadata service (a CVIX only service) this is the client interface
 * and implemented in MIXDataSource as ImageMixMetadataImpl.java
 * 
 * @author vacotittoc
 */

package gov.va.med.imaging.mix.webservices.rest.v1;

// import gov.va.med.imaging.mix.webservices.rest.types.v1.RequestorTypePurposeOfUse;
// import gov.va.med.imaging.mix.webservices.rest.types.v1.StudyType;
import gov.va.med.imaging.mix.webservices.rest.exceptions.*;
import gov.va.med.imaging.mix.webservices.rest.types.v1.FilterType;
import gov.va.med.imaging.mix.webservices.rest.types.v1.ReportStudyListResponseType;
import gov.va.med.imaging.mix.webservices.rest.types.v1.ReportType;
import gov.va.med.imaging.mix.webservices.rest.types.v1.RequestorType;
import gov.va.med.imaging.mix.webservices.rest.v1.ImageMetadata;

 public interface ImageMetadata {
    public ReportStudyListResponseType getPatientReportStudyList(String datasource, RequestorType reqtor,
    		FilterType filtr, String patId, Boolean fullTree, String transactId, String requestedSite) 
			throws MIXMetadataException;
    public ReportType getPatientReport(String datasource, RequestorType reqtor,
    		String patId,  String studyId, String transactId) // DICOM Study UID expected for client call, not studyUrn.toString(SERIALIZATION_FORMAT.NATIVE)!
			throws MIXMetadataException;
 }
