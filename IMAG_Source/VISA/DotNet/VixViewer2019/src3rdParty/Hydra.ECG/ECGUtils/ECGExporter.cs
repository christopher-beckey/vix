using ECGConversion;
using ECGConversion.ECGGlobalMeasurements;
using ECGConversion.ECGSignals;
using SvgNet.SvgGdi;
using System;
using System.Collections.Generic;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using ECGConversion.ECGDiagnostic;
using System.Drawing.Drawing2D;
using System.Drawing.Imaging;
using System.IO;

namespace Hydra.ECG
{
    public class ECGExporter
    {
        public static Bitmap ToBitmap(string filePath, string format, ExportOptions exportOptions, out ECGInfo ecgInfo)
        {
            return RenderECG(filePath, format, exportOptions, out ecgInfo);
        }

        public static Bitmap ToBitmap(Stream inputStream, string format, ExportOptions exportOptions, out ECGInfo ecgInfo)
        {
            return RenderECG(inputStream, format, exportOptions, out ecgInfo);
        }

        public static string ToSvg(string filePath, string format, ExportOptions exportOptions, out ECGInfo ecgInfo)
        {
            SvgGraphics graphics = new SvgGraphics(new RectangleF(0, 0, exportOptions.ImageWidth, exportOptions.ImageHeight));

            if (RenderECG(graphics, filePath, format, exportOptions, out ecgInfo))
                return graphics.WriteSVGString();

            return null;
        }

