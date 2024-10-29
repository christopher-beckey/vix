using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.IO;
using log4net;
using Hydra.VIX.Conversions;

namespace ImageConverter
{
    class Program
    {
        static void Main(string[] args)
        {

            //check arguments for appropriated values
            //string[] args = Environment.GetCommandLineArgs(); // note arg[0] contains .exe filespec
            if (args.Length < 4) // .exe, build config filespec, action at a minimum
            {
                usage();
                System.Environment.ExitCode = 1;
                return;
            }

            if (String.IsNullOrEmpty(args[0]))
            {
                Console.Write("Empty executable filepsec returned from Environment.GetCommandLineArgs()");
                System.Environment.ExitCode = 1;
                return;
            }
            string filepath = args[0];
            string inFilename = args[1];
            string mimeType = args[2];
            string outFilename = args[3];


            //setup log files and logging
            try
            {
                string logConfigFile = "ImageConverterConfig.xml";
                if (!File.Exists(logConfigFile))
                {
                    throw new HydraConversionException("Error " + logConfigFile + " not found.");
                }
                log4net.Config.XmlConfigurator.Configure(new System.IO.FileInfo(logConfigFile));
            }
            catch (Exception ex)
            {
                LogError(ex.Message);
                System.Environment.ExitCode = 1;
                return;
            }

            //call Image Converter conversion method
            try
            {
                LogInfo("Converting " + inFilename + " with mime type [" + mimeType + "] to .jpeg");
                ImageToJPEGConverter.convertImageToJPEG(filepath, inFilename, mimeType, outFilename);
                LogInfo("Successfully converted image to " + outFilename + ".jpeg");
            }
            catch(Exception ex)
            {
                LogError(ex.Message);
                System.Environment.ExitCode = 1;
                return;
            }

            System.Environment.ExitCode = 0;
        }

        private static ILog Logger()
        {
           return LogManager.GetLogger("ImageConverter");
        }

        private static String LogError(String infoMessage)
        {
            Logger().Error(infoMessage);
            return infoMessage;
        }

        private static String LogInfo(String infoMessage)
        {
            Logger().Info(infoMessage);
            return infoMessage;
        }

        private static void usage()
        {
            StringBuilder sb = new StringBuilder();
            sb.AppendLine("Hydra VIX Image Conversion Utility.");
            sb.AppendLine("Usage:");
            sb.AppendLine("ImageConverter");
            sb.AppendLine("\tdisplays this help information");

            sb.AppendLine("ImageConverter Filepath inFilename mimeType outFilename");
            sb.AppendLine("\tConverts input image file to an output JPEG image file.");
            sb.AppendLine("\tFilepath-temporary file location to store both inFilename and outFilename.");
            sb.AppendLine("\tinFilename-filename of input image to be converted.");
            sb.AppendLine("\tmimeType-mime type of the input image to be converted.");
            sb.AppendLine("\toutFilename-output filename of the converted JPEG image.");
            sb.AppendLine("");

            Console.Write(sb.ToString());
        }
    }
}
