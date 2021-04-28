//
//  ResultTableViewCell.swift
//  RxMVVMiTunes
//
//  Created by 유연주 on 2021/04/24.
//

import UIKit

final class ResultTableViewCell: UITableViewCell {

    @IBOutlet var albumImageView: UIImageView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var subTitleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configureCell(with track: Track) {
        ImageCacheManager.instance.fetchImage(with: track.artworkUrl100) { image in
            self.albumImageView.image = image
        }
        
        titleLabel.text = track.trackName
    }
    
}
