/***********************************************************************
**                                                                    **
**   dcm_netf.cpp -- DICOM networking functions for image transfer    **
**                                                                    **
**   These functions are used by cstore.c and send_img.c              **
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

#include <stdio.h>
#include <iostream>

//#include <signal.h>
//#include <stdlib.h>		// for atoi()
//#include <sys/types.h>
//#include <errno.h>

#include <time.h>

#include "dcm_net.h"

using namespace std;

extern int	DCM_DEBUG;		    // Debug level (set on command line)
extern long DCM_MAXBYTES;       // Maximum number of bytes to read


/***********************************************************************
**                                                                    **
**  init_winsock()                                                    **
**                                                                    **
**  initializes the Windows Sockets Library                           **
**                                                                    **
***********************************************************************/
#ifdef MS_NT
void init_winsock()
{
	WORD wVersionRequested = MAKEWORD(2,2); // WinSock 2.2 requested
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
**  int net_read_control(...)                                         **
**                                                                    **
**  read a DICOM Association Control PDU with error checking          **
**                                                                    **
***********************************************************************/

int net_read_control(
	char	*incoming_file,			// file for incoming control PDU, CSTORE.IN
	SOCKET	dicomSock,				// socket for DICOM communications
	SOCKET	mumpsSock,				// socket for communications with MUMPS backend
	struct	pdu_header *pdu_header,	// Protocol Data Unit
	int		thread_number)			// 0 for main(), 1, 2, 3, 4, or 5 otherwise
{
	FILE    *incoming;              // incoming file descriptor pointer
	char	buffer[BUFFER_SIZE];	// i/o buffer
	long    remaining_pdu_length;   // PDU length
	int     number_read = 0;        // number of bytes read from input
	int     error = 0;              // network error indicator
	int     i;                      // working variable
	char	message[200];

	remaining_pdu_length = ntohl(pdu_header->length);

	// first try to read the remander of the PDU data
	if (remaining_pdu_length > 0) {
		number_read = network_read(dicomSock, buffer,
			  (int) remaining_pdu_length, 1);

		if (number_read == -1 ) {
			// connection dropped
			error = -1;
			return (error);
		}
	}

	// open the incoming file to hold the PDU
	if ((incoming = file_open(incoming_file, "wb", thread_number)) == NULL) {
		sprintf(message, "Could not open incoming file %s\n",
			 incoming_file);
		print_message(thread_number, message);
		exit_prompt(1);
		exit (1);
	}

	// Output PDU Header to disk file
	if (i = disk_write(incoming, (char *) pdu_header, PDU_HDR, thread_number)) {
		sprintf(message, "Error #1 writing control PDU to disk\n");
		print_message(thread_number, message);
		file_close(&incoming, thread_number);
		net_close(dicomSock, mumpsSock);
		exit_prompt(1);
		exit (i);
	}

	// write the above data from the PDU to the file
	if (number_read > 0) {
		if (i = disk_write(incoming, buffer, number_read, thread_number)) {
			sprintf(message, "Error #2 writing control PDU to disk\n");
			print_message(thread_number, message);
			file_close(&incoming, thread_number);
			net_close(dicomSock, mumpsSock);
			exit_prompt(1);
			exit (i);
		}
		remaining_pdu_length -= number_read;
	}

	// Loop reading remainder of TCP/IP data and saving in disk file
	while (remaining_pdu_length > 0) {
		number_read = network_read(dicomSock, buffer,
			(int) remaining_pdu_length, 1);

		if (number_read == -1 ) {
			// connection dropped
			error = -2;
			break;
		}
		if (number_read > 0) {
			if (i = disk_write(incoming, buffer, number_read, thread_number)) {
				sprintf(message, "Error #3 writing control PDU to disk\n");
				print_message(thread_number, message);
				file_close(&incoming, thread_number);
				net_close(dicomSock, mumpsSock);
				exit_prompt(1);
				exit (i);
			}
			remaining_pdu_length -= number_read;
		}
	}

	file_close(&incoming, thread_number);
	return (error);
}




/***********************************************************************
**                                                                    **
**  net_write_control(...)                                            **
**                                                                    **
**  write a DICOM Association Control PDU with error checking         **
**                                                                    **
**  MUMPS CStore backend generates the PDU response in the outgoing   **
**  file.  This function copies the outgoing file to the dicomSock.   **
**                                                                    **
***********************************************************************/

int net_write_control(
	char	*outgoing_file,			// file for outgoing control PDU, CSTORE.OUT
	SOCKET	dicomSock,				// socket for DICOM communications
	int		thread_number)			// 0 for main(), 1, 2, 3, 4, or 5 otherwise
{
	FILE    *outgoing;              // outgoing file descriptor pointer
	char	buffer[BUFFER_SIZE];	// i/o buffer
	int     number_read;            // number of bytes read from input
	int     number_written;         // number of bytes written to file
	int     error = 0;              // network error indicator

	// open the outgoing file holding the PDU
	if ((outgoing = file_open(outgoing_file, "rb", thread_number)) == NULL) {
		printf("\nCould not open outgoing file %s\n",
			 outgoing_file);
		exit_prompt(1);
		exit (1);
	}

	// copy the outgoing file to the buffer
	number_read = disk_read(outgoing, buffer, BUFFER_SIZE, thread_number);
	file_close(&outgoing, thread_number);

	// write the buffer to the dicomSock
	number_written = network_write(dicomSock, buffer, number_read);
	if (number_written != number_read) {
		printf("\nError writing control PDU to DICOM socket\n");
		error = -1;              // network write error
	}

	return (error);
}

/***********************************************************************
**                                                                    **
**  net_read_command(...)                                             **
**                                                                    **
**  read a DICOM Command PDU with error checking                      **
**                                                                    **
***********************************************************************/

int net_read_command(
	char	*incoming_file,			// file for incoming control PDU, CSTORE.IN
	SOCKET	dicomSock,				// socket for DICOM communications
	long	*dataset_number_read,	// number of bytes read from the dataset
	struct	pdu_header *pdu_header,	// Protocol Data Unit
	struct	pdv_header *pdv_header,	// Presentation Data Value
	int		thread_number)			// 0 for main(), 1, 2, 3, 4, or 5 otherwise
{
	FILE    *incoming;              // incoming file descriptor pointer
	char	buffer[BUFFER_SIZE];	// i/o buffer
	long    remaining_pdu_length;   // PDU length
	int     number_read;            // number of bytes read from input
	int     last_fragment;          // PDV message control header switch
	int     data_cmd_switch;        // PDV message control header switch
	int     i;                      // working variable

	// open the incoming file to hold the PDU
	if ((incoming = file_open(incoming_file, "wb", thread_number)) == NULL) {
		printf("\nCould not open incoming file %s\n",
			 incoming_file);
		exit_prompt(1);
		exit (1);
	}

	remaining_pdu_length = ntohl(pdu_header->length);

	// copy all of the data fragments to the incoming file

	while (remaining_pdu_length > 0) {

		// transfer the PDV fragment from network to buffer

		number_read = net_read_pdv(dicomSock, buffer, BUFFER_SIZE,
			dataset_number_read, pdv_header, thread_number);

		if (number_read == -1) {
			printf("\nnet_read_command() -- network connection dropped\n");
			return (-1);	// network connection dropped
		}

		data_cmd_switch = 0x01 & pdv_header->msg_ctrl;
		last_fragment   = 0x02 & pdv_header->msg_ctrl;

		if (data_cmd_switch != COMMAND_FRAGMENT) {
			printf("\nWarning: Not Command Fragment\n");
		}

		if (last_fragment != LAST_FRAGMENT) {
			printf("(\nWarning: Not Last Fragment\n");
		}

		// transfer the PDV fragment from the buffer to disk
		if (number_read > 0) {
			if (i = disk_write(incoming, buffer, number_read, thread_number)) {
				printf("\nnet_read_command() -- transfer the PDV fragment from the buffer to disk failed\n");
				file_close(&incoming, thread_number);
				return (-2);
			}
		}

		remaining_pdu_length -= number_read + PDV_HDR;

	}

	file_close(&incoming, thread_number);
	return (0);
}

/***********************************************************************
**                                                                    **
**  net_read_dataset(...)                                             **
**                                                                    **
**  read a DICOM Protocol Data Value with appropriate error checking  **
**                                                                    **
***********************************************************************/

int net_read_dataset(
	int		*dcm_transfer_state,	// DICOM state variable
	char	*incoming_file,			// file for incoming control PDU, CSTORE.IN
	char	*dataset_file,			// file for incoming data PDU, the DICOM object
	FILE	**incoming,				// file descriptor for the incoming DICOM object
	SOCKET	dicomSock,				// socket for DICOM communications
	SOCKET	mumpsSock,				// socket for communications with MUMPS backend
	long	*dataset_number_read,	// number of bytes read from the dataset
	struct	pdu_header *pdu_header,	// Protocol Data Unit
	struct	pdv_header *pdv_header,	// Presentation Data Value
	int		thread_number)			// 0 for main(), 1, 2, 3, 4, or 5 otherwise
{
	char	message[200];			// Message buffer for MUMPS
	char	text[100];				// text for screen
	char	buffer[BUFFER_SIZE];	// i/o buffer
	long    remaining_pdu_length;   // PDU length
	int     number_read;            // number of bytes read from input
	int     last_fragment;          // indicator for last packet of a dataset
	int     data_cmd_switch;        // PDV message control header switch
	time_t	now;					// current time
	char	current_time[30];		// current time string
	int     i;                      // working variable
	
	remaining_pdu_length = ntohl(pdu_header->length);

	// copy all of the data fragments to the incoming file

	while (remaining_pdu_length > 0) {

		// transfer the PDV fragment from network to buffer

		number_read = net_read_pdv(dicomSock, buffer, BUFFER_SIZE,
			dataset_number_read, pdv_header, thread_number);

		if (number_read == -1) {
			printf("\nnet_read_dataset() -- network connection dropped\n");
			return (-1);	// network connection dropped
		}

		data_cmd_switch = 0x01 & pdv_header->msg_ctrl;
		last_fragment   = 0x02 & pdv_header->msg_ctrl;

		if (data_cmd_switch == COMMAND_FRAGMENT) {
			// process an incoming command fragment

			switch (*dcm_transfer_state) {
			case INITIAL_STATE:
				if ((*incoming = fopen(incoming_file, "wb")) == NULL) {
					printf("\nCould not open incoming msg file %s\n",
						 incoming_file);
					return (101);
				}
				break;
			case COMMAND_STATE:     break;
			case INTERIM_STATE:     return (102);
			case DATASET_STATE:     return (103);
			default:                return (104);
			}

			*dcm_transfer_state = COMMAND_STATE;
		}

		else {
			// process an incoming dataset fragment

			switch (*dcm_transfer_state) {
			case INITIAL_STATE:     return (105);
			case COMMAND_STATE:     return (106);
			case INTERIM_STATE: 	break;
			case DATASET_STATE:     break;
			default:                return (108);
			}

			*dcm_transfer_state = DATASET_STATE;
		}

		// transfer the PDV fragment from the buffer to disk
		if (number_read > 0) {
			if (i = disk_write(*incoming, buffer, number_read, thread_number)) {
				printf("\nnet_read_dataset() -- transfer the PDV fragment from the buffer to disk failed\n");
				file_close(incoming, thread_number);
				return (-2);
			}
		}

		remaining_pdu_length -= number_read + PDV_HDR;

		if (last_fragment == LAST_FRAGMENT) {
			file_close(incoming, thread_number);
			if (*dcm_transfer_state == COMMAND_STATE) {
				// end of a command fragment

				// get dataset filename from MUMPS backend
				sprintf(message,"DATASET PDU %d", pdv_header->context);
				send_msg(message, mumpsSock);
				recv_msg(dataset_file, mumpsSock);
				if (strcmp(dataset_file, "NON-IMAGE DATASET")==0) {
					*dcm_transfer_state = EXCEPTION_STATE;
				}
				else {
					if ((*incoming = file_open(dataset_file, "ab", thread_number)) == NULL) {
						printf("\nCould not open incoming msg file %s\n",
							 dataset_file);
						return (107);
					}

					if (thread_number == 0) {
						time(&now);
						sprintf(current_time,"%s", ctime(&now));
						current_time[19]=0;
						printf("\n%s  Input file %s          ",
						&current_time[4], dataset_file);
					}

					*dcm_transfer_state = INTERIM_STATE;
				}
			}
			else {
				// end of a dataset fragment
				if (thread_number != 0) {				
					time(&now);
					sprintf(current_time,"%s", ctime(&now));
					current_time[19]=0;
					sprintf(text, "%s Input file %s %ld",
						&current_time[4], dataset_file, *dataset_number_read);
					print_message(thread_number, text);
				}
				*dcm_transfer_state = FINAL_STATE;
				file_close(incoming, thread_number);
			}
		}
	}

	return (0);
}

/***********************************************************************
**                                                                    **
**  net_read_pdv(...)                                                 **
**                                                                    **
**  read a DICOM Protocol Data Value with appropriate error checking  **
**                                                                    **
***********************************************************************/

int net_read_pdv(
	SOCKET	dicomSock,				// socket for DICOM communications
	char	*buffer,				// memory for DICOM protocol data units
	int		count,					// number of the bytes to be read
	long	*dataset_number_read,	// number of bytes that were read from the network
	struct	pdv_header *pdv_header,	// Presentation Data Value
	int		thread_number)			// 0 for main(), 1, 2, 3, 4, or 5 otherwise
{
	int     number_read;            // number of bytes read from input

	// read the 6-byte PDV hdr to get the length, context, & ctrl
	number_read = network_read(dicomSock, (char *) pdv_header, PDV_HDR, 1);
	if (number_read != PDV_HDR) {
		if (number_read == -1) {
			printf("\nnet_read_pdv() -- network connection dropped\n");
			return (-1);    // network connection dropped
		}
		printf("\nError reading PDV header: %d bytes were read out of %d\n",
			number_read, PDV_HDR);
		closesocket(dicomSock);
		exit_prompt(1);
		exit (1);
	}

	pdv_header->length = ntohl(pdv_header->length) - 2;

	if (DCM_DEBUG > 1) {
		printf("   Context: %d   MSG CTRL: %d           ",
			0xff & pdv_header->context,
			0xff & pdv_header->msg_ctrl);
	}

	// output running count of number of data bytes transferred
	if (! (0x01 & pdv_header->msg_ctrl)) {
		*dataset_number_read += pdv_header->length;
		if (thread_number == 0) {
			printf("\b\b\b\b\b\b\b\b\b\b%10ld", *dataset_number_read);
		}
		if ((DCM_MAXBYTES > 0) && (*dataset_number_read > DCM_MAXBYTES))
		{
			closesocket(dicomSock);
			*dataset_number_read = 0;
			printf ("\nDeliberate abort after %ld bytes.\n", DCM_MAXBYTES);
			printf ("If running this program in production mode,\n");
			printf ("start the program without specifying an 'abort after' parameter.\n");
			return (-1);
		}
		/* if (pdv_header->msg_ctrl == 2) {
			*dataset_number_read = 0;       // zeroed in cstore.cpp now
		} */
	}

	// read the PDV data
	number_read = network_read(dicomSock, buffer, (int) pdv_header->length, 1);
	if (number_read != (int) pdv_header->length ) {

		if (number_read == -1) {
			return (-1);    // network connection dropped
		}

		printf("\nError reading PDV data, %d bytes were read out of %d\n",
			number_read, (int) pdv_header->length);
		closesocket(dicomSock);
		exit_prompt(1);
		exit (1);
	}

	return (number_read);
}

/***********************************************************************
**                                                                    **
**  net_write_data(...)                                               **
**                                                                    **
**  write a DICOM Association data PDU with error checking            **
**                                                                    **
***********************************************************************/

int net_write_data(
	char	*outgoing_file,			// file for outgoing control PDU, CSTORE.OUT
	SOCKET	dicomSock,				// socket for DICOM communications
	int		data_cmd_switch,		// PDV message control header switch
	long	offset,					// offest to first tag beyond DICOM meta information
	int		context,				// PDV header context
	long	*dataset_number_written, // number of bytes written to the dataset
	struct	pdu_header *pdu_header,	// Protocol Data Unit
	struct	pdv_header *pdv_header,	// Presentation Data Value
	int		thread_number)			// 0 for main(), 1, 2, 3, 4, or 5 otherwise
{
	FILE    *outgoing;              // outgoing file descriptor pointer
	char	buffer[BUFFER_SIZE];	// i/o buffer
	int     number_to_be_read;      // number of bytes to read from input
	int     number_read;            // number of bytes read from input
	int     number_written;         // number of bytes written to file
	int     eof = 0;                // end of input file indicator
	int		a, i;

	number_to_be_read = MAX_PDU_SIZE - PDV_HDR - PDU_HDR;

	if (DCM_DEBUG) printf("\nOutgoing file: %s", outgoing_file);

	// open the outgoing file to hold the message
	if ((outgoing = file_open(outgoing_file, "rb", thread_number)) == NULL) {
		printf("\nCould not open outgoing file %s\n",
			 outgoing_file);
		exit_prompt(1);
		exit (1);
	}

	// seek to the first tag beyond the DICOM meta information
	fseek(outgoing, offset, 0);

	// loop sending one PDV per PDU until done
	while (!eof) {
		// copy the outgoing_file to the buffer
		number_read = disk_read(outgoing, buffer, number_to_be_read, thread_number);

		if (feof(outgoing)) {
				eof = 1;        // set end of file
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

		// fill in the PDU and PDV headers
		pdu_header->type = PDU_TYPE_DATA;
		pdu_header->pad  = 0;
		pdu_header->length = htonl(number_read + PDV_HDR);

		pdv_header->length = htonl(number_read +2);
		pdv_header->context = 0xff & context;
		pdv_header->msg_ctrl = data_cmd_switch | (eof << 1);

		if (DCM_DEBUG > 1) {
			printf("\nSending PDU Type: %02XH  Length: %5d",
				pdu_header->type,
				ntohl(pdu_header->length));
			printf("   Context: %d   MSG CTRL: %d          ",
				0xff & pdv_header->context,
				0xff & pdv_header->msg_ctrl);
		}
		
		// output the PDU and PDV headers
		number_written = network_write(dicomSock, (char *) pdu_header, PDU_HDR);
		if (DCM_DEBUG > 2)
			printf ("\nWrite PDU, %d of %d characters written", number_written, PDU_HDR);
		if (number_written != PDU_HDR) {
			printf("\nError writing PDU hdr to socket\n");
			return (-1);             // network write error
		}

		number_written = network_write(dicomSock, (char *) pdv_header, PDV_HDR);
		if (DCM_DEBUG > 2)
			printf ("\nWrite PDV, %d of %d characters written", number_written, PDV_HDR);
		if (number_written != PDV_HDR) {
			printf("\nError writing PDV hdr to socket\n");
			return (-1);             // network write error
		}

		// write the data in the buffer to the DICOM socket
		number_written = network_write(dicomSock, buffer, number_read);
		if (DCM_DEBUG > 2)
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
			return (-1);             // network write error
		}

		// output running count of number of data bytes transferred
		if (! (0x01 & pdv_header->msg_ctrl)) {
			// dataset_number_written += pdv_header->length;
			dataset_number_written += number_written;
			printf("\b\b\b\b\b\b\b\b\b\b%10ld", *dataset_number_written);
			if (pdv_header->msg_ctrl == 2) {
				dataset_number_written = 0;
			}
		}
	}

	file_close(&outgoing, thread_number);
	return (0);
}

/***********************************************************************
**                                                                    **
**  network_read(...)                                                 **
**                                                                    **
**  read bytes from the network with the appropriate error checking   **
***********************************************************************/

int network_read(
	SOCKET	socket,			// connected socket for DICOM or MUMPS communications
	char	*buffer,		// input message buffer pointer
	int		count,			// number of bytes to read
	long	timeout)		// network read timeout value (0 don't block)
{

	int     to_be_read;     // number of bytes to be read from network
	int     total_read = 0; // total number of bytes read from network
	int     just_read;      // number of bytes read by last operation
	u_long  wCntr = 0;      // work variable
	u_long	ticker = 0;		// counter for no message time-outs

	struct  timeval wait;   // time delay for select()
	struct  fd_set readflds;// structure for select()
	struct  fd_set exceptfds;
	int     activity_flag;  // return code from select()
	int		last_error = 0;	// error code from MS NT

	wait.tv_sec = 1;        // wait one second for select()
	wait.tv_usec = 0;

	to_be_read = count < BUFFER_SIZE ? count : BUFFER_SIZE;

	while (to_be_read > 0) {
		// check for incoming network activity
		FD_ZERO(&readflds);
		FD_SET(socket, &readflds);
		FD_ZERO(&exceptfds);
		FD_SET(socket, &exceptfds);
		activity_flag = select(sizeof(readflds)*8, &readflds,
			(struct fd_set *) NULL, (struct fd_set *) NULL, &wait);

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
				if (last_error == ENETRESET) {
					// Network conection dropped
					return -1;
				}

				if (last_error != EWOULDBLOCK) {
					if (DCM_DEBUG) {
						printf("\nError in network_read()");
						printf("\ttotal read: %d, last error=%d",
							total_read, last_error);
#ifdef MS_NT
						printf("\nMS NT Socket Error #%d", last_error);
#endif
					}
					system(COLOR_YELLOW);
					printf("\nPeer DICOM Application Entity dropped the TCP/IP circut connection\n");
					return -1;
				}
			}

			else if (just_read == 0) {
				if (wCntr++ > LOOP_LIMIT)  {
					printf("\nnetwork_read(): Timeout\n");
					printf("\ttotal read: %d",
						total_read);
					return -1;
				}
			}
			
			else {
				to_be_read -= just_read;
				total_read += just_read;
			}
		}

		else {
			// a network timeout occurred
			printf("%c\b","/|\\-"[ticker++ % 4]);
		}
	}
	if (DCM_DEBUG > 2) printf ("\nnetwork_read: read = %d\n", total_read);

	return total_read;
}

