package gov.va.med.imaging.indexterm.rest.translator;

import java.util.ArrayList;
import java.util.List;

import org.junit.Test;

import gov.va.med.URNFactory;
import gov.va.med.imaging.exceptions.URNFormatException;
import gov.va.med.imaging.indexterm.IndexTermURN;
import gov.va.med.imaging.indexterm.IndexTermValue;
import gov.va.med.imaging.indexterm.rest.types.IndexTermValueType;
import gov.va.med.imaging.indexterm.rest.types.IndexTermValuesType;
import junit.framework.TestCase;

public class TestIndexTermRestTranslator
extends TestCase{
	
	@Test
	public void testIndexTermValue(){
		String urnAsString1 = "urn:indexterm:500-origin_index-I";
		String urnAsString2 = "urn:indexterm:500-origin_index-F";
		IndexTermURN urn1 = null;
		IndexTermURN urn2 = null;
		
		try {
			urn1 = URNFactory.create(urnAsString1, IndexTermURN.class);
			urn2 = URNFactory.create(urnAsString2, IndexTermURN.class);
		} catch (URNFormatException e) {
			fail("failed to create IndexTermURN.");
		}
		
		IndexTermValue value1 = new IndexTermValue(urn1, "AppName", "ABBR");
		value1.setSiteVixUrl("http://localhost:80/test");
		IndexTermValue value2 = new IndexTermValue(urn2, "Apple", "A");
		value2.setSiteVixUrl("http://localhost:80/test");
		List<IndexTermValue> values = new ArrayList<IndexTermValue>();
		values.add(value1);
		values.add(value2);
		
		IndexTermValuesType valuesType = IndexTermRestTranslator.translateIndexTerms(values);
		
		IndexTermValueType[] valueType = valuesType.getIndexTerm();
		
		IndexTermValueType valueType1 = valueType[0];
		assertEquals("ABBR", valueType1.getAbbreviation());
		assertEquals("AppName", valueType1.getName());
		assertEquals("urn:indexterm:500-origin_index-I", valueType1.getIndexTermUrn());
		assertEquals("http://localhost:80/test", valueType1.getSiteVixUrl());

		IndexTermValueType valueType2 = valueType[1];
		assertEquals("A", valueType2.getAbbreviation());
		assertEquals("Apple", valueType2.getName());
		assertEquals("urn:indexterm:500-origin_index-F", valueType2.getIndexTermUrn());
		assertEquals("http://localhost:80/test", valueType2.getSiteVixUrl());

	}
	

}
