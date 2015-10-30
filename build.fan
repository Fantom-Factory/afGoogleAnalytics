using build

class Build : BuildPod {

	new make() {
		podName = "afGoogleAnalytics"
		summary = "An IoC service to render Google's Universal Analytics script"
		version = Version("1.1.0")

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
			"sys         1.0.67 - 1.0", 
			"afIoc       3.0.0  - 3.0", 
			"afIocConfig 1.1.0  - 1.1",
			"afDuvet     1.1.0  - 1.1"
		]
		
		srcDirs = [`fan/`]
		resDirs = [`doc/`]
	}
}
