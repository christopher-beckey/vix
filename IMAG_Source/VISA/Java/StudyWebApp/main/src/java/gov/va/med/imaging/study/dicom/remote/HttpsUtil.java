package gov.va.med.imaging.study.dicom.remote;

import gov.va.med.imaging.rest.types.RestStringType;
import gov.va.med.imaging.study.dicom.DicomService;
import gov.va.med.imaging.study.dicom.PatVistaInfo;
import gov.va.med.imaging.study.dicom.remote.study.StudyResultWrapper;
import gov.va.med.imaging.study.rest.types.LoadedStudyType;
import gov.va.med.imaging.study.rest.types.StudiesResultType;
import gov.va.med.imaging.study.rest.types.StudyFilterType;
import gov.va.med.imaging.url.vista.StringUtils;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import javax.net.ssl.*;
import javax.xml.bind.JAXB;
import javax.xml.bind.JAXBContext;
import javax.xml.bind.Marshaller;
import java.io.*;
import java.net.*;
import java.nio.charset.StandardCharsets;
import java.security.cert.X509Certificate;
import java.util.*;

public class HttpsUtil implements AutoCloseable {

    private static String token;
    private final static Logger LOGGER = LogManager.getLogger(HttpsUtil.class);
    private final static String STUDY_META_URL = "https://%1s/Study/token/restservices/studiesWithAccessionNumber/site/icn/%2s/%3s?securityToken=%4s";
    private final static String LEGACY_STUDY_META_URL = "https://%1s/Study/token/restservices/studies/site/icn/%2s/%3s?securityToken=%4s";
    private final static String SERIES_META_URL = "https://%1s/Study/token/restservices/study/%2s?securityToken=%3s";
    private final static String REPORT_META_URL = "https://%1s/Study/token/restservices/study/report/%2s?securityToken=%3s";
    private final static String LOCAL_CACHE_URL = "https://%1s/Study/token/restservices/dicom/cache/local/%1s?securityToken=%2s&callingAe=%3s&callingIp=%4s&icn=%5s";
    static final String LOCAL_TOKEN_URL = "https://localhost/ViewerStudyWebApp/restservices/study/user/token";
    private static final String TFL_URL = "https://%1s/Study/token/restservices/patient/mtf/%2s?securityToken=%3s";

    private final static HostnameVerifier DO_NOT_VERIFY = new HostnameVerifier() {
		public boolean verify(String hostname, SSLSession session) {
			return !Objects.isNull(hostname);
		}};


    private final HttpsURLConnection connection;

    public HttpsUtil(String uriString) throws URISyntaxException, IOException {
    	
    	if(StringUtils.isEmpty(uriString)) {
    		String errMsg = "Given 'uriString' is null. Can't proceed.";
    		LOGGER.error(errMsg);
    		throw new IOException(errMsg);
    	}
    	
        if(LOGGER.isDebugEnabled()) 
        	LOGGER.debug("Getting Http connection to URL: {} ", uriString);
        
        connection = (HttpsURLConnection) new URI(uriString).toURL().openConnection();
        connection.setSSLSocketFactory(new BaseHttpSSLSocketFactory());
        connection.setHostnameVerifier(DO_NOT_VERIFY);
    }

    public static String getToken() {
    	
        if(HttpsUtil.token == null) 
        	setToken();
        
        return token;
    }

    static void setConnectionBasicAuth(String username, String password, HttpsURLConnection conn) 
    throws ProtocolException {
    	
        if (username != null && password != null) {
            String userpassword = username + ":" + password;
            String basic_auth = new String(Base64.getEncoder().encode((userpassword).getBytes()));
            conn.setRequestProperty("Authorization", "Basic " + basic_auth);
        }
    }

    private static void setToken() {
    	
        HttpsURLConnection conn = null;
        
        try {
        	
            conn = (HttpsURLConnection) new URI(LOCAL_TOKEN_URL).toURL().openConnection();
            conn.setSSLSocketFactory(new BaseHttpSSLSocketFactory());
            conn.setHostnameVerifier(DO_NOT_VERIFY);
            conn.setRequestMethod("GET");
            conn.setDoInput(true);
            
            setConnectionBasicAuth(DicomService.getScpConfig().getAccessCode().getValue(),
                    DicomService.getScpConfig().getVerifyCode().getValue(), conn);
            
            token = JAXB.unmarshal(new StringReader(getStringHttpResponseData(conn)), RestStringType.class).getValue();
            
        } catch (URISyntaxException | IOException e) {
            LOGGER.error("Unable to set security token, problem with URL msg: {}", e.getMessage());
        } finally {
            if(conn != null) conn.disconnect();
        }
    }

