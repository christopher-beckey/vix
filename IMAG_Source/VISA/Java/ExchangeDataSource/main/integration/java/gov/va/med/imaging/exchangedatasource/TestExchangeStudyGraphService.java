package gov.va.med.imaging.exchangedatasource;

import gov.va.med.ProtocolHandlerUtility;
import gov.va.med.ProtocolSchema;
import gov.va.med.imaging.artifactsource.ArtifactSource;
import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.datasource.DataSourceProvider;
import gov.va.med.imaging.datasource.GetPatientStudiesParameters;
import gov.va.med.imaging.datasource.Provider;
import gov.va.med.imaging.datasource.StudyGraphDataSourceSpi;
import gov.va.med.imaging.datasource.TestStudyGraphDataSourceService;
import gov.va.med.imaging.exchange.business.*;
import java.io.File;
import java.io.FileOutputStream;
import java.io.ObjectOutputStream;
import java.net.MalformedURLException;
import java.net.URL;
import java.util.ArrayList;
import java.util.List;
import java.util.SortedSet;

/**
 * 
 * @author VHAISWBECKEC
 *
 */
public class TestExchangeStudyGraphService 
extends TestStudyGraphDataSourceService
{
	private ResolvedSite resolvedSite = null;
	protected synchronized ResolvedSite getResolvedSite()
    {
		if(resolvedSite == null)
			resolvedSite = new ResolvedSite()
			{
				private Site siteImpl = null;
				private List<URL> metadataUrls = null;
				private List<URL> artifactUrls = null;
				
				@Override
				public synchronized List<URL> getMetadataUrls()
				{
					if(metadataUrls == null)
					{
						metadataUrls = new ArrayList<URL>();
						try
						{
							// exchange://localhost:80/VaImagingExchange/ImageMetadataService.asmx
							metadataUrls.add(new URL("exchange://localhost:8080/ImagingExchangeWebApp/xchange-ws/ImageMetadata.V1"));
						}
						catch (MalformedURLException x)
						{
							x.printStackTrace();
						}
					}
					return metadataUrls;
				}
				
				@Override
				public URL getMetadataUrl(String protocol)
				{
					if(protocol == null) return null;
					for(URL url : getMetadataUrls())
						if( protocol.equalsIgnoreCase(url.getProtocol()) )
							return url;
						
					return null;
				}
				
				@Override
				public synchronized List<URL> getArtifactUrls()
				{
					if(artifactUrls == null)
					{
						artifactUrls = new ArrayList<URL>();
						try
						{
							artifactUrls.add(new URL("exchange://localhost:8080/ImagingExchangeWebApp/xchange/xchange"));
						}
						catch (MalformedURLException x)
						{
							x.printStackTrace();
						}
					}
					return artifactUrls;
				}
				
				@Override
				public URL getArtifactUrl(String protocol)
				{
					if(protocol == null) return null;
					for(URL url : getArtifactUrls())
						if( protocol.equalsIgnoreCase(url.getProtocol()) )
							return url;
						
					return null;
				}
				
				@Override
				public ArtifactSource getArtifactSource()
				{
					return getSite();
				}
				
				@Override
				public boolean isLocal()
				{
					return isLocalSite();
				}
				
				@Override
				public boolean isAlien()
				{
					return isAlienSite();
				}
				
				@Override
				public boolean isLocalSite()
				{
					return false;
				}
				
				@Override
				public boolean isAlienSite()
				{
					return false;
				}
				
				@Override
				public boolean isEnabled()
				{
					return true;
				}

				@Override
				public synchronized Site getSite()
				{
					if( siteImpl == null )
						try
						{
							siteImpl = new SiteImpl("660", "Washington DC", "WDC", "localhost", 9300, "localhost", 8080, "");
						}
						catch (MalformedURLException x)
						{
							x.printStackTrace();
						}
				
					return siteImpl;
				}
			};
			
		return resolvedSite;
    }

	@Override
    protected List<GetPatientStudiesParameters> getGetPatientStudiesParametersList()
    {
		StudyFilter filter = new StudyFilter(); 
		
		List<GetPatientStudiesParameters> testStimulus = new ArrayList<GetPatientStudiesParameters>();
		testStimulus.add(new GetPatientStudiesParameters(filter, "1006184063V088473"));
		
	    return testStimulus;
    }

	@Override
    protected List<SortedSet<Study>> getGetPatientStudiesResultsList()
    {
	    return null;
    }

	private DataSourceProvider provider = null;
	protected DataSourceProvider getProvider()
	{
		provider = new Provider();
		
		return provider;
	}
	
	@Override
    protected StudyGraphDataSourceSpi getStudyGraphDataSource()
    {
		try
        {
			return getProvider().createStudyGraphDataSource(getResolvedSite(), ProtocolSchema.EXCHANGE.toString());
        } 
		catch (ConnectionException x)
		{
			x.printStackTrace();
		} 
		
        return null;
    }

	public static void main(String[] argv)
	{
		ProtocolHandlerUtility.initialize(true);
		
		TestExchangeStudyGraphService test = new TestExchangeStudyGraphService();
		ObjectOutputStream outStream = null;
		try
        {
			List<SortedSet<Study>> results = test.getResults();
			File resultsFile = new File("/TestExchangeStudyGraphService.results");
			outStream = new ObjectOutputStream( new FileOutputStream(resultsFile));
			outStream.writeObject(results);
        } 
		catch (Exception e)
        {
	        e.printStackTrace();
        }
		finally
		{
			try{outStream.close();} catch(Throwable t){}
		}
		
		
	}
}
