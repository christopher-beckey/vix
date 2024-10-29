// Copyright Laurel Bridge Software, Inc.  All rights reserved.  See distributed license file.
package gov.va.med.imaging.study.lbs;


import com.lbs.DCS.DCSException;
import com.lbs.DCS.DicomAEMapping;
import com.lbs.DCS.DicomDataDictionary;

public class CustomDicomDataDictionary extends DicomDataDictionary
{
	private static DicomDataDictionary instance_;
	
	public static void setup()
		throws DCSException
	{
		if( instance_ != null )
		{
			instance_ = null;
		}
		instance_ = new CustomDicomDataDictionary();
		setInstance( instance_ );
	}
	/**
	* Return a mapping for a given AE title string. This is an example.  In an
	* OEM application you probably do not want to call the base class first.
	* Called to resolve C-Move destinations.
	* @param ae_title Get the mapping for this AE Title.
	* @return The requested mapping.
	* @throws DCSException Thrown when no mapping is found.
	*/
	public DicomAEMapping getAETitleMapping( String ae_title )
		throws DCSException
	{
		DicomAEMapping returnValue = null;
		try
		{
			returnValue = super.getAETitleMapping( ae_title );
		}
		catch( DCSException e )
		{
			LOG.error( -1, "No AE Title mapping in default list", e );
		}

		return returnValue;
	}
	
	protected CustomDicomDataDictionary()
		throws DCSException
	{
	}
}