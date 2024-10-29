/***********************************************************************
**                                                                    **
**   c-store.c -- transfer a composite SOP Instance from TCP to disk  **
**                                                                    **
**   usage:  cstore addres port modality [ debug  [ abort ] ]         **
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

#include <stdio.h>
#include <signal.h>
#include <stdlib.h>        /* for atoi() */
#include <sys/types.h>
#include <errno.h>

#include "dcm_net.h"

static void usage(void);
static void diskfree(void);

SOCKET mumpsSock;		/* MUMPS TCP (Connected) socket */
SOCKET dicomSock;		/* DICOM TCP (Connected) socket */
int dcm_transfer_state;	/* state indicator */
int dcm_debug = 0;		/* Debug level (set on command line) */
long dcm_maxbytes = -1; /* Maximum number of bytes to read */

char buffer[BUFFER_SIZE];	/* i/o buffer */

#pragma pack (1)
struct {
	char	type;		/* PDU type (one byte) */
	char	pad;		/* pad (one byte) */
	long	length;		/* length (four bytes) */
} pdu_header;

struct {
	long	length;		/* length (four bytes) */
	char	context;	/* ACSE context */
	char	msg_ctrl;	/* Message Control Header */
} pdv_header;
#pragma pack ()

void main(int argc, char *argv[])
{
	char	*modality;			/* modality configuration */
	char	incoming_file[100];	/* incoming file */
	char	outgoing_file[100];	/* outgoing file */
	long	message_code;		/* code for rest of message */
	u_short	dicomPort;			/* Local Network Port Number */
	u_short	mumpsPort;			/* MUMPS Network Port Number */
	char	dicomNetAddr[100];	/* DICOM IP network address */
	char	*mumpsNetAddr;		/* MUMPS IP network address */
	char	message[200];		/* Message buffer for MUMPS */
	char	error_msg[200];		/* Error message text */
	int		return_error;		/* error code returned by function */
	int		number_read;		/* number of bytes read from input */
	int		close_association;	/* flag to close the association */
	int		connection_dropped;	/* flag to detect a dropped connection */

	system(COLOR_BLUE);

	if (argc < 4)
		usage();


	printf("\nVistA DICOM Storage Provider\n");

	/* Get the arguments */
	mumpsNetAddr = argv[1];
	mumpsPort = atoi(argv[2]);
	modality = argv[3];
	
	if (argc > 4) {
		dcm_debug = atoi(argv[4]);
		printf("\nDebug Level: %d\n", dcm_debug);
	}
	if (argc > 5) {
		dcm_maxbytes = atoi(argv[5]);
		printf("\nAbort after receiving: %ld bytes\n", dcm_maxbytes);
	}

	if (dcm_debug) {
		printf("\nCommand Arguments\n");

		printf("  MUMPS address = \"%s\"\n", mumpsNetAddr);
		printf("     MUMPS Port = %d\n", mumpsPort);
		printf("       Modality = \"%s\"\n", modality);
		printf("   Debug Level  = %d\n", dcm_debug);
		printf("   Abort After  = %ld\n", dcm_maxbytes);
	
#ifdef MS_NT
		printf("\nTrying to initialize WinSock");
#endif
	}

#ifdef MS_NT
	/* Initialize the WinSock library */
	init_winsock();
#endif

	/* Connect to the MUMPS storage controller for database access */

	printf("\nTrying to connect to MUMPS storage controller... ");
	sprintf(error_msg,"\n\
**** Error: Could not connect to the MUMPS storage controller ****\n\n\
Check that the DICOM CSTORE process is active.\n\
Also verify that the IP address \"%s\" & port number \"%d\" are correct.\n",
	mumpsNetAddr, mumpsPort);
	
	init_client(mumpsNetAddr, error_msg, mumpsPort, &mumpsSock);

	sprintf(message,"Connection established for %s",modality);
	send_msg(message, mumpsSock);
	recv_msg(message, mumpsSock);

	/* Parse the return message to get additional parameters from backend */
	sscanf(message, "%ld", &message_code);

	if (message_code < 0) {
		sscanf(message, "%*d %[^\n]", error_msg);
		printf("\n\n*** Error: %s ***\n", error_msg);
		net_close();
		exit_prompt(1);
		exit (0);
	}

	if (message_code == 0) {
		printf("\n\n*** Error: No additional MUMPS partitions are available ***\n");
		printf("\nIncrease the number of TCP/IP connections for your MUMPS license\n");
		net_close();
		exit_prompt(1);
		exit (0);
	}
	
	sscanf(message, "%d %s %s", &dicomPort, incoming_file, outgoing_file);
		
	if (dcm_debug) {
		printf("\n\nConfiguration Parameters\n");
		printf("     DICOM Port = %d\n", dicomPort);
		printf("  Incoming File = \"%s\"\n", incoming_file);
		printf("  Outgoing File = \"%s\"\n", outgoing_file);
		}

	printf("Success!\n");

	diskfree();	/* check for available disk space for the images */
	
	connection_dropped = 0;

	for (;;) {
		/*************************
		**                      **
		**   Association Loop   **
		**                      **
		*************************/

		init_server(dicomNetAddr, dicomPort, &dicomSock, connection_dropped);

		sprintf(message,"Storage SOP Class user %s starting association... ",
			dicomNetAddr);
		send_msg(message, mumpsSock);
		recv_msg(message, mumpsSock);
		check_response(message, "Ready for transfer");
		
		diskfree();	/* check for available disk space for the images */	
		
		close_association = 0;
		connection_dropped = 0;
		dcm_transfer_state = INITIAL_STATE;

		while (!close_association) {

			/******************************
			**                           **
			**   Message Handling Loop   **
			**                           **
			******************************/

			/* read the PDU header to get the PDU type & length */
			number_read = network_read(dicomSock,
				(char *) &pdu_header, PDU_HDR, 1);
		
			if (number_read != PDU_HDR) {
				if (number_read == -1)
					if (dcm_debug) {
						printf("\nError in reading PDU header -- connection dropped\n");
					}
					connection_dropped = 1;
					break;	/* connection dropped */
				if (number_read == 0)
					continue; /* timeout */
				printf("\nError reading PDU header\n");
				net_close();
				exit_prompt(1);
				exit (1);
			}
			
			if (dcm_debug > 1) {
				printf("\nRecving PDU Type: %02XH  Length: %5ld",
					pdu_header.type,
					ntohl(pdu_header.length));
			}

			if (pdu_header.type == PDU_TYPE_DATA) {
				if (return_error = net_read_dataset(incoming_file)) {
					if (return_error == -1) {
						/* connection dropped */
						printf("\nError in reading dataset -- connection dropped\n");
					}
					else {
						printf("\nError #%d returned by net_read_dataset()\n",
							return_error);
					}
					connection_dropped = 1;
					closesocket(dicomSock);
					break;
				}
				if (dcm_debug > 2) printf("\nTransfer State = %d\n", dcm_transfer_state);

				if (dcm_transfer_state == FINAL_STATE) {
					/* notify MUMPS backend */
					send_msg("STORAGE COMPLETE", mumpsSock);
					recv_msg(message, mumpsSock);
					check_response(message, "C-STORE RESPONSE");

					if (net_write_data(outgoing_file, 1,
						MAX_PDU_SIZE, 0, pdv_header.context)) {
						/* connection dropped */
						connection_dropped = 1;
						closesocket(dicomSock);
						break;
					}
					dcm_transfer_state = INITIAL_STATE;
				}

				else if (dcm_transfer_state == EXCEPTION_STATE) {
					/* interrogate MUMPS backend */
					send_msg("WHAT'S UP, DOC?", mumpsSock);
					recv_msg(message, mumpsSock);
					if (net_write_data(outgoing_file, 1,MAX_PDU_SIZE,
						0, pdv_header.context)) {
						/* connection dropped */
						printf("\nError in writing echo response -- connection dropped\n");
						connection_dropped = 1;
						closesocket(dicomSock);
						break;
					}
					dcm_transfer_state = INITIAL_STATE;
				}
			}

			else {
						
				if (net_read_control(incoming_file)) {
					/* connection dropped */
					printf("\nError in reading control dataset -- connection dropped\n");
					connection_dropped = 1;
					closesocket(dicomSock);
					break;
				}

				send_msg("CONTROL PDU", mumpsSock);
				recv_msg(message, mumpsSock);
				
				if (pdu_header.type == PDU_TYPE_RELEASE) {
					close_association = 1;
					check_response(message, "RELEASE OK");
				}
				else {
					check_response(message, "ASSOCIATION OK");
				}
				
				if (net_write_control(outgoing_file)) {
					/* connection dropped */
					printf("\nError in reading PDU header -- connection dropped\n");
					connection_dropped = 1;
					closesocket(dicomSock);
					break;
				}
			}
		}
		
		if (connection_dropped) {
			system(COLOR_YELLOW);
			printf("\n*** Abnormal Client Disconnection! ***\n");	
			send_msg("ABNORMAL CLIENT DISCONNECTION", mumpsSock);
		}

		else {
			printf("\nClient Disconnected!\n");	
			send_msg("CLIENT DISCONNECTED", mumpsSock);
		}

		recv_msg(message, mumpsSock);
		check_response(message, "BYE, BYE");
		closesocket(dicomSock);
	}

	net_close();

	exit_prompt(1);
	exit (0);

}  /* end main() */


