using build

class Build : BuildPod {

	new make() {
		podName = "afGoogleAnalytics"
		summary = "A simple efan component for rendering Google's Universal Analytics script"
		version = Version("0.0.7")

		meta	= [	
			"proj.name"		: "Google Analytics",
			"afIoc.module"	: "afGoogleAnalytics::GoogleAnalyticsModule",
			"internal"		: "true",			
			"repo.tags"		: "web",
			"repo.public"	: "false",
		]

		index	= [	
			"afIoc.module"	: "afGoogleAnalytics::GoogleAnalyticsModule"
		]

		depends = [
			"sys 1.0", 
			"afIoc       1.7.2+", 
			"afIocConfig 1.0.10+",
			"afEfanXtra  1.1.8+"
		]
		
		srcDirs = [`fan/`]
		resDirs = [`doc/`, `res/`]
	}
}
