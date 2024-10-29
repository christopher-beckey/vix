package gov.va.med.imaging;

import java.io.IOException;

import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;

import gov.va.med.logging.Logger;

public class TimeDelayFilter 
implements Filter
{
	private final static Logger LOGGER = Logger.getLogger(TimeDelayFilter.class);
	
	private long preDelay = 0L;
	private long postDelay = 0L;
	
	public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain) 
	throws IOException, ServletException
	{
		if(preDelay > 0)
		{
			try
			{
                LOGGER.info("TimeDelayFilter.doFilter() --> preDelay sleeping for [{}] ms", preDelay);
				Thread.sleep(preDelay);
			} 
			catch (InterruptedException e)
			{
                LOGGER.error("TimeDelayFilter.doFilter() --> preDelay: Encountered InterruptedException: {}", e.getMessage());
				throw new ServletException("TimeDelayFilter.doFilter() --> Encountered InterruptedException", e);
			}
		}
		
		chain.doFilter(request, response);
		
		if(postDelay > 0)
		{
			try
			{
                LOGGER.info("TimeDelayFilter.doFilter() --> postDelay sleeping for [{}] ms", postDelay);
				Thread.sleep(postDelay);
			} 
			catch (InterruptedException e)
			{
                LOGGER.error("TimeDelayFilter.doFilter() --> postDelay: Encountered InterruptedException: {}", e.getMessage());
				throw new ServletException("TimeDelayFilter.doFilter() --> postDelay: Encountered InterruptedException", e);
			}
		}
	}

	public void init(FilterConfig config) 
	throws ServletException
	{
		String preDelayInitParameter = config.getInitParameter("predelay");
		String postDelayInitParameter = config.getInitParameter("postdelay");
		
		try
		{
			if(preDelayInitParameter != null)
				preDelay = Long.parseLong( preDelayInitParameter );
			if(postDelayInitParameter != null)
				postDelay = Long.parseLong( postDelayInitParameter );
			
			if(preDelay < 0L)
				throw new ServletException("TimeDelayFilter predelay parameter must be a positive integer or zero.");
			if(postDelay < 0L)
				throw new ServletException("TimeDelayFilter postdelay parameter must be a positive integer or zero.");
		} 
		catch (NumberFormatException e)
		{
            LOGGER.error("TimeDelayFilter.init() --> Encountered NumberFormatException: {}", e.getMessage());
			throw new ServletException("TimeDelayFilter.init() --> Encountered NumberFormatException", e);
		}

        LOGGER.info("TimeDelayFilter initialized with predelay [{}] and postdelay[{}] in ms", preDelay, postDelay);
	}

	public void destroy()
	{
	}

}
