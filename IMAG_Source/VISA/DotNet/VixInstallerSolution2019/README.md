# README FILE FOR VIX INSTALLATION 2019 AND VixCertficateUtil

- DELIVERABLES: VixInstallerSetup.msi (which gets renamed for final delivery in a different process) and VixCertficateUtil.zip

- You must install IMAG_MS2019\.vsconfig components and the IMAG_MS2019\InstallerProjects.vsix extension to open this .sln in Visual Studio 2019.

- VixInstallerSetup folder:
  - Before the official build, you need to copy the official VixDistribution.zip to this folder.
  - For unofficial/development builds, you can run BuildTest, which temporarily copies a placeholder during the build.
    ***If you want to build in Visual Studio, you will need to do the temporary copy yourself.***

- VixCertificateUtil folder:
  - Update MAG3_0Pnnn_CVIX_Certificate_Maintenance.docx for each patch release and save it as a PDF.

- VixGetVersion is UNUSED

- VixInstallerNightly is used for nightly deploys from the command line.