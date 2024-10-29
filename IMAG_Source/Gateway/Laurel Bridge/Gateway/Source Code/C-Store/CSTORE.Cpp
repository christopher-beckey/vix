/***********************************************************************
**                                                                    **
**   cstore.cpp -- transfer a composite SOP Instance from TCP to disk **
**                                                                    **
**   usage:  cstore [-t] address port modality [ debug  [ abort ] ]   **
**                                                                    **
***********************************************************************/

/*******************************************************************
********************************************************************
**  Property of the US Government.  No permission to copy or      **
**  redistribute this software is given. Use of this software     **
**  requires the user to execute a written test agreement with    **
**  the VistA Imaging Development Office of the Department of     **
**  Veterans Affairs, telephone (301) 734-0100.                   **
**                                                                **
**  The Food and Drug Administration classifies this software as  **
**  a medical device.  As such, it may not be changed in any way. **
**  Modifications of the software may result in an adulterated    **
**  medical device under 21CFR820 and may be a violation of US    **
**  Federal Statutes.                                             **
********************************************************************
*******************************************************************/
#define _CRT_SECURE_NO_DEPRECATE

#include <windows.h>
#include <iostream>
#include <stdio.h>
#include <signal.h>
#include <stdlib.h>        // for atoi()
#include <sys/types.h>
#include <errno.h>
#include <string>

#include "dcm_net.h"

#define THREADCOUNT 5

using namespace std;

void usage(void);
void diskfree(SOCKET mumpsSock, int thread_number);

bool THREAD_MODE = FALSE;	// master single thread / multi-thread control switch

typedef struct association_parameters {
	SOCKET	dicomSock;			// dicom socket for DICOM TCP
	char	dicomNetAddr[100];	// DICOM IP network address
	int		status;				// status of thread
	int		thread_number;		// number of thread (1,2,...,n)
	HANDLE	hConnectEvent;	// TCP/IP connection for a DICOM association
} *passociation_thread;

// status values
#define	READY 0				// thread is ready and available to process an association
#define	WORK_PENDING 1		// main() dispatcher has prepared a request for a thread
#define	BUSY 2				// thread is processing an association

char *mumpsNetAddr;			// MUMPS IP network address
u_short	mumpsPort;			// MUMPS Network Port Number
char *modality;				// modality configuration
int DCM_DEBUG = 0;			// Debug level (set on command line)
long DCM_MAXBYTES = -1;		// Maximum number of bytes to read
HANDLE ghPrintMessageMutex; // Mutex for synchronizing screen output

