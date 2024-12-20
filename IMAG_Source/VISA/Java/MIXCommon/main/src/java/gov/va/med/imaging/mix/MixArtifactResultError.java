/**
 * 
  Package: MAG - VistA Imaging
  WARNING: Per VHA Directive 2004-038, this routine should not be modified.
  Date Created: Sep 30, 2010
  Site Name:  Washington OI Field Office, Silver Spring, MD
  Developer:  vhaiswwerfej
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
package gov.va.med.imaging.mix;

import gov.va.med.imaging.exchange.business.ArtifactResultError;
import gov.va.med.imaging.exchange.enums.ArtifactResultErrorCode;
import gov.va.med.imaging.exchange.enums.ArtifactResultErrorSeverity;

/**
 * @author vhaiswwerfej
 *
 */
public class MixArtifactResultError 
implements ArtifactResultError
{
	private final String codeContext;
	private final String location;
	private final ArtifactResultErrorCode errorCode;
	private final ArtifactResultErrorSeverity severity;
	
	public MixArtifactResultError(String codeContext, String location, ArtifactResultErrorCode errorCode, ArtifactResultErrorSeverity severity)
	{
		this.codeContext = codeContext;
		this.location = location;
		this.errorCode = errorCode;
		this.severity = severity;		
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.exchange.business.ArtifactResultError#getCodeContext()
	 */
	@Override
	public String getCodeContext()
	{
		return codeContext;
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.exchange.business.ArtifactResultError#getErrorCode()
	 */
	@Override
	public ArtifactResultErrorCode getErrorCode()
	{
		return errorCode;
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.exchange.business.ArtifactResultError#getLocation()
	 */
	@Override
	public String getLocation()
	{
		return location;
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.exchange.business.ArtifactResultError#getSeverity()
	 */
	@Override
	public ArtifactResultErrorSeverity getSeverity()
	{
		return severity;
	}

}
