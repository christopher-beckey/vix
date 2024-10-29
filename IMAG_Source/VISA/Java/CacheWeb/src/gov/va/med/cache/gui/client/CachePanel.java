/**
 * 
 */
package gov.va.med.cache.gui.client;

import gov.va.med.cache.gui.shared.AbstractNamedVO;
import gov.va.med.cache.gui.shared.CacheItemPath;
import gov.va.med.cache.gui.shared.CacheVO;

import java.util.logging.Level;
import java.util.logging.Logger;

import com.google.gwt.user.cellview.client.CellTree;
import com.google.gwt.user.cellview.client.HasKeyboardSelectionPolicy.KeyboardSelectionPolicy;
import com.google.gwt.user.cellview.client.TreeNode;
import com.google.gwt.user.client.ui.LayoutPanel;
import com.google.gwt.user.client.ui.ScrollPanel;
import com.google.gwt.view.client.MultiSelectionModel;
import com.google.gwt.view.client.SelectionChangeEvent;
import com.google.gwt.view.client.SingleSelectionModel;

/**
 * @author VHAISWBECKEC
 * 
 */
public class CachePanel extends LayoutPanel
{
	private CacheDataProvider		dataProvider;
	private CacheContentTreeModel	treeModel;
	private ScrollPanel				treeScroll;
	private CellTree				contentTree;
	private CacheVO					rootCache;

	Logger							logger	= Logger.getLogger("CachePanel");

	/**
	 * @param cache
	 * @param cache
	 * @param cacheManager
	 * @param html
	 */
	public CachePanel(CacheDataProvider dataProvider, CacheVO rootCache)
	{
		this.dataProvider = dataProvider;
		this.rootCache = rootCache;

		initialize();
	}

	protected CacheVO getRootCache()
	{
		return rootCache;
	}

	/**
	 * 
	 */
	public void initialize()
	{
		final SingleSelectionModel<AbstractNamedVO> selectionModel = new SingleSelectionModel<AbstractNamedVO>();
		selectionModel.addSelectionChangeHandler(new SelectionChangeEvent.Handler()
		{
			@Override
			public void onSelectionChange(SelectionChangeEvent event)
			{
				MessageDialog.showInformationDialog("Selection Change", "Group selection status has changed");
			}
		});
		/*final MultiSelectionModel<AbstractNamedVO> selectionModel = new MultiSelectionModel<AbstractNamedVO>();
		selectionModel.addSelectionChangeHandler(new SelectionChangeEvent.Handler()
		{
			@Override
			public void onSelectionChange(SelectionChangeEvent event)
			{
				MessageDialog.showInformationDialog("Selection Change", "Group selection status has changed");
			}
		});*/

		// AsyncDataProvider<RegionVO> cacheRegionDataProvider =
		// dataProvider.createDecorator(getRootCache());
		this.treeModel = new CacheContentTreeModel(dataProvider, selectionModel);

		/*
		 * Create the tree using the model. Set the cache as the value of the
		 * root node. The default value will be passed to
		 * CacheContentTreeModel#getNodeInfo();
		 */
		contentTree = new CellTree(this.treeModel, getRootCache());
		contentTree.setSize("400px", "400px");

		contentTree.setKeyboardSelectionPolicy(KeyboardSelectionPolicy.ENABLED);

		// Open the first region by default.
		logger.log(Level.INFO, "Getting root tree node.");
		TreeNode rootNode = contentTree.getRootTreeNode();
		logger.log(Level.INFO, "Root node is '" + rootNode.toString() + "'.");
		int rootChildCount = rootNode.getChildCount();
		if (rootChildCount > 0) rootNode.setChildOpen(0, true);

		// Open or close a child node and fire an event.
		// If open is true and the TreeNode successfully opens, returns the
		// child TreeNode.
		// Delegates to setChildOpen(int, boolean, boolean).
		// TreeNode firstRegion = rootNode.setChildOpen(0, true);
		// logger.log( Level.INFO, firstRegion.toString() );

		// if(firstRegion != null)
		// firstRegion.setChildOpen(0, true);

		logger.log(Level.INFO, "Adding tree to panel.");
		treeScroll = new ScrollPanel(contentTree);
		
		this.add(treeScroll);
	}
}