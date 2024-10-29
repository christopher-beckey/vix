package va.gov.vista.kidsassembler.components;

public class KernelComponentList<T extends KernelComponent> extends
		KidsComponentList<T> {
	private static final long serialVersionUID = -6885399726365201511L;
	protected final float fileNumber;
	protected final int specialInstructionIndex;

	public KernelComponentList(String name, float fileNumber,
			int specialInstructionPosition) {
		super(name);
		this.fileNumber = fileNumber;
		this.specialInstructionIndex = specialInstructionPosition;
	}

	@Override
	public int compareTo(KidsComponentList<? extends KidsComponent> o) {
		if (o instanceof KernelComponentList<?>) {
			KernelComponentList<?> other = (KernelComponentList<?>) o;
			return Float.compare(this.getFileNumber(), other.getFileNumber());
		}
		return super.compareTo(o);
	}

	public float getFileNumber() {
		return fileNumber;
	}

	public String getFileNumberString() {
		String result = Float.toString(fileNumber);
		if (result.startsWith("0"))
			result = result.substring(1);
		else if (result.endsWith(".0"))
			result = result.substring(0, result.length() - 2);
		return result;
	}

	public int getSpecialInstructionIndex() {
		return specialInstructionIndex;
	}
}
