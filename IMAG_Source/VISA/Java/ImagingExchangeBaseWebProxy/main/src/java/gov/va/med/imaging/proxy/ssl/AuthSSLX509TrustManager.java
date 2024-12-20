/*
 * NOTE: this class is almost a complete copy of the Apache Common version found at:
 * /httpclient/src/contrib/org/apache/commons/httpclient/contrib/ssl/AuthSSLProtocolSocketFactory.java
 * with some minor rewrite to use log4J. 
 * 
 * $Header: /cvs/ImagingExchangeBaseWebProxy/main/src/java/gov/va/med/imaging/proxy/ssl/AuthSSLX509TrustManager.java,v 1.2 2009/01/15 14:27:33 vhaiswwerfej Exp $
 * $Revision: 1.2 $
 * $Date: 2009/01/15 14:27:33 $
 *
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

package gov.va.med.imaging.proxy.ssl;

import java.security.cert.X509Certificate;

import javax.net.ssl.X509TrustManager;
import java.security.cert.CertificateException;
import org.apache.commons.logging.Log; 
import org.apache.commons.logging.LogFactory;

import gov.va.med.imaging.StringUtil;

/**
 * <p>
 * AuthSSLX509TrustManager can be used to extend the default {@link X509TrustManager} 
 * with additional trust decisions.
 * </p>
 * 
 * @author <a href="mailto:oleg@ural.ru">Oleg Kalnichevski</a>
 * 
 * <p>
 * DISCLAIMER: HttpClient developers DO NOT actively support this component.
 * The component is provided as a reference material, which may be inappropriate
 * for use without additional customization.
 * </p>
 */

public class AuthSSLX509TrustManager implements X509TrustManager
{
    private X509TrustManager defaultTrustManager = null;

    /** Log object for this class. */
    private static final Log LOG = LogFactory.getLog(AuthSSLX509TrustManager.class);

    /**
     * Constructor for AuthSSLX509TrustManager.
     */
    public AuthSSLX509TrustManager(final X509TrustManager defaultTrustManager) {
        super();
        if (defaultTrustManager == null) {
            throw new IllegalArgumentException("Trust manager may not be null");
        }
        this.defaultTrustManager = defaultTrustManager;
    }

    /**
     * @see javax.net.ssl.X509TrustManager#checkClientTrusted(X509Certificate[],String authType)
     */
    public void checkClientTrusted(X509Certificate[] certificates,String authType) throws CertificateException {
        if (LOG.isInfoEnabled() && certificates != null) {
            for (int c = 0; c < certificates.length; c++) {
                X509Certificate cert = certificates[c];
                LOG.debug(" Client certificate " + (c + 1) + ":");
                LOG.debug("  Subject DN: " + StringUtil.cleanString(cert.getSubjectDN().getName()));
                LOG.debug("  Signature Algorithm: " + cert.getSigAlgName());
                LOG.debug("  Valid from: " + cert.getNotBefore() );
                LOG.debug("  Valid until: " + cert.getNotAfter());
                LOG.debug("  Issuer: " + StringUtil.cleanString(cert.getIssuerDN().getName()));
            }
        }
        defaultTrustManager.checkClientTrusted(certificates,authType);
    }

    /**
     * @see javax.net.ssl.X509TrustManager#checkServerTrusted(X509Certificate[],String authType)
     */
    public void checkServerTrusted(X509Certificate[] certificates,String authType) throws CertificateException {
        if (LOG.isInfoEnabled() && certificates != null) {
            for (int c = 0; c < certificates.length; c++) {
                X509Certificate cert = certificates[c];
                LOG.debug(" Server certificate " + (c + 1) + ":");
                LOG.debug("  Subject DN: " + StringUtil.cleanString(cert.getSubjectDN().getName()));
                LOG.debug("  Signature Algorithm: " + cert.getSigAlgName());
                LOG.debug("  Valid from: " + cert.getNotBefore() );
                LOG.debug("  Valid until: " + cert.getNotAfter());
                LOG.debug("  Issuer: " + StringUtil.cleanString(cert.getIssuerDN().getName()));
            }
        }
        defaultTrustManager.checkServerTrusted(certificates,authType);
    }

    /**
     * @see javax.net.ssl.X509TrustManager#getAcceptedIssuers()
     */
    public X509Certificate[] getAcceptedIssuers() {
        return this.defaultTrustManager.getAcceptedIssuers();
    }
}
