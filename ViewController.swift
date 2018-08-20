//
//  ViewController.swift
//  FacebookAnimation
//
//  Created by OlehMalichenko on 28.07.2018.
//  Copyright © 2018 OlehMalichenko. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    let bgImageView: UIImageView = {
       let imageView = UIImageView(image: #imageLiteral(resourceName: "fb_core_data_bg"))
        return imageView
    }()
    
    let iconConteinerView: UIView = {
        let containerView = UIView()
        containerView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        
        // sizes for stack
        let iconHeight: CGFloat = 38
        let pendings: CGFloat = 6
        
        let images = [#imageLiteral(resourceName: "blue_like"), #imageLiteral(resourceName: "red_heart"), #imageLiteral(resourceName: "surprised"), #imageLiteral(resourceName: "cry_laugh"), #imageLiteral(resourceName: "cry"), #imageLiteral(resourceName: "angry")]
       
        let arrangedSubviews =
            images.map({ (image) -> UIView in
                let imageView = UIImageView(image: image)
                imageView.layer.cornerRadius = iconHeight / 2
                imageView.isUserInteractionEnabled = true
                return imageView
            })
        
        let numbersIcons = CGFloat(arrangedSubviews.count)
        let widthConteinerView = (numbersIcons * iconHeight) + ((numbersIcons + 1) * pendings)
        
        let stackView = UIStackView(arrangedSubviews: arrangedSubviews)
        stackView.distribution = .fillEqually
        stackView.spacing = pendings
        stackView.layoutMargins = UIEdgeInsets(top: pendings, left: pendings, bottom: pendings, right: pendings)
        stackView.isLayoutMarginsRelativeArrangement = true
        
        containerView.addSubview(stackView)
        
        containerView.frame = CGRect(x: 0, y: 0, width: widthConteinerView, height: iconHeight + (2 * pendings))
        containerView.layer.cornerRadius = containerView.frame.height / 2
        stackView.frame = containerView.frame
        
        // shadow
        containerView.layer.shadowColor = UIColor(white: 0.4, alpha: 0.4).cgColor
        containerView.layer.shadowRadius = 8
        containerView.layer.shadowOpacity = 0.5
        containerView.layer.shadowOffset = CGSize(width: 0, height: 4)
        
        return containerView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(bgImageView)
        bgImageView.frame = view.frame
        
        setupLongPressGesture()
    }
    
    fileprivate func setupLongPressGesture() {
        view.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(handlLongPress)))
    }
    
    @objc func handlLongPress(gesture: UILongPressGestureRecognizer) {
        if gesture.state == .began {
           handleBigen(gesture: gesture)
        } else if gesture.state == .ended {
            
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 11, options: .curveEaseOut, animations: {
                let stackView = self.iconConteinerView.subviews.first
                stackView?.subviews.forEach({ (imageView) in
                    imageView.transform = .identity
                })
                self.iconConteinerView.transform = self.iconConteinerView.transform.translatedBy(x: 0, y: 50)
                self.iconConteinerView.alpha = 0
            }) { (_) in
                self.iconConteinerView.removeFromSuperview()
            }
            
        } else if gesture.state == .changed {
            handleGestureChange(gesture: gesture)
        }
    }
    
    fileprivate func handleGestureChange(gesture: UILongPressGestureRecognizer) {
        let pressedLocation = gesture.location(in: self.iconConteinerView)
        print(pressedLocation)
        
        let fixedYLocation = CGPoint(x: pressedLocation.x, y: self.iconConteinerView.frame.height / 2)
        
        let hitTestView = iconConteinerView.hitTest(fixedYLocation, with: nil)
        
        if hitTestView is UIImageView {
            UIView.animate(
                withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut,
                animations: {
                    let stackView = self.iconConteinerView.subviews.first
                    stackView?.subviews.forEach({ (imageView) in
                        imageView.transform = .identity
                    })
                    hitTestView?.transform = CGAffineTransform(translationX: 0, y: -50)
            })
        }
    }
    
    fileprivate func handleBigen(gesture: UILongPressGestureRecognizer) {
        view.addSubview(iconConteinerView)
        // get location
        let pressedLocation = gesture.location(in: self.view)
        print(pressedLocation)
        // get centerX for iconConteiner
        let centerX = (view.frame.width - iconConteinerView.frame.width) / 2
        // alfa animated
        iconConteinerView.alpha = 0
        iconConteinerView.transform = CGAffineTransform(translationX: centerX, y: pressedLocation.y)
        UIView.animate(withDuration: 0.5,
                       delay: 0,
                       usingSpringWithDamping: 1,
                       initialSpringVelocity: 1,
                       options: .curveEaseOut,
                       animations: {
                        self.iconConteinerView.alpha = 1
                        // transform icon to location
                        self.iconConteinerView.transform = CGAffineTransform(translationX: centerX, y: pressedLocation.y - self.iconConteinerView.frame.height)})
    }
    
    override var prefersStatusBarHidden: Bool {return true}
}

