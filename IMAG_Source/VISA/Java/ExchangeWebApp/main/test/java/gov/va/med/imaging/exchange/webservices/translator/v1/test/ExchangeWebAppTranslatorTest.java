/**
 * 
  Package: MAG - VistA Imaging
  WARNING: Per VHA Directive 2004-038, this routine should not be modified.
  Date Created: Mar 18, 2008
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
package gov.va.med.imaging.exchange.webservices.translator.v1.test;

import java.text.ParseException;
import java.util.LinkedList;
import java.util.List;
import java.util.Set;

import gov.va.med.imaging.exceptions.URNFormatException;
import gov.va.med.imaging.exchange.business.Image;
import gov.va.med.imaging.exchange.business.Series;
import gov.va.med.imaging.exchange.business.Study;
import gov.va.med.imaging.exchange.webservices.soap.types.v1.InstanceType;
import gov.va.med.imaging.exchange.webservices.soap.types.v1.SeriesType;
import gov.va.med.imaging.exchange.webservices.soap.types.v1.StudyType;
import gov.va.med.imaging.exchange.webservices.translator.v1.ExchangeTranslator;
import gov.va.med.imaging.translator.test.TranslatorTestBusinessObjectBuilder;

/**
 * @author VHAISWWERFEJ
 *
 */
public class ExchangeWebAppTranslatorTest 
extends ExchangeWebAppTestBase 
{
	private final static int STUDY_COUNT = 10;
	
	private final static ExchangeTranslator translator = new ExchangeTranslator();
	
	public ExchangeWebAppTranslatorTest()
	{
		super(ExchangeWebAppTranslatorTest.class.toString());
	}
	
	public void testTransformStudy() 
	throws URNFormatException
	{
		int studyCount = STUDY_COUNT;
		System.out.println("Comparing [" + studyCount + "] studies");
		for(int i = 0; i < studyCount; i++)			
		{
			Study study = TranslatorTestBusinessObjectBuilder.createStudy(site);
			StudyType studyType = null;
			try
			{
				studyType = translator.transformStudy(study);
			}
			catch(ParseException pX)
			{
				pX.printStackTrace();
				fail(pX.getMessage());
			}
			catch(URNFormatException iurnfX)
			{
				iurnfX.printStackTrace();
				fail(iurnfX.getMessage());
			}
			compareStudy(study, studyType);
		}		
	}
	
	private void compareStudy(Study study, StudyType studyType)
	{
		assertNotNull(study);
		assertNotNull(studyType);
		assertEquals(study.getDescription(), studyType.getDescription());
		assertEquals(study.getStudyUid(), studyType.getDicomUid());
		assertNotNull(study.getModalities());
		assertNotNull(studyType.getModalities());
		compareModalities(study.getModalities(), studyType.getModalities().getModality());
		//TODO: compare modalities
		//assertEquals(, studyType.getModalities());
		assertEquals(study.getPatientId(), studyType.getPatientId());
		assertEquals(study.getPatientName() ,studyType.getPatientName());
		try{
			assertEquals(translator.translateProcedureDateToDicom(study.getProcedureDate()) , studyType.getProcedureDate());
		}
		catch(ParseException pX)
		{
			pX.printStackTrace();
			fail(pX.getMessage());
		}
		assertEquals(study.getProcedure(), studyType.getProcedureDescription());
		assertEquals(study.getRadiologyReport(), studyType.getRadiologyReport());
		assertEquals(study.getSiteAbbr(), studyType.getSiteAbbreviation());
		assertEquals(study.getSiteName() , studyType.getSiteName());
		assertEquals(study.getSiteNumber(), studyType.getSiteNumber());
		assertEquals(study.getSpecialty(), studyType.getSpecialtyDescription());
		
		assertEquals(study.getStudyUrn().toString(), studyType.getStudyId());
		
		assertEquals(study.getSeriesCount(), studyType.getSeriesCount());
		assertEquals(study.getImageCount(), studyType.getImageCount());
		for(Series series : study.getSeries())
		{
			SeriesType seriesType = findSeries(series.getSeriesIen(), studyType);
			compareSeries(series, study, seriesType);
		}		
	}
	
	private void compareModalities(Set<String> modalities, String[] studyTypeModalities)
	{
		assertEquals(modalities.size(), studyTypeModalities.length);
		
		List<String> mod = new LinkedList<String>();
		for(int i = 0; i < studyTypeModalities.length; i++)
		{
			mod.add(studyTypeModalities[i]);
		}
		for(String modality : modalities)
		{
			boolean found = false;
			int i = 0;
			while((!found) && (i < mod.size()))
			{
				if(modality.equals(mod.get(i)))
				{
					found = true;
				}
				i++;
			}
			assertTrue("Modality [" + modality + "] was not found in StudyType", found);
		}
	}
	
	private SeriesType findSeries(String seriesIen, StudyType studyType)
	{		
		SeriesType serieses[] = studyType.getComponentSeries().getSeries();
		for(int i = 0; i < serieses.length; i++)
		{
			if(serieses[i].getSeriesId().equals(seriesIen))
			{
				return serieses[i];
			}
		}
		return null;
	}
	
	private void compareSeries(Series series, Study study, SeriesType seriesType)
	{
		assertNotNull(series);
		assertNotNull(seriesType);
		
		assertEquals(study.getDescription(), seriesType.getDescription());
		assertEquals(series.getSeriesNumber(), seriesType.getDicomSeriesNumber().toString());
		assertEquals(series.getSeriesUid(), seriesType.getDicomUid());
		assertEquals(series.getImageCount(), seriesType.getImageCount());
		assertEquals(series.getModality(), seriesType.getModality());
		assertEquals(series.getSeriesIen() , seriesType.getSeriesId());
		for(Image image : series)
		{			
			InstanceType instance = findInstance(image.getImageUrn().toString(), seriesType);
			compareImages(image, instance);			
		}
	}
	
	private void compareImages(Image image, InstanceType instanceType)
	{
		assertNotNull(image);
		assertNotNull(instanceType);
		
		assertEquals(image.getImageNumber(), instanceType.getDicomInstanceNumber().toString());
		assertEquals(image.getImageUid(), instanceType.getDicomUid());
		assertEquals(image.getImageUrn().toString(), instanceType.getImageUrn());
	}
	
	private InstanceType findInstance(String imageUrn, SeriesType seriesType)
	{
		InstanceType[] instances = seriesType.getComponentInstances().getInstance();
		for(int i = 0; i < instances.length; i++)
		{
			if(instances[i].getImageUrn().equals(imageUrn))
			{
				return instances[i];
			}
		}
		return null;
	}
}
