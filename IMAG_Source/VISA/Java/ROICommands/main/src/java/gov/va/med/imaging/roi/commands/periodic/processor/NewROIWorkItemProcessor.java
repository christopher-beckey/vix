/**
 * 
  Package: MAG - VistA Imaging
  WARNING: Per VHA Directive 2004-038, this routine should not be modified.
  Date Created: Mar 29, 2012
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
package gov.va.med.imaging.roi.commands.periodic.processor;

import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.roi.ROIWorkItem;
import gov.va.med.imaging.roi.ROIStatus;
import gov.va.med.imaging.roi.commands.facade.ROICommandsContext;

/**
 * @author VHAISWWERFEJ
 *
 */
public class NewROIWorkItemProcessor
extends AbstractROIWorkItemsProcessor
{

	/**
	 * @param expectedStatus
	 * @param newStatus
	 */
	public NewROIWorkItemProcessor()
	{
		super(ROIStatus.NEW.getStatus(), ROIStatus.LOADING_STUDY.getStatus());
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.roi.commands.periodic.processor.AbstractROIWorkItemsProcessor#processWorkItem(gov.va.med.imaging.exchange.business.WorkItem)
	 */
	@Override
	protected void processWorkItem(ROIWorkItem workItem)
	throws ConnectionException, MethodException
	{
		ROICommandsContext.getRouter().processROIGetStudyImages(workItem);
	}

}
