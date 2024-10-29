package gov.va.med.cache.gui.client;

import gov.va.med.cache.gui.shared.AbstractNamedVO;
import gov.va.med.cache.gui.shared.CACHE_POPULATION_DEPTH;
import gov.va.med.cache.gui.shared.CacheGroupMetadata;
import gov.va.med.cache.gui.shared.CacheInstanceMetadata;
import gov.va.med.cache.gui.shared.CacheItemPath;
import gov.va.med.cache.gui.shared.CacheManagerVO;
import gov.va.med.cache.gui.shared.CacheMetadata;
import gov.va.med.cache.gui.shared.CacheRegionMetadata;
import gov.va.med.cache.gui.shared.CacheVO;
import gov.va.med.cache.gui.shared.GroupVO;
import gov.va.med.cache.gui.shared.InstanceVO;
import gov.va.med.cache.gui.shared.MergeException;
import gov.va.med.cache.gui.shared.NonDuplicateArrayList;
import gov.va.med.cache.gui.shared.RegionVO;
import gov.va.med.cache.gui.shared.RootVO;

import java.util.ArrayList;
import java.util.Collections;
import java.util.HashSet;
import java.util.Iterator;
import java.util.List;
import java.util.Set;
import java.util.TreeSet;
import java.util.logging.Logger;

import com.google.gwt.core.client.GWT;
import com.google.gwt.core.client.Scheduler;
import com.google.gwt.core.client.Scheduler.ScheduledCommand;
import com.google.gwt.user.client.rpc.AsyncCallback;
import com.google.gwt.view.client.AsyncDataProvider;
import com.google.gwt.view.client.HasData;

/**
 * After construction, the initialize() method MUST be called to populate this
 * class with the root CacheManagerVO.
 * 
 * AsyncDataProvider
 * An implementation of AbstractDataProvider that allows the data to be modified.
 * 
 * AbstractDataProvider
 * A base implementation of a data source for HasData implementations.
 * 
 * ProvidesKey
 * Implementors of ProvidesKey provide a key for list items, such that items that are to be treated as 
 * distinct (for example, for editing) have distinct keys.  The key must implement a coherent set of 
 * Object.equals(Object) and Object.hashCode() methods such that if objects A and B are to be treated 
 * as identical, then A.equals(B), B.equals(A), and A.hashCode() == B.hashCode(). If A and B are to be 
 * treated as unequal, then it must be the case that A.equals(B) == false and B.equals(A) == false.
 *
 */
public class CacheDataProvider
{
	private CacheManagerVO						cacheManager;						// the root of the cache hierarchy
	private ImagingCacheManagementServiceAsync	imagingCacheManagementService;		// the RPC proxy
	private final Set<HasData<CacheManagerVO>> 	hasDataClients = new HashSet<HasData<CacheManagerVO>>();
	private RootDataProvider 					rootDataProvider;					// the root of a hierarchy of DataProvider
	private List<CacheDataEventListener>		cacheDataEventListeners = new ArrayList<CacheDataEventListener>();
	
	public enum State{NEW, INITIALIZING, INITIALIZED};
	private State state = State.NEW;
	
	static Logger logger = Logger.getLogger("CacheDataProvider");

	/**
	 * 
	 */
	public CacheDataProvider()
	{
		this.rootDataProvider = new RootDataProvider();
	}
	
	/**
	 * 
	 * @param hasDataClient
	 */
	public CacheDataProvider(HasData<CacheManagerVO> hasDataClient)
	{
		this.hasDataClients.add(hasDataClient);
		this.rootDataProvider = new RootDataProvider();
	}

	/**
	 * initialize() MUST be called and this instance must complete
	 * initialization before trying to access data.
	 * Use addStateChangeListener to be notified when the initialization
	 * is complete.
	 */
	public void initialize()
	{
		setState( State.INITIALIZING );
		this.imagingCacheManagementService = GWT.create(ImagingCacheManagementService.class);

		// this will start the RPC call to get the CacheManager, the root of the hierarchy
		// the GhostHasData is simply a data sink, it has no function
		logger.info("Initiating the CacheManagerVO request.");
		notifyDataEventListenersBegin("Cache Manager", 3000);

		imagingCacheManagementService.getCacheManagerVO( new InitializationCallback() );
		
		logger.info( "Iniitiated the CacheManagerVO request.  CacheManager is updated by server only" );
	}
	
	// ===========================================================================================
	// Property Accessors
	// ===========================================================================================
	/**
	 * 
	 * @return
	 */
	public CacheManagerVO getCacheManager()
	{
		return cacheManager;
	}
	
	/**
	 * 
	 * @param cacheManager
	 */
	private void setCacheManager(CacheManagerVO cacheManager)
	{
		if( this.cacheManager == null )
		{
			this.cacheManager = cacheManager;
			if(State.INITIALIZING == getState())
				setState( State.INITIALIZED );
		}
	}

	// ===========================================================================================
	// State Change Listeners
	// Notification of CacheDataProvider state (NEW, INITIALIZING, INITIALIZED)
	// ===========================================================================================
	private Set<StateChangeListener> stateChangeListeners = new TreeSet<StateChangeListener>();
	public void addStateChangeListener(StateChangeListener listener)
	{
		stateChangeListeners.add(listener);
	}
	public void removeStateChangeListener(StateChangeListener listener)
	{
		stateChangeListeners.remove(listener);
	}
	private void notifyStateChangeListeners(State oldState, State newState)
	{
		for(StateChangeListener listener : stateChangeListeners)
			listener.stateChange(oldState, newState);
	}
	
