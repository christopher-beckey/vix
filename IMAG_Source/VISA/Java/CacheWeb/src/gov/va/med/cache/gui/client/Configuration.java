package gov.va.med.cache.gui.client;

import com.google.gwt.core.client.GWT;

public class Configuration 
{
	private static boolean showClearCache = false;
	private static boolean showRefresh = false;
	private static boolean showDelete = true;
	public static final ClientMessages clientMessages = GWT.create(ClientMessages.class);
	
	private Configuration()	{}

	public static boolean isShowClearCache() {
		return showClearCache;
	}

	public static void setShowClearCache(boolean showClearCache) {
		Configuration.showClearCache = showClearCache;
	}

	public static boolean isShowRefresh() {
		return showRefresh;
	}

	public static void setShowRefresh(boolean showRefresh) {
		Configuration.showRefresh = showRefresh;
	}

	public static boolean isShowDelete() {
		return showDelete;
	}

	public static void setShowDelete(boolean showDelete) {
		Configuration.showDelete = showDelete;
	}
	
}
