/***********************************************************************
**                                                                    **
** vista_send_image.c -- transfer a composite object from disc to TCP **
**                                                                    **
**   usage:  vista_send_image port                                    **
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
//#include <signal.h>
//#include <stdlib.h>			/* for atoi() */
//#include <sys/types.h>
//#include <errno.h>

#include <time.h>

#include "dcm_net.h"

static int net_read_pdu_hdr(int dont_care);
static void usage(void);
static int compare(char *, char *);

SOCKET mumpsSock;		/* MUMPS TCP (Connected) socket */
SOCKET dicomSock;		/* DICOM TCP (Connected) socket */
int dcm_transfer_state = INITIAL_STATE;	/* state indicator */
int dcm_debug = 0;		/* Debug level (set on command line ) */
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
	char	associate_out[100];	/* file holding outgoing PDU */
	char	associate_in[100];	/* file to hold incoming PDU */
	char	command_out[100];	/* file holding DCM command */
	char	dataset_out[100];	/* file holding DCM dataset */
	char	c_store_in[100];	/* file holding C-STORE response */
	char	release_out[100];	/* file holding outgoing PDU */
	char	release_in[100];	/* file to hold incoming PDU */
	char	dicomNetAddr[100];	/* DICOM IP network address */
	char	dicomPortNumb[100];	/* DICOM Port number (string) */
	char	*mumpsNetAddr;		/* MUMPS IP network address */
	char	message[200];		/* Message buffer for MUMPS */
	char	error_msg[200];		/* Error message text */
	char	command[100];		/* command portion of message */
	long	max_pdu_size;		/* maximum negotiated PDU size */
	long	offset;				/* offset to first tag beyond meta info */
	long	now;				/* current time */
	char	current_time[30];	/* current time string */
	u_short	dicomPort;			/* DICOM Port Number */
	u_short	mumpsPort;			/* MUMPS Network Port Number */
	int	context =1;				/* DICOM message context */

	/* setup interrupt handler */
	// signal(SIGINT, exit_trap);

	if (argc < 3)
		usage();

	/* Get the arguments */
	mumpsNetAddr = argv[1];
	mumpsPort = atoi(argv[2]);

	if (argc == 4) {
		dcm_debug = atoi(argv[3]);
		printf("\nDebug Level: %d\n", dcm_debug);
		printf("\nCommand Arguments\n");
		printf("MUMPS address = \"%s\"\n", mumpsNetAddr);
		printf("MUMPS Port = %d\n", mumpsPort);
	}

#ifdef MS_NT
	/* Initialize WinSock */
	if (dcm_debug) {
		printf("Trying to initialize WinSock library\n");
	}
	init_winsock();
