/**
 * 
  Package: MAG - VistA Imaging
  WARNING: Per VHA Directive 2004-038, this routine should not be modified.
  Date Created: 
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
package gov.va.med.imaging.core.router.commands;

import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.datasource.DicomQueryRetrieveDataSourceSpi;
import gov.va.med.imaging.exchange.business.dicom.DicomInstanceUpdateInfo;
import gov.va.med.imaging.exchange.business.dicom.InstanceStorageInfo;

import gov.va.med.logging.Logger;

/**
 * This Router command retrieves any new or changed Patient/Study information from the Data 
 * Source for a specific DICOM Instance.
 *  
 * @author vhaiswpeterb
 *
 */
public class GetDicomInstanceUpdateInfoCommandImpl 
extends AbstractDicomQueryRetrieveDataSourceCommandImpl<DicomInstanceUpdateInfo> {

	private static final long serialVersionUID = 8891761522864243337L;

	private Logger logger = Logger.getLogger(GetDicomInstanceUpdateInfoCommandImpl.class);
	
	private static final String SPI_METHOD_NAME = "getDicomInstanceUpdateInfo";

	private InstanceStorageInfo instance = null;
	
	/**
	 * Constructor
	 * 
	 * @param objectIdentifier
	 */
	public GetDicomInstanceUpdateInfoCommandImpl(InstanceStorageInfo instance){
		this.instance = instance;
	}
		
	/**
	 * @return the objectIdentifier
	 */
	public InstanceStorageInfo getInstance() {
		return instance;
	}

	@Override
	protected DicomInstanceUpdateInfo getCommandResult(DicomQueryRetrieveDataSourceSpi spi)
			throws ConnectionException, MethodException {	

		if(logger.isDebugEnabled()){
            logger.debug("{}: Executing Router Command {}", Thread.currentThread().getId(), this.getClass().getName());}

		return spi.getDicomInstanceUpdateInfo(instance);
	}

	@Override
	protected String getSpiMethodName() {
		return SPI_METHOD_NAME;
	}

	@Override
	protected Class<?>[] getSpiMethodParameterTypes() {
		return new Class<?>[]{InstanceStorageInfo.class};
	}

	@Override
	protected Object[] getSpiMethodParameters() {
		return new Object[]{getInstance()} ;
	}

}
