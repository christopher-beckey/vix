package gov.va.med.imaging.indexterm.federation.commands.ids;

import java.util.ArrayList;
import java.util.List;

import gov.va.med.imaging.versions.IDSOperationProvider;
import gov.va.med.imaging.versions.ImagingOperation;

public class IndexTermFederationIDSOperationProvider 
extends IDSOperationProvider {

	@Override
	public String getApplicationType() {
		return "Federation";
	}

	@Override
	public String getVersion() {
		return "10";
	}

	@Override
	public List<ImagingOperation> getImagingOperations() {
		List<ImagingOperation> operations = new ArrayList<ImagingOperation>();
		operations.add(new ImagingOperation("IndexTermDataSourceSpi", "/restservices/V10/"));
		return operations;
	}

}
