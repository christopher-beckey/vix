using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading;
using System.Threading.Tasks;
using System.Timers;
using System.Net;

namespace VixGetVersion
{
    class Program
    {
        static void Main(string[] args)
        {
            String vixRole = args[0];
            String confPath = args[1];
            if (HadCatalinaPropBeenChanged(confPath))
                return;

            if (GetVixVersion(vixRole))
            {
                Console.WriteLine("\nVIX is fully operational!");
                ChangeCatalinaProp(confPath);
                Console.WriteLine("\nCatalina properties successfully updated!");
            }
            else
            {
                Console.WriteLine("One or more VIX services are not operational! Please contact Support");
            }

            Console.WriteLine("\n<Return> to close this window");
            Console.Read();
        }

        private static void timer_Elapsed(object sender, ElapsedEventArgs e)
        {
            Console.Write(". ");
        }

        static bool GetVixVersion(String vixRole)
        {
            //var client = new System.Net.WebClient();
            //client.Headers.Add("user-agent", "Mozilla/5.0 (Windows NT 6.1; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/58.0.3029.110 Safari/537.36");

            Console.WriteLine(@"/-----------------------------------------------------------------------\");
            Console.WriteLine(@"|                                                                       |");

            if (vixRole.Equals("VIX"))
            Console.WriteLine(@"|                          Post VIX Installation                        |");
            else
            Console.WriteLine(@"|                         Post CVIX Installation                        |");

            Console.WriteLine(@"|                                                                       |");
            Console.WriteLine(@"\-----------------------------------------------------------------------/");
            
            Console.WriteLine("\nChecking " + vixRole + " status... Please wait... This may take a while.");
            
            var timer = new System.Timers.Timer(1000);
            timer.Enabled = true;
            timer.Elapsed += new ElapsedEventHandler(timer_Elapsed);
            timer.Start();

            Thread.Sleep(60000); //Wait for a minute to ensure the scan process has started

            var response = string.Empty;

            try
            {
                String url = @"http://localhost:8080/";

                HttpWebRequest request = (HttpWebRequest)WebRequest.Create(url);
                request.Timeout = 20 * 60 * 1000;
                request.ReadWriteTimeout = 20 * 60 * 1000;
                var wresp = (HttpWebResponse)request.GetResponse();

                Stream stream = wresp.GetResponseStream();
                //stream.Position = 0;
                StreamReader reader = new StreamReader(stream);
                response = reader.ReadToEnd();
                wresp.Close();
                reader.Close();
            }
            catch (System.Net.WebException e)
            {
                Console.WriteLine("\nStatus Code: " + e.Status);
            }

            timer.Stop();
            return (response.Contains("your current version is"));
        }


        static bool HadCatalinaPropBeenChanged(String conf)
        {
            String catalinaProp = conf + @"\catalina.properties";

            FileStream fs = new FileStream(catalinaProp, FileMode.OpenOrCreate, FileAccess.Read, FileShare.None);
            StreamReader sr = new StreamReader(fs);

            var line = "";
            var result = false;

            while ((line = sr.ReadLine()) != null)
            {
                if (line.Contains("tomcat.util.scan.StandardJarScanFilter.jarsToSkip=*.jar"))
                {
                    result = true;
                    break;
                }
            }

            fs.Close();
            return result;
        }

        static void ChangeCatalinaProp(String conf)
        {
            Console.WriteLine("\nChanging " + conf + @"\Catalina.properties to speed up startup process...");

            String savCatalinaProp = conf + @"\catalina.properties.sav";
            String catalinaProp = conf + @"\catalina.properties";
            String newCatalinaProp = conf + @"\newcatalina.properties";


            File.Delete(savCatalinaProp);
            File.Copy(catalinaProp, savCatalinaProp);

            FileStream fs = new FileStream(catalinaProp, FileMode.OpenOrCreate, FileAccess.Read, FileShare.None);
            FileStream nfs = new FileStream(newCatalinaProp, FileMode.Create, FileAccess.Write, FileShare.None);

            StreamReader sr = new StreamReader(fs);
            StreamWriter sw = new StreamWriter(nfs);
            var line = "";

            while ((line = sr.ReadLine()) != null)
            {
                if (line.Contains("tomcat.util.scan.StandardJarScanFilter.jarsToSkip="))
                {
                    line = @"tomcat.util.scan.StandardJarScanFilter.jarsToSkip=*.jar,\";
                }
                sw.WriteLine(line);
            }

            sw.Flush();
            fs.Close();
            nfs.Close();

            File.Delete(catalinaProp);
            File.Copy(newCatalinaProp, catalinaProp);
            File.Delete(newCatalinaProp);
        }



    }
}
