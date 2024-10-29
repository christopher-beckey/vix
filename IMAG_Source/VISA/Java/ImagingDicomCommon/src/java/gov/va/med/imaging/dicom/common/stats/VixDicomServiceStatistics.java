package gov.va.med.imaging.dicom.common.stats;

import java.lang.management.ManagementFactory;
import java.util.HashSet;
import java.util.Hashtable;
import java.util.Iterator;
import java.util.Set;

import javax.management.MBeanServer;
import javax.management.ObjectName;

import gov.va.med.imaging.ImagingMBean;

public class VixDicomServiceStatistics 
implements VixDicomServiceStatisticsMBean {

	private static VixDicomServiceStatistics instance_ = null;
	private static ObjectName vixDicomServiceStatisticsMBeanName = null;
    
    
	private Set<VixDicomServicesStoreSCUStatistics> vixStorageSCUStatistics;


	public VixDicomServiceStatistics() {
		vixStorageSCUStatistics = new HashSet<VixDicomServicesStoreSCUStatistics>();
	}
	
	public synchronized static VixDicomServiceStatistics getInstance(){
		if(instance_ == null){
			instance_ = new VixDicomServiceStatistics();
			registerResourceMBeans();
		}
		return instance_;
	}
	
	protected synchronized VixDicomServicesStoreSCUStatistics getFromStorageSCUList(String aet){
		
		VixDicomServicesStoreSCUStatistics statEntry;
		
		if(aet != null && aet.length()>0){
			aet = aet.trim();
		}
		
		if(vixStorageSCUStatistics.isEmpty()){
			statEntry = new VixDicomServicesStoreSCUStatistics(aet);
			String objName = "VixSendToAEFailures";
			String objNumber = Integer.toString(vixStorageSCUStatistics.size());
			registerAddedResourceMBeans(objName, objNumber, statEntry);
			vixStorageSCUStatistics.add(statEntry);
			return statEntry;
		}
		Iterator<VixDicomServicesStoreSCUStatistics> iter = vixStorageSCUStatistics.iterator();
		while(iter.hasNext()){
			statEntry = iter.next();
			if((statEntry!=null) 
					&& (statEntry.getAeTitle().equals(aet))){
				return statEntry;
			}
		}
		statEntry = new VixDicomServicesStoreSCUStatistics(aet);
		String objName = "VixSendToAEFailures";
		String objNumber = Integer.toString(vixStorageSCUStatistics.size());
		registerAddedResourceMBeans(objName, objNumber, statEntry);
		vixStorageSCUStatistics.add(statEntry);
		return statEntry;
	}

	public void incrementVixSendToAEFailureCount(String aet){
		try {
			VixDicomServicesStoreSCUStatistics sendFailure  = getFromStorageSCUList(aet);
			sendFailure.incrementVixSendToAEFailuresCount();
		} catch (Exception X) {
			//do nothing
		}
	}

	public void addToVixSendToAEFailureCount(String aet, int failuresCount){
		try {
			VixDicomServicesStoreSCUStatistics sendFailure  = getFromStorageSCUList(aet);
			sendFailure.addToVixSendToAEFailuresCount(failuresCount);
		} catch (Exception X) {
			//do nothing
		}
	}
	
	
	private synchronized static void registerResourceMBeans()
    {
		MBeanServer mBeanServer = ManagementFactory.getPlatformMBeanServer();
		
		if(vixDicomServiceStatisticsMBeanName == null)
		{
			try
            {
				Hashtable<String, String> mBeanProperties = new Hashtable<String, String>();
				mBeanProperties.put( "type", "VixDicomServices" );
				mBeanProperties.put( "name", "VixDicomServiceActivity");
				vixDicomServiceStatisticsMBeanName = new ObjectName(ImagingMBean.VIX_MBEAN_DOMAIN_NAME, mBeanProperties);
	            mBeanServer.registerMBean(VixDicomServiceStatistics.getInstance(), vixDicomServiceStatisticsMBeanName);
            } 
			catch (Exception e){ 
				e.printStackTrace();
			}
		}
	}
	
	private synchronized static void registerAddedResourceMBeans(String objName, String number, Object obj){

		MBeanServer mBeanServer = ManagementFactory.getPlatformMBeanServer();
		try
        {
			Hashtable<String, String> mBeanProperties = new Hashtable<String, String>();
			mBeanProperties.put( "type", "VixDicomServices" );
			mBeanProperties.put( "name", objName);
			mBeanProperties.put("number", number);
			ObjectName name = new ObjectName(ImagingMBean.VIX_MBEAN_DOMAIN_NAME, mBeanProperties);
            mBeanServer.registerMBean(obj, name);
        } 
		catch (Exception e){ 
			//Do nothing
		}
	}



}
