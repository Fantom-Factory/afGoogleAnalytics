using build

class Build : BuildPod {

	new make() {
		podName = "afGoogleAnalytics"
		summary = "(Internal) A simple efan component for rendering Google's Universal Analytics script"
		version = Version("0.0.5")

		meta	= [	
			"org.name"		: "Alien-Factory",
			"org.uri"		: "http://www.alienfactory.co.uk/",
			"proj.name"		: "Google Analytics",
			"proj.uri"		: "http://repo.status302.com/doc/afGoogleAnalytics/",
			"vcs.uri"		: "https://bitbucket.org/AlienFactory/afgoogleanalytics",
			"license.name"	: "The MIT Licence",	
			"repo.private"	: "true",

			"tags"			: "web",
			"afIoc.module"	: "afGoogleAnalytics::GoogleAnalyticsModule"
		]


		index	= [	
			"afIoc.module"	: "afGoogleAnalytics::GoogleAnalyticsModule"
		]


		depends = [
			"sys 1.0", 
			"afIoc 1.6.0+", 
			"afIocConfig 1.0.4+",
			"afEfanXtra 1.0.14+"
		]
		
		srcDirs = [`fan/`]
		resDirs = [`licence.txt`, `doc/`, `res/`]

		docApi = true
		docSrc = true
	}
	
	@Target { help = "Compile to pod file and associated natives" }
	override Void compile() {
		// see "stripTest" in `/etc/build/config.props` to exclude test src & res dirs
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
