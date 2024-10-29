/**
 * 
 * 
 * Date Created: Feb 12, 2014
 * Developer: Julian Werfel
 */
package gov.va.med.imaging;

import java.io.Serializable;

import gov.va.med.NamespaceIdentifier;
import gov.va.med.PatientArtifactIdentifier;
import gov.va.med.PatientIdentifier;
import gov.va.med.PatientIdentifierType;
import gov.va.med.SERIALIZATION_FORMAT;
import gov.va.med.URN;
import gov.va.med.URNComponents;
import gov.va.med.imaging.exceptions.URNFormatException;

/**
 * @author Julian Werfel
 *
 */
public abstract class AbstractPatientURN
extends URN
implements Serializable, PatientArtifactIdentifier
{
	private static final long serialVersionUID = -8462008207390338955L;

	/**
	 * 
	 * @param namespaceIdentifier
	 * @throws URNFormatException
	 */
	protected AbstractPatientURN(NamespaceIdentifier namespaceIdentifier) 
	throws URNFormatException
	{
		super(namespaceIdentifier);
		assert namespaceIdentifier != null : "Namespace identifier cannot be a null value when building " + this.getClass().getSimpleName();
	}
	
	/**
	 * 
	 * @param namespaceIdentifier
	 * @param namespaceSpecificString
	 * @param additionalIdentifiers
	 * @throws URNFormatException
	 */
	protected AbstractPatientURN(
		NamespaceIdentifier namespaceIdentifier, 
		String namespaceSpecificString, 
		String... additionalIdentifiers) 
	throws URNFormatException
	{
		super(namespaceIdentifier, namespaceSpecificString, additionalIdentifiers);
	}
	
	/**
	 * 
	 * @param urnComponents
	 * @throws URNFormatException
	 */
	protected AbstractPatientURN(URNComponents urnComponents, SERIALIZATION_FORMAT serializationFormat) 
	throws URNFormatException
	{
		super(urnComponents, serializationFormat);
	}
	
	/**
	 * 
	 */
	@Override
	public abstract AbstractPatientURN clone()
	throws CloneNotSupportedException;
	
	/**
	 * Sets the PatientIdentifierType even if the new value is the same as the default value
	 * <br/>
	 * <b>WARNING</b>: Be sure this should be set, better to use setPatientIdentifierTypeIfNecessary which does not set
	 * anything if this value is the same as the default. In some cases setting this value, even when the same
	 * as  the default may cause unintended behavior (output including the patient identifier type when not desired).
	 *
	 * @param patientIdentifierType
	 */
	public void setPatientIdentifierType(PatientIdentifierType patientIdentifierType)
	{
		this.setAdditionalIdentifier(
				getPatientIdentifierTypeAdditionalIdentifierIndex(),
				patientIdentifierType.name()
			);
	}
	
	/**
	 * Only sets the PatientIdentifierType if it is different from the default PatientIdentifierType
	 * @param patientIdentifierType
	 */
	public void setPatientIdentifierTypeIfNecessary(PatientIdentifierType patientIdentifierType)
	{
		PatientIdentifierType defaultPatientIdentifierType = getDefaultPatientIdentifierType();
		if(defaultPatientIdentifierType != patientIdentifierType && patientIdentifierType != null)
			setPatientIdentifierType(patientIdentifierType);
	}
	
	/**
	 * Return the set PatientIdentifierType, if none is set this will return null
	 * @return
	 */
	public PatientIdentifierType getPatientIdentifierType()
	{
		String[] additionalIdentifiers = this.getAdditionalIdentifiers();
		if(additionalIdentifiers != null && additionalIdentifiers.length > getPatientIdentifierTypeAdditionalIdentifierIndex())
			return PatientIdentifierType.valueOf(additionalIdentifiers[getPatientIdentifierTypeAdditionalIdentifierIndex()]);
		return null;
	}
	
	/**
	 * Helper method to return the set PatientIdentifierType or the default PatientIdentifierType. This method should
	 * never return null
	 * @return
	 */
	public PatientIdentifierType getPatientIdentifierTypeOrDefault()
	{
		PatientIdentifierType pit = getPatientIdentifierType();
		if(pit == null)
			pit = getDefaultPatientIdentifierType();
		return pit;
	}
	
	/**
	 * Returns the default PatientIdentifierType for this type, this method can be overridden if necessary. This method
	 * should never return null
	 * @return
	 */
	public PatientIdentifierType getDefaultPatientIdentifierType()
	{
		return PatientIdentifierType.icn;
	}
	
	public boolean isDefaultPatientIdentifierType(PatientIdentifierType patientIdentifierType)
	{
		return (getDefaultPatientIdentifierType() == patientIdentifierType);
	}
	
	/**
	 * Returns true if the PatientIdentifierType assigned to this AbstractImagingURN is null or the same as the default PatientIdentifierType
	 * @return
	 */
	public boolean isDefaultPatientIdentifierType()
	{
		PatientIdentifierType pit = getPatientIdentifierType();
		if(pit == null || pit == getDefaultPatientIdentifierType())
			return true;
		return false;
	}
	
	/**
	 * The index location where the patient identifier type is stored in the additional identifier array. This must be implemented
	 * so the patient identifier type can be found
	 * @return
	 */
	protected abstract int getPatientIdentifierTypeAdditionalIdentifierIndex();
	
	/**
	 * Ugly name for method that returns a PatientIdentifier object based on the patient id and patient identifier type (or default)
	 * @return
	 */
	public PatientIdentifier getThePatientIdentifier()
	{
		return new PatientIdentifier(getPatientId(), getPatientIdentifierTypeOrDefault());
	}
	
	@Override
	public String getPatientIdentifier(){return getPatientId();}
	
	public abstract String getPatientId();
}
