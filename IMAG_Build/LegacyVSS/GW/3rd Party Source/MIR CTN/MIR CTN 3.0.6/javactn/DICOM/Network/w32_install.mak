install:
	$(MAKE)/f w32_install.mak Association.class

	$(MAKE)/f w32_install.mak include_files
	copy *.h $(DICOM_ROOT)\javactn\jni_src

Association.class: Association.java
	$(JDK_ROOT)\bin\javac Association.java

include_files:
	$(JDK_ROOT)\bin\javah -jni DICOM.Network.Association

clean:
	del *.class
	del *.h
