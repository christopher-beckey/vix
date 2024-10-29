package gov.va.med.imaging.vistaobjects;

import gov.va.med.imaging.url.vista.StringUtils;

public class VistaStoredStudyFilter {

	private String id;
	private String name;
	private String packages;
	private String classes;
	private String types;
	private String procEvents;
	private String specSubSpec;
	private String fromDate;
	private String toDate;
	private int maxResults;
	private String origin;
	
	private VistaStoredStudyFilter()
	{
		maxResults = Integer.MAX_VALUE;
	}
	
	public static VistaStoredStudyFilter create(String vistaResult)
	{
		String [] lines = StringUtils.Split(vistaResult, StringUtils.NEW_LINE);
		
		if(lines.length == 1)
		{
			// filter not found
			return null;
		}
		
		VistaStoredStudyFilter result = new VistaStoredStudyFilter();
		
		String[] pieces = StringUtils.Split(lines[1], StringUtils.CARET);
		result.id = pieces[0];
		result.name = pieces[1];
		result.packages = pieces[2];
		result.classes = pieces[3];
		result.types = pieces[4];
		result.procEvents = pieces[5];
		result.specSubSpec = pieces[6];
		result.fromDate = pieces[7];
		result.toDate = pieces[8];
		result.origin = pieces[10];
		
		result.maxResults = Integer.parseInt(pieces[15]);
		
		return result;
	}
	
	/*
		   If (Pos('MED', Str) > 0) Then
    Result := Result + [MpkgMED];
  If (Pos('SUR', Str) > 0) Then
    Result := Result + [MpkgSUR];
  If (Pos('RAD', Str) > 0) Then
    Result := Result + [MpkgRAD];
  If (Pos('LAB', Str) > 0) Then
    Result := Result + [MpkgLAB];
  If (Pos('NOTE', Str) > 0) Then
    Result := Result + [MpkgNOTE];
  If (Pos('CP', Str) > 0) Then
    Result := Result + [MpkgCP];
  If (Pos('CNSLT', Str) > 0) Then
    Result := Result + [MpkgCNSLT];
  If (Pos('NONE', Str) > 0) Then
    Result := Result + [MpkgNONE];
End; 
		 */
	/*
	private String convertPackages(String line)
	{		
		String result = "";
		
		if(line.contains("MED"))
					
		return result;
	}*/


	public String getId() {
		return id;
	}


	public void setId(String id) {
		this.id = id;
	}


	public String getName() {
		return name;
	}


	public void setName(String name) {
		this.name = name;
	}


	public String getPackages() {
		return packages;
	}


	public void setPackages(String packages) {
		this.packages = packages;
	}


	public String getClasses() {
		return classes;
	}


	public void setClasses(String classes) {
		this.classes = classes;
	}


	public String getTypes() {
		return types;
	}


	public void setTypes(String types) {
		this.types = types;
	}


	public String getProcEvents() {
		return procEvents;
	}


	public void setProcEvents(String procEvents) {
		this.procEvents = procEvents;
	}


	public String getSpecSubSpec() {
		return specSubSpec;
	}


	public void setSpecSubSpec(String specSubSpec) {
		this.specSubSpec = specSubSpec;
	}


	public String getFromDate() {
		return fromDate;
	}


	public void setFromDate(String fromDate) {
		this.fromDate = fromDate;
	}


	public String getToDate() {
		return toDate;
	}


	public void setToDate(String toDate) {
		this.toDate = toDate;
	}

	public int getMaxResults() {
		return maxResults;
	}

	public void setMaxResults(int maxResults) {
		this.maxResults = maxResults;
	}

	public String getOrigin() {
		return origin;
	}

	public void setOrigin(String origin) {
		this.origin = origin;
	}
	
	
}
