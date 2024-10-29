package gov.va.med.log4j.encryption;

import java.io.IOException;
import java.io.InputStream;
import java.util.Properties;

import gov.va.med.logging.Logger;

import java.nio.ByteBuffer;
import java.nio.CharBuffer;
import java.nio.charset.CharacterCodingException;
import java.nio.charset.Charset;
import java.nio.charset.CharsetDecoder;

import gov.va.med.log4j.encryption.DefaultFieldEncryptor;

public class AESConstants {

	private static final Logger logger = Logger.getLogger(AESConstants.class);
	
	public static PasswordDTO getPassword() throws CharacterCodingException {
		Properties properties = new Properties();

		// Fortify change: added try-with-resources
		try ( InputStream is = AESConstants.class.getResourceAsStream("/authentication.properties") ) {
			properties.load(is);
		} catch (IOException e) {
            logger.error("IOEXception occurred : {}", e.getMessage());
		}
		
		PasswordDTO passwordDTO = new PasswordDTO();
		String user = properties.getProperty("user.key");
		String share = properties.getProperty("share.key");
		String muse = properties.getProperty("defaultMuse.key");
		String fileSystemCacheConfigurator = properties.getProperty("fileSystemCacheConfigurator.key");
		String sqlCacheConnection = properties.getProperty("sqlCacheConnection.key");

		passwordDTO.setUserPassword(getUserPassword(user));
		passwordDTO.setShareUserPassword(getUserPassword(share));
		passwordDTO.setDefaultMusePassword(getUserPassword(muse));
		passwordDTO.setFileSystemCacheConfigurator(getUserPassword(fileSystemCacheConfigurator));
		passwordDTO.setSqlCacheConnectionPassword(getUserPassword(sqlCacheConnection));

		return passwordDTO;
	}

	private static String getUserPassword(String userPassword) throws CharacterCodingException {
		DefaultFieldEncryptor defaultFieldEncryptor = new DefaultFieldEncryptor();
		Charset charset = Charset.forName("UTF-8");
		CharsetDecoder decoder = charset.newDecoder();
		ByteBuffer userPassBuffer = ByteBuffer
				.wrap(defaultFieldEncryptor.decrypt(defaultFieldEncryptor.decode(userPassword)));
		CharBuffer userCharBuffer = decoder.decode(userPassBuffer);
		StringBuilder userPass = new StringBuilder(userCharBuffer);
		return userPass.toString();
	}
}
