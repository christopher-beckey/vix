/* string-lib.h - headers for string-lib.c
   Eugene Kim, <eekim@eekim.com>
   $Id: string-lib.h,v 1.1 2001/10/23 19:08:23 smm Exp $

   Copyright (C) 1996,1997 Eugene Eric Kim
   All Rights Reserved
*/

#ifndef _STRING_LIB
#define _STRING_LIB 1

char *newstr(char *str);
char *substr(char *str, int offset, int len);
char *replace_ltgt(char *str);
char *lower_case(char *buffer);

#endif