/***********************************************************************
**                                                                    **
**  network_write(...)                                                **
**                                                                    **
**  write bytes to the network with the appropriate error checking    **
**                                                                    **
***********************************************************************/

int network_write(
	SOCKET	socket,				// connected socket for DICOM or MUMPS communications
	char	*buffer,			// input buffer pointer
	int		count)				// number of bytes to write
{

	int     to_be_written;		// number of bytes to be written to network
	int     total_written=0;	// total number of bytes written to network
	int     just_written;		// number bytes written by last operation
	u_long	ticker = 0;			// counter for no message time-outs
	struct  timeval wait;       // time delay for select()
	struct  fd_set writeflds;   // structure for select()
	int     activity_flag = 0;  // return code from select()
	int		last_error = 0;		// error code from MS NT
	
	wait.tv_sec = 1;			// wait one second for select()
	wait.tv_usec = 0;

	to_be_written = count;
	while (to_be_written > 0) {

		// check for available network write buffers
		FD_ZERO(&writeflds);
		FD_SET(socket, &writeflds);
		activity_flag = select(sizeof(writeflds)*8, (struct fd_set *) NULL,
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
			to_be_written, 0)) == SOCKET_ERROR) { 
				last_error = WSAGetLastError();
				Sleep(1000);  // prevent run-away output
				if ((last_error == 0) | (last_error == EWOULDBLOCK)) {
					printf("%c\b","-\\|/"[ticker++ % 4]);
					continue;
				}
				system(COLOR_YELLOW);
				printf("\nError in network_write(), WSAGetLastError = %d\n", last_error);
				printf("To be written: %d\n", to_be_written);
				return (-1);  // network write error
		}
		to_be_written -= just_written;
		total_written += just_written;
	  }

	  return total_written;
}

