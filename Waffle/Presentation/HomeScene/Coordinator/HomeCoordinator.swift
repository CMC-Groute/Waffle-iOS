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
        self.navigationController.pushViewController(homeViewController, animated: true)
    }
    
    func detailArchive(archiveId: Int) {
        self.navigationController.setNavigationBarHidden(false, animated: true)
        detailArchiveViewController = UIStoryboard(name: "Home", bundle: nil).instantiateViewController(withIdentifier: "DetailArchiveViewController") as! DetailArchiveViewController
        detailArchiveViewController.viewModel = DetailArchiveViewModel(coordinator: self, usecase: HomeUsecase(repository: HomeRepository(networkService: URLSessionNetworkService())))
        detailArchiveViewController.viewModel?.archiveId = archiveId
        self.navigationController.pushViewController(detailArchiveViewController, animated: true)
    }
    
    func addDetailPlace(archiveId: Int, category: [PlaceCategory]) {
        let addDetailPlaceViewController = UIStoryboard(name: "Home", bundle: nil).instantiateViewController(withIdentifier: "AddDetailPlaceViewController") as! AddDetailPlaceViewController
        addDetailPlaceViewController.viewModel = AddDetailPlaceViewModel(coordinator: self, usecase: HomeUsecase(repository: HomeRepository(networkService: URLSessionNetworkService())))
        addDetailPlaceViewController.viewModel?.archiveId = archiveId
        addDetailPlaceViewController.viewModel?.categoryInfo = category
        self.navigationController.pushViewController(addDetailPlaceViewController, animated: true)
    }
    
    func searchPlace() {
        let searchPlaceViewController = UIStoryboard(name: "Home", bundle: nil).instantiateViewController(withIdentifier: "SearchPlaceViewController") as! SearchPlaceViewController
        searchPlaceViewController.viewModel = SearchPlaceViewModel(coordinator: self, usecase: HomeUsecase(repository: HomeRepository(networkService: URLSessionNetworkService())))
        self.navigationController.pushViewController(searchPlaceViewController, animated: true)
    }
    
    func editPlace(archiveId: Int, placeId: Int, category: [PlaceCategory], place: PlaceInfo, detailPlace: DetailPlaceInfo, selectedCategory: PlaceCategory) {
        let editPlaceViewController = UIStoryboard(name: "Home", bundle: nil).instantiateViewController(withIdentifier: "EditPlaceViewController") as! EditPlaceViewController
        editPlaceViewController.viewModel = EditPlaceViewModel(coordinator: self, usecase: HomeUsecase(repository: HomeRepository(networkService: URLSessionNetworkService())))
        editPlaceViewController.viewModel?.selectedCategory = selectedCategory
        editPlaceViewController.viewModel?.place = place
        editPlaceViewController.viewModel?.detailPlace = detailPlace
        editPlaceViewController.viewModel?.archiveId = archiveId
        editPlaceViewController.viewModel?.placeId = placeId
        editPlaceViewController.viewModel?.categoryInfo = category
        self.navigationController.pushViewController(editPlaceViewController, animated: true)
    }
    
    func deleteCategory(archiveId: Int, category: PlaceCategory) {
        let categoryDeletePopUpView = UIStoryboard(name: "Home", bundle: nil).instantiateViewController(withIdentifier: "CategoryDeletePopUpViewController") as! CategoryDeletePopUpViewController
        categoryDeletePopUpView.coordinator = self
        categoryDeletePopUpView.usecase = HomeUsecase(repository: HomeRepository(networkService: URLSessionNetworkService()))
        categoryDeletePopUpView.delegate = detailArchiveViewController
        categoryDeletePopUpView.archiveId = archiveId
        categoryDeletePopUpView.selectedCategory = category
        categoryDeletePopUpView.modalPresentationStyle = .overFullScreen
        categoryDeletePopUpView.modalTransitionStyle = .crossDissolve
        self.navigationController.present(categoryDeletePopUpView, animated: false)
    }
    
    func arhiveDelete(archiveId: Int) {
        let deleteArchivePopUpView = UIStoryboard(name: "Home", bundle: nil).instantiateViewController(withIdentifier: "DeleteArhiveViewPopUpController") as! DeleteArhiveViewPopUpController
        deleteArchivePopUpView.archiveId = archiveId
        deleteArchivePopUpView.coordinator = self
        deleteArchivePopUpView.usecase = HomeUsecase(repository: HomeRepository(networkService: URLSessionNetworkService()))
        deleteArchivePopUpView.modalPresentationStyle = .overFullScreen
        deleteArchivePopUpView.modalTransitionStyle = .crossDissolve
        self.navigationController.present(deleteArchivePopUpView, animated: false)
    }
    
    
    func likeSend(archiveId: Int) {
        let likeSendPopUpView = UIStoryboard(name: "Home", bundle: nil).instantiateViewController(withIdentifier: "LikeSendPopUpViewController") as! LikeSendPopUpViewController
        likeSendPopUpView.archiveId = archiveId
        likeSendPopUpView.coordinator = self
        likeSendPopUpView.usecase = HomeUsecase(repository: HomeRepository(networkService: URLSessionNetworkService()))
        likeSendPopUpView.modalPresentationStyle = .overFullScreen
        likeSendPopUpView.modalTransitionStyle = .crossDissolve
        self.navigationController.present(likeSendPopUpView, animated: false)
    }
    
    func deletePlace(archiveId: Int, placeId: Int) {
        let deletePlacePopUpView = UIStoryboard(name: "Home", bundle: nil).instantiateViewController(withIdentifier: "DeletePlacePopUpViewController") as! DeletePlacePopUpViewController
        deletePlacePopUpView.archiveId = archiveId
        deletePlacePopUpView.placeId = placeId
        deletePlacePopUpView.coordinator = self
        deletePlacePopUpView.usecase = HomeUsecase(repository: HomeRepository(networkService: URLSessionNetworkService()))
        deletePlacePopUpView.modalPresentationStyle = .overFullScreen
        deletePlacePopUpView.modalTransitionStyle = .crossDissolve
        self.navigationController.present(deletePlacePopUpView, animated: false)
    }
    
    func popToViewController(with toastMessage: String?, width: CGFloat?, height: CGFloat?) {
        self.navigationController.dismiss(animated: true)
        if let toastMessage = toastMessage, let width = width, let height = height {
            self.navigationController.topViewController?.showToast(message: toastMessage, width: width, height: height)
        }
    }
    
    func popViewController() {
        self.navigationController.setNavigationBarHidden(false, animated: true)
        self.navigationController.popViewController(animated: true)
    }
    
    func popViewController(category: PlaceCategory) {
        self.navigationController.setNavigationBarHidden(false, animated: true)
        self.navigationController.popViewController(animated: true)
        if let topViewController = navigationController.topViewController as? DetailArchiveViewController {
            topViewController.viewModel?.selectedCategory = category
        }
    }
    
    func selectPlace(place: PlaceSearch) { // 장소 검색 후 돌아오기
        self.navigationController.popViewController(animated: true)
        if let topViewController = navigationController.topViewController as? AddDetailPlaceViewController  {
            topViewController.viewModel?.getPlace = place
            topViewController.viewModel?.placeViewEnabled.accept(true)
        }else {
            if let topViewController = navigationController.topViewController as? EditPlaceViewController {
                topViewController.viewModel?.getPlace = place
                topViewController.viewModel?.placeViewEnabled.accept(true)
            }
        }
    }
    
    func finish() {
        self.finishDelegate?.coordinatorDidFinish(childCoordinator: self)
    }
    
    
}

