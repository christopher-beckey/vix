package gov.va.med.imaging.storage.cache.impl;

public class ServerRunningStatus 
{

	private boolean serverRunning = false;

	/**
	 * @return the serverRunning
	 */
	public boolean isServerRunning() {
		return serverRunning;
	}

	/**
	 * @param serverRunning the serverRunning to set
	 */
	public void setServerRunning(boolean serverRunning) {
		this.serverRunning = serverRunning;
	}
}
