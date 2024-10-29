package gov.va.med.siteservice;

public class RetryBackoffPolicy {
    private final long initDelayMillis = 3000;
    private final long retryMultiplier = 2;
    private final long maxDelay;
    private final int maxAttempts;

    public RetryBackoffPolicy(long maxDelayMillis, int maxAttempts ){
        this.maxDelay = maxDelayMillis;
        this.maxAttempts = maxAttempts;
    }

    public long getDelay(int attemptCount){
        return Math.min(retryMultiplier * attemptCount * initDelayMillis, maxDelay);
    }

    public long getInitDelayMillis() {
        return initDelayMillis;
    }

    public long getRetryMultiplier() {
        return retryMultiplier;
    }

    public long getMaxDelay() {
        return maxDelay;
    }

    public int getMaxAttempts() {
        return maxAttempts;
    }
}