extension HomeCoordinator {
    func detailArchiveBottomSheet(detailArchive: DetailArhive?, archiveId: Int) {
        let detailArchiveBottomSheetView  = UIStoryboard(name: "Home", bundle: nil).instantiateViewController(withIdentifier: "ArchiveDetailPopUpViewController") as! ArchiveDetailPopUpViewController
        detailArchiveBottomSheetView.coordinator = self
        detailArchiveBottomSheetView.archiveId = archiveId
        detailArchiveBottomSheetView.detailArchive = detailArchive
        detailArchiveBottomSheetView.modalPresentationStyle = .overFullScreen
        detailArchiveBottomSheetView.modalTransitionStyle = .crossDissolve
        self.navigationController.present(detailArchiveBottomSheetView, animated: false)
    }
    
    func invitationBottomSheet(archiveId: Int, copyCode: String, detailArchive: DetailArhive) {
        let invitationBottomSheetView = UIStoryboard(name: "Home", bundle: nil).instantiateViewController(withIdentifier: "InvitationBottomSheetViewController") as! InvitationBottomSheetViewController
        invitationBottomSheetView.archiveId = archiveId
        invitationBottomSheetView.detailArchive = detailArchive
        invitationBottomSheetView.coordinator = self
        invitationBottomSheetView.archiveCode = copyCode
        invitationBottomSheetView.modalPresentationStyle = .overFullScreen
        invitationBottomSheetView.modalTransitionStyle = .crossDissolve
        self.navigationController.present(invitationBottomSheetView, animated: false)
    }
}

