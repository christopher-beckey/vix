// Copyright Laurel Bridge Software, Inc.  All rights reserved.  See distributed license file.
// WARNING: This file is generated from LOG.java. Do not hand edit.
package gov.va.med.imaging.study.lbs;

import java.io.CharArrayWriter;
import java.io.PrintWriter;

import com.lbs.LOG.LOGClient;
import com.lbs.CDS.CFGGroup;

import gov.va.med.logging.Logger;

/**
 * LOG wrapper for use in the ex_jqr_scp component
 */
class LOG
{
    //private static String ComponentId = "java_app/lb_scp";
    private static String ComponentId = "StudyLBSComponent";
	private final static Logger logger = Logger.getLogger(LOG.class);

    private LOG()
    {
    }

    /**
     * Format the stack trace message in an exception
     * @param ex the Exception
     * @return the stack trace
     */
    static String formatStackTraceMsg(Exception ex)
    {
        if (ex == null)
            return "";
        else
        {
            CharArrayWriter caw = new CharArrayWriter();
            PrintWriter pw = new PrintWriter(caw);
            ex.printStackTrace(pw);
            pw.flush();
            return System.getProperty("line.separator") + caw.toString();
        }
    }

    /**
     * Print a DEBUG message to the LogClient, if the current debug flags for
     * this component includes any of the bits in the mask parameter.
     *
     * @param mask Log message only if any of these bits are set for this component
     * @param msg Message to log
     */
    static void debug(int mask, String msg)
    {
// 		System.out.println("debug="+msg);
       if (CINFO.testDebugFlags(mask))
        {
			if(logger.isDebugEnabled()) logger.debug(msg);
            LOGClient.instance().writeMessage(LOGClient.MSG_TYPE_DEBUG, 0, ComponentId, msg, null);
        }
    }

    /**
     * Print a DEBUG message to the LogClient. (This can be used after
     * directly checking the debug flags for this component). Occasionally it
     * is more efficient to do:
     * <code>
     * if (CINFO.debug(df_SOME_DEBUG_SETTING))
     * {
     *     LOG.debug(my_big_object.ToString());
     * }
     * </code>
     * If preparing the text of the message is expensive, then you may only want
     * to do it if you are actually going to log that message.
     * @param msg
     */
    static void debug(String msg)
    {
		if(logger.isDebugEnabled()) logger.debug(msg);
        LOGClient.instance().writeMessage(LOGClient.MSG_TYPE_DEBUG, 0, ComponentId, msg, null);
    }

    /**
     * Print a DEBUG message to the LogClient, if the current debug flags for
     * this component includes any of the bits in the mask parameter.
     * @param mask Log message only if any of these bits are set for this component
     * @param msg Message to log
     * @param user_data Additional message context
     */
	static void debug(int mask, String msg, CFGGroup user_data)
    {
        if (CINFO.testDebugFlags(mask))
        {
			if(logger.isDebugEnabled()) logger.debug(msg);
            LOGClient.instance().writeMessage(LOGClient.MSG_TYPE_DEBUG, 0, ComponentId, msg, user_data);
        }
    }

    /**
     * Print a DEBUG message to the LogClient. (This can be used after
     * directly checking the debug flags for this component). Occasionally it
     * is more efficient to do:
     * <code>
     * if (CINFO.debug(df_SOME_DEBUG_SETTING))
     * {
     *     LOG.debug(my_big_object.ToString());
     * }
     * </code>
     * If preparing the text of the message is expensive, then you may only want
     * to do it if you are actually going to log that message.
     * @param msg Message to log
     * @param user_data Additional message context
     */
    static void debug(String msg, CFGGroup user_data)
    {
		if(logger.isDebugEnabled()) logger.debug(msg);
        LOGClient.instance().writeMessage(LOGClient.MSG_TYPE_DEBUG, 0, ComponentId, msg, user_data);
    }

    /**
     * Print a DEBUG message to the LOGClient, and include information about an exception that was caught.
     * @param mask Conditional debug flags
     * @param msg Text of the message
     * @param ex Exception
     */
    static void debug(int mask, String msg, Exception ex)
    {
        if (CINFO.testDebugFlags(mask))
        {
            String fullMsg = ex == null
								? msg
								: msg + formatStackTraceMsg(ex);
            if(logger.isDebugEnabled())
                logger.debug("{}{}", msg, fullMsg);
            LOGClient.instance().writeMessage(LOGClient.MSG_TYPE_DEBUG, 0, ComponentId, fullMsg, null);
        }
    }