void main(int argc, char *argv[])
{
	HANDLE	hConnectEvent[THREADCOUNT];
	HANDLE	hThreadArray[THREADCOUNT];
	DWORD	dwThreadIdArray[THREADCOUNT];
	passociation_thread pThreadParamArray[THREADCOUNT];
	SOCKET	mumpsSock = 0;		// MUMPS TCP (Connected) socket
	SOCKET	dicomSock = 0;		// DICOM TCP (Connected) socket
	char	dicomNetAddr[100];	// DICOM IP network address
	char	incoming_file[100];	// incoming file
	char	outgoing_file[100];	// outgoing file
	u_short	dicomPort;			// DICOM Listener Network Port Number
	int		connection_dropped = 0;	// flag to detect a dropped connection
	int		argi=0;				// argument counter
	int		last_thread = -1;	// last thread used for round-robin
	int		next_thread;		// next thread to be used for round-robin
	int		number_threads = 0;	// number of threads (1:THREADCOUNT)
	
	// printf("\nDEBUG line: %d (%s)\n",__LINE__,__FILE__);

	system(COLOR_BLUE);

	if (argc < 4)
		usage();

	printf("\nVistA DICOM Storage Provider\n");
	
	// Get the arguments

	if ( strncmp(argv[1],"-t",2)==0 || strncmp(argv[1],"-T",2)==0 ) {
		THREAD_MODE = TRUE;
		number_threads = atoi(&argv[1][2]);
		if ((number_threads < 1) || 
			(number_threads > THREADCOUNT)) {
			number_threads = THREADCOUNT;
		}
		cout << "\nUsing multi-thread mode... Number of threads = "
			<< number_threads << endl;
		argi++;
	}
	
	mumpsNetAddr = argv[argi+1];
	mumpsPort = atoi(argv[argi+2]);
	modality = argv[argi+3];
	
	if (argc > argi+4) {
		DCM_DEBUG = atoi(argv[argi+4]);
		printf("\nDebug Level: %d\n", DCM_DEBUG);
	}

	if (argc > argi+5) {
		DCM_MAXBYTES = atoi(argv[argi+5]);
		printf("\nAbort after receiving: %ld bytes\n", DCM_MAXBYTES);
	}

	if (DCM_DEBUG) {
		printf("\nCommand Arguments\n");

		printf("  MUMPS address = \"%s\"\n", mumpsNetAddr);
		printf("     MUMPS Port = %d\n", mumpsPort);
		printf("       Modality = \"%s\"\n", modality);
		printf("   Debug Level  = %d\n", DCM_DEBUG);
		printf("   Abort After  = %ld\n", DCM_MAXBYTES);
	}
#ifdef MS_NT
	printf("\nTrying to initialize WinSock");
	// Initialize the WinSock library
	init_winsock();
#endif

	connect_to_mumps(&mumpsSock, &dicomPort, incoming_file, outgoing_file, 0);
	
	if (DCM_DEBUG) {
		printf("\n\nConfiguration Parameters\n");
		printf("     DICOM Port = %d\n", dicomPort);
		printf("  Incoming File = \"%s\"\n", incoming_file);
		printf("  Outgoing File = \"%s\"\n", outgoing_file);
		printf("   MUMPS Socket = %d\n", mumpsSock);
		}
	
	// create the mutex for synchronizing the PrintMessage function
	ghPrintMessageMutex = CreateMutex( 
        NULL,              // default security attributes
        FALSE,             // initially not owned
        NULL);             // unnamed mutex
   
	if (ghPrintMessageMutex == NULL) {
        printf("CreateMutex error: %d\n", GetLastError());
        return;
    }

	if (THREAD_MODE) {
		// create the events and the association threads
		printf("\nStarting Multiple C-Store Threads:  ");
		for (int i=0; i<number_threads ; i++) {

			hConnectEvent[i] = CreateEvent(
				NULL,					// default security attributes
				TRUE,					// manual-reset event
				FALSE,					// initial state is nonsignaled
				NULL					// object name
				);

			// Allocate memory for the thread data

			pThreadParamArray[i] = (passociation_thread) HeapAlloc(GetProcessHeap(),
				HEAP_ZERO_MEMORY, sizeof(association_parameters));
			if (pThreadParamArray[i] == NULL) {
				// If the array allocation fails, the system is out of memory.
				// It might not be able to even print an error message.
				// Try it anyway and then terminate execution.
				printf("\nCan't allocate memory for thread array %d\n", i+1);
				ExitProcess(2);
			}

			pThreadParamArray[i]->dicomSock = 0;
			strcpy(pThreadParamArray[i]->dicomNetAddr,"");
			pThreadParamArray[i]->status = READY;
			pThreadParamArray[i]->thread_number = i+1;
			pThreadParamArray[i]->hConnectEvent = hConnectEvent[i];

			hThreadArray[i] = CreateThread(
				NULL,					// default security attributes
				0,						// use default stack size
				association_thread,		// thread function name
				pThreadParamArray[i],	// argument to thread function
				0,						// use default creation flags
				&dwThreadIdArray[i]);	// returns the thread identifier

			if (i) printf(",");
			printf(" %d",i+1);
		}
		printf("\n");
	}

	for (;;) {  // big forever loop
		
		/*************************
		**                      **
		**   Association Loop   **
		**                      **
		*************************/

		// The main process blocks in listen_server() until there is a DICOM connection

		listen_server(dicomPort, dicomNetAddr, &dicomSock, connection_dropped);

		// DICOM TCP connection request received
		
		if (DCM_DEBUG) printf("\nDICOM Socket: %d\n", dicomSock);

		if (THREAD_MODE) {
			// round-robin algorithm
			next_thread = -1;
			while (next_thread == -1) {
				for (int i=0 ; i<number_threads ; i++) {
					last_thread = ++last_thread < number_threads ? last_thread : 0;
					if (pThreadParamArray[last_thread]->status == READY) {
						next_thread = last_thread;
						break;
					}
				}
				if (next_thread == -1) {
					print_message(0, "All threads are busy");
					Sleep(200);		// wait a little bit for threads to finish
				}
			}
			pThreadParamArray[next_thread]->dicomSock = dicomSock;
			strcpy(pThreadParamArray[next_thread]->dicomNetAddr, dicomNetAddr);
			pThreadParamArray[next_thread]->status = WORK_PENDING;

			// signal the connection event
			if (! SetEvent(pThreadParamArray[next_thread]->hConnectEvent) ) {
				printf("\nSetEvent failed (%d)\n", GetLastError());
			}

			last_thread = next_thread;

			continue;
			
		}
		else {
			association(dicomSock, dicomNetAddr, connection_dropped, mumpsSock,
				incoming_file, outgoing_file, 0);
		}
	}
	
	net_close(dicomSock, mumpsSock);
	exit_prompt(1);
	exit (0);

}  // end main()



