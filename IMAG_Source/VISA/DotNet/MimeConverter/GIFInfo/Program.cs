using GifInformation;
using System;
using System.Collections.Generic;
using System.Drawing.Imaging;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace GifReader
{
    class Program
    {
        static void Main(string[] args)
        {
            //var path = @"C:\tmp\sample.gif";
            var path = args[0];
            var info = new GifInfo(path);
            if (info.Animated)
            {
                Console.WriteLine(@"TRUE");
            }
            else
            {
                Console.WriteLine(@"FALSE");
            }
            //for (int i = 0; i < info.Frames.Count - 1; i++)
            //{
            //    var frameFilePath = Path.Combine(Path.GetDirectoryName(path), $"{Path.GetFileNameWithoutExtension(path)}-{i.ToString()}.gif");
            //    var frame = info.Frames[i];

            //    Console.WriteLine(frameFilePath);

            //    frame.Save(frameFilePath, ImageFormat.Gif);
            //}

            //Console.ReadLine();
            System.Environment.ExitCode = 0;
        }

    }
}

