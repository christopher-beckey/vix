install:
	$(MAKE)/f w32_install.mak CompositeFactory.class
	$(MAKE)/f w32_install.mak CompositeObject.class
	$(MAKE)/f w32_install.mak Image.class
	$(MAKE)/f w32_install.mak Waveform.class

	$(MAKE)/f w32_install.mak include_files
	copy *.h $(DICOM_ROOT)\javactn\jni_src

CompositeFactory.class: CompositeFactory.java
	$(JDK_ROOT)\bin\javac CompositeFactory.java

CompositeObject.class: CompositeObject.java
	$(JDK_ROOT)\bin\javac CompositeObject.java

Image.class: Image.java
	$(JDK_ROOT)\bin\javac Image.java

Waveform.class: Waveform.java
	$(JDK_ROOT)\bin\javac Waveform.java

include_files:
	$(JDK_ROOT)\bin\javah -jni DICOM.InfoObj.Image
	$(JDK_ROOT)\bin\javah -jni DICOM.InfoObj.Waveform

clean:
	del *.class
	del *.h
