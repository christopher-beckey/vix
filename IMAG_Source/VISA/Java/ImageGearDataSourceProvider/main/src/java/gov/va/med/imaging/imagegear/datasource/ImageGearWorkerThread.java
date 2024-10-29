/**
 * 
  Package: MAG - VistA Imaging
  WARNING: Per VHA Directive 2004-038, this routine should not be modified.
  Date Created: Apr 30, 2012
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
package gov.va.med.imaging.imagegear.datasource;

import java.util.concurrent.CountDownLatch;

import gov.va.med.logging.Logger;

/**
 * Thread to do work executing a process.  This thread will wait for the completion of the process.
 * 
 * @author VHAISWWERFEJ
 *
 */
public class ImageGearWorkerThread
extends Thread
{
	private final Process process;
	private final CountDownLatch countdownLatch;
	private final String description;
	private int exitCode;
	
	private final static Logger logger = Logger.getLogger(ImageGearWorkerThread.class);
	
	private static long threadId = 0;
	
	private synchronized static long getThreadId()
	{
		if(threadId >= Long.MAX_VALUE)
		{
			threadId = 0;
			return threadId;
		}
		else
			
		return ++threadId;
	}
	
	public ImageGearWorkerThread(Process process, CountDownLatch countdownLatch, String description)
	{
		super("ImageGearWorker-" + getThreadId());
		this.process = process;
		this.exitCode = -1;
		this.countdownLatch = countdownLatch;
		this.description = description;
	}

	public int getExitCode()
	{
		return exitCode;
	}

	public void setExitCode(int exitCode)
	{
		this.exitCode = exitCode;
	}

	@Override
	public void run()
	{
		try
		{
            logger.debug("Executing process '{}'.", description);
			exitCode = process.waitFor();
            logger.debug("Process completed with exit code '{}'.", exitCode);
			countdownLatch.countDown();
		} 
		catch (InterruptedException e)
		{
            logger.warn("InterruptedException in thread [{}], {}", this.getName(), e.getMessage());
		}
	}
}
