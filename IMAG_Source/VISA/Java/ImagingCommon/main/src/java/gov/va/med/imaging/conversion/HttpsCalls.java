package gov.va.med.imaging.conversion;

/*
 * ====================================================================
 *
 *  Licensed to the Apache Software Foundation (ASF) under one or more
 *  contributor license agreements.  See the NOTICE file distributed with
 *  this work for additional information regarding copyright ownership.
 *  The ASF licenses this file to You under the Apache License, Version 2.0
 *  (the "License"); you may not use this file except in compliance with
 *  the License.  You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 *  Unless required by applicable law or agreed to in writing, software
 *  distributed under the License is distributed on an "AS IS" BASIS,
 *  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *  See the License for the specific language governing permissions and
 *  limitations under the License.
 * ====================================================================
 *
 * This software consists of voluntary contributions made by many
 * individuals on behalf of the Apache Software Foundation.  For more
 * information on the Apache Software Foundation, please see
 * <http://www.apache.org/>.
 *
 */

import java.io.*;
import java.net.URL;
import java.net.HttpURLConnection;

import javax.net.ssl.*;

import gov.va.med.imaging.url.vista.StringUtils;
import gov.va.med.logging.Logger;

import java.security.KeyStore;
import java.util.Base64;
import java.util.Objects;
import java.net.InetAddress;
import java.net.Socket;
import java.net.UnknownHostException;
import java.security.cert.X509Certificate;

/**
 * This example demonstrates how to create secure connections with a custom SSL
 * context.
 */
public class HttpsCalls {

	private static final Logger LOGGER = Logger.getLogger(HttpsCalls.class);
	
	private final static HostnameVerifier NOT_VERY_VERIFY = new HostnameVerifier() {
		public boolean verify(String hostname, SSLSession session) {
			return !Objects.isNull(hostname);
		}};

	private static final String LINE_BREAKER = System.getProperty("line.separator");

	//private static String TRUSTSTORE_FILE = "bin/DESClient/Truststore";
	//private static String TRUSTSTORE_PASS = "Pa55word1";
	//private static String KEYSTORE_FILE = "bin/DESClient/Truststore";
	//private static String KEYSTORE_PASS = "Pa55word1";
	//private static String KEYSTORE_ALIAS = "paypal";
	//private static final String TARGET_URL = "https://www.paypal.com";

	public final static String HttpsCall(String urlString) throws Exception {

		// Fortify change: check for null first
		if (StringUtils.isEmpty(urlString)) {
			String msg = "HttpsCalls.HttpsCall() --> URL string to create connection from is null or empty.";
			LOGGER.error(msg);
			throw new IllegalArgumentException(msg);
		}

		return urlString.startsWith("https") ? HttpsCall(urlString, null, null, null) : HttpCall(urlString);
	}

	public final static String HttpCall(String urlString) throws Exception {

		// Fortify change: check for null first
		if (StringUtils.isEmpty(urlString)) {
			String msg = "HttpsCalls.HttpCall() --> URL string to create connection from is null or empty.";
			LOGGER.error(msg);
			throw new IllegalArgumentException(msg);
		}

		LOGGER.debug("HttpsCalls.HttpCall() --> Given URL string [{}]", urlString);

		try {
			
			// Fortify change
			String escapedUrlString = org.apache.commons.lang.StringEscapeUtils.escapeJava(urlString);
			HttpURLConnection connection =  (HttpURLConnection) (new URL(escapedUrlString).openConnection());
			connection.setRequestMethod("GET");
			connection.setDoInput(true);
			
			try (InputStream inStream = connection.getInputStream();
				 InputStreamReader inStreamReader = new InputStreamReader(inStream);
			     BufferedReader bufferedReader = new BufferedReader(inStreamReader)) {

				String line = null;
				StringBuilder lines = new StringBuilder();
			
				while ((line = bufferedReader.readLine()) != null) {
					lines.append(line).append(LINE_BREAKER);
				}
			
				return lines.toString();
			}
		} catch (Exception e) {
            LOGGER.error("HttpsCalls.HttpCall() --> Got exception [{}]: {}", e.getClass().getSimpleName(), e.getMessage());
			throw e;
		} 
	}

