using afIoc
using afIocConfig
using afEfanXtra

** (efan component) Renders the Google Universal Analytics script.
const mixin GoogleAnalytics : EfanComponent {
	@Inject	abstract Log log
	
	@Config { id="afGoogleAnalytics.accountNumber" }
	@Inject	abstract Str accountNumber

	@Config { id="afGoogleAnalytics.accountDomain" }
	@Inject	abstract Uri googleDomain

	@Config { id="afBedSheet.host" }
	@Inject	abstract Uri bedSheetHost

	@Config { id="afIocEnv.isProd" }
	@Inject	abstract Bool? isProd

	@InitRender
	Bool initRender() {
		borked := false
		
		if (accountNumber.isEmpty) {
			log.warn("Google Analytics Account Number has not been set.\n Add the following to your AppModule's contributeApplicationDefaults() method:\n   config[${GoogleAnalyticsConfigIds#.name}.${GoogleAnalyticsConfigIds#accountNumber.name}] = \"GA-ACC-NO\");")
			borked = true
		}
		
		if (isProd && (accountDomain == null || accountDomain.lower.contains("localhost"))) {
			log.warn("Google Analytics Domain `${accountDomain}` is not valid'!\n Add the following to your AppModule's contributeApplicationDefaults() method:\n   config[${GoogleAnalyticsConfigIds#.name}.${GoogleAnalyticsConfigIds#accountDomain.name}] = \"http://www.example.com\");")
			borked = true
		}
		
		return isProd && !borked
	}
	
	Str? accountDomain() {
		return googleDomain.toStr.isEmpty ? bedSheetHost.host : googleDomain.host
	}
}
