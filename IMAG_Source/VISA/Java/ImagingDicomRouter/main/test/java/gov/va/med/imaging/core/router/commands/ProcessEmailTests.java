package gov.va.med.imaging.core.router.commands;

import java.util.ArrayList;
import java.util.Calendar;
import java.util.Iterator;

import org.junit.Test;

import com.thoughtworks.xstream.XStream;

import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.exchange.business.DurableQueue;
import gov.va.med.imaging.exchange.business.DurableQueueMessage;
import gov.va.med.imaging.exchange.business.QueuedEmailMessage;

public class ProcessEmailTests extends ImagingDicomRouterTestBase{

	/**
	 * @param arg0
	 */
	public ProcessEmailTests(String arg0) {
		super(arg0);
		
	}

	@Test
	public void testProcessEmailsSimpleTest() {
		MockProcessEmailQueueCommand mData = new MockProcessEmailQueueCommand();
		DurableQueue que = new DurableQueue(1, "Email", "EMAIL", true);
		ArrayList<DurableQueueMessage> list = populateListForSimpleTest(que);
		mData.setQue(que);
		mData.setList(list);
		try {
			mData.ProcessEmails();
			ArrayList<QueuedEmailMessage> messages = mData.getEmails();
			Iterator<QueuedEmailMessage> iter = messages.iterator();
			while(iter.hasNext()){
				QueuedEmailMessage sMsg = (QueuedEmailMessage)iter.next();
				assertEquals("Subject", sMsg.getSubjectLine());
				assertEquals("Body", sMsg.getMessageBody());
			}
			ArrayList<QueuedEmailMessage> requeuedMessages = mData.getRequeuedEmails();
			assertTrue(requeuedMessages.isEmpty());
		} catch (MethodException e) {
			e.printStackTrace();
			fail("Method Exception thrown.");
		} catch (ConnectionException e) {
			e.printStackTrace();
			fail("Connection Exception thrown.");
		}
	}
	
	@Test
	public void testProcessThreeDifferentEmails() {
		MockProcessEmailQueueCommand mData = new MockProcessEmailQueueCommand();
		DurableQueue que = new DurableQueue(1, "Email", "EMAIL", true);
		ArrayList<DurableQueueMessage> list = populateListForThreeDifferentEmails(que);
		mData.setQue(que);
		mData.setList(list);
		try {
			mData.ProcessEmails();
			ArrayList<QueuedEmailMessage> messages = mData.getEmails();
			QueuedEmailMessage sMsg1 = messages.get(0);
			assertEquals("Subject1", sMsg1.getSubjectLine());
			assertEquals("Body1", sMsg1.getMessageBody());
			QueuedEmailMessage sMsg2 = messages.get(1);
			assertEquals("Subject2", sMsg2.getSubjectLine());
			assertEquals("Body2", sMsg2.getMessageBody());
			QueuedEmailMessage sMsg3 = messages.get(2);
			assertEquals("Subject3", sMsg3.getSubjectLine());
			assertEquals("Body3", sMsg3.getMessageBody());

			ArrayList<QueuedEmailMessage> requeuedMessages = mData.getRequeuedEmails();
			assertTrue(requeuedMessages.isEmpty());
		} catch (MethodException e) {
			e.printStackTrace();
			fail("Method Exception thrown.");
		} catch (ConnectionException e) {
			e.printStackTrace();
			fail("Connection Exception thrown.");
		}
	}

	@Test
	public void testProcessThreeSameEmails() {
		MockProcessEmailQueueCommand mData = new MockProcessEmailQueueCommand();
		DurableQueue que = new DurableQueue(1, "Email", "EMAIL", true);
		ArrayList<DurableQueueMessage> list = populateListForThreeSameEmails(que);
		mData.setQue(que);
		mData.setList(list);
		try {
			mData.ProcessEmails();
			ArrayList<QueuedEmailMessage> messages = mData.getEmails();
			assertEquals(1, messages.size());
			
			QueuedEmailMessage sMsg1 = messages.get(0);
			assertEquals("Subject(Qty: 3)", sMsg1.getSubjectLine());
			assertEquals(3, sMsg1.getMessageCount());
			ArrayList<QueuedEmailMessage> requeuedMessages = mData.getRequeuedEmails();
			assertTrue(requeuedMessages.isEmpty());
		} catch (MethodException e) {
			e.printStackTrace();
			fail("Method Exception thrown.");
		} catch (ConnectionException e) {
			e.printStackTrace();
			fail("Connection Exception thrown.");
		}
	}

