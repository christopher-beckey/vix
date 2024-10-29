//------------------------------------------------------------------------------
// <auto-generated>
//     This code was generated by a tool.
//     Runtime Version:4.0.30319.34014
//
//     Changes to this file may cause incorrect behavior and will be lost if
//     the code is regenerated.
// </auto-generated>
//------------------------------------------------------------------------------

namespace Resources {
    using System;
    
    
    /// <summary>
    ///   A strongly-typed resource class, for looking up localized strings, etc.
    /// </summary>
    // This class was auto-generated by the StronglyTypedResourceBuilder
    // class via a tool like ResGen or Visual Studio.
    // To add or remove a member, edit your .ResX file then rerun ResGen
    // with the /str option or rebuild the Visual Studio project.
    [global::System.CodeDom.Compiler.GeneratedCodeAttribute("Microsoft.VisualStudio.Web.Application.StronglyTypedResourceProxyBuilder", "12.0.0.0")]
    [global::System.Diagnostics.DebuggerNonUserCodeAttribute()]
    [global::System.Runtime.CompilerServices.CompilerGeneratedAttribute()]
    internal class ErrorMessages {
        
        private static global::System.Resources.ResourceManager resourceMan;
        
        private static global::System.Globalization.CultureInfo resourceCulture;
        
        [global::System.Diagnostics.CodeAnalysis.SuppressMessageAttribute("Microsoft.Performance", "CA1811:AvoidUncalledPrivateCode")]
        internal ErrorMessages() {
        }
        
        /// <summary>
        ///   Returns the cached ResourceManager instance used by this class.
        /// </summary>
        [global::System.ComponentModel.EditorBrowsableAttribute(global::System.ComponentModel.EditorBrowsableState.Advanced)]
        internal static global::System.Resources.ResourceManager ResourceManager {
            get {
                if (object.ReferenceEquals(resourceMan, null)) {
                    global::System.Resources.ResourceManager temp = new global::System.Resources.ResourceManager("Resources.ErrorMessages", global::System.Reflection.Assembly.Load("App_GlobalResources"));
                    resourceMan = temp;
                }
                return resourceMan;
            }
        }
        
        /// <summary>
        ///   Overrides the current thread's CurrentUICulture property for all
        ///   resource lookups using this strongly typed resource class.
        /// </summary>
        [global::System.ComponentModel.EditorBrowsableAttribute(global::System.ComponentModel.EditorBrowsableState.Advanced)]
        internal static global::System.Globalization.CultureInfo Culture {
            get {
                return resourceCulture;
            }
            set {
                resourceCulture = value;
            }
        }
        
        /// <summary>
        ///   Looks up a localized string similar to Cannot perform the action at this time: {0}. Please try again later..
        /// </summary>
        internal static string ActionNotAllowedAtThisTime {
            get {
                return ResourceManager.GetString("ActionNotAllowedAtThisTime", resourceCulture);
            }
        }
        
        /// <summary>
        ///   Looks up a localized string similar to The device {0} has entries in the WorkQueue and cannot be deleted..
        /// </summary>
        internal static string AdminDevices_DeleteDevice_PendingWorkQueue {
            get {
                return ResourceManager.GetString("AdminDevices_DeleteDevice_PendingWorkQueue", resourceCulture);
            }
        }
        
        /// <summary>
        ///   Looks up a localized string similar to Unable to delete this server partition. This could mean there are studies on this partition.
        ///
        ///Please check the log file or contact the server administrator..
        /// </summary>
        internal static string AdminPartition_DeletePartition_Failed {
            get {
                return ResourceManager.GetString("AdminPartition_DeletePartition_Failed", resourceCulture);
            }
        }
        
        /// <summary>
        ///   Looks up a localized string similar to Unable to delete this alert item..
        /// </summary>
        internal static string AlertDeleteFailed {
            get {
                return ResourceManager.GetString("AlertDeleteFailed", resourceCulture);
            }
        }
        
        /// <summary>
        ///   Looks up a localized string similar to Failed to delete this alert item.&lt;br&gt;Error: {0}.
        /// </summary>
        internal static string AlertDeleteFailed_WithException {
            get {
                return ResourceManager.GetString("AlertDeleteFailed_WithException", resourceCulture);
            }
        }
        