	public State getState()
	{
		return state;
	}

	void setState(State state)
	{
		State oldState = this.state;
		this.state = state;
		
		notifyStateChangeListeners(oldState, this.state);
	}

	// ===========================================================================================
	// Data Event Listeners
	// ===========================================================================================
	public void addDataEventListener(CacheDataEventListener listener)
	{
		this.cacheDataEventListeners.add(listener);
	}
	public void removeDataEventListener(CacheDataEventListener listener)
	{
		this.cacheDataEventListeners.remove(listener);
	}
	private void notifyDataEventListeners(CacheDataEvent event)
	{
		for(CacheDataEventListener listener : this.cacheDataEventListeners)
			listener.cacheDataEvent(event);
	}
	private void notifyDataEventListenersBegin(String message, int expectedDuration)
	{
		notifyDataEventListeners( CacheDataEvent.createStartEvent(expectedDuration) );
	}
	private void notifyDataEventListenersSuccess(CacheItemPath cacheItemPath)
	{
		notifyDataEventListeners( CacheDataEvent.createSuccessEvent(cacheItemPath) );
	}
	private void notifyDataEventListenersFailure(String message)
	{
		notifyDataEventListeners( CacheDataEvent.createFailureEvent(message) );
	}
	private void notifyDataEventListenersFailure(CacheItemPath cacheItemPath)
	{
		notifyDataEventListeners( CacheDataEvent.createFailureEvent(cacheItemPath) );
	}
	
	/**
	 * Refresh the local model from the given path downward.
	 * 
	 * @param path
	 */
	public void refresh(CacheItemPath path) 
	{
		HierarchicalAsyncDataProvider<?, ?> dataProvider = findCachedDataProvider(path);
		logger.info(".refresh(" + path.toString() + "), data provider " + (dataProvider == null ? "was not" : "was") + " found.");
		if(dataProvider != null)
		{
			dataProvider.clear();
			logger.info(".refresh(" + path.toString() + "), cleared.");
			dataProvider.dataUpdated();
			logger.info(".refresh(" + path.toString() + "), dataUpdated.");
		}
	}
	

	/**
	 * 'this' data provider is the real data provider, the tree shows multiple types of data; caches, regions,
	 * group, instances.  The decorators give a view of the data with an established context of one of those
	 * types.
	 * 
	 * @param <C> - the Context type (parent)
	 * @param <S> - the Subject type (child)
	 * @param context
	 * @return
	 */
	@SuppressWarnings("unchecked")
	public <C extends AbstractNamedVO, S extends AbstractNamedVO> HierarchicalAsyncDataProvider<C, S> getOrCreateDecorator(C context)
	{
		logger.info("getOrCreateDecorator(" + (context == null ? "null" : context.toString()) + ")");
		
		// the RootDataProvider is an AsyncDataProvider<CacheManagerVO>
		if(context == null)
		{
			// there must be only one
			return (HierarchicalAsyncDataProvider<C, S>)(this.rootDataProvider);
		}
		
		// the CacheManagerDataProvider is an AsyncDataProvider<CacheVO>
		else if(context instanceof CacheManagerVO)
		{
			CacheManagerDataProvider dp = (CacheManagerDataProvider)findCachedDataProvider(context);
			if(dp == null)
			{
				dp = new CacheManagerDataProvider((CacheManagerVO)context);
				HierarchicalAsyncDataProvider<?, ?> parent = getOrCreateDecorator(context.getParent());	// getParent() should return null
				parent.addChildDataProvider(dp);
			}
			
			return (HierarchicalAsyncDataProvider<C, S>)dp;
		}
		
		// the CacheVODataProvider is an AsyncDataProvider<RegionVO>
		else if(context instanceof CacheVO)
		{
			CacheVODataProvider dp = (CacheVODataProvider)findCachedDataProvider(context);
			if(dp == null)
			{
				dp = new CacheVODataProvider( (CacheVO)context, this );
				HierarchicalAsyncDataProvider<?, ?> parent = getOrCreateDecorator(context.getParent());	// getParent() should return null
				parent.addChildDataProvider(dp);
			}
			return (HierarchicalAsyncDataProvider<C, S>)dp;
		}
		
		// the RegionDataProvider is an AsyncDataProvider<GroupVO>
		else if(context instanceof RegionVO)
		{
			RegionVODataProvider dp = (RegionVODataProvider)findCachedDataProvider(context);
			if(dp == null)
			{
				dp = new RegionVODataProvider( (RegionVO)context, this );
				HierarchicalAsyncDataProvider<?, ?> parent = getOrCreateDecorator(context.getParent());	// getParent() should return null
				parent.addChildDataProvider(dp);
			}
			return (HierarchicalAsyncDataProvider<C, S>)dp;
		}
		
		// the GroupDataProvider is an AsyncDataProvider<AbstractNamedVO> - its children
		// are both GroupVO and InstanceVO
		else if(context instanceof GroupVO)
		{
			GroupVODataProvider dp = (GroupVODataProvider)findCachedDataProvider(context);
			if(dp == null)
			{
				dp = new GroupVODataProvider((GroupVO)context, this);
				HierarchicalAsyncDataProvider<?, ?> parent = getOrCreateDecorator(context.getParent());	// getParent() should return null
				parent.addChildDataProvider(dp);
			}
			return (HierarchicalAsyncDataProvider<C, S>)dp;
		}
		
		return null;
	}
	
