#Google Analytics v0.0.6
---
[![Written in: Fantom](http://img.shields.io/badge/written%20in-Fantom-lightgray.svg)](http://fantom.org/)
[![pod: v0.0.6](http://img.shields.io/badge/pod-v0.0.6-yellow.svg)](http://www.fantomfactory.org/pods/afGoogleAnalytics)
![Licence: MIT](http://img.shields.io/badge/licence-MIT-blue.svg)

## Overview

Google Analytics is a simple [efan component](http://pods.fantomfactory.org/pods/afEfanXtra) for rendering Google's [Universal Analytics](https://support.google.com/analytics/answer/2790010) script.

## Install

Install `Google Analytics` with the Fantom Repository Manager ( [fanr](http://fantom.org/doc/docFanr/Tool.html#install) ):

    C:\> fanr install -r http://repo.status302.com/fanr/ afGoogleAnalytics

To use in a [Fantom](http://fantom.org/) project, add a dependency to `build.fan`:

    depends = ["sys 1.0", ..., "afGoogleAnalytics 0.0"]

## Documentation

Full API & fandocs are available on the [Fantom Pod Repository](http://pods.fantomfactory.org/pods/afGoogleAnalytics/).

## Quick Start

Set the Google Analytic account in your `AppModule`:

```
using afIoc
using afIocConig
using afGoogleAnalytics

class AppModule {
  @Contribute { serviceType=ApplicationDefaults# }
  static Void contributeApplicationDefaults(Configuration config) {

    config[GoogleAnalyticsConfigIds.accountNumber]    = "XX-99999999-9"
    config[GoogleAnalyticsConfigIds.accountDomain]    = `wotever.com`
  }
}
```

Then render it in your [efan component](http://pods.fantomfactory.org/pods/afEfanXtra), you should place it just before the closing `<body>` tag:

```
<html>
  <body>
    ...

    <% afGa.renderGoogleAnalytics() %>
  </body>
</html>
```

Or if using [Slim](http://pods.fantomfactory.org/pods/afSlim):

```
html
  body
    ...

    -- afGa.renderGoogleAnalytics()
```

