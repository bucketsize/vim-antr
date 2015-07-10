package com.project;

import java.io.File;
import java.io.IOException;
import java.util.Enumeration;
import java.util.jar.JarEntry;
import java.util.jar.JarFile;

import org.apache.bcel.classfile.ClassParser;
import org.apache.bcel.classfile.JavaClass;

public class AntrHelper{

	public String getClasses(final String jarFilename){
		try(final JarFile jarFile=new JarFile(jarFilename)){
			StringBuilder classes = new StringBuilder();
			
			final Enumeration<JarEntry> entries = jarFile.entries();			
			while (entries.hasMoreElements()) {
				final JarEntry entry = entries.nextElement();
				final String entryName = entry.getName();
				if (entryName.endsWith(".class")){
					String className = entryName.replace('/', File.separatorChar);
					ClassParser cp = new ClassParser(jarFilename,className);
					
					JavaClass jc=null;
					try{
						jc = cp.parse();
					}catch(Exception e){
						System.out.println(e);
					}
					
					String fqcn = jc.getClassName();
					int s = fqcn.lastIndexOf(".");
					
					String p = fqcn.substring(0,s).trim();
					String c = fqcn.substring(s+1).trim();

					classes.append(c).append("-").append(p).append("-").append(jarFilename);
					if (entries.hasMoreElements()){
						classes.append(",");
					}
				}
			}
			return classes.toString();
		}catch(IOException e){
			return "NONE-NONE";
		}
	}

	public static void main(String[] argv) {
		AntrHelper m = new AntrHelper();
		
		if (argv.length < 1){
			argv = new String[]{"/tmp/junit-4.11.jar", ""};
		}
		
		if ("class".equals(argv[0])){
			String jarFilename = argv[1];
			String classes = m.getClasses(jarFilename);
			System.out.println(classes);
			return;
		}
		
		if ("ctor".equals(argv[0])){
			String jarFilename = argv[1];
			String className = argv[2];
			String classes = m.getCtors(jarFilename, className);
			System.out.println(classes);
			return;
		}
		
		if ("ctor".equals(argv[0])){
			String jarFilename = argv[1];
			String className = argv[2];
			String classes = m.getMethods(jarFilename, className);
			System.out.println(classes);
			return;
		}
		
	}

	private String getMethods(String jarFilename, String className) {
		// TODO Auto-generated method stub
		return null;
	}

	private String getCtors(String jarFilename, String className) {
		// TODO Auto-generated method stub
		return null;
	}

}