/***********************************************************************
**                                                                    **
**  association_thread(...)                                           **
**                                                                    **
**  Each association thread has its own MUMPS backend process.        **
**                                                                    **
**  Connect to the MUMPS backend process and then wait for the        **
**  connection event signal.  When it is received, get the DICOM      **
**  Socket and handle the association request.                        **
**                                                                    **
***********************************************************************/

DWORD WINAPI association_thread(LPVOID lpParam)
{
	passociation_thread pDataArray;
	char	incoming_file[100];		// incoming file
	char	outgoing_file[100];		// outgoing file
	SOCKET	mumpsSock = 0;			// MUMPS TCP (Connected) socket
	u_short	dicomPort = 0;			// Local Network Port Number -- not used here
	SOCKET	dicomSock;				// DICOM TCP (Connected) socket
	char	*dicomNetAddr;			// DICOM IP network address
	int		connection_dropped = 0;	// flag to detect a dropped connection
	int		thread_number =0;		// number of this thread (1,2,...,n)
	DWORD	dwWaitResult;			// wait result
	DWORD	ResetResult;			// reset result
	
	pDataArray = (passociation_thread) lpParam;
	thread_number = pDataArray->thread_number;
	if (DCM_DEBUG) printf("\nStartThread # = %d\n", thread_number);

	connect_to_mumps(&mumpsSock, &dicomPort, incoming_file, outgoing_file,thread_number);

	while (TRUE) {
		// wait for event signal
		dwWaitResult = WaitForSingleObject(
			pDataArray->hConnectEvent,		// event handle
			INFINITE);						// wait forever for the event
		
		pDataArray->status = BUSY;
		
		if (DCM_DEBUG) {
			printf("\nThread #%d\n", pDataArray->thread_number);
		}
		
		dicomSock = pDataArray->dicomSock;
		dicomNetAddr = pDataArray->dicomNetAddr;
		association(dicomSock, dicomNetAddr, connection_dropped,
			mumpsSock, incoming_file, outgoing_file,
			pDataArray->thread_number);
		
		ResetResult = ResetEvent(pDataArray->hConnectEvent);
		pDataArray->dicomSock = 0;
		strcpy(pDataArray->dicomNetAddr,"");
		pDataArray->status = READY;
	}
	return 1;
}



