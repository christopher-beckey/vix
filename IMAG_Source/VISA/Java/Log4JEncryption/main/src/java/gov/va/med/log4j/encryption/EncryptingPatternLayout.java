/**
 * Per VHA Directive 2004-038, this routine should not be modified.
 * Property of the US Government.  No permission to copy or redistribute this software is given. 
 * Use of unreleased versions of this software requires the user to execute a written agreement 
 * with the VistA Imaging National Project Office of the Department of Veterans Affairs.  
 * Please contact the National Service Desk at(888)596-4357 or vhaistnsdtusc@va.gov in order to 
 * reach the VistA Imaging National Project office.
 * 
 * The Food and Drug Administration classifies this software as a medical device.  As such, it 
 * may not be changed in any way.  Modifications to this software may result in an adulterated 
 * medical device under 21CFR, the use of which is considered to be a violation of US Federal Statutes.
 * 
 * Federal law restricts this device to use by or on the order of either a licensed practitioner or persons 
 * lawfully engaged in the manufacture, support, or distribution of the product.
 * 
 * Created: Mar 8, 2012
 * Author: VHAISWBECKEC
 */
package gov.va.med.log4j.encryption;

import java.nio.ByteBuffer;
import java.nio.charset.Charset;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.ListIterator;
import java.util.Map;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import org.apache.logging.log4j.core.LogEvent;
import org.apache.logging.log4j.core.config.Configuration;
import org.apache.logging.log4j.core.layout.AbstractStringLayout;
import org.apache.logging.log4j.core.layout.PatternLayout;
import org.apache.logging.log4j.core.layout.PatternSelector;
import org.apache.logging.log4j.core.layout.AbstractStringLayout.Serializer;
import org.apache.logging.log4j.core.layout.PatternLayout.SerializerBuilder;
import org.apache.logging.log4j.core.pattern.RegexReplacement;


/**
 * @author VHAISWBECKEC
 */
