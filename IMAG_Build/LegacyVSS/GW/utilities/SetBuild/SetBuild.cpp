// SetBuild.cpp : Defines the entry point for the console application.
//

#include "stdafx.h"

void replace(char * line, char * string, int i, char * major, char * minor, char * patch, char * build, int zero);

int main(int argc, char* argv[])
{
 FILE *in;
 FILE *out;
 char line [1000];
 int done;
 int eol;
 int i;
 int letter;

    if (argc < 6)
	{
		printf ("Usage: SetBuild <filename> <major> <minor> <patch> <build>\n");
		printf ("(to set the version, patch and build numbers in the specified file\n");
		printf ("to the specified value)\n\n");
		return 1;
	}
	printf ("Set Version ID to %s.%s p%s b%s in file %s\n",
		     argv[2], argv[3], argv[4], argv[5], argv[1]);
	in = fopen (argv [1], "r");
	if (!in)
	{
		printf ("Cannot open %s for input.\n", argv [1]);
		return 2;
	}
	out = fopen ("version.new", "w");
	if (!out)
	{
		printf ("Cannot open 'version.new' for output.\n");
		return 3;
	}
	done = 0;
	while (!done)
	{
		i = 0;
		eol = 0;
		line [0] = 0;
		while (!eol)
		{
			letter = fgetc (in);
			if (letter == EOF)
			{
				eol = 1;
				done = 1;
				letter = 0;
			}
			if (letter == '\n')
			{
				eol = 1;
			}
			else
			{
				line [i++] = letter;
				line [i] = 0;
			}
		}
		if ((!done) || (line [0]))
		{
			replace (line, "FILEVERSION ", i, argv [2], argv [3], argv [4], argv [5], 0);
			replace (line, "PRODUCTVERSION ", i, argv [2], argv [3], argv [4], argv [5], 0);
			replace (line, "FileVersion\", \"", i, argv [2], argv [3], argv [4], argv [5], 1);
			replace (line, "ProductVersion\", \"", i, argv [2], argv [3], argv [4], argv [5], 1);
			fprintf (out, "%s\n", line);
		}
	}
	fclose (in);
	fclose (out);
	return 0;
}

void replace(char * line, char * string, int i, char * major, char * minor, char * patch, char * build, int zero)

{
 int end;
 int n;
 int ok;
 int v;

	for (end = 0, n = 0, v = 0; n < i; n++)
	{
		if (line [n] == string [v])
		{
			v++;
			if (!string [v]) end = n;
		}
		else
		{
			v = 0;
		}
	}
	if (end)
	{
		v = -1;
		ok = 1;
		while (ok)
		{
			v++;
			if (!major [v])
			{
				ok = 0;
			}
			else
			{
				line [++end] = major [v];
			}
		}
		line [++end] = ',';
		if (zero) line [++end] = ' ';
		v = -1;
		ok = 1;
		while (ok)
		{
			v++;
			if (!minor [v])
			{
				ok = 0;
			}
			else
			{
				line [++end] = minor [v];
			}
		}
		line [++end] = ',';
		if (zero) line [++end] = ' ';
		v = -1;
		ok = 1;
		while (ok)
		{
			v++;
			if (!build [v])
			{
				ok = 0;
			}
			else
			{
				line [++end] = build [v];
			}
		}
		line [++end] = ',';
		if (zero) line [++end] = ' ';
		v = -1;
		ok = 1;
		while (ok)
		{
			v++;
			if (!patch [v])
			{
				ok = 0;
			}
			else
			{
				line [++end] = patch [v];
			}
		}
		if (zero)
		{
			line [++end] = '\\';
			line [++end] = '0';
			line [++end] = '"';
		}
		line [++end] = 0;
	}
}
