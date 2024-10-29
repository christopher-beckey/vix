package gov.va.med.imaging.mix;

import gov.va.med.URN;
import gov.va.med.imaging.ImageURN;
import gov.va.med.imaging.StringUtil;
import gov.va.med.imaging.exceptions.URNFormatException;

/**
 * @author vacotittoc
 *
 */
public class VAImageID
{	
	// URN ::= "urn:" <NID> ":" <NSS> 
	// <NSS> -- Namespace Specific String (upper, lower. number, %, hex and these: ( ) + , - . : = @ ; $ _ ! * '
	private static String VAimage_NNS_separator = "" + ImageURN.namespaceSpecificStringDelimiter;
	private String vaStudyId=null;
	
	public VAImageID() {
	}
	
	public VAImageID(String vaStudyId) {
		this.vaStudyId = vaStudyId;
	}
	
	public String create(String originatingSiteId, String assignedId, String studyId, String patientICN) 
	throws URNFormatException
	{

		// ?base32 conversion of UIDs? - not needed
		// VAImageID = "urn:vaimage:<siteId>-<assignedId>-<studyId>-<patientICN>
		vaStudyId = "urn" + URN.urnComponentDelimiter + ImageURN.getManagedNamespace().toString() + URN.urnComponentDelimiter + 
					originatingSiteId + VAimage_NNS_separator + assignedId + VAimage_NNS_separator + studyId + VAimage_NNS_separator + patientICN;
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
				String[] nssParts = StringUtil.split(nSS, VAimage_NNS_separator);
				nSSpart = nssParts[i];
			}
		}
		return nSSpart;
		
	}
	
	public String getOriginatingSiteId()
	{
		return getNSSpart(0);
	}

	public String getAssignedId()
	{
		return getNSSpart(1);
	}
	public String getStudyId()
	{
		return getNSSpart(2);
	}

	public String getPatientICN()
	{
		return getNSSpart(3);
	}
}
