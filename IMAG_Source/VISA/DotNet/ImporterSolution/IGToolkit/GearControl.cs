/**
 * 
 * Package: MAG - VistA Imaging
 * WARNING: Per VHA Directive 2004-038, this routine should not be modified.
 * Date Created: 03/01/2011
 * Site Name:  Washington OI Field Office, Silver Spring, MD
 * Developer:  Jon Louthian
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


using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Drawing;
using System.Data;
using System.Net;
using System.Text;
using System.Windows.Forms;
using GearCORELib;
using GearDISPLAYLib;
using GearMEDLib;
using GearFORMATSLib;
using IGGUIWinLib;

namespace IGToolkit
{
    public partial class GearControl : UserControl
    {
        private IGImageState imageState = null;
        private bool mbUpdatePageView = false;
        private string mstrLastErrorMsg = null;
        private string mstrFilename = null;

        private IGPage currentPage = null;
        private IGPageDisplay currentPageDisp = null;
        private IIGMedPage currentMedPage = null;        
        private IIGMedContrast medContrast = null;
        private IIGLUT currentGrayLut = null;
        private IGPage currentPresStatePage = null;
        private IIGMedPage currentPresStateMedPage = null;
        private IIGIOLocation ioLocation = null;
        private IGGUIPanCtl IGPanCtrl = null;

        private MouseMode mouseMode = MouseMode.HAND_PAN;
        private bool pageCreated = false;

        public MouseMode MouseMode
        {
            get { return mouseMode; }
            set { mouseMode = value; ActivateMouseMode(); }
        }

        public event ZoomValueChangedDelegate OnZoomChangeEvent = null;
        public event WindowLevelValueChangedDelegate OnWindowLevelChangeEvent = null;

        public IGImageState ImageState
        {
            get { return imageState; }
        }

        public bool UpdatePageView
        {
            get { return mbUpdatePageView; }
            set { mbUpdatePageView = value; }
        }

        public GearControl()
        {
            InitializeComponent();
        }

        public string LastErrorMessage
        {
            get { return mstrLastErrorMsg; }
        }

        private void GearControl_Load(object sender, EventArgs e)
        {
            axIGPageViewCtl1.Width = this.Width;
            imageState = new IGImageState();
            
            IGPanCtrl = new IGGUIPanCtl();
            
        }

        public void UpdatePage()
        {
            if (axIGPageViewCtl1 != null)
            {
                axIGPageViewCtl1.UpdateView();
            }
        }

        public bool LoadRemoteImage(String filename, String serverShare, String username, String password)
        {
            NetworkConnection conn = null;
            try
            {
                if (serverShare.StartsWith("\\\\"))
                {
                    // Not a local drive. Open network connection
                    conn = NetworkConnection.GetNetworkConnection(serverShare, new NetworkCredential(username, password));
                }
                return LoadImage(filename);
            }
            finally
            {
                if (conn != null)
                {
                    conn.Dispose();
                }
            }
        }

        public bool LoadImage(string filename)
        {
            bool result = false;
            try
            {
                if (!pageCreated)
                {
                    createPage();
                    pageCreated = true;
                }
                currentPage.Clear();
                mstrFilename = "";
                if ((filename != null) && (filename.Length > 0))
                {
                    if (System.IO.File.Exists(filename))
                    {
                        currentPageDisp.Layout.Alignment = (enumIGDsplAlignModes.IG_DSPL_ALIGN_X_CENTER | enumIGDsplAlignModes.IG_DSPL_ALIGN_Y_CENTER);

                        currentPageDisp.Layout.UseImageResolution = true; // JMW p72 12/8/2006 - use image resolution for aspect ratio

                        ioLocation = (IIGIOLocation)IGComponentManager.getComponentManager().IGFormatsCtrl.CreateObject(GearFORMATSLib.enumIGFormatsObjType.IG_FORMATS_OBJ_IOFILE);  
                        ((IGIOFile)ioLocation).FileName = filename;
                        IGComponentManager.getComponentManager().IGFormatsCtrl.LoadPageFromFile(currentPage, filename, 0);

                        imageState.Page = 1;
                        imageState.PageCount = IGComponentManager.getComponentManager().IGFormatsCtrl.GetPageCount(ioLocation, GearFORMATSLib.enumIGFormats.IG_FORMAT_UNKNOWN);

                        if (mbUpdatePageView)
                        {
                            axIGPageViewCtl1.UpdateView();
                        }

                        IGDisplayZoomInfo zoomzoom = null;
                        zoomzoom = currentPageDisp.GetZoomInfo(axIGPageViewCtl1.hWnd);
                        zoomzoom.Mode = enumIGDsplZoomModes.IG_DSPL_ZOOM_H_FIXED | enumIGDsplZoomModes.IG_DSPL_ZOOM_V_NOT_FIXED;
                        imageState.ZoomValue = (int)(zoomzoom.HZoom * 100.0);

                        if (IGPanCtrl != null)
                        {
                            IIGComponent coreControl = IGComponentManager.getComponentManager().IGCoreCtrl.ComponentInterface;
                            IIGComponent displayControl = IGComponentManager.getComponentManager().IGDisplayCtrl.ComponentInterface;
                            IGPageDisplay pageDisplay = axIGPageViewCtl1.PageDisplay;

                            IGPanCtrl.SetParentImage(coreControl, displayControl, pageDisplay, axIGPageViewCtl1.hWnd);
                        }

                        mstrFilename = filename;

                        if ((currentPage.BitDepth >= 8) && (currentPage.BitDepth <= 16))
                        {
                            currentGrayLut.ChangeAttrs(currentPage.BitDepth, currentPage.Signed, 8, false);
    
                        }
                        lblZoom.Text = imageState.ZoomValue.ToString();
                        result = true;

                        currentPageDisp.Background.Color.RGB_B = Color.Black.B;
                        currentPageDisp.Background.Color.RGB_R = Color.Black.R;
                        currentPageDisp.Background.Color.RGB_G = Color.Black.G;
                    }
                    else
                    {
                        mstrLastErrorMsg = "File [" + filename + "] does not exist";
                        if (mbUpdatePageView)
                        {
                            axIGPageViewCtl1.UpdateView();
                        }
                    }
                }
                else
                {
                    mstrLastErrorMsg = "No file specified";
                }
            }
            catch (Exception ex)
            {
                mstrLastErrorMsg = ex.Message;
            }
            return result;
        }

        private void createPage()
        {
            // create new page and page display objects
            currentPage = IGComponentManager.getComponentManager().IGCoreCtrl.CreatePage();
            currentPageDisp = IGComponentManager.getComponentManager().IGDisplayCtrl.CreatePageDisplay(currentPage);
            axIGPageViewCtl1.PageDisplay = currentPageDisp;
            if (IGComponentManager.getComponentManager().IGMedCtrl != null)
            {
                currentMedPage = IGComponentManager.getComponentManager().IGMedCtrl.CreateMedPage(currentPage);
            }

            if (mbUpdatePageView)
            {
                axIGPageViewCtl1.UpdateView();
            }

            if (IGComponentManager.getComponentManager().IGMedCtrl != null)
            {
                medContrast = (IIGMedContrast)IGComponentManager.getComponentManager().IGMedCtrl.CreateObject(enumIGMedObjType.MED_OBJ_CONTRAST);
            }

            currentGrayLut = (IIGLUT)IGComponentManager.getComponentManager().IGCoreCtrl.CreateObject(enumIGCoreObjType.IG_OBJ_LUT);
            currentPresStatePage = IGComponentManager.getComponentManager().IGCoreCtrl.CreatePage();
            currentPresStateMedPage = (IIGMedPage) IGComponentManager.getComponentManager().IGMedCtrl.CreateMedPage(currentPresStatePage);          
        }

        public void ChangeZoomValue(int zoomValue)
        {
            int currZoom = 0;
            if (!pageCreated)
                return;
            IGDisplayZoomInfo igZoomInfo = null;
            igZoomInfo = currentPageDisp.GetZoomInfo(axIGPageViewCtl1.hWnd);
            currZoom = (int)(igZoomInfo.HZoom * 100);
            if (currZoom == zoomValue)
            {
                return;
            }
            imageState.ZoomValue = zoomValue;
            igZoomInfo.HZoom = (double)(zoomValue / 100.0f);
            igZoomInfo.VZoom = (double)(zoomValue / 100.0f);

            igZoomInfo.Mode = enumIGDsplZoomModes.IG_DSPL_ZOOM_H_FIXED | enumIGDsplZoomModes.IG_DSPL_ZOOM_V_FIXED;
            currentPageDisp.UpdateZoomFrom(igZoomInfo);
            if (mbUpdatePageView)
            {
                axIGPageViewCtl1.UpdateView();
            }
            lblZoom.Text = imageState.ZoomValue.ToString();
        }

        private void ChangeZoomValueInternal(int zoomValue)
        {
            ChangeZoomValue(zoomValue);
            if (OnZoomChangeEvent != null)
            {
                OnZoomChangeEvent(zoomValue);
            }
        }

        private void ActivateMouseMode()
        {
            switch (mouseMode)
            {
                case MouseMode.HAND_PAN:
                    break;
                case MouseMode.AUTO_WINLEV:
                    break;
                case MouseMode.HAND_ZOOM:
                    break;
            }
        }

        private bool mouseDown = false;
        private Point mouseStartPosition = Point.Empty;

        private void axIGPageViewCtl1_MouseMoveEvent(object sender, AxGearVIEWLib._IIGPageViewCtlEvents_MouseMoveEvent e)
        {
            if (mouseMode != MouseMode.HAND_PAN)
            {
                if ((mouseDown) && (mouseStartPosition != Point.Empty))
                {
                    int yChange = e.y - mouseStartPosition.Y;

                    if (mouseMode == MouseMode.HAND_ZOOM)
                    {
                        yChange = yChange / 10;
                        int newZoom = imageState.ZoomValue + yChange;
                        ChangeZoomValueInternal(newZoom);
                    }
                    /*
                    if (xChange > 0)
                    {

                    }
                    else
                    {
                    }
                     */
                }
            }
        }

        private void axIGPageViewCtl1_MouseDownEvent(object sender, AxGearVIEWLib._IIGPageViewCtlEvents_MouseDownEvent e)
        {
            mouseDown = true;
            mouseStartPosition = new Point(e.x, e.y);
            if ((e.button == 1) && (currentPage.IsValid))
            {
                if (mouseMode == MouseMode.HAND_PAN)
                {
                    if (IGPanCtrl != null)
                    {
                        IGPanCtrl.TrackMouse(e.x, e.y);
                    }
                }
            }
        }

        private void axIGPageViewCtl1_MouseUpEvent(object sender, AxGearVIEWLib._IIGPageViewCtlEvents_MouseUpEvent e)
        {
            mouseDown = false;
            mouseStartPosition = Point.Empty;
        }

    }
}
