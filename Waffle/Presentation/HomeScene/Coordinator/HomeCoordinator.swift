//
//  HomeCoordinator.swift
//  Waffle
//
//  Created by 조소정 on 2022/06/12.
//

import Foundation
import UIKit

final class HomeCoordinator: HomeCoordinatorProtocol {
    
    var finishDelegate: CoordinatorFinishDelegate?
    
    var navigationController: UINavigationController
    var homeViewController: HomeViewController
    var childCoordinators: [Coordinator] = []
    
    var type: CoordinatorType = .home
    var detailArchiveViewController = UIStoryboard(name: "Home", bundle: nil).instantiateViewController(withIdentifier: "DetailArchiveViewController") as! DetailArchiveViewController
    
    init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.navigationController.setNavigationBarHidden(false, animated: true)
        self.homeViewController = UIStoryboard(name: "Home", bundle: nil).instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
    }
    
    func start() {
        homeViewController.viewModel = HomeViewModel(coordinator: self, usecase: HomeUsecase(repository: HomeRepository(networkService: URLSessionNetworkService())))
        self.navigationController.pushViewController(self.homeViewController, animated: true)
    }
    
    func archiveFlow(cardInfo: CardInfo?) { 
        let archiveCoordinator = ArchiveCoordinator(self.navigationController)
        self.childCoordinators.append(archiveCoordinator)
        archiveCoordinator.finishDelegate = self
        archiveCoordinator.addArchive(isEditing: false, cardInfo: cardInfo)
    }
    
    func detailArchive(selectedArchive: CardInfo) {
        detailArchiveViewController = UIStoryboard(name: "Home", bundle: nil).instantiateViewController(withIdentifier: "DetailArchiveViewController") as! DetailArchiveViewController
        detailArchiveViewController.viewModel?.setArchive(archive: selectedArchive)
        detailArchiveViewController.viewModel = DetailArchiveViewModel(coordinator: self, usecase: HomeUsecase(repository: HomeRepository(networkService: URLSessionNetworkService())))
        
        //데이터 전달
        detailArchiveViewController.viewModel?.detailArchive = selectedArchive
        self.navigationController.pushViewController(detailArchiveViewController, animated: true)
    }
    
    func addDetailPlace(category: [Category]) {
        let addDetailPlaceViewController = UIStoryboard(name: "Home", bundle: nil).instantiateViewController(withIdentifier: "AddDetailPlaceViewController") as! AddDetailPlaceViewController
        addDetailPlaceViewController.viewModel = AddDetailPlaceViewModel(coordinator: self, usecase: HomeUsecase(repository: HomeRepository(networkService: URLSessionNetworkService())))
        addDetailPlaceViewController.viewModel?.categoryInfo = category
        self.navigationController.pushViewController(addDetailPlaceViewController, animated: true)
    }
    
    func searchPlace() {
        let searchPlaceViewController = UIStoryboard(name: "Home", bundle: nil).instantiateViewController(withIdentifier: "SearchPlaceViewController") as! SearchPlaceViewController
        searchPlaceViewController.viewModel = SearchPlaceViewModel(coordinator: self, usecase: HomeUsecase(repository: HomeRepository(networkService: URLSessionNetworkService())))
        self.navigationController.pushViewController(searchPlaceViewController, animated: true)
    }
    
    func editPlace(placeId: Int, category: [Category]) {
        let editPlaceViewController = UIStoryboard(name: "Home", bundle: nil).instantiateViewController(withIdentifier: "EditPlaceViewController") as! EditPlaceViewController
        editPlaceViewController.viewModel = EditPlaceViewModel(coordinator: self, usecase: HomeUsecase(repository: HomeRepository(networkService: URLSessionNetworkService())))
        editPlaceViewController.viewModel?.categoryInfo = category
        self.navigationController.pushViewController(editPlaceViewController, animated: true)
    }
    
    func deleteCategory(category: Category) {
        let categoryDeletePopUpView = UIStoryboard(name: "Home", bundle: nil).instantiateViewController(withIdentifier: "CategoryDeletePopUpViewController") as! CategoryDeletePopUpViewController
        categoryDeletePopUpView.coordinator = self
        categoryDeletePopUpView.usecase = HomeUsecase(repository: HomeRepository(networkService: URLSessionNetworkService()))
        categoryDeletePopUpView.selectedCategory = category
        categoryDeletePopUpView.modalPresentationStyle = .overFullScreen
        categoryDeletePopUpView.modalTransitionStyle = .crossDissolve
        self.navigationController.present(categoryDeletePopUpView, animated: false)
    }
    
    func arhiveDelete() {
        let deleteArchivePopUpView = UIStoryboard(name: "Home", bundle: nil).instantiateViewController(withIdentifier: "DeleteArhiveViewPopUpController") as! DeleteArhiveViewPopUpController
        deleteArchivePopUpView.coordinator = self
        deleteArchivePopUpView.usecase = HomeUsecase(repository: HomeRepository(networkService: URLSessionNetworkService()))
        deleteArchivePopUpView.modalPresentationStyle = .overFullScreen
        deleteArchivePopUpView.modalTransitionStyle = .crossDissolve
        self.navigationController.present(deleteArchivePopUpView, animated: false)
    }
    
    
    func likeSend() {
        let likeSendPopUpView = UIStoryboard(name: "Home", bundle: nil).instantiateViewController(withIdentifier: "LikeSendPopUpViewController") as! LikeSendPopUpViewController
        likeSendPopUpView.coordinator = self
        likeSendPopUpView.usecase = HomeUsecase(repository: HomeRepository(networkService: URLSessionNetworkService()))
        likeSendPopUpView.modalPresentationStyle = .overFullScreen
        likeSendPopUpView.modalTransitionStyle = .crossDissolve
        self.navigationController.present(likeSendPopUpView, animated: false)
    }
    
    func deletePlace(placeId: Int) {
        let deletePlacePopUpView = UIStoryboard(name: "Home", bundle: nil).instantiateViewController(withIdentifier: "DeletePlacePopUpViewController") as! DeletePlacePopUpViewController
        deletePlacePopUpView.placeId = placeId
        deletePlacePopUpView.coordinator = self
        deletePlacePopUpView.usecase = HomeUsecase(repository: HomeRepository(networkService: URLSessionNetworkService()))
        deletePlacePopUpView.modalPresentationStyle = .overFullScreen
        deletePlacePopUpView.modalTransitionStyle = .crossDissolve
        self.navigationController.present(deletePlacePopUpView, animated: false)
    }
    
    func editArchive(cardInfo: CardInfo?) {
        let archiveCoordinator = ArchiveCoordinator(self.navigationController)
        self.childCoordinators.append(archiveCoordinator)
        archiveCoordinator.finishDelegate = self
        archiveCoordinator.addArchive(isEditing: true, cardInfo: cardInfo)
    }
    
    func popToViewController(with toastMessage: String?, width: CGFloat?, height: CGFloat?) {
        self.navigationController.dismiss(animated: true)
        if let toastMessage = toastMessage, let width = width, let height = height {
            self.navigationController.topViewController?.showToast(message: toastMessage, width: width, height: height)
        }
    }
    
    func popViewController() {
        self.navigationController.popViewController(animated: true)
    }
    
    func selectPlace(place: PlaceSearchInfo?) {
        self.navigationController.popViewController(animated: true)
        guard let topViewController = navigationController.topViewController as? AddDetailPlaceViewController else { return }
        topViewController.viewModel?.getPlace = place
        topViewController.viewModel?.placeViewEnabled.accept(true)
    }
    
    func finish() {
        self.finishDelegate?.coordinatorDidFinish(childCoordinator: self)
    }
    
    
}