        private static bool RenderECG(IGraphics graphics, string filePath, string format, ExportOptions exportOptions, out ECGInfo ecgInfo)
        {
            bool success = false;
            IECGFormat currentECG = null;
            ECGDraw.GridType displayGrid = (ECGDraw.GridType)(int) exportOptions.GridType;

            ecgInfo = null;

            try
            {
                ECGConverter.Instance.waitForLoadingAllPlugins();
                IECGReader reader = ECGConverter.Instance.getReader(format);
                ECGConfig cfg = ECGConverter.Instance.getConfig(format);
                currentECG = reader.Read(filePath, 0, cfg);
                if (currentECG == null)
                    return false;

                if (exportOptions.GenerateHeader)
                {
                    if (currentECG.GlobalMeasurements != null)
                    {
                        GlobalMeasurements gms;

                        if ((currentECG.GlobalMeasurements.getGlobalMeasurements(out gms) == 0) && 
                            (gms.measurment != null) && 
                            (gms.measurment.Length > 0) && 
                            (gms.measurment[0] != null))
                        {
                            int ventRate = (gms.VentRate == GlobalMeasurement.NoValue) ? 0 : (int)gms.VentRate,
                                PRint = (gms.PRint == GlobalMeasurement.NoValue) ? 0 : (int)gms.PRint,
                                QRSdur = (gms.QRSdur == GlobalMeasurement.NoValue) ? 0 : (int)gms.QRSdur,
                                QT = (gms.QTdur == GlobalMeasurement.NoValue) ? 0 : (int)gms.QTdur,
                                QTc = (gms.QTc == GlobalMeasurement.NoValue) ? 0 : (int)gms.QTc;

                            ecgInfo = new ECGInfo();
                            ecgInfo.VentRate = string.Format("{0} BMP", ventRate);
                            ecgInfo.PRInt = string.Format("{0} ms", PRint);
                            ecgInfo.QRSDur = string.Format("{0} ms", QRSdur);
                            ecgInfo.QTQTc = string.Format("{0}/{1} ms", QT, QTc);
                            ecgInfo.PRTAxes = string.Format("{0} {1} {2}", 
                                                (gms.measurment[0].Paxis != GlobalMeasurement.NoAxisValue) ? gms.measurment[0].Paxis.ToString() : "999",
                                                (gms.measurment[0].QRSaxis != GlobalMeasurement.NoAxisValue) ? gms.measurment[0].QRSaxis.ToString() : "999",
                                                (gms.measurment[0].Taxis != GlobalMeasurement.NoAxisValue) ? gms.measurment[0].Taxis.ToString() : "999");

                            if (!exportOptions.GenerateImage)
                                success = true;
                        }
                    }

                    if (currentECG.Diagnostics != null)
                    {
                        string diagnosticText = string.Empty;
                        Statements statements;
                        currentECG.Diagnostics.getDiagnosticStatements(out statements);
                        foreach (string line in statements.statement)
                        {
                            if (string.IsNullOrEmpty(line))
                            {
                                continue;
                            }

                            diagnosticText = string.Format("{0}{1}<br>", diagnosticText, line);
                        }

                        if (diagnosticText != string.Empty)
                            ecgInfo.DiagnosticText = diagnosticText;
                    }

                    if (currentECG.Demographics != null)
                    {
                        if (ecgInfo == null)
                            ecgInfo = new ECGInfo();

                        ecgInfo.PatientId = currentECG.Demographics.PatientID;
                        ecgInfo.ReferringPhysician = currentECG.Demographics.ReferringPhysician;
                        ecgInfo.ConfirmedPhysician = currentECG.Demographics.OverreadingPhysician;

                        StringBuilder sbName = new StringBuilder();

                        if (currentECG.Demographics.LastName != null)
                        {
                            sbName.Append(currentECG.Demographics.LastName);
                            sbName.Append(" ");
                        }

                        if (currentECG.Demographics.FirstName != null)
                        {
                            sbName.Append(currentECG.Demographics.FirstName);
                        }

                        if (sbName != null)
                        {
                            ecgInfo.PatientName = sbName.ToString();
                        }

                        if (currentECG.Demographics.Gender != ECGConversion.ECGDemographics.Sex.Null)
                        {
                            string gender = string.Empty;
                            switch (currentECG.Demographics.Gender)
                            {
                                case ECGConversion.ECGDemographics.Sex.Male:
                                    gender = "M";
                                    break;

                                case ECGConversion.ECGDemographics.Sex.Female:
                                    gender = "F";
                                    break;

                                case ECGConversion.ECGDemographics.Sex.Unspecified:
                                    gender = "O";
                                    break;

                                default:
                                    break;
                            }

                            ecgInfo.PatientGender = gender;
                        }

                        ushort ageVal;
                        ECGConversion.ECGDemographics.AgeDefinition ad;
                        if (currentECG.Demographics.getPatientAge(out ageVal, out ad) == 0)
                        {
                            StringBuilder sbAge = new StringBuilder();
                            sbAge.Append(ageVal);
                            if (ad != ECGConversion.ECGDemographics.AgeDefinition.Years)
                            {
                                sbAge.Append(" ");
                                sbAge.Append(ad.ToString());
                            }

                            if (sbAge != null)
                            {
                                ecgInfo.PatientAge = sbAge.ToString();
                            }
                        }

                        DateTime dt = currentECG.Demographics.TimeAcquisition;
                        if (dt != null)
                        {
                            ecgInfo.AcquisitionDateTime = (dt.Year > 1000) ? dt.ToString("dd-MMM-yyyy HH:mm:ss") : "";
                        }
                    }
                }

                if (exportOptions.GenerateImage)
                {
                    Signals currentSignal;
                    if (currentECG.Signals.getSignals(out currentSignal) == 0)
                    {
                        if (currentSignal != null)
                        {
                            for (int i = 0, j = currentSignal.NrLeads; i < j; i++)
                            {
                                ECGTool.NormalizeSignal(currentSignal[i].Rhythm, currentSignal.RhythmSamplesPerSecond);
                            }
                        }

                        Signals sig = currentSignal.CalculateTwelveLeads();

                        if (sig != null)
                            currentSignal = sig;

                        if (currentSignal.IsBuffered)
                        {
                            BufferedSignals bs = currentSignal.AsBufferedSignals;
                            bs.LoadSignal(bs.RealRhythmStart, bs.RealRhythmStart + 60 * bs.RhythmSamplesPerSecond);

                            //ECGTimeScrollbar.Minimum = 0;
                            //ECGTimeScrollbar.Maximum = bs.RealRhythmEnd - bs.RealRhythmStart;
                            //ECGTimeScrollbar.Value = 0;
                            //ECGTimeScrollbar.SmallChange = _CurrentSignal.RhythmSamplesPerSecond;
                            //ECGTimeScrollbar.LargeChange = _CurrentSignal.RhythmSamplesPerSecond;
                        }
                        else
                        {
                            int start, end;
                            currentSignal.CalculateStartAndEnd(out start, out end);

                            //ECGTimeScrollbar.Minimum = 0;
                            //ECGTimeScrollbar.Maximum = end - start;
                            //ECGTimeScrollbar.Value = 0;
                            //ECGTimeScrollbar.SmallChange = _CurrentSignal.RhythmSamplesPerSecond;
                            //ECGTimeScrollbar.LargeChange = _CurrentSignal.RhythmSamplesPerSecond;
                        }
                    }

                    int w = exportOptions.ImageWidth, h = exportOptions.ImageHeight;
                    int n = 0;
                    int[,] s = { { 782, 492 }, { 1042, 657 }, { 1302, 822 } };

                    for (; n < s.GetLength(0); n++)
                        if ((s[n, 0] > w)
                        || (s[n, 1] > h))
                            break;

                    n += 2;
                    ECGConversion.ECGDraw.DpiX = ECGConversion.ECGDraw.DpiY = 25.4f * n;

                    ECGDraw.ECGDrawType drawType = (ECGDraw.ECGDrawType)(int)exportOptions.DrawType;

                    int oldSPS = currentSignal.RhythmSamplesPerSecond;
                    int ret = ECGDraw.DrawECG(graphics, displayGrid, currentSignal, drawType, 0, 25.0f, GetGain(exportOptions), true);

                    if (ret < 0)
                    {
                        graphics.SmoothingMode = System.Drawing.Drawing2D.SmoothingMode.AntiAlias;
                        ret = ECGDraw.DrawECG(graphics, displayGrid, currentSignal, ECGDraw.ECGDrawType.Regular, 0, 25.0f, GetGain(exportOptions), false);
                    }

                    success = true;
                }
            }
            catch (Exception)
            {
            }
            finally
            {
                if (currentECG != null)
                    currentECG.Dispose();
                currentECG = null;
            }

            return success;
        }