    private static String getStringHttpResponseData(HttpsURLConnection conn) {
    	
        try {
            if(conn.getResponseCode() != 200) {
                LOGGER.error("Http Response Code [{}] for URL [{}] ", conn.getResponseCode(), conn.getURL());
                return "";
            }
        } catch (IOException e) {
            LOGGER.error("Could not read response code for URL {}", conn.getURL());
            // Most likely something's wrong with the 'conn' object
            // return empty String here to avoid the processing below
            return "";
        }
        
        StringBuilder lines = new StringBuilder();
        
        try (InputStream is = conn.getInputStream();
        	 InputStreamReader isReader = new InputStreamReader(is);
             BufferedReader bufferedReader = new BufferedReader(isReader)) {
        
        	String line = null;
            String separator = System.getProperty("line.separator");
            
             while ((line = bufferedReader.readLine()) != null) {
                 lines.append(line).append(separator);
             }
             
        } catch (IOException e) {
            LOGGER.warn("Cannot get https string response, exception msg: {}", e.getMessage());
        }

        return lines.toString();
    }

    public static String getStringResultFromUrl(String url) {
    	
        try(HttpsUtil httpsUtil = new HttpsUtil(url)) {
            return HttpsUtil.getStringHttpResponseData(httpsUtil.connection);
        } catch (URISyntaxException | IOException e) {
            LOGGER.error("Failed to get accession number from url [{}], msg: {}", url, e.getMessage());
            return null;
        }
    }

    public static StudyResultWrapper getStudyMetaForSite(String siteId, String icn, StudyFilterType studyFilter) {
    	
        String remoteHost = DicomService.getRemoteVixHost(siteId);
        
        // Previous version may cause NPE
        if(StringUtils.isEmpty(remoteHost)) {
            LOGGER.warn("Cannot fetch meta from site Id [{}]. VIX FQDN is null.", siteId);
            return null;
        }
        
        if(token == null) {
            setToken();
        }
        
        String url = String.format(STUDY_META_URL, remoteHost, siteId, icn, token);
        
        try(HttpsUtil httpsUtil = new HttpsUtil(url)) {
        	
            httpsUtil.connection.setRequestMethod("POST");
            httpsUtil.connection.setRequestProperty("Content-Type", "application/xml");
            httpsUtil.connection.setDoOutput(true);
            httpsUtil.connection.setDoInput(true);
            
            StringWriter writer = new StringWriter();
            Marshaller jaxb = JAXBContext.newInstance(StudyFilterType.class).createMarshaller();
            jaxb.marshal(studyFilter, writer);
            
            try(OutputStream outputStream = new BufferedOutputStream(httpsUtil.connection.getOutputStream())) {
                outputStream.write(writer.toString().getBytes(StandardCharsets.UTF_8));
                outputStream.flush();
            }
            
            return new StudyResultWrapper(httpsUtil.connection.getResponseCode(),
                    JAXB.unmarshal(new StringReader(getStringHttpResponseData(httpsUtil.connection)), StudiesResultType.class));
        } catch (Exception e) {
            LOGGER.error("Failed to fetch study meta with accession over https from site Id [{}] for ICN [{}], msg: {}", siteId, icn, e.getMessage());
            return new StudyResultWrapper(500, null);
        }
    }

    public static List<String> getCacheDirs(String siteId, String icn, String callingAe, String callingIp,
                                            String studyUrn) {

        String remoteHost = DicomService.getRemoteVixHost(siteId);

        // Previous version may cause NPE
        if(StringUtils.isEmpty(remoteHost)) {
            LOGGER.warn("Cannot use FDT from site Id [{}]. VIX FQDN is null.", siteId);
            return null;
        }

        if(token == null) {
            setToken();
        }

        String url = String.format(LOCAL_CACHE_URL, remoteHost, studyUrn, token, callingAe, callingIp, icn);

        try(HttpsUtil httpsUtil = new HttpsUtil(url)) {
            httpsUtil.connection.setRequestMethod("GET");
            httpsUtil.connection.setRequestProperty("Content-Type", "application/xml");
            httpsUtil.connection.setDoInput(true);

            RestStringType result = JAXB.unmarshal(new StringReader(getStringHttpResponseData(httpsUtil.connection)),
                    RestStringType.class);

            return new ArrayList<>(Arrays.asList(result.getValue().split("\\|")));
        } catch (Exception e) {
            LOGGER.error("Failed to get remote cache dirs from site Id [{}] for study [{}], msg: {}", siteId, studyUrn, e.getMessage());
            return new ArrayList<>();
        }
    }

