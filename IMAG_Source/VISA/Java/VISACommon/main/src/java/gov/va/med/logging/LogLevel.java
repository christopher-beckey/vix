package gov.va.med.logging;

public enum LogLevel {
    /**
     * An unexpected, unrecoverable error has occurred
     */
    FATAL,

    /**
     * An error with an exception has occurred that should always be logged. This should be used by root-level handlers
     * that ultimately catch all exceptions (the equivalent of a try / catch in a "main" method) or for cases where,
     * regardless of log level, stack trace information is necessary. This should generally only be used for runtime
     * exceptions (such as NullPointerException).
     */
    EXCEPTION,

    /**
     * An error has occurred that may have an exception, which should only be logged if debugging is enabled.
     */
    ERROR,

    /**
     * An expected error has occurred. Usually this represents an error or notification to suggest that something may
     * be wrong but is either expected or recoverable
     */
    WARNING,

    /**
     * Informational logging that is useful for day-to-day operations and provides broad information about actions or
     * processes occurring.
     */
    INFO,

    /**
     * Detailed informational logging that is useful for debugging but contains information that is too detailed or
     * verbose for day-to-day operations. Analogous to "DEBUG" in most contexts.
     */
    DETAIL,

    /**
     * Extremely detailed, fine-grained logging that is used for debugging at the stack or method chain level. This
     * should be only enabled temporarily.
     */
    TRACE

}
