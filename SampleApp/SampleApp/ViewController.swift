//
//  ViewController.swift
//  SampleApp
//
//  Created by Tigran Gishyan on 24.04.23.
//
//  MIT License
//
//  Copyright (c) 2022 Tigran Gishyan
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.

import UIKit
import SugarFAB

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        createFAB()
    }

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
            backgroundColor: .systemBlue,
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
        
        // Pulse animation for main button
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) {
            fabView.startPulsingAnimation()
        }
    }
}