    public static StudyResultWrapper getStudyMetaForSiteLegacy(String siteId, String icn, StudyFilterType studyFilter) {
    	
    	  if(token == null) {
             setToken();
        }
        
    	  String remoteHost = DicomService.getRemoteVixHost(siteId);
        // Previous version may cause NPE
        if(StringUtils.isEmpty(remoteHost)) {
            LOGGER.warn("Cannot fetch meta from site Id [{}]. VIX FQDN is null", siteId);
            return null;
        }
        
        String url = String.format(LEGACY_STUDY_META_URL, remoteHost, siteId, icn, token);
        
        try(HttpsUtil httpsUtil = new HttpsUtil(url)) {
        	
            httpsUtil.connection.setRequestMethod("POST");
            httpsUtil.connection.setRequestProperty("Content-Type", "application/xml");
            httpsUtil.connection.setDoOutput(true);
            httpsUtil.connection.setDoInput(true);
            
            StringWriter writer = new StringWriter();
            Marshaller jaxb = JAXBContext.newInstance(StudyFilterType.class).createMarshaller();
            jaxb.marshal(studyFilter, writer);
            //String xml = writer.toString();
            
            try(OutputStream outputStream = new BufferedOutputStream(httpsUtil.connection.getOutputStream())) {
                outputStream.write(writer.toString().getBytes(StandardCharsets.UTF_8));
                outputStream.flush();
            }
            
            return new StudyResultWrapper(httpsUtil.connection.getResponseCode(),
                    JAXB.unmarshal(new StringReader(getStringHttpResponseData(httpsUtil.connection)),
                            StudiesResultType.class));
        } catch (Exception e) {
            LOGGER.error("Failed to fetch study meta over https from site Id [{}], for ICN [{}], msg: {}", siteId, icn, e.getMessage());
            return new StudyResultWrapper(500,null);
        }
    }

    public static LoadedStudyType getSeriesMeta(String studyUrn, String siteId) throws UnsupportedEncodingException {
    	
        if(token == null) {
            setToken();
        }
        
        String remoteHost = DicomService.getRemoteVixHost(siteId);
        
        if(StringUtils.isEmpty(remoteHost)) {
            LOGGER.warn("Cannot fetch meta from site Id [{}]. VIX FQDN is null", siteId);
            return null;
        }
        
        String url = String.format(SERIES_META_URL, remoteHost, URLEncoder.encode(studyUrn, String.valueOf(StandardCharsets.UTF_8)), token);
        
        try(HttpsUtil httpsUtil = new HttpsUtil(url)) {
        
        	httpsUtil.connection.setRequestMethod("GET");
            httpsUtil.connection.setRequestProperty("Content-Type", "application/xml");
            httpsUtil.connection.setDoInput(true);
            
            return JAXB.unmarshal(new StringReader(getStringHttpResponseData(httpsUtil.connection)), LoadedStudyType.class);
            
        } catch (Exception e) {
            LOGGER.warn("Failed to fetch series meta from site Id [{}] for studyURN [{}], msg: {}", siteId, studyUrn, e.getMessage());
        }
        
        return null;
    }

    public static RestStringType getReportMeta(String studyUrn, String siteId) {
    	
        if(token == null) {
            setToken();
        }
        
        String remoteHost = DicomService.getRemoteVixHost(siteId);
        
        if(StringUtils.isEmpty(remoteHost)) {
            LOGGER.warn("Cannot fetch meta from site Id [{}]. VIX FQDN is null", siteId);
            return null;
        }
        
        String url = String.format(REPORT_META_URL, remoteHost, studyUrn, token);
        
        try(HttpsUtil httpsUtil = new HttpsUtil(url)) {
        	
            httpsUtil.connection.setRequestMethod("GET");
            httpsUtil.connection.setRequestProperty("Content-Type", "application/xml");
            httpsUtil.connection.setDoInput(true);
            
            return JAXB.unmarshal(new StringReader(getStringHttpResponseData(httpsUtil.connection)), RestStringType.class);
        
        } catch (Exception e) {
        	LOGGER.warn("Failed to fetch report meta from site Id [{}] for studyURN [{}], msg: {}", siteId, studyUrn, e.getMessage());
        }
        
        return null;
    }

