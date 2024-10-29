using Hydra.ECG;
using System;
using System.Collections;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Drawing.Imaging;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace SVGTest
{
    public partial class Form1 : Form
    {
        private bool _exported = false;

        public Form1()
        {
            InitializeComponent();

            textBox1.Text = @"C:\ProgramData\ISI Imaging\Hydra\TestImages\SampleECGs\ZZT00000000360.DCM";
        }

        private void BrowseButton_Click(object sender, EventArgs e)
        {
            OpenFileDialog dlg = new OpenFileDialog();
            dlg.Filter = "Dicom Files (.dcm)|*.dcm|All Files (*.*)|*.*";
            dlg.FilterIndex = 1;
            dlg.Multiselect = true;

            if (dlg.ShowDialog() == System.Windows.Forms.DialogResult.OK)
                textBox1.Text = dlg.FileName;
        }

        private void ExportBitmapButton_Click(object sender, EventArgs e)
        {
            _exported = true;
            ExportBitmap();
        }

        void ExportBitmap()
        {
            if (!_exported)
                return;

            if (string.IsNullOrEmpty(textBox1.Text))
                return;

            ExportOptions export = new ExportOptions 
            { 
                DrawType = DrawType.ThreeXFourPlusThree, 
                GridType = GridType.OneMillimeters,
                ImageWidth = this.pictureBox1.ClientRectangle.Width, 
                ImageHeight = this.pictureBox1.ClientRectangle.Height, 
                GenerateHeader = true,
                GenerateImage = true,
                GridColor = GridColor.Red,
                SignalThickness = SignalThickness.One,
                SignalGain = SignalGain.Ten,
                IsWaterMarkRequired = true,
                ExtraSignals = new string[] {"V6", "I", "III"}
            };

            ECGInfo ecgInfo = null;
            Bitmap bitmap = ECGExporter.ToBitmap(textBox1.Text, "DICOM", export, out ecgInfo);
            this.pictureBox1.Image = bitmap;
        }

        void ExportSvg()
        {
            ECGInfo ecgInfo = null;
            string svgText = ECGExporter.ToSvg(textBox1.Text, "DICOM", ExportOptions.Default, out ecgInfo);
            File.WriteAllText(@"C:\ProgramData\ISI Imaging\Hydra\TestImages\SampleECGs\out.svg", svgText);
        }

        private void Form1_Resize(object sender, EventArgs e)
        {
            ExportBitmap();
        }
    }
}
