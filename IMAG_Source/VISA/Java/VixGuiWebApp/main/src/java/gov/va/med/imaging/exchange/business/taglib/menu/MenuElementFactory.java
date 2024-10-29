/**
 * Package: MAG - VistA Imaging
 * WARNING: Per VHA Directive 2004-038, this routine should not be modified.
 * Date Created: Jul 10, 2008
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

/**
 * @author VHAISWBECKEC
 *
 */
public class MenuElementFactory
{
	private final String menuId;
	private final String menuClass;
	private final String menuElementType;
	private final String menuDisplayElementType;
	private final String subMenuClass;
	private final String subMenuElementType;
	private final String menuItemClass;
	private final String menuItemElementType;
	
	private final String menuDivId;
	private final String menuDivClass;
	private final String menuDivElementType;
	
	private final String submenuWidth = "150px";

    private long subMenuId = 1L;
    private long menuItemId = 1L;
	
	MenuElementFactory(
		String menuId, String menuClass, String menuElementType, 
		String subMenuClass, String subMenuElementType, 
        String menuItemClass, String menuItemElementType,
        String menuDisplayElementType,
    	String menuDivId, String menuDivClass, String menuDivElementType)
    {
	    super();
	    this.menuId = menuId;
	    this.menuClass = menuClass;
	    this.menuElementType = menuElementType;
	    this.subMenuClass = subMenuClass;
	    this.subMenuElementType = subMenuElementType;
	    this.menuItemClass = menuItemClass;
	    this.menuItemElementType = menuItemElementType;
	    this.menuDisplayElementType = menuDisplayElementType;
	    
		this.menuDivId = menuDivId;
		this.menuDivClass = menuDivClass;
		this.menuDivElementType = menuDivElementType;
    }

    /**
     * Create unique DOM element identifiers
     * @return
     */
    private synchronized String nextSubMenuId(){return Long.toString(subMenuId++);}
    private synchronized String nextMenuItemId(){return Long.toString(menuItemId++);}
    
	
	String createMenuStartTag(String id, String styleClass)
	{
		StringBuilder sb = new StringBuilder();
		
		sb.append( "<" );
		sb.append( menuElementType );
		sb.append( " " );
		sb.append( "class=\"" + styleClass + "\" " );
		sb.append( "id=\"" + id + "\" " );
		sb.append( ">" );
		
		return sb.toString();
	}
	
	String createMenuEndTag()
	{
		StringBuilder sb = new StringBuilder();
		
		sb.append( "</" );
		sb.append( menuElementType );
		sb.append( ">");
		
		return sb.toString();
	}
	
	String createMenuItemDisplayElementStartTag(String link)
	{
		StringBuilder sb = new StringBuilder();
		
		sb.append( "<" );
		sb.append( menuDisplayElementType );
		sb.append( " href=\"" + (link == null || link.length() == 0 ? "#" : "" + link) + "\"" );
		sb.append( ">");
		
		return sb.toString();
	}
	
	String createMenuItemDisplayElementEndTag()
	{
		return "</" + menuDisplayElementType + ">";
	}

	String createMenuItemElementStartTag()
    {
		StringBuilder sb = new StringBuilder();
		String subMenuId = nextSubMenuId();
		
		sb.append( "<" );
		sb.append( menuItemElementType );
		sb.append( " " );
		sb.append( "class=\"" + menuItemClass + "\"" );
		sb.append( " " );
		sb.append( "id=\"" + subMenuId + "\"" );
		sb.append( ">" );
		
		return sb.toString();
    }

	String createMenuItemElementEndTag()
    {
		StringBuilder sb = new StringBuilder();
		
		sb.append( "</" );
		sb.append( menuItemElementType );
		sb.append( ">" );
		
		return sb.toString();
    }
	
	String createSubMenuElementStartTag()
    {
		StringBuilder sb = new StringBuilder();
		
		sb.append( "<" );
		sb.append( subMenuElementType );
		sb.append( " " );
		sb.append( "class=\"" + subMenuClass + "\" " );
		sb.append( "width=\"" +  submenuWidth + "\" ");
		sb.append( ">" );
		
		return sb.toString();
    }

	String createSubMenuElementEndTag()
    {
		StringBuilder sb = new StringBuilder();
		
		sb.append( "</" );
		sb.append( subMenuElementType );
		sb.append( ">" );
		
		return sb.toString();
    }
	
	String createMenuDivElementStartTag()
    {
		StringBuilder sb = new StringBuilder();
		
		sb.append( "<" );
		sb.append( menuDivElementType );
		sb.append( " " );
		sb.append( "class=\"" + menuDivClass + "\"" );
		sb.append( " " );
		sb.append( "id=\"" + menuDivId + "\"" );
		sb.append( ">" );
		
		return sb.toString();
    }
	
	String createMenuDivElementEndTag()
    {
		StringBuilder sb = new StringBuilder();
		
		sb.append( "</" );
		sb.append( menuDivElementType );
		sb.append( ">" );
		
		return sb.toString();
    }
}