	@Test
	public void testProcessThreeSameDUPEmails() {
		MockProcessEmailQueueCommand mData = new MockProcessEmailQueueCommand();
		DurableQueue que = new DurableQueue(1, "Email", "EMAIL", true);
		ArrayList<DurableQueueMessage> list = populateListForThreeSameDUPEmails(que);
		mData.setQue(que);
		mData.setList(list);
		try {
			mData.ProcessEmails();
			ArrayList<QueuedEmailMessage> messages = mData.getEmails();
			assertTrue(messages.isEmpty());

			ArrayList<QueuedEmailMessage> requeuedMessages = mData.getRequeuedEmails();
			assertEquals(1, requeuedMessages.size());
			QueuedEmailMessage sMsg1 = requeuedMessages.get(0);
			assertEquals("DUP/Subject", sMsg1.getSubjectLine());
			assertEquals(3, sMsg1.getMessageCount());
		} catch (MethodException e) {
			e.printStackTrace();
			fail("Method Exception thrown.");
		} catch (ConnectionException e) {
			e.printStackTrace();
			fail("Connection Exception thrown.");
		}
	}

	@Test
	public void testProcessThreeSameIODEmails() {
		MockProcessEmailQueueCommand mData = new MockProcessEmailQueueCommand();
		DurableQueue que = new DurableQueue(1, "Email", "EMAIL", true);
		ArrayList<DurableQueueMessage> list = populateListForThreeSameIODEmails(que);
		mData.setQue(que);
		mData.setList(list);
		try {
			mData.ProcessEmails();
			ArrayList<QueuedEmailMessage> messages = mData.getEmails();
			assertTrue(messages.isEmpty());

			ArrayList<QueuedEmailMessage> requeuedMessages = mData.getRequeuedEmails();
			assertEquals(1, requeuedMessages.size());
			QueuedEmailMessage sMsg1 = requeuedMessages.get(0);
			assertEquals("Subject IOD Violation", sMsg1.getSubjectLine());
			assertEquals(3, sMsg1.getMessageCount());
		} catch (MethodException e) {
			e.printStackTrace();
			fail("Method Exception thrown.");
		} catch (ConnectionException e) {
			e.printStackTrace();
			fail("Connection Exception thrown.");
		}
	}
	
	@Test
	public void testProcessEmailsEmptyList() {
		MockProcessEmailQueueCommand mData = new MockProcessEmailQueueCommand();
		DurableQueue que = new DurableQueue(1, "Email", "EMAIL", true);
		ArrayList<DurableQueueMessage> list = populateListForEmptyList(que);
		mData.setQue(que);
		mData.setList(list);
		try {
			mData.ProcessEmails();
			ArrayList<QueuedEmailMessage> messages = mData.getEmails();
			assertTrue(messages.isEmpty());
			ArrayList<QueuedEmailMessage> requeuedMessages = mData.getRequeuedEmails();
			assertTrue(requeuedMessages.isEmpty());
		} catch (MethodException e) {
			e.printStackTrace();
			fail("Method Exception thrown.");
		} catch (ConnectionException e) {
			e.printStackTrace();
			fail("Connection Exception thrown.");
		}
	}
	
	@Test
	public void testProcessMoreThan25Emails() {
		MockProcessEmailQueueCommand mData = new MockProcessEmailQueueCommand();
		DurableQueue que = new DurableQueue(1, "Email", "EMAIL", true);
		ArrayList<DurableQueueMessage> list = populateListForMoreThan25Emails(que);
		mData.setQue(que);
		mData.setList(list);
		try {
			mData.ProcessEmails();
			ArrayList<QueuedEmailMessage> messages = mData.getEmails();
			assertEquals(1, messages.size());

			QueuedEmailMessage sMsg1 = messages.get(0);
			assertEquals(28, sMsg1.getMessageCount());
			assertEquals("Subject IOD Violation(Qty: 28)", sMsg1.getSubjectLine());
			ArrayList<QueuedEmailMessage> requeuedMessages = mData.getRequeuedEmails();
			assertTrue(requeuedMessages.isEmpty());
		} catch (MethodException e) {
			e.printStackTrace();
			fail("Method Exception thrown.");
		} catch (ConnectionException e) {
			e.printStackTrace();
			fail("Connection Exception thrown.");
		}
	}

