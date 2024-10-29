/**
 * 
  Package: MAG - VistA Imaging
  WARNING: Per VHA Directive 2004-038, this routine should not be modified.
  Date Created: October 5, 2005
  Site Name:  Washington OI Field Office, Silver Spring, MD
  Developer:  VHAISWPETRB
  Description: 

        ;; +--------------------------------------------------------------------+
        ;; Property of the US Government.
        ;; No permission to copy or redistribute this software is given.
        ;; Use of unreleased versions of this software requires the user
        ;;  to execute a written test agreement with the VistA Imaging
        ;;  Development Office of the Department of Veterans Affairs,
        ;;  telephone (301) 734-0100.
        ;;
        ;; The Food and Drug Administration classifies this software as
        ;; a Class II medical device.  As such, it may not be changed
        ;; in any way.  Modifications to this software may result in an
        ;; adulterated medical device under 21CFR820, the use of which
        ;; is considered to be a violation of US Federal Statutes.
        ;; +--------------------------------------------------------------------+
 */

package gov.va.med.imaging.dicom.dcftoolkit.common.license.gui;

import java.awt.Component;
import java.io.BufferedReader;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.nio.channels.FileChannel;

import javax.swing.JFileChooser;

import gov.va.med.imaging.StringUtil;
import gov.va.med.imaging.dicom.dcftoolkit.common.license.KeyFilter;
/**
 *
 * @author William Peterson
 *
 */
public class LicenseDialog {
    
    private boolean cancellation = false;

   /**
     * Constructor
     *
     * 
     */
    public LicenseDialog() {
        super();
        // 
    }

    public File browseForFile(Component parent) { 
        File filename = null;

        //Create FileChooser object
        JFileChooser chooser = new JFileChooser();
        //Setup JFileChooser.
        chooser.setFileFilter(new KeyFilter());
        chooser.setCurrentDirectory(new File("."));
        chooser.setMultiSelectionEnabled(false);
        
        //Use FileChooser to select correct file.        
        int result = chooser.showOpenDialog(parent);
        if(result == JFileChooser.APPROVE_OPTION){
            filename = chooser.getSelectedFile();
        }
        return filename;
    } 
       
    public void loadFile(File filename) {
        String rootPath = "";
        
        // Fortify change: instantiate separately to close later
        InputStreamReader inReader = null;
        BufferedReader bReader = null;
        FileInputStream sInStream = null;
        FileOutputStream dOutStream = null;
        FileChannel srcChannel = null;
        FileChannel dstChannel = null;
        
        
        try {
            //get the correct path via environment variable            
            Process pc = Runtime.getRuntime().exec("cmd.exe /c echo %DCF_ROOT%");
            inReader = new InputStreamReader(pc.getInputStream());
            bReader = new BufferedReader(inReader);
            rootPath = bReader.readLine();
            
            //Create path to new license location.
            String nuPath = rootPath+"\\cfg\\systeminfo";
            File oldFile = new File(StringUtil.cleanString(nuPath));
            //Delete current systeminfo file.
            oldFile.delete();
            
            // Create channel on the source
            sInStream = new FileInputStream(filename); 
            srcChannel = sInStream.getChannel();
        
            // Create channel on the destination
            dOutStream = new FileOutputStream(oldFile);
            dstChannel = dOutStream.getChannel();
        
            // Copy file contents from source to destination
            dstChannel.transferFrom(srcChannel, 0, srcChannel.size());
        

        } catch(IOException ioe){
        	//
        } finally {
        	// Fortify change: added to close resources
        	try { if(inReader != null) { inReader.close(); } } catch(Exception exc) {/*unrecoverable so do nothing*/}
        	try { if(bReader != null) { bReader.close(); } } catch(Exception exc) {/*unrecoverable so do nothing*/}
        	try { if(sInStream != null) { sInStream.close(); } } catch(Exception exc) {/*unrecoverable so do nothing*/}
        	try { if(dOutStream != null) { dOutStream.close(); } } catch(Exception exc) {/*unrecoverable so do nothing*/}
        	
        	// Fortify change: moved these from try block and reworked
        	try { if(srcChannel != null) { srcChannel.close(); } } catch(Exception exc) {/*unrecoverable so do nothing*/}
        	try { if(dstChannel != null) { dstChannel.close(); } } catch(Exception exc) {/*unrecoverable so do nothing*/}
        }
    }
        
    public void cancel() {
        this.cancellation = true;
    }
    
    public boolean isCancelled() {
        return this.cancellation;
    }
}
