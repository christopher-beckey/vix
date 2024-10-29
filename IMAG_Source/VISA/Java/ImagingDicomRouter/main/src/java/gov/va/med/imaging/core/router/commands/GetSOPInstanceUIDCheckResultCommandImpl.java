package gov.va.med.imaging.core.router.commands;

import gov.va.med.RoutingToken;
import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.core.router.AbstractDataSourceCommandImpl;
import gov.va.med.imaging.datasource.DicomStorageDataSourceSpi;
import gov.va.med.imaging.datasource.VersionableDataSourceSpi;
import gov.va.med.imaging.exchange.business.ResolvedSite;
import gov.va.med.imaging.exchange.business.dicom.PatientStudyInfo;
import gov.va.med.imaging.exchange.business.dicom.UIDCheckInfo;
import gov.va.med.imaging.exchange.business.dicom.UIDCheckResult;
import gov.va.med.imaging.transactioncontext.TransactionContextFactory;

import java.lang.reflect.Method;
import java.net.URL;

public class GetSOPInstanceUIDCheckResultCommandImpl extends AbstractDicomStorageDataSourceCommandImpl<UIDCheckResult>
{

	private static final long serialVersionUID = 1L;

	private static final String SPI_METHOD_NAME = "getSOPInstanceUIDCheckResult";

	private UIDCheckInfo uidCheckInfo;

	public GetSOPInstanceUIDCheckResultCommandImpl(UIDCheckInfo uidCheckInfo)
	{
		this.uidCheckInfo = uidCheckInfo;
	}
	
	@Override
	protected UIDCheckResult getCommandResult(DicomStorageDataSourceSpi spi) throws ConnectionException, MethodException
	{
		return spi.getSOPInstanceUIDCheckResult(uidCheckInfo);
	}


	@Override
	protected Class<?>[] getSpiMethodParameterTypes() {
		return new Class<?>[]{UIDCheckInfo.class};
	}

	@Override
	protected Object[] getSpiMethodParameters() {
		return new Object[]{uidCheckInfo} ;
	}

	protected String getSpiMethodName() 
	{
		return SPI_METHOD_NAME;
	}

	@Override
	protected String parameterToString()
	{
		// TODO Auto-generated method stub
		return null;
	}

}
