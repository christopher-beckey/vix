/**
 * 
 */
package gov.va.med.cache.gui.client;

import gov.va.med.cache.gui.shared.AbstractNamedVO;

import java.util.ArrayList;
import java.util.List;
import java.util.logging.Logger;

import com.google.gwt.cell.client.CompositeCell;
import com.google.gwt.cell.client.HasCell;

/**
 * @author VHAISWBECKEC
 * 
 * Type Variables within this class definition
 * V extends AbstractNamedVO - the (concrete) type of value object that is to be rendered
 * All cache items (CacheVO, RegionVO, etc.) to be rendered are subclasses of AbstractNamedVO
 * 
 * A CompositeCell is composed of other Cells.
 * When this cell is rendered, it will render each component Cell inside a span. 
 * If the component Cell uses block level elements (such as a Div), the component cells will stack vertically.
 * Parameters:
 * <V> the type that this Cell represents
 */
public class ActionableNamedItemCell<V extends AbstractNamedVO> 
extends CompositeCell<V>
{
	// ======================================================================================================
	// Static Members
	// ======================================================================================================
	public static final String COMPOSITE_CELL_START_ELEMENT = "<div class=\"actionable-composite\">";
	public static final String COMPOSITE_CELL_END_ELEMENT = "</div>";
	
	static Logger	logger	= Logger.getLogger(ActionableNamedItemCell.class.getName());

	/**
	 * 
	 * @return
	 */
	@SuppressWarnings("unchecked")
	private static <D extends AbstractNamedVO> List<HasCell<D, ?>> createConstituentCells(
		CacheContentTreeModel model, 
		AbstractNamedItemCell<D> cell,
		AbstractNamedItemDescriptionCell<D> descriptionCell,
		boolean deletable,
		boolean moreInformationAvailable,
		boolean refreshable)
	{
		// Construct a composite cell for groups that includes a delete icon
		List<HasCell<D, ?>> hasCells = new ArrayList<HasCell<D, ?>>();

		hasCells.add( cell.getHasCell() );

		if(deletable)
			hasCells.add( (HasCell<D, ?>) DeleteActionCell.create(model) );

		if(moreInformationAvailable && descriptionCell != null)
			hasCells.add( (HasCell<D, ?>) InformationActionCell.create(model) );
		
		if(refreshable)
			hasCells.add( (HasCell<D, ?>) RefreshActionCell.create(model) );

		if(descriptionCell != null)
			hasCells.add( descriptionCell.getHasCell() );
		
		return hasCells;
	}

	// ======================================================================================================
	// Instance Members
	// ======================================================================================================
	
	/**
	 * 
	 * @param model
	 * @param cell
	 * @param deletable
	 * @param moreInformationAvailable
	 * @param refreshable
	 */
	public ActionableNamedItemCell(
		CacheContentTreeModel model, 
		AbstractNamedItemCell<V> cell, 
		AbstractNamedItemDescriptionCell<V> description, 
		boolean deletable, 
		boolean moreInformationAvailable,
		boolean refreshable)
	{
		// com.google.gwt.cell.client.CompositeCell.CompositeCell(List<HasCell<V, ?>> hasCells)
		// Construct a new CompositeCell.
		// Parameters:
		// hasCells the cells that makeup the composite
		//
		// V is the underlying data type, a subtype of AbstractNamedVO
		// ? is the Cell data type, implies that the Cell (rendered) type can be any type 
		super( ActionableNamedItemCell.createConstituentCells(
			model, 
			cell, 
			description, 
			Configuration.isShowDelete() && deletable, 
			moreInformationAvailable, 
			Configuration.isShowRefresh() && refreshable) );
	}
}
