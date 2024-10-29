using System;
using System.Collections.Generic;
using System.Configuration.Install;
using System.Linq;
using System.Reflection;
using System.Security.Principal;
using System.Text;
using System.Threading.Tasks;

namespace VIX.Viewer.Service
{
    class ServiceController
    {
        static internal void Run(string[] args, string serviceName)
        {
            string cmd = (args.Length > 0) ? args[0] : null;
            bool interactive = string.IsNullOrEmpty(cmd);

            Console.WriteLine($"{serviceName} ({Globals.ConfigFilePath})");
            if (!IsElevated)
            {
                Console.WriteLine("Run this program in elevated mode");
                if (interactive)
                {
                    Console.ReadLine();
                }
                return;
            }

            if (interactive)
            {
                Console.WriteLine("Press i to install, u to uninstall, c to run in console mode...");
                cmd = "-" + Console.ReadLine();
            }

            switch (cmd)
            {
                case "-install":
                case "-i":
                    {
                        ManagedInstallerClass.InstallHelper(new string[] { Assembly.GetExecutingAssembly().Location });
                        break;
                    }

                case "-uninstall":
                case "-u":
                    {
                        ManagedInstallerClass.InstallHelper(new string[] { "/u", Assembly.GetExecutingAssembly().Location });
                        break;
                    }

                case "-console":
                case "-c":
                    {
                        Service.RunConsole();
                        interactive = false;
                        break;
                    }
            }

            if (interactive)
            {
                Console.WriteLine("Press any key to exit");
                Console.ReadKey();
            }
        }

        bool ServiceExists(string serviceName)
        {
            return System.ServiceProcess.ServiceController.GetServices().Any(s => s.ServiceName == serviceName);
        }

        static bool IsElevated
        {
            get
            {
                return new WindowsPrincipal(WindowsIdentity.GetCurrent()).IsInRole(WindowsBuiltInRole.Administrator);
            }
        }
    }
}
