package va.gov.vista.kidsassembler.parsers;

public class DelimitedString {

	protected final String original;
	protected final String regex;
	protected final String[] parts;
	protected final boolean isOneBasedIndex;

	public DelimitedString(String original, String regex) {
		this(original, regex, false);
	}

	public DelimitedString(String original, String regex,
			boolean isOneBasedIndex) {
		this.original = original;
		this.regex = regex;
		this.parts = original.split(regex);
		this.isOneBasedIndex = isOneBasedIndex;
	}

	public String getOriginal() {
		return original;
	}
	
	public int getNumParts(){
		return parts.length;
	}

	public String getPart(int index) {
		if (isOneBasedIndex) {
			index--;
		}
		return parts[index];
	}

	public String getPartOrEmpty(int index) {
		if (isOneBasedIndex) {
			index--;
		}
		if (parts.length > index)
			return parts[index];
		return "";
	}

	public String getPartOrNull(int index) {
		if (isOneBasedIndex) {
			index--;
		}
		if (parts.length > index)
			return parts[index];
		return null;
	}

	public String getParts(int indexFrom, int indexTo) {
		if (isOneBasedIndex) {
			indexFrom--;
			indexTo--;
		}
		
		String result = "";
		
		if (parts.length > indexFrom)
			result = parts[indexFrom];
		

		for (int i=indexFrom + 1; (i < parts.length) && i <= indexTo; i++) 
		{
			result += regex + parts[i];
		}
				
		return result;
	}

	public String[] getParts() {
		return parts;
	}
	
	public String getRegex() {
		return regex;
	}

	public boolean isOneBasedIndex() {
		return isOneBasedIndex;
	}

	@Override
	public String toString() {
		return original;
	}
}
