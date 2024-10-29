
1. Create user credentials 

	a.) Option 1: Use User info and BSE token

		Example:
        var userCredentials = new UserCredentials
        {
            DUZ = "20095",
            FullName = "FRANK,STUART",
            SiteName = "CAMP MASTER",
            SiteNumber = "500",
            SSN = "666669999",
            SecurityToken = "1XWBAS1620-423141_3"
        },

	b.) Option 2: Use Vix security token

        var userCredentials = new UserCredentials
        {
			VixSecurityToken = "<Vix Security Token>"
		}

2. Create and initialize the ServiceClient object

        var serviceClient = new ServiceClient
        {
            BaseAddress = "http://localhost:9911",
            UserCredentials = userCredentials
        };


3. Intialize the study object.

        var study = new DisplayContext
        {
            PatientICN = "10121",
            SiteNumber = "500",
            ContextId = "RPT^CPRS^419^RA^6838988.8477-1^70^CAMP MASTER^^^^^^0"
        };


3. To create a DicomDir zip file for a study, the study needs to be cached first.
   
   a.)	Check if the study is cached in the viewer service. Checking the cache status of the study will trigger a cache
		request if the study is not in cache.

		You could wait until the study is cached (with or without cancel) and then continue with the dicomdir creation 
		process if the study is fully cached.

		Since caching a study could take a while, I recommend using a method that allows you to cancel the method based 
		on user action.

		// create token for cancellation
		var token = new CancellationTokenSource();

		...

		// in a task
		bool isCached = false;

        serviceClient.CacheDisplayContext(study, TimeSpan.FromMilliseconds(2000.0), token.Token, (status) =>
        {
            if (status.StatusCode == ContextStatusCode.Cached)
                isCached = true;
        });

        if (isCached)
        {
            serviceClient.CreateDicomDirZip(study, "AETitle", fileName);
		}		
   
   
   
    

