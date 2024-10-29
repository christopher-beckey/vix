/**
 * Package: MAG - VistA Imaging
 * WARNING: Per VHA Directive 2004-038, this routine should not be modified.
 * @date Sep 7, 2010
 * Site Name:  Washington OI Field Office, Silver Spring, MD
 * @author vhaiswbeckec
 * @version 1.0
 *
 * ----------------------------------------------------------------
 * Property of the US Government.
 * No permission to copy or redistribute this software is given.
 * Use of unreleased versions of this software requires the user
 * to execute a written test agreement with the VistA Imaging
 * Development Office of the Department of Veterans Affairs,
 * telephone (301) 734-0100.
 * 
 * The Food and Drug Administration classifies this software as
 * a Class II medical device.  As such, it may not be changed
 * in any way.  Modifications to this software may result in an
 * adulterated medical device under 21CFR820, the use of which
 * is considered to be a violation of US Federal Statutes.
 * ----------------------------------------------------------------
 */

package gov.va.med.imaging.ihe;

import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;

/**
 * The HL7 patient identifier found in PID-3, is a repeating field of the following format:
 * 3.4.2.3 PID-3 Patient identifier list (CX) 00106
 * 
 * Components :
 * <ID (ST)> ^
 * <check digit (ST)> ^
 * <code identifying the check digit scheme employed (ID)> ^
 * <assigning authority (HD)> ^
 * <identifier type code (ID)> ^
 * <assigning facility (HD) ^
 * <effective date (DT)> ^
 * <expiration date (DT)>
 * 
 * Subcomponents of assigning authority:
 * <namespace ID (IS)> & <universal ID (ST)> & <universal ID type (ID)>
 * 
 * Subcomponents of assigning facility:
 * <namespace ID (IS)> & <universal ID (ST)> & <universal ID type (ID)>
 * 
 * Most HL7 2.x messages only populate the following components at most: ID and identifier type code.
 * Obviously, facilities that use a check digit also populate check digit and code identifying the check digit
 * scheme employed. Occasionally the component assigning authority or assigning facility will be populated
 * in a multi system facility.
 * 
 * DT format is YYYY[MM[DD[HHMM[SS[.S[S[S[S]]]]]]]][+/-ZZZZ]
 * 
 * @author vhaiswbeckec
 */
public class HL7PatientIdentifier
{
	// e.g. 543797436^^^&1.2.840.113619.6.197&ISO
	public static final int PATIENTID_INDEX = 0;
	public static final int PATIENTID_CHECKDIGIT_INDEX = 1;
	public static final int PATIENTID_CHECKDIGITCODE_INDEX = 2;
	public static final int AUTHORITY_INDEX = 3;
	public static final int IDENTIFIERTYPE_INDEX = 4;
	public static final int FACILITY_INDEX = 5;
	public static final int EFFECTIVEDATE_INDEX = 6;
	public static final int EXPIRATIONDATE_INDEX = 7;
	
	public static final int AUTHORITY_NAMESPACE_SUBINDEX = 0;
	public static final int AUTHORITY_UNIVERSALID_SUBINDEX = 1;
	public static final int AUTHORITY_UNIVERSALIDTYPE_SUBINDEX = 2;

	public static final int FACILITY_NAMESPACE_SUBINDEX = 0;
	public static final int FACILITY_UNIVERSALID_SUBINDEX = 1;
	public static final int FACILITY_UNIVERSALIDTYPE_SUBINDEX = 2;
	
	public final static String COMPONENT_DELIMITER = "^";
	public final static String SUBCOMPONENT_DELIMITER = "&";
	public final static String COMPONENT_DELIMITER_REGEX = "\\x5E";
	public final static String SUBCOMPONENT_DELIMITER_REGEX = "\\x26";
	
	private final static DateFormat dateFormat = new SimpleDateFormat("yyyyMMddHHmmss.SSSSZZZZZ");
	
	private final String patientId;
	private final String patientIdCheckDigit;
	private final String patientIdCheckDigitCode;
	private final AssigningAuthority assigningAuthority;
	private final String identifierTypeCode;
	private final AssigningFacility assigningFacility;
	private final Date effectiveDate;
	private final Date expirationDate;
	