/***********************************************************************
**                                                                    **
**  association(...)                                                  **
**                                                                    **
**  This is the main subroutine for handling an association.          **
**                                                                    **
**  It receives and negotiates the association request and then       **
**  handles each CStore request for the association.                  **
**                                                                    **
***********************************************************************/
void association(
	SOCKET	dicomSock,		// socket for DICOM communications
	char	*dicomNetAddr,	// ip address of Storage SCU
	int		connection_dropped,	// connection termination indicator
	SOCKET	mumpsSock,		// socket for communications with MUMPS backend
	char	*incoming_file,	// file for incoming control PDU, CSTORE.IN
	char	*outgoing_file,	// file for outgoing control PDU, CSTORE.OUT
	int		thread_number)	// 0 for main(), 1, 2, 3, 4, or 5 otherwise
{
	FILE	*incoming = 0;			// pointer to file descriptor for DICOM files
	struct  pdu_header pdu_header;	// Protocol Data Unit
	struct  pdv_header pdv_header;	// Presentation Data Value
	long	dataset_number_read=0;	// number of dataset bytes read from DICOM
	long	dataset_number_written=0; // number of bytes written to DICOM
	int		dcm_transfer_state;		// state indicator
	char	message[200];			// message buffer for MUMPS
	char	dataset_file[200];		// file to hold newly acquired DICOM object
	int		return_error;			// error code returned by function
	int		number_read;			// number of bytes read from input
	int		close_association;		// flag to close the association
	char	text[100];				// text for screen

	if (DCM_DEBUG) {
		printf("\n\nConfiguration Parameters\n");
		printf("Incoming File = \"%s\"\n", incoming_file);
		printf("Outgoing File = \"%s\"\n", outgoing_file);
		printf(" MUMPS Socket = %d\n", mumpsSock);
		printf(" DICOM Socket = %d\n", dicomSock);
		}
	
	sprintf(message,"Storage SOP Class user \"%s\" starting association... ",
		dicomNetAddr);
	send_msg(message, mumpsSock);
	recv_msg(message, mumpsSock);
	check_response(message, "Ready for transfer", mumpsSock);
	
	diskfree(mumpsSock, thread_number);	// check for available disk space for the images

	close_association = 0;
	connection_dropped = 0;
	dcm_transfer_state = INITIAL_STATE;

	while (!close_association) {

		/******************************
		**                           **
		**   Message Handling Loop   **
		**                           **
		******************************/

		// read the PDU header to get the PDU type & length
		number_read = network_read(dicomSock,
			(char *) &pdu_header, PDU_HDR, 1);
	
		if (number_read != PDU_HDR) {
			if (number_read == -1)
				if (DCM_DEBUG) {
					printf("\nError in reading PDU header -- connection dropped\n");
				}
				connection_dropped = 1;
				break;	// connection dropped
			if (number_read == 0)
				continue; // timeout
			print_message(thread_number, "Error reading PDU header\n");
			net_close(dicomSock, mumpsSock);
			exit_prompt(1);
			exit (1);
		}
			
		if (DCM_DEBUG > 1) {
			printf("\nRecving PDU Type: %02XH  Length: %5ld",
				pdu_header.type,
				ntohl(pdu_header.length));
		}

		if (pdu_header.type == PDU_TYPE_DATA) {
			
			return_error = net_read_dataset(&dcm_transfer_state, incoming_file,
				dataset_file, &incoming, dicomSock, mumpsSock, &dataset_number_read,
				&pdu_header, &pdv_header, thread_number);
					
			if (return_error) {
				if (return_error == -1) {
					// connection dropped
					print_message(thread_number,
						"Error in reading dataset -- connection dropped\n");
				}
				else if (return_error == -2) {
					// disk write error
					print_message(thread_number,
						"Error in reading dataset -- disk write error\n");
				}
				else {
					sprintf(text, "Error #%d returned by net_read_dataset()\n",
						return_error);
					print_message(thread_number, text);
				}
				connection_dropped = 1;
				closesocket(dicomSock);
				break;
			}

			if (DCM_DEBUG > 2) printf("\nTransfer State = %d\n", dcm_transfer_state);

			if (dcm_transfer_state == FINAL_STATE) {
				dataset_number_read = 0;
				// notify MUMPS backend
				send_msg("STORAGE COMPLETE", mumpsSock);
				recv_msg(message, mumpsSock);
				check_response(message, "C-STORE RESPONSE", mumpsSock);

				if (net_write_data(outgoing_file, dicomSock, 1,	0,
					pdv_header.context, &dataset_number_written,
					&pdu_header, &pdv_header, thread_number)) {
					// connection dropped
					connection_dropped = 1;
					closesocket(dicomSock);
					break;
				}
				dcm_transfer_state = INITIAL_STATE;
			}

			else if (dcm_transfer_state == EXCEPTION_STATE) {
				// interrogate MUMPS backend
				send_msg("WHAT'S UP, DOC?", mumpsSock);
				recv_msg(message, mumpsSock);
				if (net_write_data(outgoing_file, dicomSock, 1, 0,
					pdv_header.context, &dataset_number_written,
					&pdu_header, &pdv_header, thread_number)) {
					// connection dropped
					print_message(thread_number,
						"Error in writing echo response -- connection dropped\n");
					connection_dropped = 1;
					closesocket(dicomSock);
					break;
				}
				dcm_transfer_state = INITIAL_STATE;
			}
		}

		else {
					
			if (net_read_control(incoming_file, dicomSock, mumpsSock, &pdu_header, thread_number)) {
				// connection dropped
				print_message(thread_number,
					"Error in reading control dataset -- connection dropped\n");
				connection_dropped = 1;
				closesocket(dicomSock);
				break;
			}

			send_msg("CONTROL PDU", mumpsSock);
			recv_msg(message, mumpsSock);
				
			if (pdu_header.type == PDU_TYPE_RELEASE) {
				close_association = 1;
				check_response(message, "RELEASE OK", mumpsSock);
			}
			else {
				check_response(message, "ASSOCIATION OK", mumpsSock);
			}
				
			if (net_write_control(outgoing_file, dicomSock, thread_number)) {
				// connection dropped
				print_message(thread_number,
					"Error in reading PDU header -- connection dropped\n");
				connection_dropped = 1;
				closesocket(dicomSock);
				break;
			}
		}
	}
		
	if (connection_dropped) {
		system(COLOR_YELLOW);
		print_message(thread_number, "*** Abnormal Client Disconnection! ***\n");	
		send_msg("ABNORMAL CLIENT DISCONNECTION", mumpsSock);
	}

	else {
		print_message(thread_number, "Client Disconnected!\n");
		send_msg("CLIENT DISCONNECTED", mumpsSock);
	}

	recv_msg(message, mumpsSock);
	check_response(message, "BYE, BYE", mumpsSock);

	closesocket(dicomSock);

	return;
} // end associate()



