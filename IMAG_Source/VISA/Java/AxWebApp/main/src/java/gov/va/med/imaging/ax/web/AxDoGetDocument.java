package gov.va.med.imaging.ax.web;

import java.io.IOException;
import java.io.OutputStream;
import java.util.ArrayList;
import java.util.List;
// import java.util.StringTokenizer;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.ws.rs.WebApplicationException;
import javax.ws.rs.core.StreamingOutput;

import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.exchange.enums.ImageFormat;

/**
 * @author vacotittoc
 *
 */
public class AxDoGetDocument
extends AbstractAxDoGetDocument
{
	private static final long serialVersionUID = 1746653124236216680L;
	private String documentURN;
	private HttpServletRequest request;
	private HttpServletResponse response;
	//private OutputStream outStream = null;
	
	public AxDoGetDocument() 
	{
		
	}
	
	public AxDoGetDocument(String documentURN, HttpServletRequest request, HttpServletResponse response) 
	{
		super();
		this.documentURN = documentURN;
		this.request = request;
		this.response = response;
	}

	public StreamingOutput streamDocument(HttpServletRequest req, HttpServletResponse resp,
			String documentURN)
		{
			StreamingOutput stream = new StreamingOutput() {
				@Override
				public void write(OutputStream outputStream) throws WebApplicationException, IOException {
					try {
						doGet(request, response);
						// pipe(...); // ???
					} catch (ServletException e) {
						// TODO Auto-generated catch block
						e.printStackTrace();
					} catch (IOException e) {
						// TODO Auto-generated catch block
						e.printStackTrace();
					}
				}
			};
		return stream;
	}

	public String getDocumentURN() {
		return documentURN;
	}

	
	public OutputStream getOutputStream()
		throws IOException
	{
		return response.getOutputStream();
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.mix.web.AbstractMIXDoImage#isBadContentType()
	 */
	protected boolean isBadContentType(HttpServletRequest request)
	{
//		String contentType = request.getParameter("contentType");
//		return ((contentType == null) || (contentType.length() == 0) || (!contentType.contains(applicationDicomJp2)));
		return false;
	}
	
	/* (non-Javadoc)
	 * @see gov.va.med.imaging.mix.web.AbstractMIXImageServlet#getAcceptableResponseContent()
	 */
	protected List<ImageFormat> getAcceptableResponseContent(HttpServletRequest request)
	throws MethodException
	{
		List<ImageFormat> acceptableResponseContent = new ArrayList<ImageFormat>();		
		acceptableResponseContent.add(ImageFormat.DICOMJPEG2000);
		
		return acceptableResponseContent;
	}
	
	/* (non-Javadoc)
	 * @see gov.va.med.imaging.mix.web.AbstractMIXImageServlet#getOperationName()
	 */
	@Override
	protected String getOperationName()
	{
		return "retrieveInstance"; // results in retrieveInstance in URL path...
	}
}

