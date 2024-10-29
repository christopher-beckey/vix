using System;
using System.Collections.Generic;
using System.IO;
using System.IO.Compression;
using System.Text;
using System.Text.RegularExpressions;
using System.Xml;

namespace AssembleMSI
{
    class Program
    {
        static void Main(string[] args)
        {
            try
            {
                if (args == null || args.Length == 0)
                {
                    Console.WriteLine("Please insert the arguments!");
                }
                else
                {
                    //Obtain the patch number as the first argument
                    string patchNum = args[0];
                    //Obtain the VIX Type (ie. VIX or CVIX) as the second argument
                    string VIXType = args[1];
                    //Obtain the Release Type (ie. Debug or Release) as the third argument 
                    string releaseType = args[2];
                    //Determine the major patch number (ie. 269)
                    string[] patchNumSplit = patchNum.Split('.');
                    string majorPatchNum = patchNumSplit[1];               
                    //Set the path of the VIX type folder from the repository
                    string repositoryPath = @".\ic\IMAG_" + VIXType;
                    //Set the path of the payloads
                    string payloadDirectory = @".\payloads";
                    //Set the root path
                    string rootDirectory = @".\";
                    //Set the payload destination path for the patch
                    string payloadPatchDestinationPath = @".\payloads\" + patchNum;
                    
                    //Prepares the payload directory
                    PreparePayloadDirectory(payloadDirectory);
                    //Copy all the artificats from the path of the VIX type folder from the repository
                    //into the payload directory
                    CopyPayloadArtifacts(payloadPatchDestinationPath, repositoryPath);

                    //Gets the current build manifest file for the patch and role type
                    string buildMani2 = VIXType + ".xml";
                    string buildManifestFileName = @"\VixBuildManifestPatch" + majorPatchNum + buildMani2;
                    string buildManifestFolder = @".\ic\IMAG_Build\Configuration\VisaBuildConfiguration";
                    var manifestFilespec = buildManifestFolder + buildManifestFileName;
					
					//Forces uses of buildmanifest with 2019 in the VixInstallerSolution path
					string buildManifestFileDirPath = Path.GetDirectoryName(manifestFilespec);
                    string buildManifestFileNameWithoutExtension = Path.GetFileNameWithoutExtension(manifestFilespec);
                    string buildManifestExtensionWithDot = Path.GetExtension(manifestFilespec);
                    string oldbuildManifestFilePath = Path.Combine(buildManifestFileDirPath, buildManifestFileNameWithoutExtension);
                    string newBuildManifestFilePath = oldbuildManifestFilePath + "2019.xml";
                    string text = File.ReadAllText(manifestFilespec);
                    text = text.Replace("VixInstallerSolution2013.root<", "VixInstallerSolution2019<");
                    text = text.Replace(@"VixInstallerSolution2013.root\VixInstallerSolution2013", "VixInstallerSolution2019");
                    File.WriteAllText(newBuildManifestFilePath, text);
                    manifestFilespec = newBuildManifestFilePath;

                    //Load the current build manifest file
                    XmlDocument manifest = new XmlDocument();
                    manifest.Load(manifestFilespec);

                    //Read the DeploymentArtifacts from the current build manifest file to determine which files to bring into the payload destination path
                    // (ie.) jars, wars, and property files 
                    XmlNodeList xmlDeploymentArtifacts1 = manifest.SelectNodes("Build/DeploymentArtifacts/DeploymentArtifact");
                    DeploymentArtifact[] deploymentArtifacts = GetDeploymentArtifacts(xmlDeploymentArtifacts1, patchNum);
                    XmlNodeList xmlDeploymentArtifacts2 = manifest.SelectNodes("Build/RepositoryDeploymentArtifacts/DeploymentArtifact");
                    DeploymentArtifact[] buildRepositoryDeploymentArtifacts = GetDeploymentArtifacts(xmlDeploymentArtifacts2, patchNum);
                    List<DeploymentArtifact> artifacts = new List<DeploymentArtifact>();
                    artifacts.AddRange(deploymentArtifacts);
                    artifacts.AddRange(buildRepositoryDeploymentArtifacts);

                    foreach (DeploymentArtifact deploymentArtifact in artifacts)
                    {
                        // note destination usually is a directory specification but can sometimes be a file specification (specification means fully qualified name)
                        string destinationFilespec = deploymentArtifact.DestinationFilespec;

                        if (string.IsNullOrEmpty(destinationFilespec))
                        {
                            continue;
                        }

                        string sourceFileSpec = deploymentArtifact.SourceFilespec;

                        File.Copy(sourceFileSpec, destinationFilespec, true);
                        File.SetAttributes(destinationFilespec, FileAttributes.Normal);
                    }

                    // Zip up the payload into VixDistribution.zip
                    string zipFilespec = System.IO.Path.Combine(rootDirectory, "VixDistribution.zip");
                    string zipFilespecDest = System.IO.Path.Combine(payloadDirectory, "VixDistribution.zip");
                    if (File.Exists(zipFilespec))
                    {
                        File.Delete(zipFilespec);
                    }
                    ZipFile.CreateFromDirectory(payloadDirectory, zipFilespec, CompressionLevel.Optimal, false);
                    //Move the zip file to its destination in the payload destination path
                    System.IO.File.Move(zipFilespec, zipFilespecDest);

                    // Copy payload zip file to VixInstaller directories
                    string VixInstallerDirspec = @".\ic\IMAG_Source\VISA\DotNet\VixInstallerSolution2019";
                    string VixInstallerSetupFilespec = System.IO.Path.Combine(VixInstallerDirspec, @"VixInstallerSetup\VixDistribution.zip");
                    string VixInstallerBinPathPart = @"VixInstaller\bin\" + releaseType + @"\Vix";
                    string VixInstallerBinVixDirspec = System.IO.Path.Combine(VixInstallerDirspec, VixInstallerBinPathPart);
                    string VixInstallerBinVixFilespec = System.IO.Path.Combine(VixInstallerBinVixDirspec, @"VixDistribution.zip");

                    File.Copy(zipFilespecDest, VixInstallerSetupFilespec, true);
                    if (Directory.Exists(VixInstallerBinVixDirspec))
                    {
                        Directory.Delete(VixInstallerBinVixDirspec, true);
                    }
                    Directory.CreateDirectory(VixInstallerBinVixDirspec);
                    File.Copy(zipFilespecDest, VixInstallerBinVixFilespec, true);
                }
            }
            catch (Exception ex)
            {
                Console.WriteLine(ex.Message);
            }
        }

