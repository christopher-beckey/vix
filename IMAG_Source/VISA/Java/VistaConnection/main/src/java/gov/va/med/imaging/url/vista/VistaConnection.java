/**
 *
 */
package gov.va.med.imaging.url.vista;

import java.io.BufferedInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.io.OutputStreamWriter;
import java.io.Writer;
import java.net.InetAddress;
import java.net.MalformedURLException;
import java.net.ServerSocket;
import java.net.Socket;
import java.net.URL;
import java.net.URLConnection;
import java.net.UnknownServiceException;
import java.util.Collections;
import java.util.HashSet;
import java.util.Iterator;
import java.util.Set;
import java.util.Timer;
import java.util.TimerTask;
import java.util.concurrent.TimeUnit;
import java.util.concurrent.locks.ReentrantLock;

import gov.va.med.logging.Logger;

import gov.va.med.imaging.url.vista.configuration.VistaConnectionConfiguration;
import gov.va.med.imaging.url.vista.enums.VistaConnectionType;
import gov.va.med.imaging.url.vista.exceptions.InvalidVistaCredentialsException;
import gov.va.med.imaging.url.vista.exceptions.VistaBrokerConnectionStyleException;
import gov.va.med.imaging.url.vista.exceptions.VistaIOException;
import gov.va.med.imaging.url.vista.exceptions.VistaMException;
import gov.va.med.imaging.url.vista.exceptions.VistaMethodException;


/**
 * Package: MAG - VistA Imaging
 * WARNING: Per VHA Directive 2004-038, this routine should not be modified.
 * Date Created: 07Jan2008
 * Site Name:  Washington OI Field Office, Silver Spring, MD
 * @author VHAISWBECKEC
 * @version 1.0
 *
 * The URLConnection derived class that is the representation of a
 * connection to a Vista server. The URL must begin with "vista", the host must
 * be specified, the port is optional. Any path information is ignored.
 *
 * Quoted comments in this code come from:
 * @see http://java.sun.com/developer/onlineTraining/protocolhandlers/
 *
 * "The handler's openConnection() method is called directly by the URL class
 * openStream() implementation. An openConnection() call is a request to the
 * handler that it create an object that can resolve the URL into a resource
 * stream. The URLConnection object is that object. The name, URLConnection,
 * indicates that the java.net.URL architecture developers expected the only way
 * to resolve a URL object into a stream is actually to open a connection to
 * some server, like an HTTP or an FTP server."
 *
 */
