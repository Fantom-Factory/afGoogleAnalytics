using build

class Build : BuildPod {

	new make() {
		podName = "afGoogleAnalytics"
		summary = "An IoC service to render Google's Universal Analytics script"
		version = Version("0.1.3")

		meta	= [	
			"proj.name"		: "Google Analytics",
			"afIoc.module"	: "afGoogleAnalytics::GoogleAnalyticsModule",
			"repo.internal"	: "true",			
			"repo.tags"		: "web",
			"repo.public"	: "false",
		]

		depends = [
			"sys         1.0.68 - 1.0", 
			"afIoc       3.0.0  - 3.0", 
			"afIocConfig 1.1.0  - 1.1",
			"afBedSheet  1.5.0  - 1.5",
			"afDuvet     1.1.0  - 1.1"
		]
		
		srcDirs = [`fan/`]
		resDirs = [`doc/`]
	}
}
