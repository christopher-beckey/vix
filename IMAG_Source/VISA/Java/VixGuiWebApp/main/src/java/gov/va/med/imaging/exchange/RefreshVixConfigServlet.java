package gov.va.med.imaging.exchange;

import gov.va.med.imaging.exchange.business.AbstractBaseServlet;
import gov.va.med.imaging.facade.configuration.FacadeConfigurationFactory;
import gov.va.med.imaging.health.configuration.VixHealthConfigurationLoader;
import gov.va.med.logging.Logger;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;


public class RefreshVixConfigServlet
        extends AbstractBaseServlet
{
    private static final long serialVersionUID = -549495539566440415L;
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException {
        refreshConfigs();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
    {
        refreshConfigs();
    }

    private void refreshConfigs()
    {
        FacadeConfigurationFactory facadeConfigurationFactory = FacadeConfigurationFactory.getConfigurationFactory();
        facadeConfigurationFactory.refreshAllRefreshableConfigs(); //only refreshes facades
        Logger.reconfigure();
        VixHealthConfigurationLoader vixHealthConfigurationLoader = VixHealthConfigurationLoader.getVixHealthConfigurationLoader();
        vixHealthConfigurationLoader.refreshFromFile();
    }

}
