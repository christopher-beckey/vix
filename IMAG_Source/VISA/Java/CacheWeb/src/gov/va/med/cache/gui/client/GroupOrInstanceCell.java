/**
 * 
 */
package gov.va.med.cache.gui.client;

import gov.va.med.cache.gui.shared.AbstractNamedVO;
import gov.va.med.cache.gui.shared.GroupVO;
import gov.va.med.cache.gui.shared.InstanceVO;

import com.google.gwt.cell.client.Cell;
import com.google.gwt.cell.client.FieldUpdater;
import com.google.gwt.cell.client.HasCell;
import com.google.gwt.safehtml.shared.SafeHtml;
import com.google.gwt.safehtml.shared.SafeHtmlBuilder;

/**
 * @author VHAISWBECKEC
 * 
 */
public class GroupOrInstanceCell 
extends AbstractNamedItemCell<AbstractNamedVO>
{
	private HasCell<AbstractNamedVO, AbstractNamedVO> hasCell = null;
	
	public GroupOrInstanceCell(CacheContentTreeModel model, String... consumedEvents) 
	{
		super(model, consumedEvents);
		this.hasCell = new HasGroupOrInstanceCell();
	}

	@Override
	public void render(Context context, AbstractNamedVO value, SafeHtmlBuilder sb)
	{
		boolean isGroup = (value instanceof GroupVO);
		String ELEMENT = isGroup ? Configuration.clientMessages.groupElement() : Configuration.clientMessages.instanceElement();
		
		sb.appendHtmlConstant("<" + ELEMENT + " class=\"" + getHtmlClass(value) + "\">");
		sb.append(getIconHtml(value));
		sb.appendEscaped(value.getName());
		sb.appendHtmlConstant("</" + ELEMENT + " >");
	}

	/**
	 * Not used for this class, just return "unknown"
	 */
	@Override
	protected String getHtmlClass() 
	{
		return getHtmlClass(null);
	}

	protected SafeHtml getIconHtml(AbstractNamedVO value) {
		if(value instanceof InstanceVO)
			return ClientResourcesUtility.getIcon(((InstanceVO)value).getSemanticTypeName());
		else if(value instanceof GroupVO)
			return ClientResourcesUtility.getIcon(((GroupVO)value).getSemanticTypeName());
		return null;
	}

	private String getHtmlClass(AbstractNamedVO value)
	{
		if(value instanceof InstanceVO)
			return ((InstanceVO)value).getSemanticTypeName();
		else if(value instanceof GroupVO)
			return ((GroupVO)value).getSemanticTypeName();
		return "unknown";
	}

	@Override
	public boolean handlesSelection()
	{
		return true;
	}

	@Override
	public boolean dependsOnSelection()
	{
		return true;
	}
	
	@Override
	public HasCell<AbstractNamedVO, AbstractNamedVO> getHasCell() 
	{
		return hasCell;
	}

	/**
	 * 
	 */
	class HasGroupOrInstanceCell 
	implements HasCell<AbstractNamedVO, AbstractNamedVO>
	{
		@Override
		public Cell<AbstractNamedVO> getCell() {return GroupOrInstanceCell.this;}

		@Override
		public FieldUpdater<AbstractNamedVO, AbstractNamedVO> getFieldUpdater() {return null;}

		@Override
		public AbstractNamedVO getValue(AbstractNamedVO object){return object;}
	}
}