        private static void PreparePayloadDirectory(string payloadRootDir)
        {
            if (Directory.Exists(payloadRootDir))
            {
                Directory.Delete(payloadRootDir, true); // recurse
            }
            Directory.CreateDirectory(payloadRootDir);
        }

        public static void CopyPayloadArtifacts(string payloadRootDir, string repositoryPayloadRootDirspec)
        {
            // copy payload skeleton and files from deployment repository
            CopyAll(new DirectoryInfo(repositoryPayloadRootDirspec), new DirectoryInfo(payloadRootDir));
        }

        protected static void CopyAll(DirectoryInfo source, DirectoryInfo target)
        {
            // Check if the target directory exists, if not, create it.
            if (Directory.Exists(target.FullName) == false)
            {
                Directory.CreateDirectory(target.FullName);
            }

            // Copy each file into it’s new directory.
            foreach (FileInfo fileInfo in source.GetFiles())
            {
                if (fileInfo.Name.StartsWith("vssver")) // silently skip any source safe marker files
                {
                    continue;
                }

                string targetFilespec = System.IO.Path.Combine(target.ToString(), fileInfo.Name);
                fileInfo.CopyTo(targetFilespec, true);
                File.SetAttributes(targetFilespec, FileAttributes.Normal);
            }

            foreach (DirectoryInfo sourceDirectoryInfo in source.GetDirectories())
            {
                DirectoryInfo targetDirectoryInfo = target.CreateSubdirectory(sourceDirectoryInfo.Name);
                CopyAll(sourceDirectoryInfo, targetDirectoryInfo); //recurse
            }
        }

