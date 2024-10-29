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

#define MS_NT 1       /* Set for NT only */

#ifdef MS_NT		/* MicroSoft NT with WINSOCK */
#include <winsock.h>
#define ENETRESET	WSAENETRESET
#define EWOULDBLOCK	WSAEWOULDBLOCK

#else			/* MicroSoft DOS with PCTCP FTP Software */
#include <sys/socket.h>
#include <4bsddefs.h>
#include <netdb.h>
#include <netinet/in.h>
#include <sys/ioctl.h>
#define send(a,b,c,d)	write(a,b,c)
#define recv(a,b,c,d)	read(a,b,c)
#define	closesocket(a)	close(a)
#define INVALID_SOCKET	(-1)
typedef	int	SOCKET;
#endif

#define BUFFER_SIZE (u_short) 45000
#define LOOP_LIMIT 0x00000005L

#define PDU_TYPE_DATA		0x04
#define PDU_TYPE_RELEASE	0x05
#define MAX_PDU_SIZE		8192
#define PDU_HDR			6
#define PDV_HDR			6

/* PDV message control values */
#define DATA_FRAGMENT		0x00
#define COMMAND_FRAGMENT	0x01
#define NOT_LAST_FRAGMENT	0x00
#define LAST_FRAGMENT		0x02

/* message transfer states */
#define INITIAL_STATE	0	/* before any messages */
#define COMMAND_STATE	1	/* processing a message command PDV */
#define INTERIM_STATE	2	/* after a command, before a dataset */
#define DATASET_STATE	3	/* processing a message dataset PDV */
#define	FINAL_STATE		4	/* after a dataset, before response */
#define EXCEPTION_STATE 5	/* after a command w/o a dataset */

/* colors for screen */
#define COLOR_RED	"COLOR FC"	// Bgnd: Bright White	Fgnd: Light Red
#define COLOR_YELLOW "COLOR E0"	// Bgnd: Bright Yellow	Fgnd: Black
#define COLOR_WHITE	"COLOR F1"	// Bgbd: Bright White	Fgnd: Blue
#define COLOR_BLUE	"COLOR 1F"	// Bgnd: Blue			Fgnd: Bright White
#define COLOR_TIMEOUT	10		// seconds to switch back to original color

extern void init_winsock(void);
extern int net_read_control(char *incoming_file);
extern int net_write_control(char *outgoing_file);
extern int net_read_command(char *incoming_file);
extern int net_read_dataset(char *incoming_file);
extern int net_read_pdv(SOCKET socket, char *buffer, int count);
extern int net_write_data(char *outgoing_file, int data_cmd_switch,
						long max_pdu_size, long offset, int context);
extern int network_read(SOCKET socket, char *buffer, int count, long timeout);
extern int network_write(SOCKET socket, char *buffer, int count);
extern void init_client(char *destination, char *error_nsg, u_short port, SOCKET *socket);
extern void init_server(char *destination, u_short port, SOCKET *socket, int connection_dropped);
extern void send_msg(char *message, SOCKET socket);
extern void recv_msg(char *message, SOCKET socket);
extern int disk_read(FILE *input, char *buffer, int count);
extern int disk_write(FILE *output, char *buffer, int count);
extern void check_response(char *message, char *expected);
extern void net_close(void);
extern int exit_trap(void);
extern void exit_prompt(int error_flag);