	/**
	 * 
	 * @param hl7Identifier
	 * @return
	 * @throws OIDFormatException 
	 * @throws ParseException 
	 */
	public static HL7PatientIdentifier create(String hl7Identifier) 
	throws ParseException
	{
		String[] components = hl7Identifier.split(COMPONENT_DELIMITER_REGEX);

		String patientId = components.length > PATIENTID_INDEX ? components[PATIENTID_INDEX] : null;
		String patientIdCheckDigit = components.length > PATIENTID_CHECKDIGIT_INDEX ? components[PATIENTID_CHECKDIGIT_INDEX] : null;
		String patientIdCheckDigitCode = components.length > PATIENTID_CHECKDIGITCODE_INDEX  ? components[PATIENTID_CHECKDIGITCODE_INDEX] : null;

		AssigningAuthority assigningAuthority = components.length > AUTHORITY_INDEX ? 
			createAssigningAuthority(components[AUTHORITY_INDEX]) : 
			null;
		String identifierTypeCode = components.length > IDENTIFIERTYPE_INDEX ? components[IDENTIFIERTYPE_INDEX] : null;
		AssigningFacility assigningFacility = components.length > FACILITY_INDEX ? 
			createAssigningFacility(components[FACILITY_INDEX]) : 
			null;
		Date effectiveDate = components.length > EFFECTIVEDATE_INDEX ? dateFormat.parse(components[EFFECTIVEDATE_INDEX]) : null;
		Date expirationDate = components.length > EXPIRATIONDATE_INDEX ? dateFormat.parse(components[EXPIRATIONDATE_INDEX]) : null;
		
		return new HL7PatientIdentifier(
			patientId, 
			patientIdCheckDigit, 
			patientIdCheckDigitCode, 
			assigningAuthority, 
			identifierTypeCode, 
			assigningFacility, 
			effectiveDate, 
			expirationDate);
	}
	
	/**
	 * @param patientId
	 * @param patientIdCheckDigit
	 * @param patientIdCheckDigitCode
	 * @param assigningAuthority
	 * @param identifierTypeCode
	 * @param assigningFacility
	 * @param effectiveDate
	 * @param expirationDate
	 */
	public HL7PatientIdentifier(
		String patientId, 
		String patientIdCheckDigit, 
		String patientIdCheckDigitCode,
		AssigningAuthority assigningAuthority, 
		String identifierTypeCode, 
		AssigningFacility assigningFacility, 
		Date effectiveDate,
		Date expirationDate)
	{
		super();
		this.patientId = patientId;
		this.patientIdCheckDigit = patientIdCheckDigit;
		this.patientIdCheckDigitCode = patientIdCheckDigitCode;
		this.assigningAuthority = assigningAuthority;
		this.identifierTypeCode = identifierTypeCode;
		this.assigningFacility = assigningFacility;
		this.effectiveDate = effectiveDate;
		this.expirationDate = expirationDate;
	}

	
	/**
	 * @return the patientId
	 */
	public String getPatientId()
	{
		return this.patientId;
	}

	/**
	 * @return the patientIdCheckDigit
	 */
	public String getPatientIdCheckDigit()
	{
		return this.patientIdCheckDigit;
	}

	/**
	 * @return the patientIdCheckDigitCode
	 */
	public String getPatientIdCheckDigitCode()
	{
		return this.patientIdCheckDigitCode;
	}

	/**
	 * Subcomponents of assigning authority:
	 * <namespace ID (IS)> & <universal ID (ST)> & <universal ID type (ID)>
	 * 
	 * @return the assigningAuthority
	 */
	public AssigningAuthority getAssigningAuthority()
	{
		return this.assigningAuthority;
	}

	/**
	 * @return the identifierTypeCode
	 */
	public String getIdentifierTypeCode()
	{
		return this.identifierTypeCode;
	}

	/**
	 * @return the assigningFacility
	 */
	public AssigningFacility getAssigningFacility()
	{
		return this.assigningFacility;
	}

	/**
	 * @return the effectiveDate
	 */
	public Date getEffectiveDate()
	{
		return this.effectiveDate;
	}

	/**
	 * @return the expirationDate
	 */
	public Date getExpirationDate()
	{
		return this.expirationDate;
	}

	@Override
	public String toString()
	{
		String result =  
			( (getPatientId() == null ? "" : "" + getPatientId()) + COMPONENT_DELIMITER) +
			( (getPatientIdCheckDigit() == null ? "" : "" + getPatientIdCheckDigit()) + COMPONENT_DELIMITER)+
			( (getPatientIdCheckDigitCode() == null ? "" : "" + getPatientIdCheckDigitCode()) + COMPONENT_DELIMITER) +
			( (getAssigningAuthority() == null ? "" : "" + getAssigningAuthority().toString()) + COMPONENT_DELIMITER) +
			( (getIdentifierTypeCode() == null ? "" : "" + getIdentifierTypeCode()) + COMPONENT_DELIMITER) +
			( (getAssigningFacility() == null ? "" : "" + getAssigningFacility().toString()) + COMPONENT_DELIMITER) +
			( (getEffectiveDate() == null ? "" : "" + dateFormat.format(getEffectiveDate())) + COMPONENT_DELIMITER) +
			( (getExpirationDate() == null ? "" : "" + dateFormat.format(getExpirationDate())) + COMPONENT_DELIMITER);
		
		// remove trailing caret characters (e.g. 123^345^234^^^^ becomes 123^345^234) 
		while(result.endsWith(COMPONENT_DELIMITER))
			result = result.substring(0, result.length()-1);
		
		return result;
	}
	
