install:
	$(MAKE)/f w32_install.mak CodeItem.class
	$(MAKE)/f w32_install.mak CodeManager.class

CodeItem.class: CodeItem.java
	$(JDK_ROOT)\bin\javac CodeItem.java

CodeManager.class: CodeManager.java
	$(JDK_ROOT)\bin\javac CodeManager.java

clean:
	del *.class
