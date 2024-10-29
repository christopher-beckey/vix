/**
 * 
 */
package gov.va.med.imaging.terminology;

import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.LineNumberReader;
import java.net.URI;
import java.util.Iterator;
import junit.framework.TestCase;

/**
 * @author vhaiswbeckec
 *
 */
public abstract class AbstractTranslationTest
extends TestCase
{
	private SchemeTranslationServiceFactory factory;
	private SchemeTranslationSPI translator;
	
	/**
	 * Return the name of the coding scheme that the source test data is in.
	 * 
	 * @return
	 */
	protected abstract CodingScheme getSourceScheme();
	
	/**
	 * Return the name of the coding scheme that the destination test data is in.
	 * 
	 * @return
	 */
	protected abstract CodingScheme getDestinationScheme();
	
	/**
	 * Return an InputStream containing a text file formatted as lines in the
	 * form: value=value
	 * 
	 * @return
	 */
	protected abstract InputStream getTestData();
	
	@Override
	protected void setUp() 
	throws Exception
	{
		super.setUp();
		factory = SchemeTranslationServiceFactory.getFactory();
		translator =
			factory.getSchemeTranslator(getSourceScheme(), getDestinationScheme());
		assertNotNull(translator);
	}

	public void testTranslationValues()
	{
		InputStream inStream = getTestData();
		assertNotNull(inStream);
		TestDataSet testDataSet = new TestDataSet(inStream);
		
		for(TestDataPoint testDataPoint : testDataSet)
		{
			String[] expectedValues = testDataPoint.getDestinationValue().split(",");
			ClassifiedValue[] actualValues = translator.translate(testDataPoint.getSourceValue());
			
			assertEquals(
				"For source value '" + testDataPoint.getSourceValue() + "', size of results differ.", 
				expectedValues.length, 
				actualValues.length 
			);

			int index=0;
			for(String expectedValue : expectedValues)
				assertEquals(
					"For source value '" + testDataPoint.getSourceValue() + "'.", 
					expectedValue, 
					actualValues[index++].getCodeValue() 
				);
		}
	}
	
	class TestDataPoint
	{
		private final String sourceValue;
		private final String destinationValue;
		/**
		 * @param sourceValue
		 * @param destinationValue
		 */
		public TestDataPoint(String sourceValue, String destinationValue)
		{
			super();
			this.sourceValue = sourceValue;
			this.destinationValue = destinationValue;
		}
		public String getSourceValue()
		{
			return this.sourceValue;
		}
		public String getDestinationValue()
		{
			return this.destinationValue;
		}
	}
	
	/**
	 * 
	 */
	class TestDataSet
	implements Iterable<TestDataPoint>
	{
		final LineNumberReader reader;
		TestDataPoint nextElement = null;
		
		/**
		 * 
		 * @param inStream
		 * @param isReversedTestData
		 */
		TestDataSet(InputStream inStream) 
		{
			reader = new LineNumberReader(new InputStreamReader(inStream));
			readNextElement();
		}
		
		private void readNextElement() 
		{
			String line;
			try
			{
				line = reader.readLine();
				if(line == null)
					nextElement = null;
				else
				{
					String[] values = line.split("=");
					nextElement = new TestDataPoint(values[0], values[1]);
				}
			}
			catch (IOException x)
			{
				x.printStackTrace();
			}
		}

		@Override
		public Iterator<TestDataPoint> iterator()
		{
			return new Iterator<TestDataPoint>()
			{
				@Override
				public boolean hasNext()
				{
					return nextElement != null;
				}

				@Override
				public TestDataPoint next()
				{
					TestDataPoint tdp = nextElement;
					readNextElement();
					return tdp;
				}

				@Override
				public void remove(){}
			};
		}
	}
	
}
