using afIoc
using afIocConfig
using afEfanXtra

const mixin GoogleAnalytics : EfanComponent {
	// TODO: afIoc-1.5 - Inject
	private static const Log log	:= GoogleAnalytics#.pod.log
	
	@Config { id="afGoogleAnalytics.accountNumber" }
	@Inject	abstract Str accountNumber

	@Config { id="afGoogleAnalytics.accountDomain" }
	@Inject	abstract Str accountDomain

	@Config { id="afIocEnv.isProd" }
	@Inject	abstract Bool? isProd

	Bool initRender() {
		borked := false
	
		if (accountNumber.isEmpty) {
			log.warn("Google Analytics Account Number has not been set.\n Please add the following to your AppModule's contributeApplicationDefaults() method:\n   config[${GoogleAnalyticsConfigIds#.name}.${GoogleAnalyticsConfigIds#accountNumber.name}] = \"GA-ACC-NO\");")
			borked = true
		}

		if (accountDomain.isEmpty) {
			log.warn("Google Analytics Account Domain has not been set.\n Please add the following to your AppModule's contributeApplicationDefaults() method:\n   config[${GoogleAnalyticsConfigIds#.name}.${GoogleAnalyticsConfigIds#accountDomain.name}] = \"wotever.com\");")
			borked = true
		}
		
		return isProd && !borked
	}
	
}
