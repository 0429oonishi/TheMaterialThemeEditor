//
//  ThemeColorViewController.swift
//  TheMaterialThemeEditor
//
//  Created by 大西玲音 on 2021/06/03.
//

import UIKit

enum ThemeColorTitle: String, CaseIterable {
    case natural
    case pop
    case elegant
    case modern
    case season
    case japan
    case overseas
    case service
}

class ThemeColorViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    var themeColorTitles: [String] = ThemeColorTitle.allCases.map { $0.rawValue.uppercased() }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(ThemeColorCollectionViewCell.nib,
                                forCellWithReuseIdentifier: ThemeColorCollectionViewCell.identifier)
        
    }
    


}

extension ThemeColorViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print(themeColorTitles[indexPath.item])
    }
    
}

extension ThemeColorViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return themeColorTitles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ThemeColorCollectionViewCell.identifier,
                                                      for: indexPath) as! ThemeColorCollectionViewCell
        let title = themeColorTitles[indexPath.item]
        cell.configure(title: title)
        cell.backgroundColor = .red
        return cell
    }
    
    
}

extension ThemeColorViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let viewSize = UIScreen.main.bounds.width
        return CGSize(width: viewSize, height: 200)
    }
}
