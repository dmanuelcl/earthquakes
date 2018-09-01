//
//  SheetView.swift
//
//
//  Created by Dani Manuel Céspedes Lara on 8/15/18.
//  Copyright © 2018 Dani Manuel Céspedes Lara. All rights reserved.
//

import UIKit
import UIKit.UIGestureRecognizerSubclass

extension UIView{
    func fill(in parentView: UIView){
        self.fill(verticalIn: parentView)
        self.fill(horizontalIn: parentView)
    }

    func fill(verticalIn parentView: UIView){
        self.translatesAutoresizingMaskIntoConstraints = false
        self.topAnchor.constraint(equalTo: parentView.topAnchor).isActive = true
        self.bottomAnchor.constraint(equalTo: parentView.bottomAnchor).isActive = true
    }

    func fill(horizontalIn parentView: UIView){
        self.translatesAutoresizingMaskIntoConstraints = false
        self.leadingAnchor.constraint(equalTo: parentView.leadingAnchor).isActive = true
        self.trailingAnchor.constraint(equalTo: parentView.trailingAnchor).isActive = true
    }

}

fileprivate enum State {
    case closed
    case open
}

extension State {
    var opposite: State {
        switch self {
        case .open: return .closed
        case .closed: return .open
        }
    }
}

protocol SheetViewDelegate: class {
    func sheetView(didOpen sheetView: SheetView)
    func sheetView(didClosed sheetView: SheetView)
}

class SheetView: UIView {

    // MARK: - Attrs
    var initialHeight: CGFloat = 60.0
    var sheetHeight: CGFloat = UIScreen.main.bounds.height * 0.5
    var indicatorColor: UIColor = UIColor.black
    var closeOnTap: Bool = true
    var closeOnTapOut: Bool = true
    var hideOnClosed: Bool = false
    var allowPanRecognizer: Bool = true

    var isOpen: Bool{
        return self.currentState == .open
    }


    weak var delegate: SheetViewDelegate?

    private weak var parentView: UIView!
    private weak var contentView: UIView!
    private var sheetOffset: CGFloat {
        return self.sheetHeight - self.initialHeight
    }


