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

import gov.va.med.logging.Logger;

import gov.va.med.RoutingToken;
import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.core.interfaces.exceptions.SecurityCredentialsExpiredException;
import gov.va.med.imaging.core.router.AbstractDataSourceCommandImpl;
import gov.va.med.imaging.datasource.DicomApplicationEntityDataSourceSpi;
import gov.va.med.imaging.exchange.business.dicom.DicomAE;
import gov.va.med.imaging.transactioncontext.TransactionContextFactory;

/**
 * This Router command retrieves necessary information about the DICOM Application Entity. A
 * DICOM Application Entity is basically any remote device that interacts with VistA Imaging
 * on a DICOM Association.
 * 
 * @author vhaiswpeterb
 *
 */
public class GetRemoteServiceAECommandImpl 
extends AbstractDataSourceCommandImpl<DicomAE,DicomApplicationEntityDataSourceSpi>
{
	private Logger logger = Logger.getLogger(this.getClass());

	private static final long serialVersionUID = 1L;

	private static final String SPI_METHOD_NAME = "getAEByAETandLocation";

	private final DicomAE appEntity;
	private final RoutingToken routingToken;
	
	
	public GetRemoteServiceAECommandImpl(RoutingToken routingToken, DicomAE.searchMode findMode, String aeTitle, String siteNumber)
	{
		this.appEntity = new DicomAE();
		this.appEntity.setFindMode(findMode);
		this.appEntity.setRemoteAETitle(aeTitle);
		this.appEntity.setSiteNumber(siteNumber);
		this.routingToken = routingToken;
	}

	
	/**
	 * @return the appEntity
	 */
	public DicomAE getAppEntity() {
		return appEntity;
	}


	@Override
	protected Class<?>[] getSpiMethodParameterTypes() {
		return new Class<?>[]{DicomAE.class};
	}

	@Override
	protected Object[] getSpiMethodParameters() {
		return new Object[]{getAppEntity()} ;
	}

	@Override
	protected String parameterToString()
	{
		// TODO Auto-generated method stub
		return null;
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.core.router.AbstractDataSourceCommandImpl#getCommandResult(gov.va.med.imaging.datasource.VersionableDataSourceSpi)
	 */
	@Override
	protected DicomAE getCommandResult(DicomApplicationEntityDataSourceSpi spi)
	throws ConnectionException, MethodException, SecurityCredentialsExpiredException 
	{
		if(logger.isDebugEnabled()){
            logger.debug("{}: Executing Router command.", this.getClass().getName());}
		return spi.getAEByAETandLocation(getAppEntity());
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.core.router.AbstractDataSourceCommandImpl#getSpiMethodName()
	 */
	@Override
	protected String getSpiMethodName() {
		return SPI_METHOD_NAME;
	}


	@Override
	public RoutingToken getRoutingToken() {
		return routingToken;
	}


	@Override
	protected Class<DicomApplicationEntityDataSourceSpi> getSpiClass() {
		// TODO Auto-generated method stub
		return DicomApplicationEntityDataSourceSpi.class;
	}


	@Override
	protected String getSiteNumber() {
		return TransactionContextFactory.get().getSiteNumber();
	}
}