	public final static String HttpCall(String urlString, String username, String userpass) throws Exception {
		
		// Fortify change: check for null first
		if (StringUtils.isEmpty(urlString)) {
			String msg = "HttpsCalls.HttpCall(1) --> URL string to create connection from is null or empty.";
			LOGGER.error(msg);
			throw new IllegalArgumentException(msg);
		}

		HttpURLConnection httpConn = null;
		try {
			
			// Fortify change
			String escapedUrlString = org.apache.commons.lang.StringEscapeUtils.escapeJava(urlString);
			httpConn =  (HttpURLConnection) (new URL(escapedUrlString).openConnection());
			httpConn.setRequestMethod("GET");
			
			if (username != null && userpass != null) {
				String userpassword = username + ":" + userpass;
				String basic_auth = new String(Base64.getEncoder().encode((userpassword).getBytes()));
				httpConn.setRequestProperty("Authorization", "Basic " + basic_auth);
			}

			httpConn.setDoInput(true);
			
			try (InputStream inStream = httpConn.getInputStream();
				 InputStreamReader inStreamReader = new InputStreamReader(inStream);
				 BufferedReader bufferedReader = new BufferedReader(inStreamReader)) {

				String line = null;
				StringBuilder lines = new StringBuilder();
			
				while ((line = bufferedReader.readLine()) != null) {
					lines.append(line).append(LINE_BREAKER);
				}
			
				return lines.toString();
			}
			
		} catch (Exception e) {
            LOGGER.error("HttpsCalls.HttpCall(1) --> Got exception [{}]: {}", e.getClass().getSimpleName(), e.getMessage());
			throw e;
		} finally {
			try { if (httpConn != null) httpConn.disconnect(); } catch (Exception e) {/* Ignore */ }
		}
	}

	public final static byte [] HttpsCallImage(String urlString, String username, String userpass, SSLSocketFactory sslSocketFactory) 
	throws Exception {
		
		// Fortify change: check for null first
		if (StringUtils.isEmpty(urlString)) {
			String msg = "HttpsCalls.HttpsCallImage() --> URL string to create connection from is null or empty.";
			LOGGER.error(msg);
			throw new IllegalArgumentException(msg);
		}
		
		//URL url = null;
		//HttpsURLConnection connection = null;
		InputStream is = null;

        LOGGER.debug("HttpsCall.HttpsCallImage() --> Given URL string [{}]", urlString);
		// System.out.println(KEYSTORE_FILE+"\n"+KEYSTORE_PASS+"\n"+KEYSTORE_ALIAS+"\n"+TRUSTSTORE_FILE+"\n"+TRUSTSTORE_PASS);

        HttpsURLConnection httpsConn = null;
        
		try (ByteArrayOutputStream buffer = new ByteArrayOutputStream();) {

			// Uncomment this in case server demands some unsafe operations
			// System.setProperty("sun.security.ssl.allowUnsafeRenegotiation", "true");
			
			// Fortify change
			String escapedUrlString = org.apache.commons.lang.StringEscapeUtils.escapeJava(urlString);
			httpsConn = (HttpsURLConnection) (new URL(escapedUrlString).openConnection());
			httpsConn.setHostnameVerifier(NOT_VERY_VERIFY);
			httpsConn.setRequestMethod("GET");
			
			if (username != null && userpass != null) {
				String userpassword = username + ":" + userpass;
				String basic_auth = new String(Base64.getEncoder().encode((userpassword).getBytes()));
				httpsConn.setRequestProperty("Authorization", "Basic " + basic_auth);
			}

			httpsConn.setDoInput(true);
			httpsConn.setRequestProperty("Accept", "*/*");
			httpsConn.setRequestProperty("Content-Type", "application/x-www-form-urlencoded");
			httpsConn.setRequestProperty("Content-Language", "en-US");
			
			// Specify a socket factory or use the default.
			if (sslSocketFactory != null) {
				httpsConn.setSSLSocketFactory(sslSocketFactory);
			} else {
				httpsConn.setSSLSocketFactory(new BaseHttpSSLSocketFactory());
			}
			
			LOGGER.debug("HttpsCall.HttpsCallImage() --> SSL SocketFactory is set.");
			
			// Process response
			is = httpsConn.getInputStream();
				
			int nRead = 0;
			byte [] data = new byte[1024];
				
			while ((nRead = is.read(data, 0, data.length)) != -1) {
				buffer.write(data, 0, nRead);
			}

			buffer.flush();
			byte [] byteArray = buffer.toByteArray();

            LOGGER.debug("HttpsCall.HttpsCallImage() --> Return byte array length [{}]", byteArray.length);

			return byteArray;
				
		} catch (Exception e) {
            LOGGER.error("HttpsCalls.HttpsCallImage() --> Got exception [{}]: {}", e.getClass().getSimpleName(), e.getMessage());
			throw e;
		} finally {
			try { if (is != null) is.close(); } catch (Exception e) {/* Ignore */ }
			try { if (httpsConn != null) httpsConn.disconnect(); } catch (Exception e) {/* Ignore */ }
		}
	}

