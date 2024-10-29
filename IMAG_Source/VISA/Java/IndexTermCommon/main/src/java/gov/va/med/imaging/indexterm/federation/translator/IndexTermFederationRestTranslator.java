package gov.va.med.imaging.indexterm.federation.translator;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;

import gov.va.med.URNFactory;
import gov.va.med.imaging.exceptions.URNFormatException;
import gov.va.med.imaging.exchange.translation.AbstractTranslator;
import gov.va.med.imaging.indexterm.IndexTermURN;
import gov.va.med.imaging.indexterm.IndexTermValue;
import gov.va.med.imaging.indexterm.enums.IndexClass;
import gov.va.med.imaging.indexterm.enums.IndexTerm;
import gov.va.med.imaging.indexterm.federation.types.FederationIndexClassArrayType;
import gov.va.med.imaging.indexterm.federation.types.FederationIndexClassType;
import gov.va.med.imaging.indexterm.federation.types.FederationIndexTermType;
import gov.va.med.imaging.indexterm.federation.types.FederationIndexTermValueArrayType;
import gov.va.med.imaging.indexterm.federation.types.FederationIndexTermValueType;
import gov.va.med.imaging.rest.types.RestStringArrayType;
import gov.va.med.imaging.rest.types.RestStringType;

public class IndexTermFederationRestTranslator 
extends AbstractTranslator 
{
	
	private static Map<IndexTerm, FederationIndexTermType> IndexTermMap;
	private static Map<IndexClass, FederationIndexClassType> IndexClassMap;
	
	static{
		IndexTermMap = new HashMap<IndexTerm, FederationIndexTermType>();
		IndexTermMap.put(IndexTerm.type_index, FederationIndexTermType.type_index);
		IndexTermMap.put(IndexTerm.origin_index, FederationIndexTermType.origin_index);
		IndexTermMap.put(IndexTerm.event_index, FederationIndexTermType.event_index);
		IndexTermMap.put(IndexTerm.specialty_index, FederationIndexTermType.specialty_index);
		
		IndexClassMap = new HashMap<IndexClass, FederationIndexClassType>();
		IndexClassMap.put(IndexClass.admin, FederationIndexClassType.admin);
		IndexClassMap.put(IndexClass.adminClin, FederationIndexClassType.adminClin);
		IndexClassMap.put(IndexClass.clin, FederationIndexClassType.clin);
		IndexClassMap.put(IndexClass.clinAdmin, FederationIndexClassType.clinAdmin);

	}

	private static FederationIndexTermValueType translate(IndexTermValue value){
		
		FederationIndexTermValueType type = new FederationIndexTermValueType();
		type.setAbbreviation(value.getAbbreviation());
		type.setIndexTermUrn(new RestStringType(translateString(value.getIndexTermUrn())));
		type.setName(value.getName());
	
		return type;
	}

	private static FederationIndexClassType translateIndexClassType(IndexClass value){
		
		for( Entry<IndexClass, FederationIndexClassType> entry : IndexClassMap.entrySet() )
			if( entry.getKey() == value )
				return entry.getValue();
		
		return FederationIndexClassType.clin;
	}

	private static String translateString(IndexTermURN value){
		if(value == null){
			return null;
		}
		else{
			return value.toString();
		}
	}
	
	private static IndexTermURN translateIndexTermURN(String value) throws URNFormatException{
		
		return URNFactory.create(value, IndexTermURN.class);
	}


	public static FederationIndexTermValueArrayType translateIndexTermValuesType(List<IndexTermValue> items) 
	{
		FederationIndexTermValueArrayType resultsArray = new FederationIndexTermValueArrayType();
		if(items == null || items.isEmpty())
			return resultsArray;
		
		FederationIndexTermValueType[] result = new FederationIndexTermValueType[items.size()];
		int i = 0;
		for(IndexTermValue item : items)
		{
			result[i] = translate(item);
			i++;
		}
		resultsArray.setValues(result);
		return resultsArray;
	}

	public static FederationIndexClassArrayType translateIndexClassesType(List<IndexClass> items) 
	{
		FederationIndexClassType[] results;
		if(items == null || items.isEmpty()){
			results= new FederationIndexClassType[0];
			return new FederationIndexClassArrayType(results);
		}
		results = new FederationIndexClassType[items.size()];
		int i = 0;
		for(IndexClass item : items)
		{
			results[i] = translateIndexClassType(item);
			i++;
		}
		return new FederationIndexClassArrayType(results);
	}

	public static RestStringArrayType translateStringArrayType(List<IndexTermURN> items) 
	{
		RestStringArrayType resultArray = new RestStringArrayType();
		if(items == null || items.isEmpty())
			return resultArray;
		
		String[] result = new String[items.size()];
		int i = 0;
		for(IndexTermURN item : items)
		{
			result[i] = translateString(item);
			i++;
		}
		resultArray.setValue(result);
		return resultArray;
	}

	public static FederationIndexTermType[] translateIndexTermsType(List<IndexTerm> items) 
	{
		FederationIndexTermType[] results;
		if(items == null || items.isEmpty()){
			results = new FederationIndexTermType[0];
			return results;
		}
		results = new FederationIndexTermType[items.size()];
		int i = 0;
		for(IndexTerm item : items)
		{
			results[i] = translateIndexTermType(item);
			i++;
		}
		return results;
	}
	
	
	public static FederationIndexTermType translateIndexTermType(IndexTerm term)
		{
			for( Entry<IndexTerm, FederationIndexTermType> entry : IndexTermMap.entrySet() )
				if( entry.getKey() == term )
					return entry.getValue();
			
			return FederationIndexTermType.type_index;
		}
		
		
		public static IndexTerm translateIndexTerm(FederationIndexTermType termType)
		{
			for( Entry<IndexTerm, FederationIndexTermType> entry : IndexTermMap.entrySet() )
				if( entry.getValue() == termType )
					return entry.getKey();
			
			return IndexTerm.type_index;
		}
		
		private static IndexTermValue translateIndexTermValue(FederationIndexTermValueType value) throws URNFormatException{
			
			IndexTermURN urn = URNFactory.create(value.getIndexTermUrn().getValue(), IndexTermURN.class);
			IndexTermValue type = new IndexTermValue(urn, value.getName(), value.getAbbreviation());
		
			return type;
		}
		
		public static List<IndexTermURN> translateIndexTermURNs(RestStringArrayType values){
			
			List<IndexTermURN> results = new ArrayList<IndexTermURN>();
			if(values == null || values.getValue() == null || values.getValue().length < 1)
				return results;
			
			String[] items = values.getValue();

			for(String item : items)
			{
				IndexTermURN result;
				try {
					result = translateIndexTermURN(item);
					results.add(result);
				} catch (URNFormatException e) {
                    getLogger().error("URN Format Exception. Failed to translate and add IndexTerm String [{}] to list.", item);
				}
			}
			return results;

		}
		
		public static IndexClass translateIndexClass(FederationIndexClassType classType)
		{
			for( Entry<IndexClass, FederationIndexClassType> entry : IndexClassMap.entrySet() )
				if( entry.getValue() == classType )
					return entry.getKey();
			
			return IndexClass.clin;
		}



		public static List<IndexTermValue> translateIndexTermValues(FederationIndexTermValueType[] items) {

			List<IndexTermValue> results = new ArrayList<IndexTermValue>();
			if(items == null || items.length < 1)
				return results;
			
			
			for(FederationIndexTermValueType item : items)
			{
				IndexTermValue result;
				try {
					result = translateIndexTermValue(item);
					results.add(result);
				} catch (URNFormatException e) {
                    getLogger().error("URN Format Exception. Failed to translate and add IndexTermValue String [{}] to list.", item.getIndexTermUrn().getValue());
				}
			}
			return results;
		}

		public static List<IndexClass> translateIndexTermClasses(FederationIndexClassArrayType values) {

			List<IndexClass> results = new ArrayList<IndexClass>();
			if(values == null || values.getValues() == null || values.getValues().length < 1)
				return results;
			
			FederationIndexClassType[] items = values.getValues();
			
			for(FederationIndexClassType item : items)
			{
				IndexClass result;
				result = translateIndexClass(item);
				results.add(result);
			}
			return results;
		}

		
		public static List<IndexTermValue> translateIndexTermValues(FederationIndexTermValueArrayType arrayType){
			return translateIndexTermValues(arrayType.getValues());
		}

}