        private static Bitmap RenderECG(string filePath, string format, ExportOptions exportOptions, out ECGInfo ecgInfo)
        {
            using (var fileStream = File.Open(filePath, FileMode.Open, FileAccess.Read, FileShare.Read))
            {
                return RenderECG(fileStream, format, exportOptions, out ecgInfo);
            }
        }

        private static Bitmap RenderECG(Stream stream, string format, ExportOptions exportOptions, out ECGInfo ecgInfo)
        {
            //bool success = false;
            IECGFormat currentECG = null;
            ECGDraw.GridType displayGrid = (ECGDraw.GridType)(int)exportOptions.GridType;
            Bitmap drawBuffer = null;

            ecgInfo = null;

            try
            {
                ECGConverter.Instance.waitForLoadingAllPlugins();
                IECGReader reader = ECGConverter.Instance.getReader(format);
                ECGConfig cfg = ECGConverter.Instance.getConfig(format);
                currentECG = reader.Read(stream, 0, cfg);
                if (currentECG == null)
                {
                    return null;
                }

                if (exportOptions.GenerateHeader)
                {
                    if (currentECG.GlobalMeasurements != null)
                    {
                        GlobalMeasurements gms;

                        if ((currentECG.GlobalMeasurements.getGlobalMeasurements(out gms) == 0) &&
                            (gms.measurment != null) &&
                            (gms.measurment.Length > 0) &&
                            (gms.measurment[0] != null))
                        {
                            int ventRate = (gms.VentRate == GlobalMeasurement.NoValue) ? 0 : (int)gms.VentRate,
                                PRint = (gms.PRint == GlobalMeasurement.NoValue) ? 0 : (int)gms.PRint,
                                QRSdur = (gms.QRSdur == GlobalMeasurement.NoValue) ? 0 : (int)gms.QRSdur,
                                QT = (gms.QTdur == GlobalMeasurement.NoValue) ? 0 : (int)gms.QTdur,
                                QTc = (gms.QTc == GlobalMeasurement.NoValue) ? 0 : (int)gms.QTc;

                            ecgInfo = new ECGInfo();
                            ecgInfo.VentRate = string.Format("{0} BMP", ventRate);
                            ecgInfo.PRInt = string.Format("{0} ms", PRint);
                            ecgInfo.QRSDur = string.Format("{0} ms", QRSdur);
                            ecgInfo.QTQTc = string.Format("{0}/{1} ms", QT, QTc);
                            ecgInfo.PRTAxes = string.Format("{0} {1} {2}",
                                                (gms.measurment[0].Paxis != GlobalMeasurement.NoAxisValue) ? gms.measurment[0].Paxis.ToString() : "999",
                                                (gms.measurment[0].QRSaxis != GlobalMeasurement.NoAxisValue) ? gms.measurment[0].QRSaxis.ToString() : "999",
                                                (gms.measurment[0].Taxis != GlobalMeasurement.NoAxisValue) ? gms.measurment[0].Taxis.ToString() : "999");

                            //if (!exportOptions.GenerateImage)
                            //    success = true;
                        }
                    }

                    if (currentECG.Diagnostics != null)
                    {
                        string diagnosticText = string.Empty;
                        Statements statements;
                        currentECG.Diagnostics.getDiagnosticStatements(out statements);
                        if ((statements != null) && (statements.statement != null))
                        {
                            foreach (string line in statements.statement)
                            {
                                if (string.IsNullOrEmpty(line))
                                {
                                    continue;
                                }

                                diagnosticText = string.Format("{0}{1}<br>", diagnosticText, line);
                            }
                        }

                        if (diagnosticText != string.Empty)
                            ecgInfo.DiagnosticText = diagnosticText;
                    }

                    if (currentECG.Demographics != null)
                    {
                        if (ecgInfo == null)
                            ecgInfo = new ECGInfo();

                        ecgInfo.PatientId = currentECG.Demographics.PatientID;
                        ecgInfo.ReferringPhysician = currentECG.Demographics.ReferringPhysician;
                        ecgInfo.ConfirmedPhysician = currentECG.Demographics.OverreadingPhysician;

                        StringBuilder sbName = new StringBuilder();

                        if (currentECG.Demographics.LastName != null)
                        {
                            sbName.Append(currentECG.Demographics.LastName);
                            sbName.Append(" ");
                        }

                        if (currentECG.Demographics.FirstName != null)
                        {
                            sbName.Append(currentECG.Demographics.FirstName);
                        }

                        if (sbName != null)
                        {
                            ecgInfo.PatientName = sbName.ToString();
                        }

                        if (currentECG.Demographics.Gender != ECGConversion.ECGDemographics.Sex.Null)
                        {
                            string gender = string.Empty;
                            switch (currentECG.Demographics.Gender)
                            {
                                case ECGConversion.ECGDemographics.Sex.Male:
                                    gender = "M";
                                    break;

                                case ECGConversion.ECGDemographics.Sex.Female:
                                    gender = "F";
                                    break;

                                case ECGConversion.ECGDemographics.Sex.Unspecified:
                                    gender = "O";
                                    break;

                                default:
                                    break;
                            }

                            ecgInfo.PatientGender = gender;
                        }

                        ushort ageVal;
                        ECGConversion.ECGDemographics.AgeDefinition ad;
                        if (currentECG.Demographics.getPatientAge(out ageVal, out ad) == 0)
                        {
                            StringBuilder sbAge = new StringBuilder();
                            sbAge.Append(ageVal);
                            if (ad != ECGConversion.ECGDemographics.AgeDefinition.Years)
                            {
                                sbAge.Append(" ");
                                sbAge.Append(ad.ToString());
                            }

                            if (sbAge != null)
                            {
                                ecgInfo.PatientAge = sbAge.ToString();
                            }
                        }

                        DateTime dt = currentECG.Demographics.TimeAcquisition;
                        if (dt != null)
                        {
                            ecgInfo.AcquisitionDateTime = (dt.Year > 1000) ? dt.ToString("dd-MMM-yyyy HH:mm:ss") : "";
                        }
                    }
                }

                if (exportOptions.GenerateImage)
                {
                    Signals currentSignal;
                    if (currentECG.Signals.getSignals(out currentSignal) == 0)
                    {
                        if (currentSignal != null)
                        {
                            for (int i = 0, j = currentSignal.NrLeads; i < j; i++)
                            {
                                ECGTool.NormalizeSignal(currentSignal[i].Rhythm, currentSignal.RhythmSamplesPerSecond);
                            }
                        }

                        if (currentSignal == null)
                        {
                            throw new NullReferenceException("Invalid ECG signal");
                        }

                        Signals sig = currentSignal.CalculateTwelveLeads();

                        if (currentSignal.GetLeads().Length > 0)
                        {
                            int _index = 0;
                            string[] _leadTypes = new string[currentSignal.GetLeads().Length];
                            foreach (Signal _Signal in currentSignal.GetLeads())
                            {
                                _leadTypes[_index] = _Signal.Type.ToString();
                                _index++;
                            }

                            // Check whether the extra signal is valid or not
                            if (exportOptions.ExtraSignals != null)
                            {
                                if (exportOptions.DrawType == DrawType.ThreeXFourPlusOne || exportOptions.DrawType == DrawType.ThreeXFourPlusThree)
                                {
                                    _index = 1;
                                    foreach (string leadType in exportOptions.ExtraSignals)
                                    {
                                        var signalIndex = Array.FindIndex(_leadTypes, row => row.Contains(leadType));
                                        switch (_index)
                                        {
                                            case 1:
                                                currentSignal.ExtraSignalPosition1 = signalIndex;
                                                break;

                                            case 2:
                                                currentSignal.ExtraSignalPosition2 = signalIndex;
                                                break;

                                            case 3:
                                                currentSignal.ExtraSignalPosition3 = signalIndex;
                                                break;
                                        }

                                        _index++;
                                    }
                                }
                            }

                            //Copy the lead types.
                            if (ecgInfo != null)
                            {
                                ecgInfo.LeadTypes = new string[currentSignal.GetLeads().Length];
                                _leadTypes.CopyTo(ecgInfo.LeadTypes, 0);

                                // Check whether the median signal is found
                                ecgInfo.IsMedian = false;
                                if ((currentSignal.MedianAVM != 0) && (currentSignal.MedianSamplesPerSecond != 0) && (currentSignal.MedianLength != 0))
                                {
                                    ecgInfo.IsMedian = true;
                                }
                            }
                        }

                        if (sig != null)
                            currentSignal = sig;

                        if (currentSignal.IsBuffered)
                        {
                            BufferedSignals bs = currentSignal.AsBufferedSignals;
                            bs.LoadSignal(bs.RealRhythmStart, bs.RealRhythmStart + 60 * bs.RhythmSamplesPerSecond);
                        }
                        else
                        {
                            int start, end;
                            currentSignal.CalculateStartAndEnd(out start, out end);
                        }
                    }

                    float scalefactor = 1.0f;
                    float zoomPercent = 100.0f;
                    ECGConversion.ECGDraw.DpiX = ECGConversion.ECGDraw.DpiY = scalefactor * 100.0f;
                    ECGDraw.ECGDrawType drawType = (ECGDraw.ECGDrawType)(int)exportOptions.DrawType;
                    if (drawType == ECGDraw.ECGDrawType.None)
                    {
                        //reset the default draw type to calculate the signal dimension.
                        drawType = ECGDraw.ECGDrawType.ThreeXFourPlusThree;
                    }

                    //Resample the signal based on the scale.
                    currentSignal.Scale = scalefactor;
                    currentSignal.Gain = GetGain(exportOptions);
                    currentSignal.Resample((int)(scalefactor * zoomPercent));

                    int _bitmapWidth = (int)currentSignal.Width(scalefactor);
                    int _bitmapHeight = currentSignal.GetSignalHeight(drawType, GetGain(exportOptions), scalefactor);

                    if (_bitmapHeight == -1 || _bitmapWidth == -1)
                    {
                        //reset the image size to original
                        _bitmapHeight = exportOptions.ImageHeight;
                        _bitmapWidth = exportOptions.ImageWidth;

                        if (_bitmapHeight <= 0 || _bitmapWidth <= 0)
                        {
                            //Setting the default value for Hydra
                            _bitmapWidth = 1200;
                            _bitmapHeight = 900;
                        }
                    }
                    else
                    {
                        //Rounding the bitmap size.
                        int aDotsPerInch = (int)(scalefactor * 100.0f);
                        int cellSize = (int)(Math.Round((aDotsPerInch * ECGDraw.Inch_Per_mm) * ECGDraw._mm_Per_GridLine));

                        //Addng pulse grid length
                        _bitmapWidth += cellSize * 2;

                        //Calculate the margin
                        _bitmapHeight += cellSize * 2;
                        _bitmapWidth += cellSize * 1;

                        // rounding the size.
                        int padding = _bitmapHeight % cellSize;
                        if (padding != 0)
                        {
                            _bitmapHeight += padding;
                        }

                        padding = _bitmapWidth % cellSize;
                        if (padding != 0)
                        {
                            _bitmapWidth += padding;
                        }
                    }

                    //Set the grid color.
                    ECGDraw.GridGraphColor gridColor = (ECGDraw.GridGraphColor)(int)exportOptions.GridColor;
                    ECGDraw.SetGridColor(gridColor);

                    //Set the signal pen width
                    int signalThickness = (int)exportOptions.SignalThickness;
                    ECGDraw.SignalPenWidth = (float)signalThickness;

                    drawBuffer = new Bitmap(_bitmapWidth, _bitmapHeight);
                    GdiGraphics graphics = new GdiGraphics(Graphics.FromImage(drawBuffer));
                    int oldSPS = currentSignal.RhythmSamplesPerSecond;
                    int ret = ECGDraw.DrawECG1(graphics, displayGrid, currentSignal, drawType, 0, 25.0f, GetGain(exportOptions), true);

                    if (ret < 0)
                    {
                        graphics.SmoothingMode = System.Drawing.Drawing2D.SmoothingMode.AntiAlias;
                        ret = ECGDraw.DrawECG1(graphics, displayGrid, currentSignal, ECGDraw.ECGDrawType.Regular, 0, 25.0f, GetGain(exportOptions), false);
                    }

                    if(exportOptions.IsWaterMarkRequired)
                    {
                        //RenderWaterMark(drawBuffer, 45);
                        RenderWaterMarkPattern(drawBuffer, 45);
                    }
                    //success = true;
                }
            }
            catch (Exception)
            {
                throw;
            }
            finally
            {
                if (currentECG != null)
                    currentECG.Dispose();
                currentECG = null;
            }

            return drawBuffer;
        }

