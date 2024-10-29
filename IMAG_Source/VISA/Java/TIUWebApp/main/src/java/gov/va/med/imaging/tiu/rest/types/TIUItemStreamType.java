package gov.va.med.imaging.tiu.rest.types;

import java.io.InputStream;

public class TIUItemStreamType {

    private InputStream inputStream;
    private String originalFilename;

    /**
     * Default constructor
     */
    public TIUItemStreamType() {
    	super();
    }

    /**
     * Convenient constructor
     * 
     * @param InputStream
     * 
     */
    public TIUItemStreamType(InputStream inputStream) {
    	super();
        this.inputStream = inputStream;
    }

    /**
     * Convenient constructor
     * 
     * @param InputStream
     * @param String				original file name
     * 
     */
    public TIUItemStreamType(InputStream inputStream, String originalFilename) {
    	super();
        this.inputStream = inputStream;
        this.originalFilename = originalFilename;
    }

	public InputStream getInputStream() {
		return inputStream;
	}

	public void setInputStream(InputStream inputStream) {
		this.inputStream = inputStream;
	}

	public String getOriginalFilename() {
		return originalFilename;
	}

	public void setOriginalFilename(String originalFilename) {
		this.originalFilename = originalFilename;
	}

}

