/**
 * 
 */
package gov.va.med.cache.gui.client;

import gov.va.med.cache.gui.shared.AbstractNamedVO;
import gov.va.med.cache.gui.shared.CacheVO;

import com.google.gwt.cell.client.Cell;
import com.google.gwt.cell.client.FieldUpdater;
import com.google.gwt.cell.client.HasCell;
import com.google.gwt.safehtml.shared.SafeHtmlBuilder;

/**
 * @author VHAISWBECKEC
 *
 */
public class CacheDescriptionCell 
extends AbstractNamedItemDescriptionCell<CacheVO>
{
	public final static String METADATA_ELEMENT = Configuration.clientMessages.cacheDescriptionElement();
	public final static String METADATA_LIST_CONTAINER_ELEMENT = Configuration.clientMessages.cacheDescriptionItemCollectionElement();
	public final static String METADATA_LIST_ELEMENT = Configuration.clientMessages.cacheDescriptionItemElement();
	
	private HasCell<CacheVO, CacheVO> hasCell = null;

	public CacheDescriptionCell(CacheContentTreeModel model, String... consumedEvents) 
	{
		super(model, consumedEvents);
		this.hasCell = new HasCacheManagerDescriptionCell();
	}

	@Override
	public void render(Context context, AbstractNamedVO value, SafeHtmlBuilder sb)
	{
		CacheVO cacheVO = (CacheVO)value;
		
		if(cacheVO.getMetadata() != null)
		{
			sb.appendHtmlConstant("<" + METADATA_ELEMENT + " class=\"description\">");
			sb.appendHtmlConstant( "<" + METADATA_LIST_CONTAINER_ELEMENT + ">" );
			
			sb.appendHtmlConstant( "<" + METADATA_LIST_ELEMENT + ">" );
			sb.appendEscaped( "URI :" + cacheVO.getMetadata().getCacheUri() );
			sb.appendHtmlConstant( "</" + METADATA_LIST_ELEMENT + ">" );
			
			sb.appendHtmlConstant( "<" + METADATA_LIST_ELEMENT + ">" );
			sb.appendEscaped( "protocol :" + cacheVO.getMetadata().getProtocol() );
			sb.appendHtmlConstant( "</" + METADATA_LIST_ELEMENT + ">" );
			
			sb.appendHtmlConstant( "<" + METADATA_LIST_ELEMENT + ">" );
			sb.appendEscaped( "location :" + cacheVO.getMetadata().getLocation() );
			sb.appendHtmlConstant( "</" + METADATA_LIST_ELEMENT + ">" );
			
			sb.appendHtmlConstant("</" + METADATA_LIST_CONTAINER_ELEMENT + ">");
			sb.appendHtmlConstant("</" + METADATA_ELEMENT + ">");
		}
	}
	
	@Override
	public HasCell<CacheVO, CacheVO> getHasCell() {return hasCell;}

	/**
	 * HasCell<T,C> is an interface for extracting a value of type C from an underlying data value of type T, 
	 * provide a Cell to render that value, and provide a FieldUpdater to perform notification of updates to the cell.
	 * 
	 * Parameters:
	 * <T> the underlying data type
	 * <C> the cell data type
	 */
	class HasCacheManagerDescriptionCell 
	implements HasCell<CacheVO, CacheVO>
	{
		@Override
		public Cell<CacheVO> getCell() {return CacheDescriptionCell.this;}

		@Override
		public FieldUpdater<CacheVO, CacheVO> getFieldUpdater() {return null;}

		@Override
		public CacheVO getValue(CacheVO object){return (CacheVO)object;}
	}
	
}
