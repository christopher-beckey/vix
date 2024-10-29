package gov.va.med.logging;

import org.apache.logging.log4j.Level;
import org.apache.logging.log4j.LogManager;
import java.util.HashMap;
import java.util.Map;

/**
 * <p>
 * Another logging facade intended to provide more rigid guidelines and rules for the use of different logging levels
 * and methods, as well as to more easily facilitate the necessity for parameter escaping requirements and such for
 * security scanners. This is not an abstracted implementation to ensure that there is no opacity with regard to scans
 * and other audits (that is, the scanner can verify for a given context that a parameter is being correctly escaped).
 * </p>
 * <p>
 * Exceptions provided in methods here are always provided to the underlying logging implementation for "fatal",
 * "exception", and "error"-level messages, but are only included for "warn"-level messages if the underlying logging
 * implementation has a "debug"-analogue enabled.
 * </p>
 * <p>
 * Methods here have more rigid definitions and intended uses for each logging level. It is expected that no logging
 * method defined here is called with a non-parameterized message string. No concatenation or other manipulation of the
 * provided string should happen prior to these method calls. For all intents and purposes, any given value of the
 * messages provided should be basically static. Parameters can be provided and included in logging strings by using
 * "{}" syntax for each parameter in order.
 * </p>
 * <p>
 * For example, instead of:
 * logger.info("got back results: " + myResult + " and " + myOtherResult);
 * </p>
 * <p>
 * Users are expected to use this variant:
 * logger.info("got back results: {} and {}", myResult, myOtherResult);
 * </p>
 * <p>
 * This ensures that unnecessary Strings are not created or built when the logging level associated with that method
 * call is not enabled and also that parameters can be correctly escaped or handled to prevent log injection and other
 * undesired behavior.
 * </p>
 * <p>
 * Users are recommended to also make use of lambda expressions for parameter types which are not Strings already or
 * which depend on the state of a provided value. For example:
 * logger.info("got back results: {} and {}", () -> myResult, () -> myOtherResult);
 * </p>
 */
public class Logger {
    // IllegalArgumentException message indicating that the provided log message was null
    private static final String EXCEPTION_MESSAGE_NULL = "Log exception must not be null";

    // IllegalArgumentException message indicating that the provided log message or exception was null
    private static final String EXCEPTION_MESSAGE_EXCEPTION_NULL = "Log message and exception must not be null";

    // Static map of logger class names to their implementations (synchronized)
    private static final Map<String, Logger> LOGGERS_BY_CLASS_NAME = new HashMap<>();
    private static final Object SYNC_OBJECT = new Object();

    /**
     * Returns a Logger for the provided class name.
     *
     * @param loggingClass The class to provide as context for the logger using its fully qualified name.
     * @return A Logger, which may be shared across threads or instances
     */
    public static Logger getLogger(Class loggingClass) {
        // Ensure we have a parameter
        if (loggingClass == null) {
            throw new IllegalArgumentException("Class provided to getLogger must not be null");
        }

        // Synchronize access to the static map
        synchronized (SYNC_OBJECT) {
            // If we have a definition for this class name already, return it
            Logger logger = LOGGERS_BY_CLASS_NAME.get(loggingClass.getName());
            if (logger != null) {
                return logger;
            }

            // Otherwise initialize a new one from Log4j2
            logger = new Logger(LogManager.getLogger(loggingClass));
            LOGGERS_BY_CLASS_NAME.put(loggingClass.getName(), logger);
            return logger;
        }
    }

    /**
     * Given an array of objects, returns escaped String representations of each.
     *
     * @param values The values (any object types) to return, if any
     * @return An array of matching size to the input with respective escaped String values
     */
    private static CharSequence[] escapeValues(Object[] values) {
        CharSequence[] escapedValues = new String[values.length];
        for (int i = 0; i < values.length; ++i) {
            if (values[i] == null) {
                escapedValues[i] = "null";
            } else {
                escapedValues[i] = escapeValue(String.valueOf(values[i]));
            }
        }
        return escapedValues;
    }

    /**
     * Given an exception and an array of objects, returns escaped String representations of each.
     *
     * @param values The values (any object types) to return, if any
     * @return An array of matching size to the input with respective escaped String values
     */
    private static CharSequence[] escapeValues(Throwable exception, Object[] values) {
        CharSequence[] escapedValues = new String[values.length + 1];
        escapedValues[0] = escapeValue(exception.getMessage());
        for (int i = 0; i < values.length; ++i) {
            if (escapedValues[i + 1] == null) {
                escapedValues[i + 1] = "null";
            } else {
                escapedValues[i + 1] = escapeValue(String.valueOf(values[i]));
            }
        }
        return escapedValues;
    }

