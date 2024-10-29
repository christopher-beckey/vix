/**
 * 
 * Package: MAG - VistA Imaging
 * WARNING: Per VHA Directive 2004-038, this routine should not be modified.
 * Date Created: 11/01/2011
 * Site Name:  Washington OI Field Office, Silver Spring, MD
 * Developer:  Jon Louthian
 * Description: 
 *
 *       ;; +--------------------------------------------------------------------+
 *       ;; Property of the US Government.
 *       ;; No permission to copy or redistribute this software is given.
 *       ;; Use of unreleased versions of this software requires the user
 *       ;;  to execute a written test agreement with the VistA Imaging
 *       ;;  Development Office of the Department of Veterans Affairs,
 *       ;;  telephone (301) 734-0100.
 *       ;;
 *       ;; The Food and Drug Administration classifies this software as
 *       ;; a Class II medical device.  As such, it may not be changed
 *       ;; in any way.  Modifications to this software may result in an
 *       ;; adulterated medical device under 21CFR820, the use of which
 *       ;; is considered to be a violation of US Federal Statutes.
 *       ;; +--------------------------------------------------------------------+
 *
 */
namespace ImagingClient.Infrastructure.Utilities
{
    using System;
    using System.Threading;

    /// <summary>
    /// The retry utility.
    /// </summary>
    public static class RetryUtility
    {
        #region Public Methods

        /// <summary>
        /// Retries the action.
        /// </summary>
        /// <param name="action">The action.</param>
        /// <param name="maxAttempts">The max attempts.</param>
        /// <param name="retryTimeout">The retry timeout.</param>
        public static void RetryAction(Action action, int maxAttempts = 5, int retryTimeout = 2000)
        {
            // Make sure an action has been passed in
            if (action == null)
            {
                throw new ArgumentNullException("action");
            }

            // Make sure they've requested at least 1 attempt...
            if (maxAttempts <= 0)
            {
                throw new ArgumentException("maxAttempts must be greater than or equal to 1");
            }

            // Initialize to the first attempt
            int currentAttempt = 1;

            while (currentAttempt <= maxAttempts)
            {
                try
                {
                    action();
                    return;
                }
                catch
                {
                    if (currentAttempt == maxAttempts)
                    {
                        // We have reached the maximum number of attempts with no success. Just throw the exception 
                        // up to the client
                        throw;
                    }
                    else
                    {
                        // More attempts remaining. Increment the attempt count and sleep
                        currentAttempt++;
                        Thread.Sleep(retryTimeout);
                    }
                }
            }
        }

        /// <summary>
        /// Retries the function.
        /// </summary>
        /// <typeparam name="T">The type to be returned by the wrapped function</typeparam>
        /// <param name="function">The function.</param>
        /// <param name="maxAttempts">The max attempts.</param>
        /// <param name="retryTimeout">The retry timeout.</param>
        /// <returns>The wrapped function's return value</returns>
        public static T RetryFunction<T>(Func<T> function, int maxAttempts = 5, int retryTimeout = 1000)
        {
            // Make sure an action has been passed in
            if (function == null)
            {
                throw new ArgumentNullException("function");
            }

            // Make sure they've requested at least 1 attempt...
            if (maxAttempts <= 0)
            {
                throw new ArgumentException("maxAttempts must be greater than or equal to 1");
            }

            // Initialize to the first attempt
            int currentAttempt = 1;

            while (currentAttempt <= maxAttempts)
            {
                try
                {
                    return function();
                }
                catch
                {
                    if (currentAttempt == maxAttempts)
                    {
                        // We have reached the maximum number of attempts with no success. Just throw the exception 
                        // up to the client
                        throw;
                    }
                    else
                    {
                        // More attempts remaining. Increment the attempt count and sleep
                        currentAttempt++;
                        Thread.Sleep(retryTimeout);
                    }
                }
            }

            // Should never get here, but if we do, throw an exception
            throw new Exception("Failure retrying function");
        }

        #endregion
    }
}