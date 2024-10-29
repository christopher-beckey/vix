package gov.va.med.cache.gui.server;

import static org.junit.Assert.*;

import org.junit.Test;

public class CacheSemanticsTest {

	@Test
	public void testGetGroupSemanticType() 
	{
		assertEquals( "group2", CacheSemantics.getGroupSemanticType("junk", "junk", 1) );
		assertEquals( "group1", CacheSemantics.getGroupSemanticType("junk", "junk", 0) );
		assertEquals( null, CacheSemantics.getGroupSemanticType("junk", "junk", 12) );
		
		//assertEquals( "homeCommunity", CacheSemantics.getGroupSemanticType("ImagingExchangeCache", "va-image-region", 0) );
		//assertEquals( "repository", CacheSemantics.getGroupSemanticType("ImagingExchangeCache", "va-image-region", 1) );
		
		//assertEquals( "homeCommunity", CacheSemantics.getGroupSemanticType("ImagingExchangeCache", "va-metadata-region", 0) );
		//assertEquals( "repository", CacheSemantics.getGroupSemanticType("ImagingExchangeCache", "va-metadata-region", 1) );
		//assertEquals( "patient", CacheSemantics.getGroupSemanticType("ImagingExchangeCache", "va-metadata-region", 2) );
		//assertEquals( "study", CacheSemantics.getGroupSemanticType("ImagingExchangeCache", "va-metadata-region", 3) );
	}

	@Test
	public void testGetInstanceSemanticType() 
	{
		assertEquals( "instance", CacheSemantics.getInstanceSemanticType("junk", "junk") );
		
		assertEquals( "study", CacheSemantics.getInstanceSemanticType("ImagingExchangeCache", "va-metadata-region") );
		assertEquals( "image", CacheSemantics.getInstanceSemanticType("ImagingExchangeCache", "va-image-region") );
	}

}