    // MARK: - Views
    private lazy var overlayView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.alpha = 0
        return view
    }()

    private lazy var sheetView: UIView = {
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.1
        self.layer.shadowRadius = 10
        self.clipsToBounds = true
        return self
    }()

    private lazy var containerView: UIView = {
        let view = UIView()
        return view
    }()

    private lazy var defaultIndicatorView: UIView = {
        let view = UIView(frame: CGRect.init(x: 0, y: 0, width: 50, height: 8))
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.1
        view.layer.shadowRadius = 2
        view.layer.cornerRadius = view.frame.height / 2
        view.backgroundColor = self.indicatorColor.withAlphaComponent(0.35)
        return view
    }()

    lazy var indicatorView: UIView = {
        return self.defaultIndicatorView
    }()

    // MARK: - Display
    func install(_ contentView: UIView, in parentView: UIView = UIApplication.shared.keyWindow!){
        self.contentView = contentView
        self.parentView = parentView
        self.layout()
        if self.allowPanRecognizer{
            self.sheetView.addGestureRecognizer(self.panRecognizer)
        }
        self.sheetView.addGestureRecognizer(self.tapRecognizer(selector: #selector(self.toggleCurrentState)))
        self.overlayView.addGestureRecognizer(self.tapRecognizer(selector: #selector(self.overlayViewTapped)))
    }

    func open(){
        self.animateTransitionIfNeeded(to: .open, duration: 0.5)
    }

    func close(){
        self.animateTransitionIfNeeded(to: .closed, duration: 0.5)
    }

    func remove(){
        self.sheetView.removeFromSuperview()
        self.overlayView.removeFromSuperview()
    }

    @objc private func overlayViewTapped(){
        guard self.closeOnTapOut else {return}
        self.close()
    }

    @objc private func toggleCurrentState(){
        guard (self.closeOnTap && self.currentState == .open) || self.currentState == .closed else {
            return
        }
        self.animateTransitionIfNeeded(to: self.currentState.opposite, duration: 0.5)
    }

    // MARK: - Layout

    private var bottomConstraint = NSLayoutConstraint()
    private let bottomConstraintOffset: CGFloat = 20

    private func cleanLayout(){
        self.overlayView.removeFromSuperview()
        self.sheetView.removeFromSuperview()
        self.indicatorView.removeFromSuperview()
        self.containerView.removeFromSuperview()
        self.contentView.removeFromSuperview()
    }

    private func layout() {
        self.cleanLayout()
        
        if self.backgroundColor == nil{
            self.backgroundColor = .white
        }
        
        if self.hideOnClosed{
            self.overlayView.alpha = 0
        }
        self.parentView.addSubview(self.overlayView)
        self.overlayView.fill(in: self.parentView)

        if self.hideOnClosed{
            self.sheetView.alpha = 0
        }
        self.parentView.addSubview(self.sheetView)
        self.sheetView.fill(horizontalIn: self.parentView)

        let sheetOffset = self.hideOnClosed ? self.sheetHeight : self.sheetOffset
        self.bottomConstraint = self.sheetView.bottomAnchor.constraint(equalTo: self.parentView.bottomAnchor, constant: sheetOffset)
        self.bottomConstraint.isActive = true
        self.sheetView.heightAnchor.constraint(equalToConstant: self.sheetHeight).isActive = true

        self.sheetView.addSubview(self.indicatorView)
        self.indicatorView.translatesAutoresizingMaskIntoConstraints = false
        self.indicatorView.centerXAnchor.constraint(equalTo: self.sheetView.centerXAnchor).isActive = true
        self.indicatorView.heightAnchor.constraint(equalToConstant: self.indicatorView.frame.height).isActive = true
        self.indicatorView.widthAnchor.constraint(equalToConstant: self.indicatorView.frame.width).isActive = true
        let indicatorTopConstant: CGFloat = self.indicatorView == self.defaultIndicatorView ? 10 : 0
        self.indicatorView.topAnchor.constraint(equalTo: self.sheetView.topAnchor, constant: indicatorTopConstant).isActive = true

        self.sheetView.addSubview(self.containerView)
        self.containerView.fill(horizontalIn: self.sheetView)
        self.containerView.bottomAnchor.constraint(equalTo: self.sheetView.bottomAnchor).isActive = true
        self.containerView.topAnchor.constraint(equalTo: self.indicatorView.bottomAnchor, constant: indicatorTopConstant).isActive = true

        self.containerView.addSubview(self.contentView)
        self.contentView.fill(horizontalIn: self.containerView)
        self.contentView.topAnchor.constraint(equalTo: self.containerView.topAnchor).isActive = true
        self.contentView.bottomAnchor.constraint(equalTo: self.containerView.bottomAnchor, constant: -self.bottomConstraintOffset).isActive = true

    }

    // MARK: - Animation

    /// The current state of the animation. This variable is changed only when an animation completes.
    private var currentState: State = .closed

    /// All of the currently running animators.
    private var runningAnimators = [UIViewPropertyAnimator]()

    /// The progress of each animator. This array is parallel to the `runningAnimators` array.
    private var animationProgress = [CGFloat]()

    private var panRecognizer: UIPanGestureRecognizer {
        let recognizer = UIPanGestureRecognizer()
        recognizer.addTarget(self, action: #selector(sheetViewPanned(recognizer:)))
        return recognizer
    }

    private func tapRecognizer(selector: Selector) -> UITapGestureRecognizer {
        let recognizer = UITapGestureRecognizer()
        recognizer.addTarget(self, action: selector)
        return recognizer
    }

    /// Animates the transition, if the animation is not already running.
    private func animateTransitionIfNeeded(to state: State, duration: TimeInterval) {
        self.sheetView.alpha = 1
        // ensure that the animators array is empty (which implies new animations need to be created)
        guard runningAnimators.isEmpty else { return }

        // an animator for the transition
        let transitionAnimator = UIViewPropertyAnimator(duration: duration, dampingRatio: 1, animations: {
            switch state {
            case .open:
                self.bottomConstraint.constant = self.bottomConstraintOffset
                self.sheetView.layer.cornerRadius = 20
                self.overlayView.alpha = 0.5
            case .closed:
                self.bottomConstraint.constant = self.hideOnClosed ? self.sheetHeight : self.sheetOffset
                self.sheetView.layer.cornerRadius = 0
                self.overlayView.alpha = 0
            }
            self.parentView.layoutIfNeeded()
        })

        // the transition completion block
        transitionAnimator.addCompletion { position in

            // update the state
            switch position {
            case .start:
                self.currentState = state.opposite
            case .end:
                self.currentState = state
            case .current:
                ()
            }

            // manually reset the constraint positions
            switch self.currentState {
            case .open:
                self.bottomConstraint.constant = self.bottomConstraintOffset
                self.delegate?.sheetView(didOpen: self)
            case .closed:
                self.bottomConstraint.constant =  self.hideOnClosed ? self.sheetHeight : self.sheetOffset
                self.delegate?.sheetView(didClosed: self)
            }

            // remove all running animators
            self.runningAnimators.removeAll()

        }

        // start all animators
        transitionAnimator.startAnimation()

        // keep track of all running animators
        runningAnimators.append(transitionAnimator)

    }

    @objc private func sheetViewPanned(recognizer: UIPanGestureRecognizer) {
        switch recognizer.state {
        case .began:

            // start the animations
            //if self.currentState == .closed{
            self.animateTransitionIfNeeded(to: self.currentState.opposite, duration: 0.5)
            //}

            // pause all animations, since the next event may be a pan changed
            self.runningAnimators.forEach { $0.pauseAnimation() }

            // keep track of each animator's progress
            self.animationProgress = self.runningAnimators.map { $0.fractionComplete }

        case .changed:

            // variable setup
            let translation = recognizer.translation(in: self.parentView)
            var fraction = -translation.y / self.sheetOffset

            // adjust the fraction for the current state and reversed state
            if self.currentState == .open { fraction *= -1 }
            if self.runningAnimators[0].isReversed { fraction *= -1 }

            // apply the new fraction
            for (index, animator) in runningAnimators.enumerated() {
                animator.fractionComplete = fraction + animationProgress[index]
            }

        case .ended:

            // variable setup
            let yVelocity = recognizer.velocity(in: self.sheetView).y
            let shouldClose = yVelocity > 0

            // if there is no motion, continue all animations and exit early
            if yVelocity == 0 {
                self.runningAnimators.forEach { $0.continueAnimation(withTimingParameters: nil, durationFactor: 0) }
                break
            }

            // reverse the animations based on their current state and pan motion
            switch self.currentState {
            case .open:
                if !shouldClose && !self.runningAnimators[0].isReversed { self.runningAnimators.forEach { $0.isReversed = !$0.isReversed } }
                if shouldClose && self.runningAnimators[0].isReversed { self.runningAnimators.forEach { $0.isReversed = !$0.isReversed } }
            case .closed:
                if shouldClose && !self.runningAnimators[0].isReversed { self.runningAnimators.forEach { $0.isReversed = !$0.isReversed } }
                if !shouldClose && self.runningAnimators[0].isReversed { self.runningAnimators.forEach { $0.isReversed = !$0.isReversed } }
            }
            // continue all animations
            self.runningAnimators.forEach { $0.continueAnimation(withTimingParameters: nil, durationFactor: 0) }

        default:
            ()
        }
    }
}
