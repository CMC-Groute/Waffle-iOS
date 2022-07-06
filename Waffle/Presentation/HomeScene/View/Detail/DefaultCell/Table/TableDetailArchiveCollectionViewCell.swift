//
//  TableDetailArchiveCollectionViewCell.swift
//  Waffle
//
//  Created by 조한빛 on 2022/07/06.
//

import UIKit

class TableDetailArchiveCollectionViewCell: UICollectionViewCell {
    static let identifier = "TableDetailArchiveCollectionViewCell"
    @IBOutlet private weak var tableView: UITableView!
    //var viewModel: DetailArchiveViewModel?
    var place: [PlaceInfo] = []
    var categories: [Category] = []
    
    var noPlaceView: UIView = {
        let view = UIView()
        return view
    }()

    var noPlaceLabel: UILabel = {
        let label = UILabel()
        label.textColor = Asset.Colors.gray7.color
        label.text = "아직 확정된 장소가 없어요"
        label.font = UIFont.fontWithName(type: .semibold, size: 15)
        return label
    }()

    var noPlaceImageView: UIImageView = {
        let noPlaceImage = Asset.Assets.noPlace.image
        let imageView = UIImageView(image: noPlaceImage)
        return imageView
    }()
        
    override func awakeFromNib() {
        super.awakeFromNib()
        configureUI()
    }
    
    private func configureUI() {
        configureNoPlaceView()
        configureTableView()
    }
    
    private func configureNoPlaceView() {
        noPlaceView.addSubview(noPlaceImageView)
        noPlaceView.addSubview(noPlaceLabel)

        noPlaceImageView.snp.makeConstraints {
            $0.top.equalTo(78)
            $0.centerX.equalTo(noPlaceView)
            $0.width.height.equalTo(64)
        }

        noPlaceLabel.snp.makeConstraints {
            $0.centerX.equalTo(noPlaceView)
            $0.top.equalTo(noPlaceImageView.snp.bottom).offset(16)
        }

        noPlaceView.frame = CGRect(x: 0, y: 0, width: self.tableView.frame.width, height: self.tableView.frame.height)
    }
    
    private func configureTableView() {
        tableView.register(UINib(nibName: "DetailPlaceTableViewCell", bundle: nil), forCellReuseIdentifier: DetailPlaceTableViewCell.identifier)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = UITableView.automaticDimension
    }
    
    func configureCell(place: [PlaceInfo]) {
        self.place = place
        self.tableView.reloadData()
    }

}

extension TableDetailArchiveCollectionViewCell: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
       return CGFloat(182)
   }
}

extension TableDetailArchiveCollectionViewCell: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if place.isEmpty {
            tableView.backgroundView  = noPlaceView
            return 0
        }
        tableView.backgroundView = nil
        return place.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: DetailPlaceTableViewCell.identifier, for: indexPath) as! DetailPlaceTableViewCell
        cell.selectionStyle = .none
        cell.delegate = self
        cell.setPlaceId(index: indexPath.row)
        cell.configureCell(placeInfo: place[indexPath.row])
        return cell
    }

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
       return true
    }

    // Move Row Instance Method
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        
        //print("\(sourceIndexPath.row) -> \(destinationIndexPath.row)")
        let moveCell = place[sourceIndexPath.row]
        place.remove(at: sourceIndexPath.row)
        place.insert(moveCell, at: destinationIndexPath.row)
        tableView.dragInteractionEnabled = false
    }
}

extension TableDetailArchiveCollectionViewCell: DetailPlaceTableViewCellDelegate {
    func canEditingButton(cell: DetailPlaceTableViewCell) {
            //TO DO
            //tableView drag and drop
            tableView.dragInteractionEnabled = true
            tableView.dragDelegate = self
            tableView.dropDelegate = self
        }
    
        func didTapLikeButton(cell: DetailPlaceTableViewCell) {
            print("didTapLikeButton")
    //        print(cell.likeButton.isSelected)
    //        print(cell.placeId)
            if cell.likeButton.isSelected {
                place[cell.placeId].likeCount += 1
            }else {
                if (place[cell.placeId].likeCount) > 0 {
                    place[cell.placeId].likeCount -= 1
                }
            }
            place[cell.placeId].likeSelected = cell.likeButton.isSelected
            tableView.reloadRows(at: [[0, cell.placeId]], with: .none)
        }
    
        func didTapConfirmButton(cell: DetailPlaceTableViewCell) {
            print("didTapConfirmButton")
    //        print(cell.confirmButton.isSelected)
    //        print(cell.placeId)
        }
    
        func didTapDetailButton(cell: DetailPlaceTableViewCell) {
            //guard let placeInfo = place[cell.placeId] else { return }
           // self.viewModel!.detailPlace(place: placeInfo, category: category[cell.placeId])
        }
}

//MARK: Drag And Drop
extension TableDetailArchiveCollectionViewCell: UITableViewDragDelegate {
    func tableView(_ tableView: UITableView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
            return [UIDragItem(itemProvider: NSItemProvider())]
        }
}

extension TableDetailArchiveCollectionViewCell: UITableViewDropDelegate {
    func tableView(_ tableView: UITableView, dropSessionDidUpdate session: UIDropSession, withDestinationIndexPath destinationIndexPath: IndexPath?) -> UITableViewDropProposal {
        if session.localDragSession != nil {
            return UITableViewDropProposal(operation: .move, intent: .insertAtDestinationIndexPath)
        }
        return UITableViewDropProposal(operation: .cancel, intent: .unspecified)
    }
    func tableView(_ tableView: UITableView, performDropWith coordinator: UITableViewDropCoordinator) {
    }
}
