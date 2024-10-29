package gov.va.med.imaging.dicom.common.spring;

import org.springframework.context.ApplicationContext;

public class SpringDicomStoreSCUContext {

	private static ApplicationContext context;
	
	public static ApplicationContext getContext()
	{
		return context;
	}
	public static void setContext(ApplicationContext context)
	{
		SpringDicomStoreSCUContext.context = context;
	}

}
