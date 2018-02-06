using afIoc
using afIocConfig
using afDuvet
using afBedSheet::HttpRequest
using afBedSheet::HttpResponse
using afBedSheet::BedSheetServer
using util::JsonOutStream

** (Service) - 
** Renders the Google Universal Analytics script and sends page views and events.
** 
** See [analytics.js]`https://developers.google.com/analytics/devguides/collection/analyticsjs/` for details.
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
	** 
	** Note that if a URL is NOT supplied, then the query string is stripped from the rendered URL. 
	** This usually makes sense for Fantom web apps as query strings do not generally denote unique pages. 
	abstract Void renderPageView(Uri? url := null, [Str:Obj?]? fieldOptions := null)

	** Renders Javascript to send an event to google analytics. 
	abstract Void renderEvent(Str category, Str action, Str? label := null, Num? value := null, [Str:Obj?]? fieldOptions := null)

	** Renders Javascript to add an arbitrary command to the command queue. Example:
	** 
	**   syntax: fantom
	**   renderCmd("create", "UA-XXXXX-Y", "auto")
	** 
	** would render:
	**  
	**   syntax: javascript
	**   ga('create', 'UA-XXXXX-Y', 'auto');
	** 
	** Arguments have 'toStr' executed on them before rendering.
	** 
	** If the last argument is a Map, then it is serialised as JSON and used as the 'fieldsObject'. Example:
	** 
	**   syntax: fantom
	**   renderCmd("create", [
	**       "trackingId"   : "UA-XXXXX-Y",
	**       "cookieDomain" : "auto"
	**   ])
	** 
	** would render:
	**  
	**   syntax: javascript
	**   ga('create', {
	**       'trackingId'   : 'UA-XXXXX-Y',
	**       'cookieDomain' : 'auto'
	**   });
	**  
	abstract Void renderCmd(Str cmd, Obj? arg1 := null, Obj? arg2 := null, Obj? arg3 := null, Obj? arg4 := null)
}

internal const class GoogleAnalyticsImpl : GoogleAnalytics {
	@Inject	private const Log log
	
	@Config
	@Inject	override const Str accountNumber

	@Config { id="afGoogleAnalytics.accountDomain" }
	@Inject	private const Uri googleDomain

	@Config { id="afIocEnv.isProd" }
	@Inject	private const Bool? isProd

	@Inject	private const BedSheetServer	bedServer
	@Inject	private const HttpRequest		httpReq
	@Inject	private const HttpResponse		httpRes
	@Inject	private const HtmlInjector		injector
			private const Bool 				renderScripts
			override const Str? 			accountDomain

	new make(|This|in) {
		in(this)
		borked := false
		if (accountNumber.isEmpty) {
			log.warn("Google Analytics Account Number has not been set.\n Add the following to your AppModule's contributeApplicationDefaults() method:\n   config[${GoogleAnalyticsConfigIds#.name}.${GoogleAnalyticsConfigIds#accountNumber.name}] = \"UA-XXXXX-Y\");")
			borked = true
		}

		if (googleDomain.toStr.all { it.isAlphaNum || it == '.' })
			accountDomain = googleDomain.toStr
		else
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

	override Void renderPageView(Uri? url := null, [Str:Obj?]? fieldOptions := null) {
		if (renderScripts || log.isDebug) {
			if (renderScripts) renderGuas
			code := StrBuf()			
			join := |Obj? obj| { code.join(JsonOutStream.writeJsonToStr(obj), ", ") }
			join("send")
			join("pageview")
			join(url ?: httpReq.urlAbs.pathOnly.encode)	// pathOnly to cut off any query string --> Fantom apps are not CGI / PHP scripts!
			if (fieldOptions != null) join(fieldOptions)

			if (renderScripts)
				injector.injectScript.withScript("ga(${code});")
			if (log.isDebug)
				log.debug("ga(${code});")
		}
		httpReq.stash["afGoogleAnalytics.pageViewRendered"] = true
	}

	override Void renderEvent(Str category, Str action, Str? label := null, Num? value := null, [Str:Obj?]? fieldOptions := null) {
		if (renderScripts || log.isDebug) {
			if (renderScripts) renderGuas
			code := StrBuf()			
			join := |Obj? obj| { code.join(JsonOutStream.writeJsonToStr(obj), ", ") }
			join("send")
			join("event")
			join(category)
			join(action)
			if (label != null || value != null || fieldOptions != null)	join(label)
			if (				 value != null || fieldOptions != null)	join(value)
			if (								  fieldOptions != null)	join(fieldOptions)

			if (renderScripts)
				injector.injectScript.withScript("ga(${code});")
			if (log.isDebug)
				log.debug("ga(${code});")
		}
	}
	
	override Void renderCmd(Str cmd, Obj? arg1 := null, Obj? arg2 := null, Obj? arg3 := null, Obj? arg4 := null) {
		if (renderScripts || log.isDebug) {
			if (renderScripts) renderGuas

			args := [cmd, arg1, arg2, arg3, arg4].exclude { it == null }
			code := args.map |arg, i| {
				i == args.size - 1 && arg is Map
					? arg
					: arg.toStr
			}.map {
				JsonOutStream.writeJsonToStr(it)
			}.join(", ")
			
			if (renderScripts)
				injector.injectScript.withScript("ga(${code});")
			if (log.isDebug)
				log.debug("ga(${code});")
		}
	}
	
	private Void renderGuas() {
		injector.injectScript.withScript(
			"(function(i,s,o,g,r,a,m){i['GoogleAnalyticsObject']=r;i[r]=i[r]||function(){
			 (i[r].q=i[r].q||[]).push(arguments)},i[r].l=1*new Date();a=s.createElement(o),
			 m=s.getElementsByTagName(o)[0];a.async=1;a.src=g;m.parentNode.insertBefore(a,m)
			 })(window,document,'script','https://www.google-analytics.com/analytics.js','ga');
			 ga('create', '${accountNumber}', '${accountDomain}');")

		csp := httpRes.headers.contentSecurityPolicy
		addCsp(csp, "script-src",	"https", "https://www.google-analytics.com")	// for the main script
		addCsp(csp, "img-src",		"https", "https://www.google-analytics.com")	// for some tracking pixel
		addCsp(csp, "connect-src",	"https", "https://www.google-analytics.com")	// because of the odd CSP report 
		httpRes.headers.contentSecurityPolicy = csp

		cspro := httpRes.headers.contentSecurityPolicyReportOnly
		addCsp(cspro, "script-src",		"https", "https://www.google-analytics.com")	// for the main script
		addCsp(cspro, "img-src",		"https", "https://www.google-analytics.com")	// for some tracking pixel
		addCsp(cspro, "connect-src",	"https", "https://www.google-analytics.com")	// because of the odd CSP report 
		httpRes.headers.contentSecurityPolicyReportOnly = cspro
	}
	
	// this handy method was nabbed and updated from Duvet
	private static Bool addCsp([Str:Str]? csp, Str dirName, Str altDir, Str newDir) {
		if (csp == null)
			return false

		directive	:= csp[dirName]?.trimToNull ?: csp["default-src"]?.trimToNull
		if (directive == null)
			return false

		directives	:= directive.split
		if (directives.contains(altDir))	// e.g. 'unsafe-inline'
			return false
		
		if (directives.contains(newDir))
			return false
		
		csp[dirName] = directive.replace("'none'", "") + " " + newDir
		return true
	}
}
