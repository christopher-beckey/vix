package gov.va.med.imaging.util;

import java.io.IOException;
import java.io.InputStream;
import java.io.Serializable;
import java.net.URL;
import java.net.URLDecoder;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Comparator;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Map;
import java.util.Properties;
import java.util.Set;
import java.util.TreeSet;
import java.util.jar.JarFile;
import java.util.stream.Stream;

import gov.va.med.logging.Logger;

public class VersionFinder {
	private static Logger logger = Logger.getLogger(VersionFinder.class);
	
	static String fmt = "yyyy-MM-dd HH:mm:ss z";
	//SAMPLE MAVEN DATE 2022-11-10 22:10:15 UTC
	
	private static String convertUTCtoLocal(String date) {
		try {
			SimpleDateFormat sdfin = new SimpleDateFormat(fmt);
			SimpleDateFormat sdfout = new SimpleDateFormat(fmt);
			date = sdfout.format(sdfin.parse(date));
		} catch (ParseException e) {
            logger.warn("Unable to parse manifest.properties date:{}", date);
		}
		return date;		
	}
	
	public static VersionFinderResult findVersions() throws IOException {
		Set<Artifact> jars = getJarManifestProperties();
		Set<Artifact> wars = getWarManifestProperties();

		VersionFinderResult result = new VersionFinderResult();
		result.add(jars);
		result.add(wars);
		
		Map<String,Integer>versions = new HashMap<String,Integer>();
		for(Artifact s: result.getSet()) {
			if(versions.containsKey(s.getVersion())) {
				Integer count = versions.get(s.getVersion());
				count++;
				versions.put(s.getVersion(),count);
			} else {
				versions.put(s.getVersion(),new Integer(1));
			}
		}
		result.setVersionSummary(versions);

		return result;
	}

	private static Set<Artifact> getWarManifestProperties() throws IOException {
		Set<Artifact> set = new HashSet<Artifact>();
		String appManifestFileName = new VersionFinder().getClass().getProtectionDomain().getCodeSource().getLocation()
				.toString() + JarFile.MANIFEST_NAME;
		if(!appManifestFileName.contains("webapps")) {
			return set;
		}
		
		String root = appManifestFileName.toString().substring(0, appManifestFileName.indexOf("webapps"));
		if( root.length()>6) root = root.substring(6);
		
		String decodedRoot = URLDecoder.decode(root, "UTF-8");
		try (Stream<Path> walkStream = Files.walk(Paths.get(decodedRoot))) {
			walkStream.filter(p -> p.toFile().isFile()).forEach(f -> {
				if (f.toString().contains("manifest.properties")) {
					try {
						Artifact one = createWarArtifact(f.toUri().toURL());
						if(one!=null) {
							set.add(one);
						}
					} catch (IOException e) {
                        logger.error("Unable to open manifest.properties on {}", f.toString());
					} 
				}
			});
		}
		return set;
	}

	private static Set<Artifact> getJarManifestProperties() throws IOException {
		Set<Artifact> set = new HashSet<Artifact>();
		Enumeration<URL> resEnum = Thread.currentThread().getContextClassLoader().getResources("manifest.properties");
		while (resEnum.hasMoreElements()) {
			URL url = (URL) resEnum.nextElement();
			Artifact one = createJarArtifact(url);
			if(one!=null && url.toString().contains("jar:")) {
				set.add(one);
			}
		}
		return set;
	}

	private static Artifact createJarArtifact(URL url) throws IOException {
		// open the manifest
		Artifact one = null;
		try(InputStream is = url.openStream()) {
			if (is != null) {
				Properties prop = new Properties();
				prop.load(is);
				String archiveUrl = url.toString().split("!")[0];
				String name = (String) prop.getProperty("build.name");
				String version = (String) prop.getProperty("build.version");
				String date = (String) prop.get("build.date");
				String user = (String) prop.get("build.user");
				if(user.toLowerCase().contains("vac10")) {
					user = "Jenkins";
				}
				one = new Artifact(name, archiveUrl, version, date,".jar",user);
			}
		}
		return one;
	}
	
	//
	//WEB-INF/classes/manifest.properties
	//
	private static Artifact createWarArtifact(URL url) throws IOException {
		// open the manifest
		Artifact one = null;
		try(InputStream is = url.openStream()) {
			if (is != null) {
				Properties prop = new Properties();
				prop.load(is);
				String archiveUrl = url.toString();
				String archiveName = archiveUrl.substring(archiveUrl.indexOf("/") + 1);
				String name = (String) prop.getProperty("build.name");
				archiveName = archiveName.substring(0,archiveName.indexOf("/"));
				String version = (String) prop.getProperty("build.version");
				String date = (String) prop.get("build.date");
				String user = (String) prop.get("build.user");
				if(user.toLowerCase().contains("vac10")) {
					user = "Jenkins";
				}
				one = new Artifact(name, archiveUrl, version, date, ".war", user);
			}
		}
		return one;
	}

	public static class Artifact implements Serializable {
		private static final long serialVersionUID = -285223897874975167L;
		private String name;
		private String path;
		private String version;
		private String date;
		private String type;
		private String user;

		public Artifact(String name, String path, String version, String date, String type, String user) {
			super();
			this.name = name;
			this.path = path;
			this.version = version;
			this.date = date;
			this.type = type;
			this.user = user;
		}

		public String getName() {
			return name;
		}

		public void setName(String name) {
			this.name = name;
		}

		public String getPath() {
			return path;
		}

		public void setPath(String path) {
			this.path=path;
		}

		public String getVersion() {
			return version;
		}

		public void setVersion(String version) {
			this.version = version;
		}

		public String getDate() {
			return date;
		}

		public void setDate(String date) {			
			this.date = convertUTCtoLocal(date);
		}

		public String getType() {
			return type;
		}

		public void setType(String type) {
			this.type = type;
		}

		public String getUser() {
			return user;
		}

		public void setUser(String user) {
			this.user = user;
		}

		@Override
		public String toString() {
			return "Artifact [name=" + name + ", path=" + path + ", version=" + version + ", date=" + date + ", type="
					+ type + ", user=" + user + "]";
		}

		public String toXml() {
			return "<artifact><type>"+type+"</type><name>"+name+"</name><version>"+version+"</version><date>"+date+"</date><path>"+path+"</path><user>"+(user==null?"unknown":user)+"</user></artifact>";
		}
		
		public String toHtml() {
			return "<tr><td>"+type+"</td><td>"+name+"</td><td>"+version+"</td><td>"+date+"</td><td>"+(user==null?"unknown":user)+"</td><td>"+path+"</td></tr>";
		}
	}

	public static class SortArtifact implements Comparator<Artifact> {
		public int compare(Artifact e1, Artifact e2) {
			String v1 = e1.getType() + e1.getName().toLowerCase();
			String v2 = e2.getType() + e2.getName().toLowerCase();
			return v1.compareTo(v2);
		}
	}
	
	public static class VersionFinderResult {
		private Set<Artifact> set = new TreeSet<Artifact>(new SortArtifact());
		Map<String,Integer>versionSummary = new HashMap<String,Integer>();
		
		public VersionFinderResult() {
			
		}
		
		public void add(Set<Artifact> artifacts) {
			set.addAll(artifacts);
		}

		public Set<Artifact> getSet() {
			return set;
		}

		public void setSet(Set<Artifact> set) {
			this.set = set;
		}

		public Map<String, Integer> getVersionSummary() {
			return versionSummary;
		}

		public void setVersionSummary(Map<String, Integer> versionSummary) {
			this.versionSummary = versionSummary;
		}
		
	}
}
