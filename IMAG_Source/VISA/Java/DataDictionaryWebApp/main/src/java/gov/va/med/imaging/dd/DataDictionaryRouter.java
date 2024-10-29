/**
 * 
  Package: MAG - VistA Imaging
  WARNING: Per VHA Directive 2004-038, this routine should not be modified.
  Date Created: Aug 12, 2011
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
package gov.va.med.imaging.dd;

import java.util.List;

import gov.va.med.imaging.core.annotations.routerfacade.FacadeRouterInterface;
import gov.va.med.imaging.core.annotations.routerfacade.FacadeRouterInterfaceCommandTester;
import gov.va.med.imaging.core.annotations.routerfacade.FacadeRouterMethod;
import gov.va.med.imaging.core.interfaces.FacadeRouter;
import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.exchange.business.dd.DataDictionaryEntryQuery;
import gov.va.med.imaging.exchange.business.dd.DataDictionaryFile;
import gov.va.med.imaging.exchange.business.dd.DataDictionaryQuery;
import gov.va.med.imaging.exchange.business.dd.DataDictionaryResult;
import gov.va.med.imaging.exchange.business.dd.DataDictionaryResultEntry;

/**
 * @author VHAISWWERFEJ
 *
 */
@FacadeRouterInterface
@FacadeRouterInterfaceCommandTester
public interface DataDictionaryRouter
extends FacadeRouter 
{

	@FacadeRouterMethod(asynchronous=false, commandClassName="GetDataDictionaryValuesCommand")
	public abstract DataDictionaryResult getDataDictionaryValues(DataDictionaryQuery dataDictionaryQuery)
	throws MethodException, ConnectionException;
	
	@FacadeRouterMethod(asynchronous=false, commandClassName="GetDataDictionaryFileCommand")
	public abstract DataDictionaryFile getDataDictionaryFile(String fileNumber)
	throws MethodException, ConnectionException;
	
	@FacadeRouterMethod(asynchronous=false, commandClassName="GetDataDictionaryFilesCommand")
	public abstract List<DataDictionaryFile> getDataDictionaryFiles()
	throws MethodException, ConnectionException;
	
	@FacadeRouterMethod(asynchronous=false, commandClassName="GetDataDictionaryValueCommand")
	public abstract DataDictionaryResultEntry getDataDictionaryValue(DataDictionaryEntryQuery dataDictionaryEntryQuery)
	throws MethodException, ConnectionException;

	@FacadeRouterMethod(asynchronous=false, commandClassName="GetFileManEntryByValueCommand")
	public abstract String[] getFileManEntryByValue(String fileNum, String keyName, String keyValue)
	throws MethodException, ConnectionException;	

}
