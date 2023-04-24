SugarFAB
=============

SugarFAB is a Swift library that creates Floating Action Buttons. It is highly customizable, lightweight, and easy to use.
SugarToast is available through [Swift Package Manager](https://www.swift.org/package-manager/)

Screenshots
---------

![alt tag](https://github.com/Gishyan93/SugarFAB/blob/main/Assets/screen.gif)

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
    func createFAB() {
        // Creating Floating View
        let fabView = FloatingView()
        fabView.translatesAutoresizingMaskIntoConstraints = false
        
        // Adding to subview of current view
        view.addSubview(fabView)
        
        // Creating constraints
        NSLayoutConstraint.activate([
            fabView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            fabView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            fabView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            fabView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        // Adding primary button
        let primaryButton = FloatingPrimaryButtonData(
            color: .systemRed,
            image: UIImage(systemName: "plus")!
                .withTintColor(.white, renderingMode: .alwaysOriginal)
        ) { [weak self] in
            print("Primary action pressed")
        }
        
        // Adding secondary buttons
        let secondaryButton = FloatingSecondaryData(
            image: UIImage(systemName: "minus")!
                .withTintColor(.white, renderingMode: .alwaysOriginal),
            tooltip: FloatingSecondaryData.Tooltip(
                text: "Cart",
                textColor: .black,
                backgroundColor: .systemBlue,
                font: .systemFont(ofSize: 16)
            )
        ) { [weak self] in
            print("Secondary action pressed")
        }
        
        fabView.set(
            data: FloatingViewData(
                primaryButton: primaryButton,
                secondaryButtons: [secondaryButton]
            )
        )
    }
```
### Starting pulse animation for main button
```swift
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) {
        fabView.startPulsingAnimation()
    }
```

# License
SugarFAB is available under the MIT license. See the LICENSE file for more information.
