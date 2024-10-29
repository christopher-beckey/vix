package gov.va.med.cache.gui.client;

import gov.va.med.cache.gui.client.CacheDataEvent.EVENT_TYPE;
import gov.va.med.cache.gui.client.widgets.ProgressBar;

import java.util.logging.Level;
import java.util.logging.Logger;

import com.google.gwt.core.client.EntryPoint;
import com.google.gwt.user.client.Timer;
import com.google.gwt.user.client.Window;
import com.google.gwt.user.client.ui.DecoratedPopupPanel;
import com.google.gwt.user.client.ui.RootPanel;

/**
 * Entry point classes define <code>onModuleLoad()</code>.
 */
public class ImagingCacheWeb 
implements EntryPoint, CacheDataProvider.StateChangeListener
{
	/**
	 * Create a remote service proxy to talk to the server-side service.
	 */
	ImagingCacheManagementServiceAsync imagingCacheManagementService;
	public final String CONTENT_ROOT_ID = "content-root";
	public final String MENU_BAR_ID = "menu-bar";
	
	// the view
	CacheStackPanel cacheStackPanel;
	DataProgressPopup dataProgressPopup;
	
	// the model
	CacheDataProvider cacheDataProvider;
	
	Logger logger = Logger.getLogger("ImagingCacheWeb");

	/**
	 * This is the entry point method.
	 */
	@Override
	public void onModuleLoad()
	{
		String queryString = Window.Location.getQueryString();
		if(queryString != null && queryString.length() > 0)
		{
			Configuration.setShowClearCache( queryString.indexOf("clearcache") >= 0 );
			Configuration.setShowRefresh( queryString.indexOf("refresh") >= 0 );
			Configuration.setShowDelete( queryString.indexOf("delete") >= 0 );
		}
		
		this.cacheDataProvider = new CacheDataProvider();
		this.cacheDataProvider.addStateChangeListener(this);
		this.cacheDataProvider.initialize();
	
		this.cacheStackPanel = new CacheStackPanel(this.cacheDataProvider);
		//cachePanel = new CachePanel(cacheManager);
		this.cacheStackPanel.setSize("900px", "600px");
		
		this.dataProgressPopup = new DataProgressPopup();
		this.cacheDataProvider.addDataEventListener(this.dataProgressPopup);
		
		RootPanel.get(CONTENT_ROOT_ID).add(cacheStackPanel);
		RootPanel.getBodyElement().setAttribute("role", "appilcation");
	}
	
	/**
	 * Notification that the CacheDataProvider has been initialized,
	 * this means that the CacheManagerVO (the root of the data model)
	 * is available.
	 */
	@Override
	public void stateChange(CacheDataProvider.State oldState, CacheDataProvider.State newState)
	{
		if(CacheDataProvider.State.INITIALIZED == newState)
		{
			logger.log(Level.INFO, "CacheDataProvider initialized.");
			this.cacheStackPanel.initialize();
		}
	}

	class DataProgressPopup
	extends DecoratedPopupPanel
	implements CacheDataEventListener
	{
		private final ProgressBar progressBar;
		private final Timer timer;
		private final double interval = 1000.0;
		
		DataProgressPopup()
		{
			progressBar = new ProgressBar(0.0, 100.0);
			timer = new Timer() 
			{
				@Override
				public void run() 
				{
					progressBar.setProgress(progressBar.getProgress() + interval);
				}
			};
		}
		
		@Override
		public void cacheDataEvent(CacheDataEvent event) 
		{
			// if the data event is a start and is expected to take longer than 1 second
			if( event.getEventType() == EVENT_TYPE.START && event.getExpectedDuration() > interval )
			{
				progressBar.setMaxProgress(event.getExpectedDuration());
				progressBar.setProgress(0.0);
				timer.scheduleRepeating((int)interval);
				center();
			}
			else if( event.getEventType() == EVENT_TYPE.SUCCESS || event.getEventType() == EVENT_TYPE.FAILURE )
			{
				timer.cancel();
				progressBar.setProgress(progressBar.getMaxProgress());
				hide();
			}
		}
		
	}
	
}
