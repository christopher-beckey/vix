package gov.va.med.imaging.ingest.business;

public enum TIUNoteSignatureOption {
    DNS ("DNS", "Do Not Sign"),
    ES ("ES", "Electronically Sign"),
    EF ("EF", "Electronically File");

    private final String optionAbbr;
    private final String description;

    TIUNoteSignatureOption(String optionAbbr, String description){
        this.optionAbbr = optionAbbr;
        this.description = description;
    }

    public String getOptionAbbr() {
        return optionAbbr;
    }

    public String getDescription() {
        return description;
    }
}
