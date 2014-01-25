
** A list of required config values.
const mixin GoogleAnalyticsConfigIds {

	 ** Your Google account number, usually in the form of 'UA-XXXXX-X'.
	 ** **Required!**
	static const Str accountNumber 	:= "afGoogleAnalytics.accountNumber";

	 ** Your Google account domain, in the format 'wotever.com'. 
	 ** If not supplied, it is taken from the BedSheet 'host' config value.
	static const Str accountDomain 	:= "afGoogleAnalytics.accountDomain";

}
