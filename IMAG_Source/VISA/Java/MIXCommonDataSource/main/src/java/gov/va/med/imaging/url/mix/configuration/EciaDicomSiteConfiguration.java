/**
 * 
 */
package gov.va.med.imaging.url.mix.configuration;

/**
 * Class to hold connection properties that are specific to ECIA.
 * 
 * @author VHAISPNGUYEQ
 *
 */
public class EciaDicomSiteConfiguration extends MIXSiteConfiguration {
	
	private String callingAE;
	private String calledAE;
	private int connectTimeOut;
	private int cfindRspTimeOut;
	
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
	public String toString() {
		return "EciaDicomSiteConfiguration [callingAE=" + callingAE + ", calledAE=" + calledAE + ", connectTimeOut="
				+ connectTimeOut + ", cfindRspTimeOut=" + cfindRspTimeOut + "]";
	}

	
}
