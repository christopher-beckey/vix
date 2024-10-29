#include "common.h"
#include "compressor.h"
#include "errors.h"

Params parseParameters(int argc, char ** argv);
void printUsage();

int main(int argc, char ** argv)
{
	Params params = parseParameters(argc,argv);
	ImageIO io;
	Compressor c(&io);
	int result = c.compress(&params);

	//If compress had an error then it will send it to stderr otherwise it will send a 0 which indicates
	//that there was no problem
	printf("%d",result);
	return result;
}

void printUsage()
{
	cout << "Usage: Compressor [options] -i [InputFilename] -o [OutputFilename]" << endl;
	cout << "\toptions:" << endl;
	cout << "\t-t [TIF, PPM, PGX, BMP, TGA, JPG, J2K, DCM, DCMJPG, DCMJ2K] Input Type" << endl;
	cout << "\t-c [J2K, JPG, DCM] Output Compression Type" << endl;
	cout << "\t-l lossy compression  (default J2k ratio = 10)  or  (default JPG quality = 75)" << endl;
	cout << "\t-r [Num] J2K Lossy Compression Ratio (3..)" << endl;
	cout << "\t-q [Num] JPG Lossy Compression Quality (1..100)" << endl;
	
	fprintf(stderr,"%d",EINVALIDUSAGE);
	exit(EINVALIDUSAGE);
}

Params parseParameters(int argc, char ** argv)
{
	Params params;
	int i, x;
	
	//Initialize the default compression parameters
	params.compressionRate = 0;
	params.lossless = true;
	params.inFilename = "";
	params.outFilename = "";
	params.outputType = J2K;
	params.inputType = UNKNOWN;

	//Cycle through the commandline parameters starting at 1 as the 0th commandline parameter is the program name
	for(x = 1; x < argc; ++x) {
		//check the 1st character of the parameter to determine what type of parameter it is, this assumes that there is a
		//- infront of the the option
		if(argv[x][0] != '-')
			printUsage();

		switch(argv[x][1]) {
			case 'i':		//The name of the file to be compressed
			case 'I':
				params.inFilename = argv[++x];
				break;
			case 'o':		//The name of the compressed file
			case 'O':	
				params.outFilename = argv[++x];
				break;
			case 'l':		//Indicates that the user wants lossy compression as opposed to lossless
			case 'L':
				params.lossless = false;
				break;
			case 'r':		//Indicates the compression rate of the lossy compression
			case 'R':
				params.compressionRate = atoi(argv[++x]);
				params.lossless = false;
				break;
			case 'q':		//Indicates the compression rate of the lossy compression
			case 'Q':
				params.compressionRate = atoi(argv[++x]);
				params.lossless = false;
				break;
			case 'c':		//Tells the compressor what kind of compressed file the user wants
			case 'C':
				{
					string tmp(argv[++x]);
					for (i = 0; i < tmp.length(); i++)
					{
						if ((tmp.at(i) > 96) && (tmp.at(i) < 123))
							tmp.at(i) -= 32; // Make parameter case insensitive
					}
					if(tmp == "J2K")
						params.outputType = J2K; // for DCM input type DCMJ2K
					else if(tmp == "JPG")
						params.outputType = JPG;
					else if(tmp == "DCM")
						params.outputType = DCM; // equivalent of DCMJ2K
					else
						printUsage();
				}
				break;
			case 't':
			case 'T':
				{
					string tmp(argv[++x]);
					for (i = 0; i < tmp.length(); i++)
					{
						if ((tmp.at(i) > 96) && (tmp.at(i) < 123))
							tmp.at(i) -= 32; // Make parameter case insensitive
					}
					if(tmp == "TIF")
						params.inputType = TIF;
					else if(tmp == "PPM")
						params.inputType = PPM;
					else if(tmp == "PGX")
						params.inputType = PGX;
					else if(tmp == "BMP")
						params.inputType = BMP;
					else if(tmp == "TGA")
						params.inputType = TGA;
					else if(tmp == "JPG")
						params.inputType = JPG;
					else if(tmp == "J2K")
						params.inputType = J2K;
					else if(tmp == "DCM")
						params.inputType = DCM;
					else if(tmp == "DCMJ2K")
						params.inputType = DCMJ2K;
					else if(tmp == "DCMJPG")
						params.inputType = DCMJPG;
					else {
						printUsage();
					}
				}
				break;
			default:
				printUsage();
				break;
		}
	}

	if(params.inFilename == "")
		printUsage();
	if ((params.outputType == JPG) && !params.lossless) {
		if (params.compressionRate == 0) params.compressionRate = 75; // force default lossy quality
		else  if ((params.compressionRate < 1) || (params.compressionRate > 100)) {
			printUsage();
		}
	} else 	if ((params.outputType == J2K) && !params.lossless) {
		if (params.compressionRate == 0) params.compressionRate = 10; // force default lossy ratio
		else if (params.compressionRate < 3) {
			printUsage();
		}
	}

	return params;
}