/***********************************************************************
**                                                                    **
**  init_client(...)						                          **
**                                                                    **
**  make a TCP/IP connection to the destination port                  **
**                                                                    **
***********************************************************************/

void init_client(
	char	*destination,			// ip address of destination 
	char	*error_msg,				// error message to be displayed
	u_short	port,					// port number connection
	SOCKET	*Socket)				// TCP socket to for the connection
{
	struct sockaddr_in localAddr;	// Sockets Address Structure
	struct hostent *npstHostent;	// Host Structure
	struct linger   stTimeOut;		// Linger time(out) structure
	u_long wOpt;					// work variable
	// int werr;					// find what the error is
	
	npstHostent = gethostbyname(destination); // get IP address
	// werr = WSAGetLastError(); //
	// printf("\nThe last error code is: %d", werr);

	// Get a TCP socket
	*Socket = socket(AF_INET, SOCK_STREAM, 0);
	/*	werr = WSAGetLastError();
	printf("\nThe last error code is: %d", werr);
	printf("\nDEBUG line: %d (%s)\n",__LINE__,__FILE__); */
	if (DCM_DEBUG) printf("\ninit_client() -- Socket value is: %ld\n", *Socket);
	if (*Socket == INVALID_SOCKET)  {
		printf("\nSocket initialization error in init_client()\n");
		exit_prompt(1);
		exit(1);
	}

	 // Initialize the sockets IP Address (sockaddr_in) structure
	 memset(&localAddr, 0, sizeof(localAddr));
	 memcpy(&(localAddr.sin_addr), npstHostent->h_addr,
	     sizeof(localAddr.sin_addr)); // Difficult to cast
	 localAddr.sin_family = AF_INET; // Internet Address Family
	 localAddr.sin_port = htons(port);

	  // connect to the port socket
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

	// set socket to non-blocking (we're more flexible this way

	wOpt = 1;

#ifdef MS_NT
	if (ioctlsocket(*Socket, FIONBIO, (u_long *)&wOpt))
	    printf("\nioctlsocket() (non-block) error in init_client()\n");
#else
	if (ioctl(*Socket, FIONBIO, (u_long *)&wOpt))
	    printf("\nioctl() (non-block) error in init_client()\n");
#endif

	// set close to don't linger, as per DICOM PS 3.8-1998 9.1.4
	stTimeOut.l_onoff = 0;
	if (setsockopt(*Socket, SOL_SOCKET, SO_LINGER, 
		(char *) &stTimeOut, sizeof(stTimeOut)))
		printf("\nsetsockopt(SO_LINGER) error in init_client()\n");
	
	return;
}

