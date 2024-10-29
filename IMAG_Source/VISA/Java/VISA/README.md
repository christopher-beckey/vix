# README FILE FOR JAVA VISA 

# Note: Current VISA/pom.xml is populated using Patch VixBuildManifestPatch269VIX.xml and VixBuildManifestPatch269CVIX.xml

# To Build
1. Populate the modules in VISA/pom.xml into the correct profile, with what is present in the 
patch XXX desired build manifest file for VIX or CVIX, if not using the current version 
noted above. Either

IMAG_Build\Configuration\VisaBuildConfiguration\VixBuildManifestPatchXXXCVIX.xml
or
IMAG_Build\Configuration\VisaBuildConfiguration\VixBuildManifestPatchXXXVIX.xml 

2. Ensure correct Java and Maven versions are installed and configured correctly.
3. Ensure all necessary jar files are present in Maven m2 repository.
4. Open command prompt and cd to the local file location ...\IMAG_Source\VISA\Java\VISA. 
Then enter for the VIX Build:
mvn clean install -f pom.xml -P VIX_Build -DBUILD_VERSION=0.1 -DJAVA_VERSION=1.8 -Dmaven.test.skip=true
Then enter for the CVIX Build:
mvn clean install -f pom.xml -P CVIX_Build -DBUILD_VERSION=0.1 -DJAVA_VERSION=1.8 -Dmaven.test.skip=true