/***********************************************************************
**                                                                    **
**  connect_to_mumps(...)                                             **
**                                                                    **
** Call init_client() to make the connection to the MUMPS CStore      **
** backend listener.  Then communicate with it to get the DICOM port  **
** for the instrument and the input and output file name for the PDU  **
** control messages.                                                  **
**                                                                    **
***********************************************************************/
void connect_to_mumps(
	SOCKET	*mumpsSock,		// socket for communications with MUMPS backend
	u_short	*dicomPort,		// port number for MUMPS CStore backend listener
	char	*incoming_file,	// file for incoming control PDU, CSTORE.IN
	char	*outgoing_file,	// file for outgoing control PDU, CSTORE.OUT
	int		thread_number)	// 0 for main(), 1, 2, 3, 4, or 5 otherwise
{
	char	message[200];	// Message buffer for MUMPS
	char	error_msg[200];	// Error message text
	long	message_code;	// code for rest of message

	// Connect to the MUMPS storage controller for database access

	if (thread_number == 0) {
		printf("\nTrying to connect to MUMPS storage controller... ");
	}
	sprintf(error_msg,"\n\
**** Error: Could not connect to the MUMPS storage controller ****\n\n\
Check that the DICOM CSTORE process is active.\n\
Also verify that the IP address \"%s\" & port number \"%d\" are correct.\n",
	mumpsNetAddr, mumpsPort);
	
	init_client(mumpsNetAddr, error_msg, mumpsPort, mumpsSock);

	sprintf(message,"Connection established for %s THREAD %d",modality, thread_number);
	send_msg(message, *mumpsSock);
	recv_msg(message, *mumpsSock);

	// Parse the return message to get additional parameters from backend
	sscanf(message, "%ld", &message_code);

	if (message_code < 0) {
		sscanf(message, "%*d %[^\n]", error_msg);
		printf("\n\n*** Error: %s ***\n", error_msg);
		closesocket(*mumpsSock);
		exit_prompt(1);
		exit (0);
	}

	if (message_code == 0) {
		printf("\n\n*** Error: No additional MUMPS partitions are available ***\n");
		printf("\nIncrease the number of TCP/IP connections for your MUMPS license\n");
		closesocket(*mumpsSock);
		exit_prompt(1);
		exit (0);
	}
	
	sscanf(message, "%d %s %s", dicomPort, incoming_file, outgoing_file);
		
	if (DCM_DEBUG) {
		printf("\n\nConfiguration Parameters\n");
		printf("     DICOM Port = %d\n", *dicomPort);
		printf("  Incoming File = \"%s\"\n", incoming_file);
		printf("  Outgoing File = \"%s\"\n", outgoing_file);
		printf("   MUMPS Socket = %d\n", *mumpsSock);
		}

	if (thread_number == 0) {
		printf("Success!\n");
	}

	diskfree(*mumpsSock, thread_number);// check for available disk space for the images
	
	return;	
}



