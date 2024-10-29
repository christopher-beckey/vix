package gov.va.med.imaging.test.presentation.state.datasource;

import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.presentation.state.PresentationStateRecord;
import gov.va.med.imaging.presentation.state.datasource.VistaImagingPresentationStateTranslator;

import java.util.List;

import junit.framework.TestCase;

import org.junit.After;
import org.junit.Before;
import org.junit.Test;


public class PSTranslatorTests extends TestCase{

	@Before
	public void setUp() throws Exception {
	}

	@After
	public void tearDown() throws Exception {
	}

	@Test
	public void testTranslatePSRecord1() {
		
		List<PresentationStateRecord> records = null;
		String result = "0^^11\r\nIEN^STUDY\r\n1^1.2.840.113754.1.4.1.6829771.8349.1.22817.4^1.2.840.113754.1.4.1.6829771.8349.1.22817.4\r\nANNOTATION GROUP000^IEN^PSTATEUID^ANNOTATOR^SAVED DATE/TIME^VERSION^SOURCE^DELETED^SERVICE^SITE^ANNOTATION NAME\r\nANNOTATION GROUP001^1^1.3.46.2424242424.26.43002.2.20170504.212345.333^1.3.46.2424242424.26.43002.2.20170504.212345.333^63^FRANK,STUART^3170504.202701^MAY 04, 2017@20:27:01^^^VIX IMAGE TEST VIEWER^VIX IMAGE TEST VIEWER^^^IRM^^1^SOFTWARE SERVICE^PRESENTATION STATE TEST FOUR^PRESENTATION STATE TEST FOUR\r\nPRESENTATION001^[!CDATA[%3C%3Fxml+version%3D%221.0%22+encoding%3D%22utf-8%22%3F%3E%0D%0A%3CAppDrv%3E%0D%0A%3CType%3EAPP%3C%2FType%3E%0D%0A%3CFolder%3E%3C%2FFolder%3E%0D%0A%3CDesc%3EDell+Update%3C%2FDesc%3E%0D%0A%3CLaunchProcess%3EDellUpdate.1.6.1\r\nPRESENTATION002^007.0.msi%3C%2FLaunchProcess%3E%0D%0A%3CArchiveLimit%3E0%3C%2FArchiveLimit%3E%0D%0A%3CClearContent%3EN%3C%2FClearContent%3E%0D%0A%3CVersion%3E1.6.1007.0%3C%2FVersion%3E%0D%0A%3CIcoLocation%3Ednd.ico%3C%2FIcoLocation%3E%0D%0A%3C%2F\r\nPRESENTATION003^AppDrv%3E%0D%0A]]\r\nANNOTATION GROUP002^2^1.3.46.52525252525.26.43002.2.20170504.212345.555^1.3.46.52525252525.26.43002.2.20170504.212345.555^63^FRANK,STUART^3170504.203529^MAY 04, 2017@20:35:29^^^VIX IMAGE TEST VIEWER^VIX IMAGE TEST VIEWER^^^IRM^^1^SOFTWARE SERVICE^PRESENTATION STATE TEST FIVE^PRESENTATION STATE TEST FIVE\r\nPRESENTATION001^[!CDATA[%3C%3Fxml+version%3D%221.0%22+encoding%3D%22utf-8%22%3F%3E%0D%0A%3CAppDrv%3E%0D%0A%3CType%3EAPP%3C%2FType%3E%0D%0A%3CFolder%3E%3C%2FFolder%3E%0D%0A%3CDesc%3EDell+Update%3C%2FDesc%3E%0D%0A%3CLaunchProcess%3EDellUpdate.1.6.1\r\nPRESENTATION002^007.0.msi%3C%2FLaunchProcess%3E%0D%0A%3CArchiveLimit%3E0%3C%2FArchiveLimit%3E%0D%0A%3CClearContent%3EN%3C%2FClearContent%3E%0D%0A%3CVersion%3E1.6.1007.0%3C%2FVersion%3E%0D%0A%3CIcoLocation%3Ednd.ico%3C%2FIcoLocation%3E%0D%0A%3C%2F\r\nPRESENTATION003^AppDrv%3E%0D%0A]]";
		try {
			records = VistaImagingPresentationStateTranslator.translatePSRecords(result);
		} catch (MethodException e) {
			fail();
		}
		
		assertTrue(records.size() == 2);
		
		
	}
}