        private static DeploymentArtifact[] GetDeploymentArtifacts(XmlNodeList xmlDeploymentArtifacts, string patchNumber)
        {
            List<DeploymentArtifact> deploymentArtifacts = new List<DeploymentArtifact>();

            foreach (XmlNode xmlDeploymentArtifact in xmlDeploymentArtifacts)
            {
                string sourceFilespec = GetDeploymentArtifactSourceFilespec(xmlDeploymentArtifact, patchNumber);
                string destinationFilespec = GetDeploymentArtifactDestinationFilespec(xmlDeploymentArtifact, sourceFilespec, patchNumber);
                string devDestinationFilespec = GetDeploymentArtifactDevDestinationFilespec(xmlDeploymentArtifact, sourceFilespec, patchNumber);

                VixDependencyType dependencyType = (VixDependencyType)Enum.Parse(typeof(VixDependencyType), xmlDeploymentArtifact.Attributes["dependencyType"].Value.Trim());

                DeploymentArtifact deployProject = new DeploymentArtifact(sourceFilespec, destinationFilespec, devDestinationFilespec, dependencyType);
                deploymentArtifacts.Add(deployProject);
            }

            return deploymentArtifacts.ToArray();
        }

        private static string GetDeploymentArtifactSourceFilespec(XmlNode xmlDeploymentArtifact, string patchNumber)
        {
            string sourceFilespec;
            string sourceRelativeFilespec;
            string sourceRelativeDirspec;
            string sourceDirspec;
            StringBuilder sb = new StringBuilder();

            if (xmlDeploymentArtifact.ParentNode.Name == "RepositoryDeploymentArtifacts")
            {
                sb.AppendFormat("Repository[@repositoryType='RationalTeamConcert']");
                XmlNode xmlRepository = xmlDeploymentArtifact.SelectSingleNode(sb.ToString());

                sourceRelativeFilespec = xmlRepository.InnerText.Trim();
                sourceRelativeDirspec = xmlRepository.Attributes["source"].Value.Trim();
                sourceDirspec = PerformStringSubstitution(sourceRelativeDirspec, patchNumber);
            }
            else
            {
                sourceRelativeFilespec = xmlDeploymentArtifact.InnerText.Trim();
                sourceRelativeDirspec = xmlDeploymentArtifact.Attributes["source"].Value.Trim();
                sourceDirspec = PerformStringSubstitution(sourceRelativeDirspec, patchNumber);
            }
            sourceFilespec = Path.Combine(sourceDirspec, sourceRelativeFilespec);

            return sourceFilespec;
        }

        private static string GetDeploymentArtifactDestinationFilespec(XmlNode xmlDeploymentArtifact, string sourceFilespec, string patchNumber)
        {
            string destinationFilespec;
            string destAttribValue;
            string destination;
            string sourceFilename = Path.GetFileName(sourceFilespec);

            StringBuilder sb = new StringBuilder();

            if (xmlDeploymentArtifact.ParentNode.Name == "RepositoryDeploymentArtifacts")
            {
                sb.AppendFormat("Repository[@repositoryType='RationalTeamConcert']");
                XmlNode xmlRepository = xmlDeploymentArtifact.SelectSingleNode(sb.ToString());

                destAttribValue = xmlRepository.Attributes["dest"].Value.Trim();
                destination = PerformStringSubstitution(destAttribValue, patchNumber);
            }
            else
            {
                destAttribValue = xmlDeploymentArtifact.Attributes["dest"].Value.Trim();

                if (string.IsNullOrEmpty(destAttribValue))
                {
                    destination = ""; // a missing dest attribute is allowed - will signal skip artifact for a payload deploy
                }
                else
                {
                    destination = PerformStringSubstitution(destAttribValue, patchNumber);
                }
            }
            if (String.IsNullOrEmpty(destination)) // an empty devDest attribute is allowed - will signal skip artifact for a development deploy
            {
                destinationFilespec = "";
            }
            else if (String.IsNullOrEmpty(Path.GetExtension(destination))) // no extension means its a directory - fragile but unavoidable
            {
                destinationFilespec = Path.Combine(destination, sourceFilename);
            }
            else // its a file
            {
                destinationFilespec = destination;
            }

            return destinationFilespec;
        }

