/**
 * 
 */
package gov.va.med.cache.gui.client;

import com.google.gwt.cell.client.Cell;
import com.google.gwt.cell.client.FieldUpdater;
import com.google.gwt.cell.client.HasCell;

import gov.va.med.cache.gui.shared.CacheManagerVO;

/**
 * @author VHAISWBECKEC
 *
 */
public class CacheManagerCell 
extends AbstractNamedItemCell<CacheManagerVO> 
{
	private static final String	HTML_CLASS	= "cache-cell";
	private HasCell<CacheManagerVO, ?> hasCell = null;

	public CacheManagerCell(CacheContentTreeModel model, String... consumedEvents) 
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
	public boolean handlesSelection()
	{
		return true;
	}
	
	@Override
	public HasCell<CacheManagerVO, ?> getHasCell()
	{
		return this.hasCell;
	}

	/**
	 * 
	 */
	class HasCacheManagerCell 
	implements HasCell<CacheManagerVO, CacheManagerVO>
	{
		@Override
		public Cell<CacheManagerVO> getCell() {return CacheManagerCell.this;}

		@Override
		public FieldUpdater<CacheManagerVO, CacheManagerVO> getFieldUpdater() {return null;}

		@Override
		public CacheManagerVO getValue(CacheManagerVO object){return (CacheManagerVO)object;}
	}
}