        /// <summary>
        ///   Looks up a localized string similar to This alert item is no longer available in the system..
        /// </summary>
        internal static string AlertNotAvailable {
            get {
                return ResourceManager.GetString("AlertNotAvailable", resourceCulture);
            }
        }
        
        /// <summary>
        ///   Looks up a localized string similar to ImageServer Authorization Failed..
        /// </summary>
        internal static string AuthorizationError {
            get {
                return ResourceManager.GetString("AuthorizationError", resourceCulture);
            }
        }
        
        /// <summary>
        ///   Looks up a localized string similar to Unable to contact the authentication and authorization server..
        /// </summary>
        internal static string CannotContactEnterpriseServer {
            get {
                return ResourceManager.GetString("CannotContactEnterpriseServer", resourceCulture);
            }
        }
        
        /// <summary>
        ///   Looks up a localized string similar to {0}.
        /// </summary>
        internal static string ChangePasswordError {
            get {
                return ResourceManager.GetString("ChangePasswordError", resourceCulture);
            }
        }
        
        /// <summary>
        ///   Looks up a localized string similar to Cookies are currently disabled on your browser..
        /// </summary>
        internal static string CookiesAreDisabled {
            get {
                return ResourceManager.GetString("CookiesAreDisabled", resourceCulture);
            }
        }
        
        /// <summary>
        ///   Looks up a localized string similar to ClearCanvas ImageServer requires your browser to accept Cookies.  Please enable Cookies on your browser and click here to try again..
        /// </summary>
        internal static string CookiesAreDisabledLongDescription {
            get {
                return ResourceManager.GetString("CookiesAreDisabledLongDescription", resourceCulture);
            }
        }
        
        /// <summary>
        ///   Looks up a localized string similar to Unable to delete the study. See server log for more details..
        /// </summary>
        internal static string DeleteStudyError {
            get {
                return ResourceManager.GetString("DeleteStudyError", resourceCulture);
            }
        }
        
        /// <summary>
        ///   Looks up a localized string similar to Validation Error. Please check all tabs for indicated errors and correct before submitting changes..
        /// </summary>
        internal static string EditDeviceValidationError {
            get {
                return ResourceManager.GetString("EditDeviceValidationError", resourceCulture);
            }
        }
        
        /// <summary>
        ///   Looks up a localized string similar to Validation Error. Please check all tabs for indicated errors and correct before submitting changes..
        /// </summary>
        internal static string EditFileSystemValidationError {
            get {
                return ResourceManager.GetString("EditFileSystemValidationError", resourceCulture);
            }
        }
        
        /// <summary>
        ///   Looks up a localized string similar to Validation Error. Please check all tabs for indicated errors and correct before submitting changes..
        /// </summary>
        internal static string EditPartitionValidationError {
            get {
                return ResourceManager.GetString("EditPartitionValidationError", resourceCulture);
            }
        }
        
        /// <summary>
        ///   Looks up a localized string similar to Validation Error. Please check all tabs for indicated errors and correct before submitting changes..
        /// </summary>
        internal static string EditServerRuleValidationError {
            get {
                return ResourceManager.GetString("EditServerRuleValidationError", resourceCulture);
            }
        }
        
        /// <summary>
        ///   Looks up a localized string similar to Validation Error. Please check all tabs for indicated errors and correct before submitting changes..
        /// </summary>
        internal static string EditStudyValidationError {
            get {
                return ResourceManager.GetString("EditStudyValidationError", resourceCulture);
            }
        }
        
        /// <summary>
        ///   Looks up a localized string similar to To include the ImageServer&apos;s error message, click here..
        /// </summary>
        internal static string ErrorShowStackTraceMessage {
            get {
                return ResourceManager.GetString("ErrorShowStackTraceMessage", resourceCulture);
            }
        }
        
        /// <summary>
        ///   Looks up a localized string similar to There are currently {1} users belonging to this group..
        /// </summary>
        internal static string ExceptionAuthorityGroupIsNotEmpty_MultipleUsers {
            get {
                return ResourceManager.GetString("ExceptionAuthorityGroupIsNotEmpty_MultipleUsers", resourceCulture);
            }
        }
        