        public static Bitmap ResizedBitmap(Bitmap sourceBitmap, ExportOptions exportOptions)
        {
            try
            {
                if (sourceBitmap == null)
                {
                    throw new NullReferenceException("Bitmap is invalid");
                }

                if (sourceBitmap.Height == exportOptions.ImageHeight && sourceBitmap.Width == exportOptions.ImageWidth)
                {
                    return sourceBitmap;
                }

                // Get the image's original width and height
                int originalWidth = sourceBitmap.Width;
                int originalHeight = sourceBitmap.Height;

                // To preserve the aspect ratio
                float ratioWidth = (float)exportOptions.ImageWidth / (float)originalWidth;
                float ratioHeight = (float)exportOptions.ImageHeight / (float)originalHeight;
                float aspectRatio = Math.Min(ratioWidth, ratioHeight);

                // New width and height based on aspect ratio
                int newWidth = (int)(originalWidth * aspectRatio);
                int newHeight = (int)(originalHeight * aspectRatio);

                return new Bitmap(sourceBitmap, new Size(newWidth, newHeight)); ;
            }
            catch (Exception)
            {
            }

            return null;
        }

        private static float GetGain(ExportOptions exportOption)
        {
            float gain = 10.0f;
            switch (exportOption.SignalGain)
            {
                case SignalGain.Five:
                    gain = 5.0f;
                    break;

                case SignalGain.Ten:
                    gain = 10.0f;
                    break;

                case SignalGain.Twenty:
                    gain = 20.0f;
                    break;

                case SignalGain.Fourty:
                    gain = 40.0f;
                    break;

                default:
                    break;
            }

            return gain;
        }