extension HomeCoordinator {
    func detailArchiveBottomSheet(cardInfo: CardInfo?) {
        let detailArchiveBottomSheetView  = UIStoryboard(name: "Home", bundle: nil).instantiateViewController(withIdentifier: "ArchiveDetailPopUpViewController") as! ArchiveDetailPopUpViewController
        detailArchiveBottomSheetView.coordinator = self
        detailArchiveBottomSheetView.cardInfo = cardInfo
        detailArchiveBottomSheetView.modalPresentationStyle = .overFullScreen
        detailArchiveBottomSheetView.modalTransitionStyle = .crossDissolve
        self.navigationController.present(detailArchiveBottomSheetView, animated: false)
    }
    
    func invitationBottomSheet(copyCode: String) {
        let invitationBottomSheetView = UIStoryboard(name: "Home", bundle: nil).instantiateViewController(withIdentifier: "InvitationBottomSheetViewController") as! InvitationBottomSheetViewController
        invitationBottomSheetView.coordinator = self
        invitationBottomSheetView.archiveCode = copyCode
        invitationBottomSheetView.modalPresentationStyle = .overFullScreen
        invitationBottomSheetView.modalTransitionStyle = .crossDissolve
        self.navigationController.present(invitationBottomSheetView, animated: false)
    }
}

