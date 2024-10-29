/**
 * 
 */
package gov.va.med.cache.gui.client;

import com.google.gwt.cell.client.Cell;
import com.google.gwt.cell.client.FieldUpdater;
import com.google.gwt.cell.client.HasCell;
import com.google.gwt.cell.client.Cell.Context;
import com.google.gwt.safehtml.shared.SafeHtmlBuilder;

import gov.va.med.cache.gui.shared.AbstractNamedVO;
import gov.va.med.cache.gui.shared.CacheManagerVO;
import gov.va.med.cache.gui.shared.CacheVO;

/**
 * @author VHAISWBECKEC
 *
 */
public class CacheManagerDescriptionCell 
extends AbstractNamedItemDescriptionCell<CacheManagerVO> 
{
	public final static String ELEMENT = Configuration.clientMessages.instanceElement();
	public final static String METADATA_ELEMENT = Configuration.clientMessages.instanceDescriptionElement();
	public final static String METADATA_LIST_CONTAINER_ELEMENT = Configuration.clientMessages.instanceDescriptionItemCollectionElement();
	public final static String METADATA_LIST_ELEMENT = Configuration.clientMessages.instanceDescriptionItemElement();
	
	private HasCell<CacheManagerVO, ?> hasCell = null;

	public CacheManagerDescriptionCell(CacheContentTreeModel model, String... consumedEvents) 
	{
		super(model, consumedEvents);
		this.hasCell = new HasCacheManagerDescriptionCell();
	}
	
	@Override
	public HasCell<CacheManagerVO, ?> getHasCell(){return this.hasCell;}

	@Override
	public void render(Context context, AbstractNamedVO value, SafeHtmlBuilder sb)
	{
		// do nothing, no metadata
	}
	
	/**
	 * 
	 */
	class HasCacheManagerDescriptionCell 
	implements HasCell<CacheManagerVO, CacheManagerVO>
	{
		@Override
		public Cell<CacheManagerVO> getCell() {return CacheManagerDescriptionCell.this;}

		@Override
		public FieldUpdater<CacheManagerVO, CacheManagerVO> getFieldUpdater() {return null;}

		@Override
		public CacheManagerVO getValue(CacheManagerVO object){return (CacheManagerVO)object;}
	}
}
