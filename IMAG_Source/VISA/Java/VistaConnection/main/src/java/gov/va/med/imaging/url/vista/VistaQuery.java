package gov.va.med.imaging.url.vista;

import gov.va.med.imaging.url.vista.enums.VistaConnectionType;
import gov.va.med.imaging.url.vista.exceptions.VistaMethodException;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

/**
 * @author VHAANNGilloJ
 *
 */
public class VistaQuery 
implements Cloneable
{	
    private String rpcName;
    private ArrayList<Parameter> parameters;

    public static final int LITERAL = 1;
    public static final int REFERENCE = 2;
    public static final int LIST = 3;
    public static final int WORDPROC = 4;
    public static final int ARRAY = 5;
    public static final int GLOBAL = 6;

    public VistaQuery(String rpcName)
    {
        setRpcName(rpcName);
    }

    public VistaQuery()
    {
    	setRpcName(null);
    }

    public void setRpcName(String rpcName)
    {
        this.rpcName = rpcName;
        this.parameters = new ArrayList<Parameter>();		// is this really intentional? Setting the RPC hacks the parameter list?
    }

    public void clear()
    {
        this.rpcName = "";
        this.parameters.clear();
    }

    /**
     * A clone that at least follows the specification for the clone() method.
     * Copies deep up to the parameter values.  List type parameters are 
     * cloned, but the list members are not.
     */
	protected Object clone() 
    throws CloneNotSupportedException
	{
		VistaQuery clone = new VistaQuery(this.getRpcName());
		
		for( Parameter parameter : parameters )
			clone.parameters.add( (Parameter)parameter.clone() );
		
		return clone;
	}

	public void clone(VistaQuery msg) 
    {
        this.rpcName = msg.getRpcName();
		for( Parameter parameter : msg.getParams() )
		{
	        try
            {
	            this.parameters.add( (Parameter)parameter.clone() );
            } 
			catch (CloneNotSupportedException e)
            {
				// this should never occur because we know that Parameter is clone-able
	            e.printStackTrace();
            }
		}
    }
	
	
    /* (non-Javadoc)
	 * @see java.lang.Object#toString()
	 */
	@Override
	public String toString() {
		return "RPC [Name=" + rpcName + ", parameters=" + parameters.toString() + "]";
	}

	public String getRpcName()
    {
        return this.rpcName;
    }

    public int getParamCount()
    {
        return parameters.size();
    }

    public List<Parameter> getParams() 
    {
        return parameters;
    }

    public void addParameter(int type, String value)
    {
        Parameter vp = new Parameter(type,value);
        parameters.add(vp);
    }

    public void addParameter(int type,String value,String text)
    {
        Parameter vp = new Parameter(type,value,text);
        parameters.add(vp);
    }

	public void addParameter(int type, Map<?, ?> lst)
	{
		Parameter vp = new Parameter(type,lst);
		parameters.add(vp);
	}

    public void addEncryptedParameter(int type, String value) 
    {
        Parameter vp = new Parameter(type, EncryptionUtils.encrypt(value));
        parameters.add(vp);
    }

    public void changeParameterValue(int idx, String value) 
    {
        Parameter p = (Parameter)parameters.get(idx);
        p.setValue(value);
    }

    private String buildApi(String rpcName, String params, String fText)
    {
        String sParams = strPack(params,5);
        return strPack(fText + rpcName + '^' + sParams,5);
    }
    
    public String buildMessage(VistaConnectionType vistaConnectionType) throws VistaMethodException
    {
    	return (vistaConnectionType == VistaConnectionType.oldStyle ? buildOldStyleMessage() : buildNewStyleMessage());
    }
    
    private String buildNewStyleMessage() throws VistaMethodException
    {
    	String sParams = "5";
    	int countWidth = 3; // hard coded?

    	for(Parameter parameter : parameters)
        {
            int pType = parameter.getType();
            if (pType == LITERAL) 
            {
                sParams += "0" + strPack(parameter.getValue(), countWidth) + "f";
            }
            else if (pType == REFERENCE) 
            {
                sParams += "1" + strPack(parameter.getValue(), countWidth) + "f";
            }
            else if ((pType == LIST) || (pType == GLOBAL))
            {
                if (pType == LIST) {
                    sParams += "2";
                } else if (pType == GLOBAL) {
                    sParams += "3";
                }
                
                Map<?, ?> lst = parameter.getList();
                
                boolean isSeen = false;
                if(lst == null)
                {
                	// do nothing, handled below
                }
                else
                {
                	Iterator<?> iter = lst.keySet().iterator();
                	while(iter.hasNext())
                	{
                		if(isSeen)
                			sParams += "t";
                		String key = (String) iter.next();
                		String value = (String) lst.get(key);
                		if((value == null) || (value.length() <= 0))
                			value = String.valueOf((char)1);
                		sParams += strPack(key, countWidth) + strPack(value, countWidth);
                		isSeen = true;                				
                	}
                }
                if(!isSeen)
                {
                	sParams += strPack("", countWidth);
                }
                sParams += "f";
            }
            else if (pType == ARRAY)
            {
                sParams += "2";
                Map<?, ?> lst = parameter.getList();
                boolean isSeen = false;
                if(lst == null)
                {
                    // do nothing, handled below
                }
                else
                {
                    Iterator<?> iter = lst.entrySet().iterator();
                    while(iter.hasNext())
                    {
                        if(isSeen) {
                            sParams += "t";
                        }
                        Map.Entry<?,?> entry = (Map.Entry<?, ?>) iter.next();
                        String key = (String) entry.getKey();
                        String value = (String) entry.getValue();
                        String paddedKey = "\""+key+"\"";
                        if((value == null) || (value.length() <= 0))
                            value = String.valueOf((char)1);
                        sParams += strPack(paddedKey, countWidth);
                        sParams += strPack(value, countWidth);
                        isSeen = true;
                    }

                }
                if(!isSeen)
                {
                    sParams += strPack("", countWidth);
                    
                }
                sParams += "f";
            }
        }
    	
    	if("5".equals(sParams))
    	{
    		sParams += "4f";
    	}
    	
    	// Keep this in case there's a need to print out for debugging 
    	String msg = VistaConnectionType.newStyle.getPrefix() + "11" + countWidth + "02" + 
        		spack("0") + spack(rpcName) + sParams + (char) 4; // not sure if that should be a 4...
    	
    	return msg;
    }

    private String buildOldStyleMessage() throws VistaMethodException
    {
        final String PREFIX = "{XWB}";
        final String HDR = "007XWB;;;;";
        int lstType = 0;

        String sParams = "";
		Map<?, ?> lst = null;
		
		for(Parameter parameter : parameters)
        {
            int pType = parameter.getType();
            if (pType == LITERAL) 
            {
                sParams += strPack('0' + parameter.getValue(),3);
            }
            else if (pType == REFERENCE) 
            {
                sParams += strPack('1' + parameter.getValue(),3);
            }
            else if (pType == LIST)
            {
                sParams += strPack('2' + parameter.getValue(),3);
				lst = parameter.getList();
				lstType = LIST;
            }
            else if (pType == ARRAY)
            {
            	sParams += strPack('2' + parameter.getValue(),3);
            	lst = parameter.getList();
            	lstType = ARRAY;
            }

        }
		// JMW 3/8/2013 P118 - change to use a StringBuilder to support larger results with 
		// more appending to the string (much better performance)
        StringBuilder msg = new StringBuilder();
		if (lst == null) 
		{
			msg.append(strPack(HDR + buildApi(rpcName,sParams,"0"),5));
		} 
		else 
		{
			msg.append(strPack(HDR + buildApi(rpcName,sParams,"1"),5));
			Iterator<?> iter = lst.keySet().iterator();
			if(lstType == LIST)
			{
				while (iter.hasNext()) 
				{
					String key = (String)iter.next();
					String value = (String)lst.get(key);
					if (value == null || value.equals(""))
						value = "\u0001";
					msg.append(strPack(key, 3) + strPack(value, 3));
				}
			}
            else if(lstType == ARRAY)
            {
                  while (iter.hasNext()) 
                  {
                        String key = (String)iter.next();
                        String value = (String)lst.get(key);
                        //pad key here.
                        String paddedKey = "\""+key+"\"";
                        if (value == null || value.equals(""))
                              value = "\u0001";
                        msg.append(strPack(paddedKey,3) + strPack(value,3));
                  }                       
            }

			msg.append("000");
		}
		// JMW 3/8/2013 - when msg was a string this is how it was done. Works fine for smaller strings 
		// but performance is terrible with larger strings
		//msg = PREFIX + strPack(msg,5);
		//return msg;
		
		// use the packLength to not pass the entire string to the method (calling msg.toString() creates a new string object)
		return (PREFIX + packLength(msg.length(), 5) + msg.toString());
    }

    /**
     * Build a fixed length string that is prepended
     * with a length indication.  The length indication
     * is exactly n bytes long.
     * 
     * example:
     * strPack("HelloWorld", 3) returns "010HelloWorld"
     */
    public static String strPack(String s, int n)
    {
        String result = s == null ? "0" : String.valueOf(s.length());
        
        while (result.length() < n) 
        {
        	result = '0' + result;
        }
        
        return (result + (s == null ? "" : s));
    }
    
    /**
     * Return a string containing the length value in length prepended with "0" to make the length of the result n characters.
     * This method is similar to the strPack method except instead of passing the actual string this only takes the length
     * of the string as input.
     * 
     * Also, if the length is more characters than n, the leading characters are truncated (VistA wants it this way)
     * 
     * example:
     * packLength(200, 5) returns "00200"
     * packLength(55112354, 5) returns "12354" 
     * 
     * 
     * @param int 			the length of the string
     * @param int 			the number of characters to return
     * @return String		result
     * 
     */    
    public static String packLength(int length, int n)
    {
    	String result = String.valueOf(length);
    	
    	while (result.length() < n) 
        {
        	result = '0' + result;
        }
    	
    	return (result.length() > n ? result.substring(result.length() - n) : result);
    }
    
    /**
     * Prepends the length of the string in one byte to the value of String, thus String must be less than 256 characters.
     * 
     *   e.g., SPack('DataValue')
     *   returns   #9 + 'DataValue'
     * 
     * @param String					given String to pack
     * @return String					result - packed String
     * @throws VistaMethodException		potential exception
     * 
     */     
    private String spack(String s) throws VistaMethodException
    {
    	int len = s.length();
    	if(len > 255)
    	{
    		throw new VistaMethodException("VistaQuery.spack() --> Length of characters [" + len + "] greater than 255 is not allowed.");
    	}
    
    	return ((char)len) + s;
    }
    

    public class Parameter
    implements Cloneable
    {
        private int type;
        private String value;
        private String text;
		private Map<?, ?> lst;

        public Parameter()
        {
            this.type = -1;
            this.value = "";
        }

        public Parameter(int type, String value)
        {
            this.type = type;
            this.value = value;
        }

        public Parameter(int type, String value, String text)
        {
            this.type = type;
            this.value = value;
            this.text = text;
        }

		public Parameter(int type, Map<?, ?> lst) 
		{
			this.type = type;
			this.value = ".x";
			this.lst = lst;
		}

        public void setType(int type)
        {
            this.type = type;
        }

        public int getType()
        {
            return this.type;
        }

        public void setValue(String value)
        {
            this.value = value;
        }

        public String getValue()
        {
            return this.value;
        }

        public void setText(String text)
        {
            this.text = text;
        }

        public String getText()
        {
            return this.text;
        }

		public void setList(Map<?, ?> lst) 
		{
			this.lst = lst;
		}

		public Map<?, ?> getList() 
		{
			return lst;
		}

		protected Object clone() 
		throws CloneNotSupportedException
		{
			Parameter clone = new Parameter();
			
			clone.type = this.type;
			clone.lst = new HashMap( this.lst );
			clone.text = new String( this.text );
			clone.value = this.value;
			
			return clone;
		}

		/* (non-Javadoc)
		 * @see java.lang.Object#toString()
		 */
		@Override
		public String toString() {
			return "Parameter ["
					+ (value != null ? "value=" + value + ", " : "")
					+ (lst != null ? "list=" + lst.toString() : "") + "]";
		}
    }
}