    /**
     * Print a DEBUG message to the LOGClient, and include information about an exception that was caught.
     * @param mask Conditional debug flags
     * @param msg Text of the message
     * @param ex Exception
     * @param user_data Additional message context
     */
    static void debug(int mask, String msg, Exception ex, CFGGroup user_data)
    {
        if (CINFO.testDebugFlags(mask))
        {
            String fullMsg = ex == null
								? msg
								: msg + formatStackTraceMsg(ex);
            if(logger.isDebugEnabled())
                logger.debug("{}{}", msg, fullMsg);
            LOGClient.instance().writeMessage(LOGClient.MSG_TYPE_DEBUG, 0, ComponentId, fullMsg, user_data);
        }
    }

    /**
     * Implementation method for LOG.warn().
     * @param msg the message
     * @param ex the exception or null
     * @param user_data additional user context
     */
    private static void warnMsg(String msg, Exception ex, CFGGroup user_data)
    {
//		System.out.println("warn="+msg+"\n"+ex);
        String preamble = "WARNING: ";
		String fullMsg = (ex == null)
							? preamble + msg
							: preamble + msg + formatStackTraceMsg(ex);
        logger.warn("{}{}", msg, fullMsg);
        LOGClient.instance().writeMessage(LOGClient.MSG_TYPE_DEBUG, 0, ComponentId, fullMsg, user_data);
    }

    /**
     * Print a DEBUG WARNING message to the LogClient, if the debug flags for
     * this component includes df_SHOW_WARNINGS.
     * @param msg Message to log
     */
    static void warn(String msg)
    {
//		System.out.println("warn="+msg);
        if (CINFO.testDebugFlags(CINFO.df_SHOW_WARNINGS))
        {
			logger.warn(msg);
            warnMsg(msg, null, null);
        }
    }

    /**
     * Print a DEBUG WARNING message to the LogClient, if the current debug flags for
     * this component includes df_SHOW_WARNINGS, and include additional message context.
     * @param msg Message to log
     * @param user_data Additional message context
     */
    static void warn(String msg, CFGGroup user_data)
    {
//		System.out.println("warn="+msg);
        if (CINFO.testDebugFlags(CINFO.df_SHOW_WARNINGS))
        {
			logger.warn(msg);
            warnMsg(msg, null, user_data);
        }
    }

    /**
     * Print a DEBUG WARNING message to the LOGClient if the current debug flags for
     * this component includes df_SHOW_WARNINGS, and include information about an exception that was caught.
     * @param msg Text of the message
     * @param ex Exception
     */
    static void warn(String msg, Exception ex)
    {
        if (CINFO.testDebugFlags(CINFO.df_SHOW_WARNINGS))
        {
            logger.warn("{}{}", msg, ex);
            warnMsg(msg, ex, null);
        }
    }

    /**
     * Print a DEBUG WARNING message to the LOGClient, if the current debug flags for
     * this component includes df_SHOW_WARNINGS, and include information about an exception that was caught,
     * and also include additional message context.
     * @param msg Text of the message
     * @param ex Exception
     * @param user_data Additional message context
     */
    static void warn(String msg, Exception ex, CFGGroup user_data)
    {
        if (CINFO.testDebugFlags(CINFO.df_SHOW_WARNINGS))
        {
            logger.warn("{}{}", msg, ex);
            warnMsg(msg, ex, user_data);
        }
    }

    /**
     * Print an INFO message to the LOGClient.
     * @param msg Text of the message
     */
    static void info(String msg)
    {
        if(logger.isDebugEnabled()) logger.debug(msg);
        LOGClient.instance().writeMessage(LOGClient.MSG_TYPE_INFO, 0, ComponentId, msg, null);
    }

    /**
     * Print an INFO message to the LOGClient.
     * @param msg Text of the message
     * @param user_data Additional message context
     */
    static void info(String msg, CFGGroup user_data)
    {
		logger.info(msg);
        LOGClient.instance().writeMessage(LOGClient.MSG_TYPE_INFO, 0, ComponentId, msg, user_data);
    }

