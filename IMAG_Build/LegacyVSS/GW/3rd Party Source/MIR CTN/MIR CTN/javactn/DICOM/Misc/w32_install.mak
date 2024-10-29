install:
	$(MAKE)/f w32_install.mak CodedValue.class
	$(MAKE)/f w32_install.mak PaletteColor.class
	$(MAKE)/f w32_install.mak Timer.class

	$(MAKE)/f w32_install.mak include_files
	copy *.h $(DICOM_ROOT)\javactn\jni_src

CodedValue.class: CodedValue.java
	$(JDK_ROOT)\bin\javac CodedValue.java

PaletteColor.class: PaletteColor.java
	$(JDK_ROOT)\bin\javac PaletteColor.java

Timer.class: Timer.java
	$(JDK_ROOT)\bin\javac Timer.java

include_files:
	$(JDK_ROOT)\bin\javah -jni DICOM.Misc.Timer

clean:
	del *.class
	del *.h
