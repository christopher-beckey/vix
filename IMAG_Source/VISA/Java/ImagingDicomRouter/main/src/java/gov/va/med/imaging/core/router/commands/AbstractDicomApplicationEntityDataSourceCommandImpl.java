package gov.va.med.imaging.core.router.commands;

import gov.va.med.RoutingToken;
import gov.va.med.imaging.core.router.AbstractDataSourceCommandImpl;
import gov.va.med.imaging.datasource.DicomApplicationEntityDataSourceSpi;
import gov.va.med.imaging.exchange.business.dicom.DicomServerConfiguration;
import gov.va.med.imaging.transactioncontext.TransactionContextFactory;

public abstract class AbstractDicomApplicationEntityDataSourceCommandImpl<R>
		extends AbstractDataSourceCommandImpl<R, DicomApplicationEntityDataSourceSpi> {

	private static final long serialVersionUID = 1L;

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
	protected Class<DicomApplicationEntityDataSourceSpi> getSpiClass() 
	{
		return DicomApplicationEntityDataSourceSpi.class;
	}

	@Override
	public RoutingToken getRoutingToken() 
	{
		return DicomServerConfiguration.getConfiguration().getRoutingToken();
	}

}
