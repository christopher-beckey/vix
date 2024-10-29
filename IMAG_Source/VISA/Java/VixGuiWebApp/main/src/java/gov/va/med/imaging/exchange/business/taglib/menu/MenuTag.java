/**
 * Package: MAG - VistA Imaging
 * WARNING: Per VHA Directive 2004-038, this routine should not be modified.
 * Date Created: Jul 9, 2008
 * Site Name:  Washington OI Field Office, Silver Spring, MD
 * @author VHAISWBECKEC
 * @version 1.0
 *
 * ----------------------------------------------------------------
 * Property of the US Government.
 * No permission to copy or redistribute this software is given.
 * Use of unreleased versions of this software requires the user
 * to execute a written test agreement with the VistA Imaging
 * Development Office of the Department of Veterans Affairs,
 * telephone (301) 734-0100.
 * 
 * The Food and Drug Administration classifies this software as
 * a Class II medical device.  As such, it may not be changed
 * in any way.  Modifications to this software may result in an
 * adulterated medical device under 21CFR820, the use of which
 * is considered to be a violation of US Federal Statutes.
 * ----------------------------------------------------------------
 */
package gov.va.med.imaging.exchange.business.taglib.menu;

import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.LineNumberReader;
import java.io.Writer;
import java.util.ArrayList;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.jsp.JspException;
import javax.servlet.jsp.tagext.Tag;
import javax.servlet.jsp.tagext.TagSupport;

