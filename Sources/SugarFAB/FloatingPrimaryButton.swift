//
//  FloatingPrimaryButton.swift
//
//
//  Created by Tigran Gishyan on 24.04.23.
//

import UIKit

protocol FloatingPrimaryButtonDelegate: AnyObject {
    func touchUpInsideAction()
    func touchDownAction()
}

public struct FloatingPrimaryButtonData {
    let color: UIColor
    let image: UIImage
    var action: (() -> Void)?
    
    public init(color: UIColor, image: UIImage, action: (() -> Void)? = nil) {
        self.color = color
        self.image = image
        self.action = action
    }
}

class FloatingPrimaryButton: UIControl {
    weak var delegate: FloatingPrimaryButtonDelegate?
    var imageView: UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
    
    func set(data: FloatingPrimaryButtonData) {
        backgroundColor = data.color
        imageView.image = data.image
        
        addTarget(self, action: #selector(touchupInsideFunction), for: .touchUpInside)
        addTarget(self, action: #selector(touchdownAction), for: .touchDown)
    }
    
    @objc
    private func touchupInsideFunction() {
        delegate?.touchUpInsideAction()
    }
    
    @objc
    private func touchdownAction() {
        delegate?.touchDownAction()
    }
}

// MARK: - Layout
private extension FloatingPrimaryButton {
    func commonInit() {
        initImageView()
        constructHierarchy()
        activateConstraints()
    }
    
    func initImageView() {
        imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(systemName: "plus")?.withTintColor(.white).withRenderingMode(.alwaysOriginal)
    }
    
    func constructHierarchy() {
        addSubview(imageView)
    }
    
    func activateConstraints() {
        NSLayoutConstraint.activate([
            imageView.centerXAnchor.constraint(equalTo: centerXAnchor),
            imageView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
}

