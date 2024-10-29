/***********************************************************************
**                                                                    **
**   dcm_netf.c -- DICOM networking functions for image transfer      **
**                                                                    **
**   These functions are used by c-store.c and send_img.c             **
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
//#include <stdlib.h>		/* for atoi() */
//#include <sys/types.h>
//#include <errno.h>

#include <time.h>

#include "dcm_net.h"

extern int mumpsSock;           /* MUMPS TCP (Connected) socket */
extern int dicomSock;           /* DICOM TCP (Connected) socket */
extern int dcm_transfer_state;  /* state indicator */
extern int dcm_debug;           /* Debug level (set on command line) */
extern long dcm_maxbytes;       /* Maximum number of bytes to read */

extern char buffer[BUFFER_SIZE];/* i/o buffer */

#pragma pack (1)
extern struct {
	char    type;           /* PDU type (one byte) */
	char    pad;            /* pad (one byte) */
	long    length;         /* length (four bytes) */
} pdu_header;

extern struct {
	long			length;         /* length (four bytes) */
	unsigned char   context;        /* ACSE context */
	char			msg_ctrl;       /* Message Control Header */
} pdv_header;
#pragma pack ()

/***********************************************************************
**                                                                    **
**  void init_winsock()                                               **
**                                                                    **
**  initializes the Windows Sockets Library                           **
**                                                                    **
***********************************************************************/
#ifdef MS_NT
void init_winsock()
{
	WORD wVersionRequested = MAKEWORD(1,1); // WinSock 1.1 requested
	WSADATA wsaData;			// WinSock details
	int nErrorStatus;			// error status

	nErrorStatus = WSAStartup(wVersionRequested, &wsaData);
	if (nErrorStatus != 0) {
			printf("\nThe WinSock initialization has failed\n");
	}
}
#endif

/***********************************************************************
**                                                                    **
**  int net_read_control(incoming_file)                               **
**                                                                    **
**  read a DICOM Association Control PDU with error checking          **
**                                                                    **
**  argument:                                                         **
**    char *incoming_file -- ptr to name of incoming message file     **
**                                                                    **
***********************************************************************/

int net_read_control(char *incoming_file)
{
	FILE    *incoming;              /* incoming file descriptor pointer */
	long    remaining_pdu_length;   /* PDU length */
	int     number_read = 0;        /* number of bytes read from input */
	int     error = 0;              /* network error indicator */
	int     i;                      /* working variable */

	remaining_pdu_length = ntohl(pdu_header.length);

	/* first try to read the remander of the PDU data */
	if (remaining_pdu_length > 0)
	{
		number_read = network_read(dicomSock, buffer,
			  (int) remaining_pdu_length, 1);
		if (number_read == -1 )
		{
			/* connection dropped */
			error = -1;
			return (error);
		}
	}

	/* open the incoming file to hold the PDU */
	if ((incoming = fopen(incoming_file, "wb")) == NULL) {
		printf("\nCould not open incoming file %s\n",
			 incoming_file);
		exit_prompt(1);
		exit (1);
	}

	/* Output PDU Header to disk file */
	if (i = disk_write(incoming, (char *) &pdu_header, PDU_HDR)) {
		printf("\nError writing control PDU to disk\n");
		fclose(incoming);
		net_close();
		exit_prompt(1);
		exit (i);
	}

	/* write the above data from the PDU to the file */
	if (number_read > 0)
	{
		if (i = disk_write(incoming, buffer, number_read))
		{
			printf("\nError writing control PDU to disk\n");
			fclose(incoming);
			net_close();
			exit_prompt(1);
			exit (i);
		}
		remaining_pdu_length -= number_read;
	}

	/* Loop reading remainder of TCP/IP data and saving in disk file */
	while (remaining_pdu_length > 0) {
		number_read = network_read(dicomSock, buffer,
			(int) remaining_pdu_length, 1);
		if (number_read == -1 ) {
			/* connection dropped */
			error = -2;
			break;
		}
		if (number_read > 0) {
			if (i = disk_write(incoming, buffer, number_read)) {
				printf("\nError writing control PDU to disk\n");
				fclose(incoming);
				net_close();
				exit_prompt(1);
				exit (i);
			}
			remaining_pdu_length -= number_read;
		}
	}

	fclose(incoming);
	return (error);
}

/***********************************************************************
**                                                                    **
**  int net_write_control(outgoing_file)                              **
**                                                                    **
**  write a DICOM Association Control PDU with error checking         **
**                                                                    **
**  MUMPS surrogate generates the PDU response in the outgoing file.  **
**  This function copies the outgoing file to the dicomSock.          **
**                                                                    **
**  argument:                                                         **
**    char *outgoing_file -- ptr to name of outgoing message file     **
**                                                                    **
***********************************************************************/