	/**
	 * 
	 * @param <C> - the context type (parent)
	 * @param <S> - the subject type (child)
	 */
	public abstract static class HierarchicalAsyncDataProvider<C extends AbstractNamedVO, S extends AbstractNamedVO>
	extends AsyncDataProvider<S>
	implements Iterable<HierarchicalAsyncDataProvider<?, ?>>
	{
		NonDuplicateArrayList<HierarchicalAsyncDataProvider<?, ?>> childDataProviders = 
			new NonDuplicateArrayList<HierarchicalAsyncDataProvider<?, ?>>();
		
		protected boolean addChildDataProvider(HierarchicalAsyncDataProvider<?, ?> child){return childDataProviders.add(child);}
		protected void removeChildDataProvider(HierarchicalAsyncDataProvider<?, ?> child){childDataProviders.remove(child);}
		protected void clearChildDataProviders(){childDataProviders.clear();}
		protected abstract C getValue();	// return the context
		
		public void clear()
		{
			// our own iterator returns an iterator over an unmodifiable collection
			// remove the members from the "real" collection as we iterate over that unmodifiable collection
			for( HierarchicalAsyncDataProvider<?, ?> childDataProvider : this)
				childDataProviders.remove(childDataProvider);
		}
		
		@Override
		public Iterator<HierarchicalAsyncDataProvider<?, ?>> iterator()
		{
			return (Collections.unmodifiableList(childDataProviders)).iterator();
		}
		
		/**
		 * 
		 */
		void childDataUpdated()
		{
			logger.info(this.toString() + ".childDataUpdated() => " + getValue().toString());
			for( HasData<S> display : getDataDisplays() )
			{
				logger.info(this.toString() + ".childDataUpdated() updating " + display.toString());
				onRangeChanged(display);
			}
		}
		
		void dataUpdated()
		{
			logger.info(this.toString() + ".dataUpdated() => " + getValue().toString());
			for( HasData<S> display : getDataDisplays() )
			{
				logger.info(this.toString() + ".dataUpdated() updating " + display.toString());
				onRangeChanged(display);
			}
		}
		@Override
		protected void onRangeChanged(HasData<S> display) {}
		
		@Override
		public String toString() 
		{
			return "HierarchicalAsyncDataProvider [? children]";
		}
		
	}
	
	/**
	 * 
	 * @param path
	 * @return
	 */
	private HierarchicalAsyncDataProvider<?, ?> findCachedDataProvider(CacheItemPath path)
	{
		logger.info("ENTERING findCachedDataProvider(" 
			+ (path == null ? "(CacheItemPath)null" : path.toString()) 
			+ ")");
		
		HierarchicalAsyncDataProvider<?, ?> result = null;
		
		Iterator<HierarchicalAsyncDataProvider<?, ?>> cacheManagerLocator = rootDataProvider.iterator();
		if( cacheManagerLocator.hasNext() )		// the CacheManagerVO data Provider will be the first and only child
			result = findCachedDataProvider(cacheManagerLocator.next(), path, CACHE_POPULATION_DEPTH.CACHE_MANAGER);
		
		logger.info("EXITING findCachedDataProvider(" 
			+ (path == null ? "(CacheItemPath)null" : path.toString()) 
			+ "), returning " 
			+ (result == null ? "(HierarchicalAsyncDataProvider)null" : result.toString()) 
		);
		
		return result;
	}
	
	/**
	 * 
	 * @param dp
	 * @param path
	 * @return
	 */
	private HierarchicalAsyncDataProvider<?, ?> findCachedDataProvider(
		HierarchicalAsyncDataProvider<?, ?> dp, 
		CacheItemPath path,
		CACHE_POPULATION_DEPTH currentDepth)
	{
		logger.info("ENTERING findCachedDataProvider( "
			+ (dp == null ? "(HierarchicalAsyncDataProvider)null" : dp.toString()) + ", " 
			+ (path == null ? "(CacheItemPath)null" : path.toString()) + ", " 
			+ (currentDepth == null ? "(CACHE_POPULATION_DEPTH)null" : currentDepth.toString()) 
			+ ")");
		
		HierarchicalAsyncDataProvider<?, ?> result = null;
		
		if(path == null || currentDepth == null)
			result = dp;

		if(result == null)
		{
			String currentName = path.getNameAt(currentDepth);
			AbstractNamedVO dataProviderValue = dp.getValue();
			
			if( currentName.equals(dataProviderValue.getName()) && path.nextDepth(currentDepth) == null )
				result = dp;
		}
		
		CACHE_POPULATION_DEPTH nextDepth = path.nextDepth(currentDepth);
		
		for(Iterator<HierarchicalAsyncDataProvider<?, ?>> iter = dp.childDataProviders.iterator(); 
			iter != null && result == null && iter.hasNext(); )
		{
			HierarchicalAsyncDataProvider<?, ?> childDp = iter.next();
			result = findCachedDataProvider(childDp, path, nextDepth);
		}
		
		logger.info("EXITING findCachedDataProvider( "
			+ (dp == null ? "null" : dp.toString()) + ", " 
			+ (path == null ? "null" : path.toString()) + ", " 
			+ (currentDepth == null ? "null" : currentDepth.toString()) 
			+ ") result = "
			+ (result == null) ? "null" : result.toString()
		);
		return result;
	}
	
