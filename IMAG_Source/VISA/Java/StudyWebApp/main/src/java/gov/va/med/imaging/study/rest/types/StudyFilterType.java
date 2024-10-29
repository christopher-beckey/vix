/**
 * 
  Package: MAG - VistA Imaging
  WARNING: Per VHA Directive 2004-038, this routine should not be modified.
  Date Created: Mar 16, 2012
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
package gov.va.med.imaging.study.rest.types;

import java.util.Date;
import java.util.List;

import javax.xml.bind.annotation.XmlRootElement;
import javax.xml.bind.annotation.XmlType;

/**
 * @author VHAISWWERFEJ
 *
 */
@XmlRootElement(name="studyFilter")
@XmlType(propOrder={"fromDate", "toDate", "resultType", "cptCodes", "modalityCodes", "storedFilterId"})
public class StudyFilterType
{
    private Date fromDate;
    private Date toDate;
    private StudyFilterResultType resultType;
    private List<String> cptCodes;
    private List<String> modalityCodes;
    private String storedFilterId;
    
    public StudyFilterType()
    {
    	super();
    }
    
	public Date getFromDate() {
		return fromDate;
	}

	public void setFromDate(Date fromDate) {
		this.fromDate = fromDate;
	}

	public Date getToDate() {
		return toDate;
	}

	public void setToDate(Date toDate) {
		this.toDate = toDate;
	}

	public StudyFilterResultType getResultType()
	{
		return resultType;
	}

	public void setResultType(StudyFilterResultType resultType)
	{
		this.resultType = resultType;
	}

	public List<String> getCptCodes() {
		return cptCodes;
	}

	public void setCptCodes(List<String> cptCodes) {
		this.cptCodes = cptCodes;
	}

	public List<String> getModalityCodes() {
		return modalityCodes;
	}

	public void setModalityCodes(List<String> modalityCodes) {
		this.modalityCodes = modalityCodes;
	}

	public String getStoredFilterId() {
		return storedFilterId;
	}

	public void setStoredFilterId(String storedFilterId) {
		this.storedFilterId = storedFilterId;
	}

	
}
