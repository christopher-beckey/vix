package gov.va.med.cache.gui.client;

import gov.va.med.cache.gui.shared.AbstractNamedVO;
import gov.va.med.cache.gui.shared.CacheItemPath;
import gov.va.med.cache.gui.shared.CacheManagerVO;
import gov.va.med.cache.gui.shared.CacheVO;
import gov.va.med.cache.gui.shared.GroupVO;
import gov.va.med.cache.gui.shared.InstanceVO;
import gov.va.med.cache.gui.shared.RegionVO;
import gov.va.med.cache.gui.shared.RootVO;

import java.util.logging.Level;
import java.util.logging.Logger;

import com.google.gwt.cell.client.AbstractCell;
import com.google.gwt.cell.client.Cell;
import com.google.gwt.safehtml.shared.SafeHtmlBuilder;
import com.google.gwt.view.client.AsyncDataProvider;
import com.google.gwt.view.client.SelectionModel;
import com.google.gwt.view.client.TreeViewModel;

/**
 * 
 * @author VHAISWBECKEC
 * 
 */
public class CacheContentTreeModel 
implements TreeViewModel
{
	final SelectionModel<AbstractNamedVO>				selectionModel;

	private final CacheDataProvider						dataProvider;
	Logger												logger					= Logger.getLogger("CacheContentTreeModel");

	/**
	 * @param cacheManager
	 *            - a reference to the root of the data model
	 * @param cache
	 *            - a reference to the cache within the data model that this
	 *            instance is to model
	 */
	public CacheContentTreeModel(CacheDataProvider dataProvider, SelectionModel<AbstractNamedVO> selectionModel)
	{
		this.dataProvider = dataProvider;
		this.selectionModel = selectionModel;
	}

	/**
	 * Get the NodeInfo that will provide the ProvidesKey, Cell, and HasData
	 * instances to retrieve and display the children of the specified value.
	 * 
	 * Specified by: getNodeInfo(...) in TreeViewModel 
	 * @param value the value in the parent node
	 * @return the NodeInfo
	 */
	@Override
	public <T> NodeInfo<?> getNodeInfo(T value)
	{
		String msg = "getNodeInfo(" + (value == null ? "<null>" : value.toString()) + ")";
		logger.log(Level.INFO, msg);
		
		// Return a node info that pairs the data with a cell.

		// if value is null, then this method is being asked for the
		// root node info
		if (value == null)
		{
			AsyncDataProvider<CacheManagerVO> cacheManagerDataProvider = dataProvider.getOrCreateDecorator((RootVO) null);
			// ListDataProvider<CacheManagerVO> dataProvider = new
			// ListDataProvider<CacheManagerVO>(mockContent);

			// Create a cell to display a composer.
			Cell<CacheManagerVO> cell = new CacheManagerCell(this);

			// Return a node info that pairs the data provider and the cell.
			return new DefaultNodeInfo<CacheManagerVO>(cacheManagerDataProvider, cell);
		}

		else if (value instanceof CacheManagerVO)
		{
			// LEVEL 1.
			// We want the children of the CacheManager. Return the Caches.
			AsyncDataProvider<CacheVO> cacheDataProvider = dataProvider.getOrCreateDecorator((CacheManagerVO) value);
			CacheCell cacheCell = new CacheCell(this);
			CacheDescriptionCell cacheDescriptionCell = new CacheDescriptionCell(this);
			Cell<CacheVO> cell = 
				new ActionableNamedItemCell<CacheVO>(this, cacheCell, cacheDescriptionCell, true, false, true);
			return new DefaultNodeInfo<CacheVO>(cacheDataProvider, cell);

		}
		else if (value instanceof CacheVO)
		{
			// LEVEL 2
			// We want the children of the Cache. Return the Regions.
			AsyncDataProvider<RegionVO> regionDataProvider = dataProvider.getOrCreateDecorator((CacheVO) value);
			RegionCell regionCell = new RegionCell(this);
			RegionDescriptionCell regionDescriptionCell = new RegionDescriptionCell(this);
			Cell<RegionVO> cell = 
				new ActionableNamedItemCell<RegionVO>(this, regionCell, regionDescriptionCell, false, true, true);
			return new DefaultNodeInfo<RegionVO>(regionDataProvider, cell);
		}
		else if (value instanceof RegionVO)
		{
			// LEVEL 3
			// We want the children of the Region. Return Groups.
			AsyncDataProvider<AbstractNamedVO> groupDataProvider = dataProvider.getOrCreateDecorator((RegionVO) value);
			GroupOrInstanceCell groupCell = new GroupOrInstanceCell(this);
			GroupOrInstanceDescriptionCell groupDescriptionCell = new GroupOrInstanceDescriptionCell(this);
			Cell<AbstractNamedVO> cell = 
				new ActionableNamedItemCell<AbstractNamedVO>(this, groupCell, groupDescriptionCell, true, true, true);
			return new DefaultNodeInfo<AbstractNamedVO>(groupDataProvider, cell);
		}
		else if (value instanceof GroupVO)
		{
			// LEVEL 4
			// We want the children of the Group. Return Groups and Instances
			AsyncDataProvider<AbstractNamedVO> groupDataProvider = dataProvider.getOrCreateDecorator((GroupVO) value) ;
			GroupOrInstanceCell groupCell = new GroupOrInstanceCell(this);
			GroupOrInstanceDescriptionCell groupDescriptionCell = new GroupOrInstanceDescriptionCell(this);
			Cell<AbstractNamedVO> cell = 
				new ActionableNamedItemCell<AbstractNamedVO>(this, groupCell, groupDescriptionCell, true, true, true);
			return new DefaultNodeInfo<AbstractNamedVO>(groupDataProvider, cell);
		}

		else return null;
	}

	/**
	 * Check if the specified value represents a leaf node. Leaf nodes cannot be
	 * opened. An instance is always a leaf node. MAYBE ... A group may be a
	 * leaf node, if the children have been retrieved from the server and there
	 * were none. ... still working on this, 'cause a group may get populated
	 * after we check it.
	 */
	@Override
	public boolean isLeaf(Object value)
	{
		return (value instanceof InstanceVO);
	}
	
	public void clearCache(String cacheName) 
	{
		this.dataProvider.clearCache(cacheName);
	}
	
	public void deleteGroup(CacheItemPath path)
	{
		this.dataProvider.deleteGroup(path);
	}

	public void deleteInstance(CacheItemPath path)
	{
		this.dataProvider.deleteInstance(path);
	}

	public void getItemInformation(CacheItemPath path) 
	{
		this.dataProvider.getItemInformation(path);
	}

	/**
	 * 
	 * @param path
	 */
	public void refresh(CacheItemPath path) 
	{
		this.dataProvider.refresh(path);
	}

}