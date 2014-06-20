using build

class Build : BuildPod {

	new make() {
		podName = "afGoogleAnalytics"
		summary = "A simple efan component for rendering Google's Universal Analytics script"
		version = Version("0.0.5")

		meta	= [	
			"proj.name"		: "Google Analytics",
			"afIoc.module"	: "afGoogleAnalytics::GoogleAnalyticsModule",
			"internal"		: "true",			
			"tags"			: "web",
			"repo.private"	: "true",
		]

		index	= [	
			"afIoc.module"	: "afGoogleAnalytics::GoogleAnalyticsModule"
		]


		depends = [
			"sys 1.0", 
			"afIoc 1.6.2+", 
			"afIocConfig 1.0.6+",
			"afEfanXtra 1.1.4+"
		]
		
		srcDirs = [`fan/`]
		resDirs = [`res/`]
	}
}
