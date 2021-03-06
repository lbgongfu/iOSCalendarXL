//
//  RemindCell.swift
//  SKCalendarView
//
//  Created by 李彪 on 2018/8/24.
//  Copyright © 2018年 shevchenko. All rights reserved.
//

import UIKit
import AssetsLibrary

protocol RemindCellDelegate {
    func imageClicked(index: Int, images: [Media])
}

class RemindCell: UITableViewCell, UICollectionViewDataSource, UICollectionViewDelegate {
    
    var medias: [Media] = []{
        didSet {
            audios.removeAll()
            images.removeAll()
            medias.forEach({(media) in
                if (media.type == .Audio) {
                    audios.append(media)
                } else if (media.type == .Image) {
                    images.append(media)
                }
            })
            updateAudioCollectionViewHeight()
            updateImageCollectionViewHeight()
            collectionViewImage.reloadData()
            collectionViewAudio.reloadData()
        }
    }
    
    var delegate: RemindCellDelegate?
    
    private var audios: [Media] = []
    
    private var images: [Media] = []
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == collectionViewAudio {
            return audios.count
        } else {
            return images.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if (collectionView == collectionViewAudio) {
            let audio = audios[indexPath.row]
            let audioCell = collectionViewAudio.dequeueReusableCell(withReuseIdentifier: "audioClipCell", for: indexPath) as! AudioClipCell
            audioCell.media = audio
            audioCell.setCanDelete(canDelete: false)
            return audioCell
        } else {
            let image = images[indexPath.row]
            let imageCell = collectionView.dequeueReusableCell(withReuseIdentifier: "imageCell", for: indexPath) as! ImageCell
            imageCell.setCanDelete(canDelete: false)
            let url = NSURL(string: image.filePath)!
            let assetLibrary = ALAssetsLibrary()
            assetLibrary.asset(for: url as URL!, resultBlock: { (asset:ALAsset?) -> Void in
                if let imageRef = asset?.defaultRepresentation().fullScreenImage() {
                    imageCell.image.image = UIImage(cgImage: imageRef.takeUnretainedValue())
                }
            }, failureBlock: {(error) in
                print("get file path error: \(error)")
            })
            return imageCell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == collectionViewImage {
            delegate?.imageClicked(index: indexPath.row, images: images)
        }
    }
    
    func updateAudioCollectionViewHeight() {
        let hCount = Int(collectionViewAudio.frame.width) / RemindViewController.mediaCellSize
        var row = audios.count / hCount
        row = audios.count % hCount == 0 ? row : row + 1
        collectionViewAudio.constraints.forEach({constraint in
            if constraint.firstAttribute == .height {
                constraint.constant = CGFloat(row * RemindViewController.mediaCellSize)
            }
        })
//        if heightConstraint == nil {
//            heightConstraint = NSLayoutConstraint(item: collectionViewAudio, attribute: NSLayoutAttribute.height, relatedBy: NSLayoutRelation.equal, toItem: nil, attribute: NSLayoutAttribute.notAnAttribute, multiplier: 1, constant: CGFloat(row * RemindViewController.mediaCellSize))
//
//            collectionViewAudio.addConstraint(heightConstraint!)
//        } else {
//            heightConstraint?.constant = CGFloat(row * RemindViewController.mediaCellSize)
//        }
    }
    
    func updateImageCollectionViewHeight() {
        let hCount = Int(collectionViewAudio.frame.width) / RemindViewController.mediaCellSize
        var row = images.count / hCount
        row = images.count % hCount == 0 ? row : row + 1
        collectionViewImage.constraints.forEach({constraint in
            if constraint.firstAttribute == .height {
                constraint.constant = CGFloat(row * RemindViewController.mediaCellSize)
            }
        })
    }
    
    @IBOutlet weak var labelRemindContent: UILabel!
    @IBOutlet weak var labelFriendlyTime: UILabel!
    @IBOutlet weak var labelDate: UILabel!
    @IBOutlet weak var labelTime: UILabel!
    @IBOutlet weak var labelLocation: UILabel!
    @IBOutlet weak var viewBackground: UIView!
    @IBOutlet weak var collectionViewAudio: UICollectionView!
    @IBOutlet weak var collectionViewImage: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        labelFriendlyTime.sakura.textColor()("accentColor")
        
        viewBackground.layer.cornerRadius = 8
        var cellNib = UINib(nibName: "AudioClipCell", bundle: nil)
        collectionViewAudio.register(cellNib, forCellWithReuseIdentifier: "audioClipCell")
        cellNib = UINib(nibName: "ImageCell", bundle: nil)
        collectionViewImage.register(cellNib, forCellWithReuseIdentifier: "imageCell")
        
        var layout = collectionViewAudio.collectionViewLayout as! LXCollectionViewLeftOrRightAlignedLayout
        layout.itemSize = CGSize(width: RemindViewController.mediaCellSize, height: RemindViewController.mediaCellSize)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0)
        layout.estimatedItemSize = CGSize(width: RemindViewController.mediaCellSize, height: RemindViewController.mediaCellSize)
        
        updateAudioCollectionViewHeight()
        
        layout = collectionViewImage.collectionViewLayout as! LXCollectionViewLeftOrRightAlignedLayout
        layout.itemSize = CGSize(width: RemindViewController.mediaCellSize, height: RemindViewController.mediaCellSize)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0)
        layout.estimatedItemSize = CGSize(width: RemindViewController.mediaCellSize, height: RemindViewController.mediaCellSize)
        
        updateImageCollectionViewHeight()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
}
