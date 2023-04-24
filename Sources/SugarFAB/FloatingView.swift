//
//  FloatingView.swift
//
//
//  Created by Tigran Gishyan on 24.04.23.
//

import UIKit

public struct FloatingViewData {
    let primaryButton: FloatingPrimaryButtonData
    let secondaryButtons: [FloatingSecondaryData]
    
    public init(
        primaryButton: FloatingPrimaryButtonData,
        secondaryButtons: [FloatingSecondaryData]
    ) {
        self.primaryButton = primaryButton
        self.secondaryButtons = secondaryButtons
    }
}

public class FloatingView: UIView {
    var isExpanded: Bool = false
    
    var animation: CABasicAnimation!
    var pulsatingLayer: CAShapeLayer!
    
    var overlayView: UIView!
    var secondaryToShowViews: [UIView] = []
    var secondaryToHideViews: [UIView] = []
    var mainStackView: UIStackView!
    var floatingPrimaryButton: FloatingPrimaryButton!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
        addTapGesture()
        conformToDelegates()
        createPulseAnimation()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
        addTapGesture()
        conformToDelegates()
        createPulseAnimation()
    }
    
    public func set(data: FloatingViewData) {
        floatingPrimaryButton.set(data: data.primaryButton)
        set(buttons: data.secondaryButtons)
    }
    
    public func startPulsingAnimation() {
        stopPulsingAnimation()
        createPulsatingLayer()
        createPulseAnimation()
        pulsatingLayer.add(animation, forKey: "pulsating")
    }

    public func stopPulsingAnimation() {
        guard pulsatingLayer != nil else { return }
        pulsatingLayer.removeAllAnimations()
        pulsatingLayer.removeFromSuperlayer()
    }
    
    private func addTapGesture() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTapRecognizer))
        tap.delegate = self
        addGestureRecognizer(tap)
    }
    
    @objc private func handleTapRecognizer() {
        primaryButtonRotationAnimation()
    }
    
    private func conformToDelegates() {
        floatingPrimaryButton.delegate = self
    }
    
    private func set(buttons: [FloatingSecondaryData]) {
        buttons.forEach { data in
            let view = FloatingSecondaryButton()
            view.set(data: data)
            mainStackView.insertArrangedSubview(view, at: 0)
            view.isHidden = true
            secondaryToShowViews.insert(view, at: 0)
        }
    }
    
    private func createPulseAnimation() {
        animation = CABasicAnimation(keyPath: "transform.scale")
        animation.toValue = 1.3
        animation.duration = 0.8
        animation.timingFunction = CAMediaTimingFunction(name: .easeOut)
        animation.autoreverses = true
        animation.repeatCount = Float.infinity
    }
    
    private func primaryButtonScaleDownAnimation() {
        UIView.animate(withDuration: 0.2, animations: {
            self.floatingPrimaryButton.transform = CGAffineTransform.identity.scaledBy(x: 0.9, y: 0.9)
        })
    }
    
    private func primaryButtonScaleUpAnimation() {
        UIView.animate(withDuration: 0.2, animations: {
            self.floatingPrimaryButton.transform = CGAffineTransform.identity.scaledBy(x: 1.0, y: 1.0)
        })
    }
    
    private func primaryButtonRotationAnimation() {
        isExpanded.toggle()
        if isExpanded {
            UIView.performWithoutAnimation {
                addOverlay()
            }
            UIView.animate(withDuration: 0.2) {
                self.overlayView.alpha = 1
                self.floatingPrimaryButton.imageView.transform = CGAffineTransform(rotationAngle: .pi/4)
            } completion: { _ in
                self.showSecondaryButtons()
            }
        } else {
            UIView.animate(
                withDuration: 0.2
            ) {
                self.overlayView.alpha = 0
                self.floatingPrimaryButton.imageView.transform = CGAffineTransform(rotationAngle: 0)
            } completion: { _ in
                self.overlayView.removeFromSuperview()
                self.dismissSecondaryButtons()
            }
        }
    }
    
    private func showSecondaryButtons() {
        guard let view = secondaryToShowViews.last else {
            return
        }
        
        secondaryToHideViews.append(view)
        secondaryToShowViews.removeLast()
            
        UIView.performWithoutAnimation {
            view.isHidden = false
            view.transform = CGAffineTransform.identity.scaledBy(x: 0.001, y: 0.001)
        }
        
        UIView.animate(withDuration: 0.2, animations: {
            view.transform = CGAffineTransform.identity.scaledBy(x: 1.0, y: 1.0)
        }) { finished in
            self.showSecondaryButtons()
        }
    }
    
    private func dismissSecondaryButtons() {
        guard let view = secondaryToHideViews.last else {
            return
        }
        
        secondaryToShowViews.append(view)
        secondaryToHideViews.removeLast()
        
        UIView.animate(withDuration: 0.075, animations: {
            view.transform = CGAffineTransform.identity.scaledBy(x: 0.001, y: 0.001)
        }) { finished in
            view.isHidden = true
            self.dismissSecondaryButtons()
        }
    }
    
    public override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        if mainStackView.frame.contains(point) {
            return true
        } else if overlayView.isDescendant(of: self) {
            return true
        } else {
            return false
        }
