using afIoc
using afIocConfig
using afEfanXtra

** (efan component) Renders the Google Universal Analytics script.
const mixin GoogleAnalytics : EfanComponent {
	@Inject	abstract internal Log log
	
	@Config { id="afGoogleAnalytics.accountNumber" }
	@Inject	abstract internal Str accountNumber

	@Config { id="afGoogleAnalytics.accountDomain" }
	@Inject	abstract internal Str googleDomain

	@Config { id="afBedSheet.host" }
	@Inject	abstract internal Uri bedSheetHost

	@Config { id="afIocEnv.isProd" }
	@Inject	abstract internal Bool? isProd

	@InitRender
	internal Bool initRender() {
		borked := false
	
		if (accountNumber.isEmpty) {
			log.warn("Google Analytics Account Number has not been set.\n Please add the following to your AppModule's contributeApplicationDefaults() method:\n   config[${GoogleAnalyticsConfigIds#.name}.${GoogleAnalyticsConfigIds#accountNumber.name}] = \"GA-ACC-NO\");")
			borked = true
		}
		
		return isProd && !borked
	}
	
	internal Str accountDomain() {
		googleDomain.isEmpty ? bedSheetHost.host : googleDomain
	}
}