public class EncryptingPatternLayout
extends AbstractStringLayout
{
    public static final String DEFAULT_CONVERSION_PATTERN = "%m%n";

    private final String conversionPattern;
    private final PatternSelector patternSelector;
    private final Serializer eventSerializer;
    

    private EncryptingPatternLayout(final Configuration config, final RegexReplacement replace, final String eventPattern,
            final PatternSelector patternSelector, final Charset charset, final boolean alwaysWriteExceptions,
            final boolean disableAnsi, final boolean noConsoleNoAnsi, final String headerPattern,
            final String footerPattern) {
        super(config, charset,
                newSerializerBuilder()
                        .setConfiguration(config)
                        .setReplace(replace)
                        .setPatternSelector(patternSelector)
                        .setAlwaysWriteExceptions(alwaysWriteExceptions)
                        .setDisableAnsi(disableAnsi)
                        .setNoConsoleNoAnsi(noConsoleNoAnsi)
                        .setPattern(headerPattern)
                        .build(),
                newSerializerBuilder()
                        .setConfiguration(config)
                        .setReplace(replace)
                        .setPatternSelector(patternSelector)
                        .setAlwaysWriteExceptions(alwaysWriteExceptions)
                        .setDisableAnsi(disableAnsi)
                        .setNoConsoleNoAnsi(noConsoleNoAnsi)
                        .setPattern(footerPattern)
                        .build());
        this.conversionPattern = eventPattern;
        this.patternSelector = patternSelector;
        this.eventSerializer = newSerializerBuilder()
                .setConfiguration(config)
                .setReplace(replace)
                .setPatternSelector(patternSelector)
                .setAlwaysWriteExceptions(alwaysWriteExceptions)
                .setDisableAnsi(disableAnsi)
                .setNoConsoleNoAnsi(noConsoleNoAnsi)
                .setPattern(eventPattern)
                .setDefaultPattern(DEFAULT_CONVERSION_PATTERN)
                .build();
    }

    public static SerializerBuilder newSerializerBuilder() {
        return new SerializerBuilder();
    }


	private String key;
	private String transformation;
	private PatternLayout layout;
	
	// e.g. %-20.30c
	// \\x2E - dot
	// \\x7B - {
	// \\x7D - }
	public final static String FIELD_REGEX = "%((-)?[\\d]*(\\x2E[\\d]*)?)?(\\x7B[\\w]*\\x7D)([cCdFlLmMnprtxX%])";
	public final static Pattern FIELD_PATTERN = Pattern.compile(FIELD_REGEX);
	public final static int TABBING_GROUP = 1;
	public final static int NEGATION_GROUP = 2;
	public final static int FRACTIONAL_GROUP = 3;
	public final static int ENCRYPTION_GROUP = 4;
	public final static int FIELD_GROUP = 5;

	// 
	private Map<PatternLayoutField, String> fieldEncryption = new HashMap<PatternLayoutField, String>();
	private final String thisPackageName = this.getClass().getPackage().getName();
	private String cPattern;
	
	/**
	 * 
	 * e.g. %d{DATE} %5p [%t] (%F:%L) - %m%n
	 */
	public void setConversionPattern(String conversionPattern)
	{
		List<EncryptedField> encryptedFields = new ArrayList<EncryptedField>();
		Matcher fieldMatcher = FIELD_PATTERN.matcher(conversionPattern);
		
		// find each of the fields that are expected to be encrypted
		while( fieldMatcher.find() )
		{
			String group = fieldMatcher.group();
			System.out.println( "Encrypting " + group);
			
			Matcher fieldContentMatcher = FIELD_PATTERN.matcher(group);
			if( ! fieldContentMatcher.matches() )
				throw new IllegalStateException("Unable to match group " + group + " with pattern " + FIELD_PATTERN.pattern() + ".");
			
			String encryption = fieldContentMatcher.group(ENCRYPTION_GROUP);
			String field = fieldContentMatcher.group(FIELD_GROUP);
			
			StringBuilder unencryptedField = new StringBuilder(); 
			unencryptedField.append("%");
			if(fieldContentMatcher.group(TABBING_GROUP) != null && fieldContentMatcher.group(TABBING_GROUP).length() > 0)
				unencryptedField.append(fieldContentMatcher.group(TABBING_GROUP));
			unencryptedField.append(field);
			
			String unencryptedFieldSpecification = unencryptedField.toString();
			
			System.out.println( "Encrypting " + field + " with " + encryption + " => " + unencryptedFieldSpecification);
			
			encryptedFields.add(new EncryptedField(field.charAt(0), encryption, group, unencryptedFieldSpecification));
		}

		//
		for(ListIterator<EncryptedField> iter = encryptedFields.listIterator(); iter.hasNext(); )
		{
			EncryptedField encryptedField = iter.next();
			conversionPattern = conversionPattern.replace(encryptedField.getEncryptedFieldSpecification(), encryptedField.getUnencryptedFieldSpecification() );
			
			PatternLayoutField field = PatternLayoutField.findByFieldChar(encryptedField.getField());
			// remove the curly brackets before saving the encryption
			fieldEncryption.put(field, encryptedField.getEncryption().substring(1, encryptedField.getEncryption().length()-1));
			
			iter.remove();
		}
		
		cPattern = conversionPattern;
	}

	public String getConversionPattern()
	{
		return cPattern;
	}

	public String getKey()
	{
		return key;
	}

	public void setKey(String key)
	{
		this.key = key;
	}

	public String getTransformation()
	{
		return transformation;
	}

	public void setTransformation(String transformation)
	{
		this.transformation = transformation;
	}

//	@Override
//	public String format(LoggingEvent event)
//	{
//		String category = event.fqnOfCategoryClass;
//		String logger = event.getLoggerName();//getLogger();
//		long timeStamp = event.timeStamp;  //getTimeStamp()
//		Level level = event.getLevel();
//		Object message = event.getMessage();
//		String threadName = event.getThreadName();
//		ThrowableInformation throwableInfo = event.getThrowableInformation();
//		String ndc = event.getNDC();
//		LocationInfo locationInformation = event.getLocationInformation();
//		//Map<?,?> properties = event.getProperties();
//		
//		String categoryEncryption = this.fieldEncryption.get(PatternLayoutField.CATEGORY);
//		String messageEncryption = this.fieldEncryption.get(PatternLayoutField.MESSAGE);
//		String threadNameEncryption = this.fieldEncryption.get(PatternLayoutField.THREAD);
//		String ndcEncryption = this.fieldEncryption.get(PatternLayoutField.NDC);
//
//		// log4j 1.2.14 compatible
//		LoggingEvent clone = new LoggingEvent(
//			category, 
//			Category.getInstance(logger),
//			timeStamp,
//			Priority.toPriority(level.toInt()),
//			messageEncryption != null ? encryptField(message == null ? "" : message.toString(), messageEncryption) : message, 
//			throwableInfo != null ? throwableInfo.getThrowable() : null
//		);

		// log4j 1.2.16 compatible
//		LoggingEvent clone = new LoggingEvent(
//			categoryEncryption != null ? encryptField(category, categoryEncryption) : category, 
//			logger,
//			timeStamp, 
//			level, 
//			messageEncryption != null ? encryptField(message.toString(), messageEncryption) : message, 
//			threadNameEncryption != null ? encryptField(threadName, threadNameEncryption) : threadName, 
//			throwableInfo, 
//			ndcEncryption != null ? encryptField(ndc, ndcEncryption) : ndc, 
//			locationInformation 
//			properties
//		);
		
//		return super.format(clone);
//	}

	/**
	 * 
	 * @param cleartext
	 * @param encryption
	 * @return
	 */
	private String encryptField(String cleartext, String encryption)
	{
		FieldEncryptor fieldEncryptor = getFieldEncryptor(encryption);
		ByteBuffer clear = fieldEncryptor.getCharset().encode(cleartext);
		byte[] cleartextBytes = clear.array();
		
		byte[] encryptedBytes = fieldEncryptor.encrypt(cleartextBytes);
		
		String encoded = fieldEncryptor.encode(encryptedBytes);
		
		return "{" + encryption + "}" + encoded;
	}
	
	private Map<String, FieldEncryptor> fieldEncryptors = new HashMap<String, FieldEncryptor>();
	private FieldEncryptor getFieldEncryptor(String encryption)
	{
		FieldEncryptor fieldEncryptor = null;
		
		synchronized (fieldEncryptors)
		{
			fieldEncryptor = fieldEncryptors.get(encryption);
			if(fieldEncryptor == null)
			{
				// if the encryption has a '.' in it then it is a fully qualified class name
				// else it is assumed to be in the same package as this class
				String fieldEncryptorClassName = 
					encryption.indexOf('.') > 0 ? 
						encryption :  
						thisPackageName + "." + encryption;
				try
				{
					@SuppressWarnings("unchecked")
					Class<FieldEncryptor> fieldEncryptorClass = (Class<FieldEncryptor>)Class.forName(fieldEncryptorClassName);
					fieldEncryptor = fieldEncryptorClass.newInstance();
					fieldEncryptors.put( encryption, fieldEncryptor );
				}
				catch (Exception e)
				{
					e.printStackTrace();
				}
			}
		}
		
		return fieldEncryptor;
	}
	
	// =====================================================================================================================
	class EncryptedField
	{
		private final char field;
		private final String encryption;
		private final String encryptedFieldSpecification;
		private final String unencryptedFieldSpecification;
		
		public EncryptedField(char field, String encryption, String encryptedFieldSpecification, String unencryptedFieldSpecification)
		{
			super();
			
			this.field = field;
			this.encryption = encryption;
			this.encryptedFieldSpecification = encryptedFieldSpecification;
			this.unencryptedFieldSpecification = unencryptedFieldSpecification;
		}
		public char getField()
		{
			return this.field;
		}
		public String getEncryption()
		{
			return this.encryption;
		}
		public String getEncryptedFieldSpecification()
		{
			return encryptedFieldSpecification;
		}
		public String getUnencryptedFieldSpecification()
		{
			return unencryptedFieldSpecification;
		}
	}
	
	class EncryptionSpecification
	{
	}


    @Override
    public String toSerializable(final LogEvent event) {
        return eventSerializer.toSerializable(event);
    }
}
