using Hydra.VIX.Conversions;
using log4net;
using System;
using System.IO;
using System.Text;


namespace VideoConverter
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
                string logConfigFile = "VideoConverterConfig.xml";
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

            //call Video Converter conversion method
            try
            {
                LogInfo("Converting " + inFilename + " with mime type [" + mimeType + "] to .avi");
                Boolean isConverted = VideoToAVIConverter.convertVideoToAVI(filepath, inFilename, mimeType, outFilename);
                if (isConverted)
                {
                    LogInfo("Successfully converted video to " + outFilename + ".avi");
                }
            }
            catch (Exception ex)
            {
                LogError(ex.Message);
                System.Environment.ExitCode = 1;
                return;
            }

            System.Environment.ExitCode = 0;
        }

        private static ILog Logger()
        {
            return LogManager.GetLogger("VideoConverter");
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
            sb.AppendLine("Hydra VIX Video Conversion Utility.");
            sb.AppendLine("Usage:");
            sb.AppendLine("VideoConverter");
            sb.AppendLine("\tdisplays this help information");

            sb.AppendLine("VideoConverter Filepath inFilename mimeType outFilename");
            sb.AppendLine("\tConverts input video file to an output AVI video file.");
            sb.AppendLine("\tFilepath-temporary file location to store both inFilename and outFilename.");
            sb.AppendLine("\tinFilename-filename of input video to be converted.");
            sb.AppendLine("\tmimeType-mime type of the input video to be converted.");
            sb.AppendLine("\toutFilename-output filename of the converted AVI video.");
            sb.AppendLine("");

            Console.Write(sb.ToString());
        }

    }
}
