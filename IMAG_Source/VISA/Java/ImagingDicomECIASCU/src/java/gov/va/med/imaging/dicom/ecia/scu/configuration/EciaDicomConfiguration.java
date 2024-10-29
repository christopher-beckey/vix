package gov.va.med.imaging.dicom.ecia.scu.configuration;

/**
 * DICOM configurations
 * 
 * @author Quoc Nguyen
 *
 */
public class EciaDicomConfiguration {

	/**
	 * Default constructor
	 */
	public EciaDicomConfiguration() {
		super();
	}

	/**
	 * Convenient constructor
	 * 
	 * @param String 			server host
	 * @param int 				server port
	 * @param String			calling AE
	 * @param String			called AE
	 * 
	 */
	public EciaDicomConfiguration(String serverHost, int serverPort, String callingAE, String calledAE, int connectTimeOut, int cfindRspTimeOut) {
		super();
		this.serverHost = serverHost;
		this.serverPort = serverPort;
		this.callingAE = callingAE;
		this.calledAE = calledAE;
		this.connectTimeOut = connectTimeOut;
		this.cfindRspTimeOut = cfindRspTimeOut;
	}
	
	private String serverHost;	
	private String callingAE;
	private String calledAE;
	private int serverPort;
	private int connectTimeOut;
	private int cfindRspTimeOut;
	
	public String getServerHost() {
		return serverHost;
	}

	public void setServerHost(String serverHost) {
		this.serverHost = serverHost;
	}

	public String getCallingAE() {
		return callingAE;
	}

	public void setCallingAE(String callingAE) {
		this.callingAE = callingAE;
	}

	public String getCalledAE() {
		return calledAE;
	}

	public void setCalledAE(String calledAE) {
		this.calledAE = calledAE;
	}

	public int getServerPort() {
		return serverPort;
	}

	public void setServerPort(int serverPort) {
		this.serverPort = serverPort;
	}

	public int getConnectTimeOut() {
		return connectTimeOut;
	}

	public void setConnectTimeOut(int connectTimeOut) {
		this.connectTimeOut = connectTimeOut;
	}

	public int getCfindRspTimeOut() {
		return cfindRspTimeOut;
	}

	public void setCfindRspTimeOut(int cfindRspTimeOut) {
		this.cfindRspTimeOut = cfindRspTimeOut;
	}

	@Override
	public int hashCode() {
		final int prime = 31;
		int result = 1;
		result = prime * result + ((calledAE == null) ? 0 : calledAE.hashCode());
		result = prime * result + ((callingAE == null) ? 0 : callingAE.hashCode());
		result = prime * result + cfindRspTimeOut;
		result = prime * result + connectTimeOut;
		result = prime * result + ((serverHost == null) ? 0 : serverHost.hashCode());
		result = prime * result + serverPort;
		return result;
	}

	@Override
	public boolean equals(Object obj) {
		if (this == obj)
			return true;
		if (obj == null)
			return false;
		if (getClass() != obj.getClass())
			return false;
		EciaDicomConfiguration other = (EciaDicomConfiguration) obj;
		if (calledAE == null) {
			if (other.calledAE != null)
				return false;
		} else if (!calledAE.equals(other.calledAE))
			return false;
		if (callingAE == null) {
			if (other.callingAE != null)
				return false;
		} else if (!callingAE.equals(other.callingAE))
			return false;
		if (cfindRspTimeOut != other.cfindRspTimeOut)
			return false;
		if (connectTimeOut != other.connectTimeOut)
			return false;
		if (serverHost == null) {
			if (other.serverHost != null)
				return false;
		} else if (!serverHost.equals(other.serverHost))
			return false;
		if (serverPort != other.serverPort)
			return false;
		return true;
	}

	@Override
	public String toString() {
		return "EciaDicomConfiguration [serverHost=" + serverHost + ", callingAE=" + callingAE + ", calledAE="
				+ calledAE + ", serverPort=" + serverPort + ", connectTimeOut=" + connectTimeOut + ", cfindRspTimeOut="
				+ cfindRspTimeOut + "]";
	}
	
	
	
}