        /// <summary>
        ///   Looks up a localized string similar to There is currently one user belonging to this group..
        /// </summary>
        internal static string ExceptionAuthorityGroupIsNotEmpty_OneUser {
            get {
                return ResourceManager.GetString("ExceptionAuthorityGroupIsNotEmpty_OneUser", resourceCulture);
            }
        }
        
        /// <summary>
        ///   Looks up a localized string similar to This message is being displayed because the ClearCanvas ImageServer encountered a situation that was unexpected. The resulting error has been recorded for future analysis. 
        ///
        ///If you would like to report the error, please post to one of the forums listed below and provide any information you think will be helpful in handling this situation in the future..
        /// </summary>
        internal static string GeneralErrorMessage {
            get {
                return ResourceManager.GetString("GeneralErrorMessage", resourceCulture);
            }
        }
        
        /// <summary>
        ///   Looks up a localized string similar to Javascript is currently disabled on your browser..
        /// </summary>
        internal static string JavascriptIsDisabled {
            get {
                return ResourceManager.GetString("JavascriptIsDisabled", resourceCulture);
            }
        }
        
        /// <summary>
        ///   Looks up a localized string similar to ClearCanvas ImageServer requires Javascript in order to run. Please enable Javascript on your browser and click here to try again.
        /// </summary>
        internal static string JavascriptIsDisabledLongDescription {
            get {
                return ResourceManager.GetString("JavascriptIsDisabledLongDescription", resourceCulture);
            }
        }
        
        /// <summary>
        ///   Looks up a localized string similar to Could not find a valid license.
        /// </summary>
        internal static string LicenseError {
            get {
                return ResourceManager.GetString("LicenseError", resourceCulture);
            }
        }
        
        /// <summary>
        ///   Looks up a localized string similar to A valid license must be entered to use this product.  Please follow the instructions in the Getting Started Guide to enter the license and refresh this page to continue..
        /// </summary>
        internal static string LicenseErrorLongDescription {
            get {
                return ResourceManager.GetString("LicenseErrorLongDescription", resourceCulture);
            }
        }
        
        /// <summary>
        ///   Looks up a localized string similar to Invalid User ID or Password..
        /// </summary>
        internal static string LoginInvalidUsernameOrPassword {
            get {
                return ResourceManager.GetString("LoginInvalidUsernameOrPassword", resourceCulture);
            }
        }
        
        /// <summary>
        ///   Looks up a localized string similar to The evaluation period for this software has expired..
        /// </summary>
        internal static string MessageSoftwareExpired {
            get {
                return ResourceManager.GetString("MessageSoftwareExpired", resourceCulture);
            }
        }
        
        /// <summary>
        ///   Looks up a localized string similar to Unexpected Error: Multiple Partitions exist with AE title {0}.
        /// </summary>
        internal static string MultiplePartitionsExistWithAETitle {
            get {
                return ResourceManager.GetString("MultiplePartitionsExistWithAETitle", resourceCulture);
            }
        }
        
        /// <summary>
        ///   Looks up a localized string similar to You are not authorized to view this page.
        /// </summary>
        internal static string PageAccessDenied {
            get {
                return ResourceManager.GetString("PageAccessDenied", resourceCulture);
            }
        }
        
        /// <summary>
        ///   Looks up a localized string similar to Your password has expired..
        /// </summary>
        internal static string PasswordExpired {
            get {
                return ResourceManager.GetString("PasswordExpired", resourceCulture);
            }
        }
        
        /// <summary>
        ///   Looks up a localized string similar to The password you entered is not acceptable. Please contact the administrator..
        /// </summary>
        internal static string PasswordPolicyNotMet {
            get {
                return ResourceManager.GetString("PasswordPolicyNotMet", resourceCulture);
            }
        }
        
        /// <summary>
        ///   Looks up a localized string similar to An error occurred resetting the password. Password has not been changed..
        /// </summary>
        internal static string PasswordResetFailed {
            get {
                return ResourceManager.GetString("PasswordResetFailed", resourceCulture);
            }
        }
        
