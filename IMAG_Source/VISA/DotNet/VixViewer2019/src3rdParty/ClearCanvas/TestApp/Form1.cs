using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

using ClearCanvas.ImageViewer.StudyManagement;
using ClearCanvas.ImageViewer;

namespace TestApp
{
    public partial class Form1 : Form
    {
        public Form1()
        {
            InitializeComponent();
        }

        private void buttonLoadImage_Click(object sender, EventArgs e)
        {
            LocalSopDataSource dicomDataSource = new LocalSopDataSource(textBoxFilePath.Text);
            ImageSop imagesop = new ImageSop(dicomDataSource);

            IPresentationImage presentationImage = PresentationImageFactory.Create(imagesop.Frames[1]);

            Bitmap bmp = presentationImage.DrawToBitmap(256, 256);

            pictureBox1.Image = bmp;
        }

        private void buttonBrowse_Click(object sender, EventArgs e)
        {
            OpenFileDialog dlg = new OpenFileDialog();

            // Set filter options and filter index.
            dlg.Filter = "All Files (*.*)|*.*";
            dlg.FilterIndex = 1;
            dlg.Multiselect = false;

            if (dlg.ShowDialog() == System.Windows.Forms.DialogResult.OK)
            {
                textBoxFilePath.Text = dlg.FileName;
            }

        }
    }
}
