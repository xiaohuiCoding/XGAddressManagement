# XGJSBridgeLibrary

[![CI Status](http://img.shields.io/travis/zj_lostself@163.com/XGJSBridgeLibrary.svg?style=flat)](https://travis-ci.org/zj_lostself@163.com/XGJSBridgeLibrary)
[![Version](https://img.shields.io/cocoapods/v/XGJSBridgeLibrary.svg?style=flat)](http://cocoapods.org/pods/XGJSBridgeLibrary)
[![License](https://img.shields.io/cocoapods/l/XGJSBridgeLibrary.svg?style=flat)](http://cocoapods.org/pods/XGJSBridgeLibrary)
[![Platform](https://img.shields.io/cocoapods/p/XGJSBridgeLibrary.svg?style=flat)](http://cocoapods.org/pods/XGJSBridgeLibrary)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Installation

XGJSBridgeLibrary is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "XGJSBridgeLibrary"
```

## Author

zj_lostself@163.com, zj_lostself@163.com

## License

XGJSBridgeLibrary is available under the MIT license. See the LICENSE file for more info.

## 版本相关  

XGJSBridgeLibrary的开发附属于兔巢业务开发，因为部分内容会耦合兔巢业务，现对版本号做如下说明：  

以如下版本号为例：  

>`版本格式：主版本号. 次版本号. 修订号`   

- 主版本号：主版本只在API做出调整时候更新，当更新此版本号时，使用者可能需要手动对老版本内容进行调整，如果更新代价太大可以使用 `~>X.0.0` 方式限制此版本号做出调整  

- 次版本号：此版本号在Bridge新增基础功能、对基础功能做出调整时更改，更新版本只做基础功能新增和调整，但不会改变原有API接口调用方式  

- 修订号：此版本号是为了服务兔巢业务，跟Bridge基础功能无关，使用者无需关心此版本更迭，此版本更新也不会影响基础业务使用  