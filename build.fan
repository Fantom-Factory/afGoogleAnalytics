using build

class Build : BuildPod {

	new make() {
		podName = "afGoogleAnalytics"
		summary = "A simple efan component for rendering Google's Universal Analytics script"
		version = Version("1.0.0")

		meta	= [	
			"proj.name"		: "Google Analytics",
			"afIoc.module"	: "afGoogleAnalytics::GoogleAnalyticsModule",
			"repo.internal"	: "true",			
			"repo.tags"		: "web",
			"repo.public"	: "false",
		]

		index	= [	
			"afIoc.module"	: "afGoogleAnalytics::GoogleAnalyticsModule"
		]

		depends = [
			"sys 1.0", 
			"afIoc       3.0.0 - 3.0", 
			"afIocConfig 1.1.0 - 1.1",
			"afEfanXtra  1.2.0 - 1.2"
		]
		
		srcDirs = [`fan/`]
		resDirs = [`doc/`, `res/`]
	}
}
