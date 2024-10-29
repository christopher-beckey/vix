/**
 * 
 * 
 * Date Created: Mar 14, 2014
 * Developer: Julian Werfel
 */
package gov.va.med.imaging.tiu.router.commands;

import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.core.router.AbstractCommandImpl;
import gov.va.med.imaging.tiu.PatientTIUNoteURN;
import gov.va.med.imaging.tiu.TIUItemURN;
import gov.va.med.imaging.tiu.router.commands.facade.TIUCommandsContext;

/**
 * @author Julian Werfel
 *
 */
public class GetTIUNoteValidCommandImpl
extends AbstractCommandImpl<Boolean>
{
	/**
	 * 
	 */
	private static final long serialVersionUID = -7927225557627308228L;
	private final String typeIndex;
	private final TIUItemURN noteUrn;
	private final PatientTIUNoteURN patientNoteUrn;
	

	/**
	 * @param routingToken
	 * @param typeIndex
	 * @param noteUrn
	 * @param patientNoteUrn
	 */
	private GetTIUNoteValidCommandImpl(TIUItemURN noteUrn, PatientTIUNoteURN patientNoteUrn, String typeIndex)
	{
		super();
		this.typeIndex = typeIndex;
		this.noteUrn = noteUrn;
		this.patientNoteUrn = patientNoteUrn;
	}
	
	public GetTIUNoteValidCommandImpl(TIUItemURN noteUrn,
		String typeIndex )
	{
		this(noteUrn, null, typeIndex);
	}
	
	public GetTIUNoteValidCommandImpl( PatientTIUNoteURN patientNoteUrn,
		String typeIndex )
	{
		this(null, patientNoteUrn, typeIndex);
	}
	
	public GetTIUNoteValidCommandImpl(
		String typeIndex )
	{
		this(null, null, typeIndex);
	}

	/**
	 * @return the typeIndex
	 */
	public String getTypeIndex()
	{
		return typeIndex;
	}

	/**
	 * @return the noteUrn
	 */
	public TIUItemURN getNoteUrn()
	{
		return noteUrn;
	}

	/**
	 * @return the patientNoteUrn
	 */
	public PatientTIUNoteURN getPatientNoteUrn()
	{
		return patientNoteUrn;
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.core.router.AbstractCommandImpl#callSynchronouslyInTransactionContext()
	 */
	@Override
	public Boolean callSynchronouslyInTransactionContext()
	throws MethodException, ConnectionException
	{
		boolean advDirective = getTypeIndex().equals("ADVANCE DIRECTIVE");
		if(advDirective)
		{
			if(getNoteUrn() == null && getPatientNoteUrn() == null)
			{
				throw new MethodException("Image is configured as an ADVANCE DIRECTIVE and must be associated with a ADVANCE DIRECTIVE note.\nPlease select an ADVANCE DIRECTIVE note to store this image");
			}
		}
		
		if(getNoteUrn() == null && getPatientNoteUrn() == null)
		{
			// not an ADVANCE DIRECTIVE and no TIU note - no problem
			return true;
		}
		
		boolean isAdvanceDirectiveNode = false;
		
		if(getNoteUrn() != null)
		{
			isAdvanceDirectiveNode = TIUCommandsContext.getRouter().isTIUNoteAdvanceDirective(getNoteUrn());
		}
		else if(getPatientNoteUrn() != null)
		{
			isAdvanceDirectiveNode = TIUCommandsContext.getRouter().isPatientNoteAdvanceDirective(getPatientNoteUrn());
		}
		
		if ((!isAdvanceDirectiveNode && !advDirective) || (isAdvanceDirectiveNode && advDirective))
        {
            // all good - nothing to do, keep working to store image
        }
        else
        {
            if (!isAdvanceDirectiveNode)
            {
            	throw new MethodException("ADVANCE DIRECTIVE images must be associated with an ADVANCE DIRECTIVE note\n\nSelect an ADVANCE DIRECTIVE Note to continue");
            }
            if (!advDirective)
            {
                throw new MethodException("Images associated with an ADVANCE DIRECTIVE Note must have Doc/Image Type of: ADVANCE DIRECTIVE");
            }
        }		
		
		return true;
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.core.router.AbstractCommandImpl#equals(java.lang.Object)
	 */
	@Override
	public boolean equals(Object obj)
	{
		return false;
	}

	/* (non-Javadoc)
	 * @see gov.va.med.imaging.core.router.AbstractCommandImpl#parameterToString()
	 */
	@Override
	protected String parameterToString()
	{
		return null;
	}

}
