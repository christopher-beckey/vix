package va.gov.vista.kidsassembler.components;

public class GlobalNode {
	protected final String key;
	protected final String data;

	public GlobalNode(String key, String data) {
		this.key = key;
		this.data = data;
	}

	public String getKey() {
		return key;
	}

	public String getData() {
		return data;
	}
}
