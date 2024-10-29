package va.gov.vista.kidsbundler;


import java.io.IOException;
import java.net.URISyntaxException;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.Iterator;
import java.util.Properties;

import javax.xml.bind.JAXBContext;
import javax.xml.bind.JAXBException;
import javax.xml.bind.Unmarshaller;

import org.apache.commons.cli.CommandLine;
import org.apache.commons.cli.CommandLineParser;
import org.apache.commons.cli.GnuParser;
import org.apache.commons.cli.HelpFormatter;
import org.apache.commons.cli.MissingOptionException;
import org.apache.commons.cli.Option;
import org.apache.commons.cli.OptionBuilder;
import org.apache.commons.cli.Options;
import org.apache.commons.cli.ParseException;
import org.apache.commons.cli.UnrecognizedOptionException;
import org.apache.commons.configuration.Configuration;
import org.apache.commons.configuration.ConfigurationException;
import org.apache.commons.configuration.PropertiesConfiguration;
import org.apache.commons.io.FilenameUtils;
import org.apache.log4j.FileAppender;
import org.apache.log4j.Logger;
import org.apache.log4j.PatternLayout;
import org.apache.log4j.PropertyConfigurator;


import va.gov.vista.kidsbundler.manifest.KidsBundlerManifest;

@SuppressWarnings("static-access")
public class KidsBundler {
	private static final Logger logger = Logger.getLogger(KidsBundler.class);
	private static final String PROPERTY_PREFIX = "va.gov.vista.kids.bundle.";
	private static final Options commandLineOptions = new Options();
	private static final Path configPath;
	private static final Path log4jConfigPath;

	static {
		Path appPath = null;
		try {
			appPath = Paths.get(KidsBundler.class.getProtectionDomain()
					.getCodeSource().getLocation().toURI());
		} catch (URISyntaxException e) {
			logger.error(e);
		}

		configPath = appPath.resolve("../KIDSBundler.properties");
		log4jConfigPath = appPath.resolve("../log4j.properties");

		commandLineOptions.addOption(OptionBuilder
				.withArgName(PROPERTY_PREFIX + "manifest").hasArg()
				.withDescription("use given file for the bundle manifest")
				.isRequired()
				.create("m"));
		commandLineOptions.addOption(OptionBuilder
				.withArgName(PROPERTY_PREFIX + "outputDirectory").hasArg()
				.withDescription("sets the directory for the output")
				.create("o"));
		commandLineOptions.addOption(OptionBuilder
				.withArgName(PROPERTY_PREFIX + "outputFileName").hasArg()
				.withDescription("sets the output file name")
				.create("n"));
		commandLineOptions.addOption(OptionBuilder
				.withArgName(PROPERTY_PREFIX + "[property]=value").hasArgs(2)
				.withValueSeparator()
				.withDescription("use value for given property")
				.create("D"));
	}

	public static Configuration loadConfiguration(CommandLine cl) {
		PropertiesConfiguration config = new PropertiesConfiguration();

		// set the configuration defaults
		config.setListDelimiter(',');
		try {
			config.load(configPath.toFile());
		} catch (ConfigurationException e) {
			logger.error(e);
		}

		// convert some shortcut names to the appropriate prefixes
		String value, clKey, configKey;
		for (Option option : cl.getOptions()) {
			clKey = option.getOpt();
			if (clKey != null && !clKey.equals("D")) {
				configKey = option.getArgName();
				value = cl.getOptionValue(clKey);
				if (value != null && !value.equals("")) {
					logger.debug("overriding property " + configKey
							+ " from the command line option " + clKey
							+ " with the value: " + value);
					config.setProperty(configKey, value);
				}
			}
		}

		// Override any properties specified on the command line
		Properties cliProps = cl.getOptionProperties("D");
		for (String propName : cliProps.stringPropertyNames()) {
			value = cliProps.getProperty(propName);
			logger.debug("overriding property " + propName
					+ " from the command line with the value: " + value);
			config.setProperty(propName, cliProps.getProperty(propName));
		}

		return config;
	}

	public static void main(String[] args) {
		PropertyConfigurator.configure(log4jConfigPath.toAbsolutePath()
				.toString());
		CommandLine cl = parseCommandLine(args);
		Configuration config = loadConfiguration(cl);
		KidsBundler bundle = new KidsBundler(config);
		bundle.configure();
		bundle.loadManifest();
		bundle.loadKidsAttributes();
	    bundle.loadKidsPatches();
		bundle.verifySetup();
		bundle.writeBundle();
	}

