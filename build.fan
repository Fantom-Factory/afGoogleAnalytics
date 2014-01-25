using build::BuildPod

class Build : BuildPod {

	new make() {
		podName = "afGoogleAnalytics"
		summary = "(Internal) A simple efan component for rendering Google's Universal Analytics script"
		version = Version("0.0.3")

		meta	= [	
			"org.name"		: "Alien-Factory",
			"org.uri"		: "http://www.alienfactory.co.uk/",
			"vcs.uri"		: "https://bitbucket.org/AlienFactory/afgoogleanalytics",
			"proj.name"		: "Google Analytics",
			"license.name"	: "BSD 2-Clause License",	
			"repo.private"	: "true",

			"afIoc.module"	: "afGoogleAnalytics::GoogleAnalyticsModule"
		]


		index	= [	
			"afIoc.module"	: "afGoogleAnalytics::GoogleAnalyticsModule"
		]


		depends = [
			"sys 1.0", 
			"afIoc 1.5.2+", 
			"afIocConfig 1.0.2+",
			"afEfanXtra 1.0.6+"
		]
		
		srcDirs = [`fan/`]
		resDirs = [`doc/`, `res/`]

		docApi = true
		docSrc = true
	}
	
	@Target { help = "Compile to pod file and associated natives" }
	override Void compile() {
		// exclude test code when building the pod
		srcDirs = srcDirs.exclude { it.toStr.startsWith("test/") }
		resDirs = resDirs.exclude { it.toStr.startsWith("res/test/") }
		
		super.compile
		
		// copy src to %FAN_HOME% for F4 debugging
		log.indent
		destDir := Env.cur.homeDir.plus(`src/${podName}/`)
		destDir.delete
		destDir.create		
		`fan/`.toFile.copyInto(destDir)		
		log.info("Copied `fan/` to ${destDir.normalize}")
		log.unindent
	}
}
