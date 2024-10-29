using Hydra.IX.Common;
using Hydra.Log;
using System.Linq;
using System.ServiceProcess;

namespace VIX.Render.Service
{
    static class Program
    {
        private static readonly ILogger _StartupLogger = LogManager.GetStartupLogger();

        /// <summary>
        /// The main entry point for the application.
        /// </summary>
        static void Main(string[] args)
        {
            //VAI-780: Simplify config file path
            #region Provide the ability to override the hard-coded config file path using -config configFilePath command line arguments
            if (args != null)
            {
                for (int i = 0; i < args.Count(); i++)
                {
                    if (args[i] == "-config")
                    {
                        if (i != args.Count())
                        {
                            args = args.Where((source, index) => index != i).ToArray();
                            Globals.OverideConfigFilePath(args[i]);
                            args = args.Where((source, index) => index != i).ToArray(); //swallow the configfile
                            break;
                        }
                    }
                }
            }
            #endregion
            ConfigurationLocator.ResolveConfigFilePath(Globals.ConfigFilePath);
            LogManager.Configuration = new LogConfiguration(Globals.ConfigFilePath);
            _StartupLogger.Info("Starting Vix Render Service", "ConfigFilePath", Globals.ConfigFilePath);

            if (System.Environment.UserInteractive)
            {
                ServiceController.Run(args, "VIX Render Service");
            }
            else
            {
                ServiceBase[] ServicesToRun;
                ServicesToRun = new ServiceBase[] 
                { 
                    new Service() 
                };
                ServiceBase.Run(ServicesToRun);
            }
        }
    }
}
