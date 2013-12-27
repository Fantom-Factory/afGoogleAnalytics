using afIoc
using afIocConfig::FactoryDefaults
using afEfanXtra

const class GoogleAnalyticsModule {

	@Contribute { serviceType=EfanLibraries# }
	internal static Void contributeEfanLibraries(MappedConfig config) {
		config["afGua"] = GoogleAnalyticsModule#.pod
	}

	@Contribute { serviceType=FactoryDefaults# }
	static Void contributeApplicationDefaults(MappedConfig config) {
		config[GoogleAnalyticsConfigIds.accountNumber]	= ""
		config[GoogleAnalyticsConfigIds.accountDomain]	= ""
	}
}
