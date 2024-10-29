/**
 * 
  Package: MAG - VistA Imaging
  WARNING: Per VHA Directive 2004-038, this routine should not be modified.
  Date Created: Jan 11, 2008
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
package gov.va.med.imaging.url.mix.test;

import java.util.ArrayList;
import java.util.List;

import org.apache.logging.log4j.Level;
import gov.va.med.logging.Logger;
import org.apache.logging.log4j.core.config.Configurator;

import gov.va.med.URNFactory;
import gov.va.med.imaging.StudyURN;
import gov.va.med.imaging.exceptions.URNFormatException;
import gov.va.med.imaging.exchange.business.Image;
import gov.va.med.imaging.exchange.business.Series;
import gov.va.med.imaging.exchange.business.SiteImpl;
import gov.va.med.imaging.exchange.business.Study;
import gov.va.med.imaging.exchange.enums.ObjectOrigin;
import gov.va.med.imaging.exchange.business.Site;
import gov.va.med.imaging.mix.translator.MixTranslator;
import gov.va.med.imaging.mix.webservices.rest.types.v1.ModalitiesType;

/**
 * @author VHAISWWERFEJ
 *
 */
public class MixTranslatorTest 
extends AbstractMixTest 
{
	private MixTranslator mixTranslator = new MixTranslator();
	private List<String> emptyStudyModalities = new ArrayList<String>();
	
	private Site site = null;

	public MixTranslatorTest()
	{
		super(MixTranslatorTest.class.toString());
	}
	
	@Override
	protected void setUp() 
	throws Exception 
	{
		super.setUp();
		Configurator.setRootLevel(Level.ALL);
		site = new SiteImpl("200", "DOD", "DOD", "", 0, "", 0, "");
	}

	public void testTransformImage()
	{
		gov.va.med.imaging.mix.webservices.rest.types.v1.InstanceType instance = createInstanceType();
		gov.va.med.imaging.mix.webservices.rest.types.v1.SeriesType seriesType = createSeriesType();
		gov.va.med.imaging.mix.webservices.rest.types.v1.StudyType studyType = createStudyType();
		Study study = mixTranslator.transformStudy(site, studyType, emptyStudyModalities);
		Series series = mixTranslator.transformSeries(site, study, seriesType);
		
		Image image = mixTranslator.transformImage(site, study, series, instance);
		assertNotNull(image);
		compareImage(instance, seriesType, studyType, image);
	}
	
	public void testTransformNullImage()
	{
		gov.va.med.imaging.mix.webservices.rest.types.v1.InstanceType instance = createInstanceType(true);
		gov.va.med.imaging.mix.webservices.rest.types.v1.SeriesType seriesType = createSeriesType(true);
		gov.va.med.imaging.mix.webservices.rest.types.v1.StudyType studyType = createStudyType(true);
		Study study = mixTranslator.transformStudy(site, studyType, emptyStudyModalities);
		Series series = mixTranslator.transformSeries(site, study, seriesType);
		
		
		Image image = mixTranslator.transformImage(site, study, series, instance);
		assertNotNull(image);
		compareImage(instance, seriesType, studyType, image);
	}
	
	public void testTransformSeries()
	{
		gov.va.med.imaging.mix.webservices.rest.types.v1.SeriesType seriesType = createSeriesType();
		gov.va.med.imaging.mix.webservices.rest.types.v1.StudyType studyType = createStudyType();
		Study study = mixTranslator.transformStudy(site, studyType, emptyStudyModalities);
		Series series = mixTranslator.transformSeries(site, study, seriesType);	
		assertNotNull(series);
		compareSeries(seriesType, studyType, series);
	}
	
	public void testTransformNullSeries()
	{
		gov.va.med.imaging.mix.webservices.rest.types.v1.SeriesType seriesType = createSeriesType(true);
		gov.va.med.imaging.mix.webservices.rest.types.v1.StudyType studyType = createStudyType(true);
		Study study = mixTranslator.transformStudy(site, studyType, emptyStudyModalities);
		Series series = mixTranslator.transformSeries(site, study, seriesType);	
		assertNotNull(series);
		compareSeries(seriesType, studyType, series);
	}
	
	public void testTransformStudy()
	{
		gov.va.med.imaging.mix.webservices.rest.types.v1.StudyType studyType = createStudyType();		
		Study study = mixTranslator.transformStudy(site, studyType, emptyStudyModalities);
		assertNotNull(study);
		compareStudy(studyType, study);
	}
	
	public void testTransformNullStudy()
	{
		gov.va.med.imaging.mix.webservices.rest.types.v1.StudyType studyType = createStudyType(true);
		Study study = mixTranslator.transformStudy(site, studyType, emptyStudyModalities);
		assertNotNull(study);
		compareStudy(studyType, study);
	}
	
	private void compareStudy(gov.va.med.imaging.mix.webservices.rest.types.v1.StudyType studyType,
		Study study)
	{
		// CTB 29Nov2009
		//String decodedStudyId = Base32ConversionUtility.base32Decode(study.getStudyIen());
		String decodedStudyId = study.getGlobalArtifactIdentifier().toString();
		//assertEquals(studyType.getStudyId(), decodedStudyId);
		if(studyType.getDescription() == null)
			assertEquals("", study.getDescription());
		else
			assertEquals(studyType.getDescription(), study.getDescription());
		assertEquals(studyType.getDicomUid(), study.getStudyUid());
		assertEquals(studyType.getImageCount(), study.getImageCount());
		assertEquals(studyType.getPatientId(), study.getPatientId());
		if(studyType.getProcedureDescription() == null)
			assertEquals("", study.getProcedure());
		else
			assertEquals(studyType.getProcedureDescription(), study.getProcedure());
		assertEquals(site.getSiteAbbr(), study.getSiteAbbr());
		if(studyType.getSiteName() == null)
			assertEquals("", study.getSiteName());
		else
			assertEquals(studyType.getSiteName(), study.getSiteName());
		if(studyType.getSpecialtyDescription() == null)
			assertEquals("", study.getSpecialty());
		else
			assertEquals(studyType.getSpecialtyDescription(), study.getSpecialty());
		String studyReport = study.getRadiologyReport();
		int loc = studyReport.indexOf("\n");
		if(loc >= 0)
		{
			studyReport = studyReport.substring(loc + 1);
		}
//		if(studyType.getRadiologyReport() == null)
//			assertEquals("", studyReport);
//		else
//			assertEquals(studyType.getRadiologyReport(), studyReport);
		
		String[] modalities = study.getModalities().toArray(new String[study.getModalities().size()]);
		for(int i = 0; i < modalities.length; i++)
		{
			assertEquals(studyType.getModalities().getModality(i), modalities[i]);
		}
		Series[] series = study.getSeries().toArray(new Series[study.getSeries().size()]);
		for(int i = 0; i < series.length; i++)
		{
			compareSeries(studyType.getComponentSeries().getSeries(i), studyType, series[i]);
		}
	}
	
	private void compareSeries(gov.va.med.imaging.mix.webservices.rest.types.v1.SeriesType seriesType,
			gov.va.med.imaging.mix.webservices.rest.types.v1.StudyType studyType,
			Series series)
	{
		assertEquals(seriesType.getSeriesId(), series.getSeriesIen());
		assertEquals(seriesType.getDicomSeriesNumber() == null ? "" : "" + seriesType.getDicomSeriesNumber().toString(), series.getSeriesNumber());
		if(seriesType.getDicomUid() == null)
			assertEquals("", series.getSeriesUid());
		else
			assertEquals(seriesType.getDicomUid(), series.getSeriesUid());
		assertEquals(seriesType.getModality(), series.getModality());
		assertEquals(ObjectOrigin.DOD, series.getObjectOrigin());
		int expectedIndex = 0;
		for(Image image : series)
		{
			compareImage(
				seriesType.getComponentInstances().getInstance(expectedIndex),
				seriesType, studyType, image);
			expectedIndex++;
		}
	}
	
	private void compareImage(gov.va.med.imaging.mix.webservices.rest.types.v1.InstanceType instance,
			gov.va.med.imaging.mix.webservices.rest.types.v1.SeriesType series,
			gov.va.med.imaging.mix.webservices.rest.types.v1.StudyType study,
			Image image)
	{
		assertNotNull(instance);
		assertNotNull(image);
		assertEquals(instance.getDicomInstanceNumber() + "", image.getImageNumber());
		
//		String decodedImageUrn = Base32ConversionUtility.base32Decode(image.getIen());
//		assertEquals(instance.getImageUrn(), decodedImageUrn);
//		if(instance.getDicomUid() == null)
//			assertEquals("", image.getImageUid());
//		else
//			assertEquals(instance.getDicomUid(), image.getImageUid());
		
		assertEquals((instance.getDicomInstanceNumber() == null ? "" :  "" + instance.getDicomInstanceNumber().toString()), image.getDicomImageNumberForDisplay());
		if(series.getModality() == null)
			assertEquals("", image.getImageModality());
		else
			assertEquals(series.getModality(), image.getImageModality());
		assertEquals(series.getDicomSeriesNumber() == null ? "" : "" + series.getDicomSeriesNumber().toString(), image.getDicomSequenceNumberForDisplay());
		if(study.getDescription() == null)
			assertEquals("", image.getDescription());
		else
			assertEquals(study.getDescription(), image.getDescription());
		assertEquals(study.getPatientId(), image.getPatientId());
		if(study.getPatientName() == null)
			assertEquals("", image.getPatientName());
		else
			assertEquals(study.getPatientName(), image.getPatientName());
		if(study.getProcedureDate() == null)
			assertEquals("", image.getProcedureDate());
		else
			assertEquals(mixTranslator.convertDICOMDateToDate(study.getProcedureDate()), image.getProcedureDate());
		if(study.getProcedureDescription() == null)
			assertEquals("", image.getProcedure());
		else
			assertEquals(study.getProcedureDescription(), image.getProcedure());
		assertEquals(site.getSiteAbbr(), image.getSiteAbbr());
		assertEquals(site.getSiteNumber(), image.getSiteNumber());
		// CTB 29Nov2009
		//String decodedStudyId = Base32ConversionUtility.base32Decode(image.getStudyIen());
		String decodedStudyId = image.getStudyIen();
		try
		{
			StudyURN studyUrn = URNFactory.create(study.getStudyId(), StudyURN.class);
			assertEquals(studyUrn.getStudyId(), decodedStudyId);
		}
		catch (URNFormatException x)
		{
			x.printStackTrace();
			fail();
		}
	}
	
	private gov.va.med.imaging.mix.webservices.rest.types.v1.StudyType createStudyType(boolean nullValues)
	{
		if(nullValues)
		{
			gov.va.med.imaging.mix.webservices.rest.types.v1.StudyType study = 
				new gov.va.med.imaging.mix.webservices.rest.types.v1.StudyType();
			study.setStudyId("urn:bhiestudy:753.42.86");
			study.setDescription(null);
			study.setDicomUid(null);
			study.setProcedureDate("200701012123");
			study.setProcedureDescription(null);
			study.setPatientId("9516284");
			study.setPatientName("TESTPATIENT,NAME");
			study.setSiteName(null);
			study.setSiteNumber(null);
			study.setSiteAbbreviation(null);
			study.setSpecialtyDescription(null);
//			study.setRadiologyReport(null);
			study.setModalities(new ModalitiesType(new String []{"CR"}));
			
			gov.va.med.imaging.mix.webservices.rest.types.v1.SeriesType [] seriesArray =
				new gov.va.med.imaging.mix.webservices.rest.types.v1.SeriesType[1];
			seriesArray[0] = createSeriesType(nullValues); 
			gov.va.med.imaging.mix.webservices.rest.types.v1.StudyTypeComponentSeries componentSeries = 
				new gov.va.med.imaging.mix.webservices.rest.types.v1.StudyTypeComponentSeries();
			componentSeries.setSeries(seriesArray);
			
			study.setImageCount(seriesArray[0].getImageCount());		
			study.setSeriesCount(seriesArray.length);		
			study.setComponentSeries(componentSeries);
			return study;
		}
		return createStudyType();
	}
	
	private gov.va.med.imaging.mix.webservices.rest.types.v1.StudyType createStudyType()
	{
		gov.va.med.imaging.mix.webservices.rest.types.v1.StudyType study = 
			new gov.va.med.imaging.mix.webservices.rest.types.v1.StudyType();
		study.setDescription("Study description");
		study.setDicomUid("654.321");
		study.setModalities(new ModalitiesType(new String []{"CR"}));
		study.setPatientId("9516284");
		study.setPatientName("TESTPATIENT,NAME");
		study.setProcedureDate("200701012123");
		study.setProcedureDescription("Procedure description");
//		study.setRadiologyReport("Rad report");
		study.setSiteAbbreviation("DOD");
		study.setSiteName("Dept. of Defense");
		study.setSiteNumber("200");
		study.setSpecialtyDescription("Specialty");
		study.setStudyId("urn:bhiestudy:753.42.86");
		
		gov.va.med.imaging.mix.webservices.rest.types.v1.SeriesType [] seriesArray =
			new gov.va.med.imaging.mix.webservices.rest.types.v1.SeriesType[1];
		seriesArray[0] = createSeriesType(); 
		gov.va.med.imaging.mix.webservices.rest.types.v1.StudyTypeComponentSeries componentSeries = 
			new gov.va.med.imaging.mix.webservices.rest.types.v1.StudyTypeComponentSeries();
		componentSeries.setSeries(seriesArray);
		
		study.setImageCount(seriesArray[0].getImageCount());		
		study.setSeriesCount(seriesArray.length);		
		study.setComponentSeries(componentSeries);
		
		return study;
	}
	
	private gov.va.med.imaging.mix.webservices.rest.types.v1.SeriesType createSeriesType(boolean nullValues)
	{
		if(nullValues)
		{
			gov.va.med.imaging.mix.webservices.rest.types.v1.SeriesType series = 
				new gov.va.med.imaging.mix.webservices.rest.types.v1.SeriesType();
			series.setSeriesId("seriesId-123456");
			series.setDicomSeriesNumber(null);
			series.setDicomUid(null);
			series.setDescription(null);
			series.setModality("CR");
			gov.va.med.imaging.mix.webservices.rest.types.v1.SeriesTypeComponentInstances instances = 
				new gov.va.med.imaging.mix.webservices.rest.types.v1.SeriesTypeComponentInstances();
			gov.va.med.imaging.mix.webservices.rest.types.v1.InstanceType [] instanceArray = 
				new gov.va.med.imaging.mix.webservices.rest.types.v1.InstanceType[1];
			instanceArray[0] = createInstanceType(nullValues);
			instances.setInstance(instanceArray);
			series.setComponentInstances(instances);
			return series;
		}
		return createSeriesType();
	}
	
	private gov.va.med.imaging.mix.webservices.rest.types.v1.SeriesType createSeriesType()
	{
		gov.va.med.imaging.mix.webservices.rest.types.v1.SeriesType series = 
			new gov.va.med.imaging.mix.webservices.rest.types.v1.SeriesType();
		series.setDescription("Series description");
		series.setDicomSeriesNumber(456);
		series.setDicomUid("456.789.012");
		series.setImageCount(1);
		series.setModality("CR");
		series.setSeriesId("seriesId-123456");
		
		gov.va.med.imaging.mix.webservices.rest.types.v1.SeriesTypeComponentInstances instances = 
			new gov.va.med.imaging.mix.webservices.rest.types.v1.SeriesTypeComponentInstances();
		gov.va.med.imaging.mix.webservices.rest.types.v1.InstanceType [] instanceArray = 
			new gov.va.med.imaging.mix.webservices.rest.types.v1.InstanceType[1];
		instanceArray[0] = createInstanceType();
		instances.setInstance(instanceArray);
		series.setComponentInstances(instances);
		return series;
	}
	
	private gov.va.med.imaging.mix.webservices.rest.types.v1.InstanceType createInstanceType(boolean nullValues)
	{
		if(nullValues) {
			gov.va.med.imaging.mix.webservices.rest.types.v1.InstanceType instance = 
				new gov.va.med.imaging.mix.webservices.rest.types.v1.InstanceType();
			instance.setDicomInstanceNumber(null);
			instance.setDicomUid(null);
			instance.setImageUrn("urn:bhieimage:123-456-789");
			return instance;
		}
		return createInstanceType();
	}
	
	private gov.va.med.imaging.mix.webservices.rest.types.v1.InstanceType createInstanceType()
	{
		gov.va.med.imaging.mix.webservices.rest.types.v1.InstanceType instance = 
			new gov.va.med.imaging.mix.webservices.rest.types.v1.InstanceType();
		instance.setDicomInstanceNumber(132);
		instance.setDicomUid("123.456.789");
		instance.setImageUrn("urn:bhieimage:123-456-789");
		return instance;
	}
}
