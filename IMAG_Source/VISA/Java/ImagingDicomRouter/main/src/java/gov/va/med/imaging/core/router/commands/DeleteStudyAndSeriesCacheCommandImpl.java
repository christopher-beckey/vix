/**
 * 
  Package: MAG - VistA Imaging
  WARNING: Per VHA Directive 2004-038, this routine should not be modified.
  Date Created: Feb 1, 2012
  Site Name:  Washington OI Field Office, Silver Spring, MD
  Developer:  VHAISWPETERB
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
package gov.va.med.imaging.core.router.commands;

import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.datasource.DicomStorageDataSourceSpi;

/**
 * Purge temporary cache objects that may exist in the Data Source.  The use of these cache objects
 * is to improve database performance by minimizing the number of database hits for redundant information.  
 * A side effect of this is the cache objects may become out-of-sync with the actual database.  This router
 * command corrects this issue. 
 * 
 * @author VHAISWPETERB
 *
 */
public class DeleteStudyAndSeriesCacheCommandImpl extends
		AbstractDicomStorageDataSourceCommandImpl<Boolean> {

	private static final String SPI_METHOD_NAME = "deleteStudyAndSeriesCache";

	/**
	 * Constructor
	 */
	public DeleteStudyAndSeriesCacheCommandImpl(){
		
	}
	
	/* (non-Javadoc)
	 * @see gov.va.med.imaging.core.router.AbstractDataSourceCommandImpl#getSpiMethodName()
	 */
	@Override
	protected String getSpiMethodName() {
		
		return SPI_METHOD_NAME;
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.core.router.AbstractDataSourceCommandImpl#getSpiMethodParameterTypes()
	 */
	@Override
	protected Class<?>[] getSpiMethodParameterTypes() {
		return new Class<?>[] { };
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.core.router.AbstractDataSourceCommandImpl#getSpiMethodParameters()
	 */
	@Override
	protected Object[] getSpiMethodParameters() {
		return new Object[] { };
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.core.router.AbstractDataSourceCommandImpl#getCommandResult(gov.va.med.imaging.datasource.VersionableDataSourceSpi)
	 */
	@Override
	protected Boolean getCommandResult(DicomStorageDataSourceSpi spi)
			throws ConnectionException, MethodException {
		
		return spi.deleteStudyAndSeriesCache();
	}
}