int net_write_control(char *outgoing_file)
{
	FILE    *outgoing;              /* outgoing file descriptor pointer */
	int     number_read;            /* number of bytes read from input */
	int     number_written;         /* number of bytes written to file */

	int     error = 0;              /* network error indicator */

	/* open the outgoing file holding the PDU */
	if ((outgoing = fopen(outgoing_file, "rb")) == NULL) {
		printf("\nCould not open outgoing file %s\n",
			 outgoing_file);
		exit_prompt(1);
		exit (1);
	}

	/* copy the outgoing file to the buffer */
	number_read = disk_read(outgoing, buffer, BUFFER_SIZE);
	fclose(outgoing);

	/* write the buffer to the dicomSock */
	number_written = network_write(dicomSock, buffer, number_read);
	if (number_written != number_read) {
		printf("\nError writing control PDU to DICOM socket\n");
		error = -1;              /* network write error */
	}

	return (error);
}

/***********************************************************************
**                                                                    **
**  int net_read_command(incoming_file)                               **
**                                                                    **
**  read a DICOM Command PDU with error checking                      **
**                                                                    **
**  argument:                                                         **
**    char *incoming_file -- ptr to name of incoming message file     **
**                                                                    **
***********************************************************************/

int net_read_command(char *incoming_file)
{
	FILE    *incoming;              /* incoming file descriptor pointer */
	long    remaining_pdu_length;   /* PDU length */
	int     number_read;            /* number of bytes read from input */
	int     last_fragment;          /* PDV message control header switch */
	int     data_cmd_switch;        /* PDV message control header switch */

	/* open the incoming file to hold the PDU */
	if ((incoming = fopen(incoming_file, "wb")) == NULL) {
		printf("\nCould not open incoming file %s\n",
			 incoming_file);
		exit_prompt(1);
		exit (1);
	}

	remaining_pdu_length = ntohl(pdu_header.length);

	/* copy all of the data fragments to the incoming file */

	while (remaining_pdu_length > 0) {

		/* transfer the PDV fragment from network to buffer */

		number_read = net_read_pdv(dicomSock, buffer,
			BUFFER_SIZE);

		if (number_read == -1) {
			printf("\nnet_read_command() -- network connection dropped\n");
			return (-1);	/* network connection dropped */
		}

		data_cmd_switch = 0x01 & pdv_header.msg_ctrl;
		last_fragment   = 0x02 & pdv_header.msg_ctrl;

		if (data_cmd_switch != COMMAND_FRAGMENT) {
			printf("\nWarning: Not Command Fragment\n");
		}

		if (last_fragment != LAST_FRAGMENT) {
			printf("(\nWarning: Not Last Fragment\n");
		}

		/* transfer the PDV fragment from the buffer to disk */

		disk_write(incoming, buffer, number_read);
		remaining_pdu_length -= number_read + PDV_HDR;

	}

	fclose(incoming);
	return (0);
}

/***********************************************************************
**                                                                    **
**  int net_read_dataset(incoming_file)                               **
**                                                                    **
**  read a DICOM Protocol Data Value with appropriate error checking  **
**                                                                    **
**  argument:                                                         **
**    char *incoming_file -- ptr to name of incoming command file     **
**                                                                    **
***********************************************************************/

