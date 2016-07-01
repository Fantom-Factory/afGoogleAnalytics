#Google Analytics v0.1.2
---
[![Written in: Fantom](http://img.shields.io/badge/written%20in-Fantom-lightgray.svg)](http://fantom.org/)
[![pod: v0.1.2](http://img.shields.io/badge/pod-v0.1.2-yellow.svg)](http://www.fantomfactory.org/pods/afGoogleAnalytics)
![Licence: MIT](http://img.shields.io/badge/licence-MIT-blue.svg)

## Overview

*Google Analytics is a support library that aids Alien-Factory in the development of other libraries, frameworks and applications. Though you are welcome to use it, you may find features are missing and the documentation incomplete.*

Google Analytics is a simple service that sends page views and events to Google's [Universal Analytics](https://support.google.com/analytics/answer/2790010) script.

It uses [Duvet](http://pods.fantomfactory.org/pods/afDuvet) to render Javascript in HTML pages.

## Install

Install `Google Analytics` with the Fantom Repository Manager ( [fanr](http://fantom.org/doc/docFanr/Tool.html#install) ):

    C:\> fanr install -r http://pods.fantomfactory.org/fanr/ afGoogleAnalytics

To use in a [Fantom](http://fantom.org/) project, add a dependency to `build.fan`:

    depends = ["sys 1.0", ..., "afGoogleAnalytics 0.1"]

## Documentation

Full API & fandocs are available on the [Fantom Pod Repository](http://pods.fantomfactory.org/pods/afGoogleAnalytics/).

## Quick Start

Set the Google Analytic account in your `AppModule`:

```
using afIoc
using afIocConig
using afGoogleAnalytics

const class AppModule {
  @Contribute { serviceType=ApplicationDefaults# }
  static Void contributeApplicationDefaults(Configuration config) {

    config[GoogleAnalyticsConfigIds.accountNumber] = "XX-99999999-9"
    config[GoogleAnalyticsConfigIds.accountDomain] = `http://example.org/`	// optional
  }
}
```

Or set the properies in `config.props` (See [IoC Config](http://pods.fantomfactory.org/pods/afIocConfig))

```
afGoogleAnalytics.accountNumber = XX-99999999-9
afGoogleAnalytics.accountDomain = http://example.org/	// optional
```

The domain is optional and will be taken from the Bedsheet host / request host parameter if not supplied.

Then render the required Javascript via the `GoogleAnalytics` service:

```
@Inject GoogleAnalytics googleAnalytics

...

googleAnalytics.sendPageView()
```

Note that Javascript is only rendered in `prod` mode. See [IoC Env](http://pods.fantomfactory.org/pods/afIocEnv) for details.