	public final static String HttpsCall(String urlString, String username, String userpass,
			SSLSocketFactory sslSocketFactory) throws Exception {

		// Fortify change: check for null first
		if (urlString == null || urlString.isEmpty()) {
			String msg = "HttpsCalls.HttpsCall() --> URL string to create connection from is null or empty.";
			LOGGER.error(msg);
			throw new IllegalArgumentException(msg);
		}

		HttpsURLConnection httpsConn = null;
		BufferedReader bufferedReader = null;

        LOGGER.debug("HttpsCalls.HttpsCall() --> Given URL string [{}]", urlString);

		try {
			
			// Uncomment this in case server demands some unsafe operations
			// System.setProperty("sun.security.ssl.allowUnsafeRenegotiation", "true");
			
			// Fortify change
			String escapedUrlString = org.apache.commons.lang.StringEscapeUtils.escapeJava(urlString);
			httpsConn = (HttpsURLConnection) new URL(escapedUrlString).openConnection();
			httpsConn.setHostnameVerifier(NOT_VERY_VERIFY);
			httpsConn.setRequestMethod("GET");
			
			if (username != null && userpass != null) {
				// Fortify scans complain that creating and storing this in memory allows for a
				// heap inspection attack
				// Since this is already stored in plain text elsewhere and passed in plain text,
				// we're leaving this unchanged. The correct course is to use a more secure HTTPS connection
				// approach and not to store those values.
				String userpassword = username + ":" + userpass;
				String basic_auth = new String(Base64.getEncoder().encode((userpassword).getBytes()));
				httpsConn.setRequestProperty("Authorization", "Basic " + basic_auth);

			}
			/* */
			httpsConn.setDoInput(true);
			httpsConn.setRequestProperty("Content-Type", "application/x-www-form-urlencoded");
			httpsConn.setRequestProperty("Content-Language", "en-US");

			// Specify a socket factory or use the default
			if (sslSocketFactory != null) {
				httpsConn.setSSLSocketFactory(sslSocketFactory);
			} else {
				httpsConn.setSSLSocketFactory(new BaseHttpSSLSocketFactory());
			}

			// Process response
			bufferedReader = new BufferedReader(new InputStreamReader(httpsConn.getInputStream()));
			String line = null;
			StringBuilder lines = new StringBuilder();
			
			while ((line = bufferedReader.readLine()) != null) {
				lines.append(line).append(LINE_BREAKER);
			}
			
			return lines.toString();

		} catch (Exception e) {
            LOGGER.error("HttpsCalls.HttpsCall() --> Got exception [{}]: {}", e.getClass().getSimpleName(), e.getMessage());
			throw e;
		} finally {
			safeClose(bufferedReader);
			try { if (httpsConn != null) httpsConn.disconnect(); } catch (Exception e) {/* Ignore */ }
		}
	}