int net_read_dataset(char *incoming_file)
{

	static char message[100];       /* Message buffer for MUMPS */

	static FILE     *incoming;      /* incoming file descriptor pointer */

	long    remaining_pdu_length;   /* PDU length */
	int     number_read;            /* number of bytes read from input */
	int     last_fragment;          /* PDV message control header switch */
	int     data_cmd_switch;        /* PDV message control header switch */
	long	now;					/* current time */
	char	current_time[30];		/* current time string */

	remaining_pdu_length = ntohl(pdu_header.length);

	/* copy all of the data fragments to the incoming file */

	while (remaining_pdu_length > 0) {

		/* transfer the PDV fragment from network to buffer */

		number_read = net_read_pdv(dicomSock, buffer,
			BUFFER_SIZE);

		if (number_read == -1) {
			printf("\nnet_read_dataset() -- network connection dropped\n");
			return (-1);	/* network connection dropped */
		}

		data_cmd_switch = 0x01 & pdv_header.msg_ctrl;
		last_fragment   = 0x02 & pdv_header.msg_ctrl;

		if (data_cmd_switch == COMMAND_FRAGMENT) {
			/* process an incoming command fragment */

			switch (dcm_transfer_state) {
			case INITIAL_STATE:
				incoming = fopen(incoming_file, "wb");
				if (incoming == NULL) {
					printf("\nCould not open incoming msg file %s\n",
						 incoming_file);
					return (101);
				}
			case COMMAND_STATE:     break;
			case INTERIM_STATE:     return (102);
			case DATASET_STATE:     return (103);
			default:                return (104);
			}

			dcm_transfer_state = COMMAND_STATE;
		}

		else {
			/* process an incoming dataset fragment */

			switch (dcm_transfer_state) {
			case INITIAL_STATE:     return (105);
			case COMMAND_STATE:     return (106);
			case INTERIM_STATE: 	break;
			case DATASET_STATE:     break;
			default:                return (108);
			}

			dcm_transfer_state = DATASET_STATE;
		}

		/* transfer the PDV fragment from the buffer to disk */

		disk_write(incoming, buffer, number_read);
		remaining_pdu_length -= number_read + PDV_HDR;

		if (last_fragment == LAST_FRAGMENT) {
			fclose(incoming);
			if (dcm_transfer_state == COMMAND_STATE) {
				/* end of a command fragment */

				/* get dataset filename from MUMPS surrogate */
				sprintf(message,"DATASET PDU %d", pdv_header.context);
				send_msg(message, mumpsSock);
				recv_msg(message, mumpsSock);
				if (strcmp(message,"NON-IMAGE DATASET")==0) {
					dcm_transfer_state = EXCEPTION_STATE;
				}
				else {

					incoming = fopen(message, "ab");
					if (incoming == NULL) {
						printf("\nCould not open incoming msg file %s\n",
							 message);
						return (107);
					}

					time(&now);
					sprintf(current_time,"%s", ctime(&now));
					current_time[19]=0;
					printf("\n%s  Input file %s          ",
						&current_time[4], message);

					dcm_transfer_state = INTERIM_STATE;
				}
			}
			else {
				/* end of a dataset fragment */
				dcm_transfer_state = FINAL_STATE;
			}
		}
	}

	return (0);
}

/***********************************************************************
**                                                                    **
**  int net_read_pdv(socket, buffer, count)                           **
**                                                                    **
**  read a DICOM Protocol Data Value with appropriate error checking  **
**                                                                    **
**  arguments:                                                        **
**    SOCKET socket --- connected TCP socket                          **
**    char *buffer -- input buffer pointer                            **
**    int count -- number of bytes to write                           **
**                                                                    **
***********************************************************************/

int net_read_pdv(SOCKET socket, char *buffer, int count)
{
	int     number_read;            /* number of bytes read from input */
	static long dataset_number_read=0;/* number of bytes read for dataset */

	/* read the 6-byte PDV hdr to get the length, context, & ctrl */
	number_read = network_read(socket, (char *) &pdv_header, PDV_HDR, 1);
	if (number_read != PDV_HDR) {
		if (number_read == -1) {
			printf("\nnet_read_pdv() -- network connection dropped\n");
			return (-1);    /* network connection dropped */
		}
		printf("\nnetwork_read() error: %d\n", number_read);
		printf("\nError reading PDV header\n");
		closesocket(socket);
		exit_prompt(1);
		exit (1);
	}

	pdv_header.length = ntohl(pdv_header.length) - 2;

	if (dcm_debug > 1) {
		printf("   Context: %d   MSG CTRL: %d           ",
			0xff & pdv_header.context,
			0xff & pdv_header.msg_ctrl);
	}

	/* output running count of number of data bytes transferred */
	if (! (0x01 & pdv_header.msg_ctrl)) {
		dataset_number_read += pdv_header.length;
		printf("\b\b\b\b\b\b\b\b\b\b%10ld", dataset_number_read);
		if ((dcm_maxbytes > 0) && (dataset_number_read > dcm_maxbytes))
		{
			closesocket(socket);
			dataset_number_read = 0;
			printf ("\nDeliberate abort after %ld bytes.\n", dcm_maxbytes);
			printf ("If running this program in production mode,\n");
			printf ("start the program without specifying an 'abort after' parameter.\n");
			return (-1);
		}
		if (pdv_header.msg_ctrl == 2) {
			dataset_number_read = 0;
		}
	}

	/* read the PDV data */
	number_read = network_read(socket, buffer, (int) pdv_header.length, 1);
	if (number_read != (int) pdv_header.length ) {

		if (number_read == -1) {
			return (-1);    /* network connection dropped */
		}

		printf("\nError reading PDV data, %u bytes input\n",
			number_read);
		closesocket(socket);
		exit_prompt(1);
		exit (1);
	}

	return (number_read);
}