	/**
	 * 
	 * @param context
	 * @return
	 */
	private HierarchicalAsyncDataProvider<?, ?> findCachedDataProvider(AbstractNamedVO context)
	{
		logger.info("ENTERING findCacheDataProvider(" + (context == null ? "(AbstractNamedVO)null" : context.toString()) + ")");
		HierarchicalAsyncDataProvider<?, ?> result = findCachedDataProvider(rootDataProvider, context);
		logger.info("EXITING findCacheDataProvider(" + (context == null ? "(AbstractNamedVO)null" : context.toString()) + ")");
		
		return result;
	}
	
	/**
	 * A recursive function to find an existing DataProvider 
	 * 
	 * @param dp
	 * @param context
	 * @return
	 */
	private HierarchicalAsyncDataProvider<?, ?> findCachedDataProvider(HierarchicalAsyncDataProvider<?, ?> dp, AbstractNamedVO context)
	{
		logger.info("ENTERING findCachedDataProvider(" 
			+ (dp == null ? "(HierarchicalAsyncDataProvider)null" : dp.toString()) 
			+ "," 
			+ (context == null ? "(AbstractNamedVO)null" : context.toString()) 
			+ ")"
		);
		
		HierarchicalAsyncDataProvider<?, ?> result = null;
		
		if(context == null || context.equals(dp.getValue()) )
			result = dp;
		
		for(Iterator<HierarchicalAsyncDataProvider<?, ?>> iter = dp.childDataProviders.iterator(); 
			result == null && iter.hasNext(); )
		{
			HierarchicalAsyncDataProvider<?, ?> childDp = iter.next();
			result = findCachedDataProvider(childDp, context);
		}
		
		logger.info("EXITING findCachedDataProvider(" 
			+ (dp == null ? "null" : dp.toString()) 
			+ "," 
			+ (context == null ? "null" : context.toString()) 
			+ ")"
			);
		return result;
	}
	
	/**
	 * 
	 */
	class RootDataProvider 
	extends HierarchicalAsyncDataProvider<RootVO, CacheManagerVO>
	{
		@Override
		protected void onRangeChanged(HasData<CacheManagerVO> display)
		{
			display.setRowCount(1);
			display.setRowData(0, Collections.singletonList(cacheManager));
		}

		@Override
		protected RootVO getValue()
		{
			return null;
		}
	}

	/**
	 * 
	 */
	class CacheManagerDataProvider 
	extends HierarchicalAsyncDataProvider<CacheManagerVO, CacheVO>
	{
		private CacheManagerVO context;
		public CacheManagerDataProvider(CacheManagerVO context)
		{
			this.context = context;
		}

		@Override
		protected CacheManagerVO getValue()
		{
			return context;
		}

		@Override
		protected void onRangeChanged(HasData<CacheVO> display)
		{
			display.setRowCount(context.getCacheCount());
			display.setRowData(0, context.getCachesAsList());
		}
	}
	
	// =====================================================================================================
	// DataProviderDecorator provides a context and type specific view into the DataProvider's model
	// =====================================================================================================
	
	/**
	 * @param C - the type of the context, that is the parent that needs children populated
	 * @param S - the subject type is the type of the children
	 * 
	 * e.g. if an instance of CacheVO is the Context then RegionVO is the subject type  
	 */
	public abstract class AbstractCacheItemDataProvider<C extends AbstractNamedVO, S extends AbstractNamedVO>
	extends HierarchicalAsyncDataProvider<C, S>
	{
		private final C context;
		private final CacheDataProvider cacheDataProvider;
		private final CACHE_POPULATION_DEPTH currentDepth;
		
		AbstractCacheItemDataProvider(C value, CacheDataProvider cacheDataProvider, CACHE_POPULATION_DEPTH currentDepth)
		{
			logger.info("ctor AbstractDataProviderDecorator(" + value.toString() + ")");
			Utilities.assertIsTrue(value != null, "AbstractDataProviderDecorator.value is null and must not be");
			Utilities.assertIsTrue(value.getPath() != null, "AbstractDataProviderDecorator.value.getPath is null and must not be");
			Utilities.assertIsTrue(cacheDataProvider != null, "AbstractDataProviderDecorator.cacheDataProvider is null and must not be");
			Utilities.assertIsTrue(currentDepth != null, "AbstractDataProviderDecorator.currentDepth is null and must not be");
			
			this.context = value;
			this.cacheDataProvider = cacheDataProvider;
			this.currentDepth = currentDepth;
		}

		@Override
		protected C getValue(){return context;}
		
		protected CacheDataProvider getCacheDataProvider(){return cacheDataProvider;}
		protected CACHE_POPULATION_DEPTH getCurrentDepth(){return currentDepth;}
		
		@Override
		protected void onRangeChanged(HasData<S> display)
		{
			logger.info("ENTERING AbstractCacheItemDataProvider.onRangeChanged(" 
				+ (display == null ? "null" : display.toString()) 
				+ ")");

			CacheItemCallback callback = 
				new CacheItemCallback(getValue(), (HasData<AbstractNamedVO>)display, getValue().getPath());
			logger.info("AbstractCacheItemDataProvider.onRangeChanged, children " 
				+ (getValue().isChildrenPopulated() ? "ARE" : "ARE NOT") 
				+ " populated.");
			if(! getValue().isChildrenPopulated())
			{
				notifyDataEventListenersBegin("Cache Data", 3000);
				imagingCacheManagementService.getCacheItems(getValue().getPath(), getCurrentDepth(), null, callback);
			}
			else
				// skip the data retrieval, it is already available. just update the displays
				callback.updateDisplay();
			
			logger.info("EXITING AbstractCacheItemDataProvider.onRangeChanged(" 
				+ (display == null ? "null" : display.toString()) 
				+ ")");
	}
	};

