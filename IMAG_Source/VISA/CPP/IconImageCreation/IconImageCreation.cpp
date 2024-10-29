// DCMabstract.cpp : Defines the entry point for the console application.
//

#include "StdAfx.h"

JNIEXPORT jint JNICALL Java_gov_va_med_imaging_storage_IconImageCreation_createIconImage
	(JNIEnv * env, jclass cl, jstring dicomFile, jstring iconFile)
{
	int ErrCode= 0;
	char* inputFile=NULL;
	char* outputFile=NULL;

	inputFile = ((char*) env->GetStringUTFChars(dicomFile, NULL));
	outputFile = ((char*) env->GetStringUTFChars(iconFile, NULL));

	HMODULE hDll=GetModuleHandle("IconImageCreation.dll");
	if (!hDll)
		return -1;
	char dllFileName[512]={0};
	GetModuleFileName(hDll,dllFileName,sizeof(dllFileName));
	char * slashPtr=NULL;
	for (int i=sizeof(dllFileName)-1;i>=0;i--)
	{
		if (dllFileName[i]=='\\' || dllFileName[i]=='/')
		{
			slashPtr=dllFileName+i;
			break;
		}
	}
	if (!slashPtr)
		return -1;
	strcpy(slashPtr+1,"IconImageMaker.exe");

	char buf[512];
	sprintf_s(buf,512,"%s %s %s",dllFileName,inputFile,outputFile);

    STARTUPINFO si;
    PROCESS_INFORMATION pi;

    ZeroMemory( &si, sizeof(si) );
    si.cb = sizeof(si);
    ZeroMemory( &pi, sizeof(pi) );
	if (!CreateProcess(NULL,buf,NULL,NULL,FALSE,0,NULL,NULL,&si,&pi))
		return -1;

    // Wait until child process exits.
    WaitForSingleObject( pi.hProcess, INFINITE );

	DWORD rc=0;
	GetExitCodeProcess(pi.hProcess,&rc);
	ErrCode = rc;
	
	// Close process and thread handles. 
    CloseHandle( pi.hProcess );
    CloseHandle( pi.hThread );

	env->ReleaseStringUTFChars(dicomFile, inputFile);
	env->ReleaseStringUTFChars(iconFile, outputFile);

	return ErrCode;
}