    /**
     * Escapes a provided String to prevent injection, leaking, or other undesired behaviors.
     *
     * @param value The String value to escape
     * @return The escaped representation of the provided value
     */
    private static CharSequence escapeValue(CharSequence value) {
        StringBuilder stringBuilder = new StringBuilder(value.length());

        // Iterate through and add back in only allowed characters
        for (int i = 0; i < value.length(); ++i) {
            // Remove any non-ASCII printable character
            if ((value.charAt(i) >= 32) && (value.charAt(i) <= 126)) {
                stringBuilder.append(value.charAt(i));
            }

            // TODO: Remove control characters?
        }

        return stringBuilder.toString();
    }

    // Non-static (instanced) declarations below

    // Our specific Log4j2 instance
    private final org.apache.logging.log4j.Logger logger;

    // Private constructor; used by the static methods above
    private Logger(org.apache.logging.log4j.Logger logger) {
        this.logger = logger;
    }

    /**
     * Actual method that does logging. Could be deprecated for individual implementations to avoid an extra method
     * invocation and some generic comparisons done here.
     *
     * @param log4jLevel The Log4j2 logging level associated with the message to be logged
     * @param message The message to be logged. Must not be null
     * @param parameters The parameters to include in the formatted message. Optional.
     */
    private void log(Level log4jLevel, CharSequence message, Object... parameters) {
        // Check log level
        if (!(logger.isEnabled(log4jLevel))) {
            return;
        }

        // Validate parameters
        if (message == null) {
            throw new IllegalArgumentException(EXCEPTION_MESSAGE_NULL);
        }

        // Escape message and parameters
        message = escapeValue(message);
        CharSequence[] escapedParameters = escapeValues(parameters);

        // Log the message
        logger.log(log4jLevel, message.toString(), (Object[]) escapedParameters);
    }

    /**
     * Actual method that does logging with an exception. Could be deprecated for individual implementations to avoid an
     * extra method invocation and some generic comparisons done here. The provided exception is only logged if the
     * provided level is "FATAL", "EXCEPTION", or the Log4J2 "DEBUG" level is enabled.
     *
     * @param log4jLevel The Log4j2 logging level associated with the message to be logged
     * @param message The message to be logged. Must not be null
     * @param exception The exception to be logged, if and only if the level is FATAL, EXCEPTION, or DEBUG is enabled.
     * @param parameters The parameters to include in the formatted message. Optional.
     */
    private void log(LogLevel logLevel, Level log4jLevel, CharSequence message, Throwable exception, Object... parameters) {
        // Check log level
        if (! (logger.isEnabled(log4jLevel))) {
            return;
        }

        // Validate parameters
        if ((message == null) || (exception == null)) {
            throw new IllegalArgumentException(EXCEPTION_MESSAGE_EXCEPTION_NULL);
        }

        // Check our log level and if debug is enabled to determine if we should log the exception
        if ((LogLevel.FATAL == logLevel) || (LogLevel.EXCEPTION == logLevel) || (LogLevel.ERROR == logLevel) || (logger.isDebugEnabled())) {
            // TODO: We may need to escape the actual exception
            logger.atLevel(log4jLevel).withThrowable(exception).log(escapeValue(message).toString(), (Object[]) escapeValues(parameters), exception);
        } else {
            // Log the message and its values
            logger.log(log4jLevel, escapeValue(message).toString(), (Object[]) escapeValues(parameters));

            // Alternative: log the message but include the escaped exception method
            //logger.log(log4jLevel, escapeValue(message) + ": {}", (Object[]) escapeValues(exception, parameters));
        }
    }

    /**
     * Logs a fatal error with an associated exception. This represents an error or condition which should be considered
     * fatal to the runtime context if not the system as a whole. This should almost never be used by code that is not
     * responsible for establishing a persistent context. The provided exception will always be passed to the underlying
     * logging implementation.
     *
     * @param message The message to log with parameters listed in order via {} syntax. Must not be null.
     * @param exception The exception to include in the log.
     * @param parameters Any parameters to include within the log message. Optional.
     */
    public void fatal(CharSequence message, Throwable exception, Object... parameters) {
        log(LogLevel.FATAL, Level.FATAL, message, exception, parameters);
    }

    /**
     * Logs an error with an associated exception. This represents an error or condition which is unexpected and
     * cannot be recovered from. This should be used by root application error handlers or other contexts from which
     * thrown exceptions cannot be caught. The provided exception will always be passed to the underlying logging
     * implementation. It is recommended that runtime exceptions (like NullPointerException, IllegalArgumentException,
     * etc) are handled with this message, except where those cause fatal issues.
     *
     * @param message The message to log with parameters listed in order via {} syntax. Must not be null.
     * @param exception The exception to include in the log.
     * @param parameters Any parameters to include within the log message. Optional.
     */
    public void exception(CharSequence message, Throwable exception, Object... parameters) {
        log(LogLevel.EXCEPTION, Level.ERROR, message, exception, parameters);
    }

