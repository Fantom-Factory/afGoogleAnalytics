using afIoc
using afIocConfig::FactoryDefaults
using afEfanXtra

** The [Ioc]`http://www.fantomfactory.org/pods/afIoc` module class.
@NoDoc
const class GoogleAnalyticsModule {

	@Contribute { serviceType=EfanLibraries# }
	internal static Void contributeEfanLibraries(Configuration config) {
		config["afGa"] = GoogleAnalyticsModule#.pod
	}

	@Contribute { serviceType=FactoryDefaults# }
	internal static Void contributeFactoryDefaults(Configuration config) {
		config[GoogleAnalyticsConfigIds.accountNumber]	= ""
		config[GoogleAnalyticsConfigIds.accountDomain]	= ``
	}
}