	/**
	 * 
	 */
	public class CacheVODataProvider 
	extends AbstractCacheItemDataProvider<CacheVO, RegionVO>
	{
		CacheVODataProvider(CacheVO context, CacheDataProvider cacheDataProvider)
		{super(context, cacheDataProvider, CACHE_POPULATION_DEPTH.REGION);}

	}
	
	/**
	 * 
	 */
	public class RegionVODataProvider 
	extends AbstractCacheItemDataProvider<RegionVO, GroupVO>
	{
		RegionVODataProvider(RegionVO context, CacheDataProvider cacheDataProvider)
		{super(context, cacheDataProvider, CACHE_POPULATION_DEPTH.GROUP0);}
	}
	
	/**
	 * 
	 */
	public class GroupVODataProvider 
	extends AbstractCacheItemDataProvider<GroupVO, AbstractNamedVO>
	{
		GroupVODataProvider(GroupVO context, CacheDataProvider cacheDataProvider)
		{super(context, cacheDataProvider, CACHE_POPULATION_DEPTH.INSTANCE);}
	}
	
	// ==========================================================================================
	// Callback handlers for the cache manager and the other items in the cache hierarchy.
	// Other than the cache manager, the callback handler is a single generic callback handler
	// that works on a hierarchy of cache item instances returned form the server, always starting
	// with a CacheVO.  The returned value object graph is merged into the client data model.
	// ==========================================================================================
	
	/**
	 * Set the parent references in a hierarchy of results, starting with a CacheManagerVO.
	 * 
	 * @param cacheManagerVO
	 */
	private static void updateParentReferences(CacheManagerVO cacheManagerVO)
	{
		updateParentReferences(null, cacheManagerVO);
	}
	
	/**
	 * Recursively set the parent references.
	 * 
	 * @param parent
	 * @param result
	 */
	private static void updateParentReferences(AbstractNamedVO parent, AbstractNamedVO result)
	{
		if(result != null)
		{
			result.setParent(parent);
			if(result.getChildren() != null)
				for( AbstractNamedVO child : result.getChildren() )
					updateParentReferences(result, child);
		}
	}
	
	/**
	 * An AsyncCallback handler that populates the root of our hierarchy.
	 */
	class InitializationCallback 
	implements AsyncCallback<CacheManagerVO>
	{
		public InitializationCallback(){}

		@Override
		public void onFailure(Throwable caught)
		{
			notifyDataEventListenersFailure(new CacheItemPath());
			MessageDialog.showErrorDialog("Exception", caught.getMessage());
		}

		@Override
		public void onSuccess(CacheManagerVO result)
		{
			logger.info("Successfully retrieved CacheManagerVO, updating child parents.");
			CacheDataProvider.updateParentReferences(result);		// fix the parent references in the returned results
			setCacheManager(result);
			notifyDataEventListenersSuccess(result.getPath());
		}
	}

	/**
	 * The asynchronous callback for all cache items except for the cache manager, 
	 * which is populated once with InitializationCallback
	 *
	 */
	class CacheItemCallback
	implements AsyncCallback<CacheVO>
	{
		private final AbstractNamedVO 				context;
		private final HasData<AbstractNamedVO>		display;
		private final CacheItemPath					initiatingPath;
		
		protected CacheItemCallback(AbstractNamedVO context, HasData<AbstractNamedVO> display, CacheItemPath initiatingPath)
		{
			Utilities.assertIsTrue(context != null, "CacheItemCallback.context is null and must not be");
			Utilities.assertIsTrue(display != null, "CacheItemCallback.display is null and must not be");
			Utilities.assertIsTrue(initiatingPath != null, "CacheItemCallback.initiatingPath is null and must not be");
			
			this.context = context; 
			this.display = display;
			this.initiatingPath = initiatingPath;
		}
		
		protected AbstractNamedVO getContext(){return this.context;}
		protected HasData<AbstractNamedVO> getDisplay(){return this.display;}
		protected CacheItemPath getInitiatingPath(){return initiatingPath;}

		/**
		 * cacheVO is a populated CacheVO instance, with the requested
		 * child items included.  Merge it into the "master" data model and
		 * then notify the HasData control of the new rows. 
		 */
		@Override
		public void onSuccess(CacheVO result)
		{
			String strTemp = (result == null) ? "NULL" : result;
			/*
				Gary Pham (oitlonphamg)
				P314
				Validate string for nonprintable characters based on Fortify software recommendation.
			*/
			if (strTemp.matches("[A-Za-z0-9 _.,!\"'/$;:%]+"))
			{
				logger.info("ENTERING CacheItemCallback.onSuccess(" + strTemp + ")");
			
				// Create a "dummy" CacheManagerVO because a CacheManagerVO is the root of
				// the data model hierarchy.  This makes merging simply a matter of calling
				// the CacheManagerVO merge() method, which recursively calls merge() methods
				// down through the hierarchy.
				CacheManagerVO cacheManagerVO = new CacheManagerVO();
				cacheManagerVO.add(result);
				updateParentReferences(cacheManagerVO);
				try
				{
					getCacheManager().merge(cacheManagerVO);
					logger.info("Merged '" + getContext().getName() + "' into cache.");
					
					updateDisplay();
				}
				catch (MergeException e)
				{
					e.printStackTrace();
					logger.severe("Error merging '" + getContext().getName() + "' into cache.");
				}
				notifyDataEventListenersSuccess(result.getPath());
				logger.info("EXITING CacheItemCallback.onSuccess(" + strTemp + ")");
			}
		}
		
		public void updateDisplay()
		{
			// Determine what level of the hierarchy the HasData instance is interested
			// in and notify it of the changes.
			// This should be the end of the original CacheItemPath that was used to
			// kick off this retrieval from the server.
			AbstractNamedVO contextCacheItem = followPath( getInitiatingPath() );
			int childCount = contextCacheItem.getChildCount();
			
			logger.info(
				"updateDisplay (" 
				+ getDisplay().toString() 
				+ "), starting from " 
				+ getInitiatingPath().toString()
				+ "=>"
				+ contextCacheItem.getName() 
				+ " with " 
				+ childCount 
				+ " rows.");
			
			getDisplay().setRowCount(childCount);
			getDisplay().setRowData(0, contextCacheItem.getChildrenAsList());
		}

		@Override
		public void onFailure(Throwable caught)
		{
			notifyDataEventListenersFailure(context.getPath());
			caught.printStackTrace();
			MessageDialog.showErrorDialog("Error getting cache item", caught.getMessage());
		}
	}
	
