package gov.va.med.imaging.mix;

import gov.va.med.URN;
import gov.va.med.imaging.StudyURN;
// import gov.va.med.imaging.ImageURN;
import gov.va.med.imaging.StringUtil;
import gov.va.med.imaging.exceptions.URNFormatException;

// import gov.va.med.imaging.ImageURN;
/**
 * @author vacotittoc
 *
 */
public class VAStudyID
{	
	// URN ::= "urn:" <NID> ":" <NSS> 
	// <NSS> -- Namespace Specific String (upper, lower. number, %, hex and these: ( ) + , - . : = @ ; $ _ ! * '
	private static String VAstudy_NNS_separator = "" + StudyURN.namespaceSpecificStringDelimiter;
	private String vaStudyId=null;
	
	public VAStudyID() {
	}
	
	public VAStudyID(String vaStudyId) {
		this.vaStudyId = vaStudyId;
	}
	
	public String create(String originatingSiteId, String studyId, String patientICN) 
	throws URNFormatException
	{
		// ?base32 conversion of UIDs? - not needed
		// VAstudyID = "urn:vastudy:<siteId>-<studyId>-<patientICN>
		vaStudyId = "urn" + URN.urnComponentDelimiter + StudyURN.getManagedNamespace().toString() + URN.urnComponentDelimiter + 
					originatingSiteId + VAstudy_NNS_separator + studyId + VAstudy_NNS_separator + patientICN;
		return	vaStudyId;
	};
	
	private String getNSSpart(int i) 
	{
		String nSS=null;
		String nSSpart=null;
		if ((vaStudyId!=null) && !vaStudyId.isEmpty())
		{
			String[] urnParts = StringUtil.split(vaStudyId, URN.urnComponentDelimiter);
			nSS = urnParts[2];
			if ((nSS!=null) && !nSS.isEmpty()) {
				String[] nssParts = StringUtil.split(nSS, VAstudy_NNS_separator);
				nSSpart = nssParts[i];
			}
		}
		return nSSpart;
		
	}
	
	public String getOriginatingSiteId()
	{
		return getNSSpart(0);
	}

	public String getStudyId()
	{
		return getNSSpart(1);
	}

	public String getPatientICN()
	{
		return getNSSpart(2);
	}
}
