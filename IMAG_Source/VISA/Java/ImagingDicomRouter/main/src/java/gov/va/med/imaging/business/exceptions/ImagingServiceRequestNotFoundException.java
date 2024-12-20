/*
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
 * TODO Update File Header block
 */
package gov.va.med.imaging.business.exceptions;

import gov.va.med.imaging.exceptions.ImagingDataException;

/**
 * Signals that the Imaging Service Request was not found in persistent
 * storage.
 * @author Jon Louthian
 *
 */
public class ImagingServiceRequestNotFoundException extends ImagingDataException {
    
	static final long serialVersionUID = 1L; 

	/**
     * 
     */
    public ImagingServiceRequestNotFoundException() {
        super();
    }
    /**
     * @param arg0
     */
    public ImagingServiceRequestNotFoundException(String arg0) {
        super(arg0);
    }
    /**
     * @param arg0
     * @param arg1
     */
    public ImagingServiceRequestNotFoundException(String arg0, Throwable arg1) {
        super(arg0, arg1);
    }
    /**
     * @param arg0
     */
    public ImagingServiceRequestNotFoundException(Throwable arg0) {
        super(arg0);
    }
}
