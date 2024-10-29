install:
	$(MAKE)/f w32_install.mak GeneralEquipmentModule.class
	$(MAKE)/f w32_install.mak GeneralSeriesModule.class
	$(MAKE)/f w32_install.mak GeneralStudyModule.class
	$(MAKE)/f w32_install.mak ImagePixelModule.class
	$(MAKE)/f w32_install.mak PatientModule.class
	$(MAKE)/f w32_install.mak SOPCommonModule.class
	$(MAKE)/f w32_install.mak SRDocumentContentModule.class
	$(MAKE)/f w32_install.mak SRDocumentGeneralModule.class
	$(MAKE)/f w32_install.mak SRDocumentSeriesModule.class
	$(MAKE)/f w32_install.mak WaveformModule.class
	$(MAKE)/f w32_install.mak WaveformChannel.class
	$(MAKE)/f w32_install.mak include_files
	copy *.h $(DICOM_ROOT)\javactn\jni_src

GeneralEquipmentModule.class: GeneralEquipmentModule.java
	$(JDK_ROOT)\bin\javac GeneralEquipmentModule.java

GeneralSeriesModule.class: GeneralSeriesModule.java
	$(JDK_ROOT)\bin\javac GeneralSeriesModule.java

GeneralStudyModule.class: GeneralStudyModule.java
	$(JDK_ROOT)\bin\javac GeneralStudyModule.java

ImagePixelModule.class: ImagePixelModule.java
	$(JDK_ROOT)\bin\javac ImagePixelModule.java

PatientModule.class: PatientModule.java
	$(JDK_ROOT)\bin\javac PatientModule.java

SOPCommonModule.class: SOPCommonModule.java
	$(JDK_ROOT)\bin\javac SOPCommonModule.java

SRDocumentContentModule.class: SRDocumentContentModule.java
	$(JDK_ROOT)\bin\javac SRDocumentContentModule.java

SRDocumentGeneralModule.class: SRDocumentGeneralModule.java
	$(JDK_ROOT)\bin\javac SRDocumentGeneralModule.java

SRDocumentSeriesModule.class: SRDocumentSeriesModule.java
	$(JDK_ROOT)\bin\javac SRDocumentSeriesModule.java

WaveformModule.class: WaveformModule.java
	$(JDK_ROOT)\bin\javac WaveformModule.java

WaveformChannel.class: WaveformChannel.java
	$(JDK_ROOT)\bin\javac WaveformChannel.java

include_files:
	$(JDK_ROOT)\bin\javah -jni DICOM.Module.ImagePixelModule
	$(JDK_ROOT)\bin\javah -jni DICOM.Module.WaveformModule


clean:
	del *.class
	del *.h
