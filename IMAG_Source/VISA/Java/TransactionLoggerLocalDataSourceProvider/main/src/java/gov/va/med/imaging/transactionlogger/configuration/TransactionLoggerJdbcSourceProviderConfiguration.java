/**
 * 
  Package: MAG - VistA Imaging
  WARNING: Per VHA Directive 2004-038, this routine should not be modified.
  Date Created: Aug 18, 2009
  Site Name:  Washington OI Field Office, Silver Spring, MD
  Developer:  vhaiswwerfej
  Description: 

        ;; +--------------------------------------------------------------------+
        ;; Property of the US Government.
        ;; No permission to copy or redistribute this software is given.
        ;; Use of unreleased versions of this software requires the user
        ;;  to execute a written test agreement with the VistA Imaging
        ;;  Development Office of the Department of Veterans Affairs,
        ;;  telephone (301) 734-0100.
        ;;
        ;; The Food and Drug Administration classifies this software as
        ;; a Class II medical device.  As such, it may not be changed
        ;; in any way.  Modifications to this software may result in an
        ;; adulterated medical device under 21CFR820, the use of which
        ;; is considered to be a violation of US Federal Statutes.
        ;; +--------------------------------------------------------------------+

 */
package gov.va.med.imaging.transactionlogger.configuration;

import java.io.Serializable;

public class TransactionLoggerJdbcSourceProviderConfiguration implements Serializable {
	private Integer retentionPeriodDays = 5;
	private Boolean useSharedCache = true;
	private String synchronousMode = "NORMAL";
	private String journalMode = "WAL";

	public TransactionLoggerJdbcSourceProviderConfiguration() {
	}

	public Integer getRetentionPeriodDays() {
		return retentionPeriodDays;
	}

	public void setRetentionPeriodDays(Integer retentionPeriodDays) {
		this.retentionPeriodDays = retentionPeriodDays;
	}

	public Boolean getUseSharedCache() {
		return useSharedCache;
	}

	public void setUseSharedCache(Boolean useSharedCache) {
		this.useSharedCache = useSharedCache;
	}

	public String getSynchronousMode() {
		return synchronousMode;
	}

	public void setSynchronousMode(String synchronousMode) {
		this.synchronousMode = synchronousMode;
	}

	public String getJournalMode() {
		return journalMode;
	}

	public void setJournalMode(String journalMode) {
		this.journalMode = journalMode;
	}

	public static TransactionLoggerJdbcSourceProviderConfiguration createDefaultConfiguration() {
		TransactionLoggerJdbcSourceProviderConfiguration configuration = new TransactionLoggerJdbcSourceProviderConfiguration();

		configuration.setRetentionPeriodDays(5);
		configuration.setJournalMode("WAL");
		configuration.setSynchronousMode("NORMAL");
		configuration.setUseSharedCache(true);

		return configuration;
	}	
}
