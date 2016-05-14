## Exercise requirements

Pricing a basket
 
Write a mobile application and associated unit tests that can price a basket of goods in a number of different currencies.
The goods that can be purchased, which are all priced in USD, are:
 
*             Peas - 95c per bag
*             Eggs - 2.10 per dozen
*             Milk - 1.30 per bottle
*             Beans - 73c per can
 
The program should allow the user to add or remove items in a basket. The user can click on a checkout button which will then display the total price for the basket with the option to display the amount in different currencies. For example, if the basket contained Milk and the currency selected was EUR with an exchange rate of 1.5, the total would be $1.95 EUR.
 
No UI design constraints are enforced so feel free to design the UI in the way you see as most appropriate for the solution.
 
The list of currencies should be consumed from http://jsonrates.com/currencies.json. To convert to other currencies, you will need to create an account on http://jsonrates.com/.
 
This will then issue you with an API-Key that permits reading from the various public APIs listed on their site. The exchange rates may change at any time.
 
The code and design should meet these requirements but be sufficiently flexible to allow for future extensibility. The code should be well structured, suitably commented, have error handling and be tested.


## Exercise notes

## Main specs:

* Developed in SWIFT 2.2, requires XCode 7.3 to run it
* iOS 9.0 compatible
* CocoaPods
* using MVC (VIPER is a bit too much for this exercise)
* Network requests in the background
* Network requests recursively repeated if temporary error (increasing delay till 30 second)
* Network requests applied Apple recommendations (see "Network requests failures" below)
* Network Log network requests/responses to console with different logs levels
* Network using HTTPS (see below)
* Network requests cached
* Pull to refresh goods (cleans basket)
* Unit tests
* plist with UIRequiresPersistentWiFi (like Apple's mail app)
* AutoLayout
* Network waiting indicators in status bar
* Push Notification for implementing slow internet connectivity messaging in the UI
* HeaderDoc HTML based documentation. Generated using jazzy. in docs/swift_output/index.html
* using SwiftLint to enforce Swift coding style and conventions
* Maximized Xcode Warnings (XcodeWarnings.xcconfig) (http://qualitycoding.org/xcode-warnings)
* Using as few external libraries as possible:

* Alamofire

## Requirements to run

* iOS9
* XCode 7.3
* Swiflint

## SwiftLint

Is a tool to enforce Swift style coding and conventions
https://github.com/realm/SwiftLint

Install: brew install swiftlint

It is implemented as a run script, if you don't want to install it, comment or remove the run script in the target.

## PR2Studio classes

I applied some of my own classes I use to develop in Swift. They are implemented as a pod (PR2StudioSwift). There is no need to run a pod install cause pods are deployed in this git repository.

If you do a pod install, you would need to add this as first line

#include "XcodeWarnings.xcconfig"

In the Pods-BasketPablo.debug.xcconfig file

## Storyboards

For this sample I will use Storyboards, but I much prefer to use NIBs than storyboards, storyboards are really a problem in team 
development (because git conflicts) and with NIBs you have more flexibility to enable different behaviors.

## Problems with End Points

http://jsonrates.com has changed and http://jsonrates.com/currencies.json is not longer available. I must request to the substitute for it, who is at https://currencylayer.com

In the free tier at currencylayer.com, you can not change source currency, it is USD by default. So I will asume that goods are in USD.

## SOLID principles

Trying to apply SOLID principles and Clean Code, specially the Single Responsability. Classes must be lightewigth and perform only one task inside his abstraction layer. So it's better to have more classes that one big bloated class

## CACHE

Goods are cached by one day, there is a pull to refresh for retrieving goods again (empties basket)
Currencies are cached by one day
Exchanges are cached by 60 mins (as they do in the free tier)

## Network logger

Logs into the console the network requests and responses. It's instantiated in AppDelegate.swift, here:

    PR2Networking.sharedInstance.logLevel = PR2NetworkingLogLevel.PR2NetworkingLogLevelInfo

logLevel can be:

* PR2NetworkingLogLevelOff - log disabled
* PR2NetworkingLogLevelDebug - logs full requests and responses
* PR2NetworkingLogLevelInfo - log with short info
* PR2NetworkingLogLevelError - logs only when errors

## jazzy (Doc generation)
https://github.com/realm/jazzy

    jazzy \
      --clean \
      --author PabloRoca \
      --author_url https://pr2studio.com \
      --github_url https://github.com/pabloroca/BasketPablo \
      --module-version 1.00 \
      --xcodebuild-arguments -scheme,BasketPabloDoc \
      --module BasketPablo \
      --root-url https://github.com/pabloroca/BasketPablo/docs/swift_output/index.html \
      --output docs/swift_output \
      --min-acl internal 


## Database

I have created this CoreData entities (sqlite tables):

* CDEBasket. Goods added to the basket
* CDECurrency. List of currencies
* CDEExchange. Exchange rates
* CDEGoods. List of goods
* CDESettings. Settings and time stamp for cache

I use relationships between entities (one to one and one to many), with delete cascade rules

## Network using HTTPS

Main reasons for using HTTPS is for now, a bit (just a bit more security in network comms) and better speed. See article by Scott Helme why to use HTTPS (https://scotthelme.co.uk/still-think-you-dont-need-https/)

The server is not properly configured for HTTPS (Qualys SSL Test grade B, key exchange using weak Diffie-Hellman (DH), no CSP, no Strict Transport Security (HSTS), Public Key Pins not configured and other security flaws).

If HPKP were configured, I would use SSL Public Key Pinning inestead certificate pinning. I would be using TrustKit (https://github.com/datatheorem/TrustKit) for it. With TrustKit it's easy to enable and avoid a man in the middle attack.

## Network requests failures

This is not a trivial issue, some debate ongoing and as per this docs

Networking Overview
https://developer.apple.com/library/ios/documentation/NetworkingInternetWeb/Conceptual/NetworkingOverview/WhyNetworkingIsHard/WhyNetworkingIsHard.html#//apple_ref/doc/uid/TP40010220-CH13-SW8

WWDC 2012 Session 706, "Networking Best Practices"
https://developer.apple.com/videos/play/wwdc2012-706/

Almofire documentation
https://github.com/Alamofire/Alamofire

So we conclude with this (and it is applied in the exercise):

* Don't use Rechability to determine if a network request should be sent. You should always send the request.
* Analize Reachability if failures. When Reachability is restored, use the event to retry failed network requests. (Even though the network requests may still fail, this is a good moment to retry them.)
* Don't timeout, let the system to do it. There is no good timeout value

## TODO

* complete HeaderDoc documentation.

## To enhance

* more use of protocols
* Better CoreData stack