	@Test
	public void testProcessDayOldEmails() {
		MockProcessEmailQueueCommand mData = new MockProcessEmailQueueCommand();
		DurableQueue que = new DurableQueue(1, "Email", "EMAIL", true);
		ArrayList<DurableQueueMessage> list = populateListPastDayEmails(que);
		mData.setQue(que);
		mData.setList(list);
		try {
			mData.ProcessEmails();
			ArrayList<QueuedEmailMessage> messages = mData.getEmails();
			assertEquals(1, messages.size());
			QueuedEmailMessage sMsg1 = messages.get(0);
			assertEquals(3, sMsg1.getMessageCount());
			assertEquals("DUP/Subject(Qty: 3)", sMsg1.getSubjectLine());
			ArrayList<QueuedEmailMessage> requeuedMessages = mData.getRequeuedEmails();
			assertTrue(requeuedMessages.isEmpty());
		} catch (MethodException e) {
			e.printStackTrace();
			fail("Method Exception thrown.");
		} catch (ConnectionException e) {
			e.printStackTrace();
			fail("Connection Exception thrown.");
		}
	}
	
	@Test
	public void testProcessEmailsWithLowCountFirstInQueue() {
		MockProcessEmailQueueCommand mData = new MockProcessEmailQueueCommand();
		DurableQueue que = new DurableQueue(1, "Email", "EMAIL", true);
		ArrayList<DurableQueueMessage> list = populateListEmailsWithLowCountObjFirstInQueue(que);
		mData.setQue(que);
		mData.setList(list);
		try {
			mData.ProcessEmails();
			ArrayList<QueuedEmailMessage> messages = mData.getEmails();
			assertTrue(messages.isEmpty());

			ArrayList<QueuedEmailMessage> requeuedMessages = mData.getRequeuedEmails();
			assertEquals(1, requeuedMessages.size());
			QueuedEmailMessage sMsg1 = requeuedMessages.get(0);
			assertEquals(16, sMsg1.getMessageCount());
			assertEquals("Subject IOD Violation", sMsg1.getSubjectLine());
		} catch (MethodException e) {
			e.printStackTrace();
			fail("Method Exception thrown.");
		} catch (ConnectionException e) {
			e.printStackTrace();
			fail("Connection Exception thrown.");
		}
	}



	private ArrayList<DurableQueueMessage> populateListForSimpleTest(DurableQueue que){
		ArrayList<DurableQueueMessage> list = new ArrayList<DurableQueueMessage>();
		String[] sendto = new String[1];
		sendto[0] = "test@test.gov";
		QueuedEmailMessage queuedEmail = new QueuedEmailMessage(sendto, "Subject", "Body");
		String sEmail = serializeUsingXStream(queuedEmail);
		DurableQueueMessage message = new DurableQueueMessage(que, "test", sEmail);
		list.add(message);
		return list;
	}

	private ArrayList<DurableQueueMessage> populateListForThreeDifferentEmails(DurableQueue que){
		ArrayList<DurableQueueMessage> list = new ArrayList<DurableQueueMessage>();
    	Calendar now = Calendar.getInstance();
		String[] sendto = new String[1];
		sendto[0] = "test@test.gov";
		QueuedEmailMessage queuedEmail1 = new QueuedEmailMessage(sendto, "Subject1", "Body1");
		queuedEmail1.setDateTimePosted(now);
		String sEmail1 = serializeUsingXStream(queuedEmail1);
		DurableQueueMessage message1 = new DurableQueueMessage(que, "test", sEmail1);
		list.add(message1);

		QueuedEmailMessage queuedEmail2 = new QueuedEmailMessage(sendto, "Subject2", "Body2");
		queuedEmail2.setDateTimePosted(now);
		String sEmail2 = serializeUsingXStream(queuedEmail2);
		DurableQueueMessage message2 = new DurableQueueMessage(que, "test", sEmail2);
		list.add(message2);

		QueuedEmailMessage queuedEmail3 = new QueuedEmailMessage(sendto, "Subject3", "Body3");
		queuedEmail3.setDateTimePosted(now);
		String sEmail3 = serializeUsingXStream(queuedEmail3);
		DurableQueueMessage message3 = new DurableQueueMessage(que, "test", sEmail3);
		list.add(message3);

		return list;
	}