extension HomeCoordinator {
    func addCategory(category: [Category]) {
        let homeCategoryPopUpView = UIStoryboard(name: "Home", bundle: nil).instantiateViewController(withIdentifier: "HomeCategoryPopUpViewController") as! HomeCategoryPopUpViewController
        homeCategoryPopUpView.coordinator = self
        homeCategoryPopUpView.delegate = detailArchiveViewController
        homeCategoryPopUpView.selectedCategoryList = category
        homeCategoryPopUpView.modalPresentationStyle = .overFullScreen
        homeCategoryPopUpView.modalTransitionStyle = .crossDissolve
        self.navigationController.present(homeCategoryPopUpView, animated: false)
    }
    
    func loadMemo(memo: String, wapple: String) {
        let memoPopUpView = UIStoryboard(name: "Home", bundle: nil).instantiateViewController(withIdentifier: "MemoPopUpViewController") as! MemoPopUpViewController
        memoPopUpView.memoText = memo
        memoPopUpView.wappleName = wapple
        memoPopUpView.coordinator = self
        memoPopUpView.modalPresentationStyle = .overFullScreen
        memoPopUpView.modalTransitionStyle = .crossDissolve
        self.navigationController.present(memoPopUpView, animated: false)
    }
    
    func participants(cardInfo: CardInfo?) {
        let particiPopUpView = UIStoryboard(name: "Home", bundle: nil).instantiateViewController(withIdentifier: "ParticiPopUpViewController") as! ParticiPopUpViewController
        particiPopUpView.coordinator = self
        particiPopUpView.cardInfo = cardInfo
        particiPopUpView.modalPresentationStyle = .overFullScreen
        particiPopUpView.modalTransitionStyle = .crossDissolve
        self.navigationController.present(particiPopUpView, animated: false)
    }
    
    func detailPlace(detailInfo: PlaceInfo, category: Category, categoryInfo: [Category]) {
        let detailPlacePopUpView = UIStoryboard(name: "Home", bundle: nil).instantiateViewController(withIdentifier: "DetailPlacePopUpViewController") as! DetailPlacePopUpViewController
        detailPlacePopUpView.coordinator = self
        detailPlacePopUpView.detailInfo = detailInfo
        detailPlacePopUpView.category = category
        detailPlacePopUpView.categoryInfo = categoryInfo
        detailPlacePopUpView.modalPresentationStyle = .overFullScreen
        detailPlacePopUpView.modalTransitionStyle = .crossDissolve
        self.navigationController.present(detailPlacePopUpView, animated: false)
    }
}

extension HomeCoordinator: CoordinatorFinishDelegate {
    func coordinatorDidFinish(childCoordinator: Coordinator) {
        self.childCoordinators = self.childCoordinators
            .filter({ $0.type != childCoordinator.type })
        childCoordinator.navigationController.popViewController(animated: true)
    }
    
}
