/***************************************************************************
Copyright 2012-2014, van Ettinger Information Technology, Lopik, The Netherlands
Copyright 2008-2010, Thoraxcentrum, Erasmus MC, Rotterdam, The Netherlands

Licensed under the Apache License, Version 2.0 (the "License");
you may not use this file except in compliance with the License.
You may obtain a copy of the License at

	http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.

Written by Maarten JB van Ettinger.

****************************************************************************/
using System;
using System.Drawing;
using System.Drawing.Drawing2D;

namespace ECGConversion
{
	using ECGDemographics;
	using ECGSignals;
    using SvgNet.SvgGdi;

	public class ECGDraw
	{
		// variables used for Bitmap output.
		public const float mm_Per_Inch = 25.4f;
		public const float Inch_Per_mm = 1f / mm_Per_Inch;
        public static float _mm_Per_GridLine = 5.0f;
		public static float uV_Per_Channel
		{
			get
			{
				return _uV_Per_Channel;
			}
			set
			{
				if ((value % 1000) == 0)
					_uV_Per_Channel = value;
			}
		}

#if WINCE
		public static RectangleF ClipBounds;
#endif

		public static float DpiX = 96.0f;
		public static float DpiY = 96.0f;
		private static float _uV_Per_Channel = 3000.0f;
		private static float _TextSize = 9.0f;
		public const int DirtSolutionFactor = 20; // max 20!!

		// Colors for drawing.
		public static Color SignalColor = Color.FromArgb(255, 0, 0, 0);
		public static Color TextColor = Color.FromArgb(255, 0, 0, 0);
		public static Color BackColor =  Color.FromArgb(0, 255, 255, 255); 
		public static Color GraphColor = Color.FromArgb(255, 187, 187);
		public static Color GraphSecondColor = Color.FromArgb(255, 229, 229);

		public enum GridType
		{
			None = 0,
			OneMillimeters = 1,
			FiveMillimeters = 2
		}

        public enum GridGraphColor
        {
            Red,
            Green,
            Blue,
            Black,
            Grey
        }

        public static float SignalPenWidth = 1.0f;

		// Configuration of the displayed info.
		public static bool DisplayInfo = true;
		//public static GridType DisplayGrid = GridType.OneMillimeters;

		/// <summary>
		/// Function to write an ECG in to an bitmap. Will only draw stored leads and will not display average beat.
		/// </summary>   
		/// <param name="src">an ECG file to convert</param>
		/// <param name="output">returns bitmap with signals.</param>
		/// <returns>0 on success</returns>
		public static int ToBitmap(IECGFormat src, ECGDraw.GridType displayGrid, float mm_Per_s, float mm_Per_mV, out Bitmap output)
		{
            return ToBitmap(src, displayGrid, 4f * mm_Per_Inch, 4f * mm_Per_Inch, mm_Per_s, mm_Per_mV, out output);
		}
		/// <summary>
		/// Function to write an ECG in to an bitmap. Will only draw stored leads and will not display average beat.
		/// </summary>   
		/// <param name="src">an ECG file to convert</param>
		/// <param name="output">returns bitmap with signals.</param>
		/// <returns>0 on success</returns>
		public static int ToBitmap(IECGFormat src, ECGDraw.GridType displayGrid, float dpiX, float dpiY, float mm_Per_s, float mm_Per_mV, out Bitmap output)
		{
			DpiX = dpiX; DpiY = dpiY;

			output = null;

			DateTime dtRecordTime = DateTime.MinValue;

			IDemographic dem = src.Demographics;
			if (dem != null)
				dtRecordTime = dem.TimeAcquisition;

			ECGSignals.Signals signals;
			if ((src.Signals == null)
			||  (src.Signals.getSignals(out signals) != 0))
			{
				return 1;
			}

			int nExtraSpace = (int) (_TextSize * DpiY * Inch_Per_mm * .4f);

			// begin: find start and end.
			int nStart	= int.MaxValue,
				nEnd	= int.MinValue;

			for (int lead=0;lead < signals.NrLeads;lead++)
			{
				if (signals[lead] != null)
				{
					nStart = Math.Min(nStart, signals[lead].RhythmStart);
					nEnd = Math.Max(nEnd, signals[lead].RhythmEnd);
				}
			}
			// end: find start and end.

			float
				fPixel_Per_s = mm_Per_s * DpiX * Inch_Per_mm,
				fPixel_Per_uV = mm_Per_mV * DpiY * Inch_Per_mm * 0.001f,
				fLeadYSpace = _uV_Per_Channel * fPixel_Per_uV;

			output = new Bitmap(
				(int) Math.Ceiling((((float) (nEnd - nStart)) / signals.RhythmSamplesPerSecond) * fPixel_Per_s + (0.2f * fPixel_Per_s)) + 1,
				(int) Math.Ceiling(fLeadYSpace * signals.NrLeads) + nExtraSpace + 1);

            DrawECG(Graphics.FromImage(output), displayGrid, signals, dtRecordTime, 0, mm_Per_s, mm_Per_mV, false);

			return 0;
		}

		/// <summary>
		/// Function to draw an ECG on a bitmap.
		/// </summary>
		/// <param name="myBM">Bitmap do draw ECG in.</param>
		/// <param name="signals">Signal data to draw (can change due to resampling).</param>
		/// <param name="dtRecordTime">Start time of recording</param>
		/// <param name="nTime">Start drawing at this sample number.</param>
		/// <param name="fmm_Per_s">mm per second</param>
		/// <param name="fmm_Per_mV">mm per mV</param>
		/// /// <returns>Sample number to start next draw ECG on.</returns>
		public static int DrawECG(Bitmap myBM, ECGDraw.GridType displayGrid, ECGSignals.Signals signals, DateTime dtRecordTime, int nTime, float fmm_Per_s, float fmm_Per_mV)
		{
            return DrawECG(Graphics.FromImage(myBM), displayGrid, signals, dtRecordTime, nTime, fmm_Per_s, fmm_Per_mV, false);
		}
		/// <summary>
		/// Function to draw an ECG on a bitmap.
		/// </summary>
		/// <param name="myBM">Bitmap do draw ECG in.</param>
		/// <param name="signals">Signal data to draw (can change due to resampling).</param>
		/// <param name="dtRecordTime">Start time of recording</param>
		/// <param name="nTime">Start drawing at this sample number.</param>
		/// <param name="fmm_Per_s">mm per second</param>
		/// <param name="fmm_Per_mV">mm per mV</param>
		/// <param name="bAllowResample">True if resample of signal is allowed.</param>
		/// <returns>Sample number to start next draw ECG on.</returns>
		public static int DrawECG(Bitmap myBM, ECGDraw.GridType displayGrid, ECGSignals.Signals signals, DateTime dtRecordTime, int nTime, float fmm_Per_s, float fmm_Per_mV, bool bAllowResample)
		{
			return DrawECG(Graphics.FromImage(myBM), displayGrid, signals, dtRecordTime, nTime, fmm_Per_s, fmm_Per_mV, bAllowResample);
		}
		/// <summary>
		/// Function to draw an ECG on a bitmap.
		/// </summary>
		/// <param name="myGraphics">The drawing surface.</param>
		/// <param name="signals">Signal data to draw (can change due to resampling).</param>
		/// <param name="dtRecordTime">Start time of recording</param>
		/// <param name="nTime">Start drawing at this sample number.</param>
		/// <param name="fmm_Per_s">mm per second</param>
		/// <param name="fmm_Per_mV">mm per mV</param>
		/// <param name="bAllowResample">True if resample of signal is allowed.</param>
		/// <returns>Sample number to start next draw ECG on.</returns>
		public static int DrawECG(Graphics myGraphics, ECGDraw.GridType displayGrid, ECGSignals.Signals signals, DateTime dtRecordTime, int nTime, float fmm_Per_s, float fmm_Per_mV, bool bAllowResample)
		{
#if WINCE
			RectangleF Bounds = ClipBounds.IsEmpty ? myGraphics.ClipBounds : ClipBounds;
#else
			RectangleF Bounds = myGraphics.VisibleClipBounds;
#endif

			// begin: drawing of ECG.
			float
				fPixel_Per_ms = fmm_Per_s * DpiX * Inch_Per_mm * 0.001f,
				fPixel_Per_uV = fmm_Per_mV * DpiY * Inch_Per_mm * 0.001f,
				fLeadYSpace = _uV_Per_Channel * fPixel_Per_uV,
				fGridY = (DpiY * Inch_Per_mm) * _mm_Per_GridLine;

			int nMinX = 0,
				nMinY = (int) (_TextSize * DpiY * Inch_Per_mm * .4f),
				nMaxX,
				nMaxY;

			if ((myGraphics == null)
			||	(signals == null))
				return 0;

			if (Math.Ceiling((fLeadYSpace * signals.NrLeads) + fGridY) >= (Bounds.Height - nMinY))
			{
				fLeadYSpace = (float) Math.Floor(((Bounds.Height - nMinY - (fGridY * 2)) / signals.NrLeads) / fGridY) * fGridY;
			}

            DrawGrid(myGraphics, displayGrid, fLeadYSpace, signals.NrLeads, nMinX, nMinY, out nMaxX, out nMaxY);

			return DrawSignal(myGraphics, signals, dtRecordTime, true, nTime, fmm_Per_s, fmm_Per_mV, nMinX, nMinY, nMaxX, nMaxY, fPixel_Per_ms * 1000f, fPixel_Per_uV, fLeadYSpace, bAllowResample);
			// end: drawing of ECG.
		}
        /// <summary>
        /// Function to draw an ECG on a bitmap.
        /// </summary>
        /// <param name="myGraphics">The drawing surface.</param>
        /// <param name="signals">Signal data to draw (can change due to resampling).</param>
        /// <param name="dtRecordTime">Start time of recording</param>
        /// <param name="nTime">Start drawing at this sample number.</param>
        /// <param name="fmm_Per_s">mm per second</param>
        /// <param name="fmm_Per_mV">mm per mV</param>
        /// <param name="bAllowResample">True if resample of signal is allowed.</param>
        /// <returns>Sample number to start next draw ECG on.</returns>
        public static int DrawECG(IGraphics myGraphics, ECGDraw.GridType displayGrid, ECGSignals.Signals signals, DateTime dtRecordTime, int nTime, float fmm_Per_s, float fmm_Per_mV, bool bAllowResample)
        {
#if WINCE
			RectangleF Bounds = ClipBounds.IsEmpty ? myGraphics.ClipBounds : ClipBounds;
#else
            RectangleF Bounds = myGraphics.VisibleClipBounds;
#endif

            // begin: drawing of ECG.
            float
                fPixel_Per_ms = fmm_Per_s * DpiX * Inch_Per_mm * 0.001f,
                fPixel_Per_uV = fmm_Per_mV * DpiY * Inch_Per_mm * 0.001f,
                fLeadYSpace = _uV_Per_Channel * fPixel_Per_uV,
                fGridY = (DpiY * Inch_Per_mm) * _mm_Per_GridLine;

            int nMinX = 0,
                nMinY = (int)(_TextSize * DpiY * Inch_Per_mm * .4f),
                nMaxX,
                nMaxY;

            if ((myGraphics == null)
            || (signals == null))
                return 0;

            if (Math.Ceiling((fLeadYSpace * signals.NrLeads) + fGridY) >= (Bounds.Height - nMinY))
            {
                fLeadYSpace = (float)Math.Floor(((Bounds.Height - nMinY - (fGridY * 2)) / signals.NrLeads) / fGridY) * fGridY;
            }

            DrawGrid(myGraphics, displayGrid, fLeadYSpace, signals.NrLeads, nMinX, nMinY, out nMaxX, out nMaxY);

            return DrawSignal(myGraphics, signals, dtRecordTime, true, nTime, fmm_Per_s, fmm_Per_mV, nMinX, nMinY, nMaxX, nMaxY, fPixel_Per_ms * 1000f, fPixel_Per_uV, fLeadYSpace, bAllowResample);
            // end: drawing of ECG.
        }
        /// <summary>
		/// Enumaration for specific ECG draw types.
		/// </summary>
		public enum ECGDrawType
		{
			None				= 0x00,
			Regular				= 0x01,
			ThreeXFour			= 0x02,
			ThreeXFourPlusOne	= 0x04,
			ThreeXFourPlusThree	= 0x08,
			SixXTwo				= 0x10,
			Median				= 0x20

		}
		/// <summary>
		/// Function to determine the possible draw types.
		/// </summary>
		/// <param name="signals">signal to detemine draw types for</param>
		/// <returns>possible draw types</returns>
		public static ECGDrawType PossibleDrawTypes(ECGSignals.Signals signals)
		{
			ECGDrawType ret = ECGDrawType.None;

			if (signals != null)
			{
				ret = ECGDrawType.Regular;

				if (signals.IsTwelveLeads)
				{
					int start, end;

					signals.CalculateStartAndEnd(out start, out end);

					int length = (int) Math.Round((end - start) / (float)signals.RhythmSamplesPerSecond);

					if (length <= 12)
					{
						ret = ECGDrawType.Regular
							| ECGDrawType.ThreeXFour
							| ECGDrawType.ThreeXFourPlusOne
							| ECGDrawType.ThreeXFourPlusThree
							| ECGDrawType.SixXTwo;
					}

					if ((signals.MedianAVM != 0)
					&&	(signals.MedianSamplesPerSecond != 0)
					&&	(signals.MedianLength != 0))
						ret |= ECGDrawType.Median;
				}
			}

			return ret;
		}
		/// <summary>
		/// An ECGDrawSection object will describe a bit of signal on the image.
		/// </summary>
		public class ECGDrawSection
		{
			/// <summary>
			/// Constructor to draw an Calibration pulse.
			/// </summary>
			/// <param name="fmm_Per_mV">millimeters per milliVolt</param>
			/// <param name="x">position X on image in millimeters</param>
			/// <param name="y">position Y on image in millimeters</param>
			/// <param name="sps">samples per second</param>
			/// <param name="length">length in nr of 5 mm blocks</param>
			public ECGDrawSection(float fmm_Per_mV, float x, float y, int sps, int length)
			: this(false, fmm_Per_mV, x, y, sps, length) {}
			/// <summary>
			/// Constructor to draw provided sample data.
			/// (one sample is one pixel on the X-axis)
			/// </summary>
			/// <param name="fmm_Per_mV">millimeters per milliVolt</param>
			/// <param name="x">position X on image in millimeters</param>
			/// <param name="y">position Y on image in millimeters</param>
			/// <param name="leadType">type of the lead</param>
			/// <param name="avm">AVM of signal data</param>
			/// <param name="sps">samples per seconds of signal data</param>
			/// <param name="start">start point in signal data</param>
			/// <param name="end">end point in signal data</param>
			/// <param name="data">signal data</param>
			public ECGDrawSection(float fmm_Per_mV, float x, float y, LeadType leadType, double avm, int sps, int start, int end, short[] data)
			: this(false, fmm_Per_mV, x, y, leadType, avm, sps, start, end, data) {}
			/// <summary>
			/// Constructor to draw an Calibration pulse.
			/// </summary>
			/// <param name="bInPixels">x and y are in pixels if this value is true</param>
			/// <param name="fmm_Per_mV">millimeters per milliVolt</param>
			/// <param name="x">position X in pixels or millimeters</param>
			/// <param name="y">position Y in pixels or millimeters</param>
			/// <param name="sps">samples per second</param>
			/// <param name="length">length in nr of 5 mm blocks</param>
			public ECGDrawSection(bool bInPixels, float fmm_Per_mV, float x, float y, int sps, int length)
			{
				if (bInPixels)
				{
					_X = x;
					_Y = y;
				}
				else
				{
					_X = x * (DpiX * Inch_Per_mm) * _mm_Per_GridLine;
					_Y = y * (DpiY * Inch_Per_mm) * _mm_Per_GridLine;
				}

				_LeadType = LeadType.Unknown;
				_AVM = 1000.0f;
				_SamplesPerSecond = sps;
				_Start = 0;
				_End = length;
				_Data = null;
				_fmm_Per_mV = fmm_Per_mV;
			}

            /// <summary>
            /// Constructor to draw an Calibration pulse.
            /// </summary>
            /// <param name="fmm_Per_mV">millimeters per milliVolt</param>
            /// <param name="x">position X on image in millimeters</param>
            /// <param name="y">position Y on image in millimeters</param>
            /// <param name="sps">samples per second</param>
            /// <param name="length">length in nr of 5 mm blocks</param>
            public ECGDrawSection(float fmm_Per_mV, float x, float y, int sps, int length, float DotsPerInchX, float DotsPerInchY)
                : this(false, fmm_Per_mV, x, y, sps, length, DotsPerInchX, DotsPerInchY) { }

            public ECGDrawSection(bool bInPixels, float fmm_Per_mV, float x, float y, int sps, int length, float DotsPerInchX, float DotsPerInchY)
            {
                if (bInPixels)
                {
                    _X = x;
                    _Y = y;
                }
                else
                {
                    _X = x * (DotsPerInchX * Inch_Per_mm) * _mm_Per_GridLine;
                    _Y = y * (DotsPerInchY * Inch_Per_mm) * _mm_Per_GridLine;
                }

                _LeadType = LeadType.Unknown;
                _AVM = 1000.0f;
                _SamplesPerSecond = sps;
                _Start = 0;
                _End = length;
                _Data = null;
                _fmm_Per_mV = fmm_Per_mV;
            }
			/// <summary>
			/// Constructor to draw provided sample data.
			/// (one sample is one pixel on the X-axis)
			/// </summary>
			/// <param name="bInPixels">x and y are in pixels if this value is true</param>
			/// <param name="fmm_Per_mV">millimeters per milliVolt</param>
			/// <param name="x">position X in pixels or millimeters</param>
			/// <param name="y">position Y in pixels or millimeters</param>
			/// <param name="leadType">type of the lead</param>
			/// <param name="avm">AVM of signal data</param>
			/// <param name="sps">samples per seconds of signal data</param>
			/// <param name="start">start point in signal data</param>
			/// <param name="end">end point in signal data</param>
			/// <param name="data">signal data</param>
			public ECGDrawSection(bool bInPixels, float fmm_Per_mV, float x, float y, LeadType lt, double avm, int sps, int start, int end, short[] data)
			{
				if (bInPixels)
				{
					_X = x;
					_Y = y;
				}
				else
				{
					_X = x * (DpiX * Inch_Per_mm) * _mm_Per_GridLine;
					_Y = y * (DpiY * Inch_Per_mm) * _mm_Per_GridLine;
				}

				_LeadType = lt;
				_AVM = avm;
				_SamplesPerSecond = sps;
				_Start = start;
				_End = end;
				_Data = data;
				_fmm_Per_mV = fmm_Per_mV;
			}

            public ECGDrawSection(bool bInPixels, float fmm_Per_mV, float x, float y, LeadType lt, double avm, int sps, int start, int end, short[] data, float DotsPerInchX, float DotsPerInchY)
            {
                if (bInPixels)
                {
                    _X = x;
                    _Y = y;
                }
                else
                {
                    _X = x * (DotsPerInchX * Inch_Per_mm) * _mm_Per_GridLine;
                    _Y = y * (DotsPerInchY * Inch_Per_mm) * _mm_Per_GridLine;
                }

                _LeadType = lt;
                _AVM = avm;
                _SamplesPerSecond = sps;
                _Start = start;
                _End = end;
                _Data = data;
                _fmm_Per_mV = fmm_Per_mV;
            }

			private float _X;
			private float _Y;
			private LeadType _LeadType;
			private double _AVM; // AVM in uV
			private int _SamplesPerSecond;
			private int _Start;
			private int _End;
			private short[] _Data;
			private float _fmm_Per_mV;
			private Color _SignalColor = ECGDraw.SignalColor;

			/// <summary>
			/// set color that will be used to draw signal.
			/// </summary>
			public Color SignalColor
			{
				set
				{
					_SignalColor = value;
				}
			}