/***********************************************************************
**                                                                    **
**  net_write_data(outgoing_file, data_cmd_switch, max_pdu_size,      **
**                 offset, context)                                   **
**                                                                    **
**  write a DICOM Association data PDU with error checking            **
**                                                                    **
**  argument:                                                         **
**    char *outgoing_file --- ptr to name of outgoing message file    **
**    int  data_cmd_switch -- 0 = dataset, 1 = command                **
**    long max_pdu_size ----- maximum negotiated pdu size             **
**    long offset ----------- offset beyond meta info to first tag    **
**    int  context ---------- ACSE context                            **
**                                                                    **
***********************************************************************/

int net_write_data(char *outgoing_file, int data_cmd_switch, long max_pdu_size, long offset, int context)
{
	FILE    *outgoing;              /* outgoing file descriptor pointer */

	int     number_to_be_read;      /* number of bytes to read from input */
	int     number_read;            /* number of bytes read from input */
	int     number_written;         /* number of bytes written to file */
	int     eof = 0;                /* end of input file indicator */
	static long dataset_number_written=0; /* number of bytes written */
	int		a, i;

	number_to_be_read = max_pdu_size - PDV_HDR - PDU_HDR;

	if (dcm_debug) printf("\nOutgoing file: %s", outgoing_file);

	/* open the outgoing file to hold the message */
	if ((outgoing = fopen(outgoing_file, "rb")) == NULL) {
		printf("\nCould not open outgoing file %s\n",
			 outgoing_file);
		exit_prompt(1);
		exit (1);
	}

	/* seek to the first tag beyond the DICOM meta information */
	fseek(outgoing, offset, 0);

	/* loop sending one PDV per PDU until done */
	while (!eof) {
		/* copy the outgoing_file to the buffer */
		number_read = disk_read(outgoing, buffer, number_to_be_read);

		if (feof(outgoing)) {
				eof = 1;        /* set end of file */
		} else if (number_read != number_to_be_read) {
			if (ferror(outgoing)) {
				printf("\nDisk read error in net_write_data()\n");
				exit_prompt(1);
				exit (3);
			}               
			else {
				printf("\nUnknown disk read error in net_write_data()\n");
				exit_prompt(1);
				exit (4);
			}
		}

		/* fill in the PDU and PDV headers */
		pdu_header.type = PDU_TYPE_DATA;
		pdu_header.pad  = 0;
		pdu_header.length = htonl(number_read + PDV_HDR);

		pdv_header.length = htonl(number_read +2);
		pdv_header.context = 0xff & context;
		pdv_header.msg_ctrl = data_cmd_switch | (eof << 1);

		if (dcm_debug>1) {
			printf("\nSending PDU Type: %02XH  Length: %5d",
				pdu_header.type,
				ntohl(pdu_header.length));
			printf("   Context: %d   MSG CTRL: %d          ",
				0xff & pdv_header.context,
				0xff & pdv_header.msg_ctrl);
		}
		
		/* output the PDU and PDV headers */
		number_written = network_write(dicomSock, (char *) &pdu_header,
			PDU_HDR);
		if (dcm_debug > 2)
			printf ("\nWrite PDU, %d of %d characters written", number_written, PDU_HDR);
		if (number_written != PDU_HDR) {
			printf("\nError writing PDU hdr to socket\n");
			return (-1);             /* network write error */
		}

		number_written = network_write(dicomSock, (char *) &pdv_header,
			PDV_HDR);
		if (dcm_debug > 2)
			printf ("\nWrite PDV, %d of %d characters written", number_written, PDV_HDR);
		if (number_written != PDV_HDR) {
			printf("\nError writing PDV hdr to socket\n");
			return (-1);             /* network write error */
		}

		/* write the data in the buffer to the DICOM socket */
		number_written = network_write(dicomSock, buffer, number_read);
		if (dcm_debug > 2)
		{
			for (i = 0; i < number_read; i++)
			{
				if (!(i % 16)) printf ("\n");
				a = buffer [i];
				if (a < 0) a += 256;
				if ((a > 31) && (a < 127))
					printf (" '%c'", a);
				else
					printf ("%4d", a);
			}
			printf ("\nWrite Data, %d of %d characters written", number_written, number_read);
		}
		if (number_written != number_read) {
			printf("\nError writing DATA PDU to socket\n");
			return (-1);             /* network write error */
		}

		/* output running count of number of data bytes transferred */
		if (! (0x01 & pdv_header.msg_ctrl)) {
			// dataset_number_written += pdv_header.length;
			dataset_number_written += number_written;
			printf("\b\b\b\b\b\b\b\b\b\b%10ld", dataset_number_written);
			if (pdv_header.msg_ctrl == 2) {
				dataset_number_written = 0;
			}
		}
	};

	fclose(outgoing);
	return (0);
}

