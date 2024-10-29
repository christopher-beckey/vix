package gov.va.med.imaging.study.dicom.query;

import com.lbs.DCS.*;
import com.lbs.DDS.DDSException;
import com.lbs.DDS.DicomDataServiceListener;
import gov.va.med.imaging.study.dicom.DicomService;
import gov.va.med.imaging.study.dicom.vista.PatientInfo;
import gov.va.med.imaging.study.rest.types.StudyType;
import gov.va.med.logging.Logger;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.time.LocalDate;
import java.time.Month;
import java.time.ZoneOffset;
import java.util.*;

public abstract class VixDicomQuery {

    private final PatientInfo patientInfo;
    private final String callingAe;
    private final String callingIp;//these are used for traceability
    private final String calledTitle;
    private final String queryLevel;
    private final Date fromDate;
    private final Date toDate;
    private final String retrieveAe; //configured title or called title if promiscuous
    private final Set<String> queriedModalities;
    private final long startMillis;
    private final DicomDataServiceListener listener; //null for cmove and web service
    private final DimseMessage dimseQuery;
    private final String transactionGuid;
    private final QueryType queryType;

    private static final Logger logger = Logger.getLogger(VixDicomQuery.class);

    public VixDicomQuery(String transactionGuid, PatientInfo patientInfo){ //for web service
        this.queryType = QueryType.PATIENTCFIND;
        this.transactionGuid = transactionGuid;
        this.patientInfo = patientInfo;
        this.dimseQuery = null;
        this.listener = null;
        this.startMillis = System.currentTimeMillis();
        this.queriedModalities = new HashSet<>();
        this.retrieveAe = "WebService";
        LocalDate tempFromDate = LocalDate.of(1900, Month.JANUARY, 1);
        LocalDate tempToDate = LocalDate.now().plusYears(100);
        this.toDate = Date.from(tempToDate.atStartOfDay(ZoneOffset.UTC).toInstant());
        this.fromDate = Date.from(tempFromDate.atStartOfDay().toInstant(ZoneOffset.UTC));
        this.queryLevel = "STUDY";
        this.calledTitle = "WebService";
        this.callingIp = "WebService";
        this.callingAe = "WebService";
    }

    public VixDicomQuery(VixDicomQuery toCopy){
        this.queryType = toCopy.queryType;
        this.transactionGuid = toCopy.transactionGuid;
        this.dimseQuery = toCopy.dimseQuery;
        this.listener = null;
        this.startMillis = toCopy.startMillis;
        this.queriedModalities = new HashSet<>(toCopy.queriedModalities);
        this.retrieveAe = toCopy.retrieveAe;
        this.toDate = toCopy.toDate;
        this.fromDate = toCopy.fromDate;
        this.calledTitle = toCopy.calledTitle;
        this.queryLevel = toCopy.queryLevel;
        this.callingAe = toCopy.callingAe;
        this.callingIp = toCopy.callingIp;
        this.patientInfo = toCopy.patientInfo;
    }

    public VixDicomQuery(DimseMessage dimseQuery, DicomDataServiceListener listener, AssociationAcceptor association,
                         PatientInfo patientInfo, String transactionGuid, QueryType queryType, long startMillis)
            throws DDSException {
        String queryLevel1;
        this.dimseQuery = dimseQuery;
        this.listener = listener;
        this.startMillis = startMillis;
        this.calledTitle = association.getAssociationInfo().calledTitle();
        this.callingIp = association.getAssociationInfo().callingPresentationAddress().substring(0, association.getAssociationInfo().callingPresentationAddress().indexOf(":"));// we don't care about the port
        this.patientInfo = patientInfo;
        this.transactionGuid = transactionGuid;

        String tempCallingTitle = association.getAssociationInfo().callingTitle();
        if (tempCallingTitle.indexOf(",") > 0) {
            tempCallingTitle = tempCallingTitle.substring(0, tempCallingTitle.indexOf(","));
        }
        this.callingAe = tempCallingTitle;
        if(dimseQuery.data() == null) {
            logger.error("null query received from {}", this.callingAe);
            throw new DDSException("null query received from " + this.callingAe);
        }

        String tempRetrieveAe = DicomService.getScpConfig().getCalledAETitle();
        if (tempRetrieveAe == null || tempRetrieveAe.equals("ANY_0.0.0.0")) {
            tempRetrieveAe = calledTitle; //tell the caller to call us back at the address they have
        }
        this.retrieveAe = tempRetrieveAe;


        Date tempToDate = Date.from(LocalDate.now().plusYears(100).atStartOfDay(ZoneOffset.UTC).toInstant());
        Date tempFromDate = Date.from(LocalDate.of(1900, Month.JANUARY, 1).atStartOfDay(ZoneOffset.UTC).toInstant());
        try {
            String dateString = dimseQuery.data().getElementStringValue(DCM.E_STUDY_DATE);
            if (dateString != null && !dateString.isEmpty()) {
                if (dateString.contains("-")){
                    int endIndex = dateString.indexOf("-");
                    tempFromDate = transformDate(dateString.substring(0, endIndex), tempFromDate);
                    tempToDate = transformDate(dateString.substring(endIndex + 1).trim(), tempToDate);
                }else{
                    tempFromDate = transformDate(dateString.trim(), tempFromDate);
                    tempToDate = tempFromDate;
                }
            }
        } catch (Exception e) {
            logger.debug("Query does not have studyDate parameter. No filtering on dates. {}", e.getMessage());
        }

        this.fromDate = tempFromDate;
        this.toDate = tempToDate;

        try {
            queryLevel1 = dimseQuery.data().getElementStringValue(DCM.E_QUERYRETRIEVE_LEVEL).trim();
        } catch (DCSException e) {
            logger.info("no query level in query from {} defaulting to STUDY", this.callingAe);
            queryLevel1 = "STUDY";
        }
        this.queryLevel = queryLevel1;

        this.queriedModalities = parseModalitiesFromQuery(dimseQuery);
        this.queryType = queryType;
    }

