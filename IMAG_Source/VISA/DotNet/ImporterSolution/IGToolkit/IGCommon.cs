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
using System.Text;

namespace IGToolkit
{

    public delegate void ZoomValueChangedDelegate(int zoomValue);
    public delegate void WindowLevelValueChangedDelegate(int windowValue, int levelValue);


    public class IGCommon
    {
    }

    public class IGImageState
    {
        private int mintWindowValueMax;
        private int mintLevelValueMax;
        private int mintWindowValueMin;
        private int mintLevelValueMin;
        private int mintPageCount;
        protected int mintZoomValue;

        public int ZoomValue
        {
            get { return mintZoomValue; }
            set { mintZoomValue = value; }
        }

        public int PageCount
        {
            get { return mintPageCount; }
            set { mintPageCount = value; }
        }
        private int mintPage;

        public int Page
        {
            get { return mintPage; }
            set { mintPage = value; }
        }

        public IGImageState()
        {
            mintWindowValueMin = 1;
            mintLevelValueMax = 0;
            mintWindowValueMax = 0;
            mintWindowValueMin = 0;
            mintPage = 0;
            mintPageCount = 0;
            mintZoomValue = 0;
        }
    }

    public enum MouseMode
    {
        HAND_PAN, HAND_ZOOM, AUTO_WINLEV
    }
}