/**
 * @author VHAISWBECKEC
 * 
 * Example:
 * <menu:Menu 
 *  menuId="mainMenu" menuClass="menu" 
 *  submenuIdRoot="subMenu-" submenuClass="mainMenuSubMenu" 
 *  menuItemIdRoot="menuItem-" menuItemClass="mainMenuItem"
 *  menuDivId="mainMenuDiv" />
*/
public class MenuTag 
extends TagSupport
{
	private static final long serialVersionUID = 1L;
	
	// the name of the properties file where the menu is defined
	public final static String DEFAULT_MENU_BUNDLE = "menu"; //$NON-NLS-1$
	private String menuBundleName = DEFAULT_MENU_BUNDLE;
	
	// the IDs and class names of the menu elements
	public final static String DEFAULT_MENU_CLASS = "menu"; //$NON-NLS-1$
	public final static String DEFAULT_MENU_ID = "menu-id"; //$NON-NLS-1$
	public final static String DEFAULT_SUBMENU_CLASS = "submenu"; //$NON-NLS-1$
	public final static String DEFAULT_SUBMENU_ID_ROOT = "submenu-"; //$NON-NLS-1$
	public final static String DEFAULT_MENUITEM_ID_ROOT = "menuitem-"; //$NON-NLS-1$
	public final static String DEFAULT_MENUITEM_CLASS = "menuitem"; //$NON-NLS-1$
	public final static String DEFAULT_MENUDIV_ID = "menudiv-id";
	public final static String DEFAULT_MENUDIV_CLASS = "menudiv";
	
	
	public final static String DEFAULT_MENU_ELEMENT = "ul";
	public final static String DEFAULT_SUBMENU_ELEMENT = "ul";
	public final static String DEFAULT_MENUITEM_ELEMENT = "li";
	public final static String DEFAULT_MENU_DISPLAYELEMENT_TYPE = "a";
	public final static String DEFAULT_MENUDIV_ELEMENT = "div";
	
	private String menuId = DEFAULT_MENU_ID;
	private String menuClass = DEFAULT_MENU_CLASS;
	private String menuElementType = DEFAULT_MENU_ELEMENT;
	
	private String subMenuClass = DEFAULT_SUBMENU_CLASS;
	private String subMenuElementType = DEFAULT_SUBMENU_ELEMENT;
	
	private String menuItemClass = DEFAULT_MENUITEM_CLASS;
	private String menuItemElementType = DEFAULT_MENUITEM_ELEMENT;
	private String menuItemDisplayElementType = DEFAULT_MENU_DISPLAYELEMENT_TYPE;
	
	private String menuDivId = DEFAULT_MENUDIV_ID;
	private String menuDivClass = DEFAULT_MENUDIV_CLASS;
	private String menuDivElementType = DEFAULT_MENUDIV_ELEMENT;
	
	private MenuElementFactory menuElementFactory;
	
	/**
     * @return the menuPropertiesResourceName
     */
    public String getMenuBundleName()
    {
    	return menuBundleName;
    }
    public void setMenuBundleName(String menuBundleName)
    {
    	this.menuBundleName = menuBundleName;
    }

	/**
     * @return the menuClass
     */
    public String getMenuClass()
    {
    	return menuClass;
    }
    public void setMenuClass(String menuClass)
    {
    	this.menuClass = menuClass;
    }

	/**
     * @return the menuId
     */
    public String getMenuId()
    {
    	return menuId;
    }
    public void setMenuId(String menuId)
    {
    	this.menuId = menuId;
    }
    
	/**
     * @return the submenuClass
     */
    public String getSubMenuClass()
    {
    	return subMenuClass;
    }
    public void setSubMenuClass(String subMenuClass)
    {
    	this.subMenuClass = subMenuClass;
    }
    
	/**
     * @return the menuItemClass
     */
    public String getMenuItemClass()
    {
    	return menuItemClass;
    }
    public void setMenuItemClass(String menuItemClass)
    {
    	this.menuItemClass = menuItemClass;
    }
    
	/**
     * @return the menuElementType
     */
    public String getMenuElementType()
    {
    	return menuElementType;
    }
    public void setMenuElementType(String menuElementType)
    {
    	this.menuElementType = menuElementType;
    }
    
	/**
     * @return the subMenuElementType
     */
    public String getSubMenuElementType()
    {
    	return subMenuElementType;
    }
    public void setSubMenuElementType(String subMenuElementType)
    {
    	this.subMenuElementType = subMenuElementType;
    }
    
	/**
     * @return the menuItemElementType
     */
    public String getMenuItemElementType()
    {
    	return menuItemElementType;
    }
    public void setMenuItemElementType(String menuItemElementType)
    {
    	this.menuItemElementType = menuItemElementType;
    }
    
    /**
     * @return the menuDisplayElementType
     */
    public String getMenuItemDisplayElementType()
    {
    	return menuItemDisplayElementType;
    }
    public void setMenuItemDisplayElementType(String menuDisplayElementType)
    {
    	this.menuItemDisplayElementType = menuDisplayElementType;
    }
    
    /**
     * @return the menuDivId
     */
    public String getMenuDivId()
    {
    	return menuDivId;
    }
    public void setMenuDivId(String menuDivId)
    {
    	this.menuDivId = menuDivId;
    }
    
	/**
     * @return the menuDivClass
     */
    public String getMenuDivClass()
    {
    	return menuDivClass;
    }
    public void setMenuDivClass(String menuDivClass)
    {
    	this.menuDivClass = menuDivClass;
    }
    
	/**
     * @return the menuDivElementType
     */
    public String getMenuDivElementType()
    {
    	return menuDivElementType;
    }
    public void setMenuDivElementType(String menuDivElementType)
    {
    	this.menuDivElementType = menuDivElementType;
    }
    
	/**
     * The component that is responsible for building the HTML elements
     * @return
     */
	private MenuElementFactory getMenuElementFactory()
    {
    	return menuElementFactory;
    }
    
	/**
     * @see javax.servlet.jsp.tagext.TagSupport#doStartTag()
     */
    @Override
    public int doStartTag() 
    throws JspException
    {
    	// initialize the HTML generation
    	menuElementFactory = new MenuElementFactory(
			getMenuId(),getMenuClass(), getMenuElementType(),
			getSubMenuClass(), getSubMenuElementType(),
			getMenuItemClass(), getMenuItemElementType(),
			getMenuItemDisplayElementType(),
			getMenuDivId(), getMenuDivClass(), getMenuDivElementType()
    	);
    	
    	try
        {
	        Writer writer = pageContext.getOut();
	        
	        writer.write( getMenuHtml() );
        } 
    	catch (IOException ioX)
        {
    		throw new JspException(ioX);
        }
    	
	    return Tag.EVAL_BODY_INCLUDE;
    }
	
    /**
     * Produce HTML like this:
     * <ul id="menu-id" class="menu">
     *   <li id="50000" >
     *     <a href="/file.jsp">File</a>
     *     <ul id="600" width="150">
     *       <li id="500001">
     *         <a href="/fileSave.jsp">Save</a>
     *       </li>
     *       <li id="500002"><a href="/fileSaveAs.jsp">Save As</a></li>
     *       <li id="500003"><a href="/fileOpen.jsp">Open</a></li>
     *     </ul>
     *   </li>
     *   <li id="50001"><a href="#">View</a>
     *     <ul width="130">
     *       <li id="500011"><a href="showShource.jsp">Source</a></li>
     *       <li id="500012"><a href="showDebugInfo.jsp">Debug info</a></li>
     *     </ul>
     *   </li>
	 * </ul>
	 * <div id="menu-div">
	 * </div> 
	 *  
     * @return
     * @throws JspException 
     */
	private String getMenuHtml() 
	throws JspException
	{
		MenuTreeBuilder menuTreeBuilder = new MenuTreeBuilder( new MenuTagProperties(getMenuBundleName()) );
		MenuItem root = menuTreeBuilder.getRootMenuItem();
		
		StringBuilder sb = new StringBuilder();

		if(isUserInPriveligedRole(root.roles))
		{
			// By default, the root menu is a UL element, submenues are also UL elements, menu items are LI elements
			sb.append( getMenuElementFactory().createMenuStartTag(getMenuId(), getMenuClass()) );
			
			for(MenuItem menuItem : root.submenuItems)
			{
				if(isUserInPriveligedRole(menuItem.roles))
					sb.append(generateMenuItemElements(menuItem));
			}
			
			sb.append( getMenuElementFactory().createMenuEndTag() );
			
			sb.append( getMenuElementFactory().createMenuDivElementStartTag());
			sb.append( getMenuElementFactory().createMenuDivElementEndTag());
		}
		
		return sb.toString();
	}
	
	// determine whether the user has the priveliges needed to see a
	// particular menu item
	private boolean isUserInPriveligedRole(Set<String> menuItemRoles) 
	throws JspException
    {
		if(menuItemRoles == null || menuItemRoles.size() == 0)
			return true;
		
		try
		{
			HttpServletRequest req = (HttpServletRequest)this.pageContext.getRequest();
			for(String menuItemRole : menuItemRoles)
				if( req.isUserInRole(menuItemRole) )
					return true;
		}
		catch(Throwable t)
		{
			throw new JspException("Unable to determine user role membership because this tag is operating outside of an HTTP servlet.");
		}
		
	    return false;
    }
	/**
	 * <a href="link">Home</a>
	 * 
	 * @param menuItem
	 * @return
	 * @throws JspException 
	 */
	private String generateMenuItemElements(MenuItem menuItem) 
	throws JspException
	{
		StringBuilder sb = new StringBuilder();
		boolean hasSubMenu = menuItem.submenuItems != null && menuItem.submenuItems.size() > 0;

		// append the <li id="subMennuId" class="submenuClass">
		sb.append( getMenuElementFactory().createMenuItemElementStartTag() );
		
		// append the <a href="link">Home</a>
		sb.append(getMenuElementFactory().createMenuItemDisplayElementStartTag(menuItem.link));
		sb.append(menuItem.text);
		sb.append(getMenuElementFactory().createMenuItemDisplayElementEndTag());

		// if there is a submenu, create the <ul> element
		// and the child elements
		if(hasSubMenu)
		{
			sb.append( getMenuElementFactory().createSubMenuElementStartTag() );
			
			for(MenuItem submenuItem : menuItem.submenuItems)
				if(isUserInPriveligedRole(submenuItem.roles))
					sb.append(generateMenuItemElements(submenuItem) + " \n");		// recursively add our child menu items
			
			sb.append( getMenuElementFactory().createSubMenuElementEndTag() );
		}
		
		// append the </li>
		sb.append( getMenuElementFactory().createMenuItemElementEndTag() );
		
		return sb.toString();
	}

	/**
	 * 
	 * @author VHAISWBECKEC
	 *
	 */
	class MenuTreeBuilder
	{
		private final MenuTagProperties menuTagProperties;
		private MenuItem rootMenuItem = null;
		
		MenuTreeBuilder(MenuTagProperties menuTagProperties)
		{
			this.menuTagProperties = menuTagProperties;
		}
		
		public synchronized MenuItem getRootMenuItem()
		{
			if(rootMenuItem == null)
				rootMenuItem = build();
			
			return rootMenuItem;
		}
		
		private MenuItem build()
		{
			// the root menu item is unique in having no text
			MenuItem root = new MenuItem("menu");

			populate(root);
			
			return root;
		}
		
		/**
		 * Recursively populate the menu tree from the properties bundle
		 * 
		 * @param root
		 */
		private void populate(MenuItem root)
		{
	    	String[] subItemNames = menuTagProperties.getStringArray(root.name + ".items");
	    	if(subItemNames != null && subItemNames.length > 0)
	    	{
	    		for(String subItemName : subItemNames)
	    		{
	    			if(subItemName == null || subItemName.length() < 1)
	    				continue;
	    			
	    			MenuItem subMenuItem = new MenuItem(subItemName);
	    			
	    			subMenuItem.text = menuTagProperties.getString(subItemName + ".text");
	    			subMenuItem.link = menuTagProperties.getString(subItemName + ".link");
	    			String[] subItemRoles = menuTagProperties.getStringArray(subItemName + ".roles");
	    			if(subItemRoles != null)
	    				for(String role : subItemRoles)
	    					subMenuItem.roles.add(role);
	    			
	    			root.submenuItems.add(subMenuItem);
	    			
	    			populate(subMenuItem); // recursively populate submenues
	    		}
	    	}
		}
	}
	
	/**
	 * 
	 * @author VHAISWBECKEC
	 *
	 */
	class MenuItem
	{
		final private String name;
		private String text;
		private String link;
		private List<MenuItem> submenuItems = new ArrayList<MenuItem>();
		private Set<String> roles = new HashSet<String>();
		
		MenuItem(String name)
		{
			this.name = name;
		}
	}
}
