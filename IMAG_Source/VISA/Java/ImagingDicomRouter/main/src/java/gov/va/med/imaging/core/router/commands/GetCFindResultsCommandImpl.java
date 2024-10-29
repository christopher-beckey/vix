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
import gov.va.med.imaging.core.interfaces.exceptions.SecurityCredentialsExpiredException;
import gov.va.med.imaging.datasource.DicomQueryRetrieveDataSourceSpi;
import gov.va.med.imaging.exchange.business.dicom.CFindResults;
import gov.va.med.imaging.exchange.business.dicom.DicomRequestParameters;

/**
 * This Router command fetches matching C-Find results from the Data Source.
 *  
 * @author vhaiswpeterb
 *
 */
public class GetCFindResultsCommandImpl 
extends AbstractDicomQueryRetrieveDataSourceCommandImpl<CFindResults>
{
	private static final long serialVersionUID = 1L;

	private static final String SPI_METHOD_NAME = "getCFindResults";
	
	private final DicomRequestParameters requestParameters;
	
	public GetCFindResultsCommandImpl(DicomRequestParameters request)
	{
		this.requestParameters = request;
	}
	
	/**
	 * @return the requestParameters
	 */
	public DicomRequestParameters getRequestParameters() {
		return requestParameters;
	}

	/* (non-Javadoc)
	 * @see java.lang.Object#hashCode()
	 */
	@Override
	public int hashCode()
	{
		final int prime = 31;
		int result = 1;
		result = prime * result + ((this.requestParameters == null) ? 0 : this.requestParameters.hashCode());
		return result;
	}
	
	/* (non-Javadoc)
	 * @see java.lang.Object#equals(java.lang.Object)
	 */
	@Override
	public boolean equals(Object obj)
	{
		// If the references are the same, the objects are equal
		if (this == obj) return true;
		
		// If they classes aren't the same, objects can't be equal
		if (getClass() != obj.getClass()) return false;
		
		// Cast to correct type
		final GetCFindResultsCommandImpl other = (GetCFindResultsCommandImpl) obj;

		// If the site numbers are different, objects aren't equal
		if (this.getSiteNumber() != other.getSiteNumber()) return false;
		
		// Check the request parameters
		if (this.requestParameters == null && other.requestParameters != null) return false;
		if (this.requestParameters != null && other.requestParameters == null) return false;
		if (!this.requestParameters.equals(other.requestParameters)) return false;

		// If we've made it to here, the objects are equal
		return true;
		
	}


	@Override
	protected Class<?>[] getSpiMethodParameterTypes() {
		return new Class<?>[]{DicomRequestParameters.class};
	}

	@Override
	protected Object[] getSpiMethodParameters() {
		return new Object[]{getRequestParameters()} ;
	}
	

	@Override
	protected String parameterToString() {
		return requestParameters == null ? "<null request>" : "" + requestParameters.toString() + ","  + getSiteNumber();
	}


	/* (non-Javadoc)
	 * @see gov.va.med.imaging.core.router.AbstractDataSourceCommandImpl#getCommandResult(gov.va.med.imaging.datasource.VersionableDataSourceSpi)
	 */
	@Override
	protected CFindResults getCommandResult(DicomQueryRetrieveDataSourceSpi spi)
	throws ConnectionException, MethodException, SecurityCredentialsExpiredException 
	{
		return spi.getCFindResults(getRequestParameters());
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.core.router.AbstractDataSourceCommandImpl#getSpiMethodName()
	 */
	@Override
	protected String getSpiMethodName() {
		return SPI_METHOD_NAME;
	}

}