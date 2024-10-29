using System;
using System.Collections.Generic;
using System.Text;
using System.Windows.Forms;
using System.ComponentModel;
using System.Collections;
using System.Reflection;

namespace gov.va.med.imaging.exchange.VixInstaller.ui
{
public class ErrorProviderFixed : ErrorProvider
    {
        ErrorProviderFixManager mToolTipFix = null;
 
        public ErrorProviderFixed()
            : base()
        {
            mToolTipFix = new ErrorProviderFixManager(this);
        }
 
        public ErrorProviderFixed(ContainerControl parentControl)
            : base(parentControl)
        {
            mToolTipFix = new ErrorProviderFixManager(this);
        }
 
        public ErrorProviderFixed(IContainer container)
            : base(container)
        {
            mToolTipFix = new ErrorProviderFixManager(this);
        }
 
        protected override void Dispose(bool disposing)
        {
            mToolTipFix.Dispose();
            base.Dispose(disposing);
        }
    }
 
    public class ErrorProviderFixManager : IDisposable
    {
        private ErrorProvider mTheErrorProvider = null;
        private Timer mTmrCheckHandelsProc = null;
        private Hashtable mHashOfNativeWindows = new Hashtable();
 
        public void Dispose()
        {
            mTmrCheckHandelsProc.Stop();
            mTmrCheckHandelsProc.Dispose();
            mTmrCheckHandelsProc = null;
        }
 
        /// <SUMMARY>
        /// constructor, which will started a timer that will
        /// keep the errorProviders tooltip window up-to-date and enabled.
        ///
        /// To do: I would like to do this without a timer (Suggestions welcome).
        /// </SUMMARY>
        /// <param name="ep"></param>
        public ErrorProviderFixManager(ErrorProvider ep)
        {
            mTheErrorProvider = ep;
 
            mTmrCheckHandelsProc = new Timer();
            mTmrCheckHandelsProc.Enabled = true;
            mTmrCheckHandelsProc.Interval = 1000;
            mTmrCheckHandelsProc.Tick += new EventHandler(tmr_CheckHandels);
        }
 
        /// <SUMMARY>
        /// Resets the error provider, error messages.  I've noticed that when
        /// you click on an error provider, while its tooltip is displayed,
        /// the tooltip doesn't return.  It will return if the text is reset, or
        /// if the user is able to hover over another error provider message for
        /// that errorProvider instance.
        /// 
        /// Todo: I would like to find an easier way to fix this...
        /// Email me at: km@KevinMPhoto.com
        /// </SUMMARY>
        private void RefreshProviderErrors()
        {
            Hashtable hashRes = (Hashtable)GetFieldValue(mTheErrorProvider, "items");
            foreach (Control control in hashRes.Keys)
            {
                if (hashRes[control] == null)
                {
                    break;
                }

                if (!(bool)GetFieldValue(hashRes[control], "toolTipShown"))
                {
                    if ((mTheErrorProvider.GetError(control) != null) &&
                          (mTheErrorProvider.GetError(control).Length > 0))
                    {
                        string str = mTheErrorProvider.GetError(control);
                        ErrorBlinkStyle prev = mTheErrorProvider.BlinkStyle;
                        mTheErrorProvider.BlinkStyle = ErrorBlinkStyle.NeverBlink;

                        //Modified to correct unwanted "flickering" in ErrorProvider Icons
                        if (!string.IsNullOrEmpty(str))
                        {
                            mTheErrorProvider.SetError(control, str + "text to reset the ErrorProvider");
                        }
                        else
                        {
                            mTheErrorProvider.SetError(control, "");
                        }
                        //End of Modifications

                        mTheErrorProvider.SetError(control, str);
                        mTheErrorProvider.BlinkStyle = prev;
                    }
                }
            }
        }
 
        /// <SUMMARY>
        /// This method checks to see if the error provider's tooltip window has
        /// changed and if it updates this Native window with the new handle.
        /// 
        /// If there is some sort of change, it also calls the RefreshProviderErrors, 
        /// which fixes the tooltip problem...
        /// </SUMMARY>
        /// <param name="sender"></param>
        /// <param name="e"></param>
        void tmr_CheckHandels(object sender, EventArgs e)
        {
            if (mTheErrorProvider.ContainerControl == null)
            {
                return;
            }
 
            if (mTheErrorProvider.ContainerControl.Visible)
            {
                Hashtable hashRes = 
                     (Hashtable)GetFieldValue(mTheErrorProvider, "windows");
                if (hashRes.Count > 0)
                {
                    foreach (Object obj in hashRes.Keys)
                    {
                        ErrorProviderNativeWindowHook hook = null;
                        if (mHashOfNativeWindows.Contains(obj))
                        {
                            hook = (ErrorProviderNativeWindowHook)
                                                  mHashOfNativeWindows[obj];
                        }
                        else
                        {
                            hook = new ErrorProviderNativeWindowHook();
                            mHashOfNativeWindows[obj] = hook;
                        }
 
                        NativeWindow nativeWindow = GetFieldValue(hashRes[obj], 
                                                    "tipWindow") as NativeWindow;
                        if (nativeWindow != null && hook.Handle == IntPtr.Zero)
                        {
                            hook.AssignHandle(nativeWindow.Handle);
                        }
                    }
                }
 
                foreach (ErrorProviderNativeWindowHook hook 
                           in mHashOfNativeWindows.Values)
                {
                    if (hook.mBlnTrigerRefresh)
                    {
                        hook.mBlnTrigerRefresh = false;
                        RefreshProviderErrors();
                    }
                }
            }
        }
 
        /// <SUMMARY>
        /// A helper method, which allows us to get the value of private fields.
        /// </SUMMARY>
        /// <param name="instance">the object instance</param>
        /// <param name="name">the name of the field, which we want to get</param>
        /// <RETURNS>the value of the private field</RETURNS>
        private object GetFieldValue(object instance, string name)
        {
            if (instance == null) return null;
 
            FieldInfo fInfo = null;
            Type type = instance.GetType();
            while (fInfo == null && type != null)
            {
                fInfo = type.GetField(name, 
                       System.Reflection.BindingFlags.FlattenHierarchy | 
                       System.Reflection.BindingFlags.NonPublic | 
                       BindingFlags.Instance);
                type = type.BaseType;
            }
            if (fInfo == null)
            {
            }
            return fInfo.GetValue(instance);
        }
    }
 
    /// <SUMMARY>
    /// A NativeWindow, which we use to trap the WndProc messages
    /// and patch up the ErrorProvider/ToolTip bug.
    /// </SUMMARY>
    public class ErrorProviderNativeWindowHook : NativeWindow
    {
        private int mInt407Count = 0;
        internal bool mBlnTrigerRefresh = false;
 
        /// <SUMMARY>
        /// This is the magic.  On the 0x407 message, we need to reset the 
        /// error provider; however, I can't do it directly in the WndProc; 
        /// otherwise, we could get a cross threading type exception, since
        /// this WndProc is called on a separate thread.  The Timer will make
        /// sure the work gets done on the Main GUI thread.          
        /// </SUMMARY>
        /// <param name="m"></param>
        protected override void WndProc(ref Message m)
        {
            if (m.Msg == 0x407)
            {
                mInt407Count++;
                if (mInt407Count > 3)  // if this occurs we need to release...
                {
                    this.ReleaseHandle();
                    mBlnTrigerRefresh = true;
                }
            }
            else
            {
                mInt407Count = 0;
            }
 
            base.WndProc(ref m);
        }
    }
}
