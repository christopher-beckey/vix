/**
 * 
 */
package gov.va.med.cache.gui.client;

import gov.va.med.cache.gui.shared.AbstractNamedVO;

import com.google.gwt.cell.client.AbstractCell;
import com.google.gwt.cell.client.HasCell;
import com.google.gwt.safehtml.shared.SafeHtmlBuilder;

/**
 * @author VHAISWBECKEC
 * 
 */
public abstract class AbstractNamedItemDescriptionCell<C extends AbstractNamedVO> 
extends AbstractCell<C>
{
	private final CacheContentTreeModel model;

	public AbstractNamedItemDescriptionCell(CacheContentTreeModel model, String... consumedEvents) 
	{
		super(consumedEvents);
		this.model = model;
	}

	public CacheContentTreeModel getModel() {return model;}

	@Override
	public boolean handlesSelection(){return false;}
	
	@Override
	public boolean dependsOnSelection(){return false;}
	
	@Override
	public void render(Context context, AbstractNamedVO value, SafeHtmlBuilder sb)
	{
		// create a DIV, set the class to the semantic type and then output the name in the DIV
		sb.appendHtmlConstant("<span class=\"description\">");
		sb.appendEscaped(value.getName());
		// if there is a description then create a second DIV with the class name as "description"
		// and write the description
		sb.appendHtmlConstant("</span>");
	}
	
	public abstract HasCell<C, ?> getHasCell();
}
