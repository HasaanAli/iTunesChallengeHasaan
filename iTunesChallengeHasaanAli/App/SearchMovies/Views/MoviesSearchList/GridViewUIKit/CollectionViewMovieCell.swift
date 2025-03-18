//
//  CollectionViewMovieCell.swift
//  iTunesChallengeHasaanAli
//
//  Created by Hasaan Ali on 16/03/2025.
//

import UIKit

class CustomCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var movieArtImageView: UIImageView!
    @IBOutlet weak var favoriteImageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
}
