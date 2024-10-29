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
public class CacheCell 
extends AbstractNamedItemCell<CacheVO>
{
	public final static String ELEMENT = Configuration.clientMessages.cacheElement();
	public final static String METADATA_ELEMENT = Configuration.clientMessages.cacheDescriptionElement();
	
	private static final String	HTML_CLASS	= "cache-cell";
	private HasCell<CacheVO, CacheVO> hasCell = null;

	public CacheCell(CacheContentTreeModel model, String... consumedEvents) 
	{
		super(model, consumedEvents);
		this.hasCell = new HasCacheManagerCell();
	}

	@Override
	protected String getHtmlClass()
	{
		return HTML_CLASS;
	}

	@Override
	public void render(Context context, AbstractNamedVO value, SafeHtmlBuilder sb)
	{
		CacheVO cacheVO = (CacheVO)value;
		
		// create a DIV, set the class to the semantic type and then output the name in the DIV
		sb.appendHtmlConstant("<" + ELEMENT + " class=\"" + getHtmlClass() + "\">");
		sb.appendEscaped(value.getName());
		// if there is a description then create a second DIV with the class name as "description"
		// and write the description
//		if(cacheVO.getMetadata() != null)
//		{
//			sb.appendHtmlConstant("<" + METADATA_ELEMENT + " class=\"description\">");
//			sb.appendHtmlConstant( "<" + METADATA_LIST_CONTAINER_ELEMENT + ">" );
//			
//			sb.appendHtmlConstant( "<" + METADATA_LIST_ELEMENT + ">" );
//			sb.appendEscaped( "URI :" + cacheVO.getMetadata().getcacheUri() );
//			sb.appendHtmlConstant( "</" + METADATA_LIST_ELEMENT + ">" );
//			
//			sb.appendHtmlConstant( "<" + METADATA_LIST_ELEMENT + ">" );
//			sb.appendEscaped( "protocol :" + cacheVO.getMetadata().getProtocol() );
//			sb.appendHtmlConstant( "</" + METADATA_LIST_ELEMENT + ">" );
//			
//			sb.appendHtmlConstant( "<" + METADATA_LIST_ELEMENT + ">" );
//			sb.appendEscaped( "location :" + cacheVO.getMetadata().getLocation() );
//			sb.appendHtmlConstant( "</" + METADATA_LIST_ELEMENT + ">" );
//			
//			sb.appendHtmlConstant("</" + METADATA_LIST_CONTAINER_ELEMENT + ">");
//			sb.appendHtmlConstant("</" + METADATA_ELEMENT + ">");
//		}
		sb.appendHtmlConstant("</" + ELEMENT + ">");
	}
	
	@Override
	public boolean handlesSelection()
	{
		return true;
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
	class HasCacheManagerCell 
	implements HasCell<CacheVO, CacheVO>
	{
		@Override
		public Cell<CacheVO> getCell() {return CacheCell.this;}

		@Override
		public FieldUpdater<CacheVO, CacheVO> getFieldUpdater() {return null;}

		@Override
		public CacheVO getValue(CacheVO object){return (CacheVO)object;}
	}
	
}
