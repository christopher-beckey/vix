package gov.va.med.imaging.channels;

/**
 * @author VHAISWBECKEC
 *
 */
public abstract class AbstractBytePump {
	private String name;

	protected AbstractBytePump(String name) {
		this.name = name;
	}

	public String getName() {
		return this.name;
	}

	public enum MEDIUM {
		ChannelToChannel, ChannelToStream, StreamToChannel, StreamToStream;
	}

	public enum TRANSFER_TYPE {
		ByteArrayToByteArray, ByteArrayToFile, ByteArrayToNetwork, FileToByteArray, FileToFile, FileToNetwork,
		NetworkToByteArray, NetworkToFile, NetworkToNetwork;
	}

	public enum BUFFER_SIZE {
		SixtyFourK(64 * 1024);

		public static BUFFER_SIZE defaultBufferSize = SixtyFourK;

		private int size;

		BUFFER_SIZE(int size) {
			this.size = size;
		}

		public int getSize() {
			return this.size;
		}
	}

	protected static BUFFER_SIZE getBufferSize(String name, MEDIUM medium) {
		return BUFFER_SIZE.defaultBufferSize;
	}

}
