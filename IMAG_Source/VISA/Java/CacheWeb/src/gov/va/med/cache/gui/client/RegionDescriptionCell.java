/**
 * 
 */
package gov.va.med.cache.gui.client;

import gov.va.med.cache.gui.shared.AbstractNamedVO;
import gov.va.med.cache.gui.shared.RegionVO;

import com.google.gwt.cell.client.Cell;
import com.google.gwt.cell.client.FieldUpdater;
import com.google.gwt.cell.client.HasCell;
import com.google.gwt.core.client.GWT;
import com.google.gwt.safehtml.shared.SafeHtmlBuilder;

/**
 * @author VHAISWBECKEC
 *
 */
public class RegionDescriptionCell 
extends AbstractNamedItemDescriptionCell<RegionVO>
{
	public final static String METADATA_ELEMENT = Configuration.clientMessages.regionDescriptionElement();
	public final static String METADATA_LIST_CONTAINER_ELEMENT = Configuration.clientMessages.regionDescriptionItemCollectionElement();
	public final static String METADATA_LIST_ELEMENT = Configuration.clientMessages.regionDescriptionItemElement();
	
	private static ClientMessages clientMessages = GWT.create(ClientMessages.class);

	private HasCell<RegionVO, RegionVO> hasCell = null;

	public RegionDescriptionCell(CacheContentTreeModel model, String... consumedEvents) 
	{
		super(model, consumedEvents);
		this.hasCell = new HasRegionDescriptionCell();
	}

	@Override
	public void render(Context context, AbstractNamedVO value, SafeHtmlBuilder sb)
	{
		RegionVO regionVO = (RegionVO)value;
		
		// if there is a description then create a second DIV with the class name as "description"
		// and write the description
		if(regionVO.getMetadata() != null)
		{
			sb.appendHtmlConstant("<" + METADATA_ELEMENT + " class=\"description\">");
			sb.appendHtmlConstant( "<" + METADATA_LIST_CONTAINER_ELEMENT + ">" );
			
			sb.appendHtmlConstant( "<" + METADATA_LIST_ELEMENT + ">" );
			sb.appendEscaped( clientMessages.regionInfoUsed() + ":" + regionVO.getMetadata().getUsedSpace() );
			sb.appendHtmlConstant( "</" + METADATA_LIST_ELEMENT + ">" );
			
			sb.appendHtmlConstant( "<" + METADATA_LIST_ELEMENT + ">" );
			sb.appendEscaped( clientMessages.regionInfoTotal() + ":" + regionVO.getMetadata().getTotalSpace() );
			sb.appendHtmlConstant( "</" + METADATA_LIST_ELEMENT + ">" );
			
			sb.appendHtmlConstant( "</" + METADATA_LIST_CONTAINER_ELEMENT + ">" );
			sb.appendHtmlConstant("</" + METADATA_ELEMENT + ">");
		}
	}
	
	@Override
	public HasCell<RegionVO, RegionVO> getHasCell() {return hasCell;}

	/**
	 * 
	 */
	class HasRegionDescriptionCell 
	implements HasCell<RegionVO, RegionVO>
	{
		@Override
		public Cell<RegionVO> getCell() {return RegionDescriptionCell.this;}

		@Override
		public FieldUpdater<RegionVO, RegionVO> getFieldUpdater() {return null;}

		@Override
		public RegionVO getValue(RegionVO object){return (RegionVO)object;}
	}
	
}
