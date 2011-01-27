
import java.io.*;
import java.util.*;

public class InfoEntityResolver {

	static Properties props;
	
	public static String resolve(String entityName) {
		if(props == null) {
			props = new Properties();
			String filename = System.getProperty("info.entity.map.file", "info-entity-map.txt");
			try {
				props.load(new FileInputStream(filename));
			}
			catch(IOException e) {
				System.err.println("Can't read " + filename);
			}
		}
		return props.getProperty(entityName, entityName);
	}
}