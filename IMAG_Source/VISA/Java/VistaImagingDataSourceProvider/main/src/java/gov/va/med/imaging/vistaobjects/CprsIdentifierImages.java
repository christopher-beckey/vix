package gov.va.med.imaging.vistaobjects;

import gov.va.med.imaging.exchange.business.Study;

import java.util.HashMap;
import java.util.List;

public class CprsIdentifierImages {

	private HashMap<String, List<Study>> vistaStudies;

	private HashMap<String, List<VistaImage>> vistaImages;
	private HashMap<String, String> errorVistaImages;
	private HashMap<String, String> imageGroups;
	private int lastStudyIen;
	
	public CprsIdentifierImages()
	{
		super();
		vistaStudies = new HashMap<String, List<Study>>();
		vistaImages = new HashMap<String, List<VistaImage>>();
		errorVistaImages = new HashMap<String, String>();
		imageGroups = new HashMap<String, String>();
	}

	public HashMap<String, List<Study>> getVistaStudies()
	{
		return vistaStudies;
	}

	public HashMap<String, List<VistaImage>> getVistaImages()
	{
		return vistaImages;
	}
	
	public HashMap<String, String> getErrorVistaImages()
	{
		return errorVistaImages;
	}

	public HashMap<String, String> getVistaImageGroups()
	{
		return imageGroups;
	}
	
	public int getLastStudyIen()
	{
		return lastStudyIen;
	}

	public void setLastStudyIen(int value)
	{
		lastStudyIen =  value;
	}

}
