package gov.va.med.imaging.dx;

import java.util.ArrayList;
import java.util.List;

/**
 * @author vhaisltjahjb
 *
 */

public class DesPollerResult {
	List<DesPollerData> dataList;
	
	public DesPollerResult()
	{
		dataList = new ArrayList<DesPollerData>();
	}
	
	public void addRecord(DesPollerData data)
	{
		dataList.add(data);
	}
	
	public List<DesPollerData> getDesPollerDataList()
	{
		return dataList;
	}
}