/***********************************************************************
**                                                                    **
**  int network_read(socket, buffer, count, timeout)                  **
**                                                                    **
**  read bytes from the network with the appropriate error checking   **
**                                                                    **
**  arguments:                                                        **
**    SOCKET socket ---- connected TCP socket                         **
**    char *buffer -- input buffer pointer                            **
**    int count ----- number of bytes to read                         **
**    long timeout ----- network read timeout value (0 don't block)   **
**                                                                    **
***********************************************************************/

int network_read(SOCKET socket, char *buffer, int count, long timeout)
{

	int     to_be_read;     /* number of bytes to be read from network */
	int     total_read = 0; /* total number of bytes read from network */
	int     just_read;      /* number of bytes read by last operation */
	u_long  wCntr = 0;      /* work variable */
	static  u_long ticker;  /* counter for no message time-outs */

	struct  timeval wait;   /* time delay for select() */
	struct  fd_set readflds;/* structure for select() */
	struct  fd_set exceptfds;
	int     activity_flag;  /* return code from select() */
	int		last_error = 0;	/* error code from MS NT */

	wait.tv_sec = 1;        /* wait one second for select() */
	wait.tv_usec = 0;


	to_be_read = count < BUFFER_SIZE ? count : BUFFER_SIZE;
	if (dcm_debug > 2) printf ("\nnetwork_read: count = %d, timeout = %d\n", count, timeout);
	while (to_be_read > 0) {
		/* check for incoming network activity */
		FD_ZERO(&readflds);
		FD_SET(socket, &readflds);
		FD_ZERO(&exceptfds);
		FD_SET(socket, &exceptfds);
		activity_flag = select(socket+1, &readflds,
			(struct fd_set *) NULL,
			&exceptfds, &wait);
		if (activity_flag == -1) {
			printf("\nselect() error in network_read()\n");
			exit_prompt(1);
			exit (1);
		}

		if (activity_flag) {
			if ((just_read=recv(socket, &buffer[total_read],
				to_be_read, 0)) == SOCKET_ERROR) {
#ifdef MS_NT
				last_error = WSAGetLastError();

#endif
				if (errno == ENETRESET) {
					/* Network conection dropped */
					return -1;
				}

				if (errno != EWOULDBLOCK) {
					if (dcm_debug) {
						printf("\nError in network_read()");
						printf("\ttotal read: %d, errno=%d",
							total_read,errno);
#ifdef MS_NT
						printf("\nMS NT Socket Error #%d", last_error);
#endif
					}
					system(COLOR_YELLOW);
					printf("\nPeer DICOM Application Entity dropped the TCP/IP circut connection\n");
					return -1;
					// net_close();
					// exit_prompt(1);
					// exit (8);
				}
			}

			else if (just_read == 0) {
				if (wCntr++ > LOOP_LIMIT)  {
					printf("\nnetwork_read(): Timeout\n");
					printf("\ttotal read: %d",
						total_read);
					return -1;
					// net_close();
					// exit_prompt(1);
					// exit (9);
				}
			}
			
			else {
				to_be_read -= just_read;
				total_read += just_read;
			}
		}

		else {
			/* a network timeout occurred */
			printf("%c\b","/|\\-"[ticker++ % 4]);
			if (timeout == 0) break;  /* force return */
		}
	}
	if (dcm_debug > 2) printf ("\nnetwork_read: requested = %d, read = %d\n", to_be_read, total_read);

	return total_read;
}

/***********************************************************************
**                                                                    **
**  int network_write(socket, buffer, count)                          **
**                                                                    **
**  write bytes to the network with the appropriate error checking    **
**                                                                    **
**  arguments:                                                        **
**    SOCKET socket --- connected TCP socket                          **
**    char *buffer -- input buffer pointer                            **
**    int count -- number of bytes to write                           **
**                                                                    **
***********************************************************************/

int network_write(SOCKET socket, char *buffer, int count)
{

	int     to_be_written;  /* number of bytes to be written to network */
	int     total_written=0;/* total number of bytes written to network */
	int     just_written;   /* number bytes written by last operation */
	static  u_long ticker;  /* counter for no message time-outs */

	struct  timeval wait;           /* time delay for select() */
	struct  fd_set writeflds;       /* structure for select() */
	int     activity_flag = 0;      /* return code from select() */
	
	wait.tv_sec = 1;        /* wait one second for select() */
	wait.tv_usec = 0;

	to_be_written = count;
	while (to_be_written > 0) {

		/* check for available network write buffers */
		FD_ZERO(&writeflds);
		FD_SET(socket, &writeflds);
		activity_flag = select(socket+1, (struct fd_set *) NULL,
			&writeflds, (struct fd_set *) NULL, &wait);
		if (activity_flag == 0) {
			// printf("\nNot ready to write...");
			printf("%c\b","-\\|/"[ticker++ % 4]);
			continue;
		}
		if (activity_flag == -1) {
			printf("\nselect() error in network_write()\n");
			exit_prompt(1);
			exit (1);
		}

		if ((just_written = send(socket, &buffer[total_written],
			to_be_written, 0)) == -1) { 
				if ((errno == 0) | (errno == EWOULDBLOCK)) {
					printf("%c\b","-\\|/"[ticker++ % 4]);
					continue;
				}
				system(COLOR_YELLOW);
				printf("\nError in network_write(), Error Number: %d\n",errno);
				printf("To be written: %d\n", to_be_written);
				return (-1);  /* network write error */
				// net_close();
				// exit_prompt(1);
				// exit(1);
		}
		to_be_written -= just_written;
		total_written += just_written;
	  }

	  return total_written;
}

