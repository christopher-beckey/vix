After running wsdl2java to generate the webservice code do the following:

1.) move the following files from ExchangeCommon into ExchangeDataSource:
  a.) gov.va.med.imaging.exchange.webservices.soap.v2.ImageMetadataService.java
  b.) gov.va.med.imaging.exchange.webservices.soap.v2.ImageMetadataServiceLocator.java
  c.) gov.va.med.imaging.exchange.webservices.soap.v2.ImageMetadataSoapBindingStub.java
  
2.) move the following files from ExchangeCommon into ExchangeWebApp:
  a.) gov.va.med.imaging.exchange.webservices.soap.v2.ImageMetadataServiceImpl.java
  b.) gov.va.med.imaging.exchange.webservices.soap.v2.ImageMetadataSoapBindingSkeleton.java
  c.) deploy.wsdd
  d.) undeploy.wsdd
  
3.) Modify ImageMetadataServiceImpl as follows:
  a.) delete all methods from the class
  b.) extend gov.va.med.imaging.exchange.webservices.ExchangeWebservicesV2