    /**
     * Print an INFO message to the LOGClient. Include information about an exception that was caught.
     * @param msg Text of the message
     * @param ex Exception
     */
    static void info(String msg, Exception ex)
    {
		String fullMsg = ex == null
							? msg
							: msg + formatStackTraceMsg(ex);
        logger.info("{}{}", msg, fullMsg);
        LOGClient.instance().writeMessage(LOGClient.MSG_TYPE_INFO, 0, ComponentId, fullMsg, null);
    }

    /**
     * Print an ERROR message (header only) to the LOGClient.
     * @param code System dependent error code
     */
    static void error(int code)
    {
        logger.error("{}", code);
        LOGClient.instance().writeMessage(LOGClient.MSG_TYPE_ERROR, code, ComponentId, null, null);
    }

    /**
     * Print an ERROR message to the LOGClient.
     * @param code System dependent error code
     * @param msg Text of the message
     */
    static void error(int code, String msg)
    {
        logger.error("errorcode: {} {}", code, msg);
        LOGClient.instance().writeMessage(LOGClient.MSG_TYPE_ERROR, code, ComponentId, msg, null);
    }

    /**
     * Print an ERROR message to the LOGClient.
     * @param code System dependent error code
     * @param msg Text of the message
     * @param user_data Additional message context
     */
    static void error(int code, String msg, CFGGroup user_data)
    {
        logger.error("errorcode: {} {}", code, msg);
        LOGClient.instance().writeMessage(LOGClient.MSG_TYPE_ERROR, code, ComponentId, msg, user_data);
    }

    /**
     * Print an ERROR message to the LOGClient.
     * @param code System dependent error code
     * @param msg Text of the message
     * @param ex Exception
     */
    static void error(int code, String msg, Exception ex)
    {
		String fullMsg = ex == null
							? msg
							: msg + formatStackTraceMsg(ex);
        logger.error("errorcode: {} {}{}", code, msg, fullMsg);
        LOGClient.instance().writeMessage(LOGClient.MSG_TYPE_ERROR, code, ComponentId, fullMsg, null);
    }

    /**
     * Print an ERROR message to the LOGClient.
     * @param code System dependent error code
     * @param msg Text of the message
     * @param ex Exception
     * @param user_data Additional message context
     */
    static void error(int code, String msg, Exception ex, CFGGroup user_data)
    {
		String fullMsg = ex == null
							? msg
							: msg + formatStackTraceMsg(ex);
        logger.error("errorcode: {} {}{}", code, msg, fullMsg);
       LOGClient.instance().writeMessage(LOGClient.MSG_TYPE_ERROR, code, ComponentId, fullMsg, user_data);
    }

    /**
     * @deprecated
     */
    static void fatal_error(int code)
    {
        logger.error("errorcode: {}", code);
        LOGClient.instance().writeMessage(LOGClient.MSG_TYPE_ERROR, code, ComponentId, null, null);
    }

    /**
     * @deprecated
     */
    static void fatal_error(int code, String msg)
    {
        logger.error("errorcode: {} {}", code, msg);
        LOGClient.instance().writeMessage(LOGClient.MSG_TYPE_ERROR, code, ComponentId, msg, null);
    }

    /**
     * @deprecated
     */
    static void fatal_error(int code, String msg, CFGGroup user_data)
    {
        logger.error("errorcode: {} {}", code, msg);
        LOGClient.instance().writeMessage(LOGClient.MSG_TYPE_ERROR, code, ComponentId, msg, user_data);
    }

    /**
     * @deprecated
     */
    static void fatal_error(int code, String msg, Exception ex)
    {
		String fullMsg = ex == null
							? msg
							: msg + formatStackTraceMsg(ex);
        logger.error("errorcode: {} {}{}", code, msg, fullMsg);
        LOGClient.instance().writeMessage(LOGClient.MSG_TYPE_ERROR, code, ComponentId, fullMsg, null);
    }

    /**
     * @deprecated
     */
    static void fatal_error(int code, String msg, Exception ex, CFGGroup user_data)
    {
		String fullMsg = ex == null
							? msg
							: msg + formatStackTraceMsg(ex);
        logger.error("errorcode: {} {}{}", code, msg, fullMsg);
        LOGClient.instance().writeMessage(LOGClient.MSG_TYPE_ERROR, code, ComponentId, fullMsg, user_data);
    }
}
