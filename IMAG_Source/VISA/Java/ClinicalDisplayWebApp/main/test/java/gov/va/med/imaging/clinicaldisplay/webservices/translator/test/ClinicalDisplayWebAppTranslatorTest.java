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
package gov.va.med.imaging.clinicaldisplay.webservices.translator.test;

import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;

import gov.va.med.imaging.clinicaldisplay.webservices.translator.ClinicalDisplayTranslator;
import gov.va.med.imaging.clinicaldisplay.webservices.translator.ClinicalDisplayTranslator3;
import gov.va.med.imaging.clinicaldisplay.webservices.translator.ClinicalDisplayTranslator4;
import gov.va.med.imaging.exceptions.URNFormatException;
import gov.va.med.imaging.exchange.business.Image;
import gov.va.med.imaging.exchange.business.Series;
import gov.va.med.imaging.exchange.business.Study;
import gov.va.med.imaging.translator.test.TranslatorTestBusinessObjectBuilder;

/**
 * Runs unit tests on the clinical display web app translator
 * @author VHAISWWERFEJ
 *
 */
public class ClinicalDisplayWebAppTranslatorTest 
extends	ClinicalDisplayWebAppTestBase 
{
	private static final int STUDY_COUNT = 10;
	
	public ClinicalDisplayWebAppTranslatorTest()
	{
		super(ClinicalDisplayWebAppTranslatorTest.class.toString());
	}
	
	private Object[] getTranslators()
	{
		Object [] translators = {
				new ClinicalDisplayTranslator(), 
				//new ClinicalDisplayTranslator2(),
				new ClinicalDisplayTranslator3(),
				new ClinicalDisplayTranslator4()
		};
		return translators;
	}
	
	public void testStudyTranslator() throws URNFormatException
	{
		int studyCount = STUDY_COUNT;	
		//int studyCount = 1;
		System.out.println("Testing [" + studyCount + "] studies"); //$NON-NLS-1$ //$NON-NLS-2$
		for(int i = 0; i < studyCount; i++ )
		{
			Study study = TranslatorTestBusinessObjectBuilder.createStudy(site);
			testTranslateStudy(study);
		}
	}
	
	public void testImageTranslator() throws URNFormatException
	{
		Study study = TranslatorTestBusinessObjectBuilder.createStudy(site);
		
		for(Series series : study.getSeries())
		{
			for(Image image : series)
			{
				testTranslateImage(image, series);
			}
		}
	}
	
	private void testTranslateImage(Image image, Series series)
	{
		Object[] translators = getTranslators();
		for(int i = 0; i < translators.length; i++)
		{
			Object translator = translators[i];
			try
			{			
				Class<?> translatorClass = translator.getClass();					
				String value = "ClinicalDisplayWebAppTranslatorTest." + translatorClass.getName() + ".transformImageToFatImage";
				String translateStudyMethodName = Messages.getString(value); //$NON-NLS-1$
				//System.out.println("Translate image method name [" + translateStudyMethodName + "]");
				//System.out.println("Translator class name [" + translatorClass.getName() + "]");
				//Method translateImageMethod = translatorClass.getMethod(translateStudyMethodName, Image.class);				
				Class [] methods = {Image.class, Series.class};
				Method translateImageMethod = translatorClass.getMethod(translateStudyMethodName, methods);
				Object parameters[] = {image, series};
				//Object instanceType = translateImageMethod.invoke(translator, image);
				Object instanceType = translateImageMethod.invoke(translator, parameters);
				assertNotNull(instanceType);
				compareImage(image, instanceType, translatorClass);
			}
			catch(NoSuchMethodException nsmX)
			{
				System.out.println("Failed testing translate image with translator [" + translator.getClass() + "]");
				nsmX.printStackTrace();
				fail(nsmX.getMessage());
			}
			catch(IllegalAccessException iaX)
			{
				System.out.println("Failed testing translate image with translator [" + translator.getClass() + "]");
				iaX.printStackTrace();
				fail(iaX.getMessage());
			}
			catch(InvocationTargetException itX)
			{
				System.out.println("Failed testing translate image with translator [" + translator.getClass() + "]");
				itX.printStackTrace();
				fail(itX.getMessage());
			}
		}
	}
	
	private void testTranslateStudy(Study study)
	{
		Object[] translators = getTranslators();
		for(int i = 0; i < translators.length; i++)
		{
			Object translator = translators[i];
			try
			{		
				Class<?> translatorClass = translator.getClass();
				//String translateStudyMethodName = Messages.getString("ClinicalDisplayWebAppTranslatorTest.gov.va.med.imaging.clinicaldisplay.webservices.translator.ClinicalDisplayTranslator.transformStudyToShallStudy"); //$NON-NLS-1$
				String value = "ClinicalDisplayWebAppTranslatorTest." + translatorClass.getName() + ".transformStudyToShallStudy"; //$NON-NLS-1$ //$NON-NLS-2$
				String translateStudyMethodName = Messages.getString(value); //$NON-NLS-1$
				Method translateStudyMethod = translatorClass.getMethod(translateStudyMethodName, Study.class);
				Object studyType = translateStudyMethod.invoke(translator, study);
				assertNotNull(studyType);
				compareStudy(study, studyType, translatorClass);
			}
			catch(NoSuchMethodException nsmX)
			{
				System.out.println("Failed testing translate study with translator [" + translator.getClass() + "]");
				nsmX.printStackTrace();
				fail(nsmX.getMessage());
			}
			catch(IllegalAccessException iaX)
			{
				System.out.println("Failed testing translate study with translator [" + translator.getClass() + "]");
				iaX.printStackTrace();
				fail(iaX.getMessage());
			}
			catch(InvocationTargetException itX)
			{
				System.out.println("Failed testing translate study with translator [" + translator.getClass() + "]");
				itX.printStackTrace();
				fail(itX.getMessage());
			}
		}
	}
	
	private void compareStudy(Study study, Object studyType, Class<?> translatorClass)
	{
		Class<?> studyTypeClass = studyType.getClass();
		assertNotNull(study);
		assertNotNull(studyType);
		
		try
		{
			String getDescriptionMethodName = Messages.getString("ClinicalDisplayWebAppTranslatorTest." + translatorClass.getName() + ".getDescription"); //$NON-NLS-1$ //$NON-NLS-2$
			compareField(study.getDescription(), getDescriptionMethodName, studyTypeClass, studyType);			
			String getEventMethodName = Messages.getString("ClinicalDisplayWebAppTranslatorTest." + translatorClass.getName() + ".getEvent"); //$NON-NLS-1$
			compareField(study.getEvent(), getEventMethodName, studyTypeClass, studyType);
			String getImageCountMethodName = Messages.getString("ClinicalDisplayWebAppTranslatorTest." + translatorClass.getName() + ".getImageCount"); //$NON-NLS-1$
			assertEquals(study.getImageCount() + "", getValue(getMethod(getImageCountMethodName, studyTypeClass, null), studyType, null) + "");
			String getImagePackageMethodName = Messages.getString("ClinicalDisplayWebAppTranslatorTest." + translatorClass.getName() + ".getImagePackage"); //$NON-NLS-1$
			compareField(study.getImagePackage(), getImagePackageMethodName, studyTypeClass, studyType);
			String getImageTypeMethodName = Messages.getString("ClinicalDisplayWebAppTranslatorTest." + translatorClass.getName() + ".getImageType"); //$NON-NLS-1$
			compareField(study.getImageType(), getImageTypeMethodName, studyTypeClass, studyType);
			String getNoteTitleMethodName = Messages.getString("ClinicalDisplayWebAppTranslatorTest." + translatorClass.getName() + ".getNoteTitle"); //$NON-NLS-1$
			compareField(study.getNoteTitle(), getNoteTitleMethodName, studyTypeClass, studyType);
			String getOriginMethodName = Messages.getString("ClinicalDisplayWebAppTranslatorTest." + translatorClass.getName() + ".getOrigin"); //$NON-NLS-1$
			compareField(study.getOrigin(), getOriginMethodName, studyTypeClass, studyType);
			String getPatientIcnMethodName = Messages.getString("ClinicalDisplayWebAppTranslatorTest." + translatorClass.getName() + ".getPaientIcn"); //$NON-NLS-1$
			compareField(study.getPatientId(), getPatientIcnMethodName, studyTypeClass, studyType);
			String getPatientNameMethodName = Messages.getString("ClinicalDisplayWebAppTranslatorTest." + translatorClass.getName() + ".getPatientName"); //$NON-NLS-1$
			compareField(study.getPatientName(), getPatientNameMethodName, studyTypeClass, studyType);
			String getProcedureMethodName = Messages.getString("ClinicalDisplayWebAppTranslatorTest." + translatorClass.getName() + ".getProcedure"); //$NON-NLS-1$
			compareField(study.getProcedure(), getProcedureMethodName, studyTypeClass, studyType);
			// in version 4 the report is no longer included in the Study object
			if(translatorClass != ClinicalDisplayTranslator4.class)
			{			
				String getRadiologyReportMethodName = Messages.getString("ClinicalDisplayWebAppTranslatorTest." + translatorClass.getName() + ".getRadiologyReport"); //$NON-NLS-1$
				compareField(study.getRadiologyReport(), getRadiologyReportMethodName, studyTypeClass, studyType);
			}
			String getSiteNumberMethodName = Messages.getString("ClinicalDisplayWebAppTranslatorTest." + translatorClass.getName() + ".getSiteNumber"); //$NON-NLS-1$
			compareField(study.getSiteNumber(), getSiteNumberMethodName, studyTypeClass, studyType);
			String getSpecialtyMethodName = Messages.getString("ClinicalDisplayWebAppTranslatorTest." + translatorClass.getName() + ".getSpecialty"); //$NON-NLS-1$
			compareField(study.getSpecialty(), getSpecialtyMethodName, studyTypeClass, studyType);
			String getStudyPackageMethodName = Messages.getString("ClinicalDisplayWebAppTranslatorTest." + translatorClass.getName() + ".getStudyPackage"); //$NON-NLS-1$
			compareField(study.getImagePackage(), getStudyPackageMethodName, studyTypeClass, studyType);
			String getStudyClassMethodName = Messages.getString("ClinicalDisplayWebAppTranslatorTest." + translatorClass.getName() + ".getStudyClass"); //$NON-NLS-1$
			compareField(study.getStudyClass(), getStudyClassMethodName, studyTypeClass, studyType);
			String getStudyTypeMethodName = Messages.getString("ClinicalDisplayWebAppTranslatorTest." + translatorClass.getName() + ".getStudyType"); //$NON-NLS-1$
			compareField(study.getImageType(), getStudyTypeMethodName, studyTypeClass, studyType);
			String getCaptureDateMethodName = Messages.getString("ClinicalDisplayWebAppTranslatorTest." + translatorClass.getName() + ".getCaptureDate"); //$NON-NLS-1$
			compareField(study.getCaptureDate(), getCaptureDateMethodName, studyTypeClass, studyType);
			String getCaptureByMethodName = Messages.getString("ClinicalDisplayWebAppTranslatorTest." + translatorClass.getName() + ".getCaptureBy"); //$NON-NLS-1$
			compareField(study.getCaptureBy(), getCaptureByMethodName, studyTypeClass, studyType);
			//TODO: check procedure date
			String getRpcResponseMsgMethodName = Messages.getString("ClinicalDisplayWebAppTranslatorTest." + translatorClass.getName() + ".getRpcResponseMsg"); //$NON-NLS-1$
			compareField(study.getRpcResponseMsg(), getRpcResponseMsgMethodName, studyTypeClass, studyType);
			String getStudyIdMethodName = Messages.getString("ClinicalDisplayWebAppTranslatorTest." + translatorClass.getName() + ".getStudyId"); //$NON-NLS-1$
			compareField(study.getStudyUrn().toString(), getStudyIdMethodName, studyTypeClass, studyType);
			String getFirstImageMethodName = Messages.getString("ClinicalDisplayWebAppTranslatorTest." + translatorClass.getName() + ".getFirstImage"); //$NON-NLS-1$
			Method getFirstImageMethod = getMethod(getFirstImageMethodName, studyTypeClass, null);
			if(getFirstImageMethod != null)
			{
				Object firstImage = getFirstImageMethod.invoke(studyType);
				compareImage(study.getFirstImage(), firstImage, translatorClass);
			}			
		}
		catch(IllegalAccessException iaX)
		{
			iaX.printStackTrace();
			fail(iaX.getMessage());
		}
		catch(InvocationTargetException itX)
		{
			itX.printStackTrace();
			fail(itX.getMessage());
		}		
	}
	
	private void compareImage(Image image, Object instanceType, Class<?> translatorClass)
	{
		Class<?> instanceTypeClass = instanceType.getClass();
		assertNotNull(image);
		assertNotNull(instanceType);
		try
		{
			String getDescriptionMethodName = Messages.getString("ClinicalDisplayWebAppTranslatorTest." + translatorClass.getName() + ".getDescription"); //$NON-NLS-1$
			compareField(image.getDescription(), getDescriptionMethodName, instanceTypeClass, instanceType);
			String getDicomImageNumberMethodName = Messages.getString("ClinicalDisplayWebAppTranslatorTest." + translatorClass.getName() + ".getDicomImageNumber"); //$NON-NLS-1$
			compareField(image.getDicomImageNumberForDisplay(), getDicomImageNumberMethodName, instanceTypeClass, instanceType);
			
			String getDicomSequenceNumberMethodName = Messages.getString("ClinicalDisplayWebAppTranslatorTest." + translatorClass.getName() + ".getDicomSequenceNumber"); //$NON-NLS-1$
			compareField(image.getDicomSequenceNumberForDisplay(), getDicomSequenceNumberMethodName, instanceTypeClass, instanceType);
			
			
			String getPatientIcnMethodName = Messages.getString("ClinicalDisplayWebAppTranslatorTest." + translatorClass.getName() + ".getPatientIcn"); //$NON-NLS-1$
			compareField(image.getPatientId(), getPatientIcnMethodName, instanceTypeClass, instanceType);
			String getPatientNameMethodName = Messages.getString("ClinicalDisplayWebAppTranslatorTest." + translatorClass.getName() + ".getPatientName"); //$NON-NLS-1$
			compareField(image.getPatientName(), getPatientNameMethodName, instanceTypeClass, instanceType);
			String getProcedureMethodName = Messages.getString("ClinicalDisplayWebAppTranslatorTest." + translatorClass.getName() + ".getProcedure"); //$NON-NLS-1$
			compareField(image.getProcedure(), getProcedureMethodName, instanceTypeClass, instanceType);
			//TODO: compare procedure date
			String getSiteNumberMethodName = Messages.getString("ClinicalDisplayWebAppTranslatorTest." + translatorClass.getName() + ".getSiteNumber"); //$NON-NLS-1$
			compareField(image.getSiteNumber(), getSiteNumberMethodName, instanceTypeClass, instanceType);
			String getSiteAbbrMethodName = Messages.getString("ClinicalDisplayWebAppTranslatorTest." + translatorClass.getName() + ".getSiteAbbr"); //$NON-NLS-1$
			compareField(image.getSiteAbbr(), getSiteAbbrMethodName, instanceTypeClass, instanceType);
			String getImageClassMethodName = Messages.getString("ClinicalDisplayWebAppTranslatorTest." + translatorClass.getName() + ".getImageClass"); //$NON-NLS-1$
			compareField(image.getImageClass(), getImageClassMethodName, instanceTypeClass, instanceType);
			String getabsLocationMethodName = Messages.getString("ClinicalDisplayWebAppTranslatorTest." + translatorClass.getName() + ".getAbsLocation"); //$NON-NLS-1$
			compareField(image.getAbsLocation(), getabsLocationMethodName ,instanceTypeClass, instanceType);
			String getFullLocationMethodName = Messages.getString("ClinicalDisplayWebAppTranslatorTest." + translatorClass.getName() + ".getFullLocation"); //$NON-NLS-1$
			compareField(image.getFullLocation(), getFullLocationMethodName, instanceTypeClass, instanceType);
			String getQaMessageMethodName = Messages.getString("ClinicalDisplayWebAppTranslatorTest." + translatorClass.getName() + ".getImageQaMessage"); //$NON-NLS-1$
			compareField(image.getQaMessage(), getQaMessageMethodName, instanceTypeClass, instanceType);
			String getImageTypeMethodName = Messages.getString("ClinicalDisplayWebAppTranslatorTest." + translatorClass.getName() + ".getImageType"); //$NON-NLS-1$
			// special case since the image type is an int and the instanceType holds a big int, need to cast to string
			Object imageTypeValue = getValue(getMethod(getImageTypeMethodName, instanceTypeClass, null), instanceType, null);
			assertEquals(image.getImgType() + "", imageTypeValue + ""); //$NON-NLS-1$ //$NON-NLS-2$
			String getImageIdMethodName = Messages.getString("ClinicalDisplayWebAppTranslatorTest." + translatorClass.getName() + ".getImageId"); //$NON-NLS-1$
			compareField(image.getImageUrn().toString(), getImageIdMethodName, instanceTypeClass, instanceType);
			String getAbsImageUriMethodName = Messages.getString("ClinicalDisplayWebAppTranslatorTest." + translatorClass.getName() + ".getAbsImageUri"); //$NON-NLS-1$
			assertNotNull(getValue(getMethod(getAbsImageUriMethodName, instanceTypeClass, null), instanceType, null));
			String getFullImageUriMethodName = Messages.getString("ClinicalDisplayWebAppTranslatorTest." + translatorClass.getName() + ".getFullImageUri"); //$NON-NLS-1$
			assertNotNull(getValue(getMethod(getFullImageUriMethodName, instanceTypeClass, null), instanceType, null));
			String getBigImageUriMethodName = Messages.getString("ClinicalDisplayWebAppTranslatorTest." + translatorClass.getName() + ".getBigImageUri"); //$NON-NLS-1$
			assertNotNull(getValue(getMethod(getBigImageUriMethodName, instanceTypeClass, null), instanceType, null));
		}
		catch(IllegalAccessException iaX)
		{
			iaX.printStackTrace();
			fail(iaX.getMessage());
		}
		catch(InvocationTargetException itX)
		{
			itX.printStackTrace();
			fail(itX.getMessage());
		}
	}
	
	private void compareField(Object field, String methodName, Class<?> instanceClass, 
			Object instance)
	throws InvocationTargetException, IllegalAccessException
	{
		compareField(field, methodName, instanceClass, null, instance);
	}
	
	private void compareField(Object field, String methodName, Class<?> instanceClass, 
			Class<?> parameters, Object instance)
	throws InvocationTargetException, IllegalAccessException
	{
		//System.out.println("Testing method [" + methodName + "]");
		Method method = getMethod(methodName, instanceClass, parameters);
		if(method != null)
		{
			if(parameters == null)
			{
				assertEquals("Testing field [" + methodName + "]", field, method.invoke(instance));
			}
			else
			{
				assertEquals("Testing field [" + methodName + "]", field, method.invoke(instance, parameters));
			}
		}
	}
	
	private Object getValue(Method method, Object instance, Class<?> parameters)
	throws InvocationTargetException, IllegalAccessException
	{
		if(parameters == null)
		{
			return method.invoke(instance);
		}
		else
		{
			return method.invoke(instance, parameters);
		}
	}
	
	private Method getMethod(String methodName, Class<?> instanceClass, Class<?> parameters)
	{
		try
		{	
			Method method = null;		
			if(parameters == null)
			{
				method = instanceClass.getMethod(methodName);
			}
			else
			{
				method = instanceClass.getMethod(methodName, parameters);
			}
			return method;
		}
		catch(NoSuchMethodException nsmX)
		{
			nsmX.printStackTrace();
		}
		return null;
	}
}