extension HomeCoordinator {
    func addCategory(archiveId: Int, category: [PlaceCategory]) {
        let homeCategoryPopUpView = UIStoryboard(name: "Home", bundle: nil).instantiateViewController(withIdentifier: "HomeCategoryPopUpViewController") as! HomeCategoryPopUpViewController
        homeCategoryPopUpView.usecase = HomeUsecase(repository: HomeRepository(networkService: URLSessionNetworkService()))
        homeCategoryPopUpView.coordinator = self
        homeCategoryPopUpView.delegate = detailArchiveViewController
        homeCategoryPopUpView.archiveId = archiveId
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
    
    func participants(detailArchive: DetailArhive?) {
        let particiPopUpView = UIStoryboard(name: "Home", bundle: nil).instantiateViewController(withIdentifier: "ParticiPopUpViewController") as! ParticiPopUpViewController
        particiPopUpView.coordinator = self
        particiPopUpView.detailArchive = detailArchive
        particiPopUpView.modalPresentationStyle = .overFullScreen
        particiPopUpView.modalTransitionStyle = .crossDissolve
        self.navigationController.present(particiPopUpView, animated: false)
    }
    
    func detailPlace(archiveId: Int, detailInfo: DetailPlaceInfo?, placeInfo: PlaceInfo, category: PlaceCategory, categoryInfo: [PlaceCategory]) {
        let detailPlacePopUpView = UIStoryboard(name: "Home", bundle: nil).instantiateViewController(withIdentifier: "DetailPlacePopUpViewController") as! DetailPlacePopUpViewController
        detailPlacePopUpView.archiveId = archiveId
        detailPlacePopUpView.delegate = detailArchiveViewController
        detailPlacePopUpView.coordinator = self
        detailPlacePopUpView.detailPlaceInfo = detailInfo
        detailPlacePopUpView.placeInfo = placeInfo
        detailPlacePopUpView.category = category
        detailPlacePopUpView.categories = categoryInfo
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

extension HomeCoordinator {
    func addArchive() {
        let addArchiveViewcontroller = UIStoryboard(name: "Archive", bundle: nil).instantiateViewController(withIdentifier: "AddArchiveViewController") as! AddArchiveViewController
        addArchiveViewcontroller.viewModel = AddArchiveViewModel(usecase: ArchiveUsecase(repository: ArchiveRepository(networkService: URLSessionNetworkService())), coordinator: self)
        navigationController.pushViewController(addArchiveViewcontroller, animated: true)
    }
    
    func editArchive(archiveId: Int, detailArchive: DetailArhive?) {
        let editArchiveViewController = UIStoryboard(name: "Archive", bundle: nil).instantiateViewController(withIdentifier: "EditArchiveViewController") as! EditArchiveViewController
        editArchiveViewController.viewModel = EditArchiveViewModel(usecase: ArchiveUsecase(repository: ArchiveRepository(networkService: URLSessionNetworkService())), coordinator: self)
        editArchiveViewController.viewModel?.archiveId = archiveId
        if let detailArchive = detailArchive {
            editArchiveViewController.viewModel?.detailArchive = detailArchive
        }
        navigationController.pushViewController(editArchiveViewController, animated: true)
    }
    
    func addLocation() {
        let addLocationViewController = UIStoryboard(name: "Archive", bundle: nil).instantiateViewController(withIdentifier: "AddLocationViewController") as! AddLocationViewController
        navigationController.pushViewController(addLocationViewController, animated: true)
    }
    
    func inputCodeArchive() {
        let inputArchiveCodeViewController = UIStoryboard(name: "Archive", bundle: nil).instantiateViewController(withIdentifier: "InputArchiveCodeViewController") as! InputArchiveCodeViewController
        inputArchiveCodeViewController.viewModel = InputArchiveCodeViewModel(usecase: ArchiveUsecase(repository: ArchiveRepository(networkService: URLSessionNetworkService())), coordinator: self)
        navigationController.pushViewController(inputArchiveCodeViewController, animated: true)
    }
    
    func popToNavigaionController() {
        navigationController.popViewController(animated: true)
    }
    
    func popToRootViewController() {
        navigationController.popToRootViewController(animated: true)
    }
    
    func alarm() {
        let homeAlarmViewController = UIStoryboard(name: "Home", bundle: nil).instantiateViewController(withIdentifier: "HomeAlarmViewController") as! HomeAlarmViewController
        homeAlarmViewController.viewModel = HomeAlarmViewModel(coordinator: self, usecase: HomeUsecase(repository: HomeRepository(networkService: URLSessionNetworkService())))
        self.navigationController.pushViewController(homeAlarmViewController, animated: true)
    }
    
    func dissmissAndPopToRootViewController() {
        self.popToViewController(with: nil, width: nil, height: nil)
        self.popToRootViewController()
    }
    
}
