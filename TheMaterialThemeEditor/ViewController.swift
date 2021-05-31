//
//  ViewController.swift
//  TheMaterialThemeEditor
//
//  Created by 大西玲音 on 2021/05/31.
//

import UIKit

protocol CustomViewDelegate: AnyObject {
    func didTapped(color: UIColor, alpha: CGFloat, selectedView: UIView)
}

final class CustomView: UIView {
    
    weak var delegate: CustomViewDelegate?
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        delegate?.didTapped(color: self.backgroundColor!, alpha: self.alpha, selectedView: self)
    }
    
}

protocol CustomBigViewDelegate: AnyObject {
    func didTapped(newSelectedView: UIView)
}

final class CustomBigView: UIView {
    
    weak var delegate: CustomBigViewDelegate?
    var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "checkmark")
        imageView.tintColor = .white
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        delegate?.didTapped(newSelectedView: self)
    }
    
}

final class ViewController: UIViewController {
    
    @IBOutlet private weak var view1: CustomBigView!
    @IBOutlet private weak var view2: CustomBigView!
    @IBOutlet private weak var view3: CustomBigView!
    @IBOutlet private weak var redStackView: UIStackView!
    @IBOutlet private var redViews: [CustomView]!
    @IBOutlet private var orangeViews: [CustomView]!
    @IBOutlet private var purpleViews: [CustomView]!
    @IBOutlet private var greenViews: [CustomView]!
    
    private var selectedView: UIView?
    private var oldSelectedBigView: UIView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        orangeViews.forEach { $0.delegate = self }
        purpleViews.forEach { $0.delegate = self }
        greenViews.forEach { $0.delegate = self }
        
        view1.delegate = self
        view2.delegate = self
        view3.delegate = self
        
        redStackView.arrangedSubviews.forEach { view in
            let customView = view as? CustomView
            customView?.delegate = self
        }
        
        addImageView(view: view1)
        addImageView(view: view2)
        addImageView(view: view3)
        view1.imageView.isHidden = false
        oldSelectedBigView = view1
        
    }
    
    private func addImageView(view: CustomBigView) {
        view.addSubview(view.imageView)
        [view.imageView.heightAnchor.constraint(equalToConstant: 50),
         view.imageView.widthAnchor.constraint(equalToConstant: 50),
         view.imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
         view.imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ].forEach { $0.isActive = true }
        view.imageView.isHidden = true
    }
    
}

extension ViewController: CustomViewDelegate {
    
    func didTapped(color: UIColor, alpha: CGFloat, selectedView: UIView) {
        UIView.animate(withDuration: 0, animations: {
            selectedView.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
        }, completion: { _ in
            UIView.animate(withDuration: 0.1) {
                selectedView.transform = .identity
                selectedView.layer.cornerRadius = selectedView.frame.size.width / 2
            }
        })
        oldSelectedBigView?.backgroundColor = color
        oldSelectedBigView?.alpha = alpha
        UIView.animate(withDuration: 0.1) {
            if self.selectedView != selectedView {
                self.selectedView?.layer.cornerRadius = 0
            }
        }
        self.selectedView = selectedView
    }
    
}

extension ViewController: CustomBigViewDelegate {
    
    func didTapped(newSelectedView: UIView) {
        let isSameViewDidTapped = (oldSelectedBigView == newSelectedView)
        let _newSelectedView = (newSelectedView as! CustomBigView)
        let _oldSelectedBigView = (oldSelectedBigView as! CustomBigView)
        if !isSameViewDidTapped {
            _newSelectedView.imageView.isHidden = false
            _oldSelectedBigView.imageView.isHidden = true
            self.selectedView?.layer.cornerRadius = 0
            let allViews = redViews + orangeViews + purpleViews + greenViews
            allViews.forEach { view in
                let sameColor = (view.backgroundColor == newSelectedView.backgroundColor)
                let sameAlpha = (view.alpha == newSelectedView.alpha)
                if sameColor && sameAlpha {
                    view.layer.cornerRadius = view.frame.size.width / 2
                    self.selectedView = view
                }
            }
        }
        oldSelectedBigView = newSelectedView
    }
    
}

