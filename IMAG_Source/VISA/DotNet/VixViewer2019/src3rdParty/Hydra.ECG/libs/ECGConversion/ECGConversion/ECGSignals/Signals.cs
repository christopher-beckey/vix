/***************************************************************************
Copyright 2012-1014, van Ettinger Information Technology, Lopik, The Netherlands
Copyright 2004,2008, Thoraxcentrum, Erasmus MC, Rotterdam, The Netherlands

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
using System.Collections;

namespace ECGConversion.ECGSignals
{
    public class RhythmMinMax
    {
        public short MinValue { get; set; }
        public short MaxValue { get; set; }
        public short MinRoundingValue { get; set; }
        public short MaxRoundingValue { get; set; }
    }

	/// <summary>
	/// Class containing signals of ECG.
	/// </summary>
	public class Signals
	{
		// Overrall Data.
		public byte NrLeads
		{
			get
			{
				return (byte) (_Lead != null ? _Lead.Length : 0);
			}
			set
			{
				if ((value < byte.MinValue)
				||	(value > byte.MaxValue))
					return;

				_Lead = new Signal[value];
			}
		}

		public virtual bool IsBuffered
		{
			get {return false;}
		}

		public virtual BufferedSignals AsBufferedSignals
		{
			get {return null;}
		}

		// Rhythm Info.
		public double RhythmAVM = 0; // AVM in uV
		public int RhythmSamplesPerSecond = 0;

		// Median Info.
		public double MedianAVM = 0; // AVM in uV
		public ushort MedianLength = 0; // Length in ms
		public int MedianSamplesPerSecond = 0;
        public int paddingPatientInfoHeight;

		// QRS zones
		public ushort MedianFiducialPoint = 0;
		public QRSZone[] QRSZone = null;

		// Signal Data
		private Signal[] _Lead = null;

        ArrayList _SignalPositions = null;

        public float Gain { get; set; }

        public float Scale { get; set; }

        private int _ExtraSignalPosition1 = 1;

        private int _ExtraSignalPosition2 = 7;

        private int _ExtraSignalPosition3 = 10;

        public ArrayList SignalPosition
        {
            get
            {
                return _SignalPositions;
            }
        }

        public bool IsTwelveLeadSignals
        {
            get
            {
                if(_Lead == null)
                {
                    return false;
                }

                return (_Lead.Length == 12 ? true : false);
            }
        }

        public int ExtraSignalPosition1
        {
            get
            {
                return _ExtraSignalPosition1;
            }

            set
            {
                _ExtraSignalPosition1 = value;
            }
        }

        public int ExtraSignalPosition2
        {
            get
            {
                return _ExtraSignalPosition2;
            }

            set
            {
                _ExtraSignalPosition2 = value;
            }
        }

        public int ExtraSignalPosition3
        {
            get
            {
                return _ExtraSignalPosition3;
            }

            set
            {
                _ExtraSignalPosition3 = value;
            }
        }

		public Signal[] GetLeads()
		{
			return _Lead;
		}

		public void SetLeads(Signal[] leads)
		{
			if (leads.Length > byte.MaxValue)
				return;

			_Lead = leads;
		}

		public Signal this[int i]
		{
			get
			{
				return ((_Lead != null) && (i < _Lead.Length)) ? _Lead[i] : null;
			}
			set
			{
				_Lead[i] = value;
			}
		}

		public Signals()
		{}

		public Signals(byte nrleads)
		{
			NrLeads = nrleads;
		}
		/// <summary>
		/// Function to determine if the first eigth leads are as expected (I, II, V1 - V6).
		/// </summary>
		/// <returns>true if as expected</returns>
		public bool IsNormal()
		{
			return Signal.IsNormal(_Lead);
		}
		/// <summary>
		/// Calculate start and end of signals.
		/// </summary>
		/// <param name="nStart">returns start</param>
		/// <param name="nEnd">returns end</param>
		public void CalculateStartAndEnd(out int nStart, out int nEnd)
		{
			nStart = int.MaxValue;
			nEnd = int.MinValue;

			if (_Lead != null)
			{
				for (int nLead=0;nLead < _Lead.Length;nLead++)
				{
					if (_Lead[nLead].RhythmStart < nStart)
						nStart = _Lead[nLead].RhythmStart;

					if (_Lead[nLead].RhythmEnd > nEnd)
						nEnd = _Lead[nLead].RhythmEnd;
				}
			}
		}

		/// <summary>
		/// Function to determine the number of simultaneosly.
		/// </summary>
		/// <param name="data">signal information.</param>
		/// <returns>true if as expected</returns>
		public int NrSimultaneosly()
		{
			return Signal.NrSimultaneosly(_Lead);
		}
		/// <summary>
		/// Function to sort signal array on lead type.
		/// </summary>
		/// <param name="data">signal array</param>
		public void SortOnType()
		{
			Signal.SortOnType(_Lead);
		}
		/// <summary>
		/// Function to sort signal array on lead type.
		/// </summary>
		/// <param name="first">first value to sort</param>
		/// <param name="last">last value to sort</param>
		public void SortOnType(int first, int last)
		{
			Signal.SortOnType(_Lead, first, last);
		}
		/// <summary>
		/// Function to trim a signals.
		/// </summary>
		/// <param name="val">value to trim on</param>
		public void TrimSignals(short val)
		{
			int start, end;

			CalculateStartAndEnd(out start, out end);

			TrimSignals(val, start, end);
		}
		/// <summary>
		/// Function to trim a signals.
		/// </summary>
		/// <param name="val">value to trim on</param>
		/// <param name="start">start of all signals</param>
		/// <param name="end">end of all signals</param>
		public void TrimSignals(short val, int start, int end)
		{
			foreach (Signal sig in _Lead)
			{
				int	trimBegin = 0,
					trimEnd = sig.Rhythm.Length-1;

				if (sig.RhythmStart == start)
				{
					for (int i=0;i < sig.Rhythm.Length;i++)
					{
						if (sig.Rhythm[i] != val)
						{
							trimBegin = i;
							break;
						}
					}
				}

				if (sig.RhythmEnd == end)
				{
					for (int i=sig.Rhythm.Length-1;i > 0;i--)
					{
						if (sig.Rhythm[i] != val)
						{
							trimEnd = i;
							break;
						}
					}
				}

				if ((trimBegin / RhythmSamplesPerSecond) < 1)
					trimBegin = 0;

				if (((sig.Rhythm.Length-1 - trimEnd) / RhythmSamplesPerSecond) < 1)
					trimEnd = sig.Rhythm.Length-1;

				if ((trimBegin != 0)
				||	(trimEnd != sig.Rhythm.Length-1))
				{
					sig.RhythmStart += trimBegin;
					sig.RhythmEnd -= (sig.Rhythm.Length-1) - trimEnd;

					short[] temp = new short[trimEnd - trimBegin + 1];

					for (int i=0;i < temp.Length;i++)
						temp[i] = sig.Rhythm[i + trimBegin];

					sig.Rhythm = temp;
				}
			}
		}
		/// <summary>
		/// Function to clone a signals object.
		/// </summary>
		/// <returns>cloned signals object</returns>
		public virtual Signals Clone()
		{
			Signals sigs = new Signals();

			sigs.RhythmAVM = this.RhythmAVM;
			sigs.RhythmSamplesPerSecond = this.RhythmSamplesPerSecond;

			sigs.MedianAVM = this.MedianAVM;
			sigs.MedianLength = this.MedianLength;
			sigs.MedianSamplesPerSecond = this.MedianSamplesPerSecond;
			sigs.MedianFiducialPoint = this.MedianFiducialPoint;

			if (this.QRSZone != null)
			{
				sigs.QRSZone = new QRSZone[this.QRSZone.Length];

				for (int i=0;i < sigs.QRSZone.Length;i++)
					sigs.QRSZone[i] = this.QRSZone[i].Clone();
			}

			if (this._Lead != null)
			{
				sigs.NrLeads = this.NrLeads;

				for (int i=0;i < sigs._Lead.Length;i++)
					sigs._Lead[i] = this._Lead[i].Clone();
			}

			return sigs;
		}
		/// <summary>
		/// Function to make leads a certain length.
		/// </summary>
		/// <param name="seconds">length in seconds</param>
		public void MakeSpecificLength(int seconds)
		{
			MakeSpecificLength(seconds, 0);
		}
		/// <summary>
		/// Function to make leads a certain length.
		/// </summary>
		/// <param name="seconds">length (in seconds)</param>
		/// <param name="startPoint">start point in signal (in seconds)</param>
		public void MakeSpecificLength(int seconds, int startPoint)
		{
			int start, end;

			seconds *= this.RhythmSamplesPerSecond;
			startPoint *= this.RhythmSamplesPerSecond;

			CalculateStartAndEnd(out start, out end);

			foreach (Signal sig in _Lead)
			{
				short[] newSig = new short[seconds+1];

				for (int n=0;n <= seconds;n++)
				{
					int pos = (n - startPoint) + start;

					newSig[n] = ((pos >= sig.RhythmStart) && (pos < sig.RhythmEnd)) ? sig.Rhythm[pos - sig.RhythmStart] : (short) 0;
				}

				sig.Rhythm = newSig;
				sig.RhythmStart = 0;
				sig.RhythmEnd = seconds;
			}
		}
		/// <summary>
		/// Function to resample all leads.
		/// </summary>
		/// <param name="samplesPerSecond">samples per second to resample towards</param>
		public void Resample(int samplesPerSecond)
		{
			foreach (Signal sig in this._Lead)
			{
				if ((this.RhythmSamplesPerSecond != 0)
				&&	(this.RhythmAVM != 0)
				&&	(sig.Rhythm != null))
				{
					ECGTool.ResampleLead(sig.Rhythm, this.RhythmSamplesPerSecond, samplesPerSecond, out sig.Rhythm);

					sig.RhythmStart = (int) (((long)sig.RhythmStart * (long)samplesPerSecond) / (long)this.RhythmSamplesPerSecond);
					sig.RhythmEnd = (int) (((long)sig.RhythmEnd * (long)samplesPerSecond) / (long)this.RhythmSamplesPerSecond);
				}

				if ((this.MedianSamplesPerSecond != 0)
				&&	(this.MedianAVM != 0)
				&&	(sig.Median != null))
				{
					ECGTool.ResampleLead(sig.Median, this.MedianSamplesPerSecond, samplesPerSecond, out sig.Median);
				}
			}

			if (this.QRSZone != null)
			{
				foreach (QRSZone zone in this.QRSZone)
				{
					zone.Start = (int) (((long)zone.Start * (long)samplesPerSecond) / (long)this.MedianSamplesPerSecond);
					zone.Fiducial = (int) (((long)zone.Fiducial * (long)samplesPerSecond) / (long)this.MedianSamplesPerSecond);
					zone.End = (int) (((long)zone.End * (long)samplesPerSecond) / (long)this.MedianSamplesPerSecond);
				}
			}

			if ((this.RhythmSamplesPerSecond != 0)
			&&	(this.RhythmAVM != 0))
			{
				this.RhythmSamplesPerSecond = samplesPerSecond;
			}

			if ((this.MedianSamplesPerSecond != 0)
			&&	(this.MedianAVM != 0))
			{
				this.MedianFiducialPoint = (ushort) (((long)this.MedianFiducialPoint * (long)samplesPerSecond) / (long)this.MedianSamplesPerSecond);

				this.MedianSamplesPerSecond = samplesPerSecond;
			}
		}
		/// <summary>
		/// Set AVM for all signals
		/// </summary>
		/// <param name="avm">preferred multiplier</param>
		public void SetAVM(double avm)
		{
			if (avm != 0.0)
			{
				int nrLeads = this.NrLeads;

				for (int i=0;i < nrLeads;i++)
				{
					ECGTool.ChangeMultiplier(this[i].Rhythm, this.RhythmAVM, avm);
					ECGTool.ChangeMultiplier(this[i].Median, this.MedianAVM, avm);
				}

				if (this.RhythmAVM != 0.0)
					this.RhythmAVM = avm;

				if (this.MedianAVM != 0.0)
					this.MedianAVM = avm;
			}
		}
		/// <summary>
		/// Determine whether this is twelve lead signal.
		/// </summary>
		/// <returns>true if twelve lead signal.</returns>
		public bool IsTwelveLeads
		{
			get
			{
				LeadType[] lt = new LeadType[]{	LeadType.I, LeadType.II, LeadType.III,
												  LeadType.aVR, LeadType.aVL, LeadType.aVF,
												  LeadType.V1, LeadType.V2, LeadType.V3,
												  LeadType.V4, LeadType.V5, LeadType.V6};

				int nrSim = NrSimultaneosly();			

				if (nrSim != _Lead.Length)
					return false;

				if (nrSim == 12)
				{
					for (int i=0;i < nrSim;i++)
						if (_Lead[i].Type != lt[i])
							return false;

					return true;
				}

				return false;
			}
		}
		/// <summary>
		/// Function to make a twelve leads signals object.
		/// </summary>
		/// <returns>returns twelve leads signals object or null</returns>
		public Signals CalculateTwelveLeads()
		{
			LeadType[] lt = new LeadType[]{	LeadType.I, LeadType.II, LeadType.III,
											LeadType.aVR, LeadType.aVL, LeadType.aVF,
											LeadType.V1, LeadType.V2, LeadType.V3,
											LeadType.V4, LeadType.V5, LeadType.V6};

			int nrSim = NrSimultaneosly();

			if (nrSim != _Lead.Length)
				return null;

			Signal[] leads = null;

			if (nrSim == 12)
			{
                ArrayList pos_list = new ArrayList(lt);

				int check_one = 0;
				ArrayList check_two = new ArrayList(lt);
				Signal[] pos = new Signal[12];

				for (int i=0;i < nrSim;i++)
				{
					if (_Lead[i].Type == lt[i])
						check_one++;

					int temp = check_two.IndexOf(_Lead[i].Type);
					if (temp < 0)
						return null;

					check_two.RemoveAt(temp);

					pos[pos_list.IndexOf(_Lead[i].Type)] = _Lead[i];
				}

				if (check_one == 12)
					return this;

				if (check_two.Count == 0)
				{
					for (int i=0;i < pos.Length;i++)
						if (pos[i] != null)
							pos[i] = pos[i].Clone();

					leads = pos;
				}
			}
			else
			{
				short[][]
					tempRhythm = null,
					tempMedian = null;

				Signal[] pos = new Signal[12];

				if (nrSim == 8)
				{
                    ArrayList pos_list = new ArrayList(lt);

					ArrayList check = new ArrayList(
						new LeadType[]{	LeadType.I, LeadType.II,
										LeadType.V1, LeadType.V2, LeadType.V3,
										LeadType.V4, LeadType.V5, LeadType.V6});

					for (int i=0;i < nrSim;i++)
					{
						int temp = check.IndexOf(_Lead[i].Type);
						if (temp < 0)
							return null;

						check.RemoveAt(temp);

                        pos[pos_list.IndexOf(_Lead[i].Type)] = _Lead[i];
					}

					if (check.Count == 0)
					{
						for (int i=0;i < pos.Length;i++)
							if (pos[i] != null)
								pos[i] = pos[i].Clone();

						tempRhythm = new short[2][];
						tempRhythm[0] = pos[0].Rhythm;
						tempRhythm[1] = pos[1].Rhythm;

						tempMedian = new short[2][];
						tempMedian[0] = pos[0].Median;
						tempMedian[1] = pos[1].Median;
					}
				}
				else if (nrSim == 9)
				{
                    ArrayList pos_list = new ArrayList(lt);

					ArrayList check = new ArrayList(
						new LeadType[]{	LeadType.I, LeadType.II, LeadType.III,
										LeadType.V1, LeadType.V2, LeadType.V3,
										LeadType.V4, LeadType.V5, LeadType.V6});

					for (int i=0;i < nrSim;i++)
					{
						int temp = check.IndexOf(_Lead[i].Type);
						if (temp < 0)
							return null;

						check.RemoveAt(temp);

                        pos[pos_list.IndexOf(_Lead[i].Type)] = _Lead[i];
					}

					if (check.Count == 0)
					{
						for (int i=0;i < pos.Length;i++)
							if (pos[i] != null)
								pos[i] = pos[i].Clone();

						tempRhythm = new short[3][];
						tempRhythm[0] = pos[0].Rhythm;
						tempRhythm[1] = pos[1].Rhythm;
						tempRhythm[2] = pos[2].Rhythm;

						tempMedian = new short[3][];
						tempMedian[0] = pos[0].Median;
						tempMedian[1] = pos[1].Median;
						tempMedian[2] = pos[2].Median;
					}
				}

				if ((tempRhythm != null)
				||	(tempMedian != null))
				{
					short[][] calcLeads;

					if ((tempRhythm != null)
					&&	(tempRhythm[0] != null)
					&&	ECGTool.CalculateLeads(tempRhythm, tempRhythm[0].Length, out calcLeads) == 0)
					{
						for (int i=0;i < calcLeads.Length;i++)
						{
							Signal sig = new Signal();
							sig.Type = lt[i + tempRhythm.Length];
							sig.RhythmStart	= pos[0].RhythmStart;
							sig.RhythmEnd	= pos[0].RhythmEnd;
							sig.Rhythm = calcLeads[i];

							pos[i + tempRhythm.Length] = sig; 
						}

						if ((tempMedian != null)
						&&	(tempMedian[0] != null)
						&&	(ECGTool.CalculateLeads(tempMedian, tempMedian[0].Length, out calcLeads) == 0))
						{
							for (int i=0;i < calcLeads.Length;i++)
							{
								pos[i + tempRhythm.Length].Median = calcLeads[i];
							}
						}

						leads = pos;
					}
				}
			}

			if (leads != null)
			{
				Signals sigs = this.Clone();

				sigs.NrLeads = (byte) leads.Length;

				for (int i=0;i < leads.Length;i++)
					sigs._Lead[i] = leads[i];

				return sigs;
			}

			return null;
		}

        public float Width(float scale)
        {
            float rhythmSamplesPerSecond = (100.0f * scale);
            return (10.0f * rhythmSamplesPerSecond);
        }

        public int GetSignalHeight(ECGDraw.ECGDrawType leadType, float gain, double scale)
        {
            try
            {
                if (_Lead.Length != 12)
                {
                    return -1;
                }

                const float _mm_Per_GridLine = 5.0f;
                const float mm_Per_Inch = 25.4f;
                const float Inch_Per_mm = 1.0f / mm_Per_Inch;

                int noOfGridBoxes = 0;
                int startPos = 0;
                int noOfElements = 0;
                int index = 0;
                ArrayList _RhythmMinMaxList = new ArrayList();

                int leadCount = _Lead.Length;
                float dotsPerInchY = (float)(scale * 100.0);
                float fPixel_Per_uV = (float)(gain * dotsPerInchY * Inch_Per_mm * 0.001);

                foreach (Signal _signal in GetLeads())
                {
                    ArrayList _originalRhythms = new ArrayList(_signal.Clone().Rhythm);

                    startPos = 0;
                    noOfElements = 0;

                    GetNoOfSignalElements(leadType, RhythmSamplesPerSecond, index, ref startPos, ref noOfElements, false);
                    short[] _Rhythms = new short[noOfElements];
                    _originalRhythms.CopyTo(startPos, _Rhythms, 0, noOfElements);
                    ArrayList _copiedRhythms = new ArrayList(_Rhythms);
                    _copiedRhythms.Sort();

                    RhythmMinMax _RhythmMinMax = new RhythmMinMax();
                    float _MinValue = (short)_copiedRhythms.ToArray().GetValue(0) * (float)RhythmAVM * fPixel_Per_uV;
                    float _MaxValue = (short)_copiedRhythms.ToArray().GetValue(_copiedRhythms.Count - 1) * (float)RhythmAVM * fPixel_Per_uV;
                    _RhythmMinMax.MinValue = (short)_MinValue;
                    _RhythmMinMax.MaxValue = (short)_MaxValue;
                    _RhythmMinMaxList.Add(_RhythmMinMax);

                    index++;
                }

                if (leadType == ECGDraw.ECGDrawType.ThreeXFourPlusOne || leadType == ECGDraw.ECGDrawType.ThreeXFourPlusThree)
                {
                    int count = (leadType == ECGDraw.ECGDrawType.ThreeXFourPlusOne ? 1 : 3);
                    int signalIndex = 0;
                    for (int _anIndex = 0; _anIndex < count; _anIndex++)
                    {
                        // Need to update the signal index based on the configuration.
                        if (leadType == ECGDraw.ECGDrawType.ThreeXFourPlusOne)
                        {
                            signalIndex = ExtraSignalPosition1;
                        }
                        else
                        {
                            switch (_anIndex)
                            {
                                case 0:
                                    signalIndex = ExtraSignalPosition1;
                                    break;

                                case 1:
                                    signalIndex = ExtraSignalPosition2;
                                    break;

                                case 2:
                                    signalIndex = ExtraSignalPosition3;
                                    break;
                            }
                        }

                        ArrayList _originalRhythms = new ArrayList(GetLeads()[signalIndex].Clone().Rhythm);
                        startPos = 0;
                        noOfElements = 0;

                        GetNoOfSignalElements(leadType, RhythmSamplesPerSecond, signalIndex, ref startPos, ref noOfElements, true);
                        short[] _Rhythms = new short[noOfElements];
                        _originalRhythms.CopyTo(startPos, _Rhythms, 0, noOfElements);
                        ArrayList _copiedRhythms = new ArrayList(_Rhythms);
                        _copiedRhythms.Sort();

                        RhythmMinMax _RhythmMinMax = new RhythmMinMax();
                        float _MinValue = (short)_copiedRhythms.ToArray().GetValue(0) * (float)RhythmAVM * fPixel_Per_uV;
                        float _MaxValue = (short)_copiedRhythms.ToArray().GetValue(_copiedRhythms.Count - 1) * (float)RhythmAVM * fPixel_Per_uV;
                        _RhythmMinMax.MinValue = (short)_MinValue;
                        _RhythmMinMax.MaxValue = (short)_MaxValue;
                        _RhythmMinMaxList.Add(_RhythmMinMax);
                    }
                }

                //Get a Cell Width
                float aCellWidth = (float)Math.Round((dotsPerInchY * Inch_Per_mm) * _mm_Per_GridLine);
                UpdateSignalPosition(_RhythmMinMaxList, leadType, gain, scale, ref noOfGridBoxes);
                return (int)(noOfGridBoxes * (int)aCellWidth);
            }
            catch (Exception)
            { }

            return -1;
        }

        private void GetNoOfSignalElements(ECGDraw.ECGDrawType leadType, int rhythmSamplesPerSecond, int signalIndex, ref int startPos, ref int noOfElements, bool IsFullSignal)
        {
            startPos = 0;
            noOfElements = 0;

            int intervalat0 = 0;
            int intervalat250 = 0;
            int intervalat500 = 0;
            int intervalat750 = 0;
            int intervalat1000 = 0;

            switch (leadType)
            {
                case ECGDraw.ECGDrawType.ThreeXFour:
                case ECGDraw.ECGDrawType.ThreeXFourPlusOne:
                case ECGDraw.ECGDrawType.ThreeXFourPlusThree:
                case ECGDraw.ECGDrawType.Median:
                    {
                        intervalat0 = 0;
                        intervalat250 = (int)(2.5f * rhythmSamplesPerSecond);
                        intervalat500 = (5 * rhythmSamplesPerSecond);
                        intervalat750 = (int)(7.5f * rhythmSamplesPerSecond);
                        intervalat1000 = (10 * rhythmSamplesPerSecond);

                        break;
                    }

                case ECGDraw.ECGDrawType.SixXTwo:
                    {
                        intervalat0 = 0;
                        intervalat250 = (5 * rhythmSamplesPerSecond);
                        intervalat500 = (10 * rhythmSamplesPerSecond);

                        break;
                    }

                case ECGDraw.ECGDrawType.Regular:
                    {
                        intervalat0 = 0;
                        intervalat250 = (10 * rhythmSamplesPerSecond);

                        break;
                    }

                default:
                    break;
            }

            switch (leadType)
            {
                case ECGDraw.ECGDrawType.ThreeXFour:
                case ECGDraw.ECGDrawType.ThreeXFourPlusOne:
                case ECGDraw.ECGDrawType.ThreeXFourPlusThree:
                case ECGDraw.ECGDrawType.Median:
                    {
                        if (IsFullSignal)
                        {
                            startPos = intervalat0;
                            noOfElements = intervalat1000 - intervalat0;
                            break;
                        }

                        if (signalIndex == 0 || signalIndex == 1 || signalIndex == 2)
                        {
                            startPos = intervalat0;
                            noOfElements = intervalat250 - intervalat0;
                        }
                        else if (signalIndex == 3 || signalIndex == 4 || signalIndex == 5)
                        {
                            startPos = intervalat250;
                            noOfElements = intervalat500 - intervalat250;
                        }
                        else if (signalIndex == 6 || signalIndex == 7 || signalIndex == 8)
                        {
                            startPos = intervalat500;
                            noOfElements = intervalat750 - intervalat500;
                        }
                        else if (signalIndex == 9 || signalIndex == 10 || signalIndex == 11)
                        {
                            startPos = intervalat750;
                            noOfElements = intervalat1000 - intervalat750;
                        }

                        break;
                    }

                case ECGDraw.ECGDrawType.SixXTwo:
                    {
                        if (signalIndex == 0 || signalIndex == 1 || signalIndex == 2 ||
                           signalIndex == 3 || signalIndex == 4 || signalIndex == 5)
                        {
                            startPos = intervalat0;
                            noOfElements = intervalat250 - intervalat0;
                        }
                        else if (signalIndex == 6 || signalIndex == 7 || signalIndex == 8 ||
                            signalIndex == 9 || signalIndex == 10 || signalIndex == 11)
                        {
                            startPos = intervalat250;
                            noOfElements = intervalat500 - intervalat250;
                        }

                        break;
                    }

                case ECGDraw.ECGDrawType.Regular:
                    {
                        startPos = intervalat0;
                        noOfElements = intervalat250 - intervalat0;

                        break;
                    }

                default:
                    {
                        break;
                    }
            }
        }

        bool UpdateSignalPosition(ArrayList rhytmsHeightList, ECGDraw.ECGDrawType leadType, float gain, double scale, ref int noOfGridBoxes)
        {
            try
            {
                if (rhytmsHeightList.Count < 12)
                {
                    return false;
                }

                const float mm_Per_Inch = 25.4f;
                const float Inch_Per_mm = 1.0f / mm_Per_Inch;
                const float _mm_Per_GridLine = 5.0f;

                int extraCellCount = 0;
                int rowCount = 0;
                ArrayList _rhythmMinMaxList = new ArrayList();

                //Get a Cell Width
                int aDotsPerInch = (int)(scale * 100);
                int aCellWidth = (int)(Math.Round((aDotsPerInch * Inch_Per_mm) * _mm_Per_GridLine));

                switch (leadType)
                {
                    case ECGDraw.ECGDrawType.ThreeXFour:
                    case ECGDraw.ECGDrawType.Median:
                        {
                            CalcMinMaxRhythm(rhytmsHeightList, leadType, ref _rhythmMinMaxList, aCellWidth);
                            rowCount = 3;
                        }
                        break;

                    case ECGDraw.ECGDrawType.ThreeXFourPlusOne:
                        {
                            CalcMinMaxRhythm(rhytmsHeightList, leadType, ref _rhythmMinMaxList, aCellWidth);
                            rowCount = 4;
                        }
                        break;

                    case ECGDraw.ECGDrawType.ThreeXFourPlusThree:
                        {
                            CalcMinMaxRhythm(rhytmsHeightList, leadType, ref _rhythmMinMaxList, aCellWidth);
                            rowCount = 6;
                        }
                        break;

                    case ECGDraw.ECGDrawType.SixXTwo:
                        {
                            CalcMinMaxRhythm(rhytmsHeightList, leadType, ref _rhythmMinMaxList, aCellWidth);
                            rowCount = 6;
                        }
                        break;

                    case ECGDraw.ECGDrawType.Regular:
                        {
                            CalcMinMaxRhythm(rhytmsHeightList, leadType, ref _rhythmMinMaxList, aCellWidth);
                            rowCount = 12;
                        }
                        break;

                    default:
                        {
                            //Invalid LeadType
                        }
                        break;
                }

                //Sets the position list of signals
                SetSignalPositionsList(rowCount, extraCellCount, _rhythmMinMaxList, ref noOfGridBoxes, aCellWidth);
            }
            catch (Exception)
            {
            }

            return false;
        }

        void CalcMinMaxRhythm(ArrayList rhytmsHeightList, ECGDraw.ECGDrawType leadType, ref ArrayList rhythmMinMaxList, int cellWidth)
        {
            try
            {
                switch (leadType)
                {
                    case ECGDraw.ECGDrawType.ThreeXFour:
                    case ECGDraw.ECGDrawType.Median:
                        {
                            Update3X4MinMaxRhythm(3, rhytmsHeightList, ref rhythmMinMaxList, cellWidth);
                        }
                        break;

                    case ECGDraw.ECGDrawType.ThreeXFourPlusOne:
                        {
                            Update3X4MinMaxRhythm(3, rhytmsHeightList, ref rhythmMinMaxList, cellWidth);

                            //Gets the minimum and maxmium value for the extra single signals.
                            RhythmMinMax aRhythmMinMax = GetRhythmMinMax(((RhythmMinMax)rhytmsHeightList.ToArray().GetValue(12)).MaxValue, ((RhythmMinMax)rhytmsHeightList.ToArray().GetValue(12)).MinValue, cellWidth);
                            rhythmMinMaxList.Add(aRhythmMinMax);
                        }
                        break;

                    case ECGDraw.ECGDrawType.ThreeXFourPlusThree:
                        {
                            Update3X4MinMaxRhythm(3, rhytmsHeightList, ref rhythmMinMaxList, cellWidth);

                            //Gets the minimum and maxmium value for the extra single signals.
                            RhythmMinMax aRhythmMinMax = GetRhythmMinMax(((RhythmMinMax)rhytmsHeightList.ToArray().GetValue(12)).MaxValue, ((RhythmMinMax)rhytmsHeightList.ToArray().GetValue(12)).MinValue, cellWidth);
                            rhythmMinMaxList.Add(aRhythmMinMax);
                            aRhythmMinMax = GetRhythmMinMax(((RhythmMinMax)rhytmsHeightList.ToArray().GetValue(13)).MaxValue, ((RhythmMinMax)rhytmsHeightList.ToArray().GetValue(13)).MinValue, cellWidth);
                            rhythmMinMaxList.Add(aRhythmMinMax);
                            aRhythmMinMax = GetRhythmMinMax(((RhythmMinMax)rhytmsHeightList.ToArray().GetValue(14)).MaxValue, ((RhythmMinMax)rhytmsHeightList.ToArray().GetValue(14)).MinValue, cellWidth);
                            rhythmMinMaxList.Add(aRhythmMinMax);
                        }
                        break;

                    case ECGDraw.ECGDrawType.SixXTwo:
                        {
                            Update6X2MinMaxRhythm(6, rhytmsHeightList, ref rhythmMinMaxList, cellWidth);
                        }
                        break;

                    case ECGDraw.ECGDrawType.Regular:
                        {
                            foreach (RhythmMinMax _RhythmMinMax in rhytmsHeightList)
                            {
                                RhythmMinMax aRhythmMinMax = GetRhythmMinMax(_RhythmMinMax.MaxValue, _RhythmMinMax.MinValue, cellWidth);
                                rhythmMinMaxList.Add(aRhythmMinMax);
                            }
                        }
                        break;
                }
            }
            catch (Exception)
            {
            }
        }

        short GetSignalIndicatorPosition()
        {
            const float mm_Per_Inch = 25.4f;
            const float Inch_Per_mm = 1.0f / mm_Per_Inch;

            // Calculate the signal indicator position.
            float dotsPerInchY = Scale * 100;
            float pixel_Per_uV = (float)(Gain * dotsPerInchY * Inch_Per_mm * 0.001);
            short signalPulseHeight = (short)Math.Round(pixel_Per_uV * 1000.0);
            short signalIndicatorHeight = (short)Math.Round(pixel_Per_uV * 1250.0);
            short totalHeight = (short)(signalPulseHeight + (signalIndicatorHeight - signalPulseHeight));

            return totalHeight;
        }

        bool SetSignalPositionsList(int rows, int extraCells, ArrayList rhytmsHeightList, ref int noOfGridBoxes, int cellWidth)
        {
            try
            {
                if (rhytmsHeightList.Count != rows)
                {
                    return false;
                }

                int position = 0;
                int height = 0;
                int index = 0;
                int minValue = 0;

                if (_SignalPositions == null)
                {
                    _SignalPositions = new ArrayList();
                }
                _SignalPositions.Clear();

                foreach (RhythmMinMax _RhythmMinMax in rhytmsHeightList)
                {
                    if (_RhythmMinMax == null)
                    {
                        continue;
                    }

                    position = _RhythmMinMax.MaxValue + height;

                    int nextSignalPosition = index + 1;
                    short minMaxCellRounding = (short)(cellWidth / 2);
                    if (nextSignalPosition < rhytmsHeightList.Count)
                    {
                        RhythmMinMax nextRhythmMinMax = (RhythmMinMax)rhytmsHeightList.ToArray().GetValue(nextSignalPosition);
                        if (nextRhythmMinMax != null)
                        {
                            int aNextMinMaxExtraCell = _RhythmMinMax.MinRoundingValue + nextRhythmMinMax.MaxRoundingValue;
                            if (aNextMinMaxExtraCell > (cellWidth + minMaxCellRounding))
                            {
                                nextRhythmMinMax.MaxValue -= 1;
                                if (nextRhythmMinMax.MinRoundingValue < minMaxCellRounding)
                                {
                                    nextRhythmMinMax.MinRoundingValue = minMaxCellRounding;
                                }
                            }
                        }
                    }
                    else if (nextSignalPosition == rhytmsHeightList.Count)
                    {
                        int paddingHeight = _RhythmMinMax.MinRoundingValue + paddingPatientInfoHeight;
                        if (paddingHeight > cellWidth)
                        {
                            _RhythmMinMax.MinValue -= 1;
                            if ((paddingHeight % cellWidth) > minMaxCellRounding)
                            {
                                extraCells = 0;
                            }
                        }
                        else if (paddingHeight > minMaxCellRounding)
                        {
                            extraCells = 0;
                        }
                    }

                    minValue = _RhythmMinMax.MinValue;
                    _SignalPositions.Add(position);
                    height = (int)_SignalPositions.ToArray().GetValue(index) + minValue;
                    index++;
                }

                noOfGridBoxes = (int)_SignalPositions.ToArray().GetValue(rows - 1) + extraCells + minValue;

                return true;
            }
            catch (Exception)
            {
            }

            return false;
        }

        RhythmMinMax GetRhythmMinMax(short maxValue, short minValue, int cellWidth)
        {
            RhythmMinMax _RhythmMinMax;
            _RhythmMinMax = new RhythmMinMax();
            if (_RhythmMinMax == null)
            {
                // Invalid RhythmMinMax object.
                return null;
            }

            //Calculate the absolute Rhythm Min Max value.
            _RhythmMinMax.MaxValue = Math.Abs(maxValue);
            _RhythmMinMax.MinValue = Math.Abs(minValue);

            // Get the signal indicator height.
            short signalIndicatorHeight = GetSignalIndicatorPosition();
            if (_RhythmMinMax.MaxValue < signalIndicatorHeight)
            {
                // Set the signal indicator height.
                _RhythmMinMax.MaxValue = signalIndicatorHeight;
            }

            // Calculate the rounding values to remove the unwanted grids after calculating the no of grid boxes
            _RhythmMinMax.MaxRoundingValue = (short)((_RhythmMinMax.MaxValue % cellWidth) == 0 ? 0 : cellWidth - (_RhythmMinMax.MaxValue % cellWidth));
            _RhythmMinMax.MinRoundingValue = (short)((_RhythmMinMax.MinValue % cellWidth) == 0 ? 0 : cellWidth - (_RhythmMinMax.MinValue % cellWidth));

            //Calculate the exact Rhythm Min Max size based on the signle grid cell size.
            _RhythmMinMax.MaxValue += _RhythmMinMax.MaxRoundingValue;
            _RhythmMinMax.MinValue += _RhythmMinMax.MinRoundingValue;

            //Calculate the no of grid cell.for Rhythm Min Max
            _RhythmMinMax.MaxValue /= (short)cellWidth;
            _RhythmMinMax.MinValue /= (short)cellWidth;

            return _RhythmMinMax;
        }

        void Update3X4MinMaxRhythm(int rows, ArrayList rhytmsHeightList, ref ArrayList rhythmMinMaxList, int cellWidth)
        {
            int index;
            RhythmMinMax _RhythmMinMax = null;
            for (index = 0; index < rows; index++)
            {
                _RhythmMinMax = new RhythmMinMax();
                if (_RhythmMinMax == null)
                {
                    // Invalid RhythmMinMax object.
                    continue;
                }

               //Calculate the absolute Rhythm Min Max value.
               int[] positiveValues = {   ((RhythmMinMax)rhytmsHeightList.ToArray().GetValue(index)).MaxValue,
                                           ((RhythmMinMax)rhytmsHeightList.ToArray().GetValue(index + rows)).MaxValue,
                                           ((RhythmMinMax)rhytmsHeightList.ToArray().GetValue(index + rows + 3)).MaxValue,
                                           ((RhythmMinMax)rhytmsHeightList.ToArray().GetValue(index + rows + 6)).MaxValue};
               int[] negativeValues = {   ((RhythmMinMax)rhytmsHeightList.ToArray().GetValue(index)).MinValue,
                                           ((RhythmMinMax)rhytmsHeightList.ToArray().GetValue(index + rows)).MinValue,
                                           ((RhythmMinMax)rhytmsHeightList.ToArray().GetValue(index + rows + 3)).MinValue,
                                           ((RhythmMinMax)rhytmsHeightList.ToArray().GetValue(index + rows + 6)).MinValue};

               ArrayList _PositiveValues = new ArrayList(positiveValues);
               ArrayList _NegativeValues = new ArrayList(negativeValues);
               _PositiveValues.Sort();
               _NegativeValues.Sort();

               _RhythmMinMax.MaxValue = (short)Math.Abs((int)_PositiveValues.ToArray().GetValue(_PositiveValues.Count - 1));
               _RhythmMinMax.MinValue = (short)Math.Abs((int)_NegativeValues.ToArray().GetValue(0));

               // Get the signal indicator height.
               short signalIndicatorHeight = GetSignalIndicatorPosition();
               if (_RhythmMinMax.MaxValue < signalIndicatorHeight)
               {
                   // Set the signal indicator height.
                   _RhythmMinMax.MaxValue = signalIndicatorHeight;
               }

               // Calculate the rounding values to remove the unwanted grids after calculating the no of grid boxes
               _RhythmMinMax.MaxRoundingValue = (short)((_RhythmMinMax.MaxValue % cellWidth) == 0 ? 0 : cellWidth - (_RhythmMinMax.MaxValue % cellWidth));
               _RhythmMinMax.MinRoundingValue = (short)((_RhythmMinMax.MinValue % cellWidth) == 0 ? 0 : cellWidth - (_RhythmMinMax.MinValue % cellWidth));

               //Calculate the exact Rhythm Min Max size based on the signle grid cell size.
               _RhythmMinMax.MaxValue += _RhythmMinMax.MaxRoundingValue;
               _RhythmMinMax.MinValue += _RhythmMinMax.MinRoundingValue;

               //Calculate the no of grid cell.for Rhythm Min Max
               _RhythmMinMax.MaxValue /= (short)cellWidth;
               _RhythmMinMax.MinValue /= (short)cellWidth;
               rhythmMinMaxList.Add(_RhythmMinMax);
            }
        }

        void Update6X2MinMaxRhythm(int rows, ArrayList rhytmsHeightList, ref ArrayList rhythmMinMaxList, int cellWidth)
        {
            int index;
            RhythmMinMax _RhythmMinMax = null;
            for (index = 0; index <= rows - 1; index++)
            {
                _RhythmMinMax = new RhythmMinMax();
                if (_RhythmMinMax == null)
                {
                    // Invalid RhythmMinMax object.
                    continue;
                }

                //Calculate the absolute Rhythm Min Max value.
                int[] positiveValues = {  ((RhythmMinMax)rhytmsHeightList.ToArray().GetValue(index)).MaxValue,
                                           ((RhythmMinMax)rhytmsHeightList.ToArray().GetValue(index + rows)).MaxValue};
                int[] negativeValues = {  ((RhythmMinMax)rhytmsHeightList.ToArray().GetValue(index)).MinValue,
                                           ((RhythmMinMax)rhytmsHeightList.ToArray().GetValue(index + rows)).MinValue};

                ArrayList _PositiveValues = new ArrayList(positiveValues);
                ArrayList _NegativeValues = new ArrayList(negativeValues);
                _PositiveValues.Sort();
                _NegativeValues.Sort();

                _RhythmMinMax.MaxValue = (short)Math.Abs((int)_PositiveValues.ToArray().GetValue(_PositiveValues.Count - 1));
                _RhythmMinMax.MinValue = (short)Math.Abs((int)_NegativeValues.ToArray().GetValue(0));

                // Get the signal indicator height.
                short aSignalIndicatorHeight = GetSignalIndicatorPosition();
                if (_RhythmMinMax.MaxValue < aSignalIndicatorHeight)
                {
                    // Set the signal indicator height.
                    _RhythmMinMax.MaxValue = aSignalIndicatorHeight;
                }

                // Calculate the rounding values to remove the unwanted grids after calculating the no of grid boxes
                _RhythmMinMax.MaxRoundingValue = (short)((_RhythmMinMax.MaxValue % cellWidth) == 0 ? 0 : cellWidth - (_RhythmMinMax.MaxValue % cellWidth));
                _RhythmMinMax.MinRoundingValue = (short)((_RhythmMinMax.MinValue % cellWidth) == 0 ? 0 : cellWidth - (_RhythmMinMax.MinValue % cellWidth));

                //Calculate the exact Rhythm Min Max size based on the signle grid cell size.
                _RhythmMinMax.MaxValue += _RhythmMinMax.MaxRoundingValue;
                _RhythmMinMax.MinValue += _RhythmMinMax.MinRoundingValue;

                //Calculate the no of grid cell.for Rhythm Min Max
                _RhythmMinMax.MaxValue /= (short)cellWidth;
                _RhythmMinMax.MinValue /= (short)cellWidth;
                rhythmMinMaxList.Add(_RhythmMinMax);
            }
        }
    }
}
