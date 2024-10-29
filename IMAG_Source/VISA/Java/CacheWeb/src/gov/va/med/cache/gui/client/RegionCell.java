/**
 * 
 */
package gov.va.med.cache.gui.client;

import gov.va.med.cache.gui.shared.AbstractNamedVO;
import gov.va.med.cache.gui.shared.RegionVO;

import com.google.gwt.cell.client.Cell;
import com.google.gwt.cell.client.FieldUpdater;
import com.google.gwt.cell.client.HasCell;
import com.google.gwt.safehtml.shared.SafeHtmlBuilder;

/**
 * @author VHAISWBECKEC
 *
 */
public class RegionCell 
extends AbstractNamedItemCell<RegionVO>
{
	public final static String ELEMENT = Configuration.clientMessages.regionElement();
	
	private static final String	HTML_CLASS	= "region-cell";

	private HasCell<RegionVO, RegionVO> hasCell = null;

	public RegionCell(CacheContentTreeModel model, String... consumedEvents) 
	{
		super(model, consumedEvents);
		this.hasCell = new HasRegionCell();
	}

	@Override
	protected String getHtmlClass()
	{
		return HTML_CLASS;
	}

	@Override
	public void render(Context context, AbstractNamedVO value, SafeHtmlBuilder sb)
	{
		RegionVO regionVO = (RegionVO)value;
		
		// create a DIV, set the class to the semantic type and then output the name in the DIV
		sb.appendHtmlConstant("<" + ELEMENT + " class=\"" + getHtmlClass() + "\">");
		sb.appendEscaped(regionVO.getName());
		sb.appendHtmlConstant("</" + ELEMENT + ">");
	}
	
	@Override
	public boolean handlesSelection()
	{
		return true;
	}
	
	@Override
	public HasCell<RegionVO, RegionVO> getHasCell() 
	{
		return hasCell;
	}

	/**
	 * 
	 */
	class HasRegionCell 
	implements HasCell<RegionVO, RegionVO>
	{
		@Override
		public Cell<RegionVO> getCell() {return RegionCell.this;}

		@Override
		public FieldUpdater<RegionVO, RegionVO> getFieldUpdater() {return null;}

		@Override
		public RegionVO getValue(RegionVO object){return (RegionVO)object;}
	}
	
}
