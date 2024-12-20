/**
 * 
  Package: MAG - VistA Imaging
  WARNING: Per VHA Directive 2004-038, this routine should not be modified.
  Date Created: Oct 14, 2011
  Site Name:  Washington OI Field Office, Silver Spring, MD
  Developer:  vhaiswwerfej
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
package gov.va.med.imaging.router.commands;

import gov.va.med.imaging.core.router.AbstractCommandImpl;
import gov.va.med.imaging.router.commands.provider.ImagingCommandContext;

import gov.va.med.logging.Logger;

/**
 * @author vhaiswwerfej
 *
 */
public abstract class AbstractImagingCommandImpl<R extends Object> 
extends AbstractCommandImpl<R>
{
	
	private static final long serialVersionUID = 5235508122230827977L;
	protected final static Logger logger = Logger.getLogger(AbstractImagingCommandImpl.class);


	protected ImagingCommandContext getCommandContext()
	{
		return (ImagingCommandContext)super.getCommandContext();
	}

}
