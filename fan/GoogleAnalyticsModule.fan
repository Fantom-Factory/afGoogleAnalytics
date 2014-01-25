using afIoc
using afIocConfig::FactoryDefaults
using afEfanXtra

** The [Ioc]`http://www.fantomfactory.org/pods/afIoc` module class.
const class GoogleAnalyticsModule {

	@Contribute { serviceType=EfanLibraries# }
	internal static Void contributeEfanLibraries(MappedConfig config) {
		config["afGa"] = GoogleAnalyticsModule#.pod
	}

	@Contribute { serviceType=FactoryDefaults# }
	internal static Void contributeFactoryDefaults(MappedConfig config) {
		config[GoogleAnalyticsConfigIds.accountNumber]	= ""
		config[GoogleAnalyticsConfigIds.accountDomain]	= ``
	}
}
