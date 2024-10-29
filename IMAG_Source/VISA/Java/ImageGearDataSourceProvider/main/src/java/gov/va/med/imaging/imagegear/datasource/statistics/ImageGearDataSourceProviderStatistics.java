/**
 * 
  Package: MAG - VistA Imaging
  WARNING: Per VHA Directive 2004-038, this routine should not be modified.
  Date Created: Apr 9, 2012
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
package gov.va.med.imaging.imagegear.datasource.statistics;

/**
 * @author VHAISWWERFEJ
 *
 */
public class ImageGearDataSourceProviderStatistics
implements ImageGearDataSourceProviderStatisticsMBean
{
	private long disclosureWriteRequests = 0L;
	private long disclosureWriteSuccess = 0L;
	private long disclosureWriteFailures = 0L;
	private long burnAnnotationRequests = 0L;
	private long burnAnnotationSuccess = 0L;
	private long burnAnnotationFailures = 0L;
	
	public ImageGearDataSourceProviderStatistics()
	{
		super();
	}

	@Override
	public long getDisclosureWriteRequests()
	{
		return disclosureWriteRequests;
	}

	@Override
	public long getDisclosureWriteSuccess()
	{
		return disclosureWriteSuccess;
	}

	@Override
	public long getDisclosureWriteFailures()
	{
		return disclosureWriteFailures;
	}
	
	@Override
	public long getBurnAnnotationRequests()
	{
		return burnAnnotationRequests;
	}

	@Override
	public long getBurnAnnotationSuccess()
	{
		return burnAnnotationSuccess;
	}

	@Override
	public long getBurnAnnotationFailures()
	{
		return burnAnnotationRequests;
	}

	public void incrementDisclosureWriteRequests()
	{
		this.disclosureWriteRequests++;
	}

	public void incrementDisclosureWriteSuccess()
	{
		this.disclosureWriteSuccess ++;
	}

	public void incrementDisclosureWriteFailures()
	{
		this.disclosureWriteFailures++;
	}
	
	public void incrementBurnAnnotationRequests()
	{
		this.burnAnnotationRequests++;
	}
	
	public void incrementBurnAnnotationFailures()
	{
		this.burnAnnotationFailures++;
	}
	
	public void incrementBurnAnnotationSuccess()
	{
		this.burnAnnotationSuccess++;
	}

}
