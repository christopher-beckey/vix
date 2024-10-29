package gov.va.med.imaging.core.router.commands;

import java.util.List;

import gov.va.med.logging.Logger;

import gov.va.med.RoutingToken;
import gov.va.med.imaging.core.interfaces.exceptions.ConnectionException;
import gov.va.med.imaging.core.interfaces.exceptions.MethodException;
import gov.va.med.imaging.core.interfaces.exceptions.ParentREFDeletedMethodException;
import gov.va.med.imaging.datasource.DicomStorageDataSourceSpi;
import gov.va.med.imaging.dicom.common.interfaces.IDicomDataSet;
import gov.va.med.imaging.dicom.router.facade.InternalDicomContext;
import gov.va.med.imaging.dicom.router.facade.InternalDicomRouter;
import gov.va.med.imaging.exchange.business.dicom.DicomServerConfiguration;
import gov.va.med.imaging.exchange.business.dicom.PatientRef;
import gov.va.med.imaging.exchange.business.dicom.ProcedureRef;
import gov.va.med.imaging.exchange.business.dicom.SOPInstance;
import gov.va.med.imaging.exchange.business.dicom.Series;
import gov.va.med.imaging.exchange.business.dicom.Study;
import gov.va.med.imaging.exchange.business.dicom.rdsr.Dose;
import gov.va.med.imaging.transactioncontext.TransactionContext;
import gov.va.med.imaging.transactioncontext.TransactionContextFactory;

public class ProcessRadiationDoseCommandImpl extends AbstractDicomCommandImpl<Boolean>
{

	private static final long serialVersionUID = 1L;
    private static Logger logger = Logger.getLogger(ProcessRadiationDoseCommandImpl.class);

	private IDicomDataSet dds;
	private PatientRef patient;
	private ProcedureRef procedure;
	private Study study;
	private Series series;
	
	public ProcessRadiationDoseCommandImpl(IDicomDataSet dds, PatientRef patient, ProcedureRef procedure, Study study, Series series)
	{
		this.dds = dds;
		this.patient = patient;
		this.procedure = procedure;
		this.study = study;
		this.series = series;
	}

	@Override
	public Boolean callSynchronouslyInTransactionContext() throws MethodException, ConnectionException
	{
		TransactionContext transactionContext = TransactionContextFactory.get();
		transactionContext.setServicedSource(DicomServerConfiguration.getConfiguration().getSiteId());
		
	    InternalDicomRouter router = InternalDicomContext.getRouter();
		
   		List<Dose> doseList = dds.getDose();
   		
   		if (doseList.size() != 0)
   		{
	   		if(logger.isDebugEnabled()){
                logger.debug("{}: Posting radiation dosage data to the database.", this.getClass().getName());}
			for(Dose dose : doseList)
	   		{
	   			try
	   			{
	   				router.postRadiationDose(patient, procedure, study, series, dose);
	   			}
	   			catch(Exception e)
	   			{
	   				String message = "Error storing radiation dose object: " + e.getMessage() + System.getProperty("line.separator");
	   				message += "  Patient: " + patient.getEnterprisePatientId() + System.getProperty("line.separator");
	   				message += "  Accession Number: " + procedure.getDicomAccessionNumber() + System.getProperty("line.separator"); 
	   				message += dose.toString() + System.getProperty("line.separator");
	   				logger.error(message);
	   			}
	   		}
   		}
   		else
   		{
   			logger.warn("Received an RDSR object containing no known templates. No dosage data was stored.");
   		}

	    return true;
	}

	@Override
	protected boolean areClassSpecificFieldsEqual(Object obj)
	{
		// TODO Auto-generated method stub
		return false;
	}

	@Override
	protected String parameterToString()
	{
		// TODO Auto-generated method stub
		return null;
	}
	
}
