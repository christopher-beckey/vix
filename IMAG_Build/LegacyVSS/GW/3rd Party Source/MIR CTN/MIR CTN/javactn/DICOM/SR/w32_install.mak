install:
	$(MAKE)/f w32_install.mak ContentItem.class
	$(MAKE)/f w32_install.mak ContentItemFactory.class
	$(MAKE)/f w32_install.mak StructuredReport.class

ContentItem.class: ContentItem.java
	$(JDK_ROOT)\bin\javac ContentItem.java

ContentItemFactory.class: ContentItemFactory.java
	$(JDK_ROOT)\bin\javac ContentItemFactory.java

StructuredReport.class: StructuredReport.java
	$(JDK_ROOT)\bin\javac StructuredReport.java

clean:
	del *.class
