using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace ImagingClient.Infrastructure.Utilities
{
    using System.Threading;

    public static class RetryUtility
    {
        public static void RetryAction(Action action, int maxAttempts = 3, int retryTimeout = 1000)
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
    }
}
