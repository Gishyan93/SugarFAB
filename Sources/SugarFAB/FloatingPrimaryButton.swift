//
//  FloatingPrimaryButton.swift
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

protocol FloatingPrimaryButtonDelegate: AnyObject {
    func touchUpInsideAction()
}

public struct FloatingPrimaryButtonData {
    let color: UIColor
    let image: UIImage
    var touchDownAction: (() -> Void)?
    var touchUpInsideAction: (() -> Void)?
    
    public init(
        color: UIColor,
        image: UIImage,
        touchDownAction: (() -> Void)? = nil,
        touchUpInsideAction: (() -> Void)? = nil
    ) {
        self.color = color
        self.image = image
        self.touchDownAction = touchDownAction
        self.touchUpInsideAction = touchUpInsideAction
    }
}

class FloatingPrimaryButton: UIControl {
    weak var delegate: FloatingPrimaryButtonDelegate?
    var imageView: UIImageView!
    private(set) var data: FloatingPrimaryButtonData?
    
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
        
        addTarget(self, action: #selector(touchupInsideAction), for: .touchUpInside)
        addTarget(self, action: #selector(touchdownAction), for: .touchDown)
        self.data = data
    }
    
    @objc
    private func touchupInsideAction() {
        guard let data = data else { return }
        scaleUpAnimation()
        delegate?.touchUpInsideAction()
        data.touchUpInsideAction?()
    }
    
    @objc
    private func touchdownAction() {
        guard let data = data else { return }
        scaleDownAnimation()
        data.touchDownAction?()
    }
    
    private func scaleDownAnimation() {
        UIView.animate(withDuration: 0.2, animations: {
            self.transform = CGAffineTransform.identity.scaledBy(x: 0.9, y: 0.9)
        })
    }
    
    private func scaleUpAnimation() {
        UIView.animate(withDuration: 0.2, animations: {
            self.transform = CGAffineTransform.identity.scaledBy(x: 1.0, y: 1.0)
        })
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