	/**
	 * 
	 * @param cacheName
	 */
	public void clearCache(String cacheName) 
	{
		logger.info("ENTERING clearCache(" + (cacheName == null ? "NULL" : cacheName) + ")");
		
		if(cacheName != null)
		{
			CacheItemPath cachePath = new CacheItemPath(cacheName);
			
			this.imagingCacheManagementService.clearCache(cachePath, new ClearCacheCallback() );
		}
		else
			MessageDialog.showErrorDialog("Internal error", "clearCache() called with null cache name.");
			
		logger.info("EXITING clearCache(" + (cacheName == null ? "NULL" : cacheName) + ")");
	}

	/**
	 * 
	 * @param path
	 */
	public void deleteGroup(CacheItemPath path)
	{
		logger.info("ENTERING deleteGroup(" + (path == null ? "NULL" : path.toString()) + ")");
		if(path != null)
			this.imagingCacheManagementService.deleteGroup( path, new DeleteGroupCallback() );
		else
			MessageDialog.showErrorDialog("Internal error", "deleteGroup() called with null path.");
		logger.info("EXITING deleteGroup(" + (path == null ? "NULL" : path.toString()) + ")");
	}

	/**
	 * 
	 * @param path
	 */
	public void deleteInstance(CacheItemPath path)
	{
		logger.info("ENTERING deleteInstance(" + (path == null ? "NULL" : path.toString()) + ")");
		if(path != null)
			this.imagingCacheManagementService.deleteInstance( path, new DeleteInstanceCallback() );
		else
			MessageDialog.showErrorDialog("Internal error", "deleteInstance() called with null path.");
		
		logger.info("EXITING deleteInstance(" + (path == null ? "NULL" : path.toString()) + ")");
	}

	/**
	 * 
	 * @param path
	 */
	public void getItemInformation(CacheItemPath path) 
	{
		logger.info("ENTERING getItemInformation("
			+ (path == null ? "<null>" : path.toString())
			+ ")");
		
		if(path.getEndpointDepth() == CACHE_POPULATION_DEPTH.CACHE)
			this.imagingCacheManagementService.getCacheMetadata( path, new GetCacheMetadataCallback(path) );
		if(path.getEndpointDepth() == CACHE_POPULATION_DEPTH.REGION)
			this.imagingCacheManagementService.getCacheRegionMetadata(path, new GetRegionMetadataCallback(path) );
		if(path.getEndpointDepth() == CACHE_POPULATION_DEPTH.GROUP0
			|| path.getEndpointDepth() == CACHE_POPULATION_DEPTH.GROUP1
			|| path.getEndpointDepth() == CACHE_POPULATION_DEPTH.GROUP2
			|| path.getEndpointDepth() == CACHE_POPULATION_DEPTH.GROUP3
			|| path.getEndpointDepth() == CACHE_POPULATION_DEPTH.GROUP4
			|| path.getEndpointDepth() == CACHE_POPULATION_DEPTH.GROUP5
			|| path.getEndpointDepth() == CACHE_POPULATION_DEPTH.GROUP6
			|| path.getEndpointDepth() == CACHE_POPULATION_DEPTH.GROUP7
			|| path.getEndpointDepth() == CACHE_POPULATION_DEPTH.GROUP8
			|| path.getEndpointDepth() == CACHE_POPULATION_DEPTH.GROUP9
		)
			this.imagingCacheManagementService.getCacheGroupMetadata( path, new GetGroupMetadataCallback(path) );
		if(path.getEndpointDepth() == CACHE_POPULATION_DEPTH.INSTANCE)
			this.imagingCacheManagementService.getCacheInstanceMetadata( path, new GetInstanceMetadataCallback(path) );
		
		logger.info("EXITING getItemInformation("
			+ (path == null ? "<null>" : path.toString())
			+ ")");
	}
	