    public static PatVistaInfo getPatInfoFromCvix(String queriedPatientId, String transId) {
        String remoteHost = DicomService.getRemoteVixHost("2001");
        if(token == null){
            setToken();
        }
        String url = String.format(TFL_URL, remoteHost, queriedPatientId, token);
        try(HttpsUtil httpsUtil = new HttpsUtil(url)) {
            httpsUtil.connection.setRequestMethod("GET");
            httpsUtil.connection.setRequestProperty("Content-Type", "application/xml");
            httpsUtil.connection.setDoInput(true);
            return JAXB.unmarshal(new StringReader(getStringHttpResponseData(httpsUtil.connection)),
                            PatVistaInfo.class);
        } catch (Exception e) {
            LOGGER.error("Failed to fetch Patient Info over https from CVIX for " + queriedPatientId
                    + " msg: " + e.getMessage());
            return new PatVistaInfo();
        }
    }

    public HttpsURLConnection setImageConnectionProperties(String un, String inToken)
    throws IOException {
    	
        if(un != null && inToken != null) {
            setConnectionBasicAuth(un, inToken, this.connection);
        }

        connection.setDoInput(true);
        connection.setRequestProperty("Accept", "*/*");
        connection.setRequestProperty("Accept-Encoding","gzip");
        connection.setRequestProperty("Content-Type", "application/x-www-form-urlencoded");
        connection.setRequestProperty("Content-Language", "en-US");

        return connection;
    }

    @Override
    public void close() {
    	if(connection != null) {
    		connection.disconnect();
    	}
    }

    // --------------------------------------------------------------------------------
    
    public static class BaseHttpSSLSocketFactory extends SSLSocketFactory
    {
        private SSLContext getSSLContext() {
            return createEasySSLContext();
        }

        @Override
        public Socket createSocket(InetAddress arg0, int arg1, InetAddress arg2, int arg3) 
        throws IOException {
        	
            return getSSLContext().getSocketFactory().createSocket(arg0, arg1, arg2, arg3);
        }

        @Override
        public Socket createSocket(String arg0, int arg1, InetAddress arg2, int arg3)
        throws IOException {
        	
            return getSSLContext().getSocketFactory().createSocket(arg0, arg1, arg2, arg3);
        }

        @Override
        public Socket createSocket(InetAddress arg0, int arg1) 
        throws IOException {
        	
            return getSSLContext().getSocketFactory().createSocket(arg0, arg1);
        }

        @Override
        public Socket createSocket(String arg0, int arg1) 
        throws IOException {
        	
            return getSSLContext().getSocketFactory().createSocket(arg0, arg1);
        }

        @Override
        public String[] getSupportedCipherSuites() {
            // TODO Auto-generated method stub
            return null;
        }

        @Override
        public String [] getDefaultCipherSuites() {
            // TODO Auto-generated method stub
            return null;
        }

        @Override
        public Socket createSocket(Socket arg0, String arg1, int arg2, boolean arg3) 
        throws IOException {
        	
            return getSSLContext().getSocketFactory().createSocket(arg0, arg1, arg2, arg3);
        }

        private SSLContext createEasySSLContext() {
        	
            try {
                SSLContext context = SSLContext.getInstance("TLSv1.2");
                context.init(null, new TrustManager[] { HttpsUtil.BaseHttpSSLSocketFactory.MyX509TrustManager.manger }, null);
                return context;
            } catch (Exception e) {
                LOGGER.error("createEasySSLContext() --> [{}]: {}", e.getClass().getSimpleName(), e.getMessage());
                return null;
            }
        }

        public static class MyX509TrustManager implements X509TrustManager {
        	
            public static BaseHttpSSLSocketFactory.MyX509TrustManager manger = new BaseHttpSSLSocketFactory.MyX509TrustManager();

            public MyX509TrustManager() {}

            public X509Certificate [] getAcceptedIssuers() {
            	//Fortify change: return null;
            	return new X509Certificate[0];
            }

            public void checkClientTrusted(X509Certificate[] chain, String authType) {}

            public void checkServerTrusted(X509Certificate[] chain, String authType) {}
        }
    }
}
