![](https://img.shields.io/badge/build-pass-brightgreen.svg?style=flat-square)
![](https://img.shields.io/badge/platform-tvOS9+-ff69b4.svg?style=flat-square)
![](https://img.shields.io/badge/Require-XCode7.1-lightgrey.svg?style=flat-square)


# tvOS 9 - New OS - Alamofire Example
tvOS 9~ Experiments - External Libraries - AppleTv.

## Example

![](https://raw.githubusercontent.com/Sweefties/tvOS9-AlamofireOnTvOS/master/source/tvOS9_Simulator2x_AlamofiretvOS_1.jpg)
![](https://raw.githubusercontent.com/Sweefties/tvOS9-AlamofireOnTvOS/master/source/tvOS9_Simulator2x_AlamofiretvOS_2.jpg)

## API Source Example
From : [iTunes Search API](https://www.apple.com/itunes/affiliates/resources/documentation/itunes-store-web-service-search-api.html)


## Requirements

- >= XCode 7.1 beta~.
- >= Swift 2.
- >= tvOS 9.0

Tested on tvOS 9.0 Simulator.

## Important

Get the `master` branch for XCode 8 / Swift 3 updated project.

## Alamofire - tvOS

- Get library from Alamofire tvOS Branch here [Alamofire-tvOS](https://github.com/Alamofire/Alamofire/tree/tvOS)
- Note : at the project writted (2015-10-06), Master branch doesn't work with tvOS.
- Installation used in this sample : Manually Install (installation with Cocoapods or Carthage untested here..)
- Check the documentation and use Alamofire!


## App Transport Security Settings

To support HTTP hosted : add the Boolean type Value to `YES` for `NSAllowsArbitraryLoads` in app's `info.plist` file.


## Code Example

Response Handling

```swift
Alamofire.request(.GET, "http://httpbin.org/get", parameters: ["foo": "bar"])
    .responseJSON { response in
        print(response.request)  // original URL request
        print(response.response) // URL response
        print(response.data)     // server data
        print(response.result)   // result of response serialization

        if let JSON = response.result.value {
            print("JSON: \(JSON)")
        }
    }
```



## Usage

To run the example project, download or clone the repo.

