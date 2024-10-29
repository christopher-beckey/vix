package gov.va.med.imaging.core.router.periodiccommands;

import java.util.Iterator;
import java.util.List;

import junit.framework.TestCase;

import org.junit.Test;

public class TestPeriodicCommandConfiguration extends TestCase{

	@Test
	public void testConfigurationLoad() {
		
		PeriodicCommandConfiguration config = PeriodicCommandConfiguration.getConfiguration();
		//PeriodicCommandConfiguration config = new PeriodicCommandConfiguration();
		//config.loadDefaultConfiguration();
		
		List<PeriodicCommandDefinition> list = config.getCommandDefinitions();
		
		Iterator<PeriodicCommandDefinition> iter = list.iterator();
		
		while(iter.hasNext()){
			try{
				PeriodicCommandDefinition definition = iter.next();
				Object[] params = definition.getCommandParameters();
				for(int i=0; i<params.length; i++){
					//String param = (String)params[i];
					System.out.println("Parameters: "+params[i].toString());
				}
			}
			catch(Throwable T){
				fail();
			}
		}
		
		
	}

}