	/**
	 * 
	 * @param assigningAuthority
	 * @return
	 */
	private static AssigningAuthority createAssigningAuthority(String assigningAuthority)
	{
		String[] subcomponents = assigningAuthority.split(SUBCOMPONENT_DELIMITER_REGEX);
		return new AssigningAuthority(
			subcomponents.length > AUTHORITY_NAMESPACE_SUBINDEX ? subcomponents[AUTHORITY_NAMESPACE_SUBINDEX] : null,
			subcomponents.length > AUTHORITY_UNIVERSALID_SUBINDEX ? subcomponents[AUTHORITY_UNIVERSALID_SUBINDEX] : null,
			subcomponents.length > AUTHORITY_UNIVERSALIDTYPE_SUBINDEX ? subcomponents[AUTHORITY_UNIVERSALIDTYPE_SUBINDEX] : null 
		);
			
	}

	private static AssigningFacility createAssigningFacility(String assigningFacility)
	{
		String[] subcomponents = assigningFacility.split(SUBCOMPONENT_DELIMITER_REGEX);
		return new AssigningFacility(
			subcomponents.length > AUTHORITY_NAMESPACE_SUBINDEX ? subcomponents[AUTHORITY_NAMESPACE_SUBINDEX] : null,
			subcomponents.length > AUTHORITY_UNIVERSALID_SUBINDEX ? subcomponents[AUTHORITY_UNIVERSALID_SUBINDEX] : null,
			subcomponents.length > AUTHORITY_UNIVERSALIDTYPE_SUBINDEX ? subcomponents[AUTHORITY_UNIVERSALIDTYPE_SUBINDEX] : null 
		);
	}
	
	/**
	 * Components that have subcomponents:
	 * <namespace ID (IS)> & <universal ID (ST)> & <universal ID type (ID)>
	 *
	 */
	private static abstract class AssigningThing
	{
		private final String namespaceID;
		private final String universalID;
		private final String universalIDType;
		/**
		 * @param namespaceID
		 * @param universalID
		 * @param universalIDType
		 */
		public AssigningThing(String namespaceID, String universalID, String universalIDType)
		{
			super();
			this.namespaceID = namespaceID;
			this.universalID = universalID;
			this.universalIDType = universalIDType;
		}
		/**
		 * @return the namespaceID
		 */
		public String getNamespaceID()
		{
			return this.namespaceID;
		}
		/**
		 * @return the universalID
		 */
		public String getUniversalID()
		{
			return this.universalID;
		}
		/**
		 * @return the universalIDType
		 */
		public String getUniversalIDType()
		{
			return this.universalIDType;
		}
		
		@Override
		public String toString()
		{
			return (getNamespaceID() == null ? "" : "" + getNamespaceID()) + SUBCOMPONENT_DELIMITER + 
				(getUniversalID() == null ? "" : "" + getUniversalID()) + SUBCOMPONENT_DELIMITER +
				(getUniversalIDType() == null ? "" : "" + getUniversalIDType());
		}
	}
	
	/**
	 * Subcomponents of assigning authority:
	 * <namespace ID (IS)> & <universal ID (ST)> & <universal ID type (ID)>
	 * @author vhaiswbeckec
	 */
	public static class AssigningAuthority
	extends AssigningThing
	{
		/**
		 * @param namespaceID
		 * @param universalID
		 * @param universalIDType
		 */
		public AssigningAuthority(String namespaceID, String universalID, String universalIDType)
		{
			super(namespaceID, universalID, universalIDType);
		}
	}
	
	/**
	 * Subcomponents of assigning facility:
	 * <namespace ID (IS)> & <universal ID (ST)> & <universal ID type (ID)>
	 * @author vhaiswbeckec
	 */
	public static class AssigningFacility
	extends AssigningThing
	{
		/**
		 * @param namespaceID
		 * @param universalID
		 * @param universalIDType
		 */
		public AssigningFacility(String namespaceID, String universalID, String universalIDType)
		{
			super(namespaceID, universalID, universalIDType);
		}
	}
	
}
