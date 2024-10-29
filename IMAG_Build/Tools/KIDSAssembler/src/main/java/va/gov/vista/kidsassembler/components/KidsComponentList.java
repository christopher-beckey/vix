package va.gov.vista.kidsassembler.components;

import java.util.LinkedList;

public class KidsComponentList<T extends KidsComponent> extends LinkedList<T>
		implements Comparable<KidsComponentList<? extends KidsComponent>> {
	private static final long serialVersionUID = 7557083867373811816L;
	protected final String name;

	public KidsComponentList(String name) {
		this.name = name;
	}

	@Override
	public int compareTo(KidsComponentList<? extends KidsComponent> o) {
		if (this == o)
			return 0;
		if (o == null)
			return 1;
		return this.name.compareTo(o.name);
	}

	public String getName() {
		return name;
	}
}
