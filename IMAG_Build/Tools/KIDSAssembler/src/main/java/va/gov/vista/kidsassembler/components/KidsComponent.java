package va.gov.vista.kidsassembler.components;

import java.util.ArrayList;
import java.util.List;

public abstract class KidsComponent implements Comparable<KidsComponent> {
	protected String name;
	protected final List<GlobalNode> body;

	public KidsComponent() {
		this.body = new ArrayList<GlobalNode>();
	}

	public KidsComponent(String name) {
		this();
		this.name = name;
	}

	@Override
	public int compareTo(KidsComponent o) {
		if (o == null)
			return 1;
		Class<? extends KidsComponent> class1 = this.getClass();
		Class<? extends KidsComponent> class2 = o.getClass();
		if (class1 != class2)
			return class1.getName().compareTo(class2.getName());
		if (name == null && o.name == null)
			return 0;
		return name.compareTo(o.name);
	}

	@Override
	public boolean equals(Object obj) {
		if (this == obj)
			return true;
		if (obj == null)
			return false;
		if (!(obj instanceof KidsComponent))
			return false;
		KidsComponent other = (KidsComponent) obj;
		if (this.getClass() != other.getClass())
			return false;
		if (name == null) {
			if (other.name != null)
				return false;
		} else if (!name.equals(other.name))
			return false;
		return true;
	}

	public List<GlobalNode> getBody() {
		return body;
	}

	public String getName() {
		return name;
	}

	@Override
	public int hashCode() {
		final int prime = 31;
		int result = 1;
		result = prime * result + this.getClass().hashCode();
		result = prime * result + ((name == null) ? 0 : name.hashCode());
		return result;
	}

	public void setName(String name) {
		this.name = name;
	}

	@Override
	public String toString() {
		return this.getClass().getName() + " [name=" + name + "]";
	}
}
