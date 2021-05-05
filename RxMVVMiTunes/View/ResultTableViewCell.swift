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
        ImageManager.instance.fetchImage(with: track.artworkUrl100) { result in
            switch result {
            case .success(let image):
                self.albumImageView.image = image
            case .failure(let error):
                ErrorUtil.instance.logError(error: error)
            }
        }
        
        titleLabel.text = track.trackName
        subTitleLabel.text = track.artistName
    }
    
}