			public int DrawSignal(Graphics g)
			{
				float fPixel_Per_uV = _fmm_Per_mV * DpiY * Inch_Per_mm * 0.001f;

				Pen myPen = new Pen(_SignalColor);

				int length = _End - _Start + 1;

				if (_Data == null)
				{
					int end = (_SamplesPerSecond * _End) / 5;

					if (_End == 1)
					{
						DrawLine(g, myPen, _X, _Y, _X, _Y - (float) (_AVM * fPixel_Per_uV));
						DrawLine(g, myPen, _X, _Y - (float) (_AVM * fPixel_Per_uV), _X + end, _Y - (float) (_AVM * fPixel_Per_uV));
						DrawLine(g, myPen, _X + end, _Y - (float) (_AVM * fPixel_Per_uV), _X + end, _Y);
					}
					else
					{
						int a = ((end * 2) / 10),
							b = ((end * 7) / 10);

						DrawLine(g, myPen, _X, _Y, _X + a, _Y);
						DrawLine(g, myPen, _X + a, _Y, _X + a, _Y - (float) (_AVM * fPixel_Per_uV));
						DrawLine(g, myPen, _X + a, _Y - (float) (_AVM * fPixel_Per_uV), _X + b, _Y - (float) (_AVM * fPixel_Per_uV));
						DrawLine(g, myPen, _X + b, _Y - (float) (_AVM * fPixel_Per_uV), _X + b, _Y);
						DrawLine(g, myPen, _X + b, _Y, _X + end, _Y);
					}
				}
				else
				{
					if (_LeadType != ECGConversion.ECGSignals.LeadType.Unknown)
					{
						Font fontText = new Font("Verdana", _TextSize, FontStyle.Regular);
						SolidBrush solidBrush = new SolidBrush(TextColor);

						g.DrawString(
							_LeadType.ToString(),
							fontText,
							solidBrush,
							_X + 4.0f,
							_Y - (1250.0f * fPixel_Per_uV));

						solidBrush.Dispose();
						fontText.Dispose();
					}

					DrawLine(g, myPen, _X, _Y - (1000.0f * fPixel_Per_uV), _X, _Y - (1250.0f * fPixel_Per_uV));

					int t2=1;
					for (;t2 < length;t2++)
					{
						int t1 = t2 - 1;

						short
							y1 = short.MinValue,
							y2 = short.MinValue;

						if ((t1 >= 0)
						&&	(t2 <= (_End - _Start))
						&&	((t1 + _Start) >= 0)
						&&	((t2 + _Start) < _Data.Length))
						{
							y1 = _Data[t1 + _Start];
							y2 = _Data[t2 + _Start];
						}

						if ((y1 != short.MinValue)
						&&	(y2 != short.MinValue))
						{
							DrawLine(g, 
								myPen,
								_X + t1,
								_Y - (float) (y1 * _AVM * fPixel_Per_uV),
								_X + t2,
								_Y - (float) (y2 * _AVM * fPixel_Per_uV));
						}
					}

					t2--;

					DrawLine(g, myPen, _X + t2, _Y - (1000.0f * fPixel_Per_uV), _X + t2, _Y - (1250.0f * fPixel_Per_uV));
				}

				myPen.Dispose();

				return _End;
			}
            public int DrawSignal(IGraphics g)
            {
                float fPixel_Per_uV = _fmm_Per_mV * DpiY * Inch_Per_mm * 0.001f;

                Pen myPen = new Pen(_SignalColor);

                int length = _End - _Start + 1;

                if (_Data == null)
                {
                    int end = (_SamplesPerSecond * _End) / 5;

                    if (_End == 1)
                    {
                        DrawLine(g, myPen, _X, _Y, _X, _Y - (float)(_AVM * fPixel_Per_uV));
                        DrawLine(g, myPen, _X, _Y - (float)(_AVM * fPixel_Per_uV), _X + end, _Y - (float)(_AVM * fPixel_Per_uV));
                        DrawLine(g, myPen, _X + end, _Y - (float)(_AVM * fPixel_Per_uV), _X + end, _Y);
                    }
                    else
                    {
                        int a = ((end * 2) / 10),
                            b = ((end * 7) / 10);

                        DrawLine(g, myPen, _X, _Y, _X + a, _Y);
                        DrawLine(g, myPen, _X + a, _Y, _X + a, _Y - (float)(_AVM * fPixel_Per_uV));
                        DrawLine(g, myPen, _X + a, _Y - (float)(_AVM * fPixel_Per_uV), _X + b, _Y - (float)(_AVM * fPixel_Per_uV));
                        DrawLine(g, myPen, _X + b, _Y - (float)(_AVM * fPixel_Per_uV), _X + b, _Y);
                        DrawLine(g, myPen, _X + b, _Y, _X + end, _Y);
                    }
                }
                else
                {
                    if (_LeadType != ECGConversion.ECGSignals.LeadType.Unknown)
                    {
                        Font fontText = new Font("Verdana", _TextSize, FontStyle.Regular);
                        SolidBrush solidBrush = new SolidBrush(TextColor);

                        g.DrawString(
                            _LeadType.ToString(),
                            fontText,
                            solidBrush,
                            _X + 4.0f,
                            _Y - (1250.0f * fPixel_Per_uV));

                        solidBrush.Dispose();
                        fontText.Dispose();
                    }

                    DrawLine(g, myPen, _X, _Y - (1000.0f * fPixel_Per_uV), _X, _Y - (1250.0f * fPixel_Per_uV));

                    int t2 = 1;
                    for (; t2 < length; t2++)
                    {
                        int t1 = t2 - 1;

                        short
                            y1 = short.MinValue,
                            y2 = short.MinValue;

                        if ((t1 >= 0)
                        && (t2 <= (_End - _Start))
                        && ((t1 + _Start) >= 0)
                        && ((t2 + _Start) < _Data.Length))
                        {
                            y1 = _Data[t1 + _Start];
                            y2 = _Data[t2 + _Start];
                        }

                        if ((y1 != short.MinValue)
                        && (y2 != short.MinValue))
                        {
                            DrawLine(g,
                                myPen,
                                _X + t1,
                                _Y - (float)(y1 * _AVM * fPixel_Per_uV),
                                _X + t2,
                                _Y - (float)(y2 * _AVM * fPixel_Per_uV));
                        }
                    }

                    t2--;

                    DrawLine(g, myPen, _X + t2, _Y - (1000.0f * fPixel_Per_uV), _X + t2, _Y - (1250.0f * fPixel_Per_uV));
                }

                myPen.Dispose();

                return _End;
            }

