package gov.va.med.imaging.study.web;

import gov.va.med.imaging.facade.configuration.EncryptedConfigurationPropertyString;
import gov.va.med.imaging.facade.configuration.FacadeConfigurationFactory;
import gov.va.med.imaging.facade.configuration.ScpConfiguration;

import java.io.IOException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import gov.va.med.imaging.study.dicom.DicomService;
import gov.va.med.logging.Logger;

public class UpdateSCPConfigurationServlet
        extends HttpServlet
{
    private final static Logger logger = Logger.getLogger(UpdateSCPConfigurationServlet.class);

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws IOException
    {
        try
        {
            String accessCode = request.getParameter("accessCode");
            String verifyCode = request.getParameter("verifyCode");

            // Separate check to handle their lengths being < 6
            if (accessCode == null || verifyCode == null || (accessCode.trim().length() < 6) || (verifyCode.trim().length() < 6)) {
                throw new IllegalArgumentException("Access and/or verify code trimmed lengths must be at least six characters long");
            }

            ScpConfiguration configuration = ScpConfiguration.getConfiguration();

            configuration.setAccessCode(new EncryptedConfigurationPropertyString(accessCode));
            configuration.setVerifyCode(new EncryptedConfigurationPropertyString(verifyCode));

            configuration.storeConfiguration();
            FacadeConfigurationFactory.getConfigurationFactory().clearConfiguration(ScpConfiguration.class);
            DicomService.refresh();
        }
        catch(Exception ex)
        {
            logger.error("Error updating ScpConfiguration, {}", ex.getMessage(), ex);
            response.sendError(500);
        }
    }
}
