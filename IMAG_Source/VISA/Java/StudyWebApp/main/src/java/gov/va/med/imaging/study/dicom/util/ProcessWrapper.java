package gov.va.med.imaging.study.dicom.util;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import java.io.BufferedReader;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.util.LinkedList;
import java.util.Queue;

public class ProcessWrapper {
	static public Logger logger = LogManager.getLogger(ProcessWrapper.class);
    private String executionPath[];

    private Process process;
    private boolean isRunning;
    
    private Queue<Long> q = new LinkedList<Long>();
    private Long start = 0l;
    private int maxRestarts = 10;
    private int restartDelayThresholdMillis = 1000;
    private int restartDelay = 5000;
    private boolean autoRestart = true;
    private boolean useStrictExitCodes = false;
    
    private String stdErrFile= null;
    private String stdOutFile= null;
    
    private static int thread = 0;
    
    public ProcessWrapper(String executionPath[], boolean autoRestart, boolean useStrictExitCodes) {
    	this.executionPath=executionPath;
    	this.autoRestart=autoRestart;
    	this.useStrictExitCodes=useStrictExitCodes;
    }
    
    public ProcessWrapper(String executionPath[], boolean autoRestart, int maxRestarts, int restartDelayThresholdMillis, int restartDelay) {
    	this.executionPath=executionPath;
    	this.autoRestart=autoRestart;
    	this.maxRestarts = maxRestarts;
    	this.restartDelayThresholdMillis=restartDelayThresholdMillis;
    	this.restartDelay=restartDelay;
    }

    public int getMaxRestarts() {
		return maxRestarts;
	}

	public void setMaxRestarts(int maxRestarts) {
		this.maxRestarts = maxRestarts;
	}

	public int getRestartDelayThresholdMillis() {
		return restartDelayThresholdMillis;
	}

	public void setRestartDelayThresholdMillis(int restartDelayThresholdMillis) {
		this.restartDelayThresholdMillis = restartDelayThresholdMillis;
	}

	public int getRestartDelay() {
		return restartDelay;
	}

	public void setRestartDelay(int restartDelay) {
		this.restartDelay = restartDelay;
	}

	public String[] getExecutionPath() {
		return executionPath;
	}
	
	public String getExecutionPathString() {
		StringBuffer res = new StringBuffer();
		for(String p:executionPath) {
			res.append(p).append(" ");
		}
		return res.toString().trim();
	}

	public void setExecutionPath(String executionPath[]) {
		this.executionPath = executionPath;
	}

	public String getStdErrFile() {
		return stdErrFile;
	}

	public void setStdErrFile(String stdErrFile) {
		this.stdErrFile = stdErrFile;
	}

	public String getStdOutFile() {
		return stdOutFile;
	}

	public void setStdOutFile(String stdOutFile) {
		this.stdOutFile = stdOutFile;
	}

	private void logInfo(InputStream in) {
		Thread t = new Thread(() -> {
			try(BufferedReader reader = new BufferedReader(new InputStreamReader(in))) {
				String line;
				while((line = reader.readLine()) != null) {
					logger.info(line);
				}
			}catch(Exception e) {
				e.printStackTrace();
			}
		});
		t.setName("ProcLogger-" + (thread++) );
		t.start();
	}
	
	private void logError(InputStream in) {
		Thread t = new Thread(() -> {
			try(BufferedReader reader = new BufferedReader(new InputStreamReader(in))) {
				String line;
				while((line = reader.readLine()) != null) {
					logger.info(line);
				}
			}catch(Exception e) {
				e.printStackTrace();
			}
		});
		t.setName("ProcLogger-" + (thread++));
		t.start();
	}
	
	public void start() {
		
        try {
        	start = System.currentTimeMillis();
        	logger.info("Starting '" + getExecutionPathString() + "'");
        	
        	ProcessBuilder builder = new ProcessBuilder(executionPath);
        	
        	builder.redirectError();        	
        	
//        	if(stdErrFile!=null) {
//        		logger.info("Redirecting stderr to '" + stdErrFile+"'");
//        		builder.redirectError(new File(stdErrFile));
//        	}
//        	if(stdOutFile!=null) {
//        		logger.info("Redirecting stdout to '" + stdOutFile+"'");
//        		builder.redirectOutput(new File(stdOutFile));
//        	}
        	
        	process = builder.start();
        	
        	logInfo(process.getInputStream());
        	logError(process.getErrorStream());
        	
            isRunning = true;
            
            Thread monitorThread = new Thread(this::monitorProcess);
            monitorThread.setDaemon(true); // Set the thread as daemon so it automatically terminates with the main thread
            monitorThread.start();
            
            Thread checkThread = new Thread(this::check);
        	checkThread.setDaemon(true); // Set the thread as daemon so it automatically terminates with the main thread
        	checkThread.start();
            
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public void stop() {
        if (process != null && process.isAlive()) {
        	logger.info("Stopping '" + getExecutionPathString() + "'");
            process.destroy();
            isRunning = false;
        }
    }

    private long average( Queue<Long> q) {
    	long total = 0l;
    	for(Long one:q) {
    		total+=one;
    	}
    	return total/q.size();
    }
    
    private void monitorProcess() {
        try {
            process.waitFor(); // Wait for the process to exit
            isRunning = false;
            q.add(System.currentTimeMillis()-start);
            
            if(q.size()>2 && average(q)<restartDelayThresholdMillis) {
            	logger.info("Delaying restart for "+restartDelay+" ms (Average restart attempt terminated in " + average(q) +" ms)");
            	Thread.sleep(restartDelay);
            }
            
            switch(process.exitValue()) {
	            case 0: //success
	            	logger.info("Process '" + getExecutionPathString() + "' exited normally with value " +process.exitValue()+ " (execution attempt " + q.size() +")");
	            	if(useStrictExitCodes) {
	            		return; //Don't attempt to restart on success exit code
	            	}
	            	break;
	            default: //failed
	            	logger.info("Process '" + getExecutionPathString() + "' exited abnormally with value " +process.exitValue()+ " (execution attempt " + q.size() +")");
	            	
            }
            
            // Automatically restart the process
            if( q.size() < maxRestarts) {
            	if(autoRestart) {
            		logger.info("Attempting to restart '"+ getExecutionPathString() +"'");
            		start();
            	}
            } else {
            	System.err.println("Aborting the restarts for '" +getExecutionPathString()+ "'.  Reached maximum restarts attempts of " + q.size());
            }
        } catch (InterruptedException e) {
            e.printStackTrace();
        }
    }

    private void check() {
    	boolean started = true;
    	for( int i = 1; i <= 10; i++) {
	    	try {
	    		Thread.sleep(500);
	    		started=started&&isAlive();
	    	} catch(InterruptedException e) {
	    	}
    	}
    	
    	//Bind to the JVM shutdown to make sure the sub-process dies
    	if(isAlive()) {
    		Runtime.getRuntime().addShutdownHook(new Thread(this::stop));
    	}
    	logger.info("Checked '"+getExecutionPathString()+"' for the first 5 seconds and it is "+ (started?"RUNNING":"NOT RUNNING"));
    }
    	
    public boolean isRunning() {
        return isRunning;
    }

    public boolean isAlive() {
        return process.isAlive();
    }
}