            public int DrawSignal1(IGraphics g)
            {
                float fPixel_Per_uV = _fmm_Per_mV * 100 * Inch_Per_mm * 0.001f;

                Pen myPen = new Pen(_SignalColor, SignalPenWidth);
                myPen.EndCap = LineCap.Round;

                int length = _End - _Start + 1;

                if (_Data == null)
                {
                    int end = (_SamplesPerSecond * _End) / 5;

                    if (_End == 1)
                    {
                        DrawLine(g, myPen, _X, _Y, _X, _Y - (float)(_AVM * fPixel_Per_uV));
                        DrawLine(g, myPen, _X, _Y - (float)(_AVM * fPixel_Per_uV), _X + end, _Y - (float)(_AVM * fPixel_Per_uV));
                        DrawLine(g, myPen, _X + end, _Y - (float)(_AVM * fPixel_Per_uV), _X + end, _Y);
                    }
                    else
                    {
                        int a = ((end * 2) / 10),
                            b = ((end * 7) / 10);

                        int startX = 0;
                        int endX = end;

                        // Start from second line of the first grid box.
                        startX = end / 10;

                        // End before Fourth line of the second grid box.
                        endX = startX * 8;

                        DrawLine(g, myPen, _X, _Y, _X + a, _Y);
                        DrawLine(g, myPen, _X + a, _Y, _X + a, _Y - (float)(_AVM * fPixel_Per_uV));
                        DrawLine(g, myPen, _X + a, _Y - (float)(_AVM * fPixel_Per_uV), _X + b, _Y - (float)(_AVM * fPixel_Per_uV));
                        DrawLine(g, myPen, _X + b, _Y - (float)(_AVM * fPixel_Per_uV), _X + b, _Y);
                        DrawLine(g, myPen, _X + b, _Y, _X + end, _Y);
                    }
                }
                else
                {
                    if (_LeadType != ECGConversion.ECGSignals.LeadType.Unknown)
                    {
                        Font fontText = new Font("Verdana", _TextSize, FontStyle.Regular);
                        SolidBrush solidBrush = new SolidBrush(TextColor);

                        g.DrawString(
                            _LeadType.ToString(),
                            fontText,
                            solidBrush,
                            _X + 4.0f,
                            _Y - (1250.0f * fPixel_Per_uV));

                        solidBrush.Dispose();
                        fontText.Dispose();
                    }

                    DrawLine(g, myPen, _X, _Y - (1000.0f * fPixel_Per_uV), _X, _Y - (1250.0f * fPixel_Per_uV));

                    int t2 = 1;
                    for (; t2 < length; t2++)
                    {
                        int t1 = t2 - 1;

                        short
                            y1 = short.MinValue,
                            y2 = short.MinValue;

                        if ((t1 >= 0)
                        && (t2 <= (_End - _Start))
                        && ((t1 + _Start) >= 0)
                        && ((t2 + _Start) < _Data.Length))
                        {
                            y1 = _Data[t1 + _Start];
                            y2 = _Data[t2 + _Start];
                        }

                        if ((y1 != short.MinValue)
                        && (y2 != short.MinValue))
                        {
                            DrawLine(g,
                                myPen,
                                _X + t1,
                                _Y - (float)(y1 * _AVM * fPixel_Per_uV),
                                _X + t2,
                                _Y - (float)(y2 * _AVM * fPixel_Per_uV));
                        }
                    }

                    t2--;

                    DrawLine(g, myPen, _X + t2, _Y - (1000.0f * fPixel_Per_uV), _X + t2, _Y - (1250.0f * fPixel_Per_uV));
                }

                myPen.Dispose();

                return _End;
            }
        }
		/// <summary>
		/// Function to draw an ECG using a certain draw type.
		/// </summary>
		/// <param name="myGraphics">graphics object to draw with.</param>
		/// <param name="signals">signal data.</param>
		/// <param name="dt">Draw type of ECG.</param>
		/// <param name="nTime">Start drawing at this sample number.</param>
		/// <param name="fmm_Per_s">mm per second</param>
		/// <param name="fmm_Per_mV">mm per mV</param>
		/// <param name="bAllowResample">True if resample of signal is allowed.</param>
		/// <returns>Sample number to start next draw ECG on.</returns>
		public static int DrawECG(Graphics myGraphics, ECGDraw.GridType displayGrid, ECGSignals.Signals signals, ECGDrawType dt, int nTime, float fmm_Per_s, float fmm_Per_mV, bool bAllowResample)
		{
			if (myGraphics == null)
				return -1;

			if (signals == null)
				return -2;

			if ((PossibleDrawTypes(signals) & dt) == 0)
				return -3;

			int ret = 0;

			float
				fPixel_Per_s = (float)Math.Round(fmm_Per_s * DpiX * Inch_Per_mm), 
				fPixel_Per_ms = fPixel_Per_s * 0.001f,
				fPixel_Per_uV = fmm_Per_mV * DpiY * Inch_Per_mm * 0.001f,
				fLeadYSpace = _uV_Per_Channel * fPixel_Per_uV,
				fGridX = (DpiX * Inch_Per_mm) * _mm_Per_GridLine,
				fGridY = (DpiY * Inch_Per_mm) * _mm_Per_GridLine;

			int nMinX = 0,
				nMinY = 0,
				nMaxX = 52,
				nMaxY = 32;

			if (signals.IsBuffered)
			{
				BufferedSignals bs = signals.AsBufferedSignals;

				int nrSamplesToLoad = 10 * bs.RealRhythmSamplesPerSecond,
					value = bs.RealRhythmStart + nTime;

				if (dt == ECGDrawType.Regular)
				{
#if WINCE
					RectangleF Bounds = ClipBounds.IsEmpty ? myGraphics.ClipBounds : ClipBounds;
#else
					RectangleF Bounds = myGraphics.VisibleClipBounds;
#endif

					nrSamplesToLoad = (int) ((Bounds.Width * bs.RealRhythmSamplesPerSecond) / fPixel_Per_s);
				}
				
				bs.LoadSignal(value, value + nrSamplesToLoad);
				
				nTime -= value;
			}

			ECGDrawSection[] drawSections = null;

			int nOldSamplesPerSecond = 0;

			// begin: resample signals to fit. (using a dirty solution)
			if (((dt != ECGDrawType.Median)
			&&	 (signals.RhythmSamplesPerSecond != (int) fPixel_Per_s))
			||	((dt == ECGDrawType.Median)
			&&	 (signals.MedianSamplesPerSecond != (int) fPixel_Per_s)))
			{
				if (!bAllowResample)
				{
					nOldSamplesPerSecond = (dt == ECGDrawType.Median) ? signals.MedianSamplesPerSecond : signals.RhythmSamplesPerSecond;
					signals = signals.Clone();
				}

				// You should note that if signal is already resampled, but dpi changes the new signal
				// will be resampled based on already resampled information instead of reloading from
				// orignal.
				int RI = ECGConversion.ECGTool.ResampleInterval;
				ECGConversion.ECGTool.ResampleInterval /= DirtSolutionFactor;
				for (int i=0;i < signals.NrLeads;i++)
				{
					ECGTool.ResampleLead(signals[i].Rhythm, (int) signals.RhythmSamplesPerSecond * DirtSolutionFactor, (int) (fPixel_Per_s * DirtSolutionFactor), out signals[i].Rhythm);

					if ((signals.MedianSamplesPerSecond != 0)
					&&	(signals[i].Median != null))
						ECGTool.ResampleLead(signals[i].Median, (int) signals.MedianSamplesPerSecond * DirtSolutionFactor, (int) (fPixel_Per_s * DirtSolutionFactor), out signals[i].Median);

					signals[i].RhythmStart = (signals[i].RhythmStart * (int) (fPixel_Per_s * DirtSolutionFactor)) / (int) (signals.RhythmSamplesPerSecond * DirtSolutionFactor);
					signals[i].RhythmEnd = (signals[i].RhythmEnd * (int) (fPixel_Per_s * DirtSolutionFactor)) / (int) (signals.RhythmSamplesPerSecond * DirtSolutionFactor);
				}
				ECGConversion.ECGTool.ResampleInterval = RI;

				nTime = (nTime * (int) (fPixel_Per_s * DirtSolutionFactor)) / (int) (signals.RhythmSamplesPerSecond * DirtSolutionFactor);

				// set new rhythm per samples.
				signals.RhythmSamplesPerSecond = (int) fPixel_Per_s;
				if (signals.MedianSamplesPerSecond != 0)
					signals.MedianSamplesPerSecond = (int) fPixel_Per_s;
			}

			switch (dt)
			{
				case ECGDrawType.Regular:
				{
#if WINCE
					RectangleF Bounds = ClipBounds.IsEmpty ? myGraphics.ClipBounds : ClipBounds;
#else
					RectangleF Bounds = myGraphics.VisibleClipBounds;
#endif
					nMinY = (int) (_TextSize * DpiY * Inch_Per_mm * .4f);

					// begin: drawing of ECG.
					if (Math.Ceiling(fLeadYSpace * signals.NrLeads) >= (Bounds.Height - nMinY))
					{
						fLeadYSpace = (float) Math.Floor(((Bounds.Height - nMinY - fGridY) / signals.NrLeads) / fGridY) * fGridY;
					}

                    DrawGrid(myGraphics, displayGrid, fLeadYSpace, signals.NrLeads, nMinX, nMinY, out nMaxX, out nMaxY);

					ret = DrawSignal(myGraphics, signals, DateTime.MinValue, false, nTime, fmm_Per_s, fmm_Per_mV, nMinX, nMinY, nMaxX, nMaxY, fPixel_Per_ms * 1000f, fPixel_Per_uV, fLeadYSpace, bAllowResample);
				}
					break;
				case ECGDrawType.SixXTwo:
				{
					drawSections = new ECGDrawSection[18];

					int a = nTime,
						b = (5 * signals.RhythmSamplesPerSecond) + nTime,
						c = (10 * signals.RhythmSamplesPerSecond) + nTime;

					drawSections[ 0] = new ECGDrawSection(true, fmm_Per_mV, 0.0f,  2.5f * fGridY, signals.RhythmSamplesPerSecond, 2);
					drawSections[ 1] = new ECGDrawSection(true, fmm_Per_mV, 0.0f,  8.0f * fGridY, signals.RhythmSamplesPerSecond, 2);
					drawSections[ 2] = new ECGDrawSection(true, fmm_Per_mV, 0.0f, 13.5f * fGridY, signals.RhythmSamplesPerSecond, 2);
					drawSections[ 3] = new ECGDrawSection(true, fmm_Per_mV, 0.0f, 19.0f * fGridY, signals.RhythmSamplesPerSecond, 2);
					drawSections[ 4] = new ECGDrawSection(true, fmm_Per_mV, 0.0f, 24.5f * fGridY, signals.RhythmSamplesPerSecond, 2);
					drawSections[ 5] = new ECGDrawSection(true, fmm_Per_mV, 0.0f, 30.0f * fGridY, signals.RhythmSamplesPerSecond, 2);

					drawSections[ 6] = new ECGDrawSection(true, fmm_Per_mV,  2 * fGridX,  2.5f * fGridY, signals[ 0].Type, signals.RhythmAVM, signals.RhythmSamplesPerSecond, a, b, signals[ 0].Rhythm);
					drawSections[ 7] = new ECGDrawSection(true, fmm_Per_mV,  2 * fGridX,  8.0f * fGridY, signals[ 1].Type, signals.RhythmAVM, signals.RhythmSamplesPerSecond, a, b, signals[ 1].Rhythm);
					drawSections[ 8] = new ECGDrawSection(true, fmm_Per_mV,  2 * fGridX, 13.5f * fGridY, signals[ 2].Type, signals.RhythmAVM, signals.RhythmSamplesPerSecond, a, b, signals[ 2].Rhythm);
					drawSections[ 9] = new ECGDrawSection(true, fmm_Per_mV,  2 * fGridX, 19.0f * fGridY, signals[ 3].Type, signals.RhythmAVM, signals.RhythmSamplesPerSecond, a, b, signals[ 3].Rhythm);
					drawSections[10] = new ECGDrawSection(true, fmm_Per_mV,  2 * fGridX, 24.5f * fGridY, signals[ 4].Type, signals.RhythmAVM, signals.RhythmSamplesPerSecond, a, b, signals[ 4].Rhythm);
					drawSections[11] = new ECGDrawSection(true, fmm_Per_mV,  2 * fGridX, 30.0f * fGridY, signals[ 5].Type, signals.RhythmAVM, signals.RhythmSamplesPerSecond, a, b, signals[ 5].Rhythm);

					drawSections[12] = new ECGDrawSection(true, fmm_Per_mV, 27 * fGridX,  2.5f * fGridY, signals[ 6].Type, signals.RhythmAVM, signals.RhythmSamplesPerSecond, b, c, signals[ 6].Rhythm);
					drawSections[13] = new ECGDrawSection(true, fmm_Per_mV, 27 * fGridX,  8.0f * fGridY, signals[ 7].Type, signals.RhythmAVM, signals.RhythmSamplesPerSecond, b, c, signals[ 7].Rhythm);
					drawSections[14] = new ECGDrawSection(true, fmm_Per_mV, 27 * fGridX, 13.5f * fGridY, signals[ 8].Type, signals.RhythmAVM, signals.RhythmSamplesPerSecond, b, c, signals[ 8].Rhythm);
					drawSections[15] = new ECGDrawSection(true, fmm_Per_mV, 27 * fGridX, 19.0f * fGridY, signals[ 9].Type, signals.RhythmAVM, signals.RhythmSamplesPerSecond, b, c, signals[ 9].Rhythm);
					drawSections[16] = new ECGDrawSection(true, fmm_Per_mV, 27 * fGridX, 24.5f * fGridY, signals[10].Type, signals.RhythmAVM, signals.RhythmSamplesPerSecond, b, c, signals[10].Rhythm);
					drawSections[17] = new ECGDrawSection(true, fmm_Per_mV, 27 * fGridX, 30.0f * fGridY, signals[11].Type, signals.RhythmAVM, signals.RhythmSamplesPerSecond, b, c, signals[11].Rhythm);
				}
					break;
				case ECGDrawType.ThreeXFour:
				{
					drawSections = new ECGDrawSection[15];

					int	a = nTime,
						b = (int) (2.5f * signals.RhythmSamplesPerSecond) + nTime,
						c = (5 * signals.RhythmSamplesPerSecond) + nTime,
						d = (int) (7.5f * signals.RhythmSamplesPerSecond) + nTime,
						e = (10 * signals.RhythmSamplesPerSecond) + nTime;

					drawSections[ 0] = new ECGDrawSection(true, fmm_Per_mV, 0.0f,  5.0f * fGridY, signals.RhythmSamplesPerSecond, 2);
					drawSections[ 1] = new ECGDrawSection(true, fmm_Per_mV, 0.0f, 16.0f * fGridY, signals.RhythmSamplesPerSecond, 2);
					drawSections[ 2] = new ECGDrawSection(true, fmm_Per_mV, 0.0f, 27.0f * fGridY, signals.RhythmSamplesPerSecond, 2);

					drawSections[ 3] = new ECGDrawSection(true, fmm_Per_mV,  2.0f * fGridX,  5.0f * fGridY, signals[ 0].Type, signals.RhythmAVM, signals.RhythmSamplesPerSecond, a, b, signals[ 0].Rhythm);
					drawSections[ 4] = new ECGDrawSection(true, fmm_Per_mV,  2.0f * fGridX, 16.0f * fGridY, signals[ 1].Type, signals.RhythmAVM, signals.RhythmSamplesPerSecond, a, b, signals[ 1].Rhythm);
					drawSections[ 5] = new ECGDrawSection(true, fmm_Per_mV,  2.0f * fGridX, 27.0f * fGridY, signals[ 2].Type, signals.RhythmAVM, signals.RhythmSamplesPerSecond, a, b, signals[ 2].Rhythm);

					drawSections[ 6] = new ECGDrawSection(true, fmm_Per_mV, 14.5f * fGridX,  5.0f * fGridY, signals[ 3].Type, signals.RhythmAVM, signals.RhythmSamplesPerSecond, b, c, signals[ 3].Rhythm);
					drawSections[ 7] = new ECGDrawSection(true, fmm_Per_mV, 14.5f * fGridX, 16.0f * fGridY, signals[ 4].Type, signals.RhythmAVM, signals.RhythmSamplesPerSecond, b, c, signals[ 4].Rhythm);
					drawSections[ 8] = new ECGDrawSection(true, fmm_Per_mV, 14.5f * fGridX, 27.0f * fGridY, signals[ 5].Type, signals.RhythmAVM, signals.RhythmSamplesPerSecond, b, c, signals[ 5].Rhythm);

					drawSections[ 9] = new ECGDrawSection(true, fmm_Per_mV, 27.0f * fGridX,  5.0f * fGridY, signals[ 6].Type, signals.RhythmAVM, signals.RhythmSamplesPerSecond, c, d, signals[ 6].Rhythm);
					drawSections[10] = new ECGDrawSection(true, fmm_Per_mV, 27.0f * fGridX, 16.0f * fGridY, signals[ 7].Type, signals.RhythmAVM, signals.RhythmSamplesPerSecond, c, d, signals[ 7].Rhythm);
					drawSections[11] = new ECGDrawSection(true, fmm_Per_mV, 27.0f * fGridX, 27.0f * fGridY, signals[ 8].Type, signals.RhythmAVM, signals.RhythmSamplesPerSecond, c, d, signals[ 8].Rhythm);

					drawSections[12] = new ECGDrawSection(true, fmm_Per_mV, 39.5f * fGridX,  5.0f * fGridY, signals[ 9].Type, signals.RhythmAVM, signals.RhythmSamplesPerSecond, d, e, signals[ 9].Rhythm);
					drawSections[13] = new ECGDrawSection(true, fmm_Per_mV, 39.5f * fGridX, 16.0f * fGridY, signals[10].Type, signals.RhythmAVM, signals.RhythmSamplesPerSecond, d, e, signals[10].Rhythm);
					drawSections[14] = new ECGDrawSection(true, fmm_Per_mV, 39.5f * fGridX, 27.0f * fGridY, signals[11].Type, signals.RhythmAVM, signals.RhythmSamplesPerSecond, d, e, signals[11].Rhythm);
				}
					break;
				case ECGDrawType.ThreeXFourPlusOne:
				{
					drawSections = new ECGDrawSection[17];

					int	a = nTime,
						b = (int) (2.5f * signals.RhythmSamplesPerSecond) + nTime,
						c = (5 * signals.RhythmSamplesPerSecond) + nTime,
						d = (int) (7.5f * signals.RhythmSamplesPerSecond) + nTime,
						e = (10 * signals.RhythmSamplesPerSecond) + nTime;

					drawSections[ 0] = new ECGDrawSection(true, fmm_Per_mV, 0.0f,  4.0f * fGridY, signals.RhythmSamplesPerSecond, 2);
					drawSections[ 1] = new ECGDrawSection(true, fmm_Per_mV, 0.0f, 12.0f * fGridY, signals.RhythmSamplesPerSecond, 2);
					drawSections[ 2] = new ECGDrawSection(true, fmm_Per_mV, 0.0f, 20.0f * fGridY, signals.RhythmSamplesPerSecond, 2);
					drawSections[ 3] = new ECGDrawSection(true, fmm_Per_mV, 0.0f, 28.0f * fGridY, signals.RhythmSamplesPerSecond, 2);

					drawSections[ 4] = new ECGDrawSection(true, fmm_Per_mV,  2.0f * fGridX,  4.0f * fGridY, signals[ 0].Type, signals.RhythmAVM, signals.RhythmSamplesPerSecond, a, b, signals[ 0].Rhythm);
					drawSections[ 5] = new ECGDrawSection(true, fmm_Per_mV,  2.0f * fGridX, 12.0f * fGridY, signals[ 1].Type, signals.RhythmAVM, signals.RhythmSamplesPerSecond, a, b, signals[ 1].Rhythm);
					drawSections[ 6] = new ECGDrawSection(true, fmm_Per_mV,  2.0f * fGridX, 20.0f * fGridY, signals[ 2].Type, signals.RhythmAVM, signals.RhythmSamplesPerSecond, a, b, signals[ 2].Rhythm);

					drawSections[ 7] = new ECGDrawSection(true, fmm_Per_mV, 14.5f * fGridX,  4.0f * fGridY, signals[ 3].Type, signals.RhythmAVM, signals.RhythmSamplesPerSecond, b, c, signals[ 3].Rhythm);
					drawSections[ 8] = new ECGDrawSection(true, fmm_Per_mV, 14.5f * fGridX, 12.0f * fGridY, signals[ 4].Type, signals.RhythmAVM, signals.RhythmSamplesPerSecond, b, c, signals[ 4].Rhythm);
					drawSections[ 9] = new ECGDrawSection(true, fmm_Per_mV, 14.5f * fGridX, 20.0f * fGridY, signals[ 5].Type, signals.RhythmAVM, signals.RhythmSamplesPerSecond, b, c, signals[ 5].Rhythm);

					drawSections[10] = new ECGDrawSection(true, fmm_Per_mV, 27.0f * fGridX,  4.0f * fGridY, signals[ 6].Type, signals.RhythmAVM, signals.RhythmSamplesPerSecond, c, d, signals[ 6].Rhythm);
					drawSections[11] = new ECGDrawSection(true, fmm_Per_mV, 27.0f * fGridX, 12.0f * fGridY, signals[ 7].Type, signals.RhythmAVM, signals.RhythmSamplesPerSecond, c, d, signals[ 7].Rhythm);
					drawSections[12] = new ECGDrawSection(true, fmm_Per_mV, 27.0f * fGridX, 20.0f * fGridY, signals[ 8].Type, signals.RhythmAVM, signals.RhythmSamplesPerSecond, c, d, signals[ 8].Rhythm);

					drawSections[13] = new ECGDrawSection(true, fmm_Per_mV, 39.5f * fGridX,  4.0f * fGridY, signals[ 9].Type, signals.RhythmAVM, signals.RhythmSamplesPerSecond, d, e, signals[ 9].Rhythm);
					drawSections[14] = new ECGDrawSection(true, fmm_Per_mV, 39.5f * fGridX, 12.0f * fGridY, signals[10].Type, signals.RhythmAVM, signals.RhythmSamplesPerSecond, d, e, signals[10].Rhythm);
					drawSections[15] = new ECGDrawSection(true, fmm_Per_mV, 39.5f * fGridX, 20.0f * fGridY, signals[11].Type, signals.RhythmAVM, signals.RhythmSamplesPerSecond, d, e, signals[11].Rhythm);

					drawSections[16] = new ECGDrawSection(true, fmm_Per_mV,  2.0f * fGridX, 28.0f * fGridY, signals[ 1].Type, signals.RhythmAVM, signals.RhythmSamplesPerSecond, a, e, signals[ 1].Rhythm);
				}
					break;
				case ECGDrawType.ThreeXFourPlusThree:
				{
					drawSections = new ECGDrawSection[21];

					int	a = nTime,
						b = (int) (2.5f * signals.RhythmSamplesPerSecond) + nTime,
						c = (5 * signals.RhythmSamplesPerSecond) + nTime,
						d = (int) (7.5f * signals.RhythmSamplesPerSecond) + nTime,
						e = (10 * signals.RhythmSamplesPerSecond) + nTime;

					drawSections[ 0] = new ECGDrawSection(true, fmm_Per_mV, 0.0f,  2.5f * fGridY, signals.RhythmSamplesPerSecond, 2);
					drawSections[ 1] = new ECGDrawSection(true, fmm_Per_mV, 0.0f,  8.0f * fGridY, signals.RhythmSamplesPerSecond, 2);
					drawSections[ 2] = new ECGDrawSection(true, fmm_Per_mV, 0.0f, 13.5f * fGridY, signals.RhythmSamplesPerSecond, 2);
					drawSections[ 3] = new ECGDrawSection(true, fmm_Per_mV, 0.0f, 19.0f * fGridY, signals.RhythmSamplesPerSecond, 2);
					drawSections[ 4] = new ECGDrawSection(true, fmm_Per_mV, 0.0f, 24.0f * fGridY, signals.RhythmSamplesPerSecond, 2);
					drawSections[ 5] = new ECGDrawSection(true, fmm_Per_mV, 0.0f, 29.5f * fGridY, signals.RhythmSamplesPerSecond, 2);

					drawSections[ 6] = new ECGDrawSection(true, fmm_Per_mV,  2.0f * fGridX,  2.5f * fGridY, signals[ 0].Type, signals.RhythmAVM, signals.RhythmSamplesPerSecond, a, b, signals[ 0].Rhythm);
					drawSections[ 7] = new ECGDrawSection(true, fmm_Per_mV,  2.0f * fGridX,  8.0f * fGridY, signals[ 1].Type, signals.RhythmAVM, signals.RhythmSamplesPerSecond, a, b, signals[ 1].Rhythm);
					drawSections[ 8] = new ECGDrawSection(true, fmm_Per_mV,  2.0f * fGridX, 13.5f * fGridY, signals[ 2].Type, signals.RhythmAVM, signals.RhythmSamplesPerSecond, a, b, signals[ 2].Rhythm);

					drawSections[ 9] = new ECGDrawSection(true, fmm_Per_mV, 14.5f * fGridX,  2.5f * fGridY, signals[ 3].Type, signals.RhythmAVM, signals.RhythmSamplesPerSecond, b, c, signals[ 3].Rhythm);
					drawSections[10] = new ECGDrawSection(true, fmm_Per_mV, 14.5f * fGridX,  8.0f * fGridY, signals[ 4].Type, signals.RhythmAVM, signals.RhythmSamplesPerSecond, b, c, signals[ 4].Rhythm);
					drawSections[11] = new ECGDrawSection(true, fmm_Per_mV, 14.5f * fGridX, 13.5f * fGridY, signals[ 5].Type, signals.RhythmAVM, signals.RhythmSamplesPerSecond, b, c, signals[ 5].Rhythm);

					drawSections[12] = new ECGDrawSection(true, fmm_Per_mV, 27.0f * fGridX,  2.5f * fGridY, signals[ 6].Type, signals.RhythmAVM, signals.RhythmSamplesPerSecond, c, d, signals[ 6].Rhythm);
					drawSections[13] = new ECGDrawSection(true, fmm_Per_mV, 27.0f * fGridX,  8.0f * fGridY, signals[ 7].Type, signals.RhythmAVM, signals.RhythmSamplesPerSecond, c, d, signals[ 7].Rhythm);
					drawSections[14] = new ECGDrawSection(true, fmm_Per_mV, 27.0f * fGridX, 13.5f * fGridY, signals[ 8].Type, signals.RhythmAVM, signals.RhythmSamplesPerSecond, c, d, signals[ 8].Rhythm);

					drawSections[15] = new ECGDrawSection(true, fmm_Per_mV, 39.5f * fGridX,  2.5f * fGridY, signals[ 9].Type, signals.RhythmAVM, signals.RhythmSamplesPerSecond, d, e, signals[ 9].Rhythm);
					drawSections[16] = new ECGDrawSection(true, fmm_Per_mV, 39.5f * fGridX,  8.0f * fGridY, signals[10].Type, signals.RhythmAVM, signals.RhythmSamplesPerSecond, d, e, signals[10].Rhythm);
					drawSections[17] = new ECGDrawSection(true, fmm_Per_mV, 39.5f * fGridX, 13.5f * fGridY, signals[11].Type, signals.RhythmAVM, signals.RhythmSamplesPerSecond, d, e, signals[11].Rhythm);

					drawSections[18] = new ECGDrawSection(true, fmm_Per_mV, 2.0f * fGridX, 19.0f * fGridY, signals[ 1].Type, signals.RhythmAVM, signals.RhythmSamplesPerSecond, a, e, signals[ 1].Rhythm);
					drawSections[19] = new ECGDrawSection(true, fmm_Per_mV, 2.0f * fGridX, 24.0f * fGridY, signals[ 7].Type, signals.RhythmAVM, signals.RhythmSamplesPerSecond, a, e, signals[ 7].Rhythm);
					drawSections[20] = new ECGDrawSection(true, fmm_Per_mV, 2.0f * fGridX, 29.5f * fGridY, signals[10].Type, signals.RhythmAVM, signals.RhythmSamplesPerSecond, a, e, signals[10].Rhythm);
				}
					break;
				case ECGDrawType.Median:
				{
					drawSections = new ECGDrawSection[15];

					int	a = nTime,
						b = ((signals.MedianLength * signals.MedianSamplesPerSecond) / 1000) + nTime + 1;

					drawSections[ 0] = new ECGDrawSection(true, fmm_Per_mV, 0.0f,  5.0f * fGridY, signals.MedianSamplesPerSecond, 2);
					drawSections[ 1] = new ECGDrawSection(true, fmm_Per_mV, 0.0f, 16.0f * fGridY, signals.MedianSamplesPerSecond, 2);
					drawSections[ 2] = new ECGDrawSection(true, fmm_Per_mV, 0.0f, 27.0f * fGridY, signals.MedianSamplesPerSecond, 2);

					drawSections[ 3] = new ECGDrawSection(true, fmm_Per_mV,  4.0f * fGridX,  5.0f * fGridY, signals[ 0].Type, signals.MedianAVM, signals.MedianSamplesPerSecond, a, b, signals[ 0].Median);
					drawSections[ 4] = new ECGDrawSection(true, fmm_Per_mV,  4.0f * fGridX, 16.0f * fGridY, signals[ 1].Type, signals.MedianAVM, signals.MedianSamplesPerSecond, a, b, signals[ 1].Median);
					drawSections[ 5] = new ECGDrawSection(true, fmm_Per_mV,  4.0f * fGridX, 27.0f * fGridY, signals[ 2].Type, signals.MedianAVM, signals.MedianSamplesPerSecond, a, b, signals[ 2].Median);

					drawSections[ 6] = new ECGDrawSection(true, fmm_Per_mV, 17.0f * fGridX,  5.0f * fGridY, signals[ 3].Type, signals.MedianAVM, signals.MedianSamplesPerSecond, a, b, signals[ 3].Median);
					drawSections[ 7] = new ECGDrawSection(true, fmm_Per_mV, 17.0f * fGridX, 16.0f * fGridY, signals[ 4].Type, signals.MedianAVM, signals.MedianSamplesPerSecond, a, b, signals[ 4].Median);
					drawSections[ 8] = new ECGDrawSection(true, fmm_Per_mV, 17.0f * fGridX, 27.0f * fGridY, signals[ 5].Type, signals.MedianAVM, signals.MedianSamplesPerSecond, a, b, signals[ 5].Median);

					drawSections[ 9] = new ECGDrawSection(true, fmm_Per_mV, 30.0f * fGridX,  5.0f * fGridY, signals[ 6].Type, signals.MedianAVM, signals.MedianSamplesPerSecond, a, b, signals[ 6].Median);
					drawSections[10] = new ECGDrawSection(true, fmm_Per_mV, 30.0f * fGridX, 16.0f * fGridY, signals[ 7].Type, signals.MedianAVM, signals.MedianSamplesPerSecond, a, b, signals[ 7].Median);
					drawSections[11] = new ECGDrawSection(true, fmm_Per_mV, 30.0f * fGridX, 27.0f * fGridY, signals[ 8].Type, signals.MedianAVM, signals.MedianSamplesPerSecond, a, b, signals[ 8].Median);

					drawSections[12] = new ECGDrawSection(true, fmm_Per_mV, 43.0f * fGridX,  5.0f * fGridY, signals[ 9].Type, signals.MedianAVM, signals.MedianSamplesPerSecond, a, b, signals[ 9].Median);
					drawSections[13] = new ECGDrawSection(true, fmm_Per_mV, 43.0f * fGridX, 16.0f * fGridY, signals[10].Type, signals.MedianAVM, signals.MedianSamplesPerSecond, a, b, signals[10].Median);
					drawSections[14] = new ECGDrawSection(true, fmm_Per_mV, 43.0f * fGridX, 27.0f * fGridY, signals[11].Type, signals.MedianAVM, signals.MedianSamplesPerSecond, a, b, signals[11].Median);
				}
					break;
				default:
					ret = -4;
					break;
			}

			if (drawSections != null)
			{
				Font fontText = new Font("Verdana", _TextSize, FontStyle.Regular);
				SolidBrush solidBrush = new SolidBrush(TextColor);

                ret = DrawECG(myGraphics, displayGrid, drawSections, nMinX, nMinY, nMaxX, nMaxY);

				if (ret < 0)
					return ret;

				if (DisplayInfo)
				{
					string tempInfo = fmm_Per_s + "mm/s, " + fmm_Per_mV + "mm/mV";

					myGraphics.DrawString(
						tempInfo,
						fontText,
						solidBrush,
						(nMaxX * fGridX) - myGraphics.MeasureString(tempInfo, fontText).Width,
						(nMaxY * fGridY));
				}

				fontText.Dispose();
				solidBrush.Dispose();
			}

			if (!bAllowResample
			&&  (nOldSamplesPerSecond != 0))
			{
				ret = (int) (((long)ret * (long)nOldSamplesPerSecond) / (long)signals.RhythmSamplesPerSecond);
			}

			return ret;
		}
        public static int DrawECG(IGraphics myGraphics, ECGDraw.GridType displayGrid, ECGSignals.Signals signals, ECGDrawType dt, int nTime, float fmm_Per_s, float fmm_Per_mV, bool bAllowResample)
        {
            if (myGraphics == null)
                return -1;

            if (signals == null)
                return -2;

            if ((PossibleDrawTypes(signals) & dt) == 0)
                return -3;

            int ret = 0;

            float
                fPixel_Per_s = (float)Math.Round(fmm_Per_s * DpiX * Inch_Per_mm),
                fPixel_Per_ms = fPixel_Per_s * 0.001f,
                fPixel_Per_uV = fmm_Per_mV * DpiY * Inch_Per_mm * 0.001f,
                fLeadYSpace = _uV_Per_Channel * fPixel_Per_uV,
                fGridX = (DpiX * Inch_Per_mm) * _mm_Per_GridLine,
                fGridY = (DpiY * Inch_Per_mm) * _mm_Per_GridLine;

            int nMinX = 0,
                nMinY = 0,
                nMaxX = 52,
                nMaxY = 32;

            if (signals.IsBuffered)
            {
                BufferedSignals bs = signals.AsBufferedSignals;

                int nrSamplesToLoad = 10 * bs.RealRhythmSamplesPerSecond,
                    value = bs.RealRhythmStart + nTime;

                if (dt == ECGDrawType.Regular)
                {
#if WINCE
					RectangleF Bounds = ClipBounds.IsEmpty ? myGraphics.ClipBounds : ClipBounds;
#else
                    RectangleF Bounds = myGraphics.VisibleClipBounds;
#endif

                    nrSamplesToLoad = (int)((Bounds.Width * bs.RealRhythmSamplesPerSecond) / fPixel_Per_s);
                }

                bs.LoadSignal(value, value + nrSamplesToLoad);

                nTime -= value;
            }

            ECGDrawSection[] drawSections = null;

            int nOldSamplesPerSecond = 0;

            // begin: resample signals to fit. (using a dirty solution)
            if (((dt != ECGDrawType.Median)
            && (signals.RhythmSamplesPerSecond != (int)fPixel_Per_s))
            || ((dt == ECGDrawType.Median)
            && (signals.MedianSamplesPerSecond != (int)fPixel_Per_s)))
            {
                if (!bAllowResample)
                {
                    nOldSamplesPerSecond = (dt == ECGDrawType.Median) ? signals.MedianSamplesPerSecond : signals.RhythmSamplesPerSecond;
                    signals = signals.Clone();
                }

                // You should note that if signal is already resampled, but dpi changes the new signal
                // will be resampled based on already resampled information instead of reloading from
                // orignal.
                int RI = ECGConversion.ECGTool.ResampleInterval;
                ECGConversion.ECGTool.ResampleInterval /= DirtSolutionFactor;
                for (int i = 0; i < signals.NrLeads; i++)
                {
                    ECGTool.ResampleLead(signals[i].Rhythm, (int)signals.RhythmSamplesPerSecond * DirtSolutionFactor, (int)(fPixel_Per_s * DirtSolutionFactor), out signals[i].Rhythm);

                    if ((signals.MedianSamplesPerSecond != 0)
                    && (signals[i].Median != null))
                        ECGTool.ResampleLead(signals[i].Median, (int)signals.MedianSamplesPerSecond * DirtSolutionFactor, (int)(fPixel_Per_s * DirtSolutionFactor), out signals[i].Median);

                    signals[i].RhythmStart = (signals[i].RhythmStart * (int)(fPixel_Per_s * DirtSolutionFactor)) / (int)(signals.RhythmSamplesPerSecond * DirtSolutionFactor);
                    signals[i].RhythmEnd = (signals[i].RhythmEnd * (int)(fPixel_Per_s * DirtSolutionFactor)) / (int)(signals.RhythmSamplesPerSecond * DirtSolutionFactor);
                }
                ECGConversion.ECGTool.ResampleInterval = RI;

                nTime = (nTime * (int)(fPixel_Per_s * DirtSolutionFactor)) / (int)(signals.RhythmSamplesPerSecond * DirtSolutionFactor);

                // set new rhythm per samples.
                signals.RhythmSamplesPerSecond = (int)fPixel_Per_s;
                if (signals.MedianSamplesPerSecond != 0)
                    signals.MedianSamplesPerSecond = (int)fPixel_Per_s;
            }

            switch (dt)
            {
                case ECGDrawType.Regular:
                    {
#if WINCE
					RectangleF Bounds = ClipBounds.IsEmpty ? myGraphics.ClipBounds : ClipBounds;
#else
                        RectangleF Bounds = myGraphics.VisibleClipBounds;
#endif
                        nMinY = (int)(_TextSize * DpiY * Inch_Per_mm * .4f);

                        // begin: drawing of ECG.
                        if (Math.Ceiling(fLeadYSpace * signals.NrLeads) >= (Bounds.Height - nMinY))
                        {
                            fLeadYSpace = (float)Math.Floor(((Bounds.Height - nMinY - fGridY) / signals.NrLeads) / fGridY) * fGridY;
                        }

                        DrawGrid(myGraphics, displayGrid, fLeadYSpace, signals.NrLeads, nMinX, nMinY, out nMaxX, out nMaxY);

                        ret = DrawSignal(myGraphics, signals, DateTime.MinValue, false, nTime, fmm_Per_s, fmm_Per_mV, nMinX, nMinY, nMaxX, nMaxY, fPixel_Per_ms * 1000f, fPixel_Per_uV, fLeadYSpace, bAllowResample);
                    }
                    break;
                case ECGDrawType.SixXTwo:
                    {
                        drawSections = new ECGDrawSection[18];

                        int a = nTime,
                            b = (5 * signals.RhythmSamplesPerSecond) + nTime,
                            c = (10 * signals.RhythmSamplesPerSecond) + nTime;

                        drawSections[0] = new ECGDrawSection(true, fmm_Per_mV, 0.0f, 2.5f * fGridY, signals.RhythmSamplesPerSecond, 2);
                        drawSections[1] = new ECGDrawSection(true, fmm_Per_mV, 0.0f, 8.0f * fGridY, signals.RhythmSamplesPerSecond, 2);
                        drawSections[2] = new ECGDrawSection(true, fmm_Per_mV, 0.0f, 13.5f * fGridY, signals.RhythmSamplesPerSecond, 2);
                        drawSections[3] = new ECGDrawSection(true, fmm_Per_mV, 0.0f, 19.0f * fGridY, signals.RhythmSamplesPerSecond, 2);
                        drawSections[4] = new ECGDrawSection(true, fmm_Per_mV, 0.0f, 24.5f * fGridY, signals.RhythmSamplesPerSecond, 2);
                        drawSections[5] = new ECGDrawSection(true, fmm_Per_mV, 0.0f, 30.0f * fGridY, signals.RhythmSamplesPerSecond, 2);

                        drawSections[6] = new ECGDrawSection(true, fmm_Per_mV, 2 * fGridX, 2.5f * fGridY, signals[0].Type, signals.RhythmAVM, signals.RhythmSamplesPerSecond, a, b, signals[0].Rhythm);
                        drawSections[7] = new ECGDrawSection(true, fmm_Per_mV, 2 * fGridX, 8.0f * fGridY, signals[1].Type, signals.RhythmAVM, signals.RhythmSamplesPerSecond, a, b, signals[1].Rhythm);
                        drawSections[8] = new ECGDrawSection(true, fmm_Per_mV, 2 * fGridX, 13.5f * fGridY, signals[2].Type, signals.RhythmAVM, signals.RhythmSamplesPerSecond, a, b, signals[2].Rhythm);
                        drawSections[9] = new ECGDrawSection(true, fmm_Per_mV, 2 * fGridX, 19.0f * fGridY, signals[3].Type, signals.RhythmAVM, signals.RhythmSamplesPerSecond, a, b, signals[3].Rhythm);
                        drawSections[10] = new ECGDrawSection(true, fmm_Per_mV, 2 * fGridX, 24.5f * fGridY, signals[4].Type, signals.RhythmAVM, signals.RhythmSamplesPerSecond, a, b, signals[4].Rhythm);
                        drawSections[11] = new ECGDrawSection(true, fmm_Per_mV, 2 * fGridX, 30.0f * fGridY, signals[5].Type, signals.RhythmAVM, signals.RhythmSamplesPerSecond, a, b, signals[5].Rhythm);

                        drawSections[12] = new ECGDrawSection(true, fmm_Per_mV, 27 * fGridX, 2.5f * fGridY, signals[6].Type, signals.RhythmAVM, signals.RhythmSamplesPerSecond, b, c, signals[6].Rhythm);
                        drawSections[13] = new ECGDrawSection(true, fmm_Per_mV, 27 * fGridX, 8.0f * fGridY, signals[7].Type, signals.RhythmAVM, signals.RhythmSamplesPerSecond, b, c, signals[7].Rhythm);
                        drawSections[14] = new ECGDrawSection(true, fmm_Per_mV, 27 * fGridX, 13.5f * fGridY, signals[8].Type, signals.RhythmAVM, signals.RhythmSamplesPerSecond, b, c, signals[8].Rhythm);
                        drawSections[15] = new ECGDrawSection(true, fmm_Per_mV, 27 * fGridX, 19.0f * fGridY, signals[9].Type, signals.RhythmAVM, signals.RhythmSamplesPerSecond, b, c, signals[9].Rhythm);
                        drawSections[16] = new ECGDrawSection(true, fmm_Per_mV, 27 * fGridX, 24.5f * fGridY, signals[10].Type, signals.RhythmAVM, signals.RhythmSamplesPerSecond, b, c, signals[10].Rhythm);
                        drawSections[17] = new ECGDrawSection(true, fmm_Per_mV, 27 * fGridX, 30.0f * fGridY, signals[11].Type, signals.RhythmAVM, signals.RhythmSamplesPerSecond, b, c, signals[11].Rhythm);
                    }
                    break;
                case ECGDrawType.ThreeXFour:
                    {
                        drawSections = new ECGDrawSection[15];

                        int a = nTime,
                            b = (int)(2.5f * signals.RhythmSamplesPerSecond) + nTime,
                            c = (5 * signals.RhythmSamplesPerSecond) + nTime,
                            d = (int)(7.5f * signals.RhythmSamplesPerSecond) + nTime,
                            e = (10 * signals.RhythmSamplesPerSecond) + nTime;

                        drawSections[0] = new ECGDrawSection(true, fmm_Per_mV, 0.0f, 5.0f * fGridY, signals.RhythmSamplesPerSecond, 2);
                        drawSections[1] = new ECGDrawSection(true, fmm_Per_mV, 0.0f, 16.0f * fGridY, signals.RhythmSamplesPerSecond, 2);
                        drawSections[2] = new ECGDrawSection(true, fmm_Per_mV, 0.0f, 27.0f * fGridY, signals.RhythmSamplesPerSecond, 2);

                        drawSections[3] = new ECGDrawSection(true, fmm_Per_mV, 2.0f * fGridX, 5.0f * fGridY, signals[0].Type, signals.RhythmAVM, signals.RhythmSamplesPerSecond, a, b, signals[0].Rhythm);
                        drawSections[4] = new ECGDrawSection(true, fmm_Per_mV, 2.0f * fGridX, 16.0f * fGridY, signals[1].Type, signals.RhythmAVM, signals.RhythmSamplesPerSecond, a, b, signals[1].Rhythm);
                        drawSections[5] = new ECGDrawSection(true, fmm_Per_mV, 2.0f * fGridX, 27.0f * fGridY, signals[2].Type, signals.RhythmAVM, signals.RhythmSamplesPerSecond, a, b, signals[2].Rhythm);

                        drawSections[6] = new ECGDrawSection(true, fmm_Per_mV, 14.5f * fGridX, 5.0f * fGridY, signals[3].Type, signals.RhythmAVM, signals.RhythmSamplesPerSecond, b, c, signals[3].Rhythm);
                        drawSections[7] = new ECGDrawSection(true, fmm_Per_mV, 14.5f * fGridX, 16.0f * fGridY, signals[4].Type, signals.RhythmAVM, signals.RhythmSamplesPerSecond, b, c, signals[4].Rhythm);
                        drawSections[8] = new ECGDrawSection(true, fmm_Per_mV, 14.5f * fGridX, 27.0f * fGridY, signals[5].Type, signals.RhythmAVM, signals.RhythmSamplesPerSecond, b, c, signals[5].Rhythm);

                        drawSections[9] = new ECGDrawSection(true, fmm_Per_mV, 27.0f * fGridX, 5.0f * fGridY, signals[6].Type, signals.RhythmAVM, signals.RhythmSamplesPerSecond, c, d, signals[6].Rhythm);
                        drawSections[10] = new ECGDrawSection(true, fmm_Per_mV, 27.0f * fGridX, 16.0f * fGridY, signals[7].Type, signals.RhythmAVM, signals.RhythmSamplesPerSecond, c, d, signals[7].Rhythm);
                        drawSections[11] = new ECGDrawSection(true, fmm_Per_mV, 27.0f * fGridX, 27.0f * fGridY, signals[8].Type, signals.RhythmAVM, signals.RhythmSamplesPerSecond, c, d, signals[8].Rhythm);

                        drawSections[12] = new ECGDrawSection(true, fmm_Per_mV, 39.5f * fGridX, 5.0f * fGridY, signals[9].Type, signals.RhythmAVM, signals.RhythmSamplesPerSecond, d, e, signals[9].Rhythm);
                        drawSections[13] = new ECGDrawSection(true, fmm_Per_mV, 39.5f * fGridX, 16.0f * fGridY, signals[10].Type, signals.RhythmAVM, signals.RhythmSamplesPerSecond, d, e, signals[10].Rhythm);
                        drawSections[14] = new ECGDrawSection(true, fmm_Per_mV, 39.5f * fGridX, 27.0f * fGridY, signals[11].Type, signals.RhythmAVM, signals.RhythmSamplesPerSecond, d, e, signals[11].Rhythm);
                    }
                    break;
                case ECGDrawType.ThreeXFourPlusOne:
                    {
                        drawSections = new ECGDrawSection[17];

                        int a = nTime,
                            b = (int)(2.5f * signals.RhythmSamplesPerSecond) + nTime,
                            c = (5 * signals.RhythmSamplesPerSecond) + nTime,
                            d = (int)(7.5f * signals.RhythmSamplesPerSecond) + nTime,
                            e = (10 * signals.RhythmSamplesPerSecond) + nTime;

                        drawSections[0] = new ECGDrawSection(true, fmm_Per_mV, 0.0f, 4.0f * fGridY, signals.RhythmSamplesPerSecond, 2);
                        drawSections[1] = new ECGDrawSection(true, fmm_Per_mV, 0.0f, 12.0f * fGridY, signals.RhythmSamplesPerSecond, 2);
                        drawSections[2] = new ECGDrawSection(true, fmm_Per_mV, 0.0f, 20.0f * fGridY, signals.RhythmSamplesPerSecond, 2);
                        drawSections[3] = new ECGDrawSection(true, fmm_Per_mV, 0.0f, 28.0f * fGridY, signals.RhythmSamplesPerSecond, 2);

                        drawSections[4] = new ECGDrawSection(true, fmm_Per_mV, 2.0f * fGridX, 4.0f * fGridY, signals[0].Type, signals.RhythmAVM, signals.RhythmSamplesPerSecond, a, b, signals[0].Rhythm);
                        drawSections[5] = new ECGDrawSection(true, fmm_Per_mV, 2.0f * fGridX, 12.0f * fGridY, signals[1].Type, signals.RhythmAVM, signals.RhythmSamplesPerSecond, a, b, signals[1].Rhythm);
                        drawSections[6] = new ECGDrawSection(true, fmm_Per_mV, 2.0f * fGridX, 20.0f * fGridY, signals[2].Type, signals.RhythmAVM, signals.RhythmSamplesPerSecond, a, b, signals[2].Rhythm);

                        drawSections[7] = new ECGDrawSection(true, fmm_Per_mV, 14.5f * fGridX, 4.0f * fGridY, signals[3].Type, signals.RhythmAVM, signals.RhythmSamplesPerSecond, b, c, signals[3].Rhythm);
                        drawSections[8] = new ECGDrawSection(true, fmm_Per_mV, 14.5f * fGridX, 12.0f * fGridY, signals[4].Type, signals.RhythmAVM, signals.RhythmSamplesPerSecond, b, c, signals[4].Rhythm);
                        drawSections[9] = new ECGDrawSection(true, fmm_Per_mV, 14.5f * fGridX, 20.0f * fGridY, signals[5].Type, signals.RhythmAVM, signals.RhythmSamplesPerSecond, b, c, signals[5].Rhythm);

                        drawSections[10] = new ECGDrawSection(true, fmm_Per_mV, 27.0f * fGridX, 4.0f * fGridY, signals[6].Type, signals.RhythmAVM, signals.RhythmSamplesPerSecond, c, d, signals[6].Rhythm);
                        drawSections[11] = new ECGDrawSection(true, fmm_Per_mV, 27.0f * fGridX, 12.0f * fGridY, signals[7].Type, signals.RhythmAVM, signals.RhythmSamplesPerSecond, c, d, signals[7].Rhythm);
                        drawSections[12] = new ECGDrawSection(true, fmm_Per_mV, 27.0f * fGridX, 20.0f * fGridY, signals[8].Type, signals.RhythmAVM, signals.RhythmSamplesPerSecond, c, d, signals[8].Rhythm);

                        drawSections[13] = new ECGDrawSection(true, fmm_Per_mV, 39.5f * fGridX, 4.0f * fGridY, signals[9].Type, signals.RhythmAVM, signals.RhythmSamplesPerSecond, d, e, signals[9].Rhythm);
                        drawSections[14] = new ECGDrawSection(true, fmm_Per_mV, 39.5f * fGridX, 12.0f * fGridY, signals[10].Type, signals.RhythmAVM, signals.RhythmSamplesPerSecond, d, e, signals[10].Rhythm);
                        drawSections[15] = new ECGDrawSection(true, fmm_Per_mV, 39.5f * fGridX, 20.0f * fGridY, signals[11].Type, signals.RhythmAVM, signals.RhythmSamplesPerSecond, d, e, signals[11].Rhythm);

                        drawSections[16] = new ECGDrawSection(true, fmm_Per_mV, 2.0f * fGridX, 28.0f * fGridY, signals[1].Type, signals.RhythmAVM, signals.RhythmSamplesPerSecond, a, e, signals[1].Rhythm);
                    }
                    break;
                case ECGDrawType.ThreeXFourPlusThree:
                    {
                        drawSections = new ECGDrawSection[21];

                        int a = nTime,
                            b = (int)(2.5f * signals.RhythmSamplesPerSecond) + nTime,
                            c = (5 * signals.RhythmSamplesPerSecond) + nTime,
                            d = (int)(7.5f * signals.RhythmSamplesPerSecond) + nTime,
                            e = (10 * signals.RhythmSamplesPerSecond) + nTime;

                        drawSections[0] = new ECGDrawSection(true, fmm_Per_mV, 0.0f, 2.5f * fGridY, signals.RhythmSamplesPerSecond, 2);
                        drawSections[1] = new ECGDrawSection(true, fmm_Per_mV, 0.0f, 8.0f * fGridY, signals.RhythmSamplesPerSecond, 2);
                        drawSections[2] = new ECGDrawSection(true, fmm_Per_mV, 0.0f, 13.5f * fGridY, signals.RhythmSamplesPerSecond, 2);
                        drawSections[3] = new ECGDrawSection(true, fmm_Per_mV, 0.0f, 19.0f * fGridY, signals.RhythmSamplesPerSecond, 2);
                        drawSections[4] = new ECGDrawSection(true, fmm_Per_mV, 0.0f, 24.0f * fGridY, signals.RhythmSamplesPerSecond, 2);
                        drawSections[5] = new ECGDrawSection(true, fmm_Per_mV, 0.0f, 29.5f * fGridY, signals.RhythmSamplesPerSecond, 2);

                        drawSections[6] = new ECGDrawSection(true, fmm_Per_mV, 2.0f * fGridX, 2.5f * fGridY, signals[0].Type, signals.RhythmAVM, signals.RhythmSamplesPerSecond, a, b, signals[0].Rhythm);
                        drawSections[7] = new ECGDrawSection(true, fmm_Per_mV, 2.0f * fGridX, 8.0f * fGridY, signals[1].Type, signals.RhythmAVM, signals.RhythmSamplesPerSecond, a, b, signals[1].Rhythm);
                        drawSections[8] = new ECGDrawSection(true, fmm_Per_mV, 2.0f * fGridX, 13.5f * fGridY, signals[2].Type, signals.RhythmAVM, signals.RhythmSamplesPerSecond, a, b, signals[2].Rhythm);

                        drawSections[9] = new ECGDrawSection(true, fmm_Per_mV, 14.5f * fGridX, 2.5f * fGridY, signals[3].Type, signals.RhythmAVM, signals.RhythmSamplesPerSecond, b, c, signals[3].Rhythm);
                        drawSections[10] = new ECGDrawSection(true, fmm_Per_mV, 14.5f * fGridX, 8.0f * fGridY, signals[4].Type, signals.RhythmAVM, signals.RhythmSamplesPerSecond, b, c, signals[4].Rhythm);
                        drawSections[11] = new ECGDrawSection(true, fmm_Per_mV, 14.5f * fGridX, 13.5f * fGridY, signals[5].Type, signals.RhythmAVM, signals.RhythmSamplesPerSecond, b, c, signals[5].Rhythm);

                        drawSections[12] = new ECGDrawSection(true, fmm_Per_mV, 27.0f * fGridX, 2.5f * fGridY, signals[6].Type, signals.RhythmAVM, signals.RhythmSamplesPerSecond, c, d, signals[6].Rhythm);
                        drawSections[13] = new ECGDrawSection(true, fmm_Per_mV, 27.0f * fGridX, 8.0f * fGridY, signals[7].Type, signals.RhythmAVM, signals.RhythmSamplesPerSecond, c, d, signals[7].Rhythm);
                        drawSections[14] = new ECGDrawSection(true, fmm_Per_mV, 27.0f * fGridX, 13.5f * fGridY, signals[8].Type, signals.RhythmAVM, signals.RhythmSamplesPerSecond, c, d, signals[8].Rhythm);

                        drawSections[15] = new ECGDrawSection(true, fmm_Per_mV, 39.5f * fGridX, 2.5f * fGridY, signals[9].Type, signals.RhythmAVM, signals.RhythmSamplesPerSecond, d, e, signals[9].Rhythm);
                        drawSections[16] = new ECGDrawSection(true, fmm_Per_mV, 39.5f * fGridX, 8.0f * fGridY, signals[10].Type, signals.RhythmAVM, signals.RhythmSamplesPerSecond, d, e, signals[10].Rhythm);
                        drawSections[17] = new ECGDrawSection(true, fmm_Per_mV, 39.5f * fGridX, 13.5f * fGridY, signals[11].Type, signals.RhythmAVM, signals.RhythmSamplesPerSecond, d, e, signals[11].Rhythm);

                        drawSections[18] = new ECGDrawSection(true, fmm_Per_mV, 2.0f * fGridX, 19.0f * fGridY, signals[1].Type, signals.RhythmAVM, signals.RhythmSamplesPerSecond, a, e, signals[1].Rhythm);
                        drawSections[19] = new ECGDrawSection(true, fmm_Per_mV, 2.0f * fGridX, 24.0f * fGridY, signals[7].Type, signals.RhythmAVM, signals.RhythmSamplesPerSecond, a, e, signals[7].Rhythm);
                        drawSections[20] = new ECGDrawSection(true, fmm_Per_mV, 2.0f * fGridX, 29.5f * fGridY, signals[10].Type, signals.RhythmAVM, signals.RhythmSamplesPerSecond, a, e, signals[10].Rhythm);
                    }
                    break;
                case ECGDrawType.Median:
                    {
                        drawSections = new ECGDrawSection[15];

                        int a = nTime,
                            b = ((signals.MedianLength * signals.MedianSamplesPerSecond) / 1000) + nTime + 1;

                        drawSections[0] = new ECGDrawSection(true, fmm_Per_mV, 0.0f, 5.0f * fGridY, signals.MedianSamplesPerSecond, 2);
                        drawSections[1] = new ECGDrawSection(true, fmm_Per_mV, 0.0f, 16.0f * fGridY, signals.MedianSamplesPerSecond, 2);
                        drawSections[2] = new ECGDrawSection(true, fmm_Per_mV, 0.0f, 27.0f * fGridY, signals.MedianSamplesPerSecond, 2);

                        drawSections[3] = new ECGDrawSection(true, fmm_Per_mV, 4.0f * fGridX, 5.0f * fGridY, signals[0].Type, signals.MedianAVM, signals.MedianSamplesPerSecond, a, b, signals[0].Median);
                        drawSections[4] = new ECGDrawSection(true, fmm_Per_mV, 4.0f * fGridX, 16.0f * fGridY, signals[1].Type, signals.MedianAVM, signals.MedianSamplesPerSecond, a, b, signals[1].Median);
                        drawSections[5] = new ECGDrawSection(true, fmm_Per_mV, 4.0f * fGridX, 27.0f * fGridY, signals[2].Type, signals.MedianAVM, signals.MedianSamplesPerSecond, a, b, signals[2].Median);

                        drawSections[6] = new ECGDrawSection(true, fmm_Per_mV, 17.0f * fGridX, 5.0f * fGridY, signals[3].Type, signals.MedianAVM, signals.MedianSamplesPerSecond, a, b, signals[3].Median);
                        drawSections[7] = new ECGDrawSection(true, fmm_Per_mV, 17.0f * fGridX, 16.0f * fGridY, signals[4].Type, signals.MedianAVM, signals.MedianSamplesPerSecond, a, b, signals[4].Median);
                        drawSections[8] = new ECGDrawSection(true, fmm_Per_mV, 17.0f * fGridX, 27.0f * fGridY, signals[5].Type, signals.MedianAVM, signals.MedianSamplesPerSecond, a, b, signals[5].Median);

                        drawSections[9] = new ECGDrawSection(true, fmm_Per_mV, 30.0f * fGridX, 5.0f * fGridY, signals[6].Type, signals.MedianAVM, signals.MedianSamplesPerSecond, a, b, signals[6].Median);
                        drawSections[10] = new ECGDrawSection(true, fmm_Per_mV, 30.0f * fGridX, 16.0f * fGridY, signals[7].Type, signals.MedianAVM, signals.MedianSamplesPerSecond, a, b, signals[7].Median);
                        drawSections[11] = new ECGDrawSection(true, fmm_Per_mV, 30.0f * fGridX, 27.0f * fGridY, signals[8].Type, signals.MedianAVM, signals.MedianSamplesPerSecond, a, b, signals[8].Median);

                        drawSections[12] = new ECGDrawSection(true, fmm_Per_mV, 43.0f * fGridX, 5.0f * fGridY, signals[9].Type, signals.MedianAVM, signals.MedianSamplesPerSecond, a, b, signals[9].Median);
                        drawSections[13] = new ECGDrawSection(true, fmm_Per_mV, 43.0f * fGridX, 16.0f * fGridY, signals[10].Type, signals.MedianAVM, signals.MedianSamplesPerSecond, a, b, signals[10].Median);
                        drawSections[14] = new ECGDrawSection(true, fmm_Per_mV, 43.0f * fGridX, 27.0f * fGridY, signals[11].Type, signals.MedianAVM, signals.MedianSamplesPerSecond, a, b, signals[11].Median);
                    }
                    break;
                default:
                    ret = -4;
                    break;
            }

            if (drawSections != null)
            {
                Font fontText = new Font("Verdana", _TextSize, FontStyle.Regular);
                SolidBrush solidBrush = new SolidBrush(TextColor);

                ret = DrawECG(myGraphics, displayGrid, drawSections, nMinX, nMinY, nMaxX, nMaxY);

                if (ret < 0)
                    return ret;

                if (DisplayInfo)
                {
                    string tempInfo = fmm_Per_s + "mm/s, " + fmm_Per_mV + "mm/mV";

                    myGraphics.DrawString(
                        tempInfo,
                        fontText,
                        solidBrush,
                        (nMaxX * fGridX) - myGraphics.MeasureString(tempInfo, fontText).Width,
                        (nMaxY * fGridY));
                }

                fontText.Dispose();
                solidBrush.Dispose();
            }

            if (!bAllowResample
            && (nOldSamplesPerSecond != 0))
            {
                ret = (int)(((long)ret * (long)nOldSamplesPerSecond) / (long)signals.RhythmSamplesPerSecond);
            }

            return ret;
        }		/// <summary>
		/// Function to draw an ECG using a ECG draw section array.
		/// </summary>
		/// <param name="myGraphics">graphics object to draw with.</param>
		/// <param name="drawSections"></param>
		/// <param name="nMinX">Minimal X value for grid.</param>
		/// <param name="nMinY">Minimal Y value for grid.</param>
		/// <param name="nBoxesX">Nr of boxes allong the X-axis.</param>
		/// <param name="nBoxesY">Nr of boxes allong the Y-axis.</param>
		/// <returns>Sample number to start next draw ECG on.</returns>
		public static int DrawECG(Graphics myGraphics, ECGDraw.GridType displayGrid, ECGDrawSection[] drawSections, int nMinX, int nMinY, int nBoxesX, int nBoxesY)
		{
#if WINCE
			RectangleF Bounds = ClipBounds.IsEmpty ? myGraphics.ClipBounds : ClipBounds;
#else
			RectangleF Bounds = myGraphics.VisibleClipBounds;
#endif

			if (drawSections == null)
				return -4;

			float fGridY = (DpiY * Inch_Per_mm) * _mm_Per_GridLine;
			int ret = int.MinValue;

			if ((((nBoxesY * fGridY) + (_TextSize * DpiY * Inch_Per_mm * .4f)) > Bounds.Height)
            || !DrawGrid(myGraphics, displayGrid, nMinX, nMinY, nBoxesX, nBoxesY))
				return -5;

			foreach (ECGDrawSection ds in drawSections)
				if (ds != null)
					ret = Math.Max(ret, ds.DrawSignal(myGraphics));

			return ret;
		}
        public static int DrawECG(IGraphics myGraphics, ECGDraw.GridType displayGrid, ECGDrawSection[] drawSections, int nMinX, int nMinY, int nBoxesX, int nBoxesY)
        {
#if WINCE
			RectangleF Bounds = ClipBounds.IsEmpty ? myGraphics.ClipBounds : ClipBounds;
#else
            RectangleF Bounds = myGraphics.VisibleClipBounds;
#endif

            if (drawSections == null)
                return -4;

            float fGridY = (DpiY * Inch_Per_mm) * _mm_Per_GridLine;
            int ret = int.MinValue;

            if ((((nBoxesY * fGridY) + (_TextSize * DpiY * Inch_Per_mm * .4f)) > Bounds.Height)
            || !DrawGrid(myGraphics, displayGrid, nMinX, nMinY, nBoxesX, nBoxesY))
                return -5;

            foreach (ECGDrawSection ds in drawSections)
                if (ds != null)
                    ret = Math.Max(ret, ds.DrawSignal(myGraphics));

            return ret;
        }

