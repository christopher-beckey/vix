
typedef union
#ifdef __cplusplus
	YYSTYPE
#endif
{
	unsigned long	num;
	char		str[DICOM_LO_LENGTH+1];
	char		*s;
	DCM_ELEMENT	*e;
	LST_HEAD	*l;
	void		*v;
} YYSTYPE;
extern YYSTYPE yylval;
# define NUMBER 257
# define VALUE 258
