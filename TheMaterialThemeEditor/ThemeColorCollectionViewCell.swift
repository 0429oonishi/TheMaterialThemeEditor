//
//  ThemeColorCollectionViewCell.swift
//  TheMaterialThemeEditor
//
//  Created by 大西玲音 on 2021/06/03.
//

import UIKit

class ThemeColorCollectionViewCell: UICollectionViewCell {
    
    static var identifier: String { String(describing: self) }
    static var nib: UINib { UINib(nibName: String(describing: self), bundle: nil) }

    @IBOutlet weak var label: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func configure(title: String) {
        label.text = title
    }

}