/***********************************************************************
**                                                                    **
**  void init_client(char *destination, u_short port, int *Socket)    **
**                                                                    **
**  open the TCP/IP port in LISTEN MODE and wait for a connection     **
**                                                                    **
**  arguments:                                                        **
**    char *destination -- ip address of destination                  **
**	  char *error_msg ---- error message to be displayed              **
**    u_short port ------- port number connection                     **
**    SOCKET *Socket ----- connected TCP socket                       **
**                                                                    **
***********************************************************************/

void init_client(char *destination, char *error_msg, u_short port, SOCKET *Socket)
{
	struct sockaddr_in localAddr;	/* Sockets Address Structure */
	struct hostent *npstHostent;	/* Host Structure */
	struct linger   stTimeOut;	/* Linger time(out) structure */
	u_long wOpt;			/* work variable */
	// int werr;			/* find what the error is */
	
	npstHostent = gethostbyname(destination); /* get IP address */
	// werr = WSAGetLastError(); //
	// printf("\nThe last error code is: %d", werr);

	/* Get a TCP socket */
	*Socket = socket(AF_INET, SOCK_STREAM, 0);
/*	werr = WSAGetLastError();
	printf("\nThe last error code is: %d", werr);
	printf("\nDEBUG line: %d (%s)\n",__LINE__,__FILE__);
	printf("*Socket value is: %ld\n", *Socket);			*/
	if (*Socket == INVALID_SOCKET)  {
		printf("\nSocket initialization error in init_client()\n");
		exit_prompt(1);
		exit(1);
	}

	 /* Initialize the sockets IP Address (sockaddr_in) structure */
	 memset(&localAddr, 0, sizeof(localAddr));
	 memcpy(&(localAddr.sin_addr), npstHostent->h_addr,
	     sizeof(localAddr.sin_addr)); /* Difficult to cast */
	 localAddr.sin_family = AF_INET; /* Internet Address Family */
	 localAddr.sin_port = htons(port);

	  /* connect to the port socket */
	 if (connect(*Socket,(struct sockaddr*)&localAddr,
		sizeof(localAddr)) < 0) {
	    	// werr = WSAGetLastError();
	     	// printf("\nThe last error code is: %d", werr);
		printf("\nConnect error in init_client()\n");
		printf("%s", error_msg);
		closesocket(*Socket);
		exit_prompt(1);
		exit(1);
	 }

	/* set socket to non-blocking (we're more flexible this way */

	wOpt = 1;

#ifdef MS_NT
	if (ioctlsocket(*Socket, FIONBIO, (u_long *)&wOpt))
	    printf("\nioctlsocket() (non-block) error in init_client()\n");
#else
	if (ioctl(*Socket, FIONBIO, (u_long *)&wOpt))
	    printf("\nioctl() (non-block) error in init_client()\n");
#endif

	/* set close to don't linger, as per DICOM PS 3.8-1998 9.1.4 */
	stTimeOut.l_onoff = 0;
	if (setsockopt(*Socket, SOL_SOCKET, SO_LINGER, 
		(char *) &stTimeOut, sizeof(stTimeOut)))
		printf("\nsetsockopt(SO_LINGER) error in init_client()\n");
	
	return;
}

/***********************************************************************
**                                                                    **
**  void init_server(char *destination, u_short port, SOCKET *Socket, **
**                   int connection_dropped)                          **
**                                                                    **
**  open the TCP/IP port in LISTEN MODE and wait for a connection     **
**                                                                    **
**  arguments:                                                        **
**    char *destination -- ip address of destination                  **
**    u_short port ------- port number to LISTEN on for connections   **
**    SOCKET *Socket ----- connected TCP socket                       **
**                                                                    **
***********************************************************************/

