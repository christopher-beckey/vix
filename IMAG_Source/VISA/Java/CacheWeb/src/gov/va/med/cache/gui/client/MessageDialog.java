package gov.va.med.cache.gui.client;

import com.google.gwt.core.client.Scheduler;
import com.google.gwt.event.dom.client.ClickEvent;
import com.google.gwt.event.dom.client.ClickHandler;
import com.google.gwt.user.client.DOM;
import com.google.gwt.user.client.ui.Button;
import com.google.gwt.user.client.ui.DialogBox;
import com.google.gwt.user.client.ui.HTML;
import com.google.gwt.user.client.ui.VerticalPanel;
import com.google.gwt.user.client.ui.Widget;

/**
 * @see http://code.google.com/p/where-i-was/source/browse/trunk/where-i-was/src/org/wiw/client/gui/MessageDialog.java?r=3
 *
 */
public class MessageDialog extends DialogBox
{
	public enum Type
	{
		INFORMATION, WARNING, ERROR
	};
	
	protected Button closeButton;

	/**
	 * 
	 * @param title
	 * @param w
	 * @param type
	 */
	private MessageDialog(String title, Widget w, Type type)
	{
		super();
		setText(title);
		setModal(true);

		VerticalPanel panel = new VerticalPanel();
		panel.getElement().setId(DOM.createUniqueId());
		add(panel);

		if (type == Type.ERROR)
			w.addStyleName("dialogError");
		else if (type == Type.WARNING)
			w.addStyleName("dialogWarning");
		else if (type == Type.INFORMATION)
			w.addStyleName("dialogInformation");

		panel.add(w);
		
		closeButton = new Button("Close", new ClickHandler()
		{
			@Override
			public void onClick(ClickEvent event)
			{
				hide();
			}
		});
		
		// implement ARIA info
		this.getElement().setAttribute("role", "alertdialog");
		this.getElement().setAttribute("aria-describedby", panel.getElement().getId());

		panel.add(closeButton);
	}

	@Override
	public void show() {
		super.show();

		Scheduler.get().scheduleDeferred(new Scheduler.ScheduledCommand () {
	        public void execute () {
	        	closeButton.setFocus(true);
	        }
	    });
	}

	public static MessageDialog showDialog(String title, Widget w, Type type)
	{
		MessageDialog messageDialog = new MessageDialog(title, w, type);
		messageDialog.center();
		return messageDialog;
	}

	public static MessageDialog showInformationDialog(String title, String message)
	{
		return showDialog(title, new HTML(message), Type.INFORMATION);
	}

	public static MessageDialog showWarningDialog(String title, String message)
	{
		return showDialog(title, new HTML(message), Type.WARNING);
	}
	
	public static MessageDialog showErrorDialog(String title, String message)
	{
		return showDialog(title, new HTML(message), Type.ERROR);
	}
}