/*
 * Created on Oct 31, 2005
 *
 */
package gov.va.med.imaging.business.test.data;

import java.util.HashMap;

/**
 *
 * TODO To change the template for this generated type comment go to
 * Window - Preferences - Java - Code Style - Code Templates
 *
 *
 * @author William Peterson
 *
 */
public class HMapCreator {

    /**
     * Constructor
     *
     * 
     */
    public HMapCreator() {
        super();
    }
    
    public HashMap<String,String> createHashmapOne(){
        
        HashMap<String, String> hMap = new HashMap<String, String>();
        // Empty result expected: no case with specified accession number
        hMap.put("0010,0020","");
        hMap.put("0020,000d","");
        hMap.put("0008,0050","021202-105*");
        hMap.put("0008,0020","");
        hMap.put("0010,0010","");
        hMap.put("0008,0090","");
        hMap.put("0010,0030","");
        hMap.put("0008,0030","");
        hMap.put("0010,0040","");
        hMap.put("0020,0010","");
        hMap.put("0008,1030","");
        
        return hMap;
    }
    
    public HashMap<String,String> createHashmapTwo(){
        
        HashMap<String,String> hMap = new HashMap<String,String>();
        // 1 row expected, 1 case with wildcarded accession number
        hMap.put("0010,0020","");
        hMap.put("0020,000d","");
        hMap.put("0008,0050","022102-105*");
        hMap.put("0008,0020","");
        hMap.put("0010,0010","");
        hMap.put("0008,0090","");
        hMap.put("0010,0030","");
        hMap.put("0008,0030","");
        hMap.put("0010,0040","");
        hMap.put("0020,0010","");
        hMap.put("0008,1030","");
        
        return hMap;
    }

    
    public HashMap<String,String> createHashmapThree(){
        
        HashMap<String,String> hMap = new HashMap<String,String>();
        // 1 row expected, 1 case with specified accession number
        hMap.put("0010,0020","");
        hMap.put("0020,000d","");
        hMap.put("0008,0050","021203-105");
        hMap.put("0008,0020","");
        hMap.put("0010,0010","");
        hMap.put("0008,0090","");
        hMap.put("0010,0030","");
        hMap.put("0008,0030","");
        hMap.put("0010,0040","");
        hMap.put("0020,0010","");
        hMap.put("0008,1030","");
        
        return hMap;
    }
    
    public HashMap<String,String> createHashmapFour(){
        
        HashMap<String,String> hMap = new HashMap<String,String>();
        // 1 row expected, 1 patient with specified name and SSN
        hMap.put("0008,0020", "");          // Study Date
        hMap.put("0008,0030", "");          // Study Time
        hMap.put("0008,0050", "");          // Accession Number
        hMap.put("0010,0010", "c*^k*");     // Patient's Name
        hMap.put("0010,0020", "217103663"); // Patient ID
        hMap.put("0020,0010", "");          // Study ID
        hMap.put("0020,000D", "");          // Study Instance UID
        return hMap;
    }
    
    public HashMap<String,String> createHashmapFive(){
        
        HashMap<String,String> hMap = new HashMap<String,String>();
        // 1 row expected, 1 case with wildcarded accession number
        // case Two has star (*) at end, this one at beginning
        hMap.put("0008,0020", "<UnKnOwN>"); // Study Date
        hMap.put("0008,0030", "");          // Study Time
        hMap.put("0008,0050", "*-19");      // Accession Number
        hMap.put("0010,0010", "");          // Patient's Name
        hMap.put("0010,0020", "");          // Patient ID
        hMap.put("0020,0010", "");          // Study ID
        hMap.put("0020,000D", "");          // Study Instance UID
        return hMap;
    }
    
    public HashMap<String,String> createHashmapSix(){
        
        HashMap<String,String> hMap = new HashMap<String,String>();
        // many rows expected, this Study UID has a lot of images
        hMap.put("0008,0020", "<UnKnOwN>"); // Study Date
        hMap.put("0008,0030", "");          // Study Time
        hMap.put("0008,0050", "");          // Accession Number
        hMap.put("0010,0010", "");          // Patient's Name
        hMap.put("0010,0020", "");          // Patient ID
        hMap.put("0020,0010", "");          // Study ID
        hMap.put("0020,000D", "1.2.840.113754.1.4.573.6989374.8748.1.62501.1333");
        hMap.put("0008,0061", ""); //  O  Modalities in Study
        hMap.put("0008,0090", ""); //  O  Referring Physician's Name
        hMap.put("0008,1030", ""); //  O  Study Description
        hMap.put("0008,1032", ""); //  O  Procedure Code Sequence
        hMap.put("0008,0100", ""); //  O  >Code Value
        hMap.put("0008,0102", ""); //  O  >Coding Scheme Designator
        hMap.put("0008,0103", ""); //  O  >Coding Scheme Version
        hMap.put("0008,0104", ""); //  O  >Code Meaning
        hMap.put("0008,1060", ""); //  O  Name of Physician(s) Reading Study
        hMap.put("0010,0030", ""); //  O  Patient's Birth Date
        hMap.put("0010,0032", ""); //  O  Patient's Birth Time [probably always blank]
        hMap.put("0010,0040", ""); //  O  Patient's Sex
        hMap.put("0010,1000", ""); //  O  Other Patient IDs
        hMap.put("0010,1001", ""); //  O  Other Patient Names
        hMap.put("0010,1010", ""); //  O  Patient's Age
        hMap.put("0010,2160", ""); //  O  Ethnic Group
        hMap.put("0010,2180", ""); //  O  Occupation
        hMap.put("0010,21B0", ""); //  O  Additional Patient History
        hMap.put("0020,1206", ""); //  O  Number of Study Related Series
        hMap.put("0020,1208", ""); //  O  Number of Study Related Instances
        hMap.put("4008,010C", ""); //  O  Interpretation Author
        return hMap;
    }
    