	/**
	 * Called asynchronously when the server responds that it has deleted an item.
	 * The path is the item that was deleted.  Force the "listening" widgets to redraw
	 * as needed.
	 * 
	 * @param path
	 */
	void updateDisplayFromParent(CacheItemPath path, boolean asynchronous)
	{
		String strTemp = (path == null) ? "<null>" : path.toString();
		/*
			Gary Pham (oitlonphamg)
			P314
			Validate string for nonprintable characters based on Fortify software recommendation.
		*/
		if (strTemp.matches("[A-Za-z0-9 _.,!\"'/$;:%]+"))
		{
			logger.info("ENTERING updateDisplayFromParent(" 
				+ strTemp
				+ ", "
				+ Boolean.toString(asynchronous)
				+ ")");
			
			if(path != null)
			{
				CacheItemPath parentPath = path.createParentPath();
				
				if(parentPath != null)
					if(asynchronous)
						synchronouslyUpdateDisplay(parentPath);
					else
						asynchronouslyUpdateDisplay(parentPath);
				else
					logger.severe("Item '" + strTemp + "' deleted but parent path is NULL, unable to update view.");
			}
			else
				logger.severe("updateDisplayFromParent(NULL), unable to find the parent path to update view.");
		}
	}
	
	class UpdateDisplayCommand
	implements ScheduledCommand
	{
		private final CacheItemPath path;
		
		UpdateDisplayCommand(CacheItemPath path){this.path = path;}
		
		@Override
		public void execute() 
		{
			synchronouslyUpdateDisplay(path);
		}
	}
	
	void asynchronouslyUpdateDisplay(CacheItemPath parentPath)
	{
		String strTemp = (parentPath == null) ? "<null>" : parentPath.toString();
		/*
			Gary Pham (oitlonphamg)
			P314
			Validate string for nonprintable characters based on Fortify software recommendation.
		*/
		if (strTemp.matches("[A-Za-z0-9 _.,!\"'/$;:%]+"))
		{
			logger.info("ENTERING asynchronouslyUpdateDisplay(" 
				+ strTemp
				+ ")");
			UpdateDisplayCommand command = new UpdateDisplayCommand(parentPath);
			Scheduler.get().scheduleDeferred(command);
			logger.info("EXITING asynchronouslyUpdateDisplay(" 
				+ strTemp
				+ ")");
		}
	}
	
	void synchronouslyUpdateDisplay(CacheItemPath parentPath)
	{
		String strTemp = (parentPath == null) ? "<null>" : parentPath.toString();
		/*
			Gary Pham (oitlonphamg)
			P314
			Validate string for nonprintable characters based on Fortify software recommendation.
		*/
		if (strTemp.matches("[A-Za-z0-9 _.,!\"'/$;:%]+"))
		{
			logger.info("ENTERING synchronouslyUpdateDisplay(" 
				+ strTemp
				+ ")");
			HierarchicalAsyncDataProvider<?, ?> dataProvider = findCachedDataProvider(parentPath);
			if(dataProvider != null)
				dataProvider.childDataUpdated();
			else
				logger.severe("Item found but unable to update '" + strTemp + "' view, unable to find the parent data provider.");
			logger.info("EXITING synchronouslyUpdateDisplay(" 
				+ strTemp
				+ ")");
		}
	}
	
	
	
	/**
	 * 
	 */
	class ClearCacheCallback
	implements AsyncCallback<CacheItemPath>
	{
		@Override
		public void onSuccess(CacheItemPath result)
		{
			String strTemp = (result == null) ? "NULL" : result;
			/*
				Gary Pham (oitlonphamg)
				P314
				Validate string for nonprintable characters based on Fortify software recommendation.
			*/
			if (strTemp.matches("[A-Za-z0-9 _.,!\"'/$;:%]+"))
			{
				logger.info("ENTERING ClearCacheCallback.onSuccess(" + strTemp + ")");
				
				// this keeps the local copy in synch with the real cache on the server
				getCacheManager().removeItem(result);
				updateDisplayFromParent(result, true);
				
				MessageDialog.showInformationDialog(
					"Cache '", 
					"'" + result.getLastGroupName() + "' has been queued for deletion.  The cache may take a minute to actually clear the cache."
				);
				logger.info("EXITING ClearCacheCallback.onSuccess(" + strTemp + ")");
			}
		}
		
		@Override
		public void onFailure(Throwable caught)
		{
			MessageDialog.showErrorDialog("Deleted", "Unable to clear cache - " + caught.getMessage());
		}
	}
	
	/**
	 * 
	 */
	class DeleteGroupCallback
	implements AsyncCallback<CacheItemPath>
	{
		public DeleteGroupCallback()
		{
			super();
		}

		@Override
		public void onSuccess(CacheItemPath result)
		{
			String strTemp = (result == null) ? "NULL" : result;
			/*
				Gary Pham (oitlonphamg)
				P314
				Validate string for nonprintable characters based on Fortify software recommendation.
			*/
			if (strTemp.matches("[A-Za-z0-9 _.,!\"'/$;:%]+"))
			{
				logger.info("ENTERING DeleteGroupCallback.onSuccess(" + strTemp + ")");
				
				// this keeps the local copy in synch with the real cache on the server
				getCacheManager().removeItem(result);
				updateDisplayFromParent(result, true);
				
				MessageDialog.showInformationDialog(
					"Group Deleted", 
					"'" + result.getLastGroupName() + "' has been queued for deletion.  The cache may take a minute to actually delete the group."
				);
				logger.info("EXITING DeleteGroupCallback.onSuccess(" + strTemp + ")");
			}
		}
		
		@Override
		public void onFailure(Throwable caught)
		{
			MessageDialog.showErrorDialog("Deleted", "Unable to delete - " + caught.getMessage());
		}
	}

