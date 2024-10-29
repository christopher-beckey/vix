@rem =========================================================
@rem Copyright (C) 2011, Laurel Bridge Software, Inc.
@rem 160 East Main Str.
@rem Newark, Delaware 19711 USA
@rem All Rights Reserved
@rem =========================================================
call dcf_vars.bat
if '%2'=='' goto noparams
start "Activate DCF License" /min javaw.exe com.lbs.ActivateDcfLicense.ActivateDcfLicense -u %2
goto oktoleave
:noparams
start "Activate DCF License" /min javaw.exe com.lbs.ActivateDcfLicense.ActivateDcfLicense
:oktoleave

