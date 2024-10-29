package gov.va.med.imaging.study.dicom.vista;

import gov.va.med.imaging.study.dicom.PatVistaInfo;

import java.util.List;

public class PatientInfo {
	private String icn = "";
	private String dssn;
	private String edipi;
	private String ien;
	private String dob;
	private String sex;
	private String name;
	private List<String> mtfList;
	private boolean isPatIdResolved = false;

	public PatientInfo(){

	}

	public PatientInfo(PatVistaInfo patVistaInfo){
		if(patVistaInfo.getIcn() != null && !patVistaInfo.getIcn().isEmpty()){
			isPatIdResolved = true;
		}

		this.icn = patVistaInfo.getIcn();
		this.dssn = patVistaInfo.getSsn();
		this.dob = patVistaInfo.getDob();
		this.mtfList = patVistaInfo.getTreatingSiteCodes();
		this.name = patVistaInfo.getName();
		this.sex = patVistaInfo.getSex();
	}

	public String getIcn() {
		return icn;
	}
	public void setIcn(String icn) {
		this.icn = icn;
	}
	public String getSsn() {
		if(dssn == null){
			return null;
		}
		return dssn.replace("-", "");
	}

	public String getDssn() {
		return dssn;
	}
	public void setDssn(String dssn) {
		this.dssn = dssn;
	}
	public String getEdipi() {
		return edipi;
	}
	public void setEdipi(String edipi) {
		this.edipi = edipi;
	}
	public String getIen() {
		return ien;
	}
	public void setIen(String ien) {
		this.ien = ien;
	}
	public String getLogIcn() {
		return "*****" + this.icn.substring(5);
	}
	public String getDob() {
		return dob;
	}
	public void setDob(String dob) {
		this.dob = dob;
	}
	public String getSex() {
		return sex;
	}
	public void setSex(String sex) {
		this.sex = sex;
	}
	
	public String getName() {
		return name;
	}
	public void setName(String name) {
		this.name = name;
	}
	public String getMaskedSsn() {
		return "*****"+ getSsn().substring(5);
	}
	public String toString() {
		return "ICN=" + icn + "; SSN=" + dssn + "; IEN=" + ien + "; EDIPI=" + edipi + "; DOB=" + dob + "; SEX=" + sex + "; NAME=" + name;
	}

	public List<String> getMtfList() {
		return mtfList;
	}

	public void setMtfList(List<String> mtfList) {
		this.mtfList = mtfList;
	}

	public boolean isPatIdResolved() {
		return isPatIdResolved;
	}

	public void setPatIdResolved(boolean patIdResolved) {
		isPatIdResolved = patIdResolved;
	}
}
