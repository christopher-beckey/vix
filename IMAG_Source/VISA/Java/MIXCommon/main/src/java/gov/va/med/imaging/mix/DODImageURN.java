package gov.va.med.imaging.mix;

import gov.va.med.URN;
import gov.va.med.imaging.BhieImageURN;
import gov.va.med.imaging.ImageURN;
import gov.va.med.imaging.StringUtil;
import gov.va.med.imaging.exceptions.URNFormatException;

/**
 * @author vacotittoc
 *
 */
public class DODImageURN
{	
	// URN ::= "urn:" <NID> ":" <NSS> 
	private static String DEFAULT_REPOSITORY_ID = "200";
	private static final String bhieNameSpace = "bhieimage"; // <NID>
	private BhieImageURN dodURN=null;
	// <NSS> -- Namespace Specific String (upper, lower. number, %, hex and these: ( ) + , - . : = @ ; $ _ ! * '
	private static String NSS_separator = "" + ImageURN.namespaceSpecificStringDelimiter;
	
	public DODImageURN() {
	}
	public DODImageURN(ImageURN imageURN) {
		dodURN = (BhieImageURN)imageURN;
	}
	
	public BhieImageURN create(String studyUID, String seriesUID, String instanceUID) 
	throws URNFormatException
	{

		// ?base32 conversion of UIDs? - not needed
		// dodURN = "urn:bhieimage:dodId
		//     dodId = 200-<studyUID>-<SeriesUID>-<instanceUID>
		String dodId = // "urn" + URN.urnComponentDelimiter + BhieImageURN.NAMESPACE + URN.urnComponentDelimiter +
				DEFAULT_REPOSITORY_ID + 
				NSS_separator + studyUID + NSS_separator + seriesUID + NSS_separator + instanceUID;
		return	BhieImageURN.create(dodId);
	};

	public String getDODPrefix()
	{
		return ("urn:" + bhieNameSpace + ":" + DEFAULT_REPOSITORY_ID);
	}
	
	private String getNSSpart(int i) 
	{
		String nSS=null;
		String nSSpart=null;
//		if ((dodURN!=null) && !dodURN.isEmpty())
		if ((dodURN!=null) && !dodURN.toString().isEmpty())
		{
			String[] urnParts = StringUtil.split(dodURN.toString(), URN.urnComponentDelimiter);
			nSS = urnParts[2];
			if ((nSS!=null) && !nSS.isEmpty()) {
				String[] nssParts = StringUtil.split(nSS, NSS_separator);
				nSSpart = nssParts[i];
			}
		}
		return nSSpart;
		
	}
	public String getStudyUID()
	{
		return getNSSpart(1);
	}

	public String getSeriesUID()
	{
		return getNSSpart(2);
	}

	public String getInstanceUID()
	{
		return getNSSpart(3);
	}
}
