//
//  FloatingSecondaryButton.swift
//
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

public struct FloatingSecondaryData {
    public struct Tooltip {
        let text: String
        let textColor: UIColor
        let backgroundColor: UIColor
        let font: UIFont
        
        public init(text: String, textColor: UIColor, backgroundColor: UIColor, font: UIFont) {
            self.text = text
            self.textColor = textColor
            self.backgroundColor = backgroundColor
            self.font = font
        }
    }
    
    let image: UIImage
    let backgroundColor: UIColor
    let tooltip: Tooltip?
    var action: (() -> Void)?
    
    public init(
        image: UIImage,
        backgroundColor: UIColor,
        tooltip: Tooltip? = nil,
        action: (() -> Void)? = nil
    ) {
        self.backgroundColor = backgroundColor
        self.tooltip = tooltip
        self.image = image
        self.action = action
    }
}

class FloatingSecondaryButton: UIView {
    var stackView: UIStackView!
    var button: UIControl!
    var labelView: UIView!
    var labelWrapperView: UIView!
    private(set) var data: FloatingSecondaryData?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    func set(data: FloatingSecondaryData) {
        createView(from: data)
    }
    
    private func createView(from data: FloatingSecondaryData) {
        if let tooltip = data.tooltip {
            // Creating Label's wrapper view
            labelWrapperView = UIView()
            labelWrapperView.backgroundColor = .clear
            labelWrapperView.translatesAutoresizingMaskIntoConstraints = false
            labelWrapperView.isHidden = true
            
            // Creating Label's view
            labelView = UIView()
            labelView.layer.cornerRadius = 12
            labelView.backgroundColor = tooltip.backgroundColor
            labelView.translatesAutoresizingMaskIntoConstraints = false
            
            // Creating Label
            let label = UILabel()
            label.text = tooltip.text
            label.font = tooltip.font
            label.translatesAutoresizingMaskIntoConstraints = false
            
            // Adding to hierarchy
            labelWrapperView.addSubview(labelView)
            labelView.addSubview(label)
            
            // Activating constraints
            NSLayoutConstraint.activate([
                labelView.topAnchor.constraint(equalTo: labelWrapperView.topAnchor, constant: 5),
                labelView.bottomAnchor.constraint(equalTo: labelWrapperView.bottomAnchor, constant: -5),
                labelView.leadingAnchor.constraint(equalTo: labelWrapperView.leadingAnchor),
                labelView.trailingAnchor.constraint(equalTo: labelWrapperView.trailingAnchor),
                
                label.topAnchor.constraint(equalTo: labelView.topAnchor),
                label.leadingAnchor.constraint(equalTo: labelView.leadingAnchor, constant: 16),
                label.bottomAnchor.constraint(equalTo: labelView.bottomAnchor),
                label.trailingAnchor.constraint(equalTo: labelView.trailingAnchor, constant: -16)
            ])
        }
        
        // Creating secondary buttons
        button = UIControl()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = data.backgroundColor
        button.layer.cornerRadius = 25
        
        // Creating image view
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = data.image
                
        stackView.addArrangedSubview(labelWrapperView)
        stackView.addArrangedSubview(button)
        button.addSubview(imageView)
        
        // Activating constraints
        NSLayoutConstraint.activate([
            button.heightAnchor.constraint(equalToConstant: 50),
            button.widthAnchor.constraint(equalToConstant: 50),
            
            imageView.centerXAnchor.constraint(equalTo: button.centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: button.centerYAnchor)
        ])
        
        button.addTarget(self, action: #selector(touchUpinsideAction), for: .touchUpInside)
        button.addTarget(self, action: #selector(touchDownAction), for: .touchDown)

        let tapGesture = UILongPressGestureRecognizer(target: self, action: #selector(longTapped))
        button.addGestureRecognizer(tapGesture)
        self.data = data
    }
    
    @objc
    private func touchUpinsideAction() {
        guard let data = data else { return }

        UIView.animate(withDuration: 0.2, animations: {
            self.button.transform = CGAffineTransform.identity.scaledBy(x: 1.0, y: 1.0)
        })
        data.action?()
    }
    
    @objc
    private func touchDownAction() {
        UIView.animate(withDuration: 0.2, animations: {
            self.button.transform = CGAffineTransform.identity.scaledBy(x: 0.9, y: 0.9)
        })
    }
    
    @objc
    private func longTapped(_ gestureRecognizer: UILongPressGestureRecognizer) {
        
        if labelWrapperView.isHidden {
            UIView.performWithoutAnimation {
                self.labelWrapperView.isHidden = false
                self.labelWrapperView.alpha = 0.0
            }
                        
            UIView.animate(withDuration: 0.3) {
                self.labelWrapperView.alpha = 1.0
            }
        }

        if gestureRecognizer.state == .ended {
            UIView.animate(withDuration: 0.3) {
                self.labelWrapperView.alpha = 0.0
            }
            
            UIView.animate(withDuration: 0.2, animations: {
                self.button.transform = CGAffineTransform.identity.scaledBy(x: 1.0, y: 1.0)
            })
            
            UIView.performWithoutAnimation {
                self.labelWrapperView.isHidden = true
            }
        }
        
    }
}

// MARK: - Layout
private extension FloatingSecondaryButton {
    func commonInit() {
        initStackView()
        constructHierarchy()
        activateConstraints()
    }
    
    func initStackView() {
        stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func constructHierarchy() {
        addSubview(stackView)
    }
    
    func activateConstraints() {
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
}
