/**
 * 
 */
package gov.va.med.imaging.artifactsource;

import gov.va.med.logging.Logger;

/**
 * @author vhaiswbeckec
 *
 */
public class ArtifactSourceFactory
{
	private static final Logger LOGGER = Logger.getLogger(ArtifactSourceFactory.class);
	
	/**
	 * 
	 * @param memento
	 * @return
	 */
	public static ArtifactSource create(ArtifactSourceMemento memento)
	{
		if(memento == null || memento.getArtifactSourceClassName() == null)
			return null;
		
		try
		{
			Class<ArtifactSource> artifactSourceClass = (Class<ArtifactSource>)Class.forName( memento.getArtifactSourceClassName());
			return (ArtifactSource) artifactSourceClass.getConstructor(ArtifactSourceMemento.class).newInstance(memento);
		}
		catch (Exception x)
		{
            LOGGER.error("ArtifactSourceFactory.create() --> Return null. Unable to create an ArtifactSource instance of type [{}]: {}", memento.getArtifactSourceClassName(), x.getMessage());
			return null;
		}
	}
}
