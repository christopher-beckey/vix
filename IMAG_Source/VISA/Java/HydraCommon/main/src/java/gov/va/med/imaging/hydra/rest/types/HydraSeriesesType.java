/**
 * 
  Property of ISI Group, LLC
  Date Created: May 9, 2014
  Developer:  Julian Werfel
 */
package gov.va.med.imaging.hydra.rest.types;

import javax.xml.bind.annotation.XmlRootElement;

/**
 * @author Julian Werfel
 *
 */
@XmlRootElement(name="serieses")
public class HydraSeriesesType
{

	private HydraSeriesType [] series;
	
	public HydraSeriesesType()
	{
		super();
	}

	public HydraSeriesesType(HydraSeriesType[] series) {
		super();
		this.series = series;
	}

	public HydraSeriesType[] getSeries() {
		return series;
	}

	public void setSeries(HydraSeriesType[] series) {
		this.series = series;
	}
}
