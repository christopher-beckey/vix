/**
 * 
  Package: MAG - VistA Imaging
  WARNING: Per VHA Directive 2004-038, this routine should not be modified.
  Date Created: Mar 8, 2012
  Site Name:  Washington OI Field Office, Silver Spring, MD
  Developer:  VHAISWWERFEJ
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
package gov.va.med;

import java.io.Serializable;

import gov.va.med.exceptions.PatientIdentifierParseException;


/**
 * This object represents a patient identifier
 * 
 * @author VHAISWWERFEJ
 *
 */
public class PatientIdentifier
implements Serializable
{
	private static final long serialVersionUID = 1L;
	
	private final String value;
	private final PatientIdentifierType patientIdentifierType;
	private final String patientIdentifierSource;
	
	public final static String patientIdentifierIcnSource = "*";
	private final static String siteIdentifierDelimiter = "-";
	
	public static PatientIdentifier icnPatientIdentifier(String value)
	{
		return new PatientIdentifier(value, PatientIdentifierType.icn, patientIdentifierIcnSource);
	}
	
	public static PatientIdentifier dfnPatientIdentifier(String value, String patientIdentifierSource)
	{
		return new PatientIdentifier(value, PatientIdentifierType.dfn, patientIdentifierSource);
	}

	public static PatientIdentifier musePatientIdentifier(String value)
	{
		return new PatientIdentifier(value, PatientIdentifierType.muse, patientIdentifierIcnSource );
	}
	public static PatientIdentifier mrnPatientIdentifier(String value)
	{
		return new PatientIdentifier(value, PatientIdentifierType.mrn, patientIdentifierIcnSource);
	}
	public static PatientIdentifier ssnPatientIdentifier(String value)
	{
		return new PatientIdentifier(value, PatientIdentifierType.ssn, patientIdentifierIcnSource);
	}

	/**
	 * 
	 * @param value The raw string value
	 * @param patientIdentifierType The type this value represents
	 */
	public PatientIdentifier(String value,
			PatientIdentifierType patientIdentifierType,
			String patientIdentifierSource)
	{
		super();
		this.value = value;
		this.patientIdentifierType = patientIdentifierType;
		this.patientIdentifierSource = patientIdentifierSource;
		
	}

	public PatientIdentifier(String value,
			PatientIdentifierType patientIdentifierType)
	{
		super();
		this.value = value;
		this.patientIdentifierType = patientIdentifierType;
		this.patientIdentifierSource = PatientIdentifier.patientIdentifierIcnSource;
		
	}

	public String getValue()
	{
		return value;
	}

	public PatientIdentifierType getPatientIdentifierType()
	{
		return patientIdentifierType;
	}

	/**
	 * @return the patientIdentifierSource
	 */
	public String getPatientIdentifierSource()
	{
		return patientIdentifierSource;
	}

	@Override
	public String toString()
	{
		return toString(false);//patientIdentifierType.name() + "(" + value + ")";
	}
	
	public String toString(boolean explicitlyIncludeIdentifierSource)
	{
		boolean includeSource = false;
		if(explicitlyIncludeIdentifierSource || !patientIdentifierIcnSource.equals(patientIdentifierSource))
			includeSource = true;
		
		if(value != null && value.contains(siteIdentifierDelimiter))
			includeSource = true;
		
		if(includeSource)
			return patientIdentifierType.name() + "(" + patientIdentifierSource + siteIdentifierDelimiter + value + ")";
		else
		return patientIdentifierType.name() + "(" + value + ")";
	}

	/* (non-Javadoc)
	 * @see java.lang.Object#hashCode()
	 */

	@Override
	public int hashCode()
	{
		final int prime = 31;
		int result = 1;
		result = prime
				* result
		+ ((patientIdentifierSource == null) ? 0 : patientIdentifierSource
		.hashCode());
		result = prime
		* result
				+ ((patientIdentifierType == null) ? 0 : patientIdentifierType
						.hashCode());
		result = prime * result + ((value == null) ? 0 : value.hashCode());
		return result;
	}

	/* (non-Javadoc)
	 * @see java.lang.Object#equals(java.lang.Object)
	 */

	@Override
	public boolean equals(Object obj)
	{
		if (this == obj)
			return true;
		if (obj == null)
			return false;
		if (getClass() != obj.getClass())
			return false;
		PatientIdentifier other = (PatientIdentifier) obj;
		if (patientIdentifierSource == null)
		{
			if (other.patientIdentifierSource != null)
				return false;
		} else if (!patientIdentifierSource
		.equals(other.patientIdentifierSource))
			return false;
		if (patientIdentifierType != other.patientIdentifierType)
			return false;
		if (value == null)
		{
			if (other.value != null)
				return false;
		} else if (!value.equals(other.value))
			return false;
		return true;
	}
	
	public static PatientIdentifier fromString(String value)
	throws PatientIdentifierParseException
	{
		if(value == null)
			return null;
		int loc = value.indexOf("(");
		if(loc < 0)
		{
			return icnPatientIdentifier(checkAndRemoveTrailingDelimiter(value));
		}
		String identifierTypeName = value.substring(0, loc);
		PatientIdentifierType patientIdentifierType =
				PatientIdentifierType.valueOf(identifierTypeName);
		if(patientIdentifierType == null)
			return null;
		String idPiece = checkAndRemoveTrailingDelimiter(value.substring(loc + 1));
		if(idPiece == null || idPiece.length() <= 0)
			throw new PatientIdentifierParseException("Missing patient ID piece in [" + value + "]");
		
		String patientId = null;
		String siteNumber = null;
		loc = idPiece.indexOf(siteIdentifierDelimiter);
		if(loc < 0)
		{
			patientId = idPiece;			
		}
		else
		{
			siteNumber = idPiece.substring(0, loc);
			patientId = idPiece.substring(loc + 1);
		}
		if(siteNumber == null)
		{
			if(patientIdentifierType.isRequiresSiteIdentifier())
				throw new PatientIdentifierParseException("PatientIdentifierType [" + patientIdentifierType.name() + "] requires a site identifier, not found in [" + value + "]");
			return new PatientIdentifier(patientId, patientIdentifierType, patientIdentifierIcnSource);
		}
		return new PatientIdentifier(patientId, patientIdentifierType, siteNumber);
		
		/*
		String [] idPieces = idPiece.split("-");
		if(idPieces.length == 1)
		{
			// no site specified
			String patientId = idPieces[0];
			if(patientIdentifierType.isRequiresSiteIdentifier())
				throw new PatientIdentifierParseException("PatientIdentifierType [" + patientIdentifierType.name() + "] requires a site identifier, not found in [" + value + "]");
			return new PatientIdentifier(patientId, patientIdentifierType, patientIdentifierIcnSource);
		}
		else if(idPieces.length == 2)
		{
			String siteNumber = idPieces[0];
			String patientId = idPieces[1];
			return new PatientIdentifier(patientId, patientIdentifierType, siteNumber);
		}*/
		//throw new PatientIdentifierParseException("Unable to parse patient identifier from [" + value + "]");		
		
	}
	
	private static String checkAndRemoveTrailingDelimiter(String value)
	{
		if(value == null)
			return null;
		if(value.endsWith(")"))
			return value.substring(0, value.length() - 1);
		return value;
	}

}
