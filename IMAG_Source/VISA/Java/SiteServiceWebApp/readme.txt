The site service web app must be deployed with the web app name vistawebsvcs so that Clinical Display and VistARad can find it.  This will allow the domain name for the site service to be updated without changing the value in the network location

The URLs for the site service in this web app are:

/vistawebsvcs/siteservice.asmx

/vistawebsvcs/ImagingExchangeSiteService.asmx

These names ARE case sensitive so Clinical Display can find them properly.

To make VistARad find the site service properly, a second entry in the Tomcat/conf/server.xml needs to be made for the web app containing the proper case (probably VistaWebSvcs)