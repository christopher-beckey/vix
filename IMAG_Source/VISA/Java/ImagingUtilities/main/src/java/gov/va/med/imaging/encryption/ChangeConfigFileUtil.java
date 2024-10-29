package gov.va.med.imaging.encryption;

import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;

import javax.crypto.AEADBadTagException;
import javax.crypto.Cipher;
import javax.crypto.spec.GCMParameterSpec;
import javax.crypto.spec.SecretKeySpec;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.transform.TransformerFactory;
import javax.xml.transform.dom.DOMSource;
import javax.xml.transform.stream.StreamResult;
import java.io.File;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.Base64;
import java.util.HashMap;
import java.util.Map;
import java.util.regex.Pattern;

/**
 * Poor man version of changing values in config files.
 * Lacking a lot of checking values, exception handling and non-existent logging
 * besides the results reporting. Since this is a temporary thing, just make it happen.
 * Worry about all those things when this becomes more permanent.
 *
 * @author VHAISPNGUYEQ
 *
 */
public class ChangeConfigFileUtil {
    private static final String FILE_PATH_LBL = "filePath";
    private static final String FILE_ELEM_LBL = "file";
    private static final String FIELD_TO_CHANGE_LBL = "fieldToChange";
    private static final String BAK_FILE_EXT_LBL = ".BAKQ";
    private static final String CLEAR_TEXT_LBL = "isClearText";
    private static final String AES_ALG = "AES";
    private static final String GCM_ALG = "AES_256/GCM/NoPadding";
    private static final byte[] OLD_KEY = "0123456789abcdef".getBytes(StandardCharsets.UTF_8);
    private static final byte[] NEW_KEY = "0123456789abcdef0123456789abcdef".getBytes(StandardCharsets.UTF_8);
    private static final String inToken = "xx_6C7fYWEIEknHGtUEVRvMti31QFQ==";
    private static final Map<String, String> filePathToBackupPath = new HashMap<>();
    private final ValidOperation selectedOperation;
    private final String toOperateOn;



    public ChangeConfigFileUtil(String toOperateOn, ValidOperation selectedOperation, String inputInToken){
        this.toOperateOn = toOperateOn;
        this.selectedOperation = selectedOperation;
        try {
            if (!inputInToken.equals(newDecrypt(inToken))){
                System.out.println("Invalid password received");
                System.exit(1);
            }
        }catch (Exception e){
            System.out.println("Error decrypting inToken: " + e.getMessage());
            System.exit(1);
        }
    }

    public void execute(){
        switch(selectedOperation){
            case UPGRADE:
            case DOWNGRADE:
                processControlFile();
                break;
            case ENCRYPT:
                encryptInput();
                break;
            case DECRYPT:
                decryptInput();
                break;
            case HELP:
                printDetailedUsage();
                break;
            default:
                printUsage();
        }
    }

    private void encryptInput(){
        try {
            System.out.println("Encrypted string is: " + newEncrypt(toOperateOn));
        } catch (Exception e) {
            e.printStackTrace();
            printUsage();
            System.exit(0);
        }
    }

    private void decryptInput() {
        try
        {
            System.out.println("Decrypted string is: " + newDecrypt(toOperateOn));
        }
        catch(AEADBadTagException aeadBadTagException)
        {
            try {
                System.out.println("Decrypting string with old algorithm. Result is: " + oldDecrypt(toOperateOn));
            } catch (Exception e) {
                e.printStackTrace();
                printUsage();
                System.exit(1);
            }
        }
        catch (Exception e)
        {
            e.printStackTrace();
            printUsage();
            System.exit(1);
        }
    }

    private void controlFileIsValid(File controlFile){
        if (!controlFile.exists()) {
            System.out.println("Must specify valid control file with upgrade/downgrade operation");
            printUsage();
            System.exit(0);
        }
    }