        /// <summary>
        /// Renders the water mark
        /// </summary>
        /// <param name="sourceBitmap"></param>
        /// <param name="watermarkTransparencyLevel"></param>
        /// <returns></returns>
        public static bool RenderWaterMark(Bitmap sourceBitmap, byte watermarkTransparencyLevel)
        {
            try
            {
                float transparencyLevel = (float)watermarkTransparencyLevel / 255.0F;

                Bitmap watermarkBitmap = new Bitmap(800, 400);
                GdiGraphics watermarkGraphics = new GdiGraphics(Graphics.FromImage(watermarkBitmap));
                watermarkGraphics.RotateTransform(-30);
                watermarkGraphics.DrawString("DRAFT", new Font("Verdana", 80, FontStyle.Bold), new SolidBrush(Color.Gray), 0, 350);

                // just change the alpha
                ColorMatrix matrix = new ColorMatrix(new float[][]{
                new float[] {1F, 0, 0, 0, 0},
                new float[] {0, 1F, 0, 0, 0},
                new float[] {0, 0, 1F, 0, 0},
                new float[] {0, 0, 0, transparencyLevel, 0},
                new float[] {0, 0, 0, 0, 1F}});

                ImageAttributes imageAttributes = new ImageAttributes();
                imageAttributes.SetColorMatrix(matrix);

                using (Graphics g = Graphics.FromImage(sourceBitmap))
                {
                    g.CompositingMode = CompositingMode.SourceOver;
                    g.CompositingQuality = CompositingQuality.HighQuality;

                    g.DrawImage(watermarkBitmap,
                        new Rectangle(0, 0, sourceBitmap.Width, sourceBitmap.Height),
                        0,
                        0,
                        watermarkBitmap.Width + 10,
                        watermarkBitmap.Height + 50,
                        GraphicsUnit.Pixel,
                        imageAttributes);
                }

                return true;
            }
            catch (Exception)
            {
            }

            return false;
        }