        private static string GetDeploymentArtifactDevDestinationFilespec(XmlNode xmlDeploymentArtifact, string sourceFilespec, string patchNumber)
        {
            string devDestinationFilespec;
            string sourceFilename = Path.GetFileName(sourceFilespec);
            string destination;

            string devDestAttrib = xmlDeploymentArtifact.Attributes["devDest"].Value.Trim();

            if (xmlDeploymentArtifact.Attributes["devDest"] == null)
            {
                destination = ""; // a missing devDest attribute is allowed
            }
            else
            {
                destination = PerformStringSubstitution(devDestAttrib, patchNumber);
            }

            if (String.IsNullOrEmpty(destination)) // an empty devDest attribute is allowed - will signal skip artifact for a development deploy
            {
                devDestinationFilespec = "";
            }
            else if (String.IsNullOrEmpty(Path.GetExtension(destination))) // no extension means its a directory - fragile but unavoidable
            {
                devDestinationFilespec = Path.Combine(destination, sourceFilename);
            }
            else // its a file
            {
                devDestinationFilespec = destination;
            }

            return devDestinationFilespec;
        }

        private static string PerformStringSubstitution(string source, string patchNumber)
        {
            Regex regex = new Regex(@"%\w*%");

            if (regex.IsMatch(source))
            {
                MatchCollection matches = regex.Matches(source);
                // reverse iteration so offsets don't get hosed
                for (int i = 0; i < matches.Count; i++)
                {
                    Match match = matches[i];
                    string substitute = GetSubstituteValue(match.Value, patchNumber);
                    //string substitute = (match.Value);
                    source = source.Replace(match.Value, substitute);
                }
            }
            return source;
        }

        private static string GetSubstituteValue(string str, string patchNumber)
        {
            string substitute = null;
            string substituteTypeAsString = str.Replace("%", "");
            try
            {
                SubstitutionType substitutionType = (SubstitutionType)Enum.Parse(typeof(SubstitutionType), substituteTypeAsString);
                switch (substitutionType)
                {
                    case SubstitutionType.buildversion:
                        substitute = patchNumber;
                        break;
                    case SubstitutionType.mavenrepo:
                        substitute = @".\ij\M2\repository";
                        break;
                    case SubstitutionType.payload:
                        substitute = @".\payloads";
                        break;
                    case SubstitutionType.tomcat:
                        substitute = @"C:\Program Files\Apache Software Foundation\Tomcat 9.0";
                        break;
                    case SubstitutionType.rtc:
                        substitute = @".\ic"; ;
                        break;
                    case SubstitutionType.jre:
                        substitute = Environment.GetEnvironmentVariable("JRE_HOME", EnvironmentVariableTarget.Machine);
                        break;
                    case SubstitutionType.vixconfig:
                        substitute = Environment.GetEnvironmentVariable("vixconfig", EnvironmentVariableTarget.Machine);
                        if (String.IsNullOrEmpty(substitute))
                        {
                            substitute = @"C:\VixConfig";
                        }
                        break;
                    case SubstitutionType.workspace:
                        substitute = @".\ic\IMAG_Source\VISA\Java";
                        break;
                }
                return substitute;
            }
            catch (Exception ex)
            {
                Console.WriteLine(ex.Message);
            }
            return substitute;
        }
    }

    public class DeploymentArtifact
    {
        public string SourceFilespec { get; set; }
        public string DestinationFilespec { get; set; }
        public string DevDestinationFilespec { get; set; }
        public VixDependencyType DependencyType { get; set; }
        public DeploymentArtifact(string sourceFilespec, string destinationFilespec, string devDestinationFilespec,
                    VixDependencyType dependencyType)
        {
            this.SourceFilespec = sourceFilespec;
            this.DestinationFilespec = destinationFilespec;
            this.DevDestinationFilespec = devDestinationFilespec;
            this.DependencyType = dependencyType;
        }
    }

    public enum VixDependencyType
    {
        AppExtensionJar, XmlConfigFile, OpenSourceDll, CommercialDll, OpenSourceJar,
        ModifiedOpenSourceJar, CommercialJar, AppJar, AppWar, JavaPropertyFile, ZipConfigFile, ResourceFile, TextFile, InHouseDll, Other, InstallerManifest
    };

    public enum SubstitutionType { workspace, mavenrepo, payload, tomcat, buildversion, jre, vixconfig, cc, rtc };
}