void diskfree(void)	/* check for available disk space for the images */
{
	char	message[200];		/* Message on available disk space for images */
	int		i;					/* working variable */

	recv_msg(message, mumpsSock);

	if (atoi(message)) {
		printf("\n");
		for (i=-5;i < (int) strlen(message); i++) printf("*");
		printf("\n*** %s ***\n", &message[3]);
		for (i=-5;i < (int) strlen(message); i++) printf("*");
		}
}


int exit_trap(void)		/* called at OS interrupt */
{
	printf("\n^C hit -- program halted\n");
	fflush(stdout);
	net_close();
	exit_prompt(1);
	exit(0);

	return(0); /* this line is never reached */
}

void usage(void)
{
#ifdef MS_NT
	printf("\tNT (Intel) Version 1.0, %s %s\n",__DATE__, __TIME__);
#else	
	printf("\tDOS Version 1.0, %s %s\n",__DATE__, __TIME__);
#endif
	printf("\
Usage:  cstore <mumps net addr> <mumps port> <modality> [<debug level>]\n\
	<mumps net addr> ---- <mumps host name><space> <mumps port>\n\
	<mumps port> -------- <mumps backend socket number>\n\
	<modality> ---------- name of modality (e.g., CR1, CT2, MR1, etc)\n\
	<debug level> ------- debug messages: 0=none, 1=some, 2=lots\n\
	<abort after> ------- (for testing only) abort after reading nnn bytes\n");
	exit_prompt(0);
	exit(1);
}