	private ArrayList<DurableQueueMessage> populateListForThreeSameEmails(DurableQueue que){
		ArrayList<DurableQueueMessage> list = new ArrayList<DurableQueueMessage>();
    	Calendar now = Calendar.getInstance();
		String[] sendto = new String[1];
		sendto[0] = "test@test.gov";
		QueuedEmailMessage queuedEmail1 = new QueuedEmailMessage(sendto, "Subject", "Body1");
		queuedEmail1.setDateTimePosted(now);
		String sEmail1 = serializeUsingXStream(queuedEmail1);
		DurableQueueMessage message1 = new DurableQueueMessage(que, "test", sEmail1);
		list.add(message1);

		QueuedEmailMessage queuedEmail2 = new QueuedEmailMessage(sendto, "Subject", "Body2");
		queuedEmail2.setDateTimePosted(now);
		String sEmail2 = serializeUsingXStream(queuedEmail2);
		DurableQueueMessage message2 = new DurableQueueMessage(que, "test", sEmail2);
		list.add(message2);

		QueuedEmailMessage queuedEmail3 = new QueuedEmailMessage(sendto, "Subject", "Body3");
		queuedEmail3.setDateTimePosted(now);
		String sEmail3 = serializeUsingXStream(queuedEmail3);
		DurableQueueMessage message3 = new DurableQueueMessage(que, "test", sEmail3);
		list.add(message3);

		return list;
	}

	
	private ArrayList<DurableQueueMessage> populateListForThreeSameDUPEmails(DurableQueue que){
		ArrayList<DurableQueueMessage> list = new ArrayList<DurableQueueMessage>();
    	Calendar now = Calendar.getInstance();
		String[] sendto = new String[1];
		sendto[0] = "test@test.gov";
		QueuedEmailMessage queuedEmail1 = new QueuedEmailMessage(sendto, "DUP/Subject", "Body1");
		queuedEmail1.setDateTimePosted(now);
		String sEmail1 = serializeUsingXStream(queuedEmail1);
		DurableQueueMessage message1 = new DurableQueueMessage(que, "test", sEmail1);
		list.add(message1);

		QueuedEmailMessage queuedEmail2 = new QueuedEmailMessage(sendto, "DUP/Subject", "Body2");
		queuedEmail2.setDateTimePosted(now);
		String sEmail2 = serializeUsingXStream(queuedEmail2);
		DurableQueueMessage message2 = new DurableQueueMessage(que, "test", sEmail2);
		list.add(message2);

		QueuedEmailMessage queuedEmail3 = new QueuedEmailMessage(sendto, "DUP/Subject", "Body3");
		queuedEmail3.setDateTimePosted(now);
		String sEmail3 = serializeUsingXStream(queuedEmail3);
		DurableQueueMessage message3 = new DurableQueueMessage(que, "test", sEmail3);
		list.add(message3);

		return list;
	}
	
	private ArrayList<DurableQueueMessage> populateListForThreeSameIODEmails(DurableQueue que){
		ArrayList<DurableQueueMessage> list = new ArrayList<DurableQueueMessage>();
    	Calendar now = Calendar.getInstance();
		String[] sendto = new String[1];
		sendto[0] = "test@test.gov";
		QueuedEmailMessage queuedEmail1 = new QueuedEmailMessage(sendto, "Subject IOD Violation", "Body1");
		queuedEmail1.setDateTimePosted(now);
		String sEmail1 = serializeUsingXStream(queuedEmail1);
		DurableQueueMessage message1 = new DurableQueueMessage(que, "test", sEmail1);
		list.add(message1);

		QueuedEmailMessage queuedEmail2 = new QueuedEmailMessage(sendto, "Subject IOD Violation", "Body2");
		queuedEmail2.setDateTimePosted(now);
		String sEmail2 = serializeUsingXStream(queuedEmail2);
		DurableQueueMessage message2 = new DurableQueueMessage(que, "test", sEmail2);
		list.add(message2);

		QueuedEmailMessage queuedEmail3 = new QueuedEmailMessage(sendto, "Subject IOD Violation", "Body3");
		queuedEmail3.setDateTimePosted(now);
		String sEmail3 = serializeUsingXStream(queuedEmail3);
		DurableQueueMessage message3 = new DurableQueueMessage(que, "test", sEmail3);
		list.add(message3);

		return list;
	}
	
	private ArrayList<DurableQueueMessage> populateListForEmptyList(DurableQueue que){
		ArrayList<DurableQueueMessage> list = new ArrayList<DurableQueueMessage>();
		return list;
	}

