/*
 * Created on May 3, 2005
// Per VHA Directive 2004-038, this routine should not be modified.
//+---------------------------------------------------------------+
//| Property of the US Government.                                |
//| No permission to copy or redistribute this software is given. |
//| Use of unreleased versions of this software requires the user |
//| to execute a written test agreement with the VistA Imaging    |
//| Development Office of the Department of Veterans Affairs,     |
//| telephone (301) 734-0100.                                     |
//|                                                               |
//| The Food and Drug Administration classifies this software as  |
//| a medical device.  As such, it may not be changed in any way. |
//| Modifications to this software may result in an adulterated   |
//| medical device under 21CFR820, the use of which is considered |
//| to be a violation of US Federal Statutes.                     |
//+---------------------------------------------------------------+
 *
 */
package gov.va.med.imaging.business.interfaces;

import gov.va.med.imaging.business.exceptions.AETitleAuthenticationException;
import gov.va.med.imaging.business.exceptions.DICOMGatewayConfigurationException;
import gov.va.med.imaging.business.exceptions.ImagingDataInternalException;
import gov.va.med.imaging.exchange.business.dicom.DicomAE;
import gov.va.med.imaging.exchange.business.dicom.DicomMap;

import java.util.HashSet;

/**
 * @author Csaba Titton
 *
 * TODO To change the template for this generated type comment go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
public interface DicomConfigurationFacade {

    /**
	 * Queries persistent DICOM map for particular map table. Each returned entry
	 * represents one DICOM tag value and prescribes its mapping to single or multiple
	 * entity filed(s).
	 * @param  operation
	 *         DICOM operation ("C-STORE", "C-FIND", ...)
	 * @param  sopClass
	 *         the DICOM SOP Class the operation applies to
	 * @param  direction
	 *         "IN" if DICOM to persistance, "OUT" for persistance to DICOM and
	 *         "INOUT" for bidirectional mapping entries only
	 * @return HashSet
	 *         in the form of {DICOMtag, ClassName, FieldName, FieldMultiplicity}
	 *         where first char of fieldName is always uppercase and fieldMultiplicity
	 *         is fM=0 for singel field mapping or fM>0 when fM fields must be filled from
	 *         a single multiple value tag.
	 */
	public abstract HashSet<DicomMap> getBusinessPropertyMappingSet(String operation,
			String sopClass, String direction);

	/**
	 * Checks if DICOM AE Title setting is persisted for the proper msgType and msgRole
	 * @param aeTitle
	 *        The DICOM AE Title to be checked upon (max 16 alphanumeric characters)
	 * @param msgType
	 *        ("C-STORE", "C-FIND", ...)
	 * @param msgRole
	 *        "SCP", "SCU" or "SCPRRN" (SCP with reverse role negotiation capability).
	 *        
	 * @return boolean
	 */
	public abstract boolean isAETitleAuthenticated(String aeTitle,
			String serviceType, String serviceRole)
			throws AETitleAuthenticationException;

	/**
	 * Find one remote DicomAE entry, throw exception for none or more than one
	 * @param AETitle
	 *            The AE title looked for in the other two params context
	 * @param serviceType
	 *            service type (C-STORE, C-FIND, N-CREATE, N-SET,...) to search for.
	 * @param serviceRole
	 *            the SCP, SCU or SCPRRN role to search for
	 * 
	 * @throws ImagingDataInternalException
	 */
	public DicomAE getRemoteAEByTitleAndServiceTypeAndRole(String AETitle, String serviceType, 
			String serviceRole)
				throws AETitleAuthenticationException;

	/**
	 * get first DICOM AE Title that is persisted and enabled for the given msgType and msgRole
	 * @param serviceType
	 *        ("C-STORE", "C-FIND", ...)
	 * @param serviceRole
	 *        "SCP", "SCU" or "SCPRRN" (SCP with reverse role negotiation capability).
	 *        
	 * @return String
	 */
	public String getLocalAETitleByServiceTypeAndRole(String serviceType, String serviceRole)
                    throws AETitleAuthenticationException;

		/**
	 * Checks if Modality Device setting is persisted for the proper model and SW Version
	 * @param manufacturer
	 *            Manufacturer looked for in the other two params context
	 * @param model
	 *            Manufacturer's Model to check for authentication
	 * @param softwareVersion
	 *            Model's SW Version to check for authentication
	 * 
	 * @return boolean
	 */
	public abstract boolean isModalityDeviceAuthenticated(String manufacturer,
			String model, String softwareVersion);
    
    
    public void loadDICOMGatewayConfig()throws DICOMGatewayConfigurationException;
}