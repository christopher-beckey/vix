package gov.va.med.imaging.url.vista;

import gov.va.med.imaging.url.vista.StringUtils;
import junit.framework.TestCase;

public class TestStringUtils 
extends TestCase
{
	public static PointStimulusAndResults[] testStimulus = 
	{
		new PointStimulusAndResults("HelloWorld", 
			new String[]{"HelloWorld"}),
		new PointStimulusAndResults("Hello|World", 
			new String[]{"Hello", "World"}),
		new PointStimulusAndResults("Hello|World|", 
			new String[]{"Hello", "World", ""}),
		new PointStimulusAndResults("NEXT_STUDY||712", 
			new String[]{"NEXT_STUDY", "", "712"}),
		new PointStimulusAndResults("STUDY_IEN|712", 
			new String[]{"STUDY_IEN", "712"}),
		new PointStimulusAndResults("STUDY_PAT|1011|9217103663V710366|IMAGPATIENT1011,1011", 
			new String[]{"STUDY_PAT", "1011", "9217103663V710366", "IMAGPATIENT1011,1011"}),
		new PointStimulusAndResults("NEXT_SERIES", 
			new String[]{"NEXT_SERIES"}),
		new PointStimulusAndResults("SERIES_IEN|712", 
			new String[]{"SERIES_IEN", "712"}),
		new PointStimulusAndResults("NEXT_IMAGE", 
			new String[]{"NEXT_IMAGE"}),
		new PointStimulusAndResults("IMAGE_IEN|713", 
			new String[]{"IMAGE_IEN", "713"}),
		new PointStimulusAndResults("IMAGE_INFO|B2^713^\\\\isw-werfelj-lt\\image1$\\DM\\00\\07\\DM000713.TGA^\\\\isw-werfelj-lt\\image1$\\DM\\00\\07\\DM000713.ABS^040600-28  CHEST SINGLE VIEW^3000406.1349^3^CR^04/06/2000^^M^A^^^1^1^SLC^^^1011^IMAGPATIENT1011,1011^CLIN^^^^", 
			new String[]{"IMAGE_INFO", "B2^713^\\\\isw-werfelj-lt\\image1$\\DM\\00\\07\\DM000713.TGA^\\\\isw-werfelj-lt\\image1$\\DM\\00\\07\\DM000713.ABS^040600-28  CHEST SINGLE VIEW^3000406.1349^3^CR^04/06/2000^^M^A^^^1^1^SLC^^^1011^IMAGPATIENT1011,1011^CLIN^^^^"}),
		new PointStimulusAndResults("IMAGE_ABSTRACT|\\\\isw-werfelj-lt\\image1$\\DM\\00\\07\\DM000713.ABS", 
			new String[]{"IMAGE_ABSTRACT", "\\\\isw-werfelj-lt\\image1$\\DM\\00\\07\\DM000713.ABS"}),
		new PointStimulusAndResults("IMAGE_FULL|\\\\isw-werfelj-lt\\image1$\\DM\\00\\07\\DM000713.TGA", 
			new String[]{"IMAGE_FULL", "\\\\isw-werfelj-lt\\image1$\\DM\\00\\07\\DM000713.TGA"}),
		new PointStimulusAndResults("IMAGE_TEXT|\\\\isw-werfelj-lt\\image1$\\DM\\00\\07\\DM000713.TXT", 
			new String[]{"IMAGE_TEXT", "\\\\isw-werfelj-lt\\image1$\\DM\\00\\07\\DM000713.TXT"})
	};
	
	public void testSplit()
	{
		for(PointStimulusAndResults challengeDatum : testStimulus)
		{
			String[] results = StringUtils.Split(challengeDatum.getStimulus(), "|");
			String[] stringSplitResults = challengeDatum.getStimulus().split("\\|", -1);
			
			// if the result is null and its supposed to be null, just keep going
			if(results == null && stringSplitResults == null && challengeDatum.getExpectedResult() == null)
				continue;
			
			if(results == null && challengeDatum.getExpectedResult() != null)
				fail( "For stimulus '" + challengeDatum.getStimulus() + "', " +
					"result was null, expected value was " + challengeDatum.getExpectedResult().length + " length String array");
			if(stringSplitResults == null && challengeDatum.getExpectedResult() != null)
				fail( "For stimulus '" + challengeDatum.getStimulus() + "', " +
					"stringSplitResults was null, expected value was " + challengeDatum.getExpectedResult().length + " length String array");
				
			if(results != null && challengeDatum.getExpectedResult() == null)
				fail("For stimulus '" + challengeDatum.getStimulus() + "', " +
						"result was " + results.length + " length String array, , expected value was null");
			if(stringSplitResults != null && challengeDatum.getExpectedResult() == null)
				fail("For stimulus '" + challengeDatum.getStimulus() + "', " +
						"result was " + stringSplitResults.length + " length String array, , expected value was null");
			
			// if we get here then neither the actual nor the expected result are null
			if(results.length != challengeDatum.getExpectedResult().length)
				fail("For stimulus '" + challengeDatum.getStimulus() + "', " +
						"result was " + results.length + 
						" length String array, expected value was " + challengeDatum.getExpectedResult().length + " length String array.");
			if(stringSplitResults.length != challengeDatum.getExpectedResult().length)
				fail("For stimulus '" + challengeDatum.getStimulus() + "', " +
						"result was " + stringSplitResults.length + 
						" length String array, expected value was " + challengeDatum.getExpectedResult().length + " length String array.");
			
			// if we get here then the actual nor the expected results are the same length
			for(int index=0; index < results.length; ++index)
			{
				assertEquals("For stimulus '" + challengeDatum.getStimulus() + "' using StringUtils.", 
						challengeDatum.getExpectedResult()[index], results[index]);
				assertEquals("For stimulus '" + challengeDatum.getStimulus() + "' using String.split.", 
						challengeDatum.getExpectedResult()[index], stringSplitResults[index]);
			}
		}
		
	}

}

class PointStimulusAndResults
{
	private String stimulus;
	private String[] expectedResult;
	
	public PointStimulusAndResults(String stimulus, String[] expectedResult)
    {
        super();
        this.stimulus = stimulus;
        this.expectedResult = expectedResult;
    }

	public String getStimulus()
    {
    	return stimulus;
    }

	public String[] getExpectedResult()
    {
    	return expectedResult;
    }
}
