package gov.va.med.cache.gui.client;

import com.google.gwt.aria.client.Roles;
import com.google.gwt.resources.client.ImageResource;
import com.google.gwt.safehtml.shared.SafeHtml;
import com.google.gwt.safehtml.shared.SafeHtmlUtils;
import com.google.gwt.user.client.ui.AbstractImagePrototype;
import com.google.gwt.user.client.ui.Image;

/**
 * 
 * @author VHAISWBECKEC
 *
 */
public class ClientResourcesUtility 
{
	// Image Buttons
	public static SafeHtml DELETE_ICON_REFERENCE = makeImageButtonReference(ClientResources.INSTANCE.deleteIcon(), "Delete");
	public static SafeHtml CLEAR_ICON_REFERENCE = makeImageButtonReference(ClientResources.INSTANCE.cacheClearIcon(), "Clear");
	public static SafeHtml INFORMATION_ICON_REFERENCE = makeImageButtonReference(ClientResources.INSTANCE.informationIcon(), "More Information");
	public static SafeHtml REFRESH_ICON_REFERENCE = makeImageButtonReference(ClientResources.INSTANCE.refreshIcon(), "Refresh");
	
	// Icons
	public static SafeHtml HOME_COMMUNITY_ICON_REFERENCE = makeImageIconReference(ClientResources.INSTANCE.homeCommunityIcon(), "Community");
	public static SafeHtml REPOSITORY_ICON_REFERENCE = makeImageIconReference(ClientResources.INSTANCE.repositoryIcon(), "Repository");
	public static SafeHtml PATIENT_ICON_REFERENCE = makeImageIconReference(ClientResources.INSTANCE.patientIcon(), "Patient");
	public static SafeHtml STUDY_ICON_REFERENCE = makeImageIconReference(ClientResources.INSTANCE.studyIcon(), "Study");
	public static SafeHtml IMAGE_ICON_REFERENCE = makeImageIconReference(ClientResources.INSTANCE.imageIcon(), "Image");
	
	/**
	 * 
	 * @param resource
	 * @return
	 */
    public static SafeHtml makeImageButtonReference(ImageResource resource, String title) 
    {
	    AbstractImagePrototype proto = AbstractImagePrototype.create(resource);
	    Image image = proto.createImage();
	    Roles.getButtonRole().set(image.getElement());
	    //image.getElement().setTabIndex(0);
	    image.getElement().setTitle(title);
	    return SafeHtmlUtils.fromTrustedString(image.getElement().getString());
    }
    
    public static SafeHtml makeImageIconReference(ImageResource resource, String title){
    	AbstractImagePrototype proto = AbstractImagePrototype.create(resource);
	    Image image = proto.createImage();
	    //image.getElement().setTabIndex(0);
	    image.setAltText(title);
	    return SafeHtmlUtils.fromTrustedString(image.getElement().getString());
    }
    
    public static SafeHtml getIcon(String name){
    	if (name.equals("community"))
    		return HOME_COMMUNITY_ICON_REFERENCE;
    	if (name.equals("repository"))
    		return REPOSITORY_ICON_REFERENCE;
    	if (name.equals("patient"))
    		return PATIENT_ICON_REFERENCE;
    	if (name.equals("study"))
    		return STUDY_ICON_REFERENCE;
    	if (name.equals("image"))
    		return IMAGE_ICON_REFERENCE;
    	return null;
    }
}