/***********************************************************************
**                                                                    **
**  listen_server(...)                                                **
**                                                                    **
**  open the TCP/IP port in LISTEN MODE and wait for a connection     **
***********************************************************************/

void listen_server(
	u_short port,					// port number to LISTEN on for connections 
	char	*destination,			// ip address of destination
	SOCKET	*dicomSock,				// socket for DICOM -- will be connected upon return
	int		connection_dropped)		// flag to detect a dropped connection
{
	struct	sockaddr_in  localAddr;  // Local Socket Address Structure
	struct  sockaddr_in  remoteAddr; // Remote Socket Address Structure
	int     addrLen = sizeof(remoteAddr); // work variable
	struct  linger stTimeOut;		// Linger time(out) structure
	static	SOCKET  listenSock = 0;	// TCP Listening socket
	long    lHostID;				// (Local) Host IP Addr
	u_long  wOpt;					// work variable
	u_long	ticker = 0;			    // time-out delay counter
	struct  timeval wait;           // time delay for select()
	struct  fd_set readflds;		// structure for select()
	int     activity_flag = 0;		// return code from select()
	char	text[100];				// text for screen

	if (listenSock == 0) {
		// Get a TCP socket
		listenSock = socket(AF_INET, SOCK_STREAM, IPPROTO_TCP);
		
		if (listenSock == INVALID_SOCKET) {
			printf("\nsocket() error in init_server()\n");
			exit_prompt(1);
			exit (2);
		}

#ifdef MS_NT
		// select any network
		lHostID = htonl(INADDR_ANY);
#else
		// get local IP address from pctcp.ini file
		lHostID = gethostid();
		if (lHostID == 0) {
			  printf("\ngethostid() error in init_server()\n");
			  exit(3);
		}
#endif

		// initialize local sockaddr_in structure
		localAddr.sin_family      = AF_INET;
		localAddr.sin_addr.s_addr = lHostID;
		localAddr.sin_port = htons(port);

		// bind local ip address & port number to the socket
		if (bind(listenSock, (struct sockaddr*)&localAddr, sizeof(localAddr)) == SOCKET_ERROR) {
			printf("\nbind() error in init_server\n");
			printf("\n*** Error: Could not listen on the DICOM port because it is already in use ***\n");
			printf("\nCheck that the requested DICOM port number is correct\n");
			exit_prompt(1);	
			exit(5);
		}

		// "passively open" the socket
		if (DCM_DEBUG) printf("\nConnection Backlog = %d\n", SOMAXCONN);
		if ((listen(listenSock, SOMAXCONN)) == SOCKET_ERROR) {
			printf("\nlisten() error in init_server()\n");
			exit_prompt(1);	
			exit (6);
		}

		// set listen socket to non-blocking

		wOpt = 1;

#ifdef MS_NT
		if (ioctlsocket(listenSock, FIONBIO, (u_long *)&wOpt))
		    printf("\nioctlsocket() (non-block) error in init_server()\n");
#else
		if (ioctl(listenSock, FIONBIO, (u_long *)&wOpt))
		    printf("\nioctl() (non-block) error in init_server()\n");
#endif

	}

	// wait for client to connect to local ip address
	sprintf(text, "Listening on Port %d for DICOM Storage User... ", port);
	print_message(0, text);

	wait.tv_sec = 1;        // wait one second for select()
	wait.tv_usec = 0;
	
	if (DCM_DEBUG) printf("\ninit_server(): listenSock = %d\n", listenSock);

	while (!activity_flag) {

		// check for incoming network connection requests
		FD_ZERO(&readflds);
		FD_SET(listenSock, &readflds);
		activity_flag = select(sizeof(readflds)*8, &readflds,
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
	
	// accept the connection on the socket
	*dicomSock = accept(listenSock, (struct sockaddr*) &remoteAddr, &addrLen);

	if (DCM_DEBUG) printf("\ninit_server(): listenSock = %d,    dicomSock = %d\n", listenSock, *dicomSock);

	if (*dicomSock == INVALID_SOCKET) {
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
	sprintf(text, "Connected to %s", destination);
	print_message(0, text);

	// set socket to non-blocking (we're more flexible this way

	wOpt = 1;

#ifdef MS_NT
	if (ioctlsocket(*dicomSock, FIONBIO, (u_long *)&wOpt))
	    printf("\nioctlsocket() (non-block) error in init_server()\n");
#else
	if (ioctl(*dicomSock, FIONBIO, (u_long *)&wOpt))
	    printf("\nioctl() (non-block) error in init_server()\n");
#endif

	// set close to don't linger, as per DICOM PS 3.8-1998 9.1.4
	stTimeOut.l_onoff = 0;
	if (setsockopt(*dicomSock, SOL_SOCKET, SO_LINGER, 
		(char *) &stTimeOut, sizeof(stTimeOut)))
		printf("\nsetsockopt(SO_LINGER) error in init_server()\n");

	return;
}




/***********************************************************************
**                                                                    **
**  send_msg(...)                                                     **
**                                                                    **
**  send a message to the MUMPS backend process                       **
**                                                                    **
**  All messages are of the format <length><text>, where <length>     **
**  is the number of characters of text following.  <length> is       **
**  formatted as a zero-padded four digit field.                      **
**                                                                    **
***********************************************************************/

void send_msg(
	char	*message,				// pointer to the message that is to be sent
	SOCKET	mumpsSock)				// socket for communications with MUMPS backend
{
	char    msg_buffer[210];		// message buffer

	if (DCM_DEBUG) {
		printf("\nSending <<%s>>", message);
	}
	sprintf(msg_buffer,"%04d%s", strlen(message), message);
	network_write(mumpsSock, msg_buffer, strlen(msg_buffer));
}


/***********************************************************************
**                                                                    **
**  recv_msg(...)                                                     **
**                                                                    **
**  receive a message from the MUMPS backend process                  **
**                                                                    **
**  All messages are of the format <length><text>, where <length>     **
**  is the number of characters of text following.  <length> is       **
**  formatted as a zero-padded four digit field.                      **
**                                                                    **
***********************************************************************/
void recv_msg(
	char	*message,				// pointer to the message after it has been received
	SOCKET	mumpsSock)				// socket for communications with MUMPS backend
{
	char    msg_buffer[210];		// message buffer
	int     length;					// length of message in bytes
	int     i;						// working variable

	memset (msg_buffer, 0, sizeof(msg_buffer));
	i = network_read(mumpsSock, msg_buffer, 4, 5);     // get the message length
	
	if (i != 4) {
		printf("\nMUMPS length network_read() error: %d\n", i);
		closesocket(mumpsSock);
		exit_prompt(1);	
		exit (1);
	}
	length = atoi(msg_buffer);
	// printf("In recv_msg(), length = %d,  msg_buffer = \"%s\"\n", length, msg_buffer);
	i = network_read(mumpsSock, message, length, 1); // get the message

	if (i != length) {
		system(COLOR_RED);
		printf("\nMUMPS message network_read() error: %d\n", i);
		closesocket(mumpsSock);
		exit_prompt(1);	
		exit (1);
	}

	message[length] = '\0';

	if (DCM_DEBUG) {
		printf("\nRecving <<%s>>\n", message);
	}
}

/***********************************************************************
**                                                                    **
**  disk_read(...)                                                    **
**                                                                    **
**  read bytes from the disk file with the appropriate error checking **
**                                                                    **
***********************************************************************/

int disk_read(
	FILE	*input,			// pointer to input file descriptor on disk 
	char	*buffer,		// input buffer pointer
	int		count,			// number of bytes to read
	int		thread_number)	// 0 for main(), 1, 2, 3, 4, or 5 otherwise
{
	int     number_read;    // number of bytes read from file

	number_read = fread(buffer, 1, count, input);
	if ((number_read != count) & (feof(input) == 0)) {
		if (ferror(input)) {
			printf("*** Disk Read error ***\n");
			error_trap(thread_number);
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
**  disk_write(...)                                                   **
**                                                                    **
**  write bytes to the disk file with the appropriate error checking  **
**                                                                    **
***********************************************************************/

int disk_write(
	FILE	*output,		// pointer to output file descriptor on disk 
	char	*buffer,		// output buffer pointer
	int		count,			// number of bytes to write
	int		thread_number)	// 0 for main(), 1, 2, 3, 4, or 5 otherwise
{
	int     number_written; // number of bytes written to file
	char	message[200];

	number_written = fwrite(buffer, 1, count, output);
	if (number_written != count) {
		if (feof(output)) {
			system(COLOR_RED);
			sprintf(message, "Error disk_write(): Output EOF reached\n");
			print_message(thread_number, message);
			return (2);
		}
		if (ferror(output)) {
			system(COLOR_RED);
			sprintf(message, "*** Error disk_write(): number_written= %d  count= %d ***",
				number_written, count);
			print_message(thread_number, message);
			error_trap(thread_number);
			return (3);
		}               
		system(COLOR_RED);
		sprintf(message, "Unknown error disk_write(): number_written= %d  count= %d\n",
				number_written,count);
		print_message(thread_number, message);
		return (4);
	}
	return (0);
}




/***********************************************************************
**                                                                    **
**  check_response(...)                                               **
**                                                                    **
**  Compare a message received from the MUMPS backend with a know     **
**  string to verify that it was correctly received.                  **
**                                                                    **
***********************************************************************/
void check_response(
	char	*message,			// text message to check
	char	*expected,			// exact string to compare
	SOCKET	mumpsSock)          // socket for communications with MUMPS backend
{
	if (DCM_DEBUG > 2)
		printf ("\n     Expect \"%s\", \nActual Text \"%s\".", expected, message);
	if (strcmp(message, expected) != 0) {
			printf("\n\n*** Error: Incorrect Message \"%s\" ***\n", message);
			printf("*** It should have been \"%s\"***\n", expected);
			closesocket(mumpsSock);
			exit_prompt(1);
			exit (0);
		}
}





/***********************************************************************
**                                                                    **
**  file_open(...)                                                    **
**                                                                    **
**  Open a file with fopen(), but provide debug tracing information.  **
**                                                                    **
***********************************************************************/
FILE * file_open(
	const char *filename,
	const char *mode,
	int thread_number)			// 0 for main(), 1, 2, 3, 4, or 5 otherwise
{
	FILE *	stream;				// file descriptor return of real fopen();
	char	message[200];		// output message

	stream = fopen(filename, mode);
	if (DCM_DEBUG) {
		sprintf(message, "File \"%s\" opened with mode \"%s\" with file descriptor %p for _file=%d\n",
			filename, mode, stream, stream->_file);
		print_message(thread_number, message);
	}

	return stream;
}


/***********************************************************************
**                                                                    **
**  close_file(...)                                                   **
**                                                                    **
**  Close a file with fclose(), but only if it is currently open.     **
**  Provide debug tracing information.                                **
**                                                                    **
***********************************************************************/
int file_close(
	FILE ** stream,
	int thread_number)			// 0 for main(), 1, 2, 3, 4, or 5 otherwise
{	
	int		status = 0;			// return status
	char	message[200];		// output message
	FILE	*file_descriptor;	// file descriptor pointer

	if (*stream == 0) {
		if (DCM_DEBUG) {
			sprintf(message, "Stream already closed\n");
			print_message(thread_number, message);
		}
	}
	else {
		file_descriptor = *stream;
		status = fclose(*stream);
		if (DCM_DEBUG) {
			sprintf(message, "Stream %p for _file=%d closed -- status = %d\n",
				*stream, file_descriptor->_file, status);
			print_message(thread_number, message);
		}

		*stream = 0;				// clear so that you don't get duplicate closure
	}
	return status;
}



/***********************************************************************
**                                                                    **
**  error_trap(...)                                                   **
**                                                                    **
**  Provide the system error number and message.                      **
**                                                                    **
***********************************************************************/
void error_trap(
	int		thread_number)	// 0 for main(), 1, 2, 3, 4, or 5 otherwise
{
	DWORD error_code=0;
	void *p_text;
	char message[200];

	error_code = GetLastError();

	if (error_code == 0) {
		sprintf(message,"System Error #: 0\n\n\n");
	}
	else {
		DWORD count = ::FormatMessage (FORMAT_MESSAGE_ALLOCATE_BUFFER |
                                FORMAT_MESSAGE_FROM_SYSTEM |
                                FORMAT_MESSAGE_MAX_WIDTH_MASK,
                                NULL,
                                error_code,
                                MAKELANGID (LANG_NEUTRAL, SUBLANG_DEFAULT),
                                (LPTSTR) &p_text,
                                0,
                                NULL);
	
		sprintf(message,"System Error #: %d -- %s\n\n\n", error_code, (char *) p_text);
		::LocalFree (p_text);  //free buffer
	}

	print_message(thread_number ,message);

	return;
}
/***********************************************************************
**                                                                    **
**  exit_prompt(...)                                                  **
**                                                                    **
**  If an error occurs, the appropriate message is displayed on the   **
**  screen.  Then exit_prompt() is called to "freeze" the screen.     **
**                                                                    **
***********************************************************************/

void exit_prompt(
	int	error_flag)				// 0 = no error, 1 = fatal error
{
		if (error_flag) system(COLOR_RED);
		printf("\nPush <Enter> to exit...");
		getchar(); // require a newline
}



/***********************************************************************
**                                                                    **
**  net_close(...)                                                    **
**                                                                    **
**  Close both the DICOM and MUMPS sockets                            **
**                                                                    **
***********************************************************************/
void net_close(
	SOCKET	dicomSock,			// socket for DICOM communications
	SOCKET	mumpsSock)			// socket for communications with MUMPS backend
{
	closesocket(mumpsSock);
	closesocket(dicomSock);
}
