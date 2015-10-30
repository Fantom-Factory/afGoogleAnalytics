using afIoc
using afIocConfig::FactoryDefaults

** The [Ioc]`pod:afIoc` module class.
@NoDoc
const class GoogleAnalyticsModule {

	internal Void defineServices(RegistryBuilder bob) {
		bob.addService(GoogleAnalytics#)
	}

	@Contribute { serviceType=FactoryDefaults# }
	internal Void contributeFactoryDefaults(Configuration config) {
		config[GoogleAnalyticsConfigIds.accountNumber]	= ""
		config[GoogleAnalyticsConfigIds.accountDomain]	= ``
	}
}
