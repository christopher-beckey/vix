package gov.va.med.imaging.core.router.commands;

import gov.va.med.RoutingToken;
import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.core.interfaces.exceptions.SecurityCredentialsExpiredException;
import gov.va.med.imaging.datasource.DicomDataSourceSpi;
import gov.va.med.imaging.datasource.VersionableDataSourceSpi;
import gov.va.med.imaging.exchange.business.ResolvedSite;

import java.lang.reflect.Method;

@Deprecated
public class GetImageDetailsCommandImpl 
extends AbstractDicomDataSourceCommandImpl<String>
{

	private static final long serialVersionUID = 1L;

	private static final String SPI_METHOD_NAME = "getImageDetails";

	private final String studyId;
	
	public GetImageDetailsCommandImpl(String studyId)
	{
		this.studyId = studyId;
	}

	@Override
	protected Class<?>[] getSpiMethodParameterTypes() {
		return new Class<?>[]{String.class};
	}

	@Override
	protected Object[] getSpiMethodParameters() {
		return new Object[]{getStudyId()} ;
	}

	/**
	 * @return the studyId
	 */
	public String getStudyId() {
		return studyId;
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
	protected String getCommandResult(DicomDataSourceSpi spi)
	throws ConnectionException, MethodException, SecurityCredentialsExpiredException 
	{
		return spi.getStudyDetails(getStudyId());
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.core.router.AbstractDataSourceCommandImpl#getSpiMethodName()
	 */
	@Override
	protected String getSpiMethodName() 
	{
		return SPI_METHOD_NAME;
	}
}
