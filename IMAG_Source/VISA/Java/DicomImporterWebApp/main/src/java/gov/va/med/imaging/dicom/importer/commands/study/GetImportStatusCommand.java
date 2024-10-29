/**
 * 
  Package: MAG - VistA Imaging
  WARNING: Per VHA Directive 2004-038, this routine should not be modified.
  Date Created: May 26, 2010
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
package gov.va.med.imaging.dicom.importer.commands.study;

import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.dicom.importer.DicomImporterRouter;
import gov.va.med.imaging.dicom.importer.commands.AbstractDicomImporterCommand;
import gov.va.med.imaging.exchange.business.dicom.importer.ImporterUtils;
import gov.va.med.imaging.exchange.business.dicom.importer.ImporterWorkItem;
import gov.va.med.imaging.exchange.business.dicom.importer.Study;
import gov.va.med.imaging.exchange.translation.exceptions.TranslationException;

import java.io.InputStream;

import com.thoughtworks.xstream.XStream;

/**
 * @author vhaiswlouthj
 *
 */
public class GetImportStatusCommand 
extends AbstractDicomImporterCommand<Study, String>
{
	private Study study = null;
	private final String interfaceVersion;
	
	public GetImportStatusCommand(String studyXml,  String interfaceVersion)
	{
		super("createImporterWorkItemCommand");
		
		XStream xstream = ImporterUtils.getXStream();
		this.study = (Study)xstream.fromXML(studyXml);
		this.interfaceVersion = interfaceVersion;

	}

	@Override
	protected Study executeRouterCommand() 
	throws MethodException, ConnectionException 
	{
		DicomImporterRouter router = getRouter();		
		Study result = router.getStudyImportStatus(getStudy());
		setEntriesReturned(1);
		return result;
	}


	@Override
	public String getInterfaceVersion() 
	{
		return this.interfaceVersion;
	}

	@Override
	protected String getMethodParameterValuesString()
	{
		return "study UID: [" + study.getUid() + "]";
	}

	@Override
	protected Class<String> getResultClass() 
	{
		return String.class;
	}

	@Override
	protected String translateRouterResult(Study routerResult) 
	throws TranslationException 
	{
		XStream xstream = ImporterUtils.getXStream();
    	return xstream.toXML(routerResult);
	}

	public void setStudy(Study study)
	{
		this.study = study ;
	}

	public Study getStudy()
	{
		return study;
	}

}