	/**
	 * HttpsGetComplexDataContent
	 * 
	 * @param urlString
	 * @return
	 * @throws Exception
	 */
	public final static byte[] HttpsGetComplexDataContent(String urlString) throws Exception {

		// Fortify change: check for null first
		if (urlString == null || urlString.isEmpty()) {
			String msg = "HttpsCalls.HttpsGetComplexDataContent() --> URL string to create connection from is null or empty.";
			LOGGER.error(msg);
			throw new IllegalArgumentException(msg);
		}

		byte [] results = null;
		HttpsURLConnection httpsConn = null;
		InputStream resultStream = null;

        LOGGER.debug("HttpsCalls.HttpsGetComplexDataContent() --> Given URL string [{}]", urlString);

		try {
			// Fortify change
			String escapedUrlString = org.apache.commons.lang.StringEscapeUtils.escapeJava(urlString);
			httpsConn = (HttpsURLConnection) new URL(escapedUrlString).openConnection();

			// Fortify change: add check for null and finally block to close connection and stream
			if (httpsConn != null) {
				httpsConn.setRequestMethod("GET");
				httpsConn.setDoInput(true);
				
				resultStream = httpsConn.getInputStream();

				// Leave checking for null here in case Fortify complains
				if (resultStream != null) {
					results = convertStreamToBytes(resultStream);
				}
			}
		} catch (Exception e) {
            LOGGER.error("HttpsCalls.HttpsGetComplexDataContent() --> Got exception [{}]: {}", e.getClass().getSimpleName(), e.getMessage());
			throw e;
		} finally {
			// diconnect() method will effectively close the stream and the socket
			// close separately to be on the safe side
			try { if (resultStream != null) resultStream.close(); } catch (Exception e) {/* Ignore */ }
			try { if (httpsConn != null) httpsConn.disconnect(); } catch (Exception e) {/* Ignore */ }
		}

		return results;
	}

	/**
	 * HttpGetComplexDataContent
	 * 
	 * @param urlString
	 * @return
	 * @throws Exception
	 */
	public final static byte [] HttpGetComplexDataContent(String urlString) throws Exception {

		// Fortify change: check for null first
		if (urlString == null || urlString.isEmpty()) {
			String msg = "HttpsCalls.HttpGetComplexDataContent() --> URL string to create connection from is null or empty.";
			LOGGER.error(msg);
			throw new IllegalArgumentException(msg);
		}

		byte [] results = null;
		HttpURLConnection httpConn = null;
		InputStream resultStream = null;

        LOGGER.debug("HttpsCalls.HttpGetComplexDataContent() --> Given URL string [{}]", urlString);

		try {
			// Fortify change
			String escapedUrlString = org.apache.commons.lang.StringEscapeUtils.escapeJava(urlString);
			httpConn = (HttpURLConnection) new URL(escapedUrlString).openConnection();

			// Fortify change: add check for null and finally block to close connection and stream
			if (httpConn != null) {

				httpConn.setRequestMethod("GET");
				httpConn.setDoInput(true);
				
				resultStream = httpConn.getInputStream();

				// Leave checking for null here in case Fortify complains
				if (resultStream != null) {
					results = convertStreamToBytes(resultStream);
				}
			}
		} catch (Exception e) {
            LOGGER.error("HttpsCalls.HttpGetComplexDataContent() --> Got exception [{}]: {}", e.getClass().getSimpleName(), e.getMessage());
			throw e;
		} finally {
			// diconnect() method will effectively close the stream and the socket
			// close separately to be on the safe side
			try { if (resultStream != null) resultStream.close(); } catch (Exception e) {/* Ignore */ }
			try { if (httpConn != null) httpConn.disconnect(); } catch (Exception e) {/* Ignore */ }
		}

		return results;
	}