	public static CommandLine parseCommandLine(String[] args) {
		CommandLineParser parser = new GnuParser();
		CommandLine cl = null;
		try {
			cl = parser.parse(commandLineOptions, args);
		} catch (MissingOptionException moe) {
			logger.error(moe);
			HelpFormatter formatter = new HelpFormatter();
			formatter.printHelp("KIDSBundler", commandLineOptions);
			System.exit(0);
		} catch (UnrecognizedOptionException uroe) {
			logger.error(uroe);
			HelpFormatter formatter = new HelpFormatter();
			formatter.printHelp("KIDSBundler", commandLineOptions);
			System.exit(0);
		} catch (ParseException pe) {
			logger.error(pe);
			HelpFormatter formatter = new HelpFormatter();
			formatter.printHelp("KIDSBundler", commandLineOptions);
			System.exit(0);
		}
		return cl;
	}

	private final Configuration configuration;
    private final KidsBundlerPackage kidsBundlerPackage;
	private KidsBundlerManifest manifest;
	private Path manifestPath;
	private Path outputDirPath;
	private Path outputFilePath;
	private Path outputLogPath;
	private Path kidsExportPath;
	
	public KidsBundler(Configuration config) {
		this.kidsBundlerPackage = new KidsBundlerPackage();
		this.configuration = config;
	}

	public void configure() {
		configurePaths();
		configureBundlerLog();
		
		logger.info("Configured Properties:");
		Iterator<String> keys = configuration.getKeys();
		String key;
		while (keys.hasNext()) {
			key = keys.next();
			logger.info(key + "=" + configuration.getProperty(key));
		}
		
		this.kidsBundlerPackage.setComment(configuration.getString(
				PROPERTY_PREFIX + "Comment", ""));
		
		this.kidsBundlerPackage.setKidsExportPath(kidsExportPath);
	
	}

	private void configureBundlerLog() {		try {
			FileAppender appender = new FileAppender(new PatternLayout(
					"%-4r [%t] %-5p %c %x - %m%n"),
					this.outputLogPath.toString());
			Logger.getRootLogger().addAppender(appender);
		} catch (IOException e) {
			// TODO Auto-generated catch block
			logger.error(e);
		}
	}

	private void configurePaths() {
		this.manifestPath = Paths.get(configuration.getString(PROPERTY_PREFIX
				+ "manifest"));

		String outputDir = configuration.getString(PROPERTY_PREFIX
				+ "outputDirectory", null);
		if (outputDir == null || outputDir.equals(""))
			outputDir = this.manifestPath.getParent().toString();
		this.outputDirPath = Paths.get(outputDir);
		this.outputDirPath.toFile().mkdirs();

		String fileName = configuration.getString(PROPERTY_PREFIX
				+ "outputFileName", null);
		if (fileName == null || fileName.equals(""))
			fileName = FilenameUtils.removeExtension(this.manifestPath
					.getFileName().toString());
		if (!fileName.toUpperCase().endsWith(".KID"))
			fileName = fileName + ".KID";
		this.outputFilePath = this.outputDirPath.resolve(fileName);

		this.outputLogPath = this.outputDirPath.resolve(FilenameUtils
				.removeExtension(fileName) + ".log");

		this.kidsExportPath = manifestPath
				.getParent()
				.resolve(
						configuration.getString(PROPERTY_PREFIX
								+ "rootDirectory", ".")).normalize();
	}

	public void loadKidsAttributes() {
		this.kidsBundlerPackage.setComment(manifest.getComment());
		this.kidsBundlerPackage.setPatchName(manifest.getPatchName());
	}

	public void loadKidsPatches() {
		
		if (manifest.getPatches() != null) {
			this.kidsBundlerPackage.getPatches().addAll(
					manifest.getPatches());
		}

	}

	public void loadManifest() {
		JAXBContext jaxbContext;
		try {
			jaxbContext = JAXBContext.newInstance(KidsBundlerManifest.class);
			Unmarshaller unmarshaller = jaxbContext.createUnmarshaller();
			manifest = (KidsBundlerManifest) unmarshaller.unmarshal(manifestPath
					.toFile());
		} catch (JAXBException e) {
			logger.error(e);
			System.exit(0);
		}
	}

	public void verifySetup() {

	}

	public void writeBundle() {
		KidsBundlerWriter kidsBundlerWriter = new KidsBundlerWriter(this.kidsBundlerPackage);
		kidsBundlerWriter.writeKidsBundler(outputFilePath);
		logger.info(outputFilePath);
	}
}