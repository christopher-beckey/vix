/**
 * 
 */
package gov.va.med.cache.gui.client;

import gov.va.med.cache.gui.shared.AbstractNamedVO;
import gov.va.med.cache.gui.shared.CacheGroupMetadata;
import gov.va.med.cache.gui.shared.CacheInstanceMetadata;
import gov.va.med.cache.gui.shared.GroupVO;
import gov.va.med.cache.gui.shared.InstanceVO;

import com.google.gwt.cell.client.Cell;
import com.google.gwt.cell.client.FieldUpdater;
import com.google.gwt.cell.client.HasCell;
import com.google.gwt.core.client.GWT;
import com.google.gwt.i18n.client.DateTimeFormat;
import com.google.gwt.i18n.client.DateTimeFormat.PredefinedFormat;
import com.google.gwt.safehtml.shared.SafeHtmlBuilder;

/**
 * @author VHAISWBECKEC
 * 
 */
public class GroupOrInstanceDescriptionCell 
extends AbstractNamedItemDescriptionCell<AbstractNamedVO>
{
	private DateTimeFormat df = DateTimeFormat.getFormat(PredefinedFormat.DATE_TIME_MEDIUM);
	private static ClientMessages clientMessages = GWT.create(ClientMessages.class);
	
	private HasCell<AbstractNamedVO, AbstractNamedVO> hasCell = null;
	
	public GroupOrInstanceDescriptionCell(CacheContentTreeModel model, String... consumedEvents) 
	{
		super(model, consumedEvents);
		this.hasCell = new HasGroupOrInstanceDescriptionCell();
	}

	@Override
	public void render(Context context, AbstractNamedVO value, SafeHtmlBuilder sb)
	{
		boolean isGroup = (value instanceof GroupVO);
		String METADATA_ELEMENT = isGroup ? Configuration.clientMessages.groupDescriptionElement() : Configuration.clientMessages.instanceDescriptionElement();
		String METADATA_LIST_CONTAINER_ELEMENT = isGroup ? Configuration.clientMessages.groupDescriptionItemCollectionElement() : Configuration.clientMessages.instanceDescriptionItemCollectionElement();
		String METADATA_LIST_ELEMENT = isGroup ? Configuration.clientMessages.groupDescriptionItemElement() : Configuration.clientMessages.instanceDescriptionItemElement();
		
		// if there is a description then create a second DIV with the class name as "description"
		// and write the description
		sb.appendHtmlConstant("<" + METADATA_ELEMENT + " class=\"description\">");
		sb.appendHtmlConstant( "<" + METADATA_LIST_CONTAINER_ELEMENT + ">" );
		
		if(value instanceof InstanceVO && ((InstanceVO)value).getMetadata() != null)
		{
			CacheInstanceMetadata instanceMetadata = ((InstanceVO)value).getMetadata();
			sb.appendHtmlConstant( "<" + METADATA_LIST_ELEMENT + ">" );
			sb.appendEscaped( clientMessages.instanceInfoSize() + ":" + BinaryOrdersOfMagnitude.format(instanceMetadata.getSize()) );
			sb.appendHtmlConstant( "</" + METADATA_LIST_ELEMENT + ">" );

			sb.appendHtmlConstant( "<" + METADATA_LIST_ELEMENT + ">" );
			sb.appendEscaped( clientMessages.instanceInfoLastAccessed() + ":" + df.format(instanceMetadata.getLastAccessDate()) );
			sb.appendHtmlConstant( "</" + METADATA_LIST_ELEMENT + ">" );
			
			sb.appendHtmlConstant( "<" + METADATA_LIST_ELEMENT + ">" );
			sb.appendEscaped( clientMessages.instanceInfoChecksum() + ":" + instanceMetadata.getChecksum() );
			sb.appendHtmlConstant( "</" + METADATA_LIST_ELEMENT + ">" );
		}
		else if(value instanceof GroupVO && ((GroupVO)value).getMetadata() != null)
		{
			CacheGroupMetadata groupMetadata = ((GroupVO)value).getMetadata();
			sb.appendHtmlConstant( "<" + METADATA_LIST_ELEMENT + ">" );
			sb.appendEscaped( clientMessages.groupInfoSize() + ":" + BinaryOrdersOfMagnitude.format(groupMetadata.getSize()) );
			sb.appendHtmlConstant( "</" + METADATA_LIST_ELEMENT + ">" );
			
			sb.appendHtmlConstant( "<" + METADATA_LIST_ELEMENT + ">" );
			sb.appendEscaped( clientMessages.groupInfoLastAccessed() + ":" + df.format(groupMetadata.getLastAccessDate()) );
			sb.appendHtmlConstant( "</" + METADATA_LIST_ELEMENT + ">" );
		}
		sb.appendHtmlConstant( "</" + METADATA_LIST_CONTAINER_ELEMENT + ">" );
		sb.appendHtmlConstant("</" + METADATA_ELEMENT + ">");
	}

	@Override
	public HasCell<AbstractNamedVO, AbstractNamedVO> getHasCell() 
	{
		return hasCell;
	}

	/**
	 * 
	 */
	class HasGroupOrInstanceDescriptionCell 
	implements HasCell<AbstractNamedVO, AbstractNamedVO>
	{
		@Override
		public Cell<AbstractNamedVO> getCell() {return GroupOrInstanceDescriptionCell.this;}

		@Override
		public FieldUpdater<AbstractNamedVO, AbstractNamedVO> getFieldUpdater() {return null;}

		@Override
		public AbstractNamedVO getValue(AbstractNamedVO object){return object;}
	}
}
