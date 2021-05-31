//
//  ViewController.swift
//  TheMaterialThemeEditor
//
//  Created by 大西玲音 on 2021/05/31.
//

import UIKit

protocol CustomViewDelegate: AnyObject {
    func didTapped(selectedView: UIView)
}

final class CustomView: UIView {
    
    weak var delegate: CustomViewDelegate?
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        UIView.animate(withDuration: 0, animations: {
            self.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
        }, completion: { _ in
            UIView.animate(withDuration: 0.1) {
                self.transform = .identity
                self.layer.cornerRadius = self.frame.size.width / 2
            }
        })
        delegate?.didTapped(selectedView: self)
    }
    
}

protocol CustomBigViewDelegate: AnyObject {
    func didTapped(newSelectedBigView: UIView)
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
        delegate?.didTapped(newSelectedBigView: self)
    }
    
}

final class ViewController: UIViewController {
    
    @IBOutlet private weak var mainColorView: CustomBigView!
    @IBOutlet private weak var subColorView: CustomBigView!
    @IBOutlet private weak var accentColorView: CustomBigView!
    @IBOutlet private weak var themeColorStackView: UIStackView!
    
    private var selectedView: UIView?
    private var oldSelectedBigView: UIView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainColorView.delegate = self
        subColorView.delegate = self
        accentColorView.delegate = self
        
        themeColorStackViewAction { $0.delegate = self }
        
        setupImageView(view: mainColorView)
        setupImageView(view: subColorView)
        setupImageView(view: accentColorView)
        mainColorView.imageView.isHidden = false
        oldSelectedBigView = mainColorView
        find(selectedView: mainColorView)
        
    }
    
    private func setupImageView(view: CustomBigView) {
        view.addSubview(view.imageView)
        [view.imageView.heightAnchor.constraint(equalToConstant: 50),
         view.imageView.widthAnchor.constraint(equalToConstant: 50),
         view.imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
         view.imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ].forEach { $0.isActive = true }
        view.imageView.isHidden = true
    }
    
    private func find(selectedView: UIView) {
        themeColorStackViewAction { view in
            let sameColor = (view.backgroundColor == selectedView.backgroundColor)
            let sameAlpha = (view.alpha == selectedView.alpha)
            if sameColor && sameAlpha {
                view.layer.cornerRadius = view.frame.size.width / 2
                self.selectedView = view
            }
        }
    }
    
    private func themeColorStackViewAction(handler: (CustomView) -> Void) {
        themeColorStackView.arrangedSubviews
            .map { $0 as! UIStackView }
            .forEach { stackView in
                stackView.arrangedSubviews
                    .map { $0 as! CustomView }
                    .forEach { handler($0) }
            }
    }
    
}

extension ViewController: CustomViewDelegate {
    
    func didTapped(selectedView: UIView) {
        oldSelectedBigView?.backgroundColor = selectedView.backgroundColor
        oldSelectedBigView?.alpha = selectedView.alpha
        UIView.animate(withDuration: 0.1) {
            if self.selectedView != selectedView {
                self.selectedView?.layer.cornerRadius = 0
            }
        }
        self.selectedView = selectedView
    }
    
}

extension ViewController: CustomBigViewDelegate {
    
    func didTapped(newSelectedBigView: UIView) {
        let isSameViewDidTapped = (oldSelectedBigView == newSelectedBigView)
        let _newSelectedView = (newSelectedBigView as! CustomBigView)
        let _oldSelectedBigView = (oldSelectedBigView as! CustomBigView)
        if !isSameViewDidTapped {
            _newSelectedView.imageView.isHidden = false
            _oldSelectedBigView.imageView.isHidden = true
            selectedView?.layer.cornerRadius = 0
            find(selectedView: newSelectedBigView)
        }
        self.oldSelectedBigView = newSelectedBigView
    }
    
}

