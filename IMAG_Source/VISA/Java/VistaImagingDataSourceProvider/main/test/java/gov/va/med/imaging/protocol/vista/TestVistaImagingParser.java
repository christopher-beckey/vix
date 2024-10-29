package gov.va.med.imaging.protocol.vista;

import gov.va.med.imaging.exchange.business.Site;
import gov.va.med.imaging.exchange.business.Study;
import gov.va.med.imaging.exchange.enums.StudyDeletedImageState;
import gov.va.med.imaging.exchange.enums.StudyLoadLevel;
import gov.va.med.imaging.protocol.vista.VistaImagingParser.ParsedVistaLine;

import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.LineNumberReader;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;
import java.util.SortedSet;

import junit.framework.TestCase;

import org.apache.logging.log4j.Level;
import gov.va.med.logging.Logger;
import org.apache.logging.log4j.core.config.Configurator;
import org.junit.Ignore;

/**
 * 
 * @author vhaiswbeckec
 *
 */
public class TestVistaImagingParser 
extends TestCase
{
	private Logger logger = Logger.getLogger(this.getClass());
	private List<TestPointStimulusAndResults> testPoints;
	
    private static VistaImagingParser.OntologyDelimiterKey[] delimiterKeys = new VistaImagingParser.OntologyDelimiterKey[]
    {
  		new VistaImagingParser.OntologyDelimiterKey("NEXT_STUDY", new String[] {"STUDY_MODALITY"}),
  		new VistaImagingParser.OntologyDelimiterKey("NEXT_SERIES"),
  		new VistaImagingParser.OntologyDelimiterKey("NEXT_IMAGE")
    };
                                                                                                  	    
	@Override
    protected void setUp() 
	throws Exception
    {
	    super.setUp();
	    Configurator.setRootLevel(Level.TRACE);
	    
	    testPoints = new ArrayList<TestPointStimulusAndResults>();
	    
	    // first test point
	    String[] lines = new String[]
	    {
    		"13", 
    		"NEXT_CONTEXTID|RPT^CPRS^419^RA^6839169.8846-1^70^CAMP MASTER^^^^^^1|1|7",
    		"NEXT_STUDY|1.2.840.113754.1.4.500.6839169.8846.1.83016.70|",
    		"STUDY_UID|1.2.840.113754.1.4.500.6839169.8846.1.83016.70",
    		"STUDY_IEN|5125|1|5126|71010|500",
    		"STUDY_INFO|^^   ^08/30/2016 11:53^RAD CR^^CHEST SINGLE VIEW^RAD^CLIN^IMAGE^RADIOLOGY^COMPUTED RADIOGRAPHY^VA^08/30/2016 12:03:48^^5125|777",
    		"STUDY_PAT|419|10121V598061|TWENTYONE,PATIENT",
    		"NEXT_SERIES",
    		"SERIES_IEN|5125",
    		"SERIES_NUMBER|1",
    		"NEXT_IMAGE",
    		"IMAGE_IEN|5126",
    		"GROUP_IEN|5125",
    		"IMAGE_INFO|^5126^\\\\54.235.72.148\\IMAGE1$\\PAN0\\00\\00\\00\\51\\PAN00000005126.DCM^\\\\54.235.72.148\\IMAGE1$\\PAN0\\00\\00\\00\\51\\PAN00000005126.ABS^CHEST SINGLE VIEW (#1)^3160830.1153^100^CR^08/30/2016 11:53^^M^A^^^1^1^PAN^^^419^TWENTYONE,PATIENT^CLIN^08/30/2016 12:03:48^02/09/2016 13:11:36^5125^^^^0^1^1^0^^1^Image is Viewable.^RAD^"
	    };
	    List<ParsedVistaLine> expectedLines = new ArrayList<ParsedVistaLine>();
	    
	    ParsedVistaLine currentLine = null;
	    
	    ParsedVistaLine rootLine = new ParsedVistaLine("NEXT_STUDY", new String[]{"1.2.840.113754.1.4.500.6839169.8846.1.83016.70",""});
	    rootLine.addProperty("STUDY_UID", new String[]{"1.2.840.113754.1.4.500.6839169.8846.1.83016.70"});
	    rootLine.addProperty("STUDY_IEN", new String[]{"5125","1","5126","71010","500"});
	    rootLine.addProperty("STUDY_INFO", new String[]{"^^   ^08/30/2016 11:53^RAD CR^^CHEST SINGLE VIEW^RAD^CLIN^IMAGE^RADIOLOGY^COMPUTED RADIOGRAPHY^VA^08/30/2016 12:03:48^^5125","777"});
	    rootLine.addProperty("STUDY_PAT", new String[]{"419", "10121V598061", "TWENTYONE,PATIENT"});
	    currentLine = rootLine.addChild("NEXT_SERIES", null);
	    currentLine.addProperty("SERIES_IEN", new String[]{"5125"});
	    currentLine.addProperty("SERIES_NUMBER", new String[]{"1"});
	    currentLine = currentLine.addChild("NEXT_IMAGE", null);
	    currentLine.addProperty("IMAGE_IEN", new String[]{"5126"});
	    currentLine.addProperty("GROUP_IEN", new String[]{"5125"});
	    currentLine.addProperty("IMAGE_INFO", new String[]{"^5126^\\\\54.235.72.148\\IMAGE1$\\PAN0\\00\\00\\00\\51\\PAN00000005126.DCM^\\\\54.235.72.148\\IMAGE1$\\PAN0\\00\\00\\00\\51\\PAN00000005126.ABS^CHEST SINGLE VIEW (#1)^3160830.1153^100^CR^08/30/2016 11:53^^M^A^^^1^1^PAN^^^419^TWENTYONE,PATIENT^CLIN^08/30/2016 12:03:48^02/09/2016 13:11:36^5125^^^^0^1^1^0^^1^Image is Viewable.^RAD^"});
	    
	    expectedLines.add( rootLine );
	    
	    testPoints.add( new TestPointStimulusAndResults(lines, delimiterKeys, expectedLines, 1) );
	    

	    List<List<VistaImagingParser.ParsedVistaLine>> spotCheckedLines = new ArrayList<List<VistaImagingParser.ParsedVistaLine>>();
	    
	    testPoints.add( new TestPointStimulusAndResults("singleStudyNoContent.studyGraph", delimiterKeys, spotCheckedLines, 1) );
	    testPoints.add( new TestPointStimulusAndResults("clinImages.studyGraph", delimiterKeys, spotCheckedLines, 1) );
	    testPoints.add( new TestPointStimulusAndResults("noSeries.studyGraph", delimiterKeys, spotCheckedLines, 1) );
	    testPoints.add( new TestPointStimulusAndResults("singleImageStudy.studyGraph", delimiterKeys, spotCheckedLines, 1) );
	    testPoints.add( new TestPointStimulusAndResults("studyGraph1.studyGraph", delimiterKeys, spotCheckedLines, 2) );
	    testPoints.add( new TestPointStimulusAndResults("singleImageGroup.studyGraph", delimiterKeys, spotCheckedLines, 1) );
	    testPoints.add( new TestPointStimulusAndResults("studyByIen.studyGraph", delimiterKeys, spotCheckedLines, 4) );
	    testPoints.add( new TestPointStimulusAndResults("multipleGroupsWithImages.studyGraph", delimiterKeys, spotCheckedLines, 4) );
    }
	
	/**
	 * 
	 */
	public void testParseLines()
	{
		for( TestPointStimulusAndResults testPoint : testPoints )
		{
			VistaImagingParser parser = new VistaImagingParser(testPoint.delimiterKeys);
			List<VistaImagingParser.ParsedVistaLine> actualResult = parser.parse(testPoint.getLines(), true);

			assertEquals(testPoint.toString(), testPoint.getExpectedRootLinesCount(), actualResult.size() );
			
			if(testPoint.isRequireOneToOneValidation())
				assertOneToOneCorrespondence(testPoint, actualResult);
			else
				assertSpotCheckedCorrespondence(testPoint, actualResult);
		}
	}

	private void assertOneToOneCorrespondence(
		TestPointStimulusAndResults testPoint,
		List<VistaImagingParser.ParsedVistaLine> actualResult)
	{
		Iterator<VistaImagingParser.ParsedVistaLine> actualResultLines = actualResult.iterator();
		Iterator<VistaImagingParser.ParsedVistaLine> expectedResultLines = testPoint.oneToOneValidationLines.iterator();
		
		for( ; actualResultLines.hasNext() && expectedResultLines.hasNext(); )
		{
			VistaImagingParser.ParsedVistaLine actualLine = actualResultLines.next();
			VistaImagingParser.ParsedVistaLine expectedLine = expectedResultLines.next();
			
			assertEquals(expectedLine, actualLine);
		}
	}	

	private void assertSpotCheckedCorrespondence(
		TestPointStimulusAndResults testPoint,
		List<VistaImagingParser.ParsedVistaLine> actualResult)
	{

	}
	
	public void testStudyWithModality()
	{
		String studyGraphFile = "studyGraphWithModality.studyGraph";
		Site site = getSite();
		List<String> lines = new ArrayList<String>(); 
		try
        {
			InputStream inStream = getClass().getClassLoader().getResourceAsStream(studyGraphFile);
			LineNumberReader reader = new LineNumberReader( new InputStreamReader(inStream) );

			for( String line = reader.readLine(); line != null; line = reader.readLine() )
				lines.add(line);
			
            reader.close();
        } 
		catch (IOException e)
        {
			e.printStackTrace();
			fail(e.getMessage());
        }
		
		SortedSet<Study> studies = 
			VistaImagingTranslator.createStudiesFromGraph( site, lines.toArray(new String[lines.size()]), StudyLoadLevel.FULL, StudyDeletedImageState.cannotIncludeDeletedImages );
		validateStudiesHaveModality(studies);
	}
	
	private void validateStudiesHaveModality(SortedSet<Study> studies)
	{
        logger.info("Validating {} studies have modality", studies.size());
		for(Study study : studies)
		{
			assertNotNull("Null Modalities", study.getModalities());
			assertNotSame("0 modalities found", 0, study.getModalities().size());			
		}
	}
	
	/**
	 * A class that encapsulates the test data and the expected result.
	 * 
	 * @author vhaiswbeckec
	 *
	 */
	@Ignore
	class TestPointStimulusAndResults
	{
		private String[] lines;
		private final String sourceFileName;
		private final VistaImagingParser.OntologyDelimiterKey[] delimiterKeys;
		private final List<VistaImagingParser.ParsedVistaLine> oneToOneValidationLines;
		private final List<List<VistaImagingParser.ParsedVistaLine>> spotCheckedValidationLines;
		private final int expectedRootLines;
		
		public TestPointStimulusAndResults(
			String[] lines, 
			VistaImagingParser.OntologyDelimiterKey[] delimiterKeys, 
			List<VistaImagingParser.ParsedVistaLine> oneToOneValidationLines,
			int expectedRootLines)
        {
	        super();
	        this.lines = lines;
	        this.sourceFileName = null;
	        this.delimiterKeys = delimiterKeys;
	        this.oneToOneValidationLines = oneToOneValidationLines;
	        this.spotCheckedValidationLines = null;
	        this.expectedRootLines = expectedRootLines;
        }

		public TestPointStimulusAndResults(
			String sourceFileName, 
			VistaImagingParser.OntologyDelimiterKey[] delimiterKeys, 
			List<List<VistaImagingParser.ParsedVistaLine>> spotCheckedValidationLines,
			int expectedRootLines)
	    {
	        super();
	        this.lines = null;
	        this.sourceFileName = sourceFileName;
	        this.delimiterKeys = delimiterKeys;
	        this.oneToOneValidationLines = null;
	        this.spotCheckedValidationLines = spotCheckedValidationLines;
	        this.expectedRootLines = expectedRootLines;
	    }
		
		public boolean isRequireOneToOneValidation()
		{
			return this.oneToOneValidationLines != null;
		}

		public int getExpectedRootLinesCount()
		{
			return this.expectedRootLines;
		}
		
		public synchronized String[] getLines()
        {
			if(lines == null && sourceFileName != null)
			{
				List<String> lineList = new ArrayList<String>(); 
				try
	            {
					InputStream inStream = getClass().getClassLoader().getResourceAsStream(sourceFileName);
					LineNumberReader reader = new LineNumberReader( new InputStreamReader(inStream) );

					for( String line = reader.readLine(); line != null; line = reader.readLine() )
						lineList.add(line);
					
		            reader.close();
		            lines = lineList.toArray(new String[lineList.size()]);
	            }
				catch(IOException ioX){}
			}
			
        	return lines;
        }

		public VistaImagingParser.OntologyDelimiterKey[] getDelimiterKeys()
        {
        	return delimiterKeys;
        }

		public List<VistaImagingParser.ParsedVistaLine> getOneToOneValidationLines()
        {
        	return oneToOneValidationLines;
        }
		
		public List<List<VistaImagingParser.ParsedVistaLine>> getSpotCheckedValidationLines()
        {
        	return spotCheckedValidationLines;
        }

		@Override
		public String toString()
		{
			return sourceFileName != null ? sourceFileName : lines[0];
		}
	}
	
	private Site getSite()
	{
		Site site = new SLCSite2();
		return site;
	}
		
}
