/**
 * 
 */
package gov.va.med.cache.gui.client;

import com.google.gwt.core.client.GWT;
import com.google.gwt.resources.client.ClientBundle;
import com.google.gwt.resources.client.ImageResource;

/**
 * usage example:
 * Display the manual file in an iframe
 * new Frame(MyResources.INSTANCE.ownersManual().getURL());
 * 
 * @see http://code.google.com/webtoolkit/doc/latest/DevGuideClientBundle.html
 * @author VHAISWBECKEC
 * 
 */
public interface ClientResources 
extends ClientBundle
{
	public static final ClientResources	INSTANCE	= GWT.create(ClientResources.class);

	@Source("images/delete-small-red.png")
	public ImageResource deleteIcon();
	
	@Source("images/delete-small-red.png")
	public ImageResource cacheClearIcon();
	
	@Source("images/info.png")
	public ImageResource informationIcon();
	
	@Source("images/refresh.png")
	public ImageResource refreshIcon();
	
	@Source("images/homeCommunityIcon.png")
	public ImageResource homeCommunityIcon();
	
	@Source("images/repositoryIcon.png")
	public ImageResource repositoryIcon();
	
	@Source("images/patientIcon.png")
	public ImageResource patientIcon();
	
	@Source("images/studyIcon.png")
	public ImageResource studyIcon();
	
	@Source("images/imageIcon.png")
	public ImageResource imageIcon();
}
