package gov.va.med.imaging.dicom.common.interfaces;

import java.io.InputStream;

import gov.va.med.imaging.dicom.common.DicomFileMetaInfo;
import gov.va.med.imaging.dicom.common.exceptions.Part10FileException;

public interface IDicomPart10File {

	public abstract DicomFileMetaInfo getFileMetaData() throws Part10FileException;
	
	public abstract IDicomDataSet getDicomDataSet() throws Part10FileException;
	
	public abstract InputStream getInputStream() throws Part10FileException;
	
	public abstract void part10File(String filename);
	
	
}
