package gov.va.med.imaging.core.router.commands;

import gov.va.med.RoutingToken;
import gov.va.med.imaging.core.router.AbstractDataSourceCommandImpl;
import gov.va.med.imaging.datasource.DicomQueryRetrieveDataSourceSpi;
import gov.va.med.imaging.datasource.DicomStorageDataSourceSpi;
import gov.va.med.imaging.exchange.business.dicom.DicomServerConfiguration;
import gov.va.med.imaging.transactioncontext.TransactionContextFactory;

public abstract class AbstractDicomQueryRetrieveDataSourceCommandImpl<R> 
extends AbstractDataSourceCommandImpl<R, DicomQueryRetrieveDataSourceSpi> {


	/* (non-Javadoc)
	 * @see gov.va.med.imaging.core.router.AbstractDataSourceCommandImpl#getSiteNumber()
	 */
	@Override
	protected String getSiteNumber() 
	{
		return TransactionContextFactory.get().getSiteNumber();
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.core.router.AbstractDataSourceCommandImpl#getSpiClass()
	 */
	@Override
	protected Class<DicomQueryRetrieveDataSourceSpi> getSpiClass() 
	{
		return DicomQueryRetrieveDataSourceSpi.class;
	}

	@Override
	public RoutingToken getRoutingToken() 
	{
		return DicomServerConfiguration.getConfiguration().getRoutingToken();
	}

}