	/**
	 * 
	 */
	class DeleteInstanceCallback
	implements AsyncCallback<CacheItemPath>
	{
		public DeleteInstanceCallback()
		{
			super();
		}

		@Override
		public void onSuccess(CacheItemPath result)
		{
			String strTemp = (result == null) ? "NULL" : result;
			/*
				Gary Pham (oitlonphamg)
				P314
				Validate string for nonprintable characters based on Fortify software recommendation.
			*/
			if (strTemp.matches("[A-Za-z0-9 _.,!\"'/$;:%]+"))
			{
				logger.info("ENTERING DeleteInstanceCallback.onSuccess(" + strTemp + ")");
				
				// this keeps the local copy in synch with the real cache on the server
				getCacheManager().removeItem(result);
				updateDisplayFromParent(result, true);
				
				MessageDialog.showInformationDialog(
					"Instance Deleted", 
					"'" + result.getInstanceName() + "' has been queued for deletion.  The cache may take a minute to actually delete the instance. ");
				logger.info("EXITING DeleteInstanceCallback.onSuccess(" + strTemp + ")");
			}
		}
		
		@Override
		public void onFailure(Throwable caught)
		{
			MessageDialog.showErrorDialog("Deleted", "Unable to delete - " + caught.getMessage());
		}
	}
	
	abstract class GetMetadataCallback<R> 
	implements AsyncCallback<R> 
	{
		private CacheItemPath path;
		
		public GetMetadataCallback(CacheItemPath path) 
		{
			super();
			this.path = path;
		}
		
		public CacheItemPath getPath() {return path;}

		@Override
		public abstract void onSuccess(R result);
		
		@Override
		public void onFailure(Throwable caught) {
			MessageDialog.showErrorDialog("Information", "Unable to get item information - " + caught.getMessage());
		}
	}
	
	class GetCacheMetadataCallback 
	extends GetMetadataCallback<CacheMetadata>
	{
		public GetCacheMetadataCallback(CacheItemPath path) {super(path);}

		@Override
		public void onSuccess(CacheMetadata result) 
		{
			AbstractNamedVO cacheItem = followPath(getPath());
			if(cacheItem instanceof CacheVO)
			{
				((CacheVO)cacheItem).setMetadata(result);
				updateDisplayFromParent(getPath(), false);
			}
		}
	}
	
	class GetRegionMetadataCallback 
	extends GetMetadataCallback<CacheRegionMetadata>
	{
		public GetRegionMetadataCallback(CacheItemPath path) {super(path);}

		@Override
		public void onSuccess(CacheRegionMetadata result) 
		{
			logger.info("ENTERING GetRegionMetadataCallback.onSuccess("
				+ result == null ? "<null>" : result.toString()
				+ ")");
			AbstractNamedVO cacheItem = followPath(getPath());
			if(cacheItem instanceof RegionVO)
			{
				((RegionVO)cacheItem).setMetadata(result);
				updateDisplayFromParent(getPath(), false);
			}
			logger.info("EXITING onSuccess("
				+ result == null ? "<null>" : result.toString()
				+ ")");
		}
	}
	
	class GetGroupMetadataCallback 
	extends GetMetadataCallback<CacheGroupMetadata>
	{
		public GetGroupMetadataCallback(CacheItemPath path) {super(path);}

		@Override
		public void onSuccess(CacheGroupMetadata result) {
			AbstractNamedVO cacheItem = followPath(getPath());
			if(cacheItem instanceof GroupVO)
			{
				((GroupVO)cacheItem).setMetadata(result);
				updateDisplayFromParent(getPath(), false);
			}
		}
	}
	
	class GetInstanceMetadataCallback 
	extends GetMetadataCallback<CacheInstanceMetadata>
	{
		public GetInstanceMetadataCallback(CacheItemPath path) {super(path);}

		@Override
		public void onSuccess(CacheInstanceMetadata result) {
			AbstractNamedVO cacheItem = followPath(getPath());
			if(cacheItem instanceof InstanceVO)
			{
				((InstanceVO)cacheItem).setMetadata(result);
				updateDisplayFromParent(getPath(), false);
			}
		}
	}
	
	/**
	 * 
	 * @param initiatingPath
	 * @return
	 */
	public AbstractNamedVO followPath(CacheItemPath initiatingPath)
	{
		return followPath(this.getCacheManager(), initiatingPath, CACHE_POPULATION_DEPTH.CACHE_MANAGER);
	}
	
	public static AbstractNamedVO followPath(CacheVO cache, CacheItemPath initiatingPath)
	{
		return followPath(cache, initiatingPath, CACHE_POPULATION_DEPTH.CACHE);
	}

	/**
	 * Recursively follow the path down through the data model,
	 * and return the item at the end of the path.
	 * 
	 * @param context - the current item in the cache
	 * @param initiatingPath - the path that we are following
	 * @param currentDepth - the current depth in the path of the children (the context depth plus one)
	 * @return
	 */
	private static AbstractNamedVO followPath(AbstractNamedVO context, CacheItemPath initiatingPath, CACHE_POPULATION_DEPTH currentDepth)
	{
		CACHE_POPULATION_DEPTH childDepth = initiatingPath.nextDepth(currentDepth);
		String childName = childDepth == null ? null : initiatingPath.getNameAt(childDepth);
		if(childName == null)		// we're at the end of the path, the context is it
			return context;
		AbstractNamedVO child = context.childWithName(childName);
		
		// the initiatingPath has to determine the next level of the path because there are one to n
		// groups between the region and the instance.
		return child != null ? followPath( child, initiatingPath, childDepth ) : null;
	}
	
	// ============================================================================================
	//
	public static interface StateChangeListener
	{
		public abstract void stateChange(State oldState, State newState);
	}
}