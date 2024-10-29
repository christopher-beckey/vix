package gov.va.med.imaging.core.router.storage.providers;

import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.core.router.storage.StorageContext;
import gov.va.med.imaging.exchange.business.storage.ArtifactWriteResults;
import gov.va.med.imaging.exchange.business.storage.NetworkLocationInfo;
import gov.va.med.imaging.exchange.business.storage.Provider;

import gov.va.med.logging.Logger;

public class JukeBoxProvider extends StorageCIFSProvider 
{
	private static final long serialVersionUID = 1L;
	private static final Logger logger = Logger.getLogger(ArtifactWriteResults.class);
	
	public JukeBoxProvider(Provider provider)
	{
		super(provider);
	}

	@Override
	protected NetworkLocationInfo getCurrentWriteLocation()  throws MethodException, ConnectionException {
		return StorageContext.getDataSourceRouter().getCurrentJukeboxWriteLocation(this);
	}
}