    private Date transformDate(String aDate, Date defaultValue) {
        try {
            return new SimpleDateFormat("yyyyMMdd").parse(aDate);
        } catch (ParseException e) {
            logger.warn("query contained invalid date {}", e.getMessage());
            return defaultValue;
        }
    }

    private static Set<String> parseModalitiesFromQuery(DimseMessage query) {
        Set<String> qMods = new HashSet<>();
        try {
            DicomElement demod = query.data().findElement(DCM.E_MODALITIES_IN_STUDY);
            if (demod != null && demod.length() > 0) {
                int i = 0;
                int len = demod.length();
                int jumpstep = 3;
                while (len > 0) {
                    String m = demod.getStringValue(i).toUpperCase();
                    if (m.startsWith("*")) {
                        m = m.substring(1);
                        if (m.endsWith("*"))
                            m = m.substring(0, m.length() - 1);
                        jumpstep = 4;
                    }
                    qMods.add(m.trim());
                    i++;
                    len -= jumpstep;
                }
                if(logger.isDebugEnabled()){
                    logger.debug("Total modalities query requested: {}", String.join(",", qMods));
                }
            }
        } catch (DCSException e) {
            logger.debug("Problem processing query param MODALITIES_IN_STUDY. {}", e.getMessage());
        }
        return qMods;
    }

    public abstract void performCFind() throws DDSException;

    public abstract Vector<DicomPersistentObjectDescriptor> performCMove() throws DDSException;

    public PatientInfo getPatientInfo() {
        return patientInfo;
    }

    public String getCallingAe() {
        return callingAe;
    }

    public String getCallingIp() {
        return callingIp;
    }

    public String getCalledTitle() {
        return calledTitle;
    }

    public String getQueryLevel() {
        return queryLevel;
    }

    public Date getFromDate() {
        return fromDate;
    }

    public Date getToDate() {
        return toDate;
    }

    public String getRetrieveAe() {
        return retrieveAe;
    }

    public Set<String> getQueriedModalities() {
        return queriedModalities;
    }

    public long getStartMillis() {
        return startMillis;
    }

    public DicomDataServiceListener getListener() {
        return listener;
    }

    public DimseMessage getDimseQuery() {
        return dimseQuery;
    }

    public String getTransactionGuid() {
        return transactionGuid;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;

        VixDicomQuery that = (VixDicomQuery) o;

        if (!patientInfo.equals(that.patientInfo)) return false;
        if (!callingAe.equals(that.callingAe)) return false;
        if (!callingIp.equals(that.callingIp)) return false;
        if (!queryLevel.equals(that.queryLevel)) return false;
        if (!fromDate.equals(that.fromDate)) return false;
        if (!toDate.equals(that.toDate)) return false;
        if (!retrieveAe.equals(that.retrieveAe)) return false;
        if (!Objects.equals(queriedModalities, that.queriedModalities))
            return false;
        return transactionGuid.equals(that.transactionGuid);
    }

    @Override
    public int hashCode() {
        int result = patientInfo.hashCode();
        result = 31 * result + callingAe.hashCode();
        result = 31 * result + callingIp.hashCode();
        result = 31 * result + queryLevel.hashCode();
        result = 31 * result + fromDate.hashCode();
        result = 31 * result + toDate.hashCode();
        result = 31 * result + retrieveAe.hashCode();
        result = 31 * result + (queriedModalities != null ? queriedModalities.hashCode() : 0);
        result = 31 * result + transactionGuid.hashCode();
        return result;
    }

    public QueryType getQueryType() {
        return queryType;
    }

    protected Set<String> getCleanModalities(StudyType study) {
        if(study.getProcedureDescription() == null &&
                (study.getStudyModalities() == null || study.getStudyModalities().length == 0)){
            return new HashSet<>();
        }
        Set<String> modalities = new HashSet<>();
        Set<String> cleanedModalities = new HashSet<>();
        String mod = study.getProcedureDescription(); // only Cerner not here and they should be fixing?
        if(mod == null || mod.isEmpty() && (study.getStudyModalities() != null && study.getStudyModalities().length > 0)){ //handle Cerner
            cleanedModalities.addAll(Arrays.asList(study.getStudyModalities()));
        }
        else{
            Collections.addAll(modalities, mod.split(","));
        }
        for(String modality : modalities) {
            String cleanedModality = modality;
            if (modality.startsWith("RAD ") || modality.startsWith("CON ")) {// vista added. remove. per John D.
                cleanedModality = modality.substring(4);
            }
            cleanedModalities.add(cleanedModality.trim());
        }

        if (calledTitle.equalsIgnoreCase("WebService") || (DicomService.getScpConfig().getAEbuildImageReport(getCallingAe(), getCallingIp()).equalsIgnoreCase("SR")
                && study.getStudyId().contains(":vastudy:") && !study.getStudyId().contains("200CRNR"))) { // if a VA one and non-image (textual) SR one
            cleanedModalities.add("SR");
        }
        return cleanedModalities;
    }

    public enum QueryType{
        PATIENTCFIND, //C-FIND w/ patientId, currently default, will pivot to STUDYCFIND if study Uid present
        STUDYCFIND, //C-FIND w/ studyUid
        CMOVE //C-MOVE w/ studyUid
    }
}
