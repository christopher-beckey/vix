/**
 * 
  Package: MAG - VistA Imaging
  WARNING: Per VHA Directive 2004-038, this routine should not be modified.
  Date Created: Apr 25, 2012
  Site Name:  Washington OI Field Office, Silver Spring, MD
  Developer:  VHAISWWERFEJ
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
package gov.va.med.imaging.facade.configuration;

import gov.va.med.imaging.encryption.AesEncryption;

/**
 * @author VHAISWWERFEJ
 *
 */
public class EncryptedConfigurationPropertyString
{
	private String value;
	private boolean isUnencryptedAtRest = false;

	public EncryptedConfigurationPropertyString()
	{
		super();
	}

	public EncryptedConfigurationPropertyString(String value)
	{
		super();
		this.value = value;
	}

	public String getValue()
	{
		return value;
	}

	public void setValue(String value)
	{
		this.value = value;
	}

	@Override
	public String toString()
	{
		return value;
	}

	public boolean isUnencryptedAtRest() {
		// Change to not encrypt values if we're set to use the "old" encryption algorithm
		if (AesEncryption.useOldAlgorithm()) {
			return false;
		}
		
		return isUnencryptedAtRest;
	}

	public void setUnencryptedAtRest(boolean unencryptedAtRest) {
		isUnencryptedAtRest = unencryptedAtRest;
	}

	@Override
	public boolean equals(Object obj){
		if (this == obj)
			return true;
		if (obj == null)
			return false;
		if (getClass() != obj.getClass())
			return false;
		EncryptedConfigurationPropertyString other = (EncryptedConfigurationPropertyString) obj;
		return value.equals(other.getValue()) && this.isUnencryptedAtRest() == other.isUnencryptedAtRest();
	}

	@Override
	public int hashCode() {
		final int prime = 31;
		int result = 1;
		return prime * result + ((value == null) ? 0 : value.hashCode());
	}
}
