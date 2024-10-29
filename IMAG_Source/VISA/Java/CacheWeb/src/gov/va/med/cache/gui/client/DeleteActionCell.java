package gov.va.med.cache.gui.client;

import static com.google.gwt.dom.client.BrowserEvents.KEYDOWN;
import gov.va.med.cache.gui.shared.AbstractNamedVO;
import gov.va.med.cache.gui.shared.CacheItemPath;
import gov.va.med.cache.gui.shared.CacheVO;
import gov.va.med.cache.gui.shared.GroupVO;
import gov.va.med.cache.gui.shared.InstanceVO;

import java.util.logging.Logger;

import com.google.gwt.cell.client.ActionCell;
import com.google.gwt.cell.client.ActionCell.Delegate;
import com.google.gwt.cell.client.Cell;
import com.google.gwt.cell.client.FieldUpdater;
import com.google.gwt.cell.client.HasCell;
import com.google.gwt.cell.client.ValueUpdater;
import com.google.gwt.core.client.GWT;
import com.google.gwt.dom.client.Element;
import com.google.gwt.dom.client.EventTarget;
import com.google.gwt.dom.client.NativeEvent;
import com.google.gwt.safehtml.shared.SafeHtmlBuilder;

/**
 * @param <T>
 */
class DeleteActionCell<T extends AbstractNamedVO>
extends ActionCell<T>
implements HasCell<T, T>
{
	private static final int SPACE_BAR = 32; 
	
	public static <T extends AbstractNamedVO> DeleteActionCell<T> create(CacheContentTreeModel model)
	{
		DeleteActionDelegate<T> delegate = new DeleteActionDelegate<T>(model);
		return new DeleteActionCell<T>(model, delegate);
	}

	// ====================================================================================
	// 
	// ====================================================================================
	
	private DeleteActionCell(CacheContentTreeModel model, DeleteActionDelegate<T> delegate) 
	{
		super( "", delegate );
	}

	@Override
	public void onBrowserEvent(Context context, Element parent, T value,
			NativeEvent event, ValueUpdater<T> valueUpdater) {
		// TODO Auto-generated method stub
		super.onBrowserEvent(context, parent, value, event, valueUpdater);
	    if (KEYDOWN.equals(event.getType()) && event.getKeyCode() == SPACE_BAR) {
	      EventTarget eventTarget = event.getEventTarget();
	      if (!Element.is(eventTarget)) {
	        return;
	      }
	      if (parent.getFirstChildElement().isOrHasChild(Element.as(eventTarget))) {
	        onEnterKeyDown(context, parent, value, event, valueUpdater);
	      }
	    }
	}
	
	@Override
	public void render(Context context, T value, SafeHtmlBuilder sb) 
	{
		sb.append(ClientResourcesUtility.DELETE_ICON_REFERENCE);
	}

	@Override
	public Cell<T> getCell() {return this;}
	@Override
	public FieldUpdater<T, T> getFieldUpdater() {return null;}
	@Override
	public T getValue(T object) {return object;}

}

/**
 * 
 *
 * @param <S>
 */
class DeleteActionDelegate<S extends AbstractNamedVO> 
implements Delegate<S>
{
	private static Logger	logger	= Logger.getLogger(ActionableNamedItemCell.class.getName());
	private static ClientMessages clientMessages = GWT.create(ClientMessages.class);
	private CacheContentTreeModel model;
	
	public DeleteActionDelegate(CacheContentTreeModel model) {this.model = model;}

	@Override
	public void execute(S context) 
	{
		String contextName = context.getName();
		logger.info("Delete instance " + contextName);
		
		if (context instanceof InstanceVO)
			deleteInstance((InstanceVO)context);
		else if (context instanceof GroupVO)
			deleteGroup((GroupVO)context);
		else if (context instanceof CacheVO)
			clearCache((CacheVO)context);
	}
	
	protected boolean clearCache(CacheVO cache)
	{
		String cacheName = cache.getName();
		
		if( com.google.gwt.user.client.Window.confirm(clientMessages.cacheClearMessage(cacheName)) )
		{
			model.clearCache(cacheName);
			return true;
		}
		
		return false;
	}

	protected boolean deleteGroup(GroupVO key)
	{
		CacheItemPath path = key.getPath();
		if( com.google.gwt.user.client.Window.confirm(clientMessages.groupDeleteMessage(key.getSemanticTypeName(), key.getName())) )
		{
			model.deleteGroup(path);
			return true;
		}
		
		return false;
	}

	protected boolean deleteInstance(InstanceVO key)
	{
		CacheItemPath path = key.getPath();
		if (com.google.gwt.user.client.Window.confirm( clientMessages.instanceDeleteMessage(key.getName()) ) )
		{
			model.deleteInstance(path);
			return true;
		}
		
		return false;
	}
}


