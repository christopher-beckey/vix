/**
 * 
 * Property of ISI Group, LLC
 * Date Created: Aug 25, 2014
 * Developer: Julian Werfel
 */
package gov.va.med.imaging.study.web.rest.types;

import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlRootElement;

/**
 * @author Julian
 *
 */
@XmlRootElement(name="serieses")
public class ViewerStudySeriesesType
{
	private ViewerStudySeriesType [] series;
	
	public ViewerStudySeriesesType()
	{
		super();
	}

	/**
	 * @param series
	 */
	public ViewerStudySeriesesType(ViewerStudySeriesType[] series)
	{
		super();
		this.series = series;
	}

	/**
	 * @return the series
	 */
	@XmlElement(name = "series")
	public ViewerStudySeriesType[] getSeries()
	{
		return series;
	}

	/**
	 * @param series the series to set
	 */
	public void setSeries(ViewerStudySeriesType[] series)
	{
		this.series = series;
	}

}
