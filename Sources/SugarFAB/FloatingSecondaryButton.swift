//
//  FloatingSecondaryButton.swift
//
//
//  Created by Tigran Gishyan on 24.04.23.
//

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
    let tooltip: Tooltip?
    var action: (() -> Void)?
    
    public init(
        image: UIImage,
        tooltip: Tooltip? = nil,
        action: (() -> Void)? = nil
    ) {
        self.tooltip = tooltip
        self.image = image
        self.action = action
    }
}

class FloatingSecondaryButton: UIView {
    var stackView: UIStackView!
    var button: UIControl!
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
            labelWrapperView.layer.cornerRadius = 12
            labelWrapperView.backgroundColor = tooltip.backgroundColor
            labelWrapperView.translatesAutoresizingMaskIntoConstraints = false
            labelWrapperView.isHidden = true
            
            // Creating Label
            let label = UILabel()
            label.text = tooltip.text
            label.font = tooltip.font
            label.translatesAutoresizingMaskIntoConstraints = false
            
            // Adding to hierarchy
            labelWrapperView.addSubview(label)
            
            // Activating constraints
            NSLayoutConstraint.activate([
                label.topAnchor.constraint(equalTo: labelWrapperView.topAnchor),
                label.leadingAnchor.constraint(equalTo: labelWrapperView.leadingAnchor, constant: 16),
                label.bottomAnchor.constraint(equalTo: labelWrapperView.bottomAnchor),
                label.trailingAnchor.constraint(equalTo: labelWrapperView.trailingAnchor, constant: -16),
            ])
        }
        
        // Creating secondary buttons
        button = UIControl()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .systemRed
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
            
            imageView.topAnchor.constraint(equalTo: button.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: button.bottomAnchor),
            imageView.leadingAnchor.constraint(equalTo: button.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: button.leadingAnchor)
        ])
        
        button.addTarget(self, action: #selector(touchUpinsideAction), for: .touchUpInside)
        button.addTarget(self, action: #selector(touchDownAction), for: .touchDown)

        let tapGesture = UILongPressGestureRecognizer(target: self, action: #selector(longTapped))
        button.addGestureRecognizer(tapGesture)
        
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