/***********************************************************************
**                                                                    **
**  diskfree(...)                                                     **
**                                                                    **
**  The MUMPS CStore listener sends information on the available disk **
**  space.  Receive the message and output it if its not null.        **
**                                                                    **
***********************************************************************/

void diskfree(
	SOCKET	mumpsSock,		// socket for communications with MUMPS backend
	int		thread_number)	// 0 for main(), 1, 2, 3, 4, or 5 otherwise
{
	char	message[200];	// Message on available disk space for images
	int		i;				// working variable

	recv_msg(message, mumpsSock);

	if ((thread_number == 0) && (atoi(message))) {
		printf("\n");
		for (i=-5;i < (int) strlen(message); i++) printf("*");
		printf("\n*** %s ***\n", &message[3]);
		for (i=-5;i < (int) strlen(message); i++) printf("*");
		}
}



/***********************************************************************
**                                                                    **
**  print_message(...)                                                **
**                                                                    **
**  Output to the screen must be synchronzed between threads.         **
**	Otherwise one thread's output will overwrite anothers.            **
**	Use the mutex for both multithread mode and single thread mode.   **
**                                                                    **
***********************************************************************/
void print_message(
	int		thread_number,		// 0 for main(), 1, 2, 3, 4, or 5 otherwise
	char	*text)				// message text (one line typically)
{
	DWORD dwWaitResult; 
	
	// wait until it is OK to proceed
    dwWaitResult = WaitForSingleObject( 
            ghPrintMessageMutex,	// handle to mutex
            INFINITE);				// no time-out interval
	printf("\n");
	if (thread_number) {
		printf("%d:", thread_number);
	}
	printf("%s", text);			// output the line of text

    // release the mutex
    ReleaseMutex(ghPrintMessageMutex);
}

void usage(void)
{
#ifdef MS_NT
	printf("\tNT (Intel) Version 2.0, %s %s\n",__DATE__, __TIME__);
#else	
	printf("\tDOS Version 1.0, %s %s\n",__DATE__, __TIME__);
#endif
	printf("\
Usage: mag_cstore [-t[<n>]] <mumps net addr> <mumps port> <modality>\n\
                  [<debug level> [<abort after>]]\n\
	-t[<n>] ------------- threaded mode (n = number of threads - up to five)\n\
	<mumps net addr> ---- <mumps host name><space> <mumps port>\n\
	<mumps port> -------- <mumps backend socket number>\n\
	<modality> ---------- name of modality (e.g., CR1, CT2, MR1, etc)\n\
	<debug level> ------- debug messages: 0=none, 1=some, 2=lots\n\
	<abort after> ------- (for testing only) abort after reading nnn bytes\n");
	exit_prompt(0);
	exit(1);
}
