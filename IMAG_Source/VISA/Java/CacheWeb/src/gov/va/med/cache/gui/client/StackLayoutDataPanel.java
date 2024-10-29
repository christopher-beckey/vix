/**
 * 
 */
package gov.va.med.cache.gui.client;

import java.util.Collections;
import java.util.HashSet;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.logging.Logger;

import com.google.gwt.dom.client.Style.Unit;
import com.google.gwt.event.shared.HandlerRegistration;
import com.google.gwt.user.client.ui.StackLayoutPanel;
import com.google.gwt.user.client.ui.Widget;
import com.google.gwt.view.client.HasData;
import com.google.gwt.view.client.Range;
import com.google.gwt.view.client.RangeChangeEvent.Handler;
import com.google.gwt.view.client.SelectionModel;

/**
 * @author VHAISWBECKEC
 *
 */
public abstract class StackLayoutDataPanel<T, W extends Widget> 
extends StackLayoutPanel 
implements HasData<T>
{
	public final static String ELEMENT_STYLE = "stack-element";
	public final static String ELEMENT_HEADER_STYLE = "stack-element-header";
	
	// ordering is critical, use a Map that provides consistent ordering
	private final Map<W, T> widgetValueMap = new LinkedHashMap<W, T>();
	private int headerSize = 40;

	private SelectionModel<? super T> selectionModel;
	
	private final Set<Handler> rangeCheckHandlers = new HashSet<Handler>();
	private final Set<com.google.gwt.view.client.RowCountChangeEvent.Handler> changeEventHandlers =
		new HashSet<com.google.gwt.view.client.RowCountChangeEvent.Handler>();
	private final Set<com.google.gwt.view.client.CellPreviewEvent.Handler<T>> cellPreviewHandlers =
		new HashSet<com.google.gwt.view.client.CellPreviewEvent.Handler<T>>();
	private Range visibleRange = new Range(0,0);
	private int rowCount = 0;
	private boolean rowCountExact = false;
	
	Logger logger = Logger.getLogger("StackLayoutDataPanel");
	
	/**
	 * 
	 * @param unit
	 */
	public StackLayoutDataPanel(Unit unit, int headerSize)
	{
		super(unit);
		this.headerSize = headerSize;
	}

	public int getHeaderSize()
	{
		return headerSize;
	}

	/**
	 * This method must be overridden.
	 * 
	 * @param identifier
	 * @return
	 */
	public abstract W createStackPanelWidget(T elementValue);
	
	/**
	 * This method should be overwritten to do anything meaningful.
	 * By default, this method simply creates an HTML widget with toString() of the element.
	 * 
	 * @param identifier
	 * @return
	 */
	public abstract Widget createStackPanelHeaderWidget(T elementValue);
	
	// =================================================================================
	// HasData implementation
	// =================================================================================
	@Override
	public void setSelectionModel(SelectionModel<? super T> selectionModel)
	{
		this.selectionModel = selectionModel;
	}

	@Override
	public SelectionModel<? super T> getSelectionModel()
	{
		return this.selectionModel;
	}

	@Override
	public T getVisibleItem(int indexOnPage)
	{
		int index = 0;
		for(Map.Entry<W, T> entry : this.widgetValueMap.entrySet())
			if(indexOnPage == index++)
				return entry.getValue();
		
		return null;
	}

	@Override
	public int getVisibleItemCount()
	{
		return this.visibleRange.getLength();
	}

	@Override
	public Iterable<T> getVisibleItems()
	{
		return Collections.unmodifiableCollection( this.widgetValueMap.values() );
	}

	@Override
	public void setRowData(int start, List<? extends T> values)
	{
		for(T elementValue : values)
		{
			//MessageDialog.showInformationDialog("CacheStackPanel", "Adding panel for '" + cache.getName() + "'.");
			W panelWidget = createStackPanelWidget(elementValue);
			Widget headerWidget = createStackPanelHeaderWidget(elementValue);
			
			panelWidget.setStylePrimaryName(ELEMENT_STYLE);
			headerWidget.setStylePrimaryName(ELEMENT_HEADER_STYLE);
			
			// retain the mapping of the elements widget to the value
			widgetValueMap.put(panelWidget, elementValue);
			
			// add the panel and the header to ourselves
			this.add(panelWidget, headerWidget, getHeaderSize());
		}
		
		setRowCount(widgetValueMap.size()-1, true);
		setVisibleRange(new Range(0, widgetValueMap.size()-1));
	}

	@Override
	public void setVisibleRangeAndClearData(Range range, boolean forceRangeChangeEvent)
	{
		setVisibleRange(range);
	}

	// =================================================================================
	// HasRows implementation
	// =================================================================================

	@Override
	public HandlerRegistration addRangeChangeHandler(Handler handler)
	{
		rangeCheckHandlers.add(handler);
		return new LocalRangeCheckHandlerRegistration<T, W>(this, handler);
	}
	@Override
	public HandlerRegistration addRowCountChangeHandler(com.google.gwt.view.client.RowCountChangeEvent.Handler handler)
	{
		changeEventHandlers.add(handler);
		return new LocalChangeEventHandlerRegistration<T, W>(this, handler);
	}
	@Override
	public HandlerRegistration addCellPreviewHandler(com.google.gwt.view.client.CellPreviewEvent.Handler<T> handler)
	{
		cellPreviewHandlers.add(handler);
		return new LocalCellPreviewHandlerRegistration<T, W>(this, handler);
	}
	
	@Override
	public Range getVisibleRange()
	{
		return new Range(0, getVisibleItemCount()-1);
	}
	@Override
	public void setVisibleRange(int start, int length)
	{
		
	}
	@Override
	public void setVisibleRange(Range range)
	{
		this.visibleRange = range;
	}

	@Override
	public int getRowCount()
	{
		return this.rowCount;
	}
	@Override
	public boolean isRowCountExact()
	{
		return rowCountExact;
	}
	@Override
	public void setRowCount(int count)
	{
		this.rowCount = count;
	}
	@Override
	public void setRowCount(int count, boolean isExact)
	{
		setRowCount(count);
		this.rowCountExact = isExact;
	}

	// =================================================================================
	// HandlerRegistration Classes
	// =================================================================================
	private static class LocalRangeCheckHandlerRegistration<T, W extends Widget>
	implements HandlerRegistration
	{
		private StackLayoutDataPanel<T, W> ghost;
		private Handler handler;
		public LocalRangeCheckHandlerRegistration(StackLayoutDataPanel<T, W> ghost, Handler handler)
		{
			super();
			this.ghost = ghost;
			this.handler = handler;
		}
		
		@SuppressWarnings("synthetic-access")
		@Override
		public void removeHandler()
		{
			ghost.rangeCheckHandlers.remove(handler);
		}
	}

	private static class LocalChangeEventHandlerRegistration<T, W extends Widget>
	implements HandlerRegistration
	{
		private StackLayoutDataPanel<T, W> ghost;
		private com.google.gwt.view.client.RowCountChangeEvent.Handler handler;
		public LocalChangeEventHandlerRegistration(StackLayoutDataPanel<T, W> ghost, com.google.gwt.view.client.RowCountChangeEvent.Handler handler)
		{
			super();
			this.ghost = ghost;
			this.handler = handler;
		}
		
		@SuppressWarnings("synthetic-access")
		@Override
		public void removeHandler()
		{
			ghost.changeEventHandlers.remove(handler);
		}
	}
	
	private static class LocalCellPreviewHandlerRegistration<T, W extends Widget>
	implements HandlerRegistration
	{
		private StackLayoutDataPanel<T, W> ghost;
		private com.google.gwt.view.client.CellPreviewEvent.Handler<T> handler;
		public LocalCellPreviewHandlerRegistration(StackLayoutDataPanel<T, W> ghost, com.google.gwt.view.client.CellPreviewEvent.Handler<T> handler)
		{
			super();
			this.ghost = ghost;
			this.handler = handler;
		}
		
		@SuppressWarnings("synthetic-access")
		@Override
		public void removeHandler()
		{
			ghost.cellPreviewHandlers.remove(handler);
		}
	}	

}