        /// <summary>
        /// Renders the water mark (using pattern)
        /// </summary>
        /// <param name="sourceBitmap"></param>
        /// <param name="watermarkTransparencyLevel"></param>
        /// <returns></returns>
        public static bool RenderWaterMarkPattern(Bitmap sourceBitmap, byte watermarkTransparencyLevel)
        {
            try
            {
                float transparencyLevel = (float)watermarkTransparencyLevel / 255.0F;

                Bitmap watermarkBitmap = new Bitmap(250, 200);
                GdiGraphics watermarkGraphics = new GdiGraphics(Graphics.FromImage(watermarkBitmap));
                watermarkGraphics.RotateTransform(-30);
                watermarkGraphics.DrawString("DRAFT", new Font("Verdana", 30, FontStyle.Bold), new SolidBrush(Color.Gray), 0, 125);

                // just change the alpha
                ColorMatrix matrix = new ColorMatrix(new float[][]{
                new float[] {1F, 0, 0, 0, 0},
                new float[] {0, 1F, 0, 0, 0},
                new float[] {0, 0, 1F, 0, 0},
                new float[] {0, 0, 0, transparencyLevel, 0},
                new float[] {0, 0, 0, 0, 1F}});

                ImageAttributes imageAttributes = new ImageAttributes();
                imageAttributes.SetColorMatrix(matrix);

                using (Graphics g = Graphics.FromImage(sourceBitmap))
                {
                    g.CompositingMode = CompositingMode.SourceOver;
                    g.CompositingQuality = CompositingQuality.HighQuality;

                    int x = 0;
                    int y = 0;

                    while (y < sourceBitmap.Height)
                    {
                        x = 0;
                        while (x < sourceBitmap.Width)
                        {
                            g.DrawImage(watermarkBitmap,
                                new Rectangle(x, y, watermarkBitmap.Width, watermarkBitmap.Height),
                                0, 0, watermarkBitmap.Width, watermarkBitmap.Height,
                                GraphicsUnit.Pixel,
                                imageAttributes);
                            x += watermarkBitmap.Width;
                        }
                        y += watermarkBitmap.Height;
                    }
                }

                return true;
            }
            catch (Exception)
            {
            }

            return false;
        }

    }
}
