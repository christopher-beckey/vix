/**
 * 
 */
package gov.va.med.cache.gui.client;

import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

import com.google.gwt.event.shared.GwtEvent;
import com.google.gwt.event.shared.HandlerRegistration;
import com.google.gwt.view.client.HasData;
import com.google.gwt.view.client.Range;
import com.google.gwt.view.client.RangeChangeEvent.Handler;
import com.google.gwt.view.client.SelectionModel;

/**
 * A "ghost" widget, it has no UI and just serves as a passthrough to notify
 * something that new data has been added.
 * 
 * @author VHAISWBECKEC
 *
 */
public class GhostHasData<T> 
implements HasData<T>
{
	final Set<Handler> rangeCheckHandlers = new HashSet<Handler>();
	final Set<com.google.gwt.view.client.RowCountChangeEvent.Handler> changeEventHandlers =
		new HashSet<com.google.gwt.view.client.RowCountChangeEvent.Handler>();
	final Set<com.google.gwt.view.client.CellPreviewEvent.Handler<T>> cellPreviewHandlers =
		new HashSet<com.google.gwt.view.client.CellPreviewEvent.Handler<T>>();
	
	@Override
	public HandlerRegistration addRangeChangeHandler(Handler handler)
	{
		rangeCheckHandlers.add(handler);
		return new LocalRangeCheckHandlerRegistration<T>(this, handler);
	}
	
	@Override
	public HandlerRegistration addRowCountChangeHandler(com.google.gwt.view.client.RowCountChangeEvent.Handler handler)
	{
		changeEventHandlers.add(handler);
		return new LocalChangeEventHandlerRegistration<T>(this, handler);
	}

	@Override
	public HandlerRegistration addCellPreviewHandler(com.google.gwt.view.client.CellPreviewEvent.Handler<T> handler)
	{
		cellPreviewHandlers.add(handler);
		return new LocalCellPreviewHandlerRegistration<T>(this, handler);
	}
	
	private Range visibleRange =  new Range(0, Integer.MAX_VALUE);
	
	@Override
	public Range getVisibleRange()
	{
		return visibleRange;
	}
	@Override
	public void setVisibleRange(int start, int length)
	{
		setVisibleRange( new Range(start, length) );
	}
	
	@Override
	public void setVisibleRange(Range range)
	{
		int s = Math.max(0, range.getStart());
		int l = Math.max( 0, Math.min(getRowCount(), range.getLength())-s );
		this.visibleRange = new Range(s, l);
	}


	private final List<T> data = new ArrayList<T>();
	private int rowCount = 0;
	private boolean rowCountExact = false;
	@Override
	public void setRowCount(int count)
	{
		this.rowCount = count;
	}
	
	@Override
	public int getRowCount()
	{
		return this.rowCount;
	}

	@Override
	public void setRowData(int start, List<? extends T> values)
	{
		data.addAll(start, values);
		setRowCount(data.size());
	}

	@Override
	public void setRowCount(int count, boolean isExact)
	{
		setRowCount(count);
		rowCountExact = isExact;
	}

	@Override
	public boolean isRowCountExact()
	{
		return rowCountExact;
	}

	@Override
	public void fireEvent(GwtEvent<?> event)
	{
		
	}

	private SelectionModel<? super T> selectionModel;
	@Override
	public SelectionModel<? super T> getSelectionModel()
	{
		return this.selectionModel;
	}
	
	@Override
	public void setSelectionModel(SelectionModel<? super T> selectionModel)
	{
		this.selectionModel = selectionModel;
	}


	@Override
	public T getVisibleItem(int indexOnPage)
	{
		
		try
		{
			return this.data.get( this.visibleRange.getStart() + indexOnPage );
		}
		catch (IndexOutOfBoundsException e)
		{
			return null;
		}
		
	}

	@Override
	public int getVisibleItemCount()
	{
		return getVisibleRange().getLength() - getVisibleRange().getStart();
	}

	@Override
	public Iterable<T> getVisibleItems()
	{
		return this.data.subList(
			getVisibleRange().getStart(), 
			getVisibleRange().getStart() + getVisibleRange().getLength() 
		);
	}
	
	@Override
	public void setVisibleRangeAndClearData(Range range, boolean forceRangeChangeEvent)
	{
		setVisibleRange(range);
	}
	
	// =================================================================================
	// HandlerRegistration Classes
	// =================================================================================
	private static class LocalRangeCheckHandlerRegistration<T>
	implements HandlerRegistration
	{
		private GhostHasData<T> ghost;
		private Handler handler;
		public LocalRangeCheckHandlerRegistration(GhostHasData<T> ghost, Handler handler)
		{
			super();
			this.ghost = ghost;
			this.handler = handler;
		}
		
		@Override
		public void removeHandler()
		{
			ghost.rangeCheckHandlers.remove(handler);
		}
	}

	private static class LocalChangeEventHandlerRegistration<T>
	implements HandlerRegistration
	{
		private GhostHasData<T> ghost;
		private com.google.gwt.view.client.RowCountChangeEvent.Handler handler;
		public LocalChangeEventHandlerRegistration(GhostHasData<T> ghost, com.google.gwt.view.client.RowCountChangeEvent.Handler handler)
		{
			super();
			this.ghost = ghost;
			this.handler = handler;
		}
		
		@Override
		public void removeHandler()
		{
			ghost.changeEventHandlers.remove(handler);
		}
	}
	
	private static class LocalCellPreviewHandlerRegistration<T>
	implements HandlerRegistration
	{
		private GhostHasData<T> ghost;
		private com.google.gwt.view.client.CellPreviewEvent.Handler<T> handler;
		public LocalCellPreviewHandlerRegistration(GhostHasData<T> ghost, com.google.gwt.view.client.CellPreviewEvent.Handler<T> handler)
		{
			super();
			this.ghost = ghost;
			this.handler = handler;
		}
		
		@Override
		public void removeHandler()
		{
			ghost.cellPreviewHandlers.remove(handler);
		}
	}	
}
