/**
 * 
  Package: MAG - VistA Imaging
  WARNING: Per VHA Directive 2004-038, this routine should not be modified.
  Date Created: Apr 6, 2017
  Developer:  vhaisltjahjb
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
package gov.va.med.imaging.dx.datasource.test;

import gov.va.med.imaging.artifactsource.ResolvedArtifactSource;
import gov.va.med.imaging.datasource.DataSourceProvider;
import gov.va.med.imaging.datasource.DocumentSetDataSourceSpi;
import gov.va.med.imaging.exceptions.URNFormatException;
import gov.va.med.imaging.exchange.business.DocumentFilter;
import gov.va.med.imaging.exchange.business.documents.Document;
import gov.va.med.imaging.exchange.business.documents.DocumentSet;

import java.io.PrintStream;
import java.net.MalformedURLException;
import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.SortedSet;

/**
 * THIS IS NOT A JUNIT TEST!
 * 
 * @author vhaisltjahjb
 *
 */
public class DxDocumentSetDataSourceTest
extends AbstractDxDataSourceTest
{
	/**
	 * @param args
	 */
	public static void main(String[] args) 
	{
		initializeLogging();
		initializeConnectionHandlers();
		initializeTransactionContext();
		
		DateFormat df = new SimpleDateFormat("dd/MM/yyyy");
		
		//String patientIcn = "673951";					// a valid HAIMS ID
		//String patientIcn = "9876543210";				// another valid HAIMS ID
		//String patientIcn = "9876543210";				// and another valid HAIMS ID
		String patientIcn = "1006184063V088473";		// a known good VA ICN
		
		try
		{
			System.out.println("Getting all documents for patient '" + patientIcn + "'.");
			DxDocumentSetDataSourceTest test = new DxDocumentSetDataSourceTest();
			test.testDxDocumentQuery(getTestVAResolvedSite(), "dx", new DocumentFilter(patientIcn));

			System.out.println("Getting all documents for patient '" + patientIcn + "' between 01/01/2000 and 31/12/2009");
			try
			{
				test.testDxDocumentQuery(getTestVAResolvedSite(), "dx", 
					 new DocumentFilter(patientIcn, df.parse("01/01/2000"), df.parse("31/12/2009")));
			}
			catch (ParseException x)
			{
				x.printStackTrace();
			}
			
			System.out.println("Getting all documents for patient '" + patientIcn + "' of type 1");
			test.testDxDocumentQuery(getTestVAResolvedSite(), "dx", 
				 new DocumentFilter(patientIcn, "1"));
		}
		catch (MalformedURLException x)
		{
			x.printStackTrace();
		}
	}
	
	public void testDxDocumentQuery(ResolvedArtifactSource resolvedSite, String protocol, DocumentFilter filter)
	{
		try
		{
			DataSourceProvider provider = getProvider();
			
			System.out.println("Connecting to '" + resolvedSite.toString() + "'.");
			
			DocumentSetDataSourceSpi spi = provider.createDocumentSetDataSource(resolvedSite, protocol);
			
			SortedSet<DocumentSet> documentSets = spi.getPatientDocumentSets(resolvedSite.getArtifactSource().createRoutingToken(),
					filter).getArtifacts();
			
			printDocumentSets(documentSets, System.out);
		}
		catch(Exception ex)
		{
			ex.printStackTrace();
		}
	}

	/**
	 * 
	 * @param documentSets
	 * @param printStream
	 * @throws URNFormatException
	 */
	private void printDocumentSets(SortedSet<DocumentSet> documentSets, PrintStream printStream) 
	throws URNFormatException
	{
		printStream.println("Received '" + (documentSets == null ? "null" : "" + documentSets.size()) + "' document sets");
		if(documentSets != null)
		{
			for(DocumentSet set : documentSets)
			{
				printStream.print("'" + set.toString() + "'.");
				
				for(Document document : set)
				{
					try
					{
						printStream.println("\t'" + document.toString() + "'." );
					}
					catch (RuntimeException x)
					{
					}
				}
			}
		}
	}
}
