package gov.va.med.imaging.study.dicom;

import gov.va.med.imaging.study.dicom.vista.PatientInfo;

import javax.xml.bind.annotation.XmlRootElement;
import java.util.ArrayList;
import java.util.List;

@XmlRootElement
public class PatVistaInfo {
    private List<String> treatingSiteCodes = new ArrayList<>();
    private String icn;
    private String dob;
    private String sex;
    private String name;
    private String ssn;

    public PatVistaInfo(){

    }

    public PatVistaInfo(PatientInfo patInfo){
        this.icn = patInfo.getIcn();
        this.dob = patInfo.getDob();
        this.sex = patInfo.getSex();
        this.name = patInfo.getName();
        this.treatingSiteCodes.addAll(patInfo.getMtfList());
        this.ssn = patInfo.getSsn();
    }

    public List<String> getTreatingSiteCodes() {
        return treatingSiteCodes;
    }

    public String getIcn() {
        return icn;
    }

    public String getDob() {
        return dob;
    }

    public String getSex() {
        return sex;
    }

    public String getName() {
        return name;
    }

    @Override
    public String toString() {
        return "PatVistaInfo{" +
                "treatingSiteCodes=" + String.join(",",treatingSiteCodes) +
                ", icn='" + icn + '\'' +
                ", dob='" + dob + '\'' +
                ", sex='" + sex + '\'' +
                ", name='" + name + '\'' +
                '}';
    }

    public void setDob(String dob) {
        this.dob = dob;
    }

    public void setTreatingSiteCodes(List<String> treatingSiteCodes) {
        this.treatingSiteCodes = treatingSiteCodes;
    }

    public void setIcn(String icn) {
        this.icn = icn;
    }

    public void setSex(String sex) {
        this.sex = sex;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getSsn() {
        return ssn;
    }

    public void setSsn(String ssn) {
        this.ssn = ssn;
    }
}
