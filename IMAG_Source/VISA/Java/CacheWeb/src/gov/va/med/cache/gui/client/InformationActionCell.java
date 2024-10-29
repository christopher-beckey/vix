package gov.va.med.cache.gui.client;

import static com.google.gwt.dom.client.BrowserEvents.KEYDOWN;
import gov.va.med.cache.gui.shared.AbstractNamedVO;
import gov.va.med.cache.gui.shared.CacheItemPath;

import java.util.logging.Logger;

import com.google.gwt.cell.client.ActionCell;
import com.google.gwt.cell.client.ActionCell.Delegate;
import com.google.gwt.cell.client.Cell;
import com.google.gwt.cell.client.FieldUpdater;
import com.google.gwt.cell.client.HasCell;
import com.google.gwt.cell.client.ValueUpdater;
import com.google.gwt.dom.client.Element;
import com.google.gwt.dom.client.EventTarget;
import com.google.gwt.dom.client.NativeEvent;
import com.google.gwt.safehtml.shared.SafeHtmlBuilder;

/**
 * @param <T>
 */
class InformationActionCell<T extends AbstractNamedVO>
extends ActionCell<T>
implements HasCell<T, T>
{
	private static final int SPACE_BAR = 32; 
	
	public static <T extends AbstractNamedVO> InformationActionCell<T> create(CacheContentTreeModel model)
	{
		InformationActionDelegate<T> delegate = new InformationActionDelegate<T>(model);
		return new InformationActionCell<T>(model, delegate);
	}

	// ====================================================================================
	// 
	// ====================================================================================
	
	private InformationActionCell(CacheContentTreeModel model, InformationActionDelegate<T> delegate) 
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
		sb.append(ClientResourcesUtility.INFORMATION_ICON_REFERENCE);
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
class InformationActionDelegate<S extends AbstractNamedVO> 
implements Delegate<S>
{
	private static Logger	logger	= Logger.getLogger(ActionableNamedItemCell.class.getName());
	private CacheContentTreeModel model;
	
	public InformationActionDelegate(CacheContentTreeModel model) {this.model = model;}

	@Override
	public void execute(S context) 
	{
		String contextName = context.getName();
		logger.info("Information " + contextName);
		
		CacheItemPath path = context.getPath();
		model.getItemInformation(path);
	}
}