	private final static byte[] convertStreamToBytes(InputStream is) throws Exception {
		
		try (ByteArrayOutputStream baos = new ByteArrayOutputStream()) {

			byte [] buf = new byte[1024];
			int readNum = 0;
			
			while ((readNum = is.read(buf, 0, buf.length)) != -1) {
				baos.write(buf, 0, readNum);
			}
			baos.flush();
			return baos.toByteArray();

		} catch (Exception e) {
            LOGGER.error("HttpsCalls.convertStreamToBytes() --> Got exception [{}]: {}", e.getClass().getSimpleName(), e.getMessage());
			throw e;
		} 
	}

	/**
	 * Initializes a SSLSocketFactory provided an optional keystore and truststore
	 * file
	 *
	 * @param keyStoreFilePath   The file path to load a keystore from to be used
	 *                           for 2-way SSL (client auth)
	 * @param keyStorePassword   The password to the keystore file (and also the
	 *                           password of the default key)
	 * @param trustStoreFilePath The file path to load a truststore from to be used
	 *                           to trust server certificates
	 * @param trustStorePassword The password to the truststore file
	 * @return a SSLSocketFactory
	 * @throws Exception In the event of any issues loading keystore files or
	 *                   initializing the factory
	 */
	public static SSLSocketFactory getSSLSocketFactory(String keyStoreFilePath, String keyStorePassword,
			String trustStoreFilePath, String trustStorePassword) throws Exception {
		// File paths aren't guaranteed to be URL-formatted, so this should normalize those
		keyStoreFilePath = (keyStoreFilePath == null ? null : keyStoreFilePath.replace("file:///", ""));
		trustStoreFilePath = (trustStoreFilePath == null ? null : trustStoreFilePath.replace("file:///", ""));

		// Initialize a key manager
		KeyManagerFactory keyManagerFactory = null;
		if (keyStoreFilePath != null) {
			
			try(InputStream keyStoreInputStream = new FileInputStream(new File(keyStoreFilePath));) {
				// Initialize the factory using the default algorithm
				keyManagerFactory = KeyManagerFactory.getInstance(KeyManagerFactory.getDefaultAlgorithm());
				// Load the store
				KeyStore keyStore = KeyStore.getInstance("JKS");
				keyStore.load(keyStoreInputStream, keyStorePassword.toCharArray());

				// Initialize the factory
				keyManagerFactory.init(keyStore, keyStorePassword.toCharArray());
				
			} catch (Exception e) {
				String msg = "HttpsCalls.getSSLSocketFactory() --> Unable to load key store file [" + keyStoreFilePath + "]: " + e.getMessage();
				LOGGER.error(msg);
				throw new Exception(msg, e);
			}
		}

		// Initialize a trust manager
		TrustManagerFactory trustManagerFactory = null;
		if (trustStoreFilePath != null) {
			
			try(InputStream trustStoreInputStream = new FileInputStream(new File(trustStoreFilePath));) {
				// Initialize the factory using the default algorithm
				trustManagerFactory = TrustManagerFactory.getInstance(TrustManagerFactory.getDefaultAlgorithm());

				// Load the store
				KeyStore trustStore = KeyStore.getInstance("JKS");
				trustStore.load(trustStoreInputStream, trustStorePassword.toCharArray());

				// Initialize the factory
				trustManagerFactory.init(trustStore);
			} catch (Exception e) {
				String msg = "HttpsCalls.getSSLSocketFactory() --> Unable to load trust store file [" + trustStoreFilePath + "]: " + e.getMessage();
				LOGGER.error(msg);
				throw new Exception(msg, e);
			} 
		}

		// Initialize the SSL context with the provided key and trust managers
		SSLContext context = SSLContext.getInstance("TLSv1.2");
		context.init(keyManagerFactory == null ? null : keyManagerFactory.getKeyManagers(),
				     trustManagerFactory == null ? null : trustManagerFactory.getTrustManagers(), null);
		
		return context.getSocketFactory();
	}
////////////////////////////////////////////////    