//        return mainStackView.frame.contains(point) || overlayView.frame.contains(point)
    }
}

// MARK: - UIGestureRecognizerDelegate & FloatingPrimaryButtonDelegate
extension FloatingView: UIGestureRecognizerDelegate, FloatingPrimaryButtonDelegate {
    public func gestureRecognizer(
        _ gestureRecognizer: UIGestureRecognizer,
        shouldReceive touch: UITouch
    ) -> Bool {
        if touch.view == overlayView { return true }
        return false
    }
    
    func touchDownAction() {
        primaryButtonScaleDownAnimation()
    }
    
    func touchUpInsideAction() {
        primaryButtonScaleUpAnimation()
        primaryButtonRotationAnimation()
    }
    
    func createPulsatingLayer() {
        let path = UIBezierPath(
            arcCenter: .zero,
            radius: 25, startAngle: 0,
            endAngle: .pi*2,
            clockwise: true
        )

        pulsatingLayer = CAShapeLayer()
        pulsatingLayer.path = path.cgPath
        pulsatingLayer.fillColor = UIColor.systemRed.cgColor
        pulsatingLayer.lineWidth = 10
        pulsatingLayer.strokeEnd = 0
        
        layer.insertSublayer(pulsatingLayer, at: 1)
        
        let buttonHeight = mainStackView.arrangedSubviews.first!.frame.height
        let secondaryButtonsCount = CGFloat(mainStackView.arrangedSubviews.count - 1)
        
        let allHeigh = CGFloat((secondaryButtonsCount * buttonHeight) + (secondaryButtonsCount * 10.0))
        
        let xPoint = mainStackView.frame.origin.x + buttonHeight/2
        let yPoint = mainStackView.frame.origin.y + allHeigh + buttonHeight/2
        let position = CGPoint(x: xPoint, y: yPoint)
        pulsatingLayer.position = position
    }
    
    func addOverlay() {
        insertSubview(overlayView, at: 0)

        NSLayoutConstraint.activate([
            overlayView.topAnchor.constraint(equalTo: topAnchor),
            overlayView.bottomAnchor.constraint(equalTo: bottomAnchor),
            overlayView.leadingAnchor.constraint(equalTo: leadingAnchor),
            overlayView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
}

// MARK: - Layout
private extension FloatingView {
    func commonInit() {
        initStackView()
        initOverlayView()
        initFloatingPrimaryButton()
        constructHierarchy()
        activateConstraints()
    }
    
    func initStackView() {
        mainStackView = UIStackView()
        mainStackView.translatesAutoresizingMaskIntoConstraints = false
        mainStackView.axis = .vertical
        mainStackView.spacing = 10
        mainStackView.distribution = .fill
        mainStackView.alignment = .trailing
        mainStackView.clipsToBounds = true
    }
    
    func initOverlayView() {
        overlayView = UIView()
        overlayView.translatesAutoresizingMaskIntoConstraints = false
        overlayView.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        overlayView.alpha = 0.0
    }
    
    func initFloatingPrimaryButton() {
        floatingPrimaryButton = FloatingPrimaryButton()
        floatingPrimaryButton.backgroundColor = .systemRed
        floatingPrimaryButton.translatesAutoresizingMaskIntoConstraints = false
        floatingPrimaryButton.layer.cornerRadius = 25
    }
    
    func constructHierarchy() {
        addSubview(overlayView)
        addSubview(mainStackView)
        
        mainStackView.addArrangedSubview(floatingPrimaryButton)
    }
    
    func activateConstraints() {
        NSLayoutConstraint.activate([
            
            mainStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20),
            mainStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),

            floatingPrimaryButton.heightAnchor.constraint(equalToConstant: 50),
            floatingPrimaryButton.widthAnchor.constraint(equalToConstant: 50),
        ])
        
        layoutIfNeeded()
        setNeedsLayout()
    }
}