        public static int DrawECG1(IGraphics myGraphics, ECGDraw.GridType displayGrid, ECGDrawSection[] drawSections, int nMinX, int nMinY, int nBoxesX, int nBoxesY)
        {
#if WINCE
			RectangleF Bounds = ClipBounds.IsEmpty ? myGraphics.ClipBounds : ClipBounds;
#else
            RectangleF Bounds = myGraphics.VisibleClipBounds;
#endif

            if (drawSections == null)
                return -4;

            int ret = int.MinValue;

            DrawGrid1(myGraphics, displayGrid, nMinX, nMinY, nBoxesX, nBoxesY);

            foreach (ECGDrawSection ds in drawSections)
                if (ds != null)
                    ret = Math.Max(ret, ds.DrawSignal1(myGraphics));

            return ret;
        }		
        /// <summary>
		/// Function that will draw as much grid as is possible.
		/// </summary>
		/// <param name="myGraphics">The drawing surface.</param>
		/// <param name="fLeadYSpace">Space needed for each lead.</param>
		/// <param name="nNrLeads">Number of leads in signal.</param>
		/// <param name="nMinX">Minimal X for drawing.</param>
		/// <param name="nMinY">Minimal Y for drawing.</param>
		/// <param name="nMaxX">returns the maximum X for drawing signal</param>
		/// <param name="nMaxY">returns the maximum Y for drawing signal</param>
		private static void DrawGrid(Graphics myGraphics, ECGDraw.GridType displayGrid, float fLeadYSpace, int nNrLeads, int nMinX, int nMinY, out int nMaxX, out int nMaxY)
		{
#if WINCE
			RectangleF Bounds = ClipBounds.IsEmpty ? myGraphics.ClipBounds : ClipBounds;
#else
			RectangleF Bounds = myGraphics.VisibleClipBounds;
#endif

			// begin: draw grid.
			Brush backBrush = new SolidBrush(BackColor);
			myGraphics.FillRectangle(backBrush, 0, 0, (int) Bounds.Width, (int) Bounds.Height);
			backBrush.Dispose();

			float
				fGridX = (DpiX * Inch_Per_mm) * _mm_Per_GridLine,
				fGridY = (DpiY * Inch_Per_mm) * _mm_Per_GridLine;

			int nExtraSpace = nMinY,
				nAlternate = 1;

			nMaxX = (int) (Math.Floor((Bounds.Width - nMinX - 1) / fGridX) * fGridX) + nMinX;
			nMaxY = nMinY;

			float
				fTempY = (float) Math.Round((fLeadYSpace * nNrLeads) / fGridY) * fGridY + fGridY,
				fMaxY = fTempY + nMinY;

			Pen gridPen = new Pen(GraphColor),
				gridSecondPen = new Pen(GraphSecondColor);

			Brush gridBrush = null;

            if ((displayGrid == GridType.OneMillimeters)
			&&	(fGridX >= 10f)
			&&	(fGridY >= 10f))
			{
				fGridX /= 5;
				fGridY /= 5;
				
				nAlternate = 5;
			}
#if !WINCE
            else if (displayGrid == GridType.OneMillimeters)
			{
				gridBrush = new HatchBrush(HatchStyle.Percent30, GraphSecondColor, BackColor);
			}
#endif

			while (fMaxY < Bounds.Height)
			{
				nMaxY = (int) fMaxY;

				int j=0;

				if (gridBrush != null)
					myGraphics.FillRectangle(gridBrush, nMinX, nMinY, nMaxX, nMaxY);

				// draw vertical lines.
				for (float i=nMinX;i <= (nMaxX + 1);i+=fGridX,j++)
				{
					int nTempX = (int) Math.Round(i);

                    if (displayGrid != GridType.None)
					{
						DrawLine(myGraphics, (j % nAlternate) == 0 ? gridPen : gridSecondPen, nTempX, nMinY, nTempX, nMaxY);
					}
				}

				j=0;

				// draw horizontal lines.
				for (float i=nMinY;i <= (fMaxY + 1);i+=fGridY,j++)
				{
					int nTempY = (int) Math.Round(i);

                    if (displayGrid != GridType.None)
					{
						DrawLine(myGraphics, (j % nAlternate) == 0 ? gridPen : gridSecondPen, nMinX, nTempY, nMaxX, nTempY);
					}
				}

				nMinY = (int) (fMaxY + nExtraSpace);
				fMaxY += (fTempY + nExtraSpace);
			}

			if (gridBrush != null)
				gridBrush.Dispose();

			gridPen.Dispose();
			gridSecondPen.Dispose();
			// end: draw grid.
		}
        private static void DrawGrid(IGraphics myGraphics, ECGDraw.GridType displayGrid, float fLeadYSpace, int nNrLeads, int nMinX, int nMinY, out int nMaxX, out int nMaxY)
        {
#if WINCE
			RectangleF Bounds = ClipBounds.IsEmpty ? myGraphics.ClipBounds : ClipBounds;
#else
            RectangleF Bounds = myGraphics.VisibleClipBounds;
#endif

            // begin: draw grid.
            Brush backBrush = new SolidBrush(BackColor);
            myGraphics.FillRectangle(backBrush, 0, 0, (int)Bounds.Width, (int)Bounds.Height);
            backBrush.Dispose();

            float
                fGridX = (DpiX * Inch_Per_mm) * _mm_Per_GridLine,
                fGridY = (DpiY * Inch_Per_mm) * _mm_Per_GridLine;

            int nExtraSpace = nMinY,
                nAlternate = 1;

            nMaxX = (int)(Math.Floor((Bounds.Width - nMinX - 1) / fGridX) * fGridX) + nMinX;
            nMaxY = nMinY;

            float
                fTempY = (float)Math.Round((fLeadYSpace * nNrLeads) / fGridY) * fGridY + fGridY,
                fMaxY = fTempY + nMinY;

            Pen gridPen = new Pen(GraphColor),
                gridSecondPen = new Pen(GraphSecondColor);

            Brush gridBrush = null;

            if ((displayGrid == GridType.OneMillimeters)
            && (fGridX >= 10f)
            && (fGridY >= 10f))
            {
                fGridX /= 5;
                fGridY /= 5;

                nAlternate = 5;
            }
#if !WINCE
            else if (displayGrid == GridType.OneMillimeters)
            {
                gridBrush = new HatchBrush(HatchStyle.Percent30, GraphSecondColor, BackColor);
            }
#endif

            while (fMaxY < Bounds.Height)
            {
                nMaxY = (int)fMaxY;

                int j = 0;

                if (gridBrush != null)
                    myGraphics.FillRectangle(gridBrush, nMinX, nMinY, nMaxX, nMaxY);

                // draw vertical lines.
                for (float i = nMinX; i <= (nMaxX + 1); i += fGridX, j++)
                {
                    int nTempX = (int)Math.Round(i);

                    if (displayGrid != GridType.None)
                    {
                        DrawLine(myGraphics, (j % nAlternate) == 0 ? gridPen : gridSecondPen, nTempX, nMinY, nTempX, nMaxY);
                    }
                }

                j = 0;

                // draw horizontal lines.
                for (float i = nMinY; i <= (fMaxY + 1); i += fGridY, j++)
                {
                    int nTempY = (int)Math.Round(i);

                    if (displayGrid != GridType.None)
                    {
                        DrawLine(myGraphics, (j % nAlternate) == 0 ? gridPen : gridSecondPen, nMinX, nTempY, nMaxX, nTempY);
                    }
                }

                nMinY = (int)(fMaxY + nExtraSpace);
                fMaxY += (fTempY + nExtraSpace);
            }

            if (gridBrush != null)
                gridBrush.Dispose();

            gridPen.Dispose();
            gridSecondPen.Dispose();
            // end: draw grid.
        }		/// <summary>
		/// Function that will draw as much grid as is possible.
		/// </summary>
		/// <param name="myGraphics">The drawing surface.</param>
		/// <param name="fLeadYSpace">Space needed for each lead.</param>
		/// <param name="nNrLeads">Number of leads in signal.</param>
		/// <param name="nMinX">Minimal X for drawing.</param>
		/// <param name="nMinY">Minimal Y for drawing.</param>
		/// <param name="nBoxesX">Nr of boxes allong the X-axis.</param>
		/// <param name="nBoxesY">Nr of boxes allong the Y-axis.</param>
		/// <returns>true if successfull</returns>
		private static bool DrawGrid(Graphics myGraphics, ECGDraw.GridType displayGrid, int nMinX, int nMinY, int nBoxesX, int nBoxesY)
		{
#if WINCE
			RectangleF Bounds = ClipBounds.IsEmpty ? myGraphics.ClipBounds : ClipBounds;
#else
			RectangleF Bounds = myGraphics.VisibleClipBounds;
#endif

			Brush backBrush = new SolidBrush(BackColor);
			myGraphics.FillRectangle(backBrush, 0, 0, (int) Bounds.Width, (int) Bounds.Height);
			backBrush.Dispose();

			float
				fGridX = (DpiX * Inch_Per_mm) * _mm_Per_GridLine,
				fGridY = (DpiY * Inch_Per_mm) * _mm_Per_GridLine,
				fPenWidth = DpiX * 0.015625f;

			int nMaxX = nMinX + (int) Math.Round(fGridX * nBoxesX),
				nMaxY = nMinY + (int) Math.Round(fGridY * nBoxesY),
				nAlternate = 1;

			if ((nMaxX > Bounds.Width)
			||	(nMaxY > Bounds.Height))
				return false;

            if (displayGrid == GridType.None)
				return true;

			Pen gridPen = new Pen(GraphColor),
				gridSecondPen = new Pen(GraphSecondColor);

			Brush gridBrush = null;

            if ((displayGrid == GridType.OneMillimeters)
			&&	(fGridX >= 10f)
			&&	(fGridY >= 10f))
			{
				fGridX /= 5;
				fGridY /= 5;
				
				nAlternate = 5;
			}
#if !WINCE 
            else if (displayGrid == GridType.OneMillimeters)
			{
				gridBrush = new HatchBrush(HatchStyle.Percent30, GraphSecondColor, BackColor);
			}
#endif
			
			if (gridBrush != null)
				myGraphics.FillRectangle(gridBrush, nMinX, nMinY, nMaxX, nMaxY);

			int j = 0;
			
			// draw vertical lines.
			for (float i=nMinX;i <= (nMaxX + fPenWidth);i+=fGridX,j++)
			{
				int nTempX = (int) Math.Round(i);
				DrawLine(myGraphics, (j % nAlternate) == 0 ? gridPen : gridSecondPen, nTempX, nMinY, nTempX, nMaxY);
			}

			j = 0;

			// draw horizontal lines.
			for (float i=nMinY;i <= (nMaxY + fPenWidth);i+=fGridY,j++)
			{
				int nTempY = (int) Math.Round(i);
				DrawLine(myGraphics, (j % nAlternate) == 0 ? gridPen : gridSecondPen, nMinX, nTempY, nMaxX, nTempY);
			}

			if (gridBrush != null)
				gridBrush.Dispose();

			gridPen.Dispose();
			gridSecondPen.Dispose();

			return true;
		}
        private static bool DrawGrid(IGraphics myGraphics, ECGDraw.GridType displayGrid, int nMinX, int nMinY, int nBoxesX, int nBoxesY)
        {
#if WINCE
			RectangleF Bounds = ClipBounds.IsEmpty ? myGraphics.ClipBounds : ClipBounds;
#else
            RectangleF Bounds = myGraphics.VisibleClipBounds;
#endif

            Brush backBrush = new SolidBrush(BackColor);
            myGraphics.FillRectangle(backBrush, 0, 0, (int)Bounds.Width, (int)Bounds.Height);
            backBrush.Dispose();

            float
                fGridX = (DpiX * Inch_Per_mm) * _mm_Per_GridLine,
                fGridY = (DpiY * Inch_Per_mm) * _mm_Per_GridLine,
                fPenWidth = DpiX * 0.015625f;

            int nMaxX = nMinX + (int)Math.Round(fGridX * nBoxesX),
                nMaxY = nMinY + (int)Math.Round(fGridY * nBoxesY),
                nAlternate = 1;

            if ((nMaxX > Bounds.Width)
            || (nMaxY > Bounds.Height))
                return false;

            if (displayGrid == GridType.None)
                return true;

            Pen gridPen = new Pen(GraphColor),
                gridSecondPen = new Pen(GraphSecondColor);

            Brush gridBrush = null;

            if ((displayGrid == GridType.OneMillimeters)
            && (fGridX >= 10f)
            && (fGridY >= 10f))
            {
                fGridX /= 5;
                fGridY /= 5;

                nAlternate = 5;
            }
#if !WINCE
            else if (displayGrid == GridType.OneMillimeters)
            {
                gridBrush = new HatchBrush(HatchStyle.Percent30, GraphSecondColor, BackColor);
            }
#endif

            if (gridBrush != null)
                myGraphics.FillRectangle(gridBrush, nMinX, nMinY, nMaxX, nMaxY);

            int j = 0;

            // draw vertical lines.
            for (float i = nMinX; i <= (nMaxX + fPenWidth); i += fGridX, j++)
            {
                int nTempX = (int)Math.Round(i);
                DrawLine(myGraphics, (j % nAlternate) == 0 ? gridPen : gridSecondPen, nTempX, nMinY, nTempX, nMaxY);
            }

            j = 0;

            // draw horizontal lines.
            for (float i = nMinY; i <= (nMaxY + fPenWidth); i += fGridY, j++)
            {
                int nTempY = (int)Math.Round(i);
                DrawLine(myGraphics, (j % nAlternate) == 0 ? gridPen : gridSecondPen, nMinX, nTempY, nMaxX, nTempY);
            }

            if (gridBrush != null)
                gridBrush.Dispose();

            gridPen.Dispose();
            gridSecondPen.Dispose();

            return true;
        }