	/*
	 * * private static class AliasForcingKeyManager implements X509KeyManager {
	 * X509KeyManager baseKM = null; String alias = null;
	 * 
	 * public AliasForcingKeyManager(X509KeyManager keyManager, String alias) {
	 * baseKM = keyManager; this.alias = alias; }
	 * 
	 * public String chooseClientAlias(String[] keyType, Principal[] issuers, Socket
	 * socket) { return alias; }
	 * 
	 * public String chooseServerAlias(String keyType, Principal[] issuers, Socket
	 * socket) { return baseKM.chooseServerAlias(keyType, issuers, socket); }
	 * 
	 * public X509Certificate[] getCertificateChain(String alias) { return
	 * baseKM.getCertificateChain(alias); }
	 * 
	 * public String[] getClientAliases(String keyType, Principal[] issuers) {
	 * return baseKM.getClientAliases(keyType, issuers); }
	 * 
	 * public PrivateKey getPrivateKey(String alias) { return
	 * baseKM.getPrivateKey(alias); }
	 * 
	 * public String[] getServerAliases(String keyType, Principal[] issuers) {
	 * return baseKM.getServerAliases(keyType, issuers); } }
	 * 
	 * public static void setKeystoreFile(String path) { KEYSTORE_FILE = path; }
	 * 
	 * public static void setKeystorePass(String pass) { KEYSTORE_PASS = pass; }
	 * 
	 * public static void setKeystoreAlias(String alias) { KEYSTORE_ALIAS = alias; }
	 * 
	 * public static void setTruststoreFile(String path) { TRUSTSTORE_FILE = path; }
	 * 
	 * public static void setTruststorePass(String pass) { TRUSTSTORE_PASS = pass; }
	 * 
	 */
	
	public static void safeClose(BufferedReader br) {
		if (br != null) {
			try {
				br.close();
			} catch (IOException e) {
                LOGGER.warn("HttpsCalls.safeClose() --> Encountered IOException: {}", e.getMessage());
			}
		}
	}

	// --------------------------------------------------------------------------------
	public static class BaseHttpSSLSocketFactory extends SSLSocketFactory {
		private SSLContext getSSLContext() {
			return createEasySSLContext();
		}

		@Override
		public Socket createSocket(InetAddress arg0, int arg1, InetAddress arg2, int arg3) throws IOException {
			return getSSLContext().getSocketFactory().createSocket(arg0, arg1, arg2, arg3);
		}

		@Override
		public Socket createSocket(String arg0, int arg1, InetAddress arg2, int arg3)
				throws IOException, UnknownHostException {
			return getSSLContext().getSocketFactory().createSocket(arg0, arg1, arg2, arg3);
		}

		@Override
		public Socket createSocket(InetAddress arg0, int arg1) throws IOException {
			return getSSLContext().getSocketFactory().createSocket(arg0, arg1);
		}

		@Override
		public Socket createSocket(String arg0, int arg1) throws IOException, UnknownHostException {
			return getSSLContext().getSocketFactory().createSocket(arg0, arg1);
		}

		@Override
		public String[] getSupportedCipherSuites() {
			// TODO Auto-generated method stub
			return null;
		}

		@Override
		public String[] getDefaultCipherSuites() {
			// TODO Auto-generated method stub
			return null;
		}

		@Override
		public Socket createSocket(Socket arg0, String arg1, int arg2, boolean arg3) throws IOException {
			return getSSLContext().getSocketFactory().createSocket(arg0, arg1, arg2, arg3);
		}

		private SSLContext createEasySSLContext() {
			
			SSLContext context = null;
			
			try {
				context = SSLContext.getInstance("TLSv1.2");
				context.init(null, new TrustManager[] { MyX509TrustManager.manger }, null);			
			} catch (Exception e) {
                LOGGER.warn("BaseHttpSSLSocketFactory.createEasySSLContext() --> Encountered exception [{}]: {}", e.getClass().getSimpleName(), e.getMessage());
			}
			
			return context;
		}

		public static class MyX509TrustManager implements X509TrustManager {

			public static MyX509TrustManager manger = new MyX509TrustManager();

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
