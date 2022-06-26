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
    
    init(_ navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.navigationController.setNavigationBarHidden(false, animated: true)
        self.homeViewController = UIStoryboard(name: "Home", bundle: nil).instantiateViewController(withIdentifier: "HomeViewController") as! HomeViewController
    }
    
    func start() {
        homeViewController.viewModel = HomeViewModel(coordinator: self, usecase: HomeUsecase(repository: HomeRepository(networkService: URLSessionNetworkService())))
        self.navigationController.pushViewController(self.homeViewController, animated: true)
    }
    
    func archiveFlow() {
        let archiveCoordinator = ArchiveCoordinator(self.navigationController)
        self.childCoordinators.append(archiveCoordinator)
        archiveCoordinator.finishDelegate = self
        archiveCoordinator.addArchive(isEditing: false)
    }
    
    func detailArchive(selectedArchive: CardInfo) {
        let detailArchiveViewController = UIStoryboard(name: "Home", bundle: nil).instantiateViewController(withIdentifier: "DetailArchiveViewController") as! DetailArchiveViewController
        detailArchiveViewController.viewModel?.setArchive(archive: selectedArchive)
        detailArchiveViewController.viewModel = DetailArchiveViewModel(coordinator: self, usecase: HomeUsecase(repository: HomeRepository(networkService: URLSessionNetworkService())))
        
        //데이터 전달
        detailArchiveViewController.viewModel?.detailArchive = selectedArchive
        self.navigationController.pushViewController(detailArchiveViewController, animated: true)
    }
    
    func deleteCategory() {
        let categoryDeletePopUpView = UIStoryboard(name: "Home", bundle: nil).instantiateViewController(withIdentifier: "CategoryDeletePopUpViewController") as! CategoryDeletePopUpViewController
        categoryDeletePopUpView.coordinator = self
        categoryDeletePopUpView.usecase = HomeUsecase(repository: HomeRepository(networkService: URLSessionNetworkService()))
        categoryDeletePopUpView.modalPresentationStyle = .overFullScreen
        categoryDeletePopUpView.modalTransitionStyle = .crossDissolve
        self.navigationController.present(categoryDeletePopUpView, animated: false)
    }
    
    func arhiveDelete() {
        let deleteArchivePopUpView = UIStoryboard(name: "Home", bundle: nil).instantiateViewController(withIdentifier: "DeleteArhivePopUpViewController") as! DeleteArhiveViewPopUpController
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
    
    func editArchive() {
        let archiveCoordinator = ArchiveCoordinator(self.navigationController)
        self.childCoordinators.append(archiveCoordinator)
        archiveCoordinator.finishDelegate = self
        archiveCoordinator.addArchive(isEditing: true)
    }
    
    func popToRootViewController(with toastMessage: String?) {
        self.navigationController.dismiss(animated: true)
        if let toastMessage = toastMessage {
            self.navigationController.topViewController?.showToast(message: toastMessage, width: 216)
        }
    }
    
    func finish() {
        self.finishDelegate?.coordinatorDidFinish(childCoordinator: self)
    }
    
    
}

extension HomeCoordinator {
    func detailArchiveBottomSheet() {
        let detailArchiveBottomSheetView  = UIStoryboard(name: "Home", bundle: nil).instantiateViewController(withIdentifier: "ArchiveDetailPopUpViewController") as! ArchiveDetailPopUpViewController
        detailArchiveBottomSheetView.coordinator = self
        detailArchiveBottomSheetView.modalPresentationStyle = .overFullScreen
        detailArchiveBottomSheetView.modalTransitionStyle = .crossDissolve
        self.navigationController.present(detailArchiveBottomSheetView, animated: false)
    }
    
    func invitationBottomSheet() {
        let invitationBottomSheetView = UIStoryboard(name: "Home", bundle: nil).instantiateViewController(withIdentifier: "InvitationBottomSheetViewController") as! InvitationBottomSheetViewController
        invitationBottomSheetView.coordinator = self
        invitationBottomSheetView.modalPresentationStyle = .overFullScreen
        invitationBottomSheetView.modalTransitionStyle = .crossDissolve
        self.navigationController.present(invitationBottomSheetView, animated: false)
    }
}

extension HomeCoordinator {
    func category() {
        let homeCategoryPopUpView = UIStoryboard(name: "Home", bundle: nil).instantiateViewController(withIdentifier: "HomeCategoryPopUpViewController") as! HomeCategoryPopUpViewController
        homeCategoryPopUpView.coordinator = self
        homeCategoryPopUpView.modalPresentationStyle = .overFullScreen
        homeCategoryPopUpView.modalTransitionStyle = .crossDissolve
        self.navigationController.present(homeCategoryPopUpView, animated: false)
    }
    
    func loadMemo() {
        let memoPopUpView = UIStoryboard(name: "Home", bundle: nil).instantiateViewController(withIdentifier: "MemoPopUpViewController") as! MemoPopUpViewController
        memoPopUpView.coordinator = self
        memoPopUpView.modalPresentationStyle = .overFullScreen
        memoPopUpView.modalTransitionStyle = .crossDissolve
        self.navigationController.present(memoPopUpView, animated: false)
    }
    
    func participants() {
        let particiPopUpView = UIStoryboard(name: "Home", bundle: nil).instantiateViewController(withIdentifier: "ParticiPopUpViewController") as! ParticiPopUpViewController
        particiPopUpView.coordinator = self
        particiPopUpView.modalPresentationStyle = .overFullScreen
        particiPopUpView.modalTransitionStyle = .crossDissolve
        self.navigationController.present(particiPopUpView, animated: false)
    }
    
    func detailPlace(detailInfo: PlaceInfo, category: Category) {
        let detailPlacePopUpView = UIStoryboard(name: "Home", bundle: nil).instantiateViewController(withIdentifier: "DetailPlacePopUpViewController") as! DetailPlacePopUpViewController
        detailPlacePopUpView.coordinator = self
        detailPlacePopUpView.detailInfo = detailInfo
        detailPlacePopUpView.category = category
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
