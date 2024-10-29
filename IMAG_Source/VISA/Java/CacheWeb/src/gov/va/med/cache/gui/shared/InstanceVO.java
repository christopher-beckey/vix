/**
 * 
 */
package gov.va.med.cache.gui.shared;

import gov.va.med.cache.gui.client.Utilities;

import java.io.Serializable;
import java.util.List;
import java.util.SortedSet;

import com.google.gwt.user.client.rpc.IsSerializable;

/**
 * @author VHAISWBECKEC
 *
 */
public class InstanceVO
extends AbstractNamedVO
implements Serializable, IsSerializable
{
	private static final long	serialVersionUID	= 1L;
	private String semanticTypeName;
	private CacheInstanceMetadata metadata = null;
	private CacheItemPath path = null;
	
	public InstanceVO(){}
	
	public InstanceVO(String name, CacheInstanceMetadata metadata, String semanticTypeName)
	{
		super(name);
		this.metadata = metadata;
		this.semanticTypeName = semanticTypeName;
	}
	
	public InstanceVO(String name, CacheInstanceMetadata metadata, String semanticTypeName, CacheItemPath path)
	{
		super(name);
		this.metadata = metadata;
		this.semanticTypeName = semanticTypeName;
		this.path = path;
	}

	public CacheInstanceMetadata getMetadata() {
		return metadata;
	}

	public void setMetadata(CacheInstanceMetadata metadata) {
		this.metadata = metadata;
	}

	/**
	 * Indicates a semantic to be applied to this group, the specifics are dependent on the
	 * individual caches, the UI will use this as a CSS style name.
	 * @return
	 */
	public String getSemanticTypeName() {return semanticTypeName;}
	public void setSemanticTypeName(String semanticTypeName) {this.semanticTypeName = semanticTypeName;}
	
	@Override
	public void merge(AbstractNamedVO other) 
	throws MergeException
	{
		if(other instanceof InstanceVO)
		{
			if(this.getMetadata() == null && ((InstanceVO)other).getMetadata() != null)
				this.setMetadata( ((InstanceVO)other).getMetadata() );
			
			super.merge(other);
		}
		else
			throw new MergeException("InstanceVO is unable to merge with '" + other.toString() + "'.");
	}

	
	@Override
	public CacheItemPath getPath()
	{
		if (path != null)
			return path;
		else if( getParent() != null )
		{
			CacheItemPath parentPath = getParent().getPath();
			path = parentPath.createChildPath(this.getName(), false);
			return path;
		}
		else
		{
			logger.severe( "InstanceVO.getParent() returns null." );
			return null;
		}
	}
	
	@Override
	public int getChildCount(){return 0;}
	
	@Override
	public AbstractNamedVO childWithName(String name)
	{
		return null;
	}
	
	@Override
	public boolean removeChild(AbstractNamedVO child){return false;}
	
	@Override
	public SortedSet<AbstractNamedVO> getChildren()
	{
		return null;
	}
}
