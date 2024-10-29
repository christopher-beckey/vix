/**
 * 
 */
package gov.va.med.cache.gui.client;

import gov.va.med.cache.gui.shared.CacheManagerVO;
import gov.va.med.cache.gui.shared.CacheVO;

import java.util.logging.Logger;

import com.google.gwt.aria.client.Roles;
import com.google.gwt.core.client.GWT;
import com.google.gwt.dom.client.Style.Unit;
import com.google.gwt.event.dom.client.ClickEvent;
import com.google.gwt.event.dom.client.ClickHandler;
import com.google.gwt.user.client.Element;
import com.google.gwt.user.client.ui.HTML;
import com.google.gwt.user.client.ui.HorizontalPanel;
import com.google.gwt.user.client.ui.Label;
import com.google.gwt.user.client.ui.Widget;
import com.google.gwt.view.client.AsyncDataProvider;

/**
 * @author VHAISWBECKEC
 *
 */
public class CacheStackPanel 
extends StackLayoutDataPanel<CacheVO, CachePanel>
{
	Logger 					logger = Logger.getLogger("CacheStackPanel");
	CacheDataProvider 		cacheDataProvider;
	static ClientMessages clientMessages = GWT.create(ClientMessages.class); 
	
	public CacheStackPanel(CacheDataProvider cacheDataProvider)
	{
		super(Unit.PX, 30);

		if(cacheDataProvider == null)
			throw new IllegalArgumentException("The provided CacheDataProvider must not be null.");
		this.cacheDataProvider = cacheDataProvider;
		this.addStyleName("cache_panel");
		setSize("800px", "400px");
	}
	
	private CacheDataProvider getCacheDataProvider()
	{
		return cacheDataProvider;
	}

	@Override
	public CachePanel createStackPanelWidget(CacheVO cache)
	{
		return new CachePanel(this.cacheDataProvider, cache);
	}

	@Override
	public Widget createStackPanelHeaderWidget(CacheVO cache)
	{
		return new CachePanelHeaderWidget(cache);
	}

	private class CachePanelHeaderWidget
	extends HorizontalPanel
	{
		private final CacheVO cache;
		
		public CachePanelHeaderWidget(CacheVO cache) 
		{
			this.cache = cache;
			this.setWidth("100%");
			this.addStyleName("cache-panel-header");
			HTML htmlCacheDisplay = new HTML(cache.getName());
			htmlCacheDisplay.addStyleName("cache-panel-title");
			add(htmlCacheDisplay);
			
			if(Configuration.isShowClearCache())
			{
				Label clearButton = new Label("Clear Cache");
				clearButton.setStyleName("hyperlink_style_label");
				
				clearButton.addClickHandler(new ClickHandler() {
					@Override
					public void onClick(ClickEvent event) {clearClick();}
				});
				
				Roles.getButtonRole().set(clearButton.getElement());
				add(clearButton);
			}
		}
		private void clearClick(){clearCache(cache);}
		
	}

	protected void initialize()
	{
		CacheManagerVO cacheManager = getCacheDataProvider().getCacheManager();
		AsyncDataProvider<CacheVO> dataProvider = getCacheDataProvider().getOrCreateDecorator(cacheManager);
		logger.info( "CacheStackPanel, CacheDataProvider decorator is " + dataProvider.toString() );
		
		dataProvider.addDataDisplay( this );
		this.setRowCount(Integer.MAX_VALUE);
		this.setVisibleRange(0, Integer.MAX_VALUE);
		//MessageDialog.showInformationDialog("CacheStackPanel", "Cache Manager Set");
	}
	
	private void clearCache(CacheVO cache)
	{
		String cacheName = cache.getName();
		
		if( com.google.gwt.user.client.Window.confirm(clientMessages.halSays(cacheName)) )
			cacheDataProvider.clearCache(cacheName);
	}
}
