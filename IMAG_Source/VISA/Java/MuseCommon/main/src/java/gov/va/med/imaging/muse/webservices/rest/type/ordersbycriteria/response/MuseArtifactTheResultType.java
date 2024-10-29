package gov.va.med.imaging.muse.webservices.rest.type.ordersbycriteria.response;

import java.io.Serializable;

import javax.xml.bind.annotation.XmlAccessType;
import javax.xml.bind.annotation.XmlAccessorType;
import javax.xml.bind.annotation.XmlElement;
import javax.xml.bind.annotation.XmlType;

@XmlAccessorType(XmlAccessType.FIELD)
@XmlType(name="TheResult")
public class MuseArtifactTheResultType 
implements Serializable{

	private static final long serialVersionUID = -3927064517569702268L;

	@XmlElement(name="Test")
	private MuseArtifactResultTestType [] tests = null;

	/**
	 * @return the tests
	 */
	public MuseArtifactResultTestType [] getTests() {
		return tests;
	}

	/**
	 * @param tests the tests to set
	 */
	public void setTests(MuseArtifactResultTestType [] tests) {
		this.tests = tests;
	}
}
