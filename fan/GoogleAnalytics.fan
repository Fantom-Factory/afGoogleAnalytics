using afIoc
using afIocConfig
using afDuvet
using afBedSheet::HttpRequest
using afBedSheet::BedSheetServer

** (Service) - 
** Renders the Google Universal Analytics script and sends page views and events.
const mixin GoogleAnalytics {

	** Returns the domain used to setup the google script. 
	abstract Str? accountDomain()

	** Returns the account used to setup the google script. 
	abstract Str accountNumber()

	** Returns 'true' if the page has already rendered Javascript to send a page view event.
	** 
	** This allows individual pages to send page views for canonical URLs and a layout component to 
	** send general page views if the page hasn't done so. 
	abstract Bool pageViewRendered()

	** Renders Javascript to send a page view to google analytics. If 'url' is given then it should start with a leading '/', e.g. '/about'
	abstract Void renderPageView(Uri? url := null)

	** Renders Javascript to send an event to google analytics. 
	abstract Void renderEvent(Str category, Str action, Str? label := null)

	@NoDoc @Deprecated { msg="Use renderPageView() instead" }
	virtual Void sendPageView(Uri? url := null) {
		renderPageView(url)
	}

	@NoDoc @Deprecated { msg="Use renderEvent() instead" }
	virtual Void sendEvent(Str category, Str action, Str? label := null) {
		renderEvent(category, action, label)
	}
}

internal const class GoogleAnalyticsImpl : GoogleAnalytics {
	@Inject	private const Log log
	
	@Config { id="afGoogleAnalytics.accountNumber" }
	@Inject	override const Str accountNumber

	@Config { id="afGoogleAnalytics.accountDomain" }
	@Inject	private const Uri googleDomain

	@Config { id="afIocEnv.isProd" }
	@Inject	private const Bool? isProd

	@Inject	private const BedSheetServer	bedServer
	@Inject	private const HttpRequest		httpReq
	@Inject	private const HtmlInjector		injector
			private const Bool 				renderScripts
			override const Str? 			accountDomain

	new make(|This|in) {
		in(this)

		borked := false
		if (accountNumber.isEmpty) {
			log.warn("Google Analytics Account Number has not been set.\n Add the following to your AppModule's contributeApplicationDefaults() method:\n   config[${GoogleAnalyticsConfigIds#.name}.${GoogleAnalyticsConfigIds#accountNumber.name}] = \"GA-ACC-NO\");")
			borked = true
		}

		accountDomain = googleDomain.toStr.trim.isEmpty ? bedServer.host.host : googleDomain.host 
		if (isProd && (accountDomain == null || accountDomain.lower.contains("localhost"))) {
			log.warn("Google Analytics Domain `${accountDomain}` is not valid'!\n Add the following to your AppModule's contributeApplicationDefaults() method:\n   config[${GoogleAnalyticsConfigIds#.name}.${GoogleAnalyticsConfigIds#accountDomain.name}] = \"http://www.example.com\");")
			borked = true
		}

		renderScripts = isProd && !borked
	}
	
	override Bool pageViewRendered() {
		httpReq.stash["afGoogleAnalytics.pageViewRendered"] == true
	}

	override Void renderPageView(Uri? url := null) {
		if (renderScripts) {
			renderGuas
			
			if (url == null)
				// by default, cut off any query string from the rendered URL 
				url = bedServer.toAbsoluteUrl(httpReq.url).pathOnly
			
			// maybe allow the page to be set rather than passing in a url
			// see https://developers.google.com/analytics/devguides/collection/analyticsjs/pages
			injector.injectScript.withScript(url == null ? "ga('send', 'pageview');" : "ga('send', 'pageview', '${url.encode}');")
		}
		httpReq.stash["afGoogleAnalytics.pageViewRendered"] = true
	}

	override Void renderEvent(Str category, Str action, Str? label := null) {
		if (renderScripts) {
			renderGuas
			jsCategory	:= category.toCode('\'')
			jsAction	:= action.toCode('\'')
			jsLabel		:= label?.toCode('\'')
			injector.injectScript.withScript(label == null ? "ga('send', 'event', ${jsCategory}, ${jsAction});" : "ga('send', 'event', ${jsCategory}, ${jsAction}, ${jsLabel});")
		}
	}
	
	private Void renderGuas() {
		injector.injectScript.withScript(
			"(function(i,s,o,g,r,a,m){i['GoogleAnalyticsObject']=r;i[r]=i[r]||function(){
			 (i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),
			 m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)
			 })(window,document,'script','https://www.google-analytics.com/analytics.js','ga');
			 ga('create', '${accountNumber}', '${accountDomain}');")
	}
}
