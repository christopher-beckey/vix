/**
 * 
 */
package gov.va.med;

import gov.va.med.imaging.BhieImageURN;
import gov.va.med.imaging.BhieStudyURN;
import gov.va.med.imaging.ImageURN;
import gov.va.med.imaging.MuseImageURN;
import gov.va.med.imaging.MuseStudyURN;
import gov.va.med.imaging.P34ImageURN;
import gov.va.med.imaging.P34StudyURN;
import gov.va.med.imaging.StudyURN;
import gov.va.med.imaging.exceptions.URNFormatException;
import junit.framework.TestCase;

/**
 * @author vhaiswbeckec
 *
 */
public class URNTest
	extends TestCase
{

	@Override
	protected void setUp() throws Exception
	{
		super.setUp();
		//Configurator.setRootLevel(Level.ALL);
	}

	public void testURNRegularExpression()
	{
		assertTrue( URN.urnSchemaIdentifierPattern.matcher("urn").matches() );
		assertTrue( URN.urnSchemaIdentifierPattern.matcher("URN").matches() );
		assertTrue( URN.urnSchemaIdentifierPattern.matcher("uRn").matches() );
		assertTrue( URN.urnSchemaIdentifierPattern.matcher("Urn").matches() );
		assertFalse( URN.urnSchemaIdentifierPattern.matcher("run").matches() );
		assertFalse( URN.urnSchemaIdentifierPattern.matcher("1").matches() );
		assertFalse( URN.urnSchemaIdentifierPattern.matcher("").matches() );
	}
	
	public void testNamespaceRegularExpression()
	{
		assertTrue( URN.urnNamespaceIdentifierPattern.matcher("vaimage").matches() );
		assertTrue( URN.urnNamespaceIdentifierPattern.matcher("bhieimage").matches() );
		assertTrue( URN.urnNamespaceIdentifierPattern.matcher("vastudy").matches() );
		assertTrue( URN.urnNamespaceIdentifierPattern.matcher("bhiestudy").matches() );
		assertTrue( URN.urnNamespaceIdentifierPattern.matcher("123").matches() );
		assertTrue( URN.urnNamespaceIdentifierPattern.matcher("a").matches() );
		assertTrue( URN.urnNamespaceIdentifierPattern.matcher("a-a").matches() );
		assertTrue( URN.urnNamespaceIdentifierPattern.matcher("aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa").matches() );
		
		assertFalse( URN.urnNamespaceIdentifierPattern.matcher("^").matches() );
		assertFalse( URN.urnNamespaceIdentifierPattern.matcher("A^").matches() );
		assertFalse( URN.urnNamespaceIdentifierPattern.matcher("^A").matches() );
		assertFalse( URN.urnNamespaceIdentifierPattern.matcher("%2d").matches() );
		assertFalse( URN.urnNamespaceIdentifierPattern.matcher("-").matches() );
		// too big, 33 characters
		assertFalse( URN.urnNamespaceIdentifierPattern.matcher("aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa").matches() );
	}
	
	public void testNamespaceSpecificStringRegularExpression()
	{
		assertTrue( URN.namespaceSpecificStringPattern.matcher("a").matches() );
		assertTrue( URN.namespaceSpecificStringPattern.matcher("1-2-3-4-5").matches() );
		
		assertTrue( URN.namespaceSpecificStringPattern.matcher("1%3C2%3E3%3C4%3E5").matches() );
		assertTrue( URN.namespaceSpecificStringPattern.matcher("1<2>3<4>5").matches() );
		
		assertTrue( URN.namespaceSpecificStringPattern.matcher("1%5B2%5C3%5B4%5C5").matches() );
		assertFalse( URN.namespaceSpecificStringPattern.matcher("1[2]3[4]5").matches() );
	}
	
	public void testToStringSerialization() 
	throws URNFormatException
	{
		URN urn;
		String ts;
		URN cloneUrn;
		
		urn = new URN( new NamespaceIdentifier("nsi"), "nss");
		ts = urn.toString();
		System.out.println(ts);
		assertEquals("urn:nsi:nss", ts);
		
		urn = new URN( new NamespaceIdentifier("nsi"), "nss", "ai1", "ai2");
		ts = urn.toStringCDTP();
		System.out.println(ts);
		assertEquals("urn:nsi:nss[ai1][ai2]", ts);
		cloneUrn = URNFactory.create(ts);
		assertEquals(urn, cloneUrn);
		
		urn = new URN( new NamespaceIdentifier("nsi"), "nss-42");
		ts = urn.toString();
		System.out.println(ts);
		assertEquals("urn:nsi:nss-42", ts);

		urn = URNFactory.create("urn:nsi:nss?42");
		ts = urn.toString();
		System.out.println(ts);
		assertEquals("urn:nsi:nss%3f42", ts);
	}
	
	public void testToStringVariations() 
	throws URNFormatException
	{
		URN urn;
		String ts;
		String tsInternal;
		String tsNative;
		
		urn = URNFactory.create("urn:nsi:nss?42*19");
		ts = urn.toString();
		tsInternal = urn.toStringCDTP();
		tsNative = urn.toStringNative();
		System.out.println("RFC2141 = " + ts);
		System.out.println("Internal = " + tsInternal);
		System.out.println("Native = " + tsNative);
		assertEquals("urn:nsi:nss%3f42*19", ts);
		assertEquals("urn:nsi:nss%3f42%2a19", tsInternal);
		assertEquals("urn:nsi:nss?42*19", tsNative);

		urn = URNFactory.create("urn:nsi:nss?42*19[id1][id2]");
		ts = urn.toString();
		tsInternal = urn.toStringCDTP();
		tsNative = urn.toStringNative();
		System.out.println("RFC2121 = " + ts);
		System.out.println("Internal = " + tsInternal);
		System.out.println("Native = " + tsNative);
		assertEquals("urn:nsi:nss%3f42*19", ts);
		assertEquals("urn:nsi:nss%3f42%2a19[id1][id2]", tsInternal);
		assertEquals("urn:nsi:nss?42*19", tsNative);

		urn = URNFactory.create("urn:nsi:nss?42*19");
		ts = urn.toString();
		tsInternal = urn.toStringCDTP();
		tsNative = urn.toStringNative();
		System.out.println("RFC2121 = " + ts);
		System.out.println("Internal = " + tsInternal);
		System.out.println("Native = " + tsNative);
		assertEquals("urn:nsi:nss%3f42*19", ts);
		assertEquals("urn:nsi:nss%3f42%2a19", tsInternal);
		assertEquals("urn:nsi:nss?42*19", tsNative);

		urn = URNFactory.create("urn:nsi:nss?42*19[id1][id2]");
		ts = urn.toString();
		tsInternal = urn.toStringCDTP();
		tsNative = urn.toStringNative();
		System.out.println("RFC2121 = " + ts);
		System.out.println("Internal = " + tsInternal);
		System.out.println("Native = " + tsNative);
		assertEquals("urn:nsi:nss%3f42*19", ts);
		assertEquals("urn:nsi:nss%3f42%2a19[id1][id2]", tsInternal);
		assertEquals("urn:nsi:nss?42*19", tsNative);
	}
	
	/**
	 * Test method for {@link gov.va.med.URN#create(java.lang.String)}.
	 */
	public void testGenericTyping()
	{
		try
		{
			URN urn = URNFactory.create("urn:junk:0123456789");
			assertTrue( urn instanceof URN );
		}
		catch (URNFormatException x)
		{
			x.printStackTrace();
			fail(x.getMessage());
		}
		
		try
		{
			ImageURN urn = URNFactory.create("urn:vaimage:660-A-A-A-A");
			assertTrue( urn instanceof ImageURN );
		}
		catch (URNFormatException x)
		{
			x.printStackTrace();
			fail(x.getMessage());
		}
		
		try
		{
			ImageURN urn = URNFactory.create("urn:vaimage:660-ImageId-GroupId-PatientId");
			assertTrue( urn instanceof ImageURN );
		}
		catch (URNFormatException x)
		{
			x.printStackTrace();
			fail(x.getMessage());
		}
		try
		{
			ImageURN urn = URNFactory.create("urn:vaimage:660-ImageId-1011^6949598.9048^1^191-PatientId");
			assertTrue( urn instanceof ImageURN );
		}
		catch (URNFormatException x)
		{
			x.printStackTrace();
			fail(x.getMessage());
		}
		
		try
		{
			StudyURN urn = URNFactory.create("urn:vastudy:660-111DFEA-44456");
			assertTrue( urn instanceof StudyURN );
			assertNotNull(urn.getDocumentUniqueId());
			assertNotNull(urn.getGroupId());
		}
		catch (URNFormatException x)
		{
			x.printStackTrace();
			fail(x.getMessage());
		}

		try
		{
			P34StudyURN urn = URNFactory.create("urn:vap34study:660-56734-444565858V12334");
			assertTrue( urn instanceof P34StudyURN );
			assertNotNull(urn.getDocumentUniqueId());
			assertNotNull(urn.getGroupId());
			assertTrue(urn.isNewDataStructure());
		}
		catch (URNFormatException x)
		{
			x.printStackTrace();
			fail(x.getMessage());
		}
		
		try
		{
			P34ImageURN urn = URNFactory.create("urn:vap34image:660-554667-554665-9954483330V322-55697-55692");
			assertTrue( urn instanceof P34ImageURN );
			assertTrue(urn.isNewDataStructure());
			assertEquals("N554667", urn.getImagingIdentifier());
			
		}
		catch (URNFormatException x)
		{
			x.printStackTrace();
			fail(x.getMessage());
		}

		try
		{
			P34ImageURN urn = URNFactory.create("urn:vap34image:660-554667-554665-9954483330V322-554877-554123-CT");
			assertTrue( urn instanceof P34ImageURN );
			assertTrue(urn.isNewDataStructure());
			assertEquals("CT", urn.getImageModality());
			assertEquals("N554667", urn.getImagingIdentifier());
		}
		catch (URNFormatException x)
		{
			x.printStackTrace();
			fail(x.getMessage());
		}

		try
		{
			MuseStudyURN urn = URNFactory.create("urn:musestudy:660-56734-444565858V12334-3");
			assertTrue( urn instanceof MuseStudyURN);
			assertNotNull(urn.getGroupId());
			assertNotNull(urn.getMuseServerId());
		}
		catch (URNFormatException x)
		{
			x.printStackTrace();
			fail(x.getMessage());
		}
		
		try
		{
			MuseImageURN urn = URNFactory.create("urn:museimage:660-456-2-4266789V556-1");
			assertTrue( urn instanceof MuseImageURN );
		}
		catch (URNFormatException x)
		{
			x.printStackTrace();
			fail(x.getMessage());
		}


		try
		{
			StudyURN urn = URNFactory.create("urn:vastudy:660-1011^6949598.9048^1^191-44456");
			assertTrue( urn instanceof StudyURN );
			assertNotNull(urn.getDocumentUniqueId());
			assertNotNull(urn.getGroupId());
		}
		catch (URNFormatException x)
		{
			x.printStackTrace();
			fail(x.getMessage());
		}
		
		
		try
		{
			BhieStudyURN urn = URNFactory.create("urn:bhiestudy:rp02_0108_rg01-8a6b447b-2b2c-4f9d-a1a7-432bb468a53d");
			assertTrue( urn instanceof BhieStudyURN );
			assertNotNull(urn.getDocumentUniqueId());
			assertNotNull(urn.getGroupId());
		}
		catch (URNFormatException x)
		{
			x.printStackTrace();
			fail(x.getMessage());
		}
		
		try
		{
			URN urn = URNFactory.create("urn:unknown:655321-111DFEA-44456");
			assertTrue( urn instanceof URN );
		}
		catch (URNFormatException x)
		{
			x.printStackTrace();
			fail(x.getMessage());
		}
		
		try
		{
			URN urn = URNFactory.create("urn:bad$nid:655321-111DFEA-44456");
			fail("Invalid namespace identifier");
		}
		catch (URNFormatException x)
		{
		}
		try
		{
			URN urn = URNFactory.create("urn:-nid:655321-111DFEA-44456");
			fail("Invalid namespace identifier");
		}
		catch (URNFormatException x)
		{
		}
		
		try
		{
			ImageURN urn = URNFactory.create("urn:unknown:655321-111DFEA-44456");
			fail("Wrong type assignment");
		}
		catch (ClassCastException x){}
		catch (URNFormatException x)
		{
			x.printStackTrace();
			fail(x.getMessage());
		}
	}
	
	/**
	 * Test the version of the create() method that casts the created URN
	 * to the expected type.
	 */
	public void testTyping()
	{
		try
		{
			URN urn = URNFactory.create("urn:junk:0123456789", URN.class);
			assertTrue( urn instanceof URN );
		}
		catch (URNFormatException x)
		{
			x.printStackTrace();
			fail(x.getMessage());
		}
		
		try
		{
			ImageURN urn = URNFactory.create("urn:vaimage:A-A-A-A", ImageURN.class);
			assertTrue( urn instanceof ImageURN );
		}
		catch (URNFormatException x)
		{
			x.printStackTrace();
			fail(x.getMessage());
		}
		
		try
		{
			StudyURN urn = URNFactory.create("urn:vastudy:655321-111DFEA-44456", StudyURN.class);
			assertTrue( urn instanceof StudyURN );
		}
		catch (URNFormatException x)
		{
			x.printStackTrace();
			fail(x.getMessage());
		}

		try
		{
			P34StudyURN urn = URNFactory.create("urn:vap34study:660-45367-4445644493V39554", P34StudyURN.class);
			assertTrue( urn instanceof P34StudyURN );
		}
		catch (URNFormatException x)
		{
			x.printStackTrace();
			fail(x.getMessage());
		}

		try
		{
			P34ImageURN urn = URNFactory.create("urn:vap34image:660-45367-45366-4445644493V39554-45377-45392",
													P34ImageURN.class);
			assertTrue( urn instanceof P34ImageURN );
		}
		catch (URNFormatException x)
		{
			x.printStackTrace();
			fail(x.getMessage());
		}

		try
		{
			P34ImageURN urn = URNFactory.create("urn:vap34image:660-45367-45366-4445644493V39554-453767-453221-MR",
													P34ImageURN.class);
			assertTrue( urn instanceof P34ImageURN );
		}
		catch (URNFormatException x)
		{
			x.printStackTrace();
			fail(x.getMessage());
		}

		try
		{
			MuseStudyURN urn = URNFactory.create("urn:musestudy:660-45367-4445644493V39554-2", MuseStudyURN.class);
			assertTrue( urn instanceof MuseStudyURN );
		}
		catch (URNFormatException x)
		{
			x.printStackTrace();
			fail(x.getMessage());
		}
		try
		{
			MuseImageURN urn = URNFactory.create("urn:museimage:660-121-10-5667565441V11023-1", MuseImageURN.class);
			assertTrue( urn instanceof MuseImageURN );
		}
		catch (URNFormatException x)
		{
			x.printStackTrace();
			fail(x.getMessage());
		}


		try
		{
			BhieStudyURN urn = URNFactory.create("urn:bhiestudy:655321-111DFEA-44456", BhieStudyURN.class);
			assertTrue( urn instanceof BhieStudyURN );
		}
		catch (URNFormatException x)
		{
			x.printStackTrace();
			fail(x.getMessage());
		}
		
		try
		{
			BhieImageURN urn = URNFactory.create("urn:bhieimage:655321-111DFEA-44456", BhieImageURN.class);
			assertTrue( urn instanceof BhieImageURN );
		}
		catch (URNFormatException x)
		{
			x.printStackTrace();
			fail(x.getMessage());
		}
	}
	
	// 2D = '-'		// legal RFC2141 char
	// 5B = '['		// illegal RFC2141 char
	// 5C = '\'		// illegal RFC2141 char
	// 5D = ']'		// illegal RFC2141 char
	// 5E = '^'		// illegal RFC2141 char
	// 5F = '_'		// legal RFC2141 char
	
	public void testCharacterEscapingEquality()
	{
		String[] testStimuli = new String[]
		{
			"urn:vaimage:655653-76786-898",
			"urn:vaimage:655653^76786^898",
			"urn:bhiestudy:655321-111DFEA-44456",
			"urn:vaimage:A-A-A-A",
			"urn:bad$nid:655321-111DFEA-44456",
			"urn:-nid:655321-111DFEA-44456",
			"urn:bhiestudy:rp02_0108_rg01-8a6b447b-2b2c-4f9d-a1a7-432bb468a53d",
			"urn:vastudy:660-1011^6949598.9048^1^191-44456",
			"urn:vaimage:660-ImageId-GroupId-PatientId",
			"urn:bhieimage:rp02%5f0108%5frg01%2d8a6b447b%2d2b2c%2d4f9d%2da1a7%2d432bb468a53d",
			"urn:vap34study:500-355642-59595949494V33932",
			"urn:musestudy:660-45532-49493993V3423-1",
			"urn:vap34image:660-43354-43353-493838483V3231-43345-44568",
			"urn:vap34image:660-43354-43353-493838483V3231-43345-44568-CR",
			"urn:museimage:660-154-15-559284848V9554",
			
		};
		
		for(String testStimulus : testStimuli)
		{
			String escaped = URN.RFC2141_ESCAPING.escapeIllegalCharacters(testStimulus);
			String unescaped = URN.RFC2141_ESCAPING.unescapeIllegalCharacters(escaped);
			
			System.out.println(testStimulus + "=>" + escaped + "=>" + unescaped);
			assertEquals(testStimulus, unescaped);
		}
	}

	public void testCharacterEscaping()
	{
		String[][] testStimuli = new String[][]
		{
			new String[]{"655653-76786-898", "655653-76786-898"},	// all legal char, no change
			new String[]{"655653^76786^898", "655653%5e76786%5e898"},	// caret is illegal char, should be escaped
			new String[]{"655321[111DFEA]44456", "655321%5b111DFEA%5d44456"},	// square brackets are illegal char, should be escaped
			new String[]{"655321-111DFEA-44456", "655321-111DFEA-44456"},	// all legal char, no change
			new String[]{"655321_111DFEA_44456", "655321_111DFEA_44456"},	// all legal char, no change
			new String[]{"655321%5f111DFEA%5f44456", "655321%5f111DFEA%5f44456"},	// all legal char, no change
			new String[]{"rp02_0108_rg01-8a6b447b-2b2c-4f9d-a1a7-432bb468a53d", "rp02_0108_rg01-8a6b447b-2b2c-4f9d-a1a7-432bb468a53d"},
			new String[]{"rp02%5f0108%5frg01%2d8a6b447b%2d2b2c%2d4f9d%2da1a7%2d432bb468a53d", "rp02%5f0108%5frg01%2d8a6b447b%2d2b2c%2d4f9d%2da1a7%2d432bb468a53d"},
			new String[]{"660-1011^6949598.9048^1^191-44456", "660-1011%5e6949598.9048%5e1%5e191-44456"},
			new String[]{"660-1011%5e6949598.9048%5e1%5e191-44456", "660-1011%5e6949598.9048%5e1%5e191-44456"}
		};
		
		for(String[] testStimulus : testStimuli)
		{
			String expected = testStimulus[1];
			String escaped = URN.RFC2141_ESCAPING.escapeIllegalCharacters(testStimulus[0]);
			
			System.out.println(testStimulus[0] + "=>" + escaped + ", should be " + expected);
			assertEquals(expected, escaped);
		}
	}
	
	public void testVftpEscaping() 
	throws URNFormatException
	{
		String[] testStimuli = new String[]
  		{
			"urn:junk:0123456789",
			"urn:vaimage:660-A-A-A-A",
			"urn:vaimage:660-ImageId-GroupId-PatientId",
			"urn:vaimage:660-ImageId-1011^6949598.9048^1^191-PatientId",
			"urn:vastudy:660-111DFEA-44456",
			"urn:vastudy:660-1011^6949598.9048^1^191-44456",
			"urn:bhiestudy:rp02_0108_rg01-8a6b447b-2b2c-4f9d-a1a7-432bb468a53d",
			"urn:unknown:655321-111DFEA-44456"
  		};
  		String vftpForm = null;
  		
  		for(String testStimulus : testStimuli)
  		{
  			URN urn = URNFactory.create(testStimulus);
  			vftpForm = urn.toString(SERIALIZATION_FORMAT.VFTP);
  			URN urnClone = URNFactory.create(vftpForm, SERIALIZATION_FORMAT.VFTP);
  			String clone = urnClone.toString(SERIALIZATION_FORMAT.VFTP);
  			URN urnFinalClone = URNFactory.create(clone);
  			
  			assertEquals(urn, urnFinalClone);
  		}
	}
	
	/**
	 * Test the serialization of many URNs in all possible formats.
	 *  
	 * @throws URNFormatException
	 */
	public void testURNSerialization() 
	throws URNFormatException
	{
		URN[] testStimuli = new URN[]
		{
			ImageURNFactory.create("200", "123", "456", "ICN", "CT", ImageURN.class),
			StudyURNFactory.create("200", "123", "456", StudyURN.class),
			URNFactory.create("urn:vaimage:660-A-A-A-A"),
			URNFactory.create("urn:vaimage:660-ImageId-GroupId-PatientId"),
			URNFactory.create("urn:vaimage:660-ImageId-1011^6949598.9048^1^191-PatientId"),
			ImageURNFactory.create("660", "12334", "1011^6949598.9048^1^191", "1006170647V052871", null, ImageURN.class),
			URNFactory.create("urn:vastudy:660-111DFEA-44456"),
			URNFactory.create("urn:vastudy:660-1011^6949598.9048^1^191-44456"),
			URNFactory.create("urn:vastudy:A-A-A"),
			URNFactory.create("urn:vastudy:ABFFG-1-1234"),
			URNFactory.create("urn:vastudy:655321-111DFEA-44456"),
			URNFactory.create("urn:vastudy:000000000000000111111111111111999999999999999-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA-ZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZZ"),
			URNFactory.create("urn:vastudy:660-250-1006170647V052871"),
			URNFactory.create("urn:bhiestudy:rp02_0108_rg01-8a6b447b-2b2c-4f9d-a1a7-432bb468a53d"),
			URNFactory.create("urn:bhieimage:rp02_0108_rp01-b84c243d-68ab-42ae-a125-7029777ea227", SERIALIZATION_FORMAT.NATIVE),
			URNFactory.create("urn:gaid:2.16.840.1.113883.3.42.10012.100001.206-central-h01afb8984dcbe3413cbb9c7943efd9a96e0114", SERIALIZATION_FORMAT.RAW),
			URNFactory.create("urn:unknown:655321-111DFEA-44456"),
			URNFactory.create("urn:junk:0123456789"),
			URNFactory.create("urn:vap34study:660-34229-49494933V9054"),
			URNFactory.create("urn:musestudy:500-65632-546522345V5545-2"),
			URNFactory.create("urn:vap34image:660-12345-12344-6695944335V560-12366-12367"),
			URNFactory.create("urn:vap34image:660-12345-12344-6695944335V560-12366-12367-MG"),
			URNFactory.create("urn:museimage:660-35754-45-6695944335V560-2"),
		};
		
		for(SERIALIZATION_FORMAT serializationFormat : SERIALIZATION_FORMAT.values())
			for(URN testStimulus : testStimuli)
		  		serializeDeserializeAndCompare(serializationFormat, testStimulus);
	}

	public void testTroubleSpot() 
	throws URNFormatException
	{
		URN urn = ImageURNFactory.create("200", "123", "456", "ICN", "CT", ImageURN.class);
		//URNFactory.create("urn:gaid:2.16.840.1.113883.3.42.10012.100001.206-central-h01afb8984dcbe3413cbb9c7943efd9a96e0114");
		serializeDeserializeAndCompare( SERIALIZATION_FORMAT.RAW, urn );
		serializeDeserializeAndCompare( SERIALIZATION_FORMAT.VFTP, urn );
		serializeDeserializeAndCompare( SERIALIZATION_FORMAT.CDTP, urn );
		URN urn1 = ImageURNFactory.create("500", "123", "456", "ICN", "657", "659" ,"CT", P34ImageURN.class);
		//URNFactory.create("urn:gaid:2.16.840.1.113883.3.42.10012.100001.206-central-h01afb8984dcbe3413cbb9c7943efd9a96e0114");
		serializeDeserializeAndCompare( SERIALIZATION_FORMAT.RAW, urn1 );
		serializeDeserializeAndCompare( SERIALIZATION_FORMAT.VFTP, urn1 );
		serializeDeserializeAndCompare( SERIALIZATION_FORMAT.CDTP, urn1 );
		URN urn2 = ImageURNFactory.create("500", "123", "456", "ICN", "5", MuseImageURN.class);
		//URNFactory.create("urn:gaid:2.16.840.1.113883.3.42.10012.100001.206-central-h01afb8984dcbe3413cbb9c7943efd9a96e0114");
		serializeDeserializeAndCompare( SERIALIZATION_FORMAT.RAW, urn2 );
		serializeDeserializeAndCompare( SERIALIZATION_FORMAT.VFTP, urn2 );
		serializeDeserializeAndCompare( SERIALIZATION_FORMAT.CDTP, urn2 );

	}
	
	/**
	 * 
	 * @param serializationFormat
	 * @param testStimulus
	 */
	private void serializeDeserializeAndCompare(SERIALIZATION_FORMAT serializationFormat, URN testStimulus)
	{
		String serializedForm = testStimulus.toString(serializationFormat);
		System.out.println(serializedForm);
		assertTrue(
			"'null' found in '" + serializationFormat + "' format of '" + testStimulus.toString() + "' -> '" + serializedForm + "'.", 
			serializedForm.indexOf("null") < 0);
		
		try
		{
			URN imageUrnClone = URNFactory.create(serializedForm, serializationFormat);
			System.out.println(imageUrnClone.toString(serializationFormat));
			if(serializationFormat.isReflective())
				assertEquals(testStimulus.toString() + "[" + serializationFormat.toString() + "]", testStimulus, imageUrnClone);
		}
		catch (URNFormatException x)
		{
			x.printStackTrace();
		}
	}
	
	public void testImageUrn1() 
	throws URNFormatException
	{
		ImageURN imageUrn = 
			ImageURNFactory.create("660", 
				"12334", // this id is not in the exam
	            "1011^6949598.9048^1^191",
	            "1006170647V052871", 
	            null, ImageURN.class);
		System.out.println("ImageURN.toString() " + imageUrn.toString());
		System.out.println("Study ID " + imageUrn.getStudyId());
		
		String rawFormat = imageUrn.toString(SERIALIZATION_FORMAT.RAW);
		System.out.println("RAW " + rawFormat);
		URN untypedUrn = URNFactory.create( rawFormat, SERIALIZATION_FORMAT.RAW );
		
		assertTrue(untypedUrn instanceof ImageURN);
	}
	
	public void testAdditionalIdentifierBuilder() 
	throws URNFormatException
	{
		assertEquals( "[hello]", URN.buildAdditionalIdentifiersString(SERIALIZATION_FORMAT.RAW, "hello") );
		assertEquals( "[hello][world]", URN.buildAdditionalIdentifiersString(SERIALIZATION_FORMAT.RAW, "hello", "world") );
		assertEquals( "[hello][][world]", URN.buildAdditionalIdentifiersString(SERIALIZATION_FORMAT.RAW, "hello", null, "world") );
		assertEquals( "[hello][world]", URN.buildAdditionalIdentifiersString(SERIALIZATION_FORMAT.RAW, "hello", "world", null) );
		assertEquals( "[hello][][world]", URN.buildAdditionalIdentifiersString(SERIALIZATION_FORMAT.RAW, "hello", "", "world") );

		ImageURN imageUrn = BhieImageURN.create("200", "image", "study", "patient", "CT");//, ImageURN.class);
		assertEquals( "urn:vaimage:200-image-[patient][study][CT]", imageUrn.toString(SERIALIZATION_FORMAT.CDTP) );
		assertEquals( "urn:bhieimage:image[patient][study][CT]", imageUrn.toString(SERIALIZATION_FORMAT.RAW) );

		imageUrn = ImageURNFactory.create("200", "image", "study", "patient", "CT", ImageURN.class);
		System.out.println("CDTP: " + imageUrn.toString(SERIALIZATION_FORMAT.CDTP));
		System.out.println("RAW: " +imageUrn.toString(SERIALIZATION_FORMAT.RAW));
		assertEquals( "urn:vaimage:200-image-[patient][study][CT]", imageUrn.toString(SERIALIZATION_FORMAT.CDTP) );
		assertEquals( "urn:bhieimage:image[patient][study][CT]", imageUrn.toString(SERIALIZATION_FORMAT.RAW) );

		imageUrn = URNFactory.create("urn:bhieimage:rp02_0108_rp01-80740332-0906-426f-96d4-f709711782c0", ImageURN.class);
		imageUrn.setImageModality("CT");
		imageUrn.setPatientId("patient");
		imageUrn.setStudyId("study");
		assertEquals( "urn:vaimage:200-rp02_0108_rp01%2d80740332%2d0906%2d426f%2d96d4%2df709711782c0-[patient][study][CT]", imageUrn.toString(SERIALIZATION_FORMAT.CDTP) );
		assertEquals( "urn:bhieimage:rp02_0108_rp01-80740332-0906-426f-96d4-f709711782c0[patient][study][CT]", imageUrn.toString(SERIALIZATION_FORMAT.RAW) );

		StudyURN studyURN1 = StudyURNFactory.create("660", "59964", "449355932V9567", StudyURN.class);
		System.out.println("CDTP: " + studyURN1.toString(SERIALIZATION_FORMAT.CDTP));
		System.out.println("RAW: " +studyURN1.toString(SERIALIZATION_FORMAT.RAW));
		assertEquals( "urn:vastudy:660-59964-449355932V9567", studyURN1.toString(SERIALIZATION_FORMAT.CDTP) );
		assertEquals( "urn:vastudy:660-59964-449355932V9567", studyURN1.toString(SERIALIZATION_FORMAT.RAW) );

		P34StudyURN studyURN2 = StudyURNFactory.create("660", "59964", "449355932V9567", P34StudyURN.class);
		System.out.println("CDTP: " + studyURN2.toString(SERIALIZATION_FORMAT.CDTP));
		System.out.println("RAW: " +studyURN2.toString(SERIALIZATION_FORMAT.RAW));
		assertEquals( "urn:vap34study:660-59964-449355932V9567", studyURN2.toString(SERIALIZATION_FORMAT.CDTP) );
		assertEquals( "urn:vap34study:660-59964-449355932V9567", studyURN2.toString(SERIALIZATION_FORMAT.RAW) );

		MuseStudyURN studyURN3 = StudyURNFactory.create("500", "776576", "449355932V9567", "4", MuseStudyURN.class);
		System.out.println("CDTP: " + studyURN3.toString(SERIALIZATION_FORMAT.CDTP));
		System.out.println("RAW: " +studyURN3.toString(SERIALIZATION_FORMAT.RAW));
		assertEquals( "urn:musestudy:500-776576-449355932V9567-4", studyURN3.toString(SERIALIZATION_FORMAT.CDTP) );
		assertEquals( "urn:musestudy:500-776576-449355932V9567-4", studyURN3.toString(SERIALIZATION_FORMAT.RAW) );

		P34ImageURN imageURN3 = ImageURNFactory.create("660", "59964","59963", "449355932V9567", "59965", "59966", "US", 
															P34ImageURN.class);
		System.out.println("CDTP: " + imageURN3.toString(SERIALIZATION_FORMAT.CDTP));
		System.out.println("RAW: " +imageURN3.toString(SERIALIZATION_FORMAT.RAW));
		assertEquals( "urn:vap34image:660-59964-59963-449355932V9567-59965-59966-US", imageURN3.toString(SERIALIZATION_FORMAT.CDTP) );
		assertEquals( "urn:vap34image:660-59964-59963-449355932V9567-59965-59966-US", imageURN3.toString(SERIALIZATION_FORMAT.RAW) );

		MuseImageURN imageUrn1 = ImageURNFactory.create("660", "44567", "231", "778649112V593", "2", MuseImageURN.class);
		System.out.println("CDTP: " + imageUrn1.toString(SERIALIZATION_FORMAT.CDTP));
		System.out.println("RAW: " +imageUrn1.toString(SERIALIZATION_FORMAT.RAW));
		assertEquals( "urn:museimage:660-44567-231-778649112V593-2", imageUrn1.toString(SERIALIZATION_FORMAT.CDTP) );
		assertEquals( "urn:museimage:660-44567-231-778649112V593-2", imageUrn1.toString(SERIALIZATION_FORMAT.RAW) );

	}
}
