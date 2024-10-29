package gov.va.med.imaging.exchange.proxy.v1;

import gov.va.med.imaging.DicomDateFormat;
import gov.va.med.imaging.StringUtil;
import gov.va.med.imaging.exchange.webservices.soap.types.v1.*;
import gov.va.med.imaging.proxy.AbstractResult;

import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.io.Serializable;
import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;

/**
 * A simple wrapper class that allows the proxy to return the transaction identifier along with
 * the studies.
 * As a derivation of AbstractResult,  this class always has a Transaction ID once it has been created.
 * If one is not supplied in the constructor then one is created in the constructor.  
 * Once created the transaction ID is immutable. 
 * 
 * @author VHAISWBECKEC
 *
 */
public class StudyResult
extends AbstractResult
implements Serializable
{
	private static final long serialVersionUID = -4974352581115168471L;
	private StudyType[] studies;
	
	public StudyResult(String transactionId, StudyType[] studies)
	{
		super(transactionId);
		this.studies = studies;
	}

	public StudyType[] getStudies()
	{
		return this.studies;
	}
	
	/**
	 * @see gov.va.med.imaging.Equivalent
	 */
	public boolean equivalent(Object obj)
	{
		if (this == obj)
			return true;
		if (obj == null)
			return false;
		if (getClass() != obj.getClass())
			return false;
		final StudyResult that = (StudyResult)obj;
		
		// if the studies list is null in both instances then the results are equivalent
		if(this.studies == null && that.studies == null)
			return true;

		// if the studies list is null in one instances but not the other then the results are not equivalent
		if(this.studies == null && that.studies != null ||
				this.studies != null && that.studies == null)
			return false;

		// if the number of studies differ then the results are not equivalent
		if(this.studies.length != that.studies.length)
			return false;
		
		// at this point we know that both instances have studies and both instances have the
		// same number of studies
		// equivalence is determined on the same studies, the same study IDs and the studies
		// with the same IDs are .equals()
		for(StudyType study : this.studies)
		{
			boolean studyMatchFound = false;
			for(StudyType thatStudy : that.studies)
			{
				// if the study IDs match then the rest of the studyType must match
				if( study.getStudyId().equals(thatStudy.getStudyId()) )
				{
					studyMatchFound = true;
					if(! study.equals(thatStudy))
						return false;
					break;
				}
			}
			// no study with the same study ID was found in the 'that' results
			if(!studyMatchFound)
				return false;
		}
		
		return true;
	}

	/**
	 * @param filespec - the tab delimited file to append to. Filespec will be created
	 * if it does not already exist. This is a helper function used to build the test data
	 * spreadhsheet for CPS.
	 */
	public void appendStudiesToTabDelimitedFile(String filespec)
	{
		StringBuilder sb = new StringBuilder();
		
		if (studies == null)
		{
			return;
		}

		// Fortify change: added clean string
		File file = new File(StringUtil.cleanString(filespec));
		
		if (!file.exists())
		{
			sb.append("Patient/Proc Date\tStudy\tSeries\tInstance\tCount\tDICOM UID\tDICOM #\n"); // column headers
		}
		
		for (int i = 0 ; i < this.studies.length ; i++)
		{
			StudyType study = this.studies[i];
			if (i == 0)
			{
				sb.append(study.getPatientName().trim() + " (" + study.getPatientId() + ")\n"); // patient line
			}
			sb.append(translateProcedureDateFromDicom(study.getProcedureDate()) + 
					"\t" + " Study:" + study.getStudyId() + 
					"(" + study.getProcedureDescription() + " - " + study.getDescription() +
					")\t\t\t" + study.getSeriesCount() +   
					"\t" + study.getDicomUid() + "\n"); // study line
			
			StudyTypeComponentSeries componentSeries = study.getComponentSeries();
			for (int j = 0 ; j < study.getSeriesCount() ; j++)
			{
				SeriesType series = componentSeries.getSeries(j);
				sb.append("\t\tSeries:" + series.getSeriesId() +  
						"\t\t" + series.getImageCount() + "\t" + series.getDicomUid() + 
						"\t" + series.getDicomSeriesNumber()+ "\n"); // series line
	
				SeriesTypeComponentInstances componentInstances = series.getComponentInstances();
				for (int k = 0 ; k < series.getImageCount() ; k++)
				{
					InstanceType image = componentInstances.getInstance(k);
					// sb.append("\t\t\tImage:" + image.getImageId() +	
					sb.append("\t\t\tImage:" + image.getImageUrn() +	
							"\t\t" + image.getDicomUid() + 
							"\t" + image.getDicomInstanceNumber() + "\n"); // instance line
				}
			}
		}
		
		String results = sb.toString();
		
		// Fortify change: added try-with-resources
		try ( FileWriter writer = new FileWriter(file, true) ) 
		{
			writer.write(results);
		} 
		catch (IOException e) 
		{
			e.printStackTrace();
		}		
	}
	
	private String translateProcedureDateFromDicom(String dateString)
	{
		String procedureDateString = "";
		if (dateString != null)
		{
			String trimmedDateString = dateString.trim();
			if (trimmedDateString.length() > 0)
			{
				DateFormat procedureDateFormat = null;
				DateFormat dicomDateFormat = new DicomDateFormat();
				if (dateString.trim().length() > 8)
				{
					procedureDateFormat = new SimpleDateFormat("MM/dd/yyyy HH:mm");
				}
				else
				{
					procedureDateFormat = new SimpleDateFormat("MM/dd/yyyy");
				}
				
				Date procedureDate = null;
				try 
				{
					procedureDate = dicomDateFormat.parse(trimmedDateString);
				} 
				catch (ParseException e) 
				{
					e.printStackTrace();
				}
				procedureDateString = procedureDateFormat.format(procedureDate);
			}
		}
		return procedureDateString;
	}
}

