using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Hydra.ECG
{
    public enum DrawType
    {
        None = 0x00,
        Regular = 0x01,
        ThreeXFour = 0x02,
        ThreeXFourPlusOne = 0x04,
        ThreeXFourPlusThree = 0x08,
        SixXTwo = 0x10,
        Median = 0x20
    }

    public enum GridType
    {
        None = 0,
        OneMillimeters = 1,
        FiveMillimeters = 2
    }

    public enum GridColor
    {
        Red,
        Green,
        Blue,
        Black,
        Grey
    }

    public enum SignalThickness
    {
        One = 1,
        Two,
        Three
    }

    public enum SignalGain
    {
        Five,
        Ten,
        Twenty,
        Fourty
    }

    public class ExportOptions
    {
        public static ExportOptions Default = new ExportOptions
        { 
            DrawType = DrawType.Regular, 
            GridType = GridType.OneMillimeters,
            ImageWidth = 600, 
            ImageHeight = 400,
            GenerateHeader = true,
            GenerateImage = true,
            GridColor = GridColor.Red,
            SignalThickness = SignalThickness.One,
            SignalGain = SignalGain.Ten,
            IsWaterMarkRequired = false,
            ExtraSignals = new string[] {"I"}
        }; 

        public DrawType DrawType { get; set; }
        public GridType GridType { get; set; }
        public int ImageWidth { get; set; }
        public int ImageHeight { get; set; }
        public bool GenerateHeader { get; set; }
        public bool GenerateImage { get; set; }
        public GridColor GridColor { get; set; }
        public SignalThickness SignalThickness { get; set; }
        public SignalGain SignalGain { get; set; }
        public bool IsWaterMarkRequired { get; set; }
        public string[] ExtraSignals { get; set; }
    }
}