    public HashMap<String,String> createHashmapSeven(){
        
        HashMap<String,String> hMap = new HashMap<String,String>();
        // All required tags present, no data specified, should present error
        hMap.put("0008,0020", "");          // Study Date
        hMap.put("0008,0030", "");          // Study Time
        hMap.put("0008,0050", "");          // Accession Number
        hMap.put("0010,0010", "");          // Patient's Name
        hMap.put("0010,0020", "");          // Patient ID
        hMap.put("0020,0010", "");          // Study ID
        hMap.put("0020,000D", "");          // Study Instance UID
        return hMap;
    }
    
    public HashMap<String,String> createHashmapEight(){
        
        HashMap<String,String> hMap = new HashMap<String,String>();
        // required tags missing, should present error
        hMap.put("0010,0010", "c*^k*");     // Patient's Name
        hMap.put("0010,0020", "217103663"); // Patient ID
        return hMap;
    }
    
    public HashMap<String,String> createHashmapNine(){
        
        HashMap<String,String> hMap = new HashMap<String,String>();
        // Empty result expected
        // There are patients with the wildcarded name
        // There is a patient with the specified SSN
        // But there is no patient who matches both name and SSN
        hMap.put("0008,0020", "");          // Study Date
        hMap.put("0008,0030", "");          // Study Time
        hMap.put("0008,0050", "");          // Accession Number
        hMap.put("0010,0010", "c*^k*");     // Patient's Name
        hMap.put("0010,0020", "317103663"); // Patient ID
        hMap.put("0020,0010", "");          // Study ID
        hMap.put("0020,000D", "");          // Study Instance UID
        return hMap;
    }
    
    public HashMap<String,String> createHashmapTen(){
        
        HashMap<String,String> hMap = new HashMap<String,String>();
        // 1 row expected, 1 patient with specified name and SSN
        hMap.put("0008,0020", "");          // Study Date
        hMap.put("0008,0030", "");          // Study Time
        hMap.put("0008,0050", "");          // Accession Number
        hMap.put("0010,0010", "c*^k*");     // Patient's Name
        hMap.put("0010,0020", "528220000"); // Patient ID
        hMap.put("0020,0010", "");          // Study ID
        hMap.put("0020,000D", "");          // Study Instance UID
        return hMap;
    }
    
    public HashMap<String,String> createHashmapEleven(){
        
        HashMap<String,String> hMap = new HashMap<String,String>();
        // Several rows expected in specified date/time range
        hMap.put("0008,0020", "19900101-20050202");  // Study Date
        hMap.put("0008,0030", "");          // Study Time
        hMap.put("0008,0050", "");          // Accession Number
        hMap.put("0010,0010", "");          // Patient's Name
        hMap.put("0010,0020", "");          // Patient ID
        hMap.put("0020,0010", "");          // Study ID
        hMap.put("0020,000D", "");          // Study Instance UID
        return hMap;
    }
    
    public HashMap<String,String> createHashmapTwelve(){
        
        HashMap<String,String> hMap = new HashMap<String,String>();
        // Error expected: 0920,0010 is an invalid tag
        hMap.put("0008,0020", "19900101-20050202"); // Study Date
        hMap.put("0008,0030", "");          // Study Time
        hMap.put("0008,0050", "");          // Accession Number
        hMap.put("0010,0010", "");          // Patient's Name
        hMap.put("0010,0020", "");          // Patient ID
        hMap.put("0020,0010", "");          // Study ID
        hMap.put("0020,000D", "");          // Study Instance UID
        hMap.put("0920,0010", "");          // Bogus tag
        return hMap;
    }
    
    public HashMap<String,String> createHashmapThirteen(){
        
        HashMap<String,String> hMap = new HashMap<String,String>();
        // 1 row expected, only one image with combination of UIDs
        hMap.put("0008,0020", "<UnKnOwN>"); // Study Date
        hMap.put("0008,0030", "");          // Study Time
        hMap.put("0008,0050", "");          // Accession Number
        hMap.put("0010,0010", "");          // Patient's Name
        hMap.put("0010,0020", "");          // Patient ID
        hMap.put("0020,0010", "");          // Study ID
        hMap.put("0020,000D", "1.2.840.113754.1.4.573.6989374.8748.1.62501.1333");
        hMap.put("0008,0018", "1.2.840.113704.7.1.1762575577.10833.993499397.7"); // Image SOP Instance UID
        hMap.put("0008,0061", ""); //  O  Modalities in Study
        return hMap;
    }


}
