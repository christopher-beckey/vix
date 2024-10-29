/**
 * 
 */
package gov.va.med.imaging.ihe;

/**
 * @author vhaiswbeckec
 *
 * the standardized parameter names from:
 * IHE IT Infrastructure Technical Framework, vol. 2 (ITI TF-2): Transactions
 * 
 */
public enum FindDocumentStoredQueryParameterNames
{
	patientId("$XDSDocumentEntryPatientId"),
	classCode("$XDSDocumentEntryClassCode"),
	classCodeScheme("$XDSDocumentEntryClassCodeScheme"),
	practiceSettingCode("$XDSDocumentEntryPracticeSettingCode"),
	practiceSettingCodeScheme("$XDSDocumentEntryPracticeSettingCode"),
	creationTimeFrom("$XDSDocumentEntryCreationTimeFrom"),
	creationTimeTo("$XDSDocumentEntryCreationTimeTo"),
	serviceStartTimeFrom("$XDSDocumentEntryServiceStartTimeFrom"),
	serviceStartTimeTo("$XDSDocumentEntryServiceStartTimeTo"),
	serviceStopTimeFrom("$XDSDocumentEntryServiceStopTimeFrom"),
	serviceStopTimeTo("$XDSDocumentEntryServiceStopTimeTo"),
	healthcareFacilityTypeCode("$XDSDocumentEntryHealthcareFacilityTypeCode"),
	healthcareFacilityTypeCodeScheme("$XDSDocumentEntryHealthcareFacilityTypeCodeScheme"),
	eventCodeList("$XDSDocumentEntryEventCodeList"),
	eventCodeListScheme("$XDSDocumentEntryEventCodeListScheme"),
	confidentialityCodeList("$XDSDocumentEntryConfidentialityCode"),
	confidentialityCodeListScheme("$XDSDocumentEntryConfidentialityCodeScheme"),
	author("$XDSDocumentEntryAuthorPerson4"),
	formatCode("$XDSDocumentEntryFormatCode"),
	entryStatus("$XDSDocumentEntryStatus");

	private final String key;
	
	FindDocumentStoredQueryParameterNames(String key)
	{
		this.key = key;
	}

	public String getKey()
	{
		return this.key;
	}

	@Override
	public String toString()
	{
		return getKey();
	}
	
	/**
	 * 
	 * @param key
	 * @return
	 */
	public static FindDocumentStoredQueryParameterNames valueOfKey(String key)
	{
		if(key == null)
			return null;
		
		for(FindDocumentStoredQueryParameterNames qp : FindDocumentStoredQueryParameterNames.values())
			if(key.equals(qp.key))
				return qp;
		
		return null;
	}
}