void init_server(char *destination, u_short port, SOCKET *Socket,
				 int connection_dropped)
{
	struct sockaddr_in  localAddr;  /* Local Socket Address Structure */
	struct sockaddr_in  remoteAddr; /* Remote Socket Address Structure */
	struct linger   stTimeOut;	/* Linger time(out) structure */
	static int      listenSock = 0; /* TCP (Listening) socket */
	long    lHostID;		/* (Local) Host IP Addr */
	u_long     wOpt;		/* work variable */
	int     addrLen = sizeof(localAddr);    /* work variable */
	static  u_long ticker = 0;      /* time-out delay counter */
	struct  timeval wait;           /* time delay for select() */
	struct  fd_set readflds;        /* structure for select() */
	int     activity_flag = 0;      /* return code from select() */
	
	wait.tv_sec = 1;        /* wait one second for select() */
	wait.tv_usec = 0;

	if (listenSock == 0) {
		/* Get a TCP socket */
		listenSock = socket(AF_INET, SOCK_STREAM, 0);
	//	printf("\nDEBUG line: %d (%s)\n",__LINE__,__FILE__);
		if (listenSock == INVALID_SOCKET) {
			printf("\nsocket() error in init_server()\n");
			exit_prompt(1);
			exit (2);
		}

#ifdef MS_NT
		/* select any network */
		lHostID = htonl(INADDR_ANY);
#else
		/* get local IP address from pctcp.ini file */
		lHostID = gethostid();
		if (lHostID == 0) {
			  printf("\ngethostid() error in init_server()\n");
			  exit(3);
		}
#endif

		/* initialize local sockaddr_in structure */
		localAddr.sin_family      = AF_INET;
		localAddr.sin_addr.s_addr = lHostID;
		localAddr.sin_port = htons(port);

		/* bind local ip address & port number to the socket */
		if (bind(listenSock, (struct sockaddr*)&localAddr, addrLen)<0) {
			printf("\nbind() error in init_server\n");
			printf("\n*** Error: Could not listen on the DICOM port because it is already in use ***\n");
			printf("\nCheck that the requested DICOM port number is correct\n");
			exit_prompt(1);	
			exit(5);
		}

		/* "passively open" the socket */
		if ((listen(listenSock, 1)) < 0) {
			printf("\nlisten() error in init_server()\n");
			exit_prompt(1);	
			exit (6);
		}

		/* set listen socket to non-blocking */

		wOpt = 1;

#ifdef MS_NT
		if (ioctlsocket(listenSock, FIONBIO, (u_long *)&wOpt))
		    printf("\nioctlsocket() (non-block) error in init_server()\n");
#else
		if (ioctl(listenSock, FIONBIO, (u_long *)&wOpt))
		    printf("\nioctl() (non-block) error in init_server()\n");
#endif

	}

	/* wait for client to connect to local ip address */
	printf("\nListening on Port %d for DICOM Storage User... ", port);
	ticker = 0;

	while (!activity_flag) {

		/* check for incoming network connection requests */
		FD_ZERO(&readflds);
		FD_SET(listenSock, &readflds);
		activity_flag = select(listenSock+1, &readflds,
			(struct fd_set *) NULL,
			(struct fd_set *) NULL, &wait);
		if (activity_flag == -1) {
			printf("\nselect() error in init_server()\n");
			exit_prompt(1);	
			exit (1);
		}
		
		printf("%c\b","-\\|/"[ticker++ % 4]);
		if ((!connection_dropped)
			&& (ticker == COLOR_TIMEOUT)) system(COLOR_BLUE);
	}

	*Socket = accept(listenSock, (struct sockaddr*) &remoteAddr, &addrLen);
	if (*Socket < 0) {
		printf("\naccept() error in init_server()\n");
		exit_prompt(1);	
		exit (7);
	} 

	sprintf(destination, "%d.%d.%d.%d",
		remoteAddr.sin_addr.S_un.S_un_b.s_b1,
		remoteAddr.sin_addr.S_un.S_un_b.s_b2,
		remoteAddr.sin_addr.S_un.S_un_b.s_b3,
		remoteAddr.sin_addr.S_un.S_un_b.s_b4);
	system(COLOR_WHITE);
	printf("Connected to %s", destination);

	/* set socket to non-blocking (we're more flexible this way */

	wOpt = 1;

#ifdef MS_NT
	if (ioctlsocket(*Socket, FIONBIO, (u_long *)&wOpt))
	    printf("\nioctlsocket() (non-block) error in init_server()\n");
#else
	if (ioctl(*Socket, FIONBIO, (u_long *)&wOpt))
	    printf("\nioctl() (non-block) error in init_server()\n");
#endif

	/* set close to don't linger, as per DICOM PS 3.8-1998 9.1.4 */
	stTimeOut.l_onoff = 0;
	if (setsockopt(*Socket, SOL_SOCKET, SO_LINGER, 
		(char *) &stTimeOut, sizeof(stTimeOut)))
		printf("\nsetsockopt(SO_LINGER) error in init_server()\n");

	return;
}