public class VistaConnection
		extends URLConnection
{
	/**
	 * Default value for the maximum time to wait during the disconnect conversation.
	 */
	private static final long DEFAULT_DISCONNECT_READ_TIMEOUT = 60000L;
	private static final long DEFAULT_CONNECT_READ_TIMEOUT = 60000L;
	private static final long DEFAULT_CALL_READ_TIMEOUT = 120000L;

	/**
	 * The polling interval for all read() operations that have a timeout specified.
	 */
	private static final long DEFAULT_READ_POLLING_INTERVAL = 10L;

	/**
	 * The delay and polling period of the disconnect thread
	 */
	private static final int DISCONNECT_TIMER_PERIOD = 10000;
	private static final int DISCONNECT_TIMER_DELAY = 30000;
	public static final int DEFAULT_PORT = 9200;
	public static final int DEFAULT_SOCKET_TIMEOUT = 180000;
	public static final int DEFAULT_CONNECTION_SOCKET_TIMEOUT = 20000;

	private final static int countWidth = 3;

	private static final boolean DEFAULT_NEW_STYLE_CONNNECTION_STYLE_ENABLED = false;
	private static final boolean DEFAULT_OLD_STYLE_CONNNECTION_STYLE_ENABLED = true;

	// this object is used strictly for synchronization so that multiple
	// connect()
	// methods do not happen simultaneously, which seems to confuse Vista
	private static ReentrantLock connectionSynchronizationLock = new ReentrantLock();
	private long connectSynchronizationMaxWait = 10000L;

	private static Set<VistaConnection> disconnectRequests =
			Collections.synchronizedSet( new HashSet<VistaConnection>() );
	private static Timer disconnectTimer;
	static
	{
		disconnectTimer = new Timer("VistaConnectionDisconnect", true);
		disconnectTimer.schedule(
				new TimerTask()
				{
					@Override
					public void run()
					{
						disconnectExpiredConnections();
					}

					// if we are canceled then assure that the connections waiting to close are closed.
					@Override
					public boolean cancel()
					{
						disconnectExpiredConnections();
						return super.cancel();
					}

					/**
					 *
					 */
					private void disconnectExpiredConnections()
					{
						Set<VistaConnection> disconnectThisIteration;

						// copy the disconnect requests and work from the copy
						// this will free the disconnectRequests set for other threads
						synchronized(disconnectRequests)
						{
							disconnectThisIteration = new HashSet<VistaConnection>(disconnectRequests);
							disconnectRequests.clear();
						}
						try
						{
							for(
									Iterator<VistaConnection> disconnectRequestIter = disconnectThisIteration.iterator();
									disconnectRequestIter.hasNext(); )
							{
								VistaConnection disconnectingConnection = disconnectRequestIter.next();
								try
								{
									disconnectingConnection.internalDisconnect();
									disconnectRequestIter.remove();
								}
								catch(Throwable t)		// since this thread is the only way the connections get disconnected
								// it must stay running
								{
									logger.error(t.getMessage());
								}
							}
						}
						catch(Throwable t2)		// since this thread is the only way the connections get disconnected ...
						{
							logger.error(t2.getMessage());
						}
					}
				}, DISCONNECT_TIMER_DELAY, DISCONNECT_TIMER_PERIOD);
	}

	// =====================================================================================
	// Instance Fields and Methods
	// =====================================================================================

	private transient Socket transactionSocket;	// the socket that the method calls will go across
	private final long createTime;		// the time that the connection was created
	private long connectTime;			// the time that the connection was opened
	private String connectingThreadName;	// the thread name that initialized the connection
	private StackTraceElement[] connectingStackTrace = null;	// a stack trace at connect time (for tracing unclosed connections)

	//private transient Logger logger = Logger.getLogger(VistaConnection.class.getName());
	private final static Logger logger = Logger.getLogger(VistaConnection.class);

	private boolean prohibitUnexpectedResponder = false;	// if true then the responding IP must match the called IP
	private VistaConnectionType vistaConnectionType = VistaConnectionType.newStyle;
	private long pollingInterval = DEFAULT_READ_POLLING_INTERVAL;		// milliseconds to sleep when waiting for a read
	private long connectReadTimeout = DEFAULT_CONNECT_READ_TIMEOUT;	// milliseconds to wait for a response from VistA when opening a connection
	private long callReadTimeout = DEFAULT_CALL_READ_TIMEOUT;	// milliseconds to wait for a response from VistA when doing an RPC call
	private long disconnectReadTimeout = DEFAULT_DISCONNECT_READ_TIMEOUT;	// milliseconds to wait for a response from VistA when closing a connection

	private final boolean newStyleConnectionEnabled;
	private final boolean oldStyleConnectionEnabled;

	private boolean failedCall = false;


	@Override
	protected void finalize() throws Throwable {
		super.finalize();

		try{ if(transactionSocket != null) { transactionSocket.close(); } } catch(Exception exc) {/*unrecoverable so do nothing*/}
	}

	/**
	 * Create a VistaConnection instance, set the URLConnection properties to indicate that this
	 * connection does input and output.
	 *
	 * @param url
	 */
	public VistaConnection(URL url)
	{
		super(url);
		setDoInput(true);
		setDoOutput(true);
		setUseCaches(false);

		Long connectionReadTimeoutValue = getVistaConnectionConfiguration().getConnectReadTimeout();
		setConnectReadTimeout(connectionReadTimeoutValue != null ? connectionReadTimeoutValue : DEFAULT_CONNECT_READ_TIMEOUT );

		Long callReadTimeoutValue = getVistaConnectionConfiguration().getCallReadTimeout();
		setCallReadTimeout(callReadTimeoutValue != null ? callReadTimeoutValue : DEFAULT_CALL_READ_TIMEOUT );

		Long disconnectReadTimeoutValue = getVistaConnectionConfiguration().getDisconnectReadTimeout();
		setDisconnectReadTimeout(disconnectReadTimeoutValue != null ? disconnectReadTimeoutValue : DEFAULT_DISCONNECT_READ_TIMEOUT );

		Boolean newStyleConnectionValue = getVistaConnectionConfiguration().getNewStyleLoginEnabled();
		newStyleConnectionEnabled = (newStyleConnectionValue != null ? newStyleConnectionValue : DEFAULT_NEW_STYLE_CONNNECTION_STYLE_ENABLED);

		Boolean oldStyleConnectionValue = getVistaConnectionConfiguration().getOldStyleLoginEnabled();
		oldStyleConnectionEnabled = (oldStyleConnectionValue != null ? oldStyleConnectionValue : DEFAULT_OLD_STYLE_CONNNECTION_STYLE_ENABLED);

		Long readPollingIntervalValue = getVistaConnectionConfiguration().getReadPollingInterval();
		setPollingInterval(readPollingIntervalValue != null ? readPollingIntervalValue : DEFAULT_READ_POLLING_INTERVAL);

		this.createTime = System.currentTimeMillis();
	}

	/**
	 * @return
	 */
	long getPollingInterval()
	{
		return pollingInterval;
	}

	/**
	 * NOTE: the polling interval cannot be set to less than 10 milliseconds
	 * @param pollingInterval
	 */
	void setPollingInterval(long pollingInterval)
	{
		this.pollingInterval = Math.max(10, pollingInterval);
	}

	/**
	 * @return
	 */
	public long getConnectReadTimeout()
	{
		return connectReadTimeout;
	}
	public void setConnectReadTimeout(long connectReadDelay)
	{
		this.connectReadTimeout = connectReadDelay >= 0 ? connectReadDelay : 0L;
	}

	public long getCallReadTimeout()
	{
		return callReadTimeout;
	}
	public void setCallReadTimeout(long callReadDelay)
	{
		this.callReadTimeout = callReadDelay >= 0 ? callReadDelay : 0L;
	}

	public long getDisconnectReadTimeout()
	{
		return disconnectReadTimeout;
	}
	public void setDisconnectReadTimeout(long disconnectReadDelay)
	{
		this.disconnectReadTimeout = disconnectReadDelay >= 0 ? disconnectReadDelay : 0L;
	}

	public long getCreateTime()
	{
		return createTime;
	}
	public long getConnectTime()
	{
		return connectTime;
	}
	public String getConnectingThreadName()
	{
		return connectingThreadName;
	}
	public StackTraceElement[] getConnectingStackTrace()
	{
		return connectingStackTrace;
	}

	// public void setRemoteFlag(boolean fRemote) {this.fRemote = fRemote;}
	// public boolean isRemote() {return fRemote;}

	/**
	 * @return the vistaConnectionType
	 */
	public VistaConnectionType getVistaConnectionType()
	{
		return vistaConnectionType;
	}

	/**
	 * Return true if connected, else return false.
	 * It is suggested that isConnected() always be used to evaluate
	 * the connection state except for internal methods that know
	 * how to deal with the asynchronous disconnect correctly.
	 */
	public boolean isConnected()
	{
		// Return true if the connection is connected and the connection is NOT
		// in the list to be disconnected asynchronously.
		return this.connected && !disconnectRequests.contains(this);
	}

	/**
	 * This method is synchronized on two semaphores:
	 * 1.) the first is its own, to prevent a disconnect from taking place during a connect
	 * and vice-versa, which would royally screw things up.
	 * 2.) the second is on a shared semaphore to prevent multiple threads from trying to
	 * connect at the same time, which Vista apparently does not tolerate with its usual
	 * good humor.
	 * Since we have two locks we need to be cognizant of potential deadlock scenario.  As of
	 * now there are none because the instance lock object is always acquired before the shared
	 * object.  Keep it that way.
	 *
	 * @throws  IOException
	 * @see java.net.URLConnection#connect()
	 */
	@Override
	public synchronized void connect()
			throws IOException
	{
		// is really connected
		if(isConnected())
		{
			logger.warn("VistaConnection.connect() called on a connected instance, ignoring ...");
			return;
		}

		synchronized(disconnectRequests)
		{
			// if the connection is waiting for an asynchronous disconnect
			// then just take it off the list to be disconnected and return.
			if(VistaConnection.disconnectRequests.contains(this))
			{
				logger.warn("VistaConnection.connect() called on a instance during asynchronous disconnect, recovering connection.");
				VistaConnection.disconnectRequests.remove(this);
				return;
			}
		}

		if(! this.notifyListenersBeforeOpen() )
		{
			logger.warn("VistaConnectionListener has returned false from connectionOpening() thereby preventing connection.");
			return;
		}

		if(newStyleConnectionEnabled)
		{
			try
			{
				newStyleConnect();
			}
			catch(VistaBrokerConnectionStyleException vbcsX)
			{
                logger.warn("Attempted to connect to remote site '{} with new connection style, falling back to old style: {}", getURL().toString(), vbcsX.getMessage());
				oldStyleConnect();
			}
		}
		else
		{
			oldStyleConnect();
		}
	}

	/**
	 * Vista has (had) a unique model for interaction.
	 * The initial connection to VistA is made on a well-known port, the first
	 * transaction includes a port number that will be used for all subsequent
	 * communication.  For this implementation the initial socket is done
	 * over the "connectionSocket" and subsequent transactions take place
	 * over the "transactionSocket".  The connectionSocket exists only for the
	 * time required to establish the connection.
	 * This code allows the OS to pick any open port for the responses.
	 * BTW, this opens up a security hole in that another host on the network
	 * could sniff, detect the receive port, and simply transmit responses
	 * before the real server.  At the very least this will break the clients
	 * but may actually be usable to display invalid information.
	 * Ironically, (rumor has it that) the reason that VistA uses a separate socket
	 * for the connection and the transactions is for ... security.
	 *
	 * @throws IOException
	 */
	private void oldStyleConnect()
			throws IOException
	{
		this.vistaConnectionType = VistaConnectionType.oldStyle;
		Socket connectionSocket = null;		// temporary socket used for initial VistA contact
		ServerSocket serverSocket = null;	// temporary server socket for VistA to contact us at

		// kludge alert!!!
		// synchronize on a static object to throttle the multiple
		// connect calls to Vista
		boolean connectSynchLockAcquired = false;
		try
		{
			connectSynchLockAcquired =
					connectionSynchronizationLock.tryLock(getConnectSynchronizationMaxWait(), TimeUnit.MILLISECONDS);
		}
		catch (InterruptedException e1)
		{
			String msg = "Failed to acquire connect synchronization lock, thread interruped while waiting.";
			logger.warn("Failed to acquire connect synchronization lock, thread interruped while waiting.");

			throw new IOException(msg);
		}

		URL url = this.getURL();

		try
		{
			if(!connectSynchLockAcquired)
				logger.warn("Failed to acquire connect synchronization lock in alloted time, proceeding anyway.");

			String hostname = url.getHost();
			if( hostname == null || hostname.length() == 0 )
				throw new MalformedURLException("No hostname provided when trying to connect.  This should never be seen.");

			int port = url.getPort();
			if (port == -1)
				port = DEFAULT_PORT;

			InetAddress localInetAddr = null;

			InetAddress vistaAddr = InetAddress.getByName(hostname);	// resolve the hostname to an IP address

            logger.info("Attempting connection to '{}({})'.", hostname, vistaAddr.getHostAddress());

			connectionSocket = new Socket(vistaAddr, port);		// creates and connects socket to remote host/port
			connectionSocket.setSoTimeout(DEFAULT_CONNECTION_SOCKET_TIMEOUT);
			// socket = new Socket(hostname,port);
			// @todo need to implement connect with IP address
			serverSocket = new ServerSocket(0);		// create a socket on any free port
			// this will become the transactionSocket
			// where all transactions after connect will occur

			// QN: based on the comment above, why is transactionSocket = connectionSocket below? Does it even work?
			// Pretty bad coding... Will fix what Fortify complained about

			serverSocket.setSoTimeout(DEFAULT_CONNECTION_SOCKET_TIMEOUT);
			localInetAddr = InetAddress.getLocalHost();

			// build a string that tells Vista which socket to send
			// messages to us on
			StringBuilder sb = new StringBuilder();
			sb.append("TCPconnect^");
			sb.append(localInetAddr.getHostAddress());				// our host address
			sb.append('^');
			sb.append(serverSocket.getLocalPort());					// the server socket that we just established and that VistA
			// should respond to us on
			sb.append('^');

			String responseMsg = null;
			String requestMsg = "{XWB}" + VistaQuery.strPack(sb.toString(), 5);

			// send the TCPConnect message to VistA and get the response
			transactionSocket = connectionSocket;			// temporarily set the transaction socket to be the same as the connection socket

			try
			{
				responseMsg = internalCall(requestMsg, getConnectReadTimeout());}	// skips sanity checking on connection state
			catch(IOException ioX)
			{
				try{ serverSocket.close(); } catch (IOException ioX2) {}	// eat exceptions, just close it
				throw ioX;
			}
			catch (InvalidVistaCredentialsException e)
			{
				try{serverSocket.close();}catch(IOException ioX2){}	// eat exceptions, just close it
				throw new IOException("Invalid security credentials: " + e.getMessage());
			}
			catch (VistaMethodException e)
			{
				try{serverSocket.close();}catch(IOException ioX2){}	// eat exceptions, just close it
				throw new IOException(e.getMessage());
			}
			finally
			{
				// immediately null this out, if we successfully connect
				// then transactionSocket is acquired from serverSocket, else we
				// do not want it connected or retained.
				transactionSocket = null;
			}

			try
			{
				// VistA should respond with an accept on our connection socket
				if( responseMsg == null || !responseMsg.equals("accept") )
				{
					String msg = "Connection not accepted by '" + hostname + "'.";
					logger.warn(msg);
					throw new VistaIOException(msg);
				}

				// there must be a delay here until VistA creates a socket
				// and attempts to connect to us
				transactionSocket = serverSocket.accept();
				transactionSocket.setSoTimeout(DEFAULT_SOCKET_TIMEOUT);

				// the host that we connect to must be the remote host of the
				// initial socket connection, else there may be a security
				// problem (man in the middle or simply a sniffer)
				InetAddress remoteAddress = transactionSocket.getInetAddress();
				if( ! vistaAddr.getHostAddress().equals(remoteAddress.getHostAddress()) )
				{
					String msg = "Listener socket connected to '" + remoteAddress.getHostAddress() +
							"' and should have connected to '" + vistaAddr.getHostAddress() + "'.";

					if(isProhibitUnexpectedResponder())
					{
						msg += "Connection will be dropped because of potential security implications.";
						logger.error(msg);

						try{serverSocket.close();}catch(Throwable t1){}	// eat exceptions, just close it
						try{transactionSocket.close();}catch(Throwable t2){}	// eat exceptions, just close it

						throw new VistaIOException(msg);
					}
					else
					{
						msg += "Connection is allowed to continue despite potential security implications.";
						logger.warn(msg);
					}

				}

				// we are now validly connected to VistA
				// record connection stats to use for debugging,
				// mark ourselves as connected and add ourselves to the openConnections list
				// for monitoring
				connectingThreadName = Thread.currentThread().getName();
				connectTime = System.currentTimeMillis();
				connectingStackTrace = Thread.currentThread().getStackTrace();
				connected = true;
			}
			catch (VistaIOException vioX)
			{
				// if we got an error either in the VistA response or in validating
				// the remote host, close everything down
				try{transactionSocket.close();}catch(Throwable t){}	// eat exceptions, just close it
				throw vioX;
			}
			finally
			{
			}
		}
		finally
		{
			// Fortify change: moved from the above finally block = wrong place

			// regardless of the connection success, we no longer use the
			// connection socket or the server socket so close them
			if (connectionSocket != null) {
				try {
					connectionSocket.close();
				} catch (Throwable t) {
				}    // eat exceptions, just close it
			}

			if (serverSocket != null) {
				try {
					serverSocket.close();
				} catch (Throwable t) {
				}        // eat exceptions, just close it
			}

			if(connectionSynchronizationLock.isHeldByCurrentThread())
				connectionSynchronizationLock.unlock();
		}
		this.notifyListenersAfterOpen();
	}

	/**
	 *
	 * @throws IOException
	 * @throws VistaBrokerConnectionStyleException
	 */
	private void newStyleConnect()
			throws IOException, VistaBrokerConnectionStyleException
	{
		this.vistaConnectionType = VistaConnectionType.newStyle;

		// kludge alert!!!
		// synchronize on a static object to throttle the multiple
		// connect calls to Vista
		boolean connectSynchLockAcquired = false;
		try
		{
			connectSynchLockAcquired =
					connectionSynchronizationLock.tryLock(getConnectSynchronizationMaxWait(), TimeUnit.MILLISECONDS);
		}
		catch (InterruptedException e1)
		{
			String msg = "Failed to acquire connect synchronization lock, thread interruped while waiting.";
			logger.warn("Failed to acquire connect synchronization lock, thread interruped while waiting.");

			throw new IOException(msg);
		}

		URL url = this.getURL();

		try
		{
			if(!connectSynchLockAcquired)
				logger.warn("Failed to acquire connect synchronization lock in alloted time, proceeding anyway.");

			String hostname = url.getHost();
			if( hostname == null || hostname.length() == 0 )
				throw new MalformedURLException("No hostname provided when trying to connect.  This should never be seen.");

			int port = url.getPort();
			if (port == -1)
				port = DEFAULT_PORT;

			InetAddress localInetAddr = null;

			InetAddress vistaAddr = InetAddress.getByName(hostname);	// resolve the hostname to an IP address

            logger.info("Attempting connection to '{}({})'.", hostname, vistaAddr.getHostAddress());

			transactionSocket = new Socket(vistaAddr, port);		// creates and connects socket to remote host/port
			transactionSocket.setSoTimeout(DEFAULT_CONNECTION_SOCKET_TIMEOUT);

			localInetAddr = InetAddress.getLocalHost();

			// build a string that tells Vista which socket to send
			// messages to us on
			StringBuilder sb = new StringBuilder();
			sb.append(VistaConnectionType.newStyle.getPrefix());
			sb.append("10");
			sb.append(countWidth);
			sb.append("0");
			sb.append("4");
			sb.append((char)10);
			sb.append("TCPConnect50");
			sb.append(VistaQuery.strPack(localInetAddr.getHostAddress(), countWidth));
			sb.append("f0");
			sb.append(VistaQuery.strPack("0", countWidth));
			sb.append("f0");
			sb.append(VistaQuery.strPack(localInetAddr.getHostName(), countWidth));
			sb.append("f");
			sb.append((char)4);

			String responseMsg = null;
			String requestMsg = sb.toString();

			// send the TCPConnect message to VistA and get the response
			try
			{
				//System.out.println("Request message: '" + requestMsg + "'.");
				responseMsg = internalCall(requestMsg, getConnectReadTimeout());
			}	// skips sanity checking on connection state
			catch (InvalidVistaCredentialsException e)
			{
				// if we got here on the initial connect, this indicates the remote site does not support the new style connector
				// throw the appropriate exception
				if (transactionSocket != null) { try { transactionSocket.close(); } catch (Exception exc) { /* Ignore */ } }
				throw new VistaBrokerConnectionStyleException("Error connecting to VistA site '" + hostname + ":" + port + "' with new broker style");
			}
			catch (Exception e)
			{
				if (transactionSocket != null) { try { transactionSocket.close(); } catch (Exception exc) { /* Ignore */ } }
				throw new IOException(e.getMessage());
			}

			// then transactionSocket is acquired from serverSocket, else we
			// do not want it connected or retained.

			try
			{
				// VistA should respond with an accept on our connection socket
				if( responseMsg == null || !responseMsg.equals("accept") )
				{
					String msg = "Connection not accepted by '" + hostname + "', response was '" + responseMsg + "'.";
					logger.warn(msg);
					throw new VistaIOException(msg);
				}

				// there must be a delay here until VistA creates a socket
				// and attempts to connect to us
				//transactionSocket = connectionSocket;
				//transactionSocket.setSoTimeout(DEFAULT_SOCKET_TIMEOUT);

				// we are now validly connected to VistA
				// record connection stats to use for debugging,
				// mark ourselves as connected and add ourselves to the openConnections list
				// for monitoring
				connectingThreadName = Thread.currentThread().getName();
				connectTime = System.currentTimeMillis();
				connectingStackTrace = Thread.currentThread().getStackTrace();
				connected = true;
			}
			catch (Exception e)
			{
				// if we got an error either in the VistA response or in validating
				// the remote host, close everything down
				try{ if(transactionSocket != null) { transactionSocket.close(); } } catch(Exception exc) {/*unrecoverable so do nothing*/}
				throw new VistaIOException("Error establishing Vista connection", e);
			}
		}
		finally
		{
			// Fortify change: added codes to close resource
			// Can't close this here: used elsewhere
			//try{ if(connectionSocket != null) { connectionSocket.close(); } } catch(Exception exc) {/*unrecoverable so do nothing*/}

			if(connectionSynchronizationLock.isHeldByCurrentThread())
				connectionSynchronizationLock.unlock();
		}
		this.notifyListenersAfterOpen();
	}

	/**
	 *
	 * @return
	 */
	public boolean isProhibitUnexpectedResponder()
	{
		return prohibitUnexpectedResponder ;
	}

	/**
	 * Set to true to throw an exception of the responding server is not the one we sent the request to.
	 * This usually works, but some co-located sites must allow the responder to differ from the requested
	 * site.
	 * Default is false.
	 *
	 * @param prohibitUnexpectedResponder
	 */
	public void setProhibitUnexpectedResponder(boolean prohibitUnexpectedResponder)
	{
		this.prohibitUnexpectedResponder = prohibitUnexpectedResponder;
	}

	/**
	 * @param connectSynchronizationMaxWait the connectSynchronizationMaxWait to set
	 */
	public void setConnectSynchronizationMaxWait(long connectSynchronizationMaxWait)
	{
		this.connectSynchronizationMaxWait = connectSynchronizationMaxWait;
	}

	private long getConnectSynchronizationMaxWait()
	{
		return connectSynchronizationMaxWait;
	}

	/**
	 * Call an RPC on the Vista instance to which we are connected.
	 *
	 * @throws IOException
	 * @throws InvalidVistaCredentialsException
	 * @throws VistaMethodException
	 * @throws VistaException
	 */
	/*
	public synchronized String call(String request)
	throws IOException, InvalidVistaCredentialsException, VistaMethodException
	{
		if(! isConnected())
			throw new VistaIOException("Vista connection has not been established yet, call connect() before calling call().");

		return internalCall(request);
	}*/

	public synchronized String call(VistaQuery vistaQuery)
			throws IOException, InvalidVistaCredentialsException, VistaMethodException
	{
		if(! isConnected())
			throw new VistaIOException("Vista connection has not been established yet, call connect() before calling call().");

		return internalCall(vistaQuery.buildMessage(getVistaConnectionType()), getCallReadTimeout());
	}

	/**
	 * An internal (private) call that allows class methods to make
	 * calls before the connection is completely established.
	 *
	 * @param request
	 * @return
	 * @throws IOException
	 * @throws InvalidVistaCredentialsException
	 * @throws VistaMethodException
	 * @throws VistaException
	 */
	private String internalCall(String request, long readWait)
			throws IOException, InvalidVistaCredentialsException, VistaMethodException
	{
		setFailedCall(false); // reset for this call
		send(request);
		return recv(readWait);
	}

	/**
	 *
	 * @param msg
	 * @throws IOException
	 */
	private synchronized void send(String msg)
			throws IOException
	{
		Writer out = new OutputStreamWriter( getOutputStreamInternal(), "ASCII" );
		out.write(msg);
		out.flush();
	}

	/**
	 *
	 * @return
	 * @throws VistaException
	 * @throws IOException
	 * @throws VistaMethodException
	 */
	private synchronized String recv(long wait)
			throws IOException, InvalidVistaCredentialsException, VistaMethodException
	{
		InputStreamReader in = new InputStreamReader(
				new BufferedInputStream(getInputStreamInternal()),
				"ASCII" );
		//InputStreamReader in = new VistaInputStreamReader( new BufferedInputStream(getInputStreamInternal()), "ASCII", 60000L );

		int c = nonBlockingRead(in, wait);	// read #of chars in security error message
		if( c != 0 )		// if the number of chars is not 0 then there is a security error message
		{
			StringBuffer securityMessageBuffer = new StringBuffer();

			while( (c = nonBlockingRead(in, wait)) != -1 && c != 0x04 )	// not end of stream and not EOT (end of transmission)
				securityMessageBuffer.append((char) c);

			// Sometimes c is the first char and not # of chars
			if( securityMessageBuffer.length() != c && StringUtils.isAlphaChar((char) c) )
				securityMessageBuffer = securityMessageBuffer.insert(0, c);

			setFailedCall(true);
			throw new InvalidVistaCredentialsException( securityMessageBuffer.toString().trim() );
		}

		c = nonBlockingRead(in, wait);	// read # of chars in application error message
		if (c != 0)		// if the number of chars is not 0 then there is an application error message
		{
			StringBuffer applicationErrorMessageBuffer = new StringBuffer();

			while ((c = nonBlockingRead(in, wait)) != -1 && c != 4)	// not end of stream and not EOT (end of transmission)
				applicationErrorMessageBuffer.append((char) c);

			// Sometimes c is the first char and not # of chars
			if (applicationErrorMessageBuffer.length() != c && StringUtils.isAlphaChar((char) c))
				applicationErrorMessageBuffer = applicationErrorMessageBuffer.insert(0, c);

			setFailedCall(true);
			throw new VistaMethodException( applicationErrorMessageBuffer.toString().trim() );
		}
		// Now finally read the message...
		StringBuffer applicationMessageBuffer = new StringBuffer();
		while ((c = nonBlockingRead(in, wait)) != -1 && c != 4)		// not end of stream and not EOT (end of transmission)
			applicationMessageBuffer.append((char) c);

		String response = applicationMessageBuffer.toString().trim();
		if (response.indexOf("M  ERROR", 0) != -1)
		{
			setFailedCall(true);
			throw new VistaMException(response);
		}

		return response;
	}

	/**
	 * Waits up to wait milliseconds for a character.
	 * Throws an IOException if no char are available.
	 *
	 * @param inStream
	 * @param wait
	 * @return
	 * @throws IOException
	 */
	public int nonBlockingRead(InputStreamReader inStream, long wait)
			throws IOException
	{
		if(wait > 0)
		{
			long pollingInterval = getPollingInterval();
			long currentPollingInterval = 2L; // start with a 2 second polling interval in case the read will be ready soon
			long startWait = System.currentTimeMillis();
			long endWait = startWait + (wait > 0 ? wait : 0l);		// pre-calculate this to save processing on each loop
			boolean expired = false;
			while( ! inStream.ready() && !(expired = (System.currentTimeMillis() > endWait)) )
			{
				try
				{
					Thread.sleep(currentPollingInterval);
				}
				catch (InterruptedException x)
				{
					x.printStackTrace();
					throw new IOException("Interrupted waiting for input in recv() method.", x);
				}

				if(currentPollingInterval < pollingInterval)
				{
					// if the current polling interval is less than the polling interval
					// double the polling interval
					currentPollingInterval *= 2;
					if(currentPollingInterval > pollingInterval)
					{
						// ensure the polling interval is not above the desired polling interval
						currentPollingInterval = pollingInterval;
					}
				}
			}
			if(expired)
				throw new IOException("Timed out waiting " + wait + " milliseconds.");
		}

		return inStream.read();	// read a character
	}

	public synchronized void disconnect()
	{
		VistaConnection.disconnectRequests.add(this);
	}

	/**
	 * Method to immediately disconnect the connection, not go into the disconnect pool.
	 * This should only be used for debugging purposes and not for production use.
	 */
	public synchronized void disconnectImmediately()
	{
		try
		{
			internalDisconnect();
		}
		catch(Throwable t)
		{
            logger.error("Error disconnecting immediately, {}", t.getMessage());
		}
	}

	public synchronized void errorDisconnect()
			throws IOException
	{
		// JMW 4/19/2012 - Chris and I believe that in all cases the broker should make the BYE call to VistA - even in an error condition.
		// It shouldn't hurt and if there are any exceptions it won't matter because the socket is then closed
		internalDisconnect();
		/*
		if(this.connected)
		{
			if(this.transactionSocket != null && transactionSocket.isConnected())
				this.transactionSocket.close();

			this.transactionSocket = null;
			connected = false;
		}*/
	}

	/**
	 *
	 * @throws VistaException
	 * @throws IOException
	 */
	private synchronized void internalDisconnect()
			throws IOException
	{
		if( this.connected )
		{
			if(! this.notifyListenersBeforeClose() )
			{
				logger.warn("VistaConnectionListener has returned false from connectionClosing() thereby preserving connection.");
				return;
			}

			String msg = getVistaConnectionType().getPrefix();
			if(getVistaConnectionType() == VistaConnectionType.newStyle)
			{
				msg += "10" + countWidth + "04" + (char)5 + "#BYE#" + (char)4;
			}
			else
			{
				msg += VistaQuery.strPack(VistaQuery.strPack("#BYE#", 5), 5);
			}
			try
			{
				msg = internalCall(msg, getDisconnectReadTimeout());
			}
			catch (InvalidVistaCredentialsException e)
			{
				// should never occur, an artifact of the call() method
				throw new IOException(e);
			}
			catch (VistaMethodException e)
			{
				// turn this into an IOException to make it look like
				// it is a URLConnection defined call, like connect()
				throw new IOException(e);
			}
			finally
			{
				try
				{
					// @todo msg should contain "BYE" - do anything if it doesn't?
					if(this.transactionSocket != null && transactionSocket.isConnected())
						this.transactionSocket.close();

					this.transactionSocket = null;
					connected = false;
				}
				catch(Exception ex)
				{
					// just in case...
                    logger.warn("Exception closing socket, {}", ex.getMessage());
				}
			}
		}

		this.notifyListenersAfterClose();
	}



	/**
	 * Returns an input stream that reads from this open connection.
	 *
	 * A SocketTimeoutException can be thrown when reading from the returned
	 * input stream if the read timeout expires before data is available for
	 * read.
	 *
	 * @return an input stream that reads from this open connection.
	 * @exception IOException
	 *                if an I/O error occurs while creating the input stream.
	 * @exception UnknownServiceException
	 *                if the protocol does not support input.
	 * @see #setReadTimeout(int)
	 * @see #getReadTimeout()
	 */
	@Override
	public InputStream getInputStream()
			throws IOException
	{
		throw new IOException("VistaConnection does not suppport direct access to streams, use call() method.");
	}

	private InputStream getInputStreamInternal()
			throws IOException
	{
		return this.transactionSocket == null ? null : this.transactionSocket.getInputStream();
	}

	/**
	 * Returns an output stream that writes to this connection.
	 *
	 * @return an output stream that writes to this connection.
	 * @exception IOException
	 *                if an I/O error occurs while creating the output stream.
	 * @exception UnknownServiceException
	 *                if the protocol does not support output.
	 */
	@Override
	public OutputStream getOutputStream()
			throws IOException
	{
		throw new IOException("VistaConnection does not suppport direct access to streams, use call() method.");
	}

	private OutputStream getOutputStreamInternal()
			throws IOException
	{
		return transactionSocket == null ? null : transactionSocket.getOutputStream();
	}

	// =================================================================================
	// VistaConnectionListener Management
	// =================================================================================
	private Set<VistaConnectionListener> listeners = new HashSet<VistaConnectionListener>();

	public void registerListener(VistaConnectionListener listener)
	{
		listeners.add(listener);
	}

	public void unregisterListener(VistaConnectionListener listener)
	{
		listeners.remove(listener);
	}

	private boolean notifyListenersBeforeOpen()
	{
		for(VistaConnectionListener listener : listeners)
			if( ! listener.connectionOpening(this) )
				return false;
		return true;
	}

	private void notifyListenersAfterOpen()
	{
		for(VistaConnectionListener listener : listeners)
			listener.connectionOpened(this);
	}

	private boolean notifyListenersBeforeClose()
	{
		for(VistaConnectionListener listener : listeners)
			if( ! listener.connectionClosing(this) )
				return false;
		return true;
	}

	private void notifyListenersAfterClose()
	{
		for(VistaConnectionListener listener : listeners)
			listener.connectionClosed(this);
	}

	private VistaConnectionConfiguration getVistaConnectionConfiguration()
	{
		return VistaConnectionConfiguration.getVistaConnectionConfiguration();
	}

	/**
	 * Returns true if the most recent RPC call threw an exception
	 *
	 * @return the failedCall
	 */
	public boolean isFailedCall()
	{
		return failedCall;
	}

	/**
	 * @param failedCall the failedCall to set
	 */
	private void setFailedCall(boolean failedCall)
	{
		this.failedCall = failedCall;
	}
}