        private static bool DrawGrid1(IGraphics myGraphics, ECGDraw.GridType displayGrid, int nMinX, int nMinY, int nBoxesX, int nBoxesY)
        {
#if WINCE
			RectangleF Bounds = ClipBounds.IsEmpty ? myGraphics.ClipBounds : ClipBounds;
#else
            RectangleF Bounds = myGraphics.VisibleClipBounds;
#endif

            Brush backBrush = new SolidBrush(BackColor);
            myGraphics.FillRectangle(backBrush, 0, 0, (int)Bounds.Width, (int)Bounds.Height);
            backBrush.Dispose();

            float
                fGridX = (DpiX * Inch_Per_mm) * _mm_Per_GridLine,
            fGridY = (DpiY * Inch_Per_mm) * _mm_Per_GridLine,
                fPenWidth = DpiX * 0.015625f;

            fGridX = (float)Math.Round(fGridX);
            fGridY = (float)Math.Round(fGridY);

            int nMaxX = nMinX + (int)Math.Round(fGridX * nBoxesX),
                nMaxY = nMinY + (int)Math.Round(fGridY * nBoxesY),
                nAlternate = 1;

            if (displayGrid == GridType.None)
                return true;

            Pen gridPen = new Pen(GraphColor),
                gridSecondPen = new Pen(GraphSecondColor);

            Brush gridBrush = null;

            if ((displayGrid == GridType.OneMillimeters)
            && (fGridX >= 10f)
            && (fGridY >= 10f))
            {
                fGridX /= 5;
                fGridY /= 5;

                nAlternate = 5;
            }
#if !WINCE
            else if (displayGrid == GridType.OneMillimeters)
            {
                gridBrush = new HatchBrush(HatchStyle.Percent30, GraphSecondColor, BackColor);
            }
#endif

            if (gridBrush != null)
                myGraphics.FillRectangle(gridBrush, nMinX, nMinY, nMaxX, nMaxY);

            int j = 0;

            // draw vertical lines.
            for (float i = nMinX; i <= (nMaxX + fPenWidth); i += fGridX, j++)
            {
                int nTempX = (int)Math.Round(i);
                DrawLine(myGraphics, (j % nAlternate) == 0 ? gridPen : gridSecondPen, nTempX, nMinY, nTempX, nMaxY);
            }

            j = 0;

            // draw horizontal lines.
            for (float i = nMinY; i <= (nMaxY + fPenWidth); i += fGridY, j++)
            {
                int nTempY = (int)Math.Round(i);
                DrawLine(myGraphics, (j % nAlternate) == 0 ? gridPen : gridSecondPen, nMinX, nTempY, nMaxX, nTempY);
            }

            if (gridBrush != null)
                gridBrush.Dispose();

            gridPen.Dispose();
            gridSecondPen.Dispose();

            return true;
        }
        /// <summary>
		/// Function that will draw as much signal on the image as possible.
		/// </summary>
		/// <param name="myGraphics">The drawing surface.</param>
		/// <param name="signals">signal data.</param>
		/// <param name="dtRecordTime">Recording time of signal.</param>
		/// <param name="bShowTime">true if need to show the time</param>
		/// <param name="nTime">Sample number to start drawing of signal,</param>
		/// <param name="fmm_Per_s">mm per second</param>
		/// <param name="fmm_Per_mV">mm per mV</param>
		/// <param name="nMinX">minimal X value to draw.</param>
		/// <param name="nMinY">minimal Y value to draw.</param>
		/// <param name="nMaxX">maximum X value to draw.</param>
		/// <param name="nMaxY">maximum Y value to draw.</param>
		/// <param name="fPixel_Per_s">pixels per second.</param>
		/// <param name="fPixel_Per_uV">pixels per uV.</param>
		/// <param name="fLeadYSpace">space for each lead.</param>
		/// <param name="bAllowResample">True if resample of signal is allowed.</param>
		/// <returns>Sample number to start next draw ECG on.</returns>
		private static int DrawSignal(Graphics myGraphics, ECGSignals.Signals signals, DateTime dtRecordTime, bool bShowTime, int nTime, float fmm_Per_s, float fmm_Per_mV, int nMinX, int nMinY, int nMaxX, int nMaxY, float fPixel_Per_s, float fPixel_Per_uV, float fLeadYSpace, bool bAllowResample)
		{
			float fGridY = (DpiY * Inch_Per_mm) * _mm_Per_GridLine;

			int nOldRhythmSamplesPerSecond = 0;

			// begin: resample signals to fit. (using a dirty solution)
			if (signals.RhythmSamplesPerSecond != (int) fPixel_Per_s)
			{
				if (!bAllowResample)
				{
					nOldRhythmSamplesPerSecond = signals.RhythmSamplesPerSecond;
					signals = signals.Clone();
				}

				// You should note that if signal is already resampled, but dpi changes the new signal
				// will be resampled based on already resampled information instead of reloading from
				// orignal.
				int RI = ECGConversion.ECGTool.ResampleInterval;
				ECGConversion.ECGTool.ResampleInterval /= DirtSolutionFactor;
				for (int i=0;i < signals.NrLeads;i++)
				{
					ECGTool.ResampleLead(signals[i].Rhythm, (int) signals.RhythmSamplesPerSecond * DirtSolutionFactor, (int) (fPixel_Per_s * DirtSolutionFactor), out signals[i].Rhythm);

					if ((signals.MedianSamplesPerSecond != 0)
					&&	(signals[i].Median != null))
						ECGTool.ResampleLead(signals[i].Median, (int) signals.MedianSamplesPerSecond * DirtSolutionFactor, (int) (fPixel_Per_s * DirtSolutionFactor), out signals[i].Median);

					signals[i].RhythmStart = (signals[i].RhythmStart * (int) (fPixel_Per_s * DirtSolutionFactor)) / (int) (signals.RhythmSamplesPerSecond * DirtSolutionFactor);
					signals[i].RhythmEnd = (signals[i].RhythmEnd * (int) (fPixel_Per_s * DirtSolutionFactor)) / (int) (signals.RhythmSamplesPerSecond * DirtSolutionFactor);
				}
				ECGConversion.ECGTool.ResampleInterval = RI;

				nTime = (nTime * (int) (fPixel_Per_s * DirtSolutionFactor)) / (int) (signals.RhythmSamplesPerSecond * DirtSolutionFactor);

				// set new rhythm per samples.
				signals.RhythmSamplesPerSecond = (int) fPixel_Per_s;
				if (signals.MedianSamplesPerSecond != 0)
					signals.MedianSamplesPerSecond = (int) fPixel_Per_s;
			}
			// end: resample signals to fit. (dirty solution)

			// begin: find start and end.
			int nStart	= int.MaxValue,
				nEnd	= int.MinValue;

			for (int lead=0;lead < signals.NrLeads;lead++)
			{
				if (signals[lead] != null)
				{
					nStart = Math.Min(nStart, signals[lead].RhythmStart);
					nEnd = Math.Max(nEnd, signals[lead].RhythmEnd);
				}
			}
			// end: find start and end.

			int nPulseSpace = (int) Math.Floor(DpiX * Inch_Per_mm * _mm_Per_GridLine) + 1;

			nStart += nTime;

			int nXOffset = nMinX;
			float fYOffset = nMinY;

			DrawLeadHead(myGraphics, signals, dtRecordTime, bShowTime, nTime, nMinX, fYOffset, nMaxX, fmm_Per_s, fmm_Per_mV, fPixel_Per_uV, fLeadYSpace, nPulseSpace, nMinY);

			Pen myPen = new Pen(SignalColor);

			// begin: write rhythm data to image
			for (int n=nTime+1;n < nEnd;n++)
			{
				for (byte i=0;i < signals.NrLeads;i++)
				{
					int	x1 = n - nStart - 1 + nPulseSpace + nXOffset,
						x2 = n - nStart + nPulseSpace + nXOffset;
					short
						y1 = short.MinValue,
						y2 = short.MinValue;

					if (x2 > nMaxX)
					{
						// check whether there is space for drawing leads below
						if ((int) (fYOffset + ((signals.NrLeads * fLeadYSpace + fGridY) * 2)) < nMaxY)
						{
							nXOffset -= nMaxX - nMinX - nPulseSpace;
							fYOffset += signals.NrLeads * fLeadYSpace + nMinY + fGridY;

							x1 = n - nStart - 1 + nPulseSpace + nXOffset;
							x2 = n - nStart + nPulseSpace + nXOffset;

							DrawLeadHead(myGraphics, signals, dtRecordTime, bShowTime, n-1, nMinX, fYOffset, nMaxX, fmm_Per_s, fmm_Per_mV, fPixel_Per_uV, fLeadYSpace, nPulseSpace, nMinY);
						}
						else
						{
							// no more space so end drawing.
							nEnd = n - 1;
							break;
						}
					}

					if ((n > signals[i].RhythmStart)
					&&	(n <= signals[i].RhythmEnd))
					{
						y1 = signals[i].Rhythm[n-1-signals[i].RhythmStart];
						if ((n-signals[i].RhythmStart) < signals[i].Rhythm.Length)
							y2 = signals[i].Rhythm[n-signals[i].RhythmStart];
					}

					if ((y1 != short.MinValue)
					&&	(y2 != short.MinValue))
						DrawLine(myGraphics, 
							myPen,
							x1,
							(float) (((i + .5f) * fLeadYSpace) + fGridY - (y1 * signals.RhythmAVM * fPixel_Per_uV) + fYOffset),
							x2,
							(float) (((i + .5f) * fLeadYSpace) + fGridY - (y2 * signals.RhythmAVM * fPixel_Per_uV) + fYOffset));
				}
			}
			// end: write rhythm data to image

			if (nOldRhythmSamplesPerSecond != 0)
			{
				nEnd = (int) (((long)nEnd * (long)nOldRhythmSamplesPerSecond) / (long)signals.RhythmSamplesPerSecond);
			}

			myPen.Dispose();

			return nEnd;
		}
        private static int DrawSignal(IGraphics myGraphics, ECGSignals.Signals signals, DateTime dtRecordTime, bool bShowTime, int nTime, float fmm_Per_s, float fmm_Per_mV, int nMinX, int nMinY, int nMaxX, int nMaxY, float fPixel_Per_s, float fPixel_Per_uV, float fLeadYSpace, bool bAllowResample)
        {
            float fGridY = (DpiY * Inch_Per_mm) * _mm_Per_GridLine;

            int nOldRhythmSamplesPerSecond = 0;

            // begin: resample signals to fit. (using a dirty solution)
            if (signals.RhythmSamplesPerSecond != (int)fPixel_Per_s)
            {
                if (!bAllowResample)
                {
                    nOldRhythmSamplesPerSecond = signals.RhythmSamplesPerSecond;
                    signals = signals.Clone();
                }

                // You should note that if signal is already resampled, but dpi changes the new signal
                // will be resampled based on already resampled information instead of reloading from
                // orignal.
                int RI = ECGConversion.ECGTool.ResampleInterval;
                ECGConversion.ECGTool.ResampleInterval /= DirtSolutionFactor;
                for (int i = 0; i < signals.NrLeads; i++)
                {
                    ECGTool.ResampleLead(signals[i].Rhythm, (int)signals.RhythmSamplesPerSecond * DirtSolutionFactor, (int)(fPixel_Per_s * DirtSolutionFactor), out signals[i].Rhythm);

                    if ((signals.MedianSamplesPerSecond != 0)
                    && (signals[i].Median != null))
                        ECGTool.ResampleLead(signals[i].Median, (int)signals.MedianSamplesPerSecond * DirtSolutionFactor, (int)(fPixel_Per_s * DirtSolutionFactor), out signals[i].Median);

                    signals[i].RhythmStart = (signals[i].RhythmStart * (int)(fPixel_Per_s * DirtSolutionFactor)) / (int)(signals.RhythmSamplesPerSecond * DirtSolutionFactor);
                    signals[i].RhythmEnd = (signals[i].RhythmEnd * (int)(fPixel_Per_s * DirtSolutionFactor)) / (int)(signals.RhythmSamplesPerSecond * DirtSolutionFactor);
                }
                ECGConversion.ECGTool.ResampleInterval = RI;

                nTime = (nTime * (int)(fPixel_Per_s * DirtSolutionFactor)) / (int)(signals.RhythmSamplesPerSecond * DirtSolutionFactor);

                // set new rhythm per samples.
                signals.RhythmSamplesPerSecond = (int)fPixel_Per_s;
                if (signals.MedianSamplesPerSecond != 0)
                    signals.MedianSamplesPerSecond = (int)fPixel_Per_s;
            }
            // end: resample signals to fit. (dirty solution)

            // begin: find start and end.
            int nStart = int.MaxValue,
                nEnd = int.MinValue;

            for (int lead = 0; lead < signals.NrLeads; lead++)
            {
                if (signals[lead] != null)
                {
                    nStart = Math.Min(nStart, signals[lead].RhythmStart);
                    nEnd = Math.Max(nEnd, signals[lead].RhythmEnd);
                }
            }
            // end: find start and end.

            int nPulseSpace = (int)Math.Floor(DpiX * Inch_Per_mm * _mm_Per_GridLine) + 1;

            nStart += nTime;

            int nXOffset = nMinX;
            float fYOffset = nMinY;

            DrawLeadHead(myGraphics, signals, dtRecordTime, bShowTime, nTime, nMinX, fYOffset, nMaxX, fmm_Per_s, fmm_Per_mV, fPixel_Per_uV, fLeadYSpace, nPulseSpace, nMinY);

            Pen myPen = new Pen(SignalColor);

            // begin: write rhythm data to image
            for (int n = nTime + 1; n < nEnd; n++)
            {
                for (byte i = 0; i < signals.NrLeads; i++)
                {
                    int x1 = n - nStart - 1 + nPulseSpace + nXOffset,
                        x2 = n - nStart + nPulseSpace + nXOffset;
                    short
                        y1 = short.MinValue,
                        y2 = short.MinValue;

                    if (x2 > nMaxX)
                    {
                        // check whether there is space for drawing leads below
                        if ((int)(fYOffset + ((signals.NrLeads * fLeadYSpace + fGridY) * 2)) < nMaxY)
                        {
                            nXOffset -= nMaxX - nMinX - nPulseSpace;
                            fYOffset += signals.NrLeads * fLeadYSpace + nMinY + fGridY;

                            x1 = n - nStart - 1 + nPulseSpace + nXOffset;
                            x2 = n - nStart + nPulseSpace + nXOffset;

                            DrawLeadHead(myGraphics, signals, dtRecordTime, bShowTime, n - 1, nMinX, fYOffset, nMaxX, fmm_Per_s, fmm_Per_mV, fPixel_Per_uV, fLeadYSpace, nPulseSpace, nMinY);
                        }
                        else
                        {
                            // no more space so end drawing.
                            nEnd = n - 1;
                            break;
                        }
                    }

                    if ((n > signals[i].RhythmStart)
                    && (n <= signals[i].RhythmEnd))
                    {
                        y1 = signals[i].Rhythm[n - 1 - signals[i].RhythmStart];
                        if ((n - signals[i].RhythmStart) < signals[i].Rhythm.Length)
                            y2 = signals[i].Rhythm[n - signals[i].RhythmStart];
                    }

                    if ((y1 != short.MinValue)
                    && (y2 != short.MinValue))
                        DrawLine(myGraphics,
                            myPen,
                            x1,
                            (float)(((i + .5f) * fLeadYSpace) + fGridY - (y1 * signals.RhythmAVM * fPixel_Per_uV) + fYOffset),
                            x2,
                            (float)(((i + .5f) * fLeadYSpace) + fGridY - (y2 * signals.RhythmAVM * fPixel_Per_uV) + fYOffset));
                }
            }
            // end: write rhythm data to image

            if (nOldRhythmSamplesPerSecond != 0)
            {
                nEnd = (int)(((long)nEnd * (long)nOldRhythmSamplesPerSecond) / (long)signals.RhythmSamplesPerSecond);
            }

            myPen.Dispose();

            return nEnd;
        }		/// <summary>
		/// Function to draw the head of a signal.
		/// </summary>
		/// <param name="myGraphics">The drawing surface.</param>
		/// <param name="signals">signal data</param>
		/// <param name="dtRecordTime">start time of recording</param>
		/// <param name="bShowTime">true if need to show time</param>
		/// <param name="nTime">sample number currently add.</param>
		/// <param name="nX">x position in image</param>
		/// <param name="fY">y position in image</param>
		/// <param name="nMaxX">maximum x value</param>
		/// <param name="fmm_Per_s">mm per second</param>
		/// <param name="fmm_Per_mV">mm per mV</param>
		/// <param name="fPixel_Per_uV">Pixels per uV</param>
		/// <param name="fLeadYSpace">Space for lead in Y axe.</param>
		/// <param name="nPulseSpace">Space for the calibration pulse (in pixels)</param>
		/// <param name="nExtraSpace">Space for text (in pixels)</param>
		private static void DrawLeadHead(Graphics myGraphics, ECGSignals.Signals signals, DateTime dtRecordTime, bool bShowTime, int nTime, int nX, float fY, int nMaxX, float fmm_Per_s, float fmm_Per_mV, float fPixel_Per_uV, float fLeadYSpace, int nPulseSpace, int nExtraSpace)
		{
			int nY = (int) Math.Round(fY);

			// begin: write tags per lead. 
			Font fontText = new Font("Verdana", _TextSize, FontStyle.Regular);
			SolidBrush solidBrush = new SolidBrush(TextColor);

			long lTime = ((long)nTime * 1000L) / (long)signals.RhythmSamplesPerSecond;

			DateTime dtTemp = dtRecordTime.AddMilliseconds(lTime);

			if (bShowTime)
			{
				myGraphics.DrawString(
					((dtTemp.Year > 100)
					?	 dtTemp.ToShortDateString() + " "
					:	 "")
					+	dtTemp.Hour.ToString("00") + ":"
					+	dtTemp.Minute.ToString("00") + ":"
					+	dtTemp.Second.ToString("00") + "."
					+	(dtTemp.Millisecond/100).ToString("0"),
					fontText,
					solidBrush,
					nX,
					nY - nExtraSpace);
			}

			if (DisplayInfo)
			{
				string tempInfo = fmm_Per_s + "mm/s, " + fmm_Per_mV + "mm/mV";

				myGraphics.DrawString(
					tempInfo,
					fontText,
					solidBrush,
					nMaxX - myGraphics.MeasureString(tempInfo, fontText).Width,
					nY - nExtraSpace);
			}

			nY = (int) Math.Round(fY + (DpiY * Inch_Per_mm * _mm_Per_GridLine));

			for (byte i=0;i < signals.NrLeads;i++)
				myGraphics.DrawString(
					(signals[i].Type != ECGConversion.ECGSignals.LeadType.Unknown
					?	signals[i].Type.ToString()
					:	"Channel " + (i + 1)),
					fontText,
					solidBrush,
					nX + nPulseSpace + 2.0f ,
					nY + 2.0f + i * fLeadYSpace);

			fontText.Dispose();
			fontText = new Font(System.Drawing.FontFamily.GenericMonospace, _TextSize, FontStyle.Regular);

			fontText.Dispose();
			solidBrush.Dispose();
			// end: write tags per lead.

			// begin: draw pulse.
			Pen myPen = new Pen(SignalColor);

			for (int i=0;i < signals.NrLeads;i++)
			{
				int	a = ((nPulseSpace << 1) / 3) + nX,
					b = (int) Math.Round(((i + .5f) * fLeadYSpace) - (1000.0f * fPixel_Per_uV)) + nY,
					c = (int) Math.Round((i + .5f) * fLeadYSpace) + nY;
				
				DrawLine(myGraphics, myPen, a, c, a, b);
				DrawLine(myGraphics, myPen, a, b, nPulseSpace + nX, b);
				DrawLine(myGraphics, myPen, nPulseSpace + nX, c, nPulseSpace + nX, b);
			}

			myPen.Dispose();
			// end: draw pulse.
		}
        private static void DrawLeadHead(IGraphics myGraphics, ECGSignals.Signals signals, DateTime dtRecordTime, bool bShowTime, int nTime, int nX, float fY, int nMaxX, float fmm_Per_s, float fmm_Per_mV, float fPixel_Per_uV, float fLeadYSpace, int nPulseSpace, int nExtraSpace)
        {
            int nY = (int)Math.Round(fY);

            // begin: write tags per lead. 
            Font fontText = new Font("Verdana", _TextSize, FontStyle.Regular);
            SolidBrush solidBrush = new SolidBrush(TextColor);

            long lTime = ((long)nTime * 1000L) / (long)signals.RhythmSamplesPerSecond;

            DateTime dtTemp = dtRecordTime.AddMilliseconds(lTime);

            if (bShowTime)
            {
                myGraphics.DrawString(
                    ((dtTemp.Year > 100)
                    ? dtTemp.ToShortDateString() + " "
                    : "")
                    + dtTemp.Hour.ToString("00") + ":"
                    + dtTemp.Minute.ToString("00") + ":"
                    + dtTemp.Second.ToString("00") + "."
                    + (dtTemp.Millisecond / 100).ToString("0"),
                    fontText,
                    solidBrush,
                    nX,
                    nY - nExtraSpace);
            }

            if (DisplayInfo)
            {
                string tempInfo = fmm_Per_s + "mm/s, " + fmm_Per_mV + "mm/mV";

                myGraphics.DrawString(
                    tempInfo,
                    fontText,
                    solidBrush,
                    nMaxX - myGraphics.MeasureString(tempInfo, fontText).Width,
                    nY - nExtraSpace);
            }

            nY = (int)Math.Round(fY + (DpiY * Inch_Per_mm * _mm_Per_GridLine));

            for (byte i = 0; i < signals.NrLeads; i++)
                myGraphics.DrawString(
                    (signals[i].Type != ECGConversion.ECGSignals.LeadType.Unknown
                    ? signals[i].Type.ToString()
                    : "Channel " + (i + 1)),
                    fontText,
                    solidBrush,
                    nX + nPulseSpace + 2.0f,
                    nY + 2.0f + i * fLeadYSpace);

            fontText.Dispose();
            fontText = new Font(System.Drawing.FontFamily.GenericMonospace, _TextSize, FontStyle.Regular);

            fontText.Dispose();
            solidBrush.Dispose();
            // end: write tags per lead.

            // begin: draw pulse.
            Pen myPen = new Pen(SignalColor);

            for (int i = 0; i < signals.NrLeads; i++)
            {
                int a = ((nPulseSpace << 1) / 3) + nX,
                    b = (int)Math.Round(((i + .5f) * fLeadYSpace) - (1000.0f * fPixel_Per_uV)) + nY,
                    c = (int)Math.Round((i + .5f) * fLeadYSpace) + nY;

                DrawLine(myGraphics, myPen, a, c, a, b);
                DrawLine(myGraphics, myPen, a, b, nPulseSpace + nX, b);
                DrawLine(myGraphics, myPen, nPulseSpace + nX, c, nPulseSpace + nX, b);
            }

            myPen.Dispose();
            // end: draw pulse.
        }
		private static void DrawLine(Graphics g, Pen pen, float x1, float y1, float x2, float y2)
		{
#if WINCE
			g.DrawLine(
				pen,
				(int) Math.Round(x1),
				(int) Math.Round(y1),
				(int) Math.Round(x2),
				(int) Math.Round(y2));
#else
			g.DrawLine(pen, x1, y1, x2, y2);
#endif
		}
        private static void DrawLine(IGraphics g, Pen pen, float x1, float y1, float x2, float y2)
        {
#if WINCE
			g.DrawLine(
				pen,
				(int) Math.Round(x1),
				(int) Math.Round(y1),
				(int) Math.Round(x2),
				(int) Math.Round(y2));
#else
            g.DrawLine(pen, x1, y1, x2, y2);
#endif
        }

