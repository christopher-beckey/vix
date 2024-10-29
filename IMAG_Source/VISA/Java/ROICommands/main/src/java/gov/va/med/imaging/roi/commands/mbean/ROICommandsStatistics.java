/**
 * 
  Package: MAG - VistA Imaging
  WARNING: Per VHA Directive 2004-038, this routine should not be modified.
  Date Created: Apr 20, 2012
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
package gov.va.med.imaging.roi.commands.mbean;

import gov.va.med.imaging.ImagingMBean;

import java.lang.management.ManagementFactory;
import java.util.ArrayList;
import java.util.Hashtable;
import java.util.List;

import javax.management.MBeanServer;
import javax.management.ObjectName;

import gov.va.med.logging.Logger;

/**
 * @author VHAISWWERFEJ
 *
 */
public class ROICommandsStatistics 
implements ROICommandsStatisticsMBean
{
	private final static Logger logger = Logger.getLogger(ROICommandsStatistics.class);
	
	private boolean roiPeriodicProcessing;
	private String roiPeriodicProcessingError;
	private boolean roiCompletedItemsPurgeProcessing;
	private boolean roiProcessWorkItemImmediately;
	
	private long roiDisclosureRequests;
	private long roiDisclosureProcessingErrors;
	private long roiDisclosuresCompleted;
	private long roiStudiesSentToExportQueue;
	private long roiDisclosuresCancelled;
	
	public ROICommandsStatistics()
	{
		super();
		this.roiPeriodicProcessing = false;
		this.roiPeriodicProcessingError = null;
		this.roiCompletedItemsPurgeProcessing = false;
		this.roiDisclosureRequests = 0L;
		this.roiDisclosureProcessingErrors = 0L;
		this.roiDisclosuresCompleted = 0L;
		this.roiStudiesSentToExportQueue = 0L;
		this.roiDisclosuresCancelled = 0L;
		this.roiProcessWorkItemImmediately = false;
	}

	public boolean isRoiPeriodicProcessing()
	{
		return roiPeriodicProcessing;
	}
				  
	public String getRoiPeriodicProcessingError()
	{
		return roiPeriodicProcessingError;
	}

	public void setRoiPeriodicProcessingError(String roiPeriodicProcessingError)
	{
		this.roiPeriodicProcessingError = roiPeriodicProcessingError;
	}

	public void setRoiPeriodicProcessing(boolean roiPeriodicProcessing)
	{
		this.roiPeriodicProcessing = roiPeriodicProcessing;
	}
	
	public boolean isRoiCompletedItemsPurgeProcessing()
	{
		return roiCompletedItemsPurgeProcessing;
	}

	public void setRoiCompletedItemsPurgeProcessing(
			boolean roiCompletedItemsPurgeProcessing)
	{
		this.roiCompletedItemsPurgeProcessing = roiCompletedItemsPurgeProcessing;
	}

	public long getRoiDisclosureRequests()
	{
		return roiDisclosureRequests;
	}

	public void setRoiDisclosureRequests(long roiDisclosureRequests)
	{
		this.roiDisclosureRequests = roiDisclosureRequests;
	}

	public long getRoiDisclosureProcessingErrors()
	{
		return roiDisclosureProcessingErrors;
	}

	public void setRoiDisclosureProcessingErrors(long roiDisclosureProcessingErrors)
	{
		this.roiDisclosureProcessingErrors = roiDisclosureProcessingErrors;
	}

	public long getRoiDisclosuresCompleted()
	{
		return roiDisclosuresCompleted;
	}

	public void setRoiDisclosuresCompleted(long roiDisclosuresCompleted)
	{
		this.roiDisclosuresCompleted = roiDisclosuresCompleted;
	}

	public long getRoiStudiesSentToExportQueue()
	{
		return roiStudiesSentToExportQueue;
	}

	public void setRoiStudiesSentToExportQueue(long roiStudiesSentToExportQueue)
	{
		this.roiStudiesSentToExportQueue = roiStudiesSentToExportQueue;
	}

	public long getRoiDisclosuresCancelled()
	{
		return roiDisclosuresCancelled;
	}

	public void setRoiDisclosuresCancelled(long roiDisclosuresCancelled)
	{
		this.roiDisclosuresCancelled = roiDisclosuresCancelled;
	}

	public synchronized void incrementRoiDisclosureRequests()
	{
		roiDisclosureRequests++;
	}
	
	public synchronized void incrementRoiDisclosureProcessingErrors()
	{
		roiDisclosureProcessingErrors++;
	}

	public synchronized void incrementRoiDisclosuresCompleted()
	{
		roiDisclosuresCompleted++;
	}
	
	public synchronized void incrementRoiStudiesSentToExportQueue()
	{
		roiStudiesSentToExportQueue++;
	}
	
	public synchronized void incrementRoiDisclosuresCancelled()
	{
		roiDisclosuresCancelled++;
	}

	public boolean isRoiProcessWorkItemImmediately()
	{
		return roiProcessWorkItemImmediately;
	}

	public void setRoiProcessWorkItemImmediately(
			boolean roiProcessWorkItemImmediately)
	{
		this.roiProcessWorkItemImmediately = roiProcessWorkItemImmediately;
	}

	private static ObjectName roiCommandsProcessingStatisticsMBeanName = null;
	public static Object roiCommandsStatistics = null;
	public synchronized static ROICommandsStatistics getRoiCommandsStatistics()
	{
		if(roiCommandsStatistics == null)
		{
			roiCommandsStatistics = new ROICommandsStatistics();
			registerMBeanServer();
		}
		return (ROICommandsStatistics) roiCommandsStatistics;
	}
	
	
	private static synchronized void registerMBeanServer()
	{
		if(roiCommandsProcessingStatisticsMBeanName == null)
		{
			logger.info("Registering ROI Commands Statistics with JMX");
			try
			{
	            // add statistics
				MBeanServer mBeanServer = ManagementFactory.getPlatformMBeanServer();
				Hashtable<String, String> mBeanProperties = new Hashtable<String, String>();
				mBeanProperties.put( "type", "ROIProcessingCommands" );
				mBeanProperties.put( "name", "Statistics");
				roiCommandsProcessingStatisticsMBeanName = new ObjectName(ImagingMBean.VIX_MBEAN_DOMAIN_NAME, mBeanProperties);
				mBeanServer.registerMBean(getRoiCommandsStatistics(), roiCommandsProcessingStatisticsMBeanName);
			}
			catch(Exception ex)
			{
				logger.error("Error registering ROI Commands Statistics with JMX", ex);
			}
		}
	}


}