#endif

	/* Connect to the MUMPS backend system for database access */

	printf("\nConnecting to MUMPS backend system... ");
	sprintf(error_msg,"\n\
*** Error: Could not connect to the MUMPS backend ***\n\n\
Check that the MUMPS ^MAGDIW5 process is running and\n\
that the IP address & port number are correct\n");
	init_client(mumpsNetAddr, error_msg, mumpsPort, &mumpsSock);
	printf("Success!");

	sprintf(message,"Connection established to MUMPS");
	send_msg(message, mumpsSock);
	
	
	
	/************************************************************************
	**                                                                     **
	**   Main loop of program -- get instructions from MUMPS and do them   **
	**                                                                     **
	************************************************************************/
	
	for (;;) {	
	
		recv_msg(message, mumpsSock);
		sscanf(message, "%s", command);
	
		if (strcmp("CONNECT", command) == 0) {
			sscanf(message, "%*s %s %s", dicomNetAddr, dicomPortNumb);
			dicomPort = atoi(dicomPortNumb);
			
			/* Connect to the DICOM Storage SCP */
			printf("\rConnecting to DICOM storage server \"%s\", port %d... ",
				dicomNetAddr, dicomPort);
			sprintf(error_msg,"\n\
*** Error: Could not connect to the DICOM backend ***\n\n\
Check that DICOM Storage Provider is running and\n\
that the IP address & port number are correct\n");
			init_client(dicomNetAddr, error_msg, dicomPort, &dicomSock);
			printf("Success!");
			sprintf(message,"CONNECTION SUCCESSFUL");
			send_msg(message, mumpsSock);
		}

		else if (strcmp("NEW_ASSOCIATION", command) == 0) {
			sscanf(message, "%*s %s %s", associate_out, associate_in);
			if (dcm_debug) {
				printf("Associate Out File = \"%s\"\n", associate_out);
				printf("Associate In File = \"%s\"\n", associate_in);			
			}

			/* Initialize the Association */

			/* send the A-ASSOCIATE-RQ PDU to the DICOM Storage SCP */
			if (dcm_debug) {
				printf("\nSending A-ASSOCIATE-RQ PDU to DICOM Storage SCP... \n"); 
			}
			if (net_write_control(associate_out)) {
				/* connection dropped */
				sprintf(message,"Association Request PDU failed");
				printf("\n%s\n", message);
				send_msg(message, mumpsSock);
				exit_prompt(2);
				net_close();
				exit (1);
			}

			/* receive the A-ASSOCIATE-AC PDU from the DICOM Storage SCP */
			if (dcm_debug) {
				printf("\nRecving A-ASSOCIATE-AC PDU from DICOM Storage SCP... \n"); 
			}

			net_read_pdu_hdr(0);
	
			if (net_read_control(associate_in)) {
				/* connection dropped */
				sprintf(message,"Association Acknowledgement PDU failed");
				printf("\n%s\n", message);
				send_msg(message, mumpsSock);
				exit_prompt(3);
				net_close();
				exit (1);
			}
			
			sprintf(message,"ASSOCIATION ACKNOWLEDGE");
			send_msg(message, mumpsSock);
		}
		
		else if (strcmp("SEND_IMAGE", command) == 0) {
			sscanf(message, "%*s %s %s %ld %ld %s",
				command_out, dataset_out, &max_pdu_size, &offset, c_store_in);
			if (dcm_debug) {
				printf("Command Out File = \"%s\"\n", command_out);
				printf("Dataset Out File = \"%s\"\n", dataset_out);
				printf("Maximum PDU Size = \"%ld\"\n", max_pdu_size);
				printf("First Tag Offset = \"%ld\"\n", offset);
				printf("C-STORE Response File = \"%s\"\n", c_store_in);
			}

			/* Send the COMMAND and DATASET msgs to the DICOM STORAGE SCP */
			/* output the DICOM COMMAND */
			if (dcm_debug) {
				printf("\nSending COMMAND PDU to DICOM Storage SCP... \n"); 
			}
			if (net_write_data(command_out, 1, max_pdu_size, 0, context)) {
				/* connection dropped */
				sprintf(message, "Image transfer Command PDU failed");
				printf("\n%s\n", message);
				send_msg(message, mumpsSock);
				exit_prompt(4);
				net_close();
				exit (1);
			}

			/* output the DICOM DATASET */
			time(&now);
			sprintf(current_time,"%s", ctime(&now));
			current_time[19]=0;
			printf("\n%s  Sending %s", &current_time[4], dataset_out);
			// printf("\nSending image from file %s",dataset_out);
			if (dcm_debug>1) printf("\n");
			else printf("              ");
			if (net_write_data(dataset_out, 0,max_pdu_size, offset, context)) {
				/* connection dropped */
				sprintf(message, "Image transfer Dataset PDU failed");
				printf("\n%s\n", message);
				send_msg(message, mumpsSock);
				exit_prompt(5);
				net_close();
				exit (1);
			}

			/* Read the C-STORE Response */
			if (dcm_debug) {
				printf("\nRecving C-STORE Response PDU from DICOM Storage SCP... \n"); 
			}
			
			net_read_pdu_hdr(0);
					
			if (net_read_command(c_store_in)) {
				/* connection dropped */
				sprintf(message, "C-STORE Response PDU failed");
				printf("\n%s\n", message);
				send_msg(message, mumpsSock);
				exit_prompt(6);
				net_close();
				exit (1);
			}
			sprintf(message,"IMAGE SENT");
			send_msg(message, mumpsSock);	
		}
		
		else if (strcmp("END_ASSOCIATION", command) == 0) {
			sscanf(message, "%*s %s %s", release_out, release_in);
			if (dcm_debug) {
				printf("Release Out File = \"%s\"\n", release_out);
				printf("Release In File = \"%s\"\n", release_in);
			}

			/* Terminate the Association */

			/* send the A-RELEASE-RQ PDU to the DICOM Storage SCP */
			if (dcm_debug) {
				printf("\nSending A-RELEASE-RQ PDU to DICOM Storage SCP... \n"); 
			}
			if (net_write_control(release_out)) {
				/* connection dropped */
				sprintf(message, "Association Release Request PDU failed");
				printf("\n%s\n", message);
				send_msg(message, mumpsSock);
				exit_prompt(7);
				net_close();
				exit (1);
			}

			/* receive the A-RELEASE-RP PDU from the DICOM Storage SCP */
			if (dcm_debug) {
				printf("\nRecving A-RELEASE-RP PDU from DICOM Storage SCP... \n"); 
			}
			

			/* Try to read the A-RELEASE-RP (Association Release Response) PDU      **
			** Some vendors, like BRIT, terminate the TCP/IP connection immediately **
			** after sending the A-RELEASE-RP.  This sets up a race condition where **
			** the connection closing interrupt is received before the PDU can be   **
			** read.  Special handling is required to recognize this condition and  **
			** ignore it.  (The DICOM Standard says the SCU should terminate it.)   */

			if (!net_read_pdu_hdr(1)) {
				// ignore reading the four zero bytes if the pdu header was not read
				if (net_read_control(release_in)) {
					/* connection dropped */
					sprintf(message, "Warning: Association Release Response PDU failed");
					printf("\n%s\n", message);
					// send_msg(message, mumpsSock);
					// exit_prompt(8);
					// net_close();
					// exit (1);
				}
			}

			sprintf(message,"ASSOCIATION ENDED");
			send_msg(message, mumpsSock);	
		}
		
		else if (strcmp("END_SESSION", command) == 0) {
			printf("\nDisconnecting from Storage SOP Class Provider\n");
			
			sprintf(message,"SESSION ENDED");
			send_msg(message, mumpsSock);

			net_close();
			exit (0);
		}
		
		else {
			printf("Unknown message from MUMPS: \"%s\"\n", message);
			exit_prompt(9);
			net_close();
			exit(1);
		}
	}
}  /* end main() */

