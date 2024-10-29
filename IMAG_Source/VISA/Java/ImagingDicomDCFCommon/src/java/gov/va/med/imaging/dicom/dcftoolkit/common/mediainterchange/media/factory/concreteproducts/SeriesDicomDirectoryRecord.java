/**
 * 
  Package: MAG - VistA Imaging
  WARNING: Per VHA Directive 2004-038, this routine should not be modified.
  Date Created: Mar 6, 2011
  Site Name:  Washington OI Field Office, Silver Spring, MD
  Developer:  vhaiswpeterb
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
package gov.va.med.imaging.dicom.dcftoolkit.common.mediainterchange.media.factory.concreteproducts;

import gov.va.med.imaging.dicom.dcftoolkit.common.exceptions.DicomDIRFactoryException;
import gov.va.med.imaging.dicom.dcftoolkit.common.impl.DicomDataSetImpl;
import gov.va.med.imaging.dicom.dcftoolkit.common.mediainterchange.media.factory.products.AbstractDicomDirectoryRecord;
import gov.va.med.imaging.exchange.business.dicom.DicomDIRRecord;
import gov.va.med.imaging.exchange.business.dicom.ImageDIRRecord;
import gov.va.med.imaging.exchange.business.dicom.Series;
import gov.va.med.imaging.exchange.business.dicom.SeriesDIRRecord;

import com.lbs.DCS.DCSException;
import com.lbs.DSS.DicomDirectoryRecord;
import com.lbs.DSS.SeriesDirectoryRecord;

/**
 * @author vhaiswpeterb
 *
 */
public class SeriesDicomDirectoryRecord extends AbstractDicomDirectoryRecord {

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.dicom.dcftoolkit.common.mediainterchange.media.factory.products.AbstractDicomDirectoryRecord#createDicomDIRRecord(com.lbs.DSS.DicomDirectoryRecord)
	 */
	@Override
	public DicomDIRRecord createDicomDIRRecord(DicomDirectoryRecord record)
			throws DicomDIRFactoryException {
		
		SeriesDIRRecord seriesDIRRecord = new SeriesDIRRecord();
		SeriesDirectoryRecord seriesRecord = (SeriesDirectoryRecord)record;

		try{
			DicomDataSetImpl dataSet = new DicomDataSetImpl(seriesRecord.data_set());
			Series series = dataSet.getSeries(null, null);
			
			seriesDIRRecord.setDirectoryRecordType(DicomDIRRecord.SERIES);
			seriesDIRRecord.setModality(seriesRecord.modality());
			seriesDIRRecord.setSeriesInstanceUID(seriesRecord.seriesInstanceUid());
			seriesDIRRecord.setSeriesNumber(seriesRecord.seriesNumber());
			seriesDIRRecord.setFacility(series.getFacility());
			seriesDIRRecord.setInstitutionAddress(series.getInstitutionAddress());
			seriesDIRRecord.setSeriesDescription(series.getDescription());
			
		}
		catch(DCSException dcsX){
			throw new DicomDIRFactoryException("Failed to create DICOMDIR Series Directory Record.");
		}
		return seriesDIRRecord;
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.dicom.dcftoolkit.common.mediainterchange.media.factory.products.AbstractDicomDirectoryRecord#addDicomDIRRecordToParent(gov.va.med.imaging.exchange.business.dicom.DicomDIRRecord, gov.va.med.imaging.exchange.business.dicom.DicomDIRRecord)
	 */
	@Override
	public void addDicomDIRRecordToParent(DicomDIRRecord parent,
			DicomDIRRecord child) throws DicomDIRFactoryException {

		((SeriesDIRRecord)parent).addImage((ImageDIRRecord)child);
	}

	
}
