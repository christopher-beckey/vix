package gov.va.med.imaging.system;

import java.util.concurrent.Executors;
import java.util.concurrent.ScheduledExecutorService;
import java.util.concurrent.TimeUnit;

import javax.servlet.ServletContext;
import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;

import gov.va.med.logging.Logger;

public class ShutdownServletContextListener implements ServletContextListener {
	private final Logger logger = Logger.getLogger(this.getClass());
	private int timeoutInSeconds = 10;
	
	@Override
	public void contextInitialized(ServletContextEvent servletContextEvent) {
		ServletContext ctx = servletContextEvent.getServletContext();
        String timeout = ctx.getInitParameter("forceShutdownTimeout");
        try {
        	timeoutInSeconds = Integer.parseInt(timeout);
            logger.info("ShutdownServletContextListener initialized. Using a forced shutdown wait time of {} seconds", timeoutInSeconds);
        } catch( Exception e ) {
            logger.warn("Unable to parse forced shutdown timeout. Using default value of: {} seconds", timeoutInSeconds);
        }
	}

	@Override
	public void contextDestroyed(ServletContextEvent servletContextEvent) {
        logger.info("ShutdownServletContextListener forcing shutdown in {} seconds", timeoutInSeconds);
		new Thread(new Runnable() {
		    public void run() {
			try {				
				Thread.sleep(1000*timeoutInSeconds);
			} catch (InterruptedException e) {
				logger.error("ShutdownServletContextListener: Encountered a InterruptedException");
			}
			System.exit(0);
		    }
		}).start();
	}
}
