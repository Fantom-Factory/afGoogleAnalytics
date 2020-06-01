# Google Analytics v0.1.10
---

[![Written in: Fantom](http://img.shields.io/badge/written%20in-Fantom-lightgray.svg)](https://fantom-lang.org/)
[![pod: v0.1.10](http://img.shields.io/badge/pod-v0.1.10-yellow.svg)](http://eggbox.fantomfactory.org/pods/afGoogleAnalytics)
[![Licence: ISC](http://img.shields.io/badge/licence-ISC-blue.svg)](https://choosealicense.com/licenses/isc/)

## Overview

*Google Analytics is a support library that aids Alien-Factory in the development of other libraries, frameworks and applications. Though you are welcome to use it, you may find features are missing and the documentation incomplete.*

Google Analytics is a simple service that sends page views and events to Google's [Universal Analytics](https://support.google.com/analytics/answer/2790010) script.

It uses [Duvet](http://eggbox.fantomfactory.org/pods/afDuvet) to render Javascript in HTML pages.

## <a name="Install"></a>Install

Install `Google Analytics` with the Fantom Pod Manager ( [FPM](http://eggbox.fantomfactory.org/pods/afFpm) ):

    C:\> fpm install afGoogleAnalytics

Or install `Google Analytics` with [fanr](https://fantom.org/doc/docFanr/Tool.html#install):

    C:\> fanr install -r http://eggbox.fantomfactory.org/fanr/ afGoogleAnalytics

To use in a [Fantom](https://fantom-lang.org/) project, add a dependency to `build.fan`:

    depends = ["sys 1.0", ..., "afGoogleAnalytics 0.1"]

## <a name="documentation"></a>Documentation

Full API & fandocs are available on the [Eggbox](http://eggbox.fantomfactory.org/pods/afGoogleAnalytics/) - the Fantom Pod Repository.

## Quick Start

Set the Google Analytic account in your `AppModule`:

    using afIoc
    using afIocConig
    using afGoogleAnalytics
    
    const class AppModule {
      @Contribute { serviceType=ApplicationDefaults# }
      Void contributeApplicationDefaults(Configuration config) {
    
        config[GoogleAnalyticsConfigIds.accountNumber] = "XX-99999999-9"
        config[GoogleAnalyticsConfigIds.accountDomain] = `http://example.org/`  // optional, defaults to 'auto'
      }
    }
    

Or set the properies in `config.props` (See [IoC Config](http://eggbox.fantomfactory.org/pods/afIocConfig))

    afGoogleAnalytics.accountNumber = XX-99999999-9
    afGoogleAnalytics.accountDomain = http://example.org/   // optional, defaults to 'auto'
    

The domain is optional and will be taken from the Bedsheet host / request host parameter if not supplied.

Then render the required Javascript via the `GoogleAnalytics` service:

    using afGoogleAnalytics::GoogleAnalytics
    
    ...
    
    @Inject GoogleAnalytics googleAnalytics
    
    ...
    
    googleAnalytics.renderPageView()
    

## Content-Security-Policy

GoogleAnalytics automatically updates any Content-Security-Policy HTTP response headers with all neccessary directives. But if you wish to add them manually, it's been observed that the following are required:

    script-src  https", "https://www.google-analytics.com
    img-src     https", "https://www.google-analytics.com
    connect-src https", "https://www.google-analytics.com

## Debugging

Note that Javascript is only rendered in `prod` mode (see [IoC Env](http://eggbox.fantomfactory.org/pods/afIocEnv) for details). Enable debugging if want to see the generated google analytics javascript in the logs:

    Log.get("afGoogleAnalytics").level = LogLevel.debug

