//
//  ResultTableViewCell.swift
//  RxMVVMiTunes
//
//  Created by 유연주 on 2021/04/24.
//

import UIKit

final class ResultTableViewCell: UITableViewCell {

    @IBOutlet var albumImageView: ImageView!
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var subTitleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configureCell(with track: Track) {
        albumImageView.setImage(with: track.artworkUrl100)
        titleLabel.text = track.trackName
        subTitleLabel.text = track.artistName
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        albumImageView.image = nil
        albumImageView.loader.cancelTask()
    }
    
}