int exit_trap(void)		/* called at OS interrupt */
{
	printf("\n^C hit -- program halted\n");
	fflush(stdout);
	exit_prompt(10);
	net_close();
	exit(0);

	return (0);
}

int net_read_pdu_hdr(int dont_care)
{
	int	number_read;		/* number of bytes read from input */
	int error = 0;			/* error reading PDU header */

	/* read the PDU header to get the PDU type & length */

	for (;;) {
		number_read = network_read(dicomSock,
		(char *) &pdu_header, PDU_HDR, 5);

		if (number_read == PDU_HDR) break;	/* read ok */
		if (number_read == 0) continue;		/* timeout */

		if (dont_care) {
			fprintf(stderr,"\nWarning: Error reading PDU header -- ");
			fprintf(stderr,"Number read: %d (should be %d)\n",
				number_read, PDU_HDR);
			error = 1;
			break;
		}
		else {
			fprintf(stderr,"\nError reading PDU header --");
			fprintf(stderr,"Number read: %d (should be %d)\n",
				number_read, PDU_HDR);
			exit_prompt(11);
			net_close();
			exit (1);
		}
	}

	if (dcm_debug > 1) {
		printf("\nReceiving PDU Type: %02XH  Length: %5ld",
			pdu_header.type, ntohl(pdu_header.length));
	}
	return (error);
}

void usage(void)
{
#ifdef MS_NT
	printf("\tNT (Intel) Version 1.0, %s %s\n",__DATE__, __TIME__);
#else	
	printf("\tDOS Version 1.0, %s %s\n",__DATE__, __TIME__);
#endif
	printf("\
Usage:  vista_send_image <mumps ip address> <mumps port> [<debug>]\n\
	<mumps ip address> --- ip address of mumps system\n\
	<mumps port> --------- mumps proces socket number\n\
	<debug level> -------- debug messages: 0=none, 1=some, 2=lots\n\
	\n\
Note: vista_send_image is intended to be invoked directly from MUMPS.\n");
	exit_prompt(12);
	exit(1);
}
