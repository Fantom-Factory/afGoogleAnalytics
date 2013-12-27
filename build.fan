using build::BuildPod

class Build : BuildPod {

	new make() {
		podName = "afGoogleAnalytics"
		summary = "(Internal) A simple efan component for rendering Google's Universal Analytics script"
		version = Version("0.0.1")

		meta	= [	"org.name"		: "Alien-Factory",
					"org.uri"		: "http://www.alienfactory.co.uk/",
					"vcs.uri"		: "https://bitbucket.org/Alien-Factory/afgoogleanalytics",
					"proj.name"		: "Google Analytics",
					"license.name"	: "BSD 2-Clause License",	
					"repo.private"	: "true"

					,"afIoc.module"	: "afGoogleAnalytics::GoogleAnalyticsModule"
				]


		index	= [	"afIoc.module"	: "afGoogleAnalytics::GoogleAnalyticsModule"
				]


		depends = ["sys 1.0", "afIoc 1.4+", "afEfanXtra 1+", "afIocConfig 0+"]
		srcDirs = [`fan/`]
		resDirs = [`doc/`, `res/`]

		docApi = true
		docSrc = true

	}
}