	private ArrayList<DurableQueueMessage> populateListForMoreThan25Emails(DurableQueue que){
		ArrayList<DurableQueueMessage> list = new ArrayList<DurableQueueMessage>();
    	Calendar now = Calendar.getInstance();
		String[] sendto = new String[1];
		sendto[0] = "test@test.gov";
		QueuedEmailMessage queuedEmail1 = new QueuedEmailMessage(sendto, "Subject IOD Violation", "Body1");
		queuedEmail1.setDateTimePosted(now);
		queuedEmail1.setMessageCount(26);
		String sEmail1 = serializeUsingXStream(queuedEmail1);
		DurableQueueMessage message1 = new DurableQueueMessage(que, "test", sEmail1);
		list.add(message1);

		QueuedEmailMessage queuedEmail2 = new QueuedEmailMessage(sendto, "Subject IOD Violation", "Body2");
		queuedEmail2.setDateTimePosted(now);
		String sEmail2 = serializeUsingXStream(queuedEmail2);
		DurableQueueMessage message2 = new DurableQueueMessage(que, "test", sEmail2);
		list.add(message2);

		QueuedEmailMessage queuedEmail3 = new QueuedEmailMessage(sendto, "Subject IOD Violation", "Body3");
		queuedEmail3.setDateTimePosted(now);
		String sEmail3 = serializeUsingXStream(queuedEmail3);
		DurableQueueMessage message3 = new DurableQueueMessage(que, "test", sEmail3);
		list.add(message3);

		return list;
	}
	
	private ArrayList<DurableQueueMessage> populateListPastDayEmails(DurableQueue que){
		ArrayList<DurableQueueMessage> list = new ArrayList<DurableQueueMessage>();
    	Calendar now = Calendar.getInstance();
    	now.add(Calendar.DAY_OF_YEAR, -1);
    	
		String[] sendto = new String[1];
		sendto[0] = "test@test.gov";
		QueuedEmailMessage queuedEmail1 = new QueuedEmailMessage(sendto, "DUP/Subject", "Body1");
		queuedEmail1.setDateTimePosted(now);
		String sEmail1 = serializeUsingXStream(queuedEmail1);
		DurableQueueMessage message1 = new DurableQueueMessage(que, "test", sEmail1);
		list.add(message1);

		QueuedEmailMessage queuedEmail2 = new QueuedEmailMessage(sendto, "DUP/Subject", "Body2");
		queuedEmail2.setDateTimePosted(now);
		String sEmail2 = serializeUsingXStream(queuedEmail2);
		DurableQueueMessage message2 = new DurableQueueMessage(que, "test", sEmail2);
		list.add(message2);

		QueuedEmailMessage queuedEmail3 = new QueuedEmailMessage(sendto, "DUP/Subject", "Body3");
		queuedEmail3.setDateTimePosted(now);
		String sEmail3 = serializeUsingXStream(queuedEmail3);
		DurableQueueMessage message3 = new DurableQueueMessage(que, "test", sEmail3);
		list.add(message3);

		return list;
	}
	
	private ArrayList<DurableQueueMessage> populateListEmailsWithLowCountObjFirstInQueue(DurableQueue que){
		ArrayList<DurableQueueMessage> list = new ArrayList<DurableQueueMessage>();
    	Calendar now = Calendar.getInstance();
		String[] sendto = new String[1];
		sendto[0] = "test@test.gov";
		QueuedEmailMessage queuedEmail1 = new QueuedEmailMessage(sendto, "Subject IOD Violation", "Body1");
		queuedEmail1.setDateTimePosted(now);
		String sEmail1 = serializeUsingXStream(queuedEmail1);
		DurableQueueMessage message1 = new DurableQueueMessage(que, "test", sEmail1);
		list.add(message1);

		QueuedEmailMessage queuedEmail2 = new QueuedEmailMessage(sendto, "Subject IOD Violation", "Body2");
		queuedEmail2.setDateTimePosted(now);
		String sEmail2 = serializeUsingXStream(queuedEmail2);
		DurableQueueMessage message2 = new DurableQueueMessage(que, "test", sEmail2);
		list.add(message2);

		QueuedEmailMessage queuedEmail3 = new QueuedEmailMessage(sendto, "Subject IOD Violation", "Body3");
		queuedEmail3.setDateTimePosted(now);
		queuedEmail3.setMessageCount(14);
		String sEmail3 = serializeUsingXStream(queuedEmail3);
		DurableQueueMessage message3 = new DurableQueueMessage(que, "test", sEmail3);
		list.add(message3);

		return list;
	}

	private String serializeUsingXStream(QueuedEmailMessage emailMessage){
		XStream xstream = new XStream();
		return xstream.toXML(emailMessage);
	}
}
