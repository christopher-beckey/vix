package gov.va.med.imaging.dicom.email;

import gov.va.med.imaging.exchange.BaseTimedCacheValueItem;

public class DicomEmailTrackingCacheItem extends BaseTimedCacheValueItem
{
	DicomEmailInfo dicomEmailInfo;
	public DicomEmailTrackingCacheItem(DicomEmailInfo dicomEmailInfo)
	{
		this.dicomEmailInfo = dicomEmailInfo;
	}

	@Override
	public Object getKey()
	{
		return getCacheKey(dicomEmailInfo);
	}

	public static Object getCacheKey(DicomEmailInfo dicomEmailInfo)
	{
		StringBuffer buffer = new StringBuffer();
		buffer.append(dicomEmailInfo.getMessageType().toString() + "_");
		buffer.append(dicomEmailInfo.getDicomLevel().toString() + "_");
		buffer.append(dicomEmailInfo.getMessageId());
		return buffer.toString();
	}

	public DicomEmailInfo getDicomEmailInfo()
	{
		return dicomEmailInfo;
	}
}