    /**
     * Logs an error with an associated exception. This represents an error or condition which may or may not be
     * expected and for which the inclusion of the exception is not critical for diagnosis or other information. The
     * exception will only be included if the underlying logger implementation is currently set to a "debug"-level
     * analogue.
     *
     * @param message The message to log with parameters listed in order via {} syntax. Must not be null.
     * @param exception The exception to include in the log, if and only if a "debug"-level equivalent is enabled.
     * @param parameters Any parameters to include within the log message. Optional.
     */
    public void error(CharSequence message, Throwable exception, Object... parameters) {
        log(LogLevel.ERROR, Level.ERROR, message, exception, parameters);
    }

    /**
     * Logs an error. This represents an error or condition which may or may not be expected but which has sufficient
     * information in its provided text or parameters for diagnosis, troubleshooting, or just general information.
     *
     * @param message The message to log with parameters listed in order via {} syntax. Must not be null.
     * @param parameters Any parameters to include within the log message. Optional.
     */
    public void error(CharSequence message, Object... parameters) {
        log(Level.ERROR, message, parameters);
    }

    /**
     * Logs a warning with an associated exception. This represents a condition or state which is unusual or erroneous
     * but which is expected or handled and which has sufficient information in its provided text or parameters for
     * consumers to determine if this represents a broader issue. The exception is only included if the underlying
     * logger implementation is currently set to a "debug"-level analogue.
     *
     * @param message The message to log with parameters listed in order via {} syntax. Must not be null.
     * @param exception The exception to include in the log, if and only if a "debug"-level equivalent is enabled.
     * @param parameters Any parameters to include within the log message. Optional.
     */
    public void warn(CharSequence message, Throwable exception, Object... parameters) {
        log(LogLevel.WARNING, Level.WARN, message, exception, parameters);
    }

    /**
     * Logs a warning. This represents a condition or state which is unusual or erroneous but which is expected or
     * handled and which has sufficient information in its provided text or parameters for consumers to determine if
     * this represents a broader issue.
     *
     * @param message The message to log with parameters listed in order via {} syntax. Must not be null.
     * @param parameters Any parameters to include within the log message. Optional.
     */
    public void warn(CharSequence message, Object... parameters) {
        log(Level.WARN, message, parameters);
    }

    /**
     * Logs information. This should contain information which is broad and relatively non-verbose for the context of
     * its source package, project, or framework. This can include cases like information about sending or receiving
     * requests and responses, beginning or ending some process, or other, similarly-scoped information. Log messages
     * which are useful or necessary for day-to-day operations should use this method.
     *
     * @param message The message to log with parameters listed in order via {} syntax. Must not be null.
     * @param parameters Any parameters to include within the log message. Optional.
     */
    public void info(CharSequence message, Object... parameters) {
        log(Level.INFO, message, parameters);
    }

    /**
     * Logs detailed information. This is analogous to and implemented as a "debug"-level message in any underlying
     * logging implementation. This should contain information which is useful for providing details about a process,
     * message, or other context for the purposes of debugging or when log verbosity is not an issue. It is strongly
     * recommended to not enable this in production systems or to only do some temporarily.
     *
     * @param message The message to log with parameters listed in order via {} syntax. Must not be null.
     * @param parameters Any parameters to include within the log message. Optional.
     */
    public void debug(CharSequence message, Object... parameters) {
        log(Level.DEBUG, message, parameters);
    }

    /**
     * Logs extremely detailed information. This is intended to be used to provide log messages which are necessary
     * for development, debugging, and troubleshooting. It is strongly recommended to never enable this outside of a
     * development environment and even then to only do so temporarily. Committed, production code should probably not
     * contain uses of this method.
     *
     * @param message The message to log with parameters listed in order via {} syntax. Must not be null.
     * @param parameters Any parameters to include within the log message. Optional.
     */
    public void trace(CharSequence message, Object... parameters) {
        log(Level.TRACE, message, parameters);
    }

    // TODO: Find instances, remove
    public boolean isDebugEnabled() {
        return logger.isDebugEnabled();
    }

    public boolean isInfoEnabled() {
        return logger.isInfoEnabled();
    }

    public boolean isTraceEnabled() {
        return logger.isTraceEnabled();
    }

    public void error(Throwable t) {
        error(t.getMessage(), t);
    }

    public void warn(Throwable t) {
        warn(t.getMessage(), t);
    }

    public void fatal(Throwable t) {
        fatal(t.getMessage(), t);
    }

    public void debug(Throwable t) {
        debug(t.getMessage(), t);
    }

    public void info(Throwable t) {
        info(t.getMessage(), t);
    }

    public static void reconfigure() {
        ((org.apache.logging.log4j.core.LoggerContext) LogManager.getContext(false)).reconfigure();
    }
}
