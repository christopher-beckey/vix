/**
 * 
 */
package gov.va.med.imaging.terminology;

import java.net.URI;
import java.util.List;

/**
 * @author vhaiswbeckec
 *
 */
public abstract class SchemeTranslationProvider
{
	public abstract List<SchemeTranslationServiceMapping> getSchemeTranslationServiceMappings();
	
	/**
	 * 
	 * @author vhaiswbeckec
	 *
	 */
	public class SchemeTranslationServiceMapping
	{
		private final String manufacturer;
		private final CodingScheme sourceScheme;
		private final CodingScheme destinationScheme;
		private final Class<? extends SchemeTranslationSPI> translationClass;
		
		/**
		 * @param sourceScheme
		 * @param destinationScheme
		 * @param translationClass
		 */
		public SchemeTranslationServiceMapping(
				String manufacturer,
				CodingScheme sourceScheme,
				CodingScheme destinationScheme,
				Class<? extends SchemeTranslationSPI> translationClass)
		{
			super();
			this.manufacturer = manufacturer;
			this.sourceScheme = sourceScheme;
			this.destinationScheme = destinationScheme;
			this.translationClass = translationClass;
		}

		public String getManufacturer()
		{
			return this.manufacturer;
		}

		public CodingScheme getSourceScheme()
		{
			return this.sourceScheme;
		}

		public CodingScheme getDestinationScheme()
		{
			return this.destinationScheme;
		}

		public Class<? extends SchemeTranslationSPI> getTranslationClass()
		{
			return this.translationClass;
		}

		@Override
		public int hashCode()
		{
			final int prime = 31;
			int result = 1;
			result = prime
					* result
					+ ((this.destinationScheme == null) ? 0
							: this.destinationScheme.hashCode());
			result = prime
					* result
					+ ((this.manufacturer == null) ? 0 : this.manufacturer
							.hashCode());
			result = prime
					* result
					+ ((this.sourceScheme == null) ? 0 : this.sourceScheme
							.hashCode());
			result = prime
					* result
					+ ((this.translationClass == null) ? 0
							: this.translationClass.hashCode());
			return result;
		}

		@Override
		public boolean equals(Object obj)
		{
			if (this == obj)
				return true;
			if (obj == null)
				return false;
			if (getClass() != obj.getClass())
				return false;
			final SchemeTranslationServiceMapping other = (SchemeTranslationServiceMapping) obj;
			if (this.destinationScheme == null)
			{
				if (other.destinationScheme != null)
					return false;
			}
			else if (!this.destinationScheme.equals(other.destinationScheme))
				return false;
			if (this.manufacturer == null)
			{
				if (other.manufacturer != null)
					return false;
			}
			else if (!this.manufacturer.equals(other.manufacturer))
				return false;
			if (this.sourceScheme == null)
			{
				if (other.sourceScheme != null)
					return false;
			}
			else if (!this.sourceScheme.equals(other.sourceScheme))
				return false;
			if (this.translationClass == null)
			{
				if (other.translationClass != null)
					return false;
			}
			else if (!this.translationClass.equals(other.translationClass))
				return false;
			return true;
		}

		@Override
		public String toString()
		{
			StringBuilder sb = new StringBuilder();
			
			sb.append(this.getClass().getSimpleName());
			sb.append('(');
			sb.append(this.getSourceScheme().toString());
			sb.append("->");
			sb.append(this.getDestinationScheme().toString());
			sb.append(')');
			
			return sb.toString();
		}

	}
}
