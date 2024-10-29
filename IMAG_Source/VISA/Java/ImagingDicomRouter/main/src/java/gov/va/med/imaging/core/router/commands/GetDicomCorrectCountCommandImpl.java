package gov.va.med.imaging.core.router.commands;

import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.datasource.DicomStorageDataSourceSpi;
import gov.va.med.imaging.exchange.business.dicom.DicomCorrectInfo;

public class GetDicomCorrectCountCommandImpl extends AbstractDicomStorageDataSourceCommandImpl<Integer>
{

	private static final long serialVersionUID = 1L;

	private static final String SPI_METHOD_NAME = "getDicomCorrectCount";

	private DicomCorrectInfo dicomCorrectInfo;
	
	public GetDicomCorrectCountCommandImpl(DicomCorrectInfo dicomCorrectInfo)
	{
		this.dicomCorrectInfo = dicomCorrectInfo;
	}
	
	@Override
	protected Integer getCommandResult(DicomStorageDataSourceSpi spi) throws ConnectionException, MethodException
	{
		return spi.getDicomCorrectCount(dicomCorrectInfo);
	}
	
	@Override
	protected Class<?>[] getSpiMethodParameterTypes() {
		return new Class<?>[]{DicomCorrectInfo.class};
	}

	@Override
	protected Object[] getSpiMethodParameters() {
		return new Object[]{getDicomCorrectInfo()} ;
	}

	@Override
	protected String parameterToString()
	{
		// TODO Auto-generated method stub
		return null;
	}

	protected String getSpiMethodName() 
	{
		return SPI_METHOD_NAME;
	}

	/**
	 * @return the dicomCorrectInfo
	 */
	public DicomCorrectInfo getDicomCorrectInfo() {
		return dicomCorrectInfo;
	}

}
