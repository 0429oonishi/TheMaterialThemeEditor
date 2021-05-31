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
    @IBOutlet private weak var orangeStackView: UIStackView!
    @IBOutlet private weak var purpleStackView: UIStackView!
    @IBOutlet private weak var greenStackView: UIStackView!
    @IBOutlet private weak var skyBlueStackView: UIStackView!
    @IBOutlet private weak var pinkStackView: UIStackView!
    @IBOutlet private weak var blueStackView: UIStackView!
    @IBOutlet private weak var yellowGreenStackView: UIStackView!
    @IBOutlet private weak var purpleBlueStackView: UIStackView!
    @IBOutlet private weak var pink2StackView: UIStackView!
    @IBOutlet private weak var pink3StackView: UIStackView!
    
    private var selectedView: UIView?
    private var oldSelectedBigView: UIView?
    private var allViews = [CustomView]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view1.delegate = self
        view2.delegate = self
        view3.delegate = self
        
        configure(redStackView)
        configure(orangeStackView)
        configure(purpleStackView)
        configure(greenStackView)
        configure(skyBlueStackView)
        configure(pinkStackView)
        configure(blueStackView)
        configure(yellowGreenStackView)
        configure(purpleBlueStackView)
        configure(pink2StackView)
        configure(pink3StackView)
        
        view1.backgroundColor = redStackView.arrangedSubviews[0].backgroundColor
        view2.backgroundColor = orangeStackView.arrangedSubviews[1].backgroundColor
        view3.backgroundColor = purpleStackView.arrangedSubviews[2].backgroundColor

        configureImageView(view: view1)
        configureImageView(view: view2)
        configureImageView(view: view3)
        view1.imageView.isHidden = false
        oldSelectedBigView = view1
        find(selectedView: view1)
        
    }
    
    private func configure(_ stackView: UIStackView) {
        stackView.arrangedSubviews
            .map { $0 as! CustomView }
            .forEach {
                $0.delegate = self
                allViews.append($0)
            }
    }
    
    private func configureImageView(view: CustomBigView) {
        view.addSubview(view.imageView)
        [view.imageView.heightAnchor.constraint(equalToConstant: 50),
         view.imageView.widthAnchor.constraint(equalToConstant: 50),
         view.imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
         view.imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
        ].forEach { $0.isActive = true }
        view.imageView.isHidden = true
    }
    
    private func find(selectedView: UIView) {
        allViews.forEach { view in
            let sameColor = (view.backgroundColor == selectedView.backgroundColor)
            let sameAlpha = (view.alpha == selectedView.alpha)
            if sameColor && sameAlpha {
                view.layer.cornerRadius = view.frame.size.width / 2
                self.selectedView = view
            }
        }
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
            self.find(selectedView: newSelectedView)
        }
        oldSelectedBigView = newSelectedView
    }
    
}

