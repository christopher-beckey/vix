/**
 * 
 * Package: MAG - VistA Imaging
 * WARNING: Per VHA Directive 2004-038, this routine should not be modified.
 * Date Created: 02/21/2013
 * Site Name:  Washington OI Field Office, Silver Spring, MD
 * Developer:  Lenard Williams
 * Description: 
 *
 *       ;; +--------------------------------------------------------------------+
 *       ;; Property of the US Government.
 *       ;; No permission to copy or redistribute this software is given.
 *       ;; Use of unreleased versions of this software requires the user
 *       ;;  to execute a written test agreement with the VistA Imaging
 *       ;;  Development Office of the Department of Veterans Affairs,
 *       ;;  telephone (301) 734-0100.
 *       ;;
 *       ;; The Food and Drug Administration classifies this software as
 *       ;; a Class II medical device.  As such, it may not be changed
 *       ;; in any way.  Modifications to this software may result in an
 *       ;; adulterated medical device under 21CFR820, the use of which
 *       ;; is considered to be a violation of US Federal Statutes.
 *       ;; +--------------------------------------------------------------------+
 *
 */
namespace ImagingClient.Infrastructure.Events
{
    using Microsoft.Practices.Prism.Events;
    using Microsoft.Practices.Prism.Regions;

    /// <summary>
    /// An event that is published when the Importer  is doing work that requires
    /// a progress bar. 
    /// </summary>
    public class IsWorkInProgressEvent : CompositePresentationEvent<bool> {}

    /// <summary>
    /// An event that is published when a user is logged out of the Importer 
    /// </summary>
    public class LogoutEvent : CompositePresentationEvent<string> {}

    /// <summary>
    /// An event that is published when a user is logged out of the Importer 
    /// </summary>
    public class NavigatedToStudyListEvent : CompositePresentationEvent<NavigationContext> { }

    /// <summary>
    /// An event that is published when a new user logs in after an idle
    /// time out has occurred.
    /// </summary>
    public class NewUserLoginEvent : CompositePresentationEvent<string> {}

    /// <summary>
    /// An event that is published when a user performs a mouse or keyboard action
    /// on a window.
    /// </summary>
    public class UserActionEvent : CompositePresentationEvent<string> { }

    /// <summary>
    /// An event that is published when a user logs in.
    /// </summary>
    public class UserLoginEvent : CompositePresentationEvent<string> {}
}
