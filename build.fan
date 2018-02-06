using build

class Build : BuildPod {

	new make() {
		podName = "afGoogleAnalytics"
		summary = "An IoC service to render Google's Universal Analytics script"
		version = Version("0.1.9")

		meta	= [
			"pod.dis"		: "Google Analytics",
			"afIoc.module"	: "afGoogleAnalytics::GoogleAnalyticsModule",
			"repo.internal"	: "true",			
			"repo.tags"		: "web",
			"repo.public"	: "true",
		]

		depends = [
			"sys         1.0.70 - 1.0", 
			"util        1.0.70 - 1.0", 
			"afIoc       3.0.6  - 3.0", 
			"afIocConfig 1.1.0  - 1.1",
			"afBedSheet  1.5.10 - 1.5",
			"afDuvet     1.1.0  - 1.1"
		]
		
		srcDirs = [`fan/`]
		resDirs = [`doc/`]
	}
}