    private void processControlFile(){
        File controlFile = new File(toOperateOn);
        controlFileIsValid(controlFile);
        try {
            System.out.println("\nOperation: "+ selectedOperation.toString() + ". Given initial file : " + toOperateOn);
            Document controlDoc = getXmlDocument(toOperateOn);
            NodeList fileList = controlDoc.getElementsByTagName(FILE_ELEM_LBL);

            System.out.println("\n--------------------------- START ------------------------------------------\n");

            for (int fileIndex = 0; fileIndex < fileList.getLength(); fileIndex++) {
                Node fileNode = fileList.item(fileIndex);

                if (fileNode.getNodeType() == Node.ELEMENT_NODE) {
                    processFileChange((Element) fileNode, selectedOperation.equals(ValidOperation.UPGRADE));
                }
            }
            deleteBackups();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    /**
     * Helper method to load and convert XML file to a Document object
     *
     * @param filePath 		file path to load
     * @return Document		loaded Document object
     * @throws Exception	catch all exception
     *
     */
    private Document getXmlDocument(String filePath) throws Exception {

        if (filePath == null || filePath.length() == 0) {
            throw new IllegalArgumentException("Can't get document with null or zero length for file path.");
        }

        Document doc = DocumentBuilderFactory.newInstance().newDocumentBuilder().parse(new File(filePath));
        doc.getDocumentElement().normalize();

        return doc;
    }

    private void processNodeChange(Node changeNode, boolean upgrade, boolean isClearText) throws Exception{
        String givenValue = changeNode.getTextContent();

        if (upgrade) {
            if (isClearText){
                changeNode.setTextContent(newEncrypt(givenValue));
            } else {
                changeNode.setTextContent(newEncrypt(oldDecrypt(givenValue)));
            }
        } else { //downgrade
            if (isClearText){
                try {
                    changeNode.setTextContent(newDecrypt(givenValue));
                }catch(Exception exception){
                    System.out.println("Attempted downgrade decryption failed. Leaving value unchanged.");
                    changeNode.setTextContent(givenValue);
                }
            } else {
                try {
                    changeNode.setTextContent(oldEncrypt(newDecrypt(givenValue)));
                }catch(Exception e){
                    System.out.println("Attempted downgrade encryption failed. Leaving value unchanged.");
                    changeNode.setTextContent(givenValue);
                }
            }
        }

    }
    /**
     * Helper method to process the change(s) needed per Element (each file in the given list)
     *
     * @param anElement			an element that contains all the needed data to process
     * @param upgrade If we are upgrading (going from plaintext + old to new) or downgrading
     * @throws Exception		catch all exception
     *
     */
    private void processFileChange(Element anElement, boolean upgrade) {
        if (anElement == null) {
            throw new IllegalArgumentException("Can't process a null element.");
        }

        String filePath = anElement.getElementsByTagName(FILE_PATH_LBL).item(0).getTextContent();
        System.out.println("Configuration file path : " + filePath);
        try {
            createBackupFile(filePath);
        }catch (Exception e){
            System.out.println("Unable to backup file. Ceasing operation on " + filePath + ".");
            return;
        }
        boolean propertiesAreClearText = anElement.getElementsByTagName(CLEAR_TEXT_LBL).item(0).getTextContent()
                .equalsIgnoreCase("true");
        NodeList fieldList = anElement.getElementsByTagName(FIELD_TO_CHANGE_LBL);
        try {
            Document doc = getXmlDocument(filePath);

            for (int fieldIndex = 0; fieldIndex < fieldList.getLength(); fieldIndex++) {
                NodeList changeNodeList = doc.getElementsByTagName(fieldList.item(fieldIndex).getTextContent());
                for (int changeIndex = 0; changeIndex < changeNodeList.getLength(); ++changeIndex) {
                    processNodeChange(changeNodeList.item(changeIndex), upgrade, propertiesAreClearText);
                }
            }

            System.out.println("Saving change(s).......");
            TransformerFactory.newInstance().newTransformer().transform(new DOMSource(doc), new StreamResult(new File(filePath)));
        }catch(Exception e){
            System.out.println("Problem occurred operating on " + filePath + ". Reverting to backup if exists.");
            try{
                restoreBackupFile(filePath);
            }catch (Exception restoreException){
                System.out.println("Unable to revert to backup.");
                e.printStackTrace();
            }
        }

        System.out.println("\n---------------------------- DONE ------------------------------------------\n");
    }

    /**
     * Helper method to decrypt a value using old scheme as required
     *
     * @param encryptedInput				encrypted input
     * @return String			decrypted value
     * @throws Exception			catch all exception
     *
     */
    private String oldDecrypt(String encryptedInput) throws Exception {

        if (encryptedInput == null || encryptedInput.length() == 0) {
            throw new IllegalArgumentException("Can't decrypt a null or zero length value.");
        }

        //System.out.println(encryptedInput + " encrypted value is being decrypted (old scheme)....");
        byte[] encryptedData  = Base64.getDecoder().decode(encryptedInput.trim().replace("-", "+").replace("_", "/"));
        Cipher c = Cipher.getInstance(AES_ALG);
        c.init(Cipher.DECRYPT_MODE, new SecretKeySpec(OLD_KEY, AES_ALG));
        return new String(c.doFinal(encryptedData), StandardCharsets.UTF_8);
    }

    /**
     * Helper method to encrypt a value using old scheme as required
     *
     * @param clearText The clear text to encrypt
     * @return The encrypted, base64-encoded text
     * @throws Exception In the event of any errors
     */
    private String oldEncrypt(String clearText) throws Exception {
        byte[] bytes = clearText.getBytes();
        Cipher cipher = Cipher.getInstance(AES_ALG);
        cipher.init(Cipher.ENCRYPT_MODE, new SecretKeySpec(OLD_KEY, AES_ALG));
        return Base64.getEncoder().encodeToString(cipher.doFinal(bytes));
    }

    /**
     * Helper method to decrypt a value using old scheme as required
     * @param encryptedInput The encrypted text to decode
     * @return The unencrypted, plain text result
     * @throws Exception In the event of any errors
     */
    private String newDecrypt(String encryptedInput) throws Exception {
        if (encryptedInput == null || encryptedInput.length() == 0) {
            throw new IllegalArgumentException("Can't decrypt a null or zero length value.");
        }

        byte[] encryptedData  = Base64.getDecoder().decode(encryptedInput.trim().replace("-", "+").replace("_", "/"));
        Cipher cipher = Cipher.getInstance(GCM_ALG);
        cipher.init(Cipher.DECRYPT_MODE, new SecretKeySpec(NEW_KEY, AES_ALG), new GCMParameterSpec(16 * 8, NEW_KEY));
        return new String(cipher.doFinal(encryptedData), StandardCharsets.UTF_8);
    }

    /**
     * Helper method to encrypt a value using new scheme as required
     *
     * @param clearText				clear text input
     * @return String			encrypted value
     * @throws Exception			catch all exception
     *
     */
    private String newEncrypt(String clearText) throws Exception {

        if (clearText == null || clearText.length() == 0) {
            throw new IllegalArgumentException("Can't encrypt a null or zero length value.");
        }

        try{
            newDecrypt(clearText);
            System.out.println("Encryption called for already encrypted string: " + clearText);
            return clearText;
        }catch(Exception e){
            //this is squelched intentionally as an Exception is expected for intended operation
        }

        //System.out.println(clearText + " clear text value is being encrypted (new scheme)....");
        byte[] encryptedData = clearText.getBytes(StandardCharsets.UTF_8);
        Cipher c =  Cipher.getInstance(GCM_ALG);
        c.init(Cipher.ENCRYPT_MODE, new SecretKeySpec(NEW_KEY, AES_ALG), new GCMParameterSpec(16 * 8, NEW_KEY));

        return Base64.getEncoder().encodeToString(c.doFinal(encryptedData)).replace("+", "-").replace("/", "_");
    }

    /**
     * Helper method to back up the current file being overwritten
     *
     * @param filePath 				file path to operate from
     * @throws Exception			catch all exception
     *
     */
    private void createBackupFile(String filePath) throws Exception {

        if (filePath == null || filePath.length() == 0) {
            throw new IllegalArgumentException("Can't back up a file with null or zero length for file path.");
        }

        String backupPath = filePathToBackupPath.containsKey(filePath) ? filePathToBackupPath.get(filePath) :
                filePath + BAK_FILE_EXT_LBL + System.currentTimeMillis();

        File curFile = new File(backupPath);

        if (curFile.exists()) {
            curFile.delete();
        }

        Files.copy(Paths.get(filePath), Paths.get(backupPath));
        filePathToBackupPath.put(filePath, backupPath);
    }

    private void restoreBackupFile(String filePath) throws Exception{
        System.out.println("Restoring " + filePath + " from backup.");
        if(!filePathToBackupPath.containsKey(filePath)){
            System.out.println("Cannot restore from backup. No backup exists for " + filePath);
            return;
        }

        String backupPath = filePathToBackupPath.get(filePath);
        Files.copy(Paths.get(backupPath), Paths.get(filePath));
    }

    private void deleteBackups(){
        for(String filePath : filePathToBackupPath.keySet()){
            deleteBackupFile(filePath);
        }
    }

    private void deleteBackupFile(String filePath){
        if(!filePathToBackupPath.containsKey(filePath)){
            System.out.println("Cannot delete backup. No backup exists for " + filePath + ".");
            return;
        }

        String backupPath = filePathToBackupPath.get(filePath);
        File toDelete = new File(backupPath);
        if(toDelete.exists())
            toDelete.delete();
    }

    private static void printUsage(){
        System.out.println("Usage: java ChangeConfigFileUtil -operation=[upgrade|downgrade|encrypt|decrypt] " +
                "-input=[full path to control XML file|text to encrypt/decrypt] -password=[password]");
    }

    private void printDetailedUsage(){
        System.out.println("ChangeConfigFileUtil Help: \n" +
                "This file is used to encrypt credentials in VIX/CVIX configuration files or to manually generate " +
                "and print the encrypted or decrypted value. Valid operations are: ");
        printUpgradeHelp();
        printDowngradeHelp();
        printEncryptHelp();
        printDecryptHelp();
    }

    private void printUpgradeHelp(){
        System.out.println("Upgrade: Reads a control file for a list of configuration files and their nodes. Processes" +
                "each file and node to encrypt the values using current encryption algorithm. Input should be valid " +
                "file path to control file with list of valid config files and relevant nodes to operate on. Control " +
                "file format example: " +
                "<files>\n"+
                "\t<file>\n" +
                "\t\t<filePath>C:/full/path/to/file.config</filePath>\n" +
                "\t\t<isClearText>true</isClearText>\n" +
                "\t\t<fieldToChange>aKeystorePassVal</fieldToChange>\n" +
                "\t\t<fieldToChange>aTruststorePassVal</fieldToChange>\n" +
                "\t</file>\n" +
                "</files>\n");
    }

    private void printDowngradeHelp(){
        System.out.println("Downgrade: Reads a control file for a list of configuration files and their nodes. Processes" +
                "each file and node to reverse the values to state prior to upgrade operation. Input should be valid " +
                "file path to control file with list of valid config files and relevant nodes to operate on. Control " +
                "file format example: " +
                "<files>\n"+
                "\t<file>\n" +
                "\t\t<filePath>C:/full/path/to/file.config</filePath>\n" +
                "\t\t<isClearText>true</isClearText>\n" +
                "\t\t<fieldToChange>aKeystorePassVal</fieldToChange>\n" +
                "\t\t<fieldToChange>aTruststorePassVal</fieldToChange>\n" +
                "\t</file>\n" +
                "</files>\n");
    }
    private void printEncryptHelp(){
        System.out.println("Takes a plain text string as input. Encrypts it with the newest algorithm.");
    }
    private void printDecryptHelp(){
        System.out.println("Takes an encrypted string as input. Attempts to decrypt with newest algorithm before falling" +
                "back to legacy algorithm.");
    }

    enum ValidOperation{
        UPGRADE,
        DOWNGRADE,
        ENCRYPT,
        DECRYPT,
        VOID,
        HELP
    }

    private static ChangeConfigFileUtil processArgs(String[] args){
        String toOperateOn = "";
        ValidOperation selectedOperation = ValidOperation.VOID;
        String inputInToken = "";
        for(String arg : args){
            if(containsIgnoreCase(arg,"-password")){
                inputInToken = getArgValue(arg);
            }
            else if(containsIgnoreCase(arg,"-input")){
                toOperateOn = getArgValue(arg);
            }else if(containsIgnoreCase(arg,"-operation")){
                try{
                    selectedOperation = ValidOperation.valueOf(getArgValue(arg).toUpperCase());
                }catch(Exception e){
                    System.out.println("Invalid operation specified");
                    printUsage();
                    System.exit(0);
                }
            }else{
                printUsage();
                System.exit(0);
            }
        }
        return new ChangeConfigFileUtil(toOperateOn, selectedOperation, inputInToken);
    }


    private static String getArgValue(String arg){
        return arg.substring(arg.indexOf("=")+1);
    }

    private static boolean containsIgnoreCase(String toSearch, String searchString){
        return Pattern.compile(Pattern.quote(searchString), Pattern.CASE_INSENSITIVE).matcher(toSearch).find();
    }

    /**
     * Entry point
     *
     * @param args [] 	standard input
     *
     */
    public static void main(String[] args) {

        if (args == null || args.length == 0) {
            printUsage();
            System.exit(0);
        }

        ChangeConfigFileUtil util = processArgs(args);
        util.execute();
    }
}
