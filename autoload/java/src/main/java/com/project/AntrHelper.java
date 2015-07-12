package com.project;

import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Enumeration;
import java.util.Iterator;
import java.util.List;
import java.util.jar.JarEntry;
import java.util.jar.JarFile;

import org.apache.bcel.classfile.ClassParser;
import org.apache.bcel.classfile.JavaClass;
import org.apache.bcel.classfile.Method;

public class AntrHelper{

	private final String L_DELIM = ",";
	private final String F_DELIM = ";";

	private String getClasses(final String jarFilename){
		StringBuilder classes = new StringBuilder();

		Iterator<String> entries = getAllClasses(jarFilename).listIterator();
		while(entries.hasNext()) {
			final String className = entries.next();
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

			classes.append(c).append(F_DELIM).append(p).append(F_DELIM).append(jarFilename);
			if (entries.hasNext()){
				classes.append(L_DELIM);
			}
		}
		return classes.toString();
	}

	private String getMethods(String jarFilename, String classNames) {
		StringBuilder classMethods = new StringBuilder();

		Iterator<String> entries = Arrays.asList(classNames.split(L_DELIM)).listIterator();
		while(entries.hasNext()) {
			final String className = entries.next().replace('.', File.separatorChar);
			ClassParser cp = new ClassParser(jarFilename,className);

			JavaClass jc=null;
			try{
				jc = cp.parse();
			}catch(Exception e){
				System.out.println(e);
			}

			final List<Method> _methodEntries = Arrays.asList(jc.getMethods());
			Iterator<Method> methodEntries = _methodEntries.listIterator(); 
			while(methodEntries.hasNext()){
				final Method method = methodEntries.next();
				classMethods.append(method.getName()).append(":").append(method.getSignature());
				if (methodEntries.hasNext()){
					classMethods.append(L_DELIM);
				}
			}

			if (entries.hasNext()){
				classMethods.append(L_DELIM);
			}
		}
		return classMethods.toString();
	}

	private List<String> getAllClasses(final String jarFilename){
		try(final JarFile jarFile=new JarFile(jarFilename)){
			List<String> classes = new ArrayList<String>();

			final Enumeration<JarEntry> entries = jarFile.entries();			
			while (entries.hasMoreElements()) {
				final JarEntry entry = entries.nextElement();
				final String entryName = entry.getName();
				if (entryName.endsWith(".class")){
					String className = entryName.replace('/', File.separatorChar);
					classes.add(className);
				}
			}
			return classes;
		}catch(IOException e){
			return null;
		}
	}


	public static void main(String[] argv) {
		AntrHelper m = new AntrHelper();

		if (argv.length < 1){
//			argv = new String[]{"classes", "/tmp/junit-4.11.jar", ""};
			argv = new String[]{"methods", "/tmp/junit-4.11.jar", "Test"};
		}

		if ("classes".equals(argv[0])){
			String jarFilename = argv[1];
			String classes = m.getClasses(jarFilename);
			System.out.println(classes);
			return;
		}

		if ("methods".equals(argv[0])){
			String jarFilename = argv[1];
			String classNames = argv[2];
			String methods = m.getMethods(jarFilename, classNames);
			System.out.println(methods);
			return;
		}

	}


}
