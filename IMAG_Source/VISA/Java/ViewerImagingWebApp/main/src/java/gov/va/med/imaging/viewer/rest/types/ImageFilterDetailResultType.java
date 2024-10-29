package gov.va.med.imaging.viewer.rest.types;

import javax.xml.bind.annotation.XmlRootElement;

/**
 * Date Created: Apr 23, 2018
 * @author vhaisltjahjb
 *
 */
@XmlRootElement(name="imageFilterDetail")
public class ImageFilterDetailResultType
{
	private String filterIEN;
	private String filterName;
	private String packageIndex;
	private String classIndex;
	private String typeIndex;
	private String eventIndex;
	private String specialtiesIndex;
	private String dateFrom;
	private String dateThrough;
	private String relativeRange;
	
	private String origin;
	private String imageStatus;
	private String descriptionContains;
	private String capturedBy;
	private String useCaptureDates;
	private String dayRange;
	private String columnWidths;
	private String percent;

	public ImageFilterDetailResultType()
	{
		super();
	}

	public ImageFilterDetailResultType(
		String filterIEN,
		String filterName,
		String packageIndex,
		String classIndex,
		String typeIndex,
		String eventIndex,
		String specialtiesIndex,
		String dateFrom,
		String dateThrough,
		String relativeRange,
		
		String origin,
		String imageStatus,
		String descriptionContains,
		String capturedBy,
		String useCaptureDates,
		String dayRange,
		String columnWidths,
		String percent)
	{
		super();
		this.filterIEN = filterIEN;
		this.filterName = filterName;
		this.packageIndex = packageIndex;
		this.classIndex = classIndex;
		this.typeIndex = typeIndex;
		this.eventIndex = eventIndex;
		this.specialtiesIndex = specialtiesIndex;
		this.dateFrom = dateFrom;
		this.dateThrough = dateThrough;
		this.relativeRange = relativeRange;
		this.origin = origin;
		this.imageStatus = imageStatus;
		this.descriptionContains = descriptionContains;
		this.capturedBy = capturedBy;
		this.useCaptureDates = useCaptureDates;
		this.dayRange = dayRange;
		this.columnWidths = columnWidths;
		this.percent = percent;
	}

	/**
	 * @return the relativeRange
	 */
	public String getRelativeRange()
	{
		return relativeRange;
	}

	/**
	 * @param relativeRange the relativeRange to set
	 */
	public void setRelativeRange(String relativeRange)
	{
		this.relativeRange = relativeRange;
	}

	/**
	 * @return the dateThrough
	 */
	public String getDateThrough()
	{
		return dateThrough;
	}

	/**
	 * @param dateThrough the dateThrough to set
	 */
	public void setDateThrough(String dateThrough)
	{
		this.dateThrough = dateThrough;
	}
	
	/**
	 * @return the dateFrom
	 */
	public String getDateFrom()
	{
		return dateFrom;
	}

	/**
	 * @param dateFrom the dateFrom to set
	 */
	public void setDateFrom(String dateFrom)
	{
		this.dateFrom = dateFrom;
	}

	/**
	 * @return the specialtiesIndex
	 */
	public String getSpecialtiesIndex()
	{
		return specialtiesIndex;
	}

	/**
	 * @param specialtiesIndex the specialtiesIndex to set
	 */
	public void setSpecialtiesIndex(String specialtiesIndex)
	{
		this.specialtiesIndex = specialtiesIndex;
	}

	/**
	 * @return the eventIndex
	 */
	public String getEventIndex()
	{
		return eventIndex;
	}

	/**
	 * @param eventIndex the eventIndex to set
	 */
	public void setEventIndex(String eventIndex)
	{
		this.eventIndex = eventIndex;
	}

	/**
	 * @return the typeIndex
	 */
	public String getTypeIndex()
	{
		return typeIndex;
	}

	/**
	 * @param typeIndex the typeIndex to set
	 */
	public void setTypeIndex(String typeIndex)
	{
		this.typeIndex = typeIndex;
	}

	/**
	 * @return the filterIEN
	 */
	public String getFilterIEN()
	{
		return filterIEN;
	}

	/**
	 * @param filterIEN the filterIEN to set
	 */
	public void setFilterIEN(String filterIEN)
	{
		this.filterIEN = filterIEN;
	}

	/**
	 * @return the filterName
	 */
	public String getFilterName()
	{
		return filterName;
	}

	/**
	 * @param filterName the filterName to set
	 */
	public void setFilterName(String filterName)
	{
		this.filterName = filterName;
	}

	/**
	 * @return the packageIndex
	 */
	public String getPackageIndex()
	{
		return packageIndex;
	}

	/**
	 * @param packageIndex the packageIndex to set
	 */
	public void setPackageIndex(String packageIndex)
	{
		this.packageIndex = packageIndex;
	}


	/**
	 * @return the classIndex
	 */
	public String getClassIndex()
	{
		return classIndex;
	}

	/**
	 * @param classIndex the classIndex to set
	 */
	public void setClassIndex(String classIndex)
	{
		this.classIndex = classIndex;
	}

	public String getOrigin() {
		return origin;
	}

	public void setOrigin(String origin) {
		this.origin = origin;
	}

	public String getImageStatus() {
		return imageStatus;
	}

	public void setImageStatus(String imageStatus) {
		this.imageStatus = imageStatus;
	}

	public String getDescriptionContains() {
		return descriptionContains;
	}

	public void setDescriptionContains(String descriptionContains) {
		this.descriptionContains = descriptionContains;
	}

	public String getCapturedBy() {
		return capturedBy;
	}

	public void setCapturedBy(String capturedBy) {
		this.capturedBy = capturedBy;
	}

	public String getUseCaptureDates() {
		return useCaptureDates;
	}

	public void setUseCaptureDates(String useCaptureDates) {
		this.useCaptureDates = useCaptureDates;
	}

	public String getDayRange() {
		return dayRange;
	}

	public void setDayRange(String dayRange) {
		this.dayRange = dayRange;
	}

	public String getColumnWidths() {
		return columnWidths;
	}

	public void setColumnWidths(String columnWidths) {
		this.columnWidths = columnWidths;
	}

	public String getPercent() {
		return percent;
	}

	public void setPercent(String percent) {
		this.percent = percent;
	}



}