/***********************************************************************
**                                                                    **
**  void send_msg(message, socket)                                    **
**  void recv_msg(message, socket)                                    **
**                                                                    **
**  send/receive a message to/from the MUMPS surrogate process        **
**                                                                    **
**  arguments:                                                        **
**    char *message -- the message                                    **
**    SOCKET socket -- TCP socket connected to the MUMPS surrogate    **
**                                                                    **
**  All messages are of the format <length><text>, where <length>     **
**  is the number of characters of text following.  <length> is       **
**  formatted as a zero-padded four digit field.                      **
**                                                                    **
***********************************************************************/

void send_msg(char *message, SOCKET socket)
{
	char    msg_buffer[110];                /* message buffer */

	if (dcm_debug) {
		printf("\nSending <<%s>>", message);
	}
	sprintf(msg_buffer,"%04d%s", strlen(message), message);
	network_write(socket, msg_buffer, strlen(msg_buffer));
}



void recv_msg(char *message, SOCKET socket)
{
	char    msg_buffer[110];                /* message buffer */
	int     length;                         /* length of message in bytes */
	int     i;                              /* working variable */

	memset (msg_buffer, 0, sizeof(msg_buffer));
	i = network_read(socket, msg_buffer, 4, 5);     /* get the message length */
	if (i != 4) {
		printf("\nMUMPS length network_read() error: %d\n", i);
		net_close();
		exit_prompt(1);	
		exit (1);
	}
	length = atoi(msg_buffer);
	i = network_read(socket, message, length, 1);/* get the message */

	if (i != length) {
		system(COLOR_RED);
		printf("\nMUMPS message network_read() error: %d\n", i);
		net_close();
		exit_prompt(1);	
		exit (1);
	}

	message[length] = '\0';

	if (dcm_debug) {
		printf("\nRecving <<%s>>\n", message);
	}
}

/***********************************************************************
**                                                                    **
**  int disk_read(input, buffer, count)                               **
**                                                                    **
**  read bytes from the disk file with the appropriate error checking **
**                                                                    **
**  arguments:                                                        **
**    FILE *input --- name of input file on disk                      **
**    char *buffer -- input buffer pointer                            **
**    int count ------ number of bytes to read                        **
**                                                                    **
***********************************************************************/

int disk_read(FILE *input, char *buffer, int count)
{
	int     number_read;    /* number of bytes read from file */

	number_read = fread(buffer, 1, count, input);
	if ((number_read != count) & (feof(input) == 0)) {
		if (ferror(input)) {
			printf("\nDisk Read error\n");
			exit_prompt(1);	
			exit (3);
		}               
		printf("\nUnknown read error\n");
		exit_prompt(1);	
		exit (4);
	}
	return (number_read);
}

/***********************************************************************
**                                                                    **
**  int disk_write(output, buffer, count)                             **
**                                                                    **
**  write bytes to the disk file with the appropriate error checking  **
**                                                                    **
**  arguments:                                                        **
**    FILE *output -- name of output file on disk                     **
**    char *buffer -- input buffer pointer                            **
**    int count ------ number of bytes to write                       **
**                                                                    **
***********************************************************************/

int disk_write(FILE *output, char *buffer, int count)
{
	int     number_written; /* number of bytes written to file */

	number_written = fwrite(buffer, 1, count, output);
	if (number_written != count) {
		if (feof(output)) {
			system(COLOR_RED);
			printf("\nOutput EOF reached\n");
			return (2);
		}
		if (ferror(output)) {
			system(COLOR_RED);
			printf("\nWrite error: number_written= %d  count= %d\n",
				number_written,count);
			return (3);
		}               
		system(COLOR_RED);
		printf("\nUnknown write error\n");
		return (4);
	}
	return (0);
}

void check_response(char *message, char *expected)
{
	if (dcm_debug > 2)
		printf ("\n     Expect \"%s\", \nActual Text \"%s\".", expected, message);
	if (strcmp(message, expected) != 0) {
			printf("\n\n*** Error: Incorrect Message \"%s\" ***\n", message);
			printf("*** It should have been \"%s\"***\n", expected);
			net_close();
			exit_prompt(1);
			exit (0);
		}
}


void exit_prompt(int error_flag)
{
		if (error_flag) system(COLOR_RED);
		printf("\nPush <Enter> to exit...");
		getchar(); /* require a newline */
}


void net_close(void)
{
	closesocket(mumpsSock);
	closesocket(dicomSock);
}
