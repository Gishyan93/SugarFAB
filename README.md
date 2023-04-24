SugarFAB
=============

SugarFAB is a Swift library that creates Floating Action Buttons. It is highly customizable, lightweight, and easy to use.
SugarToast is available through [Swift Package Manager](https://www.swift.org/package-manager/)

Screenshots
---------

Features
---------

**Core features:**
 - Creating main Floating Action Button with optional callback listener
 - Creating secondary buttons with optional callback listeners and optional tooltip

**Availability:**
 - Swift 5.4 (main branch)
 - iOS >= 13.0

## Usage

In order to correctly compile:

### Initializing somewhere in your ViewController
```swift
    func createSimpleToast() {
        let data = ToastViewData(image: UIImage(named: "info")!,
                                 title: "Sugar Title",
                                 subtitle: "Sugar Subtitle")
                    
        let presenter = ToastView.presenter(forAlertWithData: data)
        present(presenter, animated: true)
    }
```

# License
SugarToast is available under the MIT license. See the LICENSE file for more information.