        /// <summary>
        ///   Looks up a localized string similar to Provided passwords do not match.&lt;br/&gt;Please retype your passwords and try again..
        /// </summary>
        internal static string PasswordsDoNotMatch {
            get {
                return ResourceManager.GetString("PasswordsDoNotMatch", resourceCulture);
            }
        }
        
        /// <summary>
        ///   Looks up a localized string similar to Provided passwords don&apos;t match. 
        ///Please retype your passwords and try again..
        /// </summary>
        internal static string PasswordsDontMatch {
            get {
                return ResourceManager.GetString("PasswordsDontMatch", resourceCulture);
            }
        }
        
        /// <summary>
        ///   Looks up a localized string similar to A potentially dangerous request was detected..
        /// </summary>
        internal static string PotentialDangerousRequest {
            get {
                return ResourceManager.GetString("PotentialDangerousRequest", resourceCulture);
            }
        }
        
        /// <summary>
        ///   Looks up a localized string similar to Report is not available at this time because of the following error(s):.
        /// </summary>
        internal static string QCReportNotAvailable {
            get {
                return ResourceManager.GetString("QCReportNotAvailable", resourceCulture);
            }
        }
        
        /// <summary>
        ///   Looks up a localized string similar to ImageServer session timed out..
        /// </summary>
        internal static string SessionTimedout {
            get {
                return ResourceManager.GetString("SessionTimedout", resourceCulture);
            }
        }
        
        /// <summary>
        ///   Looks up a localized string similar to This message is being displayed because there has been no activity in the past {0} minute(s). For security purposes, your ImageServer session has been closed. Please login again to continue using ClearCanvas ImageServer. .
        /// </summary>
        internal static string SessionTimedoutLongDescription {
            get {
                return ResourceManager.GetString("SessionTimedoutLongDescription", resourceCulture);
            }
        }
        
        /// <summary>
        ///   Looks up a localized string similar to Something happened that the ImageServer was unprepared for..
        /// </summary>
        internal static string UnexpectedError {
            get {
                return ResourceManager.GetString("UnexpectedError", resourceCulture);
            }
        }
        
        /// <summary>
        ///   Looks up a localized string similar to Access denied.  The user credentials may be invalid or the account may be disabled..
        /// </summary>
        internal static string UserAccessDenied {
            get {
                return ResourceManager.GetString("UserAccessDenied", resourceCulture);
            }
        }
        
        /// <summary>
        ///   Looks up a localized string similar to This message is being displayed because the ClearCanvas ImageServer encountered an error authorizing user with ID &quot;{0}&quot;.
        /// </summary>
        internal static string WebViewerAuthorizationErrorDescription {
            get {
                return ResourceManager.GetString("WebViewerAuthorizationErrorDescription", resourceCulture);
            }
        }
        
        /// <summary>
        ///   Looks up a localized string similar to The requested session has already been removed.  Please try to login again..
        /// </summary>
        internal static string WebViewerSessionAlreadyRemoved {
            get {
                return ResourceManager.GetString("WebViewerSessionAlreadyRemoved", resourceCulture);
            }
        }
        
        /// <summary>
        ///   Looks up a localized string similar to This message is being displayed because there has been no activity in the past few minute(s). For security purposes, your session has been closed..
        /// </summary>
        internal static string WebViewerSessionTimedoutLongDescription {
            get {
                return ResourceManager.GetString("WebViewerSessionTimedoutLongDescription", resourceCulture);
            }
        }
        
        /// <summary>
        ///   Looks up a localized string similar to &apos;{0}&apos; is invalid.
        /// </summary>
        internal static string WebViewerSpecifiedFieldInvalid {
            get {
                return ResourceManager.GetString("WebViewerSpecifiedFieldInvalid", resourceCulture);
            }
        }
        
        /// <summary>
        ///   Looks up a localized string similar to &apos;{0}&apos; is specified but contain an empty value.
        /// </summary>
        internal static string WebViewerSpecifiedFieldIsEmpty {
            get {
                return ResourceManager.GetString("WebViewerSpecifiedFieldIsEmpty", resourceCulture);
            }
        }
    }
}
