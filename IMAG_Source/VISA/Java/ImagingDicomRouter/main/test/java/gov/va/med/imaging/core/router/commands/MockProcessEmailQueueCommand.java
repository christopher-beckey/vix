package gov.va.med.imaging.core.router.commands;

import java.util.ArrayList;

import gov.va.med.RoutingToken;
import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.exchange.business.DurableQueue;
import gov.va.med.imaging.exchange.business.DurableQueueMessage;
import gov.va.med.imaging.exchange.business.QueuedEmailMessage;

public class MockProcessEmailQueueCommand extends ProcessEmailQueueCommandImpl {

	/**
	 * 
	 */
	private static final long serialVersionUID = -1687411503855656969L;
	private ArrayList<DurableQueueMessage> list = null;
	private ArrayList<QueuedEmailMessage> emails = null;
	private DurableQueue que = null;
	private ArrayList<QueuedEmailMessage> requeuedEmails = null;
	private int index;
	
	
	public MockProcessEmailQueueCommand() {
		list = new ArrayList<DurableQueueMessage>();
		emails = new ArrayList<QueuedEmailMessage>();
		requeuedEmails = new ArrayList<QueuedEmailMessage>();
		index = 0;
	}

	@Override
	protected Boolean requeue(RoutingToken routingToken, DurableQueue queue,
			String msgGroupID, QueuedEmailMessage queuedEmail, Boolean doCount)
			throws ConnectionException, MethodException {
		requeuedEmails.add(queuedEmail);
		return true;
	}

	@Override
	protected void sendMail(QueuedEmailMessage emailMessage) {
		emails.add(emailMessage);
	}

	@Override
	protected DurableQueue getEmailQueue() throws ConnectionException,
			MethodException {
		return que;
	}

	@Override
	protected DurableQueueMessage getQueueMessage(RoutingToken routingToken,
			DurableQueue queue, String msgGroupID) throws MethodException,
			ConnectionException {
		if(list.size() > index){
			DurableQueueMessage queMessage = list.get(index);
			index++;
			return queMessage;
		}
		else{
			return null;
		}
	}

	public ArrayList<QueuedEmailMessage> getEmails() {
		return emails;
	}

	public ArrayList<QueuedEmailMessage> getRequeuedEmails() {
		return requeuedEmails;
	}

	public void setList(ArrayList<DurableQueueMessage> list) {
		this.list = list;
	}

	public void setQue(DurableQueue que) {
		this.que = que;
	}
	
	
	
}