        public static int DrawECG1(IGraphics myGraphics, ECGDraw.GridType displayGrid, ECGSignals.Signals signals, ECGDrawType dt, int nTime, float fmm_Per_s, float fmm_Per_mV, bool bAllowResample)
        {
            if (myGraphics == null)
                return -1;

            if (signals == null)
                return -2;

            if (signals.IsTwelveLeadSignals == false)
                return -3;

            int ret = 0;

            float
                fPixel_Per_s = (float)Math.Round(fmm_Per_s * DpiX * Inch_Per_mm),
                fPixel_Per_ms = fPixel_Per_s * 0.001f,
                fPixel_Per_uV = fmm_Per_mV * DpiY * Inch_Per_mm * 0.001f,
                fLeadYSpace = _uV_Per_Channel * fPixel_Per_uV,
                fGridX = (DpiX * Inch_Per_mm) * _mm_Per_GridLine,
                fGridY = (DpiY * Inch_Per_mm) * _mm_Per_GridLine;

            int nMinX = 0,
                nMinY = 0,
                nMaxX = 54,
                nMaxY = 32;

            RectangleF _bounds = myGraphics.VisibleClipBounds;
            if (_bounds.Height > 0 && _bounds.Width > 0)
            {
                int dotsPerInch = (int)(1.0f * 100.0f);
                int cellWidth = (int)(Math.Round((dotsPerInch * Inch_Per_mm) * _mm_Per_GridLine));
                nMaxY = (int)Math.Round(_bounds.Height) / cellWidth;
                nMaxX = (int)Math.Round(_bounds.Width) / cellWidth;

                //Calculate the margins
                nMaxY -= 2;
                nMaxX -= 2;
                nMinX = nMinY = cellWidth;
            }

            if (signals.IsBuffered)
            {
                BufferedSignals bs = signals.AsBufferedSignals;

                int nrSamplesToLoad = 10 * bs.RealRhythmSamplesPerSecond,
                    value = bs.RealRhythmStart + nTime;

                if (dt == ECGDrawType.Regular)
                {
#if WINCE
					RectangleF Bounds = ClipBounds.IsEmpty ? myGraphics.ClipBounds : ClipBounds;
#else
                    RectangleF Bounds = myGraphics.VisibleClipBounds;
#endif

                    nrSamplesToLoad = (int)((Bounds.Width * bs.RealRhythmSamplesPerSecond) / fPixel_Per_s);
                }

                bs.LoadSignal(value, value + nrSamplesToLoad);

                nTime -= value;
            }

            ECGDrawSection[] drawSections = null;

            int nOldSamplesPerSecond = 0;

            // begin: resample signals to fit. (using a dirty solution)
            if (((dt != ECGDrawType.Median)
            && (signals.RhythmSamplesPerSecond != (int)fPixel_Per_s))
            || ((dt == ECGDrawType.Median)
            && (signals.MedianSamplesPerSecond != (int)fPixel_Per_s)))
            {
                if (!bAllowResample)
                {
                    nOldSamplesPerSecond = (dt == ECGDrawType.Median) ? signals.MedianSamplesPerSecond : signals.RhythmSamplesPerSecond;
                    signals = signals.Clone();
                }

                // You should note that if signal is already resampled, but dpi changes the new signal
                // will be resampled based on already resampled information instead of reloading from
                // orignal.
                int RI = ECGConversion.ECGTool.ResampleInterval;
                ECGConversion.ECGTool.ResampleInterval /= DirtSolutionFactor;
                for (int i = 0; i < signals.NrLeads; i++)
                {
                    ECGTool.ResampleLead(signals[i].Rhythm, (int)signals.RhythmSamplesPerSecond * DirtSolutionFactor, (int)(fPixel_Per_s * DirtSolutionFactor), out signals[i].Rhythm);

                    if ((signals.MedianSamplesPerSecond != 0)
                    && (signals[i].Median != null))
                        ECGTool.ResampleLead(signals[i].Median, (int)signals.MedianSamplesPerSecond * DirtSolutionFactor, (int)(fPixel_Per_s * DirtSolutionFactor), out signals[i].Median);

                    signals[i].RhythmStart = (signals[i].RhythmStart * (int)(fPixel_Per_s * DirtSolutionFactor)) / (int)(signals.RhythmSamplesPerSecond * DirtSolutionFactor);
                    signals[i].RhythmEnd = (signals[i].RhythmEnd * (int)(fPixel_Per_s * DirtSolutionFactor)) / (int)(signals.RhythmSamplesPerSecond * DirtSolutionFactor);
                }
                ECGConversion.ECGTool.ResampleInterval = RI;

                nTime = (nTime * (int)(fPixel_Per_s * DirtSolutionFactor)) / (int)(signals.RhythmSamplesPerSecond * DirtSolutionFactor);

                // set new rhythm per samples.
                signals.RhythmSamplesPerSecond = (int)fPixel_Per_s;
                if (signals.MedianSamplesPerSecond != 0)
                    signals.MedianSamplesPerSecond = (int)fPixel_Per_s;
            }

            switch (dt)
            {
                case ECGDrawType.Regular:
                    {
                        drawSections = new ECGDrawSection[24];
                        int a = 0;
                        int b = (10 * signals.RhythmSamplesPerSecond);

                        float gridY = (DpiY * Inch_Per_mm) * _mm_Per_GridLine;
                        gridY = (float)Math.Round(gridY);

                        int channelBoxPosition = 3;
                        int channe2BoxPosition = (int)5.5;
                        int channe3BoxPosition = 8;
                        int channe4BoxPosition = (int)10.5;
                        int channe5BoxPosition = 13;
                        int channe6BoxPosition = (int)15.5;
                        int channe7BoxPosition = 18;
                        int channe8BoxPosition = (int)20.5;
                        int channe9BoxPosition = 23;
                        int channe10BoxPosition = (int)25.5;
                        int channe11BoxPosition = 28;
                        int channe12BoxPosition = 31;

                        if (signals.SignalPosition.Count == 12)
                        {
                            channelBoxPosition = (int)signals.SignalPosition.ToArray().GetValue(0);
                            channe2BoxPosition = (int)signals.SignalPosition.ToArray().GetValue(1);
                            channe3BoxPosition = (int)signals.SignalPosition.ToArray().GetValue(2);
                            channe4BoxPosition = (int)signals.SignalPosition.ToArray().GetValue(3);
                            channe5BoxPosition = (int)signals.SignalPosition.ToArray().GetValue(4);
                            channe6BoxPosition = (int)signals.SignalPosition.ToArray().GetValue(5);
                            channe7BoxPosition = (int)signals.SignalPosition.ToArray().GetValue(6);
                            channe8BoxPosition = (int)signals.SignalPosition.ToArray().GetValue(7);
                            channe9BoxPosition = (int)signals.SignalPosition.ToArray().GetValue(8);
                            channe10BoxPosition = (int)signals.SignalPosition.ToArray().GetValue(9);
                            channe11BoxPosition = (int)signals.SignalPosition.ToArray().GetValue(10);
                            channe12BoxPosition = (int)signals.SignalPosition.ToArray().GetValue(11);
                        }

                        int channelSpace1 = (int)(nMinY + (gridY * channelBoxPosition));
                        int channelSpace2 = (int)(nMinY + (gridY * channe2BoxPosition));
                        int channelSpace3 = (int)(nMinY + (gridY * channe3BoxPosition));
                        int channelSpace4 = (int)(nMinY + (gridY * channe4BoxPosition));
                        int channelSpace5 = (int)(nMinY + (gridY * channe5BoxPosition));
                        int channelSpace6 = (int)(nMinY + (gridY * channe6BoxPosition));
                        int channelSpace7 = (int)(nMinY + (gridY * channe7BoxPosition));
                        int channelSpace8 = (int)(nMinY + (gridY * channe8BoxPosition));
                        int channelSpace9 = (int)(nMinY + (gridY * channe9BoxPosition));
                        int channelSpace10 = (int)(nMinY + (gridY * channe10BoxPosition));
                        int channelSpace11 = (int)(nMinY + (gridY * channe11BoxPosition));
                        int channelSpace12 = (int)(nMinY + (gridY * channe12BoxPosition));

                        drawSections[0] = new ECGDrawSection(true, fmm_Per_mV, nMinX + 0.0f, (float)channelSpace1, signals.RhythmSamplesPerSecond, 2, DpiX, DpiY);
                        drawSections[1] = new ECGDrawSection(true, fmm_Per_mV, nMinX + 0.0f, (float)channelSpace2, signals.RhythmSamplesPerSecond, 2, DpiX, DpiY);
                        drawSections[2] = new ECGDrawSection(true, fmm_Per_mV, nMinX + 0.0f, (float)channelSpace3, signals.RhythmSamplesPerSecond, 2, DpiX, DpiY);
                        drawSections[3] = new ECGDrawSection(true, fmm_Per_mV, nMinX + 0.0f, (float)channelSpace4, signals.RhythmSamplesPerSecond, 2, DpiX, DpiY);
                        drawSections[4] = new ECGDrawSection(true, fmm_Per_mV, nMinX + 0.0f, (float)channelSpace5, signals.RhythmSamplesPerSecond, 2, DpiX, DpiY);
                        drawSections[5] = new ECGDrawSection(true, fmm_Per_mV, nMinX + 0.0f, (float)channelSpace6, signals.RhythmSamplesPerSecond, 2, DpiX, DpiY);
                        drawSections[6] = new ECGDrawSection(true, fmm_Per_mV, nMinX + 0.0f, (float)channelSpace7, signals.RhythmSamplesPerSecond, 2, DpiX, DpiY);
                        drawSections[7] = new ECGDrawSection(true, fmm_Per_mV, nMinX + 0.0f, (float)channelSpace8, signals.RhythmSamplesPerSecond, 2, DpiX, DpiY);
                        drawSections[8] = new ECGDrawSection(true, fmm_Per_mV, nMinX + 0.0f, (float)channelSpace9, signals.RhythmSamplesPerSecond, 2, DpiX, DpiY);
                        drawSections[9] = new ECGDrawSection(true, fmm_Per_mV, nMinX + 0.0f, (float)channelSpace10, signals.RhythmSamplesPerSecond, 2, DpiX, DpiY);
                        drawSections[10] = new ECGDrawSection(true, fmm_Per_mV, nMinX + 0.0f, (float)channelSpace11, signals.RhythmSamplesPerSecond, 2, DpiX, DpiY);
                        drawSections[11] = new ECGDrawSection(true, fmm_Per_mV, nMinX + 0.0f, (float)channelSpace12, signals.RhythmSamplesPerSecond, 2, DpiX, DpiY);

                        int startX = (int)(((signals.RhythmSamplesPerSecond * 2.0) / 5) + nMinX);
                        int pulseSpace = startX;

                        drawSections[12] = new ECGDrawSection(true, fmm_Per_mV, (float)startX, (float)channelSpace1, signals[0].Type, signals.RhythmAVM, signals.RhythmSamplesPerSecond, a, b, signals[0].Rhythm, DpiX, DpiY);
                        drawSections[13] = new ECGDrawSection(true, fmm_Per_mV, (float)startX, (float)channelSpace2, signals[1].Type, signals.RhythmAVM, signals.RhythmSamplesPerSecond, a, b, signals[1].Rhythm, DpiX, DpiY);
                        drawSections[14] = new ECGDrawSection(true, fmm_Per_mV, (float)startX, (float)channelSpace3, signals[2].Type, signals.RhythmAVM, signals.RhythmSamplesPerSecond, a, b, signals[2].Rhythm, DpiX, DpiY);
                        drawSections[15] = new ECGDrawSection(true, fmm_Per_mV, (float)startX, (float)channelSpace4, signals[3].Type, signals.RhythmAVM, signals.RhythmSamplesPerSecond, a, b, signals[3].Rhythm, DpiX, DpiY);
                        drawSections[16] = new ECGDrawSection(true, fmm_Per_mV, (float)startX, (float)channelSpace5, signals[4].Type, signals.RhythmAVM, signals.RhythmSamplesPerSecond, a, b, signals[4].Rhythm, DpiX, DpiY);
                        drawSections[17] = new ECGDrawSection(true, fmm_Per_mV, (float)startX, (float)channelSpace6, signals[5].Type, signals.RhythmAVM, signals.RhythmSamplesPerSecond, a, b, signals[5].Rhythm, DpiX, DpiY);
                        drawSections[18] = new ECGDrawSection(true, fmm_Per_mV, (float)startX, (float)channelSpace7, signals[6].Type, signals.RhythmAVM, signals.RhythmSamplesPerSecond, a, b, signals[6].Rhythm, DpiX, DpiY);
                        drawSections[19] = new ECGDrawSection(true, fmm_Per_mV, (float)startX, (float)channelSpace8, signals[7].Type, signals.RhythmAVM, signals.RhythmSamplesPerSecond, a, b, signals[7].Rhythm, DpiX, DpiY);
                        drawSections[20] = new ECGDrawSection(true, fmm_Per_mV, (float)startX, (float)channelSpace9, signals[8].Type, signals.RhythmAVM, signals.RhythmSamplesPerSecond, a, b, signals[8].Rhythm, DpiX, DpiY);
                        drawSections[21] = new ECGDrawSection(true, fmm_Per_mV, (float)startX, (float)channelSpace10, signals[9].Type, signals.RhythmAVM, signals.RhythmSamplesPerSecond, a, b, signals[9].Rhythm, DpiX, DpiY);
                        drawSections[22] = new ECGDrawSection(true, fmm_Per_mV, (float)startX, (float)channelSpace11, signals[10].Type, signals.RhythmAVM, signals.RhythmSamplesPerSecond, a, b, signals[10].Rhythm, DpiX, DpiY);
                        drawSections[23] = new ECGDrawSection(true, fmm_Per_mV, (float)startX, (float)channelSpace12, signals[11].Type, signals.RhythmAVM, signals.RhythmSamplesPerSecond, a, b, signals[11].Rhythm, DpiX, DpiY);
                    }
                    break;
                case ECGDrawType.SixXTwo:
                    {
                        drawSections = new ECGDrawSection[18];

                        int a = 0;
                        int b = (5 * signals.RhythmSamplesPerSecond);
                        int c = (10 * signals.RhythmSamplesPerSecond);

                        float gridY = (DpiY * Inch_Per_mm) * _mm_Per_GridLine;
                        gridY = (float)Math.Round(gridY);

                        int channelBoxPosition = 4;
                        int channe2BoxPosition = 9;
                        int channe3BoxPosition = 14;
                        int channe4BoxPosition = 19;
                        int channe5BoxPosition = 25;
                        int channe6BoxPosition = 32;

                        if (signals.SignalPosition.Count == 6)
                        {
                            channelBoxPosition = (int)signals.SignalPosition.ToArray().GetValue(0);
                            channe2BoxPosition = (int)signals.SignalPosition.ToArray().GetValue(1);
                            channe3BoxPosition = (int)signals.SignalPosition.ToArray().GetValue(2);
                            channe4BoxPosition = (int)signals.SignalPosition.ToArray().GetValue(3);
                            channe5BoxPosition = (int)signals.SignalPosition.ToArray().GetValue(4);
                            channe6BoxPosition = (int)signals.SignalPosition.ToArray().GetValue(5);
                        }

                        int channelSpace1 = (int)(nMinY + (gridY * channelBoxPosition));
                        int channelSpace2 = (int)(nMinY + (gridY * channe2BoxPosition));
                        int channelSpace3 = (int)(nMinY + (gridY * channe3BoxPosition));
                        int channelSpace4 = (int)(nMinY + (gridY * channe4BoxPosition));
                        int channelSpace5 = (int)(nMinY + (gridY * channe5BoxPosition));
                        int channelSpace6 = (int)(nMinY + (gridY * channe6BoxPosition));

                        drawSections[0] = new ECGDrawSection(true, fmm_Per_mV, nMinX + 0.0f, (float)channelSpace1, signals.RhythmSamplesPerSecond, 2, DpiX, DpiY);
                        drawSections[1] = new ECGDrawSection(true, fmm_Per_mV, nMinX + 0.0f, (float)channelSpace2, signals.RhythmSamplesPerSecond, 2, DpiX, DpiY);
                        drawSections[2] = new ECGDrawSection(true, fmm_Per_mV, nMinX + 0.0f, (float)channelSpace3, signals.RhythmSamplesPerSecond, 2, DpiX, DpiY);
                        drawSections[3] = new ECGDrawSection(true, fmm_Per_mV, nMinX + 0.0f, (float)channelSpace4, signals.RhythmSamplesPerSecond, 2, DpiX, DpiY);
                        drawSections[4] = new ECGDrawSection(true, fmm_Per_mV, nMinX + 0.0f, (float)channelSpace5, signals.RhythmSamplesPerSecond, 2, DpiX, DpiY);
                        drawSections[5] = new ECGDrawSection(true, fmm_Per_mV, nMinX + 0.0f, (float)channelSpace6, signals.RhythmSamplesPerSecond, 2, DpiX, DpiY);

                        int startX = (int)(((signals.RhythmSamplesPerSecond * 2.0) / 5) + nMinX);
                        int pulseSpace = startX;

                        drawSections[6] = new ECGDrawSection(true, fmm_Per_mV, (float)startX, (float)channelSpace1, signals[0].Type, signals.RhythmAVM, signals.RhythmSamplesPerSecond, a, b, signals[0].Rhythm, DpiX, DpiY);
                        drawSections[7] = new ECGDrawSection(true, fmm_Per_mV, (float)startX, (float)channelSpace2, signals[1].Type, signals.RhythmAVM, signals.RhythmSamplesPerSecond, a, b, signals[1].Rhythm, DpiX, DpiY);
                        drawSections[8] = new ECGDrawSection(true, fmm_Per_mV, (float)startX, (float)channelSpace3, signals[2].Type, signals.RhythmAVM, signals.RhythmSamplesPerSecond, a, b, signals[2].Rhythm, DpiX, DpiY);
                        drawSections[9] = new ECGDrawSection(true, fmm_Per_mV, (float)startX, (float)channelSpace4, signals[3].Type, signals.RhythmAVM, signals.RhythmSamplesPerSecond, a, b, signals[3].Rhythm, DpiX, DpiY);
                        drawSections[10] = new ECGDrawSection(true, fmm_Per_mV, (float)startX, (float)channelSpace5, signals[4].Type, signals.RhythmAVM, signals.RhythmSamplesPerSecond, a, b, signals[4].Rhythm, DpiX, DpiY);
                        drawSections[11] = new ECGDrawSection(true, fmm_Per_mV, (float)startX, (float)channelSpace6, signals[5].Type, signals.RhythmAVM, signals.RhythmSamplesPerSecond, a, b, signals[5].Rhythm, DpiX, DpiY);

                        startX = (int)(b + pulseSpace + 0.00f);
                        drawSections[12] = new ECGDrawSection(true, fmm_Per_mV, (float)startX, (float)channelSpace1, signals[6].Type, signals.RhythmAVM, signals.RhythmSamplesPerSecond, b, c, signals[6].Rhythm, DpiX, DpiY);
                        drawSections[13] = new ECGDrawSection(true, fmm_Per_mV, (float)startX, (float)channelSpace2, signals[7].Type, signals.RhythmAVM, signals.RhythmSamplesPerSecond, b, c, signals[7].Rhythm, DpiX, DpiY);
                        drawSections[14] = new ECGDrawSection(true, fmm_Per_mV, (float)startX, (float)channelSpace3, signals[8].Type, signals.RhythmAVM, signals.RhythmSamplesPerSecond, b, c, signals[8].Rhythm, DpiX, DpiY);
                        drawSections[15] = new ECGDrawSection(true, fmm_Per_mV, (float)startX, (float)channelSpace4, signals[9].Type, signals.RhythmAVM, signals.RhythmSamplesPerSecond, b, c, signals[9].Rhythm, DpiX, DpiY);
                        drawSections[16] = new ECGDrawSection(true, fmm_Per_mV, (float)startX, (float)channelSpace5, signals[10].Type, signals.RhythmAVM, signals.RhythmSamplesPerSecond, b, c, signals[10].Rhythm, DpiX, DpiY);
                        drawSections[17] = new ECGDrawSection(true, fmm_Per_mV, (float)startX, (float)channelSpace6, signals[11].Type, signals.RhythmAVM, signals.RhythmSamplesPerSecond, b, c, signals[11].Rhythm, DpiX, DpiY);
                    }
                    break;
                case ECGDrawType.ThreeXFour:
                    {
                        drawSections = new ECGDrawSection[15];

                        int a = 0;
                        int b = (int)(2.5f * signals.RhythmSamplesPerSecond);
                        int c = (5 * signals.RhythmSamplesPerSecond);
                        int d = (int)(7.5f * signals.RhythmSamplesPerSecond);
                        int e = (10 * signals.RhythmSamplesPerSecond);

                        float gridY = (DpiY * Inch_Per_mm) * _mm_Per_GridLine;
                        gridY = (float)Math.Round(gridY);

                        int channelBoxPosition = 6;
                        int channe2BoxPosition = 16;
                        int channe3BoxPosition = 26;

                        if (signals.SignalPosition.Count == 3)
                        {
                            channelBoxPosition = (int)signals.SignalPosition.ToArray().GetValue(0);
                            channe2BoxPosition = (int)signals.SignalPosition.ToArray().GetValue(1);
                            channe3BoxPosition = (int)signals.SignalPosition.ToArray().GetValue(2);
                        }

                        int channelSpace1 = (int)(nMinY + (gridY * channelBoxPosition));
                        int channelSpace2 = (int)(nMinY + (gridY * channe2BoxPosition));
                        int channelSpace3 = (int)(nMinY + (gridY * channe3BoxPosition));

                        drawSections[0] = new ECGDrawSection(true, fmm_Per_mV, nMinX + 0.0f, (float)channelSpace1, signals.RhythmSamplesPerSecond, 2, DpiX, DpiY);
                        drawSections[1] = new ECGDrawSection(true, fmm_Per_mV, nMinX + 0.0f, (float)channelSpace2, signals.RhythmSamplesPerSecond, 2, DpiX, DpiY);
                        drawSections[2] = new ECGDrawSection(true, fmm_Per_mV, nMinX + 0.0f, (float)channelSpace3, signals.RhythmSamplesPerSecond, 2, DpiX, DpiY);

                        int startX = (int)(((signals.RhythmSamplesPerSecond * 2.0) / 5) + nMinX);
                        int pulseSpace = startX;
                        drawSections[3] = new ECGDrawSection(true, fmm_Per_mV, (float)startX, (float)channelSpace1, signals[0].Type, signals.RhythmAVM, signals.RhythmSamplesPerSecond, a, b, signals[0].Rhythm, DpiX, DpiY);
                        drawSections[4] = new ECGDrawSection(true, fmm_Per_mV, (float)startX, (float)channelSpace2, signals[1].Type, signals.RhythmAVM, signals.RhythmSamplesPerSecond, a, b, signals[1].Rhythm, DpiX, DpiY);
                        drawSections[5] = new ECGDrawSection(true, fmm_Per_mV, (float)startX, (float)channelSpace3, signals[2].Type, signals.RhythmAVM, signals.RhythmSamplesPerSecond, a, b, signals[2].Rhythm, DpiX, DpiY);

                        startX = (int)(b + pulseSpace + (0.00f * 1));
                        drawSections[6] = new ECGDrawSection(true, fmm_Per_mV, (float)startX, (float)channelSpace1, signals[3].Type, signals.RhythmAVM, signals.RhythmSamplesPerSecond, b, c, signals[3].Rhythm, DpiX, DpiY);
                        drawSections[7] = new ECGDrawSection(true, fmm_Per_mV, (float)startX, (float)channelSpace2, signals[4].Type, signals.RhythmAVM, signals.RhythmSamplesPerSecond, b, c, signals[4].Rhythm, DpiX, DpiY);
                        drawSections[8] = new ECGDrawSection(true, fmm_Per_mV, (float)startX, (float)channelSpace3, signals[5].Type, signals.RhythmAVM, signals.RhythmSamplesPerSecond, b, c, signals[5].Rhythm, DpiX, DpiY);

                        startX = (int)(c + pulseSpace + (0.00f * 2));
                        drawSections[9] = new ECGDrawSection(true, fmm_Per_mV, (float)startX, (float)channelSpace1, signals[6].Type, signals.RhythmAVM, signals.RhythmSamplesPerSecond, c, d, signals[6].Rhythm, DpiX, DpiY);
                        drawSections[10] = new ECGDrawSection(true, fmm_Per_mV, (float)startX, (float)channelSpace2, signals[7].Type, signals.RhythmAVM, signals.RhythmSamplesPerSecond, c, d, signals[7].Rhythm, DpiX, DpiY);
                        drawSections[11] = new ECGDrawSection(true, fmm_Per_mV, (float)startX, (float)channelSpace3, signals[8].Type, signals.RhythmAVM, signals.RhythmSamplesPerSecond, c, d, signals[8].Rhythm, DpiX, DpiY);

                        startX = (int)(d + pulseSpace + (0.00f * 3));
                        drawSections[12] = new ECGDrawSection(true, fmm_Per_mV, (float)startX, (float)channelSpace1, signals[9].Type, signals.RhythmAVM, signals.RhythmSamplesPerSecond, d, e, signals[9].Rhythm, DpiX, DpiY);
                        drawSections[13] = new ECGDrawSection(true, fmm_Per_mV, (float)startX, (float)channelSpace2, signals[10].Type, signals.RhythmAVM, signals.RhythmSamplesPerSecond, d, e, signals[10].Rhythm, DpiX, DpiY);
                        drawSections[14] = new ECGDrawSection(true, fmm_Per_mV, (float)startX, (float)channelSpace3, signals[11].Type, signals.RhythmAVM, signals.RhythmSamplesPerSecond, d, e, signals[11].Rhythm, DpiX, DpiY);
                    }
                    break;
                case ECGDrawType.ThreeXFourPlusOne:
                    {
                        drawSections = new ECGDrawSection[17];

                        int a = 0,
                            b = (int)(2.5f * signals.RhythmSamplesPerSecond),
                            c = (5 * signals.RhythmSamplesPerSecond),
                            d = (int)(7.5f * signals.RhythmSamplesPerSecond),
                            e = (10 * signals.RhythmSamplesPerSecond);

                        float gridY = (DpiY * Inch_Per_mm) * _mm_Per_GridLine;
                        gridY = (float)Math.Round(gridY);

                        int channelBoxPosition = 6;
                        int channe2BoxPosition = 13;
                        int channe3BoxPosition = 19;
                        int channe4BoxPosition = 26;

                        if (signals.SignalPosition.Count == 4)
                        {
                            channelBoxPosition = (int)signals.SignalPosition.ToArray().GetValue(0);
                            channe2BoxPosition = (int)signals.SignalPosition.ToArray().GetValue(1);
                            channe3BoxPosition = (int)signals.SignalPosition.ToArray().GetValue(2);
                            channe4BoxPosition = (int)signals.SignalPosition.ToArray().GetValue(3);
                        }

                        int channelSpace1 = (int)(nMinY + (gridY * channelBoxPosition));
                        int channelSpace2 = (int)(nMinY + (gridY * channe2BoxPosition));
                        int channelSpace3 = (int)(nMinY + (gridY * channe3BoxPosition));
                        int channelSpace4 = (int)(nMinY + (gridY * channe4BoxPosition));

                        drawSections[0] = new ECGDrawSection(true, fmm_Per_mV, nMinX + 0.0f, (float)channelSpace1, signals.RhythmSamplesPerSecond, 2, DpiX, DpiY);
                        drawSections[1] = new ECGDrawSection(true, fmm_Per_mV, nMinX + 0.0f, (float)channelSpace2, signals.RhythmSamplesPerSecond, 2, DpiX, DpiY);
                        drawSections[2] = new ECGDrawSection(true, fmm_Per_mV, nMinX + 0.0f, (float)channelSpace3, signals.RhythmSamplesPerSecond, 2, DpiX, DpiY);
                        drawSections[3] = new ECGDrawSection(true, fmm_Per_mV, nMinX + 0.0f, (float)channelSpace4, signals.RhythmSamplesPerSecond, 2, DpiX, DpiY);

                        int startX = (int)(((signals.RhythmSamplesPerSecond * 2.0) / 5) + nMinX);
                        int pulseSpace = startX;
                        drawSections[4] = new ECGDrawSection(true, fmm_Per_mV, (float)startX, (float)channelSpace1, signals[0].Type, signals.RhythmAVM, signals.RhythmSamplesPerSecond, a, b, signals[0].Rhythm, DpiX, DpiY);
                        drawSections[5] = new ECGDrawSection(true, fmm_Per_mV, (float)startX, (float)channelSpace2, signals[1].Type, signals.RhythmAVM, signals.RhythmSamplesPerSecond, a, b, signals[1].Rhythm, DpiX, DpiY);
                        drawSections[6] = new ECGDrawSection(true, fmm_Per_mV, (float)startX, (float)channelSpace3, signals[2].Type, signals.RhythmAVM, signals.RhythmSamplesPerSecond, a, b, signals[2].Rhythm, DpiX, DpiY);

                        startX = (int)(b + pulseSpace + (0.00f * 1));
                        drawSections[7] = new ECGDrawSection(true, fmm_Per_mV, (float)startX, (float)channelSpace1, signals[3].Type, signals.RhythmAVM, signals.RhythmSamplesPerSecond, b, c, signals[3].Rhythm, DpiX, DpiY);
                        drawSections[8] = new ECGDrawSection(true, fmm_Per_mV, (float)startX, (float)channelSpace2, signals[4].Type, signals.RhythmAVM, signals.RhythmSamplesPerSecond, b, c, signals[4].Rhythm, DpiX, DpiY);
                        drawSections[9] = new ECGDrawSection(true, fmm_Per_mV, (float)startX, (float)channelSpace3, signals[5].Type, signals.RhythmAVM, signals.RhythmSamplesPerSecond, b, c, signals[5].Rhythm, DpiX, DpiY);

                        startX = (int)(c + pulseSpace + (0.00f * 2));
                        drawSections[10] = new ECGDrawSection(true, fmm_Per_mV, (float)startX, (float)channelSpace1, signals[6].Type, signals.RhythmAVM, signals.RhythmSamplesPerSecond, c, d, signals[6].Rhythm, DpiX, DpiY);
                        drawSections[11] = new ECGDrawSection(true, fmm_Per_mV, (float)startX, (float)channelSpace2, signals[7].Type, signals.RhythmAVM, signals.RhythmSamplesPerSecond, c, d, signals[7].Rhythm, DpiX, DpiY);
                        drawSections[12] = new ECGDrawSection(true, fmm_Per_mV, (float)startX, (float)channelSpace3, signals[8].Type, signals.RhythmAVM, signals.RhythmSamplesPerSecond, c, d, signals[8].Rhythm, DpiX, DpiY);

                        startX = (int)(d + pulseSpace + (0.00f * 3));
                        drawSections[13] = new ECGDrawSection(true, fmm_Per_mV, (float)startX, (float)channelSpace1, signals[9].Type, signals.RhythmAVM, signals.RhythmSamplesPerSecond, d, e, signals[9].Rhythm, DpiX, DpiY);
                        drawSections[14] = new ECGDrawSection(true, fmm_Per_mV, (float)startX, (float)channelSpace2, signals[10].Type, signals.RhythmAVM, signals.RhythmSamplesPerSecond, d, e, signals[10].Rhythm, DpiX, DpiY);
                        drawSections[15] = new ECGDrawSection(true, fmm_Per_mV, (float)startX, (float)channelSpace3, signals[11].Type, signals.RhythmAVM, signals.RhythmSamplesPerSecond, d, e, signals[11].Rhythm, DpiX, DpiY);

                        startX = (int)(a + pulseSpace);
                        int aFirstSignalPosition = signals.ExtraSignalPosition1;
                        drawSections[16] = new ECGDrawSection(true, fmm_Per_mV, (float)startX, (float)channelSpace4, signals[aFirstSignalPosition].Type, signals.RhythmAVM, signals.RhythmSamplesPerSecond, a, e, signals[1].Rhythm, DpiX, DpiY);
                    }
                    break;
                case ECGDrawType.ThreeXFourPlusThree:
                    {
                        drawSections = new ECGDrawSection[21];

                        int a = 0;
                        int b = (int)(2.5f * signals.RhythmSamplesPerSecond);
                        int c = (5 * signals.RhythmSamplesPerSecond);
                        int d = (int)(7.5f * signals.RhythmSamplesPerSecond);
                        int e = (10 * signals.RhythmSamplesPerSecond);

                        float gridY = (DpiY * Inch_Per_mm) * _mm_Per_GridLine;
                        gridY = (float)Math.Round(gridY);

                        int channelBoxPosition = 4;
                        int channe2BoxPosition = 9;
                        int channe3BoxPosition = 14;
                        int channe4BoxPosition = 19;
                        int channe5BoxPosition = 25;
                        int channe6BoxPosition = 32;

                        if (signals.SignalPosition.Count == 6)
                        {
                            channelBoxPosition = (int)signals.SignalPosition.ToArray().GetValue(0);
                            channe2BoxPosition = (int)signals.SignalPosition.ToArray().GetValue(1);
                            channe3BoxPosition = (int)signals.SignalPosition.ToArray().GetValue(2);
                            channe4BoxPosition = (int)signals.SignalPosition.ToArray().GetValue(3);
                            channe5BoxPosition = (int)signals.SignalPosition.ToArray().GetValue(4);
                            channe6BoxPosition = (int)signals.SignalPosition.ToArray().GetValue(5);
                        }

                        int channelSpace1 = (int)(nMinY + (gridY * channelBoxPosition));
                        int channelSpace2 = (int)(nMinY + (gridY * channe2BoxPosition));
                        int channelSpace3 = (int)(nMinY + (gridY * channe3BoxPosition));
                        int channelSpace4 = (int)(nMinY + (gridY * channe4BoxPosition));
                        int channelSpace5 = (int)(nMinY + (gridY * channe5BoxPosition));
                        int channelSpace6 = (int)(nMinY + (gridY * channe6BoxPosition));

                        drawSections[0] = new ECGDrawSection(true, fmm_Per_mV, nMinX + 0.0f, (float)channelSpace1, signals.RhythmSamplesPerSecond, 2, DpiX, DpiY);
                        drawSections[1] = new ECGDrawSection(true, fmm_Per_mV, nMinX + 0.0f, (float)channelSpace2, signals.RhythmSamplesPerSecond, 2, DpiX, DpiY);
                        drawSections[2] = new ECGDrawSection(true, fmm_Per_mV, nMinX + 0.0f, (float)channelSpace3, signals.RhythmSamplesPerSecond, 2, DpiX, DpiY);
                        drawSections[3] = new ECGDrawSection(true, fmm_Per_mV, nMinX + 0.0f, (float)channelSpace4, signals.RhythmSamplesPerSecond, 2, DpiX, DpiY);
                        drawSections[4] = new ECGDrawSection(true, fmm_Per_mV, nMinX + 0.0f, (float)channelSpace5, signals.RhythmSamplesPerSecond, 2, DpiX, DpiY);
                        drawSections[5] = new ECGDrawSection(true, fmm_Per_mV, nMinX + 0.0f, (float)channelSpace6, signals.RhythmSamplesPerSecond, 2, DpiX, DpiY);

                        int aStartX = (int)(((signals.RhythmSamplesPerSecond * 2.0) / 5) + nMinX);
                        int aPulseSpace = aStartX;
                        drawSections[6] = new ECGDrawSection(true, fmm_Per_mV, (float)aStartX, (float)channelSpace1, signals[0].Type, signals.RhythmAVM, signals.RhythmSamplesPerSecond, a, b, signals[0].Rhythm, DpiX, DpiY);
                        drawSections[7] = new ECGDrawSection(true, fmm_Per_mV, (float)aStartX, (float)channelSpace2, signals[1].Type, signals.RhythmAVM, signals.RhythmSamplesPerSecond, a, b, signals[1].Rhythm, DpiX, DpiY);
                        drawSections[8] = new ECGDrawSection(true, fmm_Per_mV, (float)aStartX, (float)channelSpace3, signals[2].Type, signals.RhythmAVM, signals.RhythmSamplesPerSecond, a, b, signals[2].Rhythm, DpiX, DpiY);

                        aStartX = (int)(b + aPulseSpace + (0.00 * 1));
                        drawSections[9] = new ECGDrawSection(true, fmm_Per_mV, (float)aStartX, (float)channelSpace1, signals[3].Type, signals.RhythmAVM, signals.RhythmSamplesPerSecond, b, c, signals[3].Rhythm, DpiX, DpiY);
                        drawSections[10] = new ECGDrawSection(true, fmm_Per_mV, (float)aStartX, (float)channelSpace2, signals[4].Type, signals.RhythmAVM, signals.RhythmSamplesPerSecond, b, c, signals[4].Rhythm, DpiX, DpiY);
                        drawSections[11] = new ECGDrawSection(true, fmm_Per_mV, (float)aStartX, (float)channelSpace3, signals[5].Type, signals.RhythmAVM, signals.RhythmSamplesPerSecond, b, c, signals[5].Rhythm, DpiX, DpiY);

                        aStartX = (int)(c + aPulseSpace + (0.00 * 2));
                        drawSections[12] = new ECGDrawSection(true, fmm_Per_mV, (float)aStartX, (float)channelSpace1, signals[6].Type, signals.RhythmAVM, signals.RhythmSamplesPerSecond, c, d, signals[6].Rhythm, DpiX, DpiY);
                        drawSections[13] = new ECGDrawSection(true, fmm_Per_mV, (float)aStartX, (float)channelSpace2, signals[7].Type, signals.RhythmAVM, signals.RhythmSamplesPerSecond, c, d, signals[7].Rhythm, DpiX, DpiY);
                        drawSections[14] = new ECGDrawSection(true, fmm_Per_mV, (float)aStartX, (float)channelSpace3, signals[8].Type, signals.RhythmAVM, signals.RhythmSamplesPerSecond, c, d, signals[8].Rhythm, DpiX, DpiY);

                        aStartX = (int)(d + aPulseSpace + (0.00 * 3));
                        drawSections[15] = new ECGDrawSection(true, fmm_Per_mV, (float)aStartX, (float)channelSpace1, signals[9].Type, signals.RhythmAVM, signals.RhythmSamplesPerSecond, d, e, signals[9].Rhythm, DpiX, DpiY);
                        drawSections[16] = new ECGDrawSection(true, fmm_Per_mV, (float)aStartX, (float)channelSpace2, signals[10].Type, signals.RhythmAVM, signals.RhythmSamplesPerSecond, d, e, signals[10].Rhythm, DpiX, DpiY);
                        drawSections[17] = new ECGDrawSection(true, fmm_Per_mV, (float)aStartX, (float)channelSpace3, signals[11].Type, signals.RhythmAVM, signals.RhythmSamplesPerSecond, d, e, signals[11].Rhythm, DpiX, DpiY);

                        int aFirstSignalPosition = signals.ExtraSignalPosition1;
                        int aSecondSignalPosition = signals.ExtraSignalPosition2;
                        int aThirdSignalPosition = signals.ExtraSignalPosition3;

                        aStartX = (int)(a + aPulseSpace);
                        drawSections[18] = new ECGDrawSection(true, fmm_Per_mV, (float)aStartX, (float)channelSpace4, signals[aFirstSignalPosition].Type, signals.RhythmAVM, signals.RhythmSamplesPerSecond, a, e, signals[aFirstSignalPosition].Rhythm, DpiX, DpiY);
                        drawSections[19] = new ECGDrawSection(true, fmm_Per_mV, (float)aStartX, (float)channelSpace5, signals[aSecondSignalPosition].Type, signals.RhythmAVM, signals.RhythmSamplesPerSecond, a, e, signals[aSecondSignalPosition].Rhythm, DpiX, DpiY);
                        drawSections[20] = new ECGDrawSection(true, fmm_Per_mV, (float)aStartX, (float)channelSpace6, signals[aThirdSignalPosition].Type, signals.RhythmAVM, signals.RhythmSamplesPerSecond, a, e, signals[aThirdSignalPosition].Rhythm, DpiX, DpiY);
                    }
                    break;
                case ECGDrawType.Median:
                    {
                        drawSections = new ECGDrawSection[15];

                        int a = 0;
                        int b = signals.MedianLength / 4;
                        int c = signals.MedianLength / 2;
                        int d = b + c;
                        int e = signals.MedianLength;

                        float gridY = (DpiY * Inch_Per_mm) * _mm_Per_GridLine;
                        gridY = (float)Math.Round(gridY);

                        int channelBoxPosition = 6;
                        int channe2BoxPosition = 16;
                        int channe3BoxPosition = 26;

                        if (signals.SignalPosition.Count == 3)
                        {
                            channelBoxPosition = (int)signals.SignalPosition.ToArray().GetValue(0);
                            channe2BoxPosition = (int)signals.SignalPosition.ToArray().GetValue(1);
                            channe3BoxPosition = (int)signals.SignalPosition.ToArray().GetValue(2);
                        }

                        int channelSpace1 = (int)(nMinY + (gridY * channelBoxPosition));
                        int channelSpace2 = (int)(nMinY + (gridY * channe2BoxPosition));
                        int channelSpace3 = (int)(nMinY + (gridY * channe3BoxPosition));

                        int startX = (int)nMinX;

                        drawSections[0] = new ECGDrawSection(true, fmm_Per_mV, (float)startX, (float)channelSpace1, signals[0].Type, signals.MedianAVM, signals.MedianSamplesPerSecond, a, b, signals[0].Median, DpiX, DpiY);
                        drawSections[1] = new ECGDrawSection(true, fmm_Per_mV, (float)startX, (float)channelSpace2, signals[1].Type, signals.MedianAVM, signals.MedianSamplesPerSecond, a, b, signals[1].Median, DpiX, DpiY);
                        drawSections[2] = new ECGDrawSection(true, fmm_Per_mV, (float)startX, (float)channelSpace3, signals[2].Type, signals.MedianAVM, signals.MedianSamplesPerSecond, a, b, signals[2].Median, DpiX, DpiY);

                        startX = (int)(b + nMinX + (0.00f * 1));
                        drawSections[3] = new ECGDrawSection(true, fmm_Per_mV, (float)startX, (float)channelSpace1, signals[3].Type, signals.MedianAVM, signals.MedianSamplesPerSecond, a, b, signals[3].Median, DpiX, DpiY);
                        drawSections[4] = new ECGDrawSection(true, fmm_Per_mV, (float)startX, (float)channelSpace2, signals[4].Type, signals.MedianAVM, signals.MedianSamplesPerSecond, a, b, signals[4].Median, DpiX, DpiY);
                        drawSections[5] = new ECGDrawSection(true, fmm_Per_mV, (float)startX, (float)channelSpace3, signals[5].Type, signals.MedianAVM, signals.MedianSamplesPerSecond, a, b, signals[5].Median, DpiX, DpiY);

                        startX = (int)(c + nMinX + (0.00f * 2));
                        drawSections[6] = new ECGDrawSection(true, fmm_Per_mV, (float)startX, (float)channelSpace1, signals[6].Type, signals.MedianAVM, signals.MedianSamplesPerSecond, a, b, signals[6].Median, DpiX, DpiY);
                        drawSections[7] = new ECGDrawSection(true, fmm_Per_mV, (float)startX, (float)channelSpace2, signals[7].Type, signals.MedianAVM, signals.MedianSamplesPerSecond, a, b, signals[7].Median, DpiX, DpiY);
                        drawSections[8] = new ECGDrawSection(true, fmm_Per_mV, (float)startX, (float)channelSpace3, signals[8].Type, signals.MedianAVM, signals.MedianSamplesPerSecond, a, b, signals[8].Median, DpiX, DpiY);

                        startX = (int)(d + nMinX + (0.00f * 2));
                        drawSections[9] = new ECGDrawSection(true, fmm_Per_mV, (float)startX, (float)channelSpace1, signals[9].Type, signals.MedianAVM, signals.MedianSamplesPerSecond, a, b, signals[9].Median, DpiX, DpiY);
                        drawSections[10] = new ECGDrawSection(true, fmm_Per_mV, (float)startX, (float)channelSpace2, signals[10].Type, signals.MedianAVM, signals.MedianSamplesPerSecond, a, b, signals[10].Median, DpiX, DpiY);
                        drawSections[11] = new ECGDrawSection(true, fmm_Per_mV, (float)startX, (float)channelSpace3, signals[11].Type, signals.MedianAVM, signals.MedianSamplesPerSecond, a, b, signals[11].Median, DpiX, DpiY);
                    }
                    break;
                default:
                    ret = -4;
                    break;
            }

            if (drawSections != null)
            {
                Font fontText = new Font("Verdana", _TextSize, FontStyle.Regular);
                SolidBrush solidBrush = new SolidBrush(TextColor);

                ret = DrawECG1(myGraphics, displayGrid, drawSections, nMinX, nMinY, nMaxX, nMaxY);

                if (ret < 0)
                    return ret;

                if (DisplayInfo)
                {
                    string tempInfo = fmm_Per_s + "mm/s, " + fmm_Per_mV + "mm/mV";

                    myGraphics.DrawString(
                        tempInfo,
                        fontText,
                        solidBrush,
                        (nMaxX * fGridX) - myGraphics.MeasureString(tempInfo, fontText).Width,
                        (0));
                }

                fontText.Dispose();
                solidBrush.Dispose();
            }

            if (!bAllowResample
            && (nOldSamplesPerSecond != 0))
            {
                ret = (int)(((long)ret * (long)nOldSamplesPerSecond) / (long)signals.RhythmSamplesPerSecond);
            }

            return ret;
        }

        public static void SetGridColor(GridGraphColor gridColor)
        {
            GraphColor = Color.FromArgb(255, 187, 187);
            GraphSecondColor = Color.FromArgb(255, 229, 229);
            BackColor = Color.FromArgb(0, 255, 255, 255);
            SignalColor = Color.Black;
            TextColor = Color.Black;

            switch (gridColor)
            {
                case GridGraphColor.Red:
                    GraphColor = Color.FromArgb(255, 187, 187);
                    GraphSecondColor = Color.FromArgb(255, 229, 229);
                    break;

                case GridGraphColor.Green:
                    GraphColor = Color.FromArgb(28, 255, 28);
                    GraphSecondColor = Color.FromArgb(204, 255, 204);
                    break;

                case GridGraphColor.Blue:
                    GraphColor = Color.FromArgb(187, 187, 255);
                    GraphSecondColor = Color.FromArgb(229, 229, 255);
                    break;

                case GridGraphColor.Black:
                    GraphColor = Color.FromArgb(40, 40, 40);
                    GraphSecondColor = Color.FromArgb(190, 190, 190);
                    break;

                case GridGraphColor.Grey:
                    GraphColor = Color.Gray;
                    GraphSecondColor = Color.FromArgb(96, 96, 96);
                    BackColor = Color.Black;
                    SignalColor = Color.Lime;
                    TextColor = Color.Lime;
                    break;

                default:
                    break;
            }
        }
    }
}
