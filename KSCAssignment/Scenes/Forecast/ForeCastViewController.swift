//
//  ForeCastViewController.swift
//  KSCAssignment
//
//  Created by Preeyapol Owatsuwan on 25/3/2566 BE.
//

import Foundation
import UIKit

protocol ForeCastViewControllerDisplayLogic: AnyObject {
    func displayForeCast(viewModel: ForeCastModels.ForeCast.ViewModel)
}

class ForeCastViewController: UIViewController {
    var interactor: ForeCastInteractorBusinessLogic!
    var router: ForeCastRouterRoutingLogic!

    @IBOutlet private weak var tableView: UITableView!
    
    private var foreCast: [ForeCastModels.ForeCast.ForeCastViewModel] = []
    
    // MARK: Configure ViewController
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        configureViewController()
    }
    
    private func configureViewController() {
        let interactor = ForeCastInteractor()
        let presenter = ForeCastPresenter()
        let router = ForeCastRouter()
        
        self.interactor = interactor
        self.router = router
        interactor.presenter = presenter
        presenter.viewController = self
        router.viewController = self
    }
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureViews()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        inquiryForeCast()
    }
    
    // MARK: Configure Views
    
    private func configureViews() {
        configureTableView()
    }
    
    private func configureTableView() {
        let nib = UINib(nibName: "ForeCastTableViewCell", bundle: nil)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(nib, forCellReuseIdentifier: "ForeCastTableViewCell")
    }
    
    // MARK: Event Handler
    
    private func inquiryForeCast() {
        showLoading()
        interactor.inquiryForeCast(request: .init())
    }
    
    // MARK: IBAction objc
}

extension ForeCastViewController: ForeCastViewControllerDisplayLogic {
    func displayForeCast(viewModel: ForeCastModels.ForeCast.ViewModel) {
        hideLoading()
        
        switch viewModel.dataSource {
        case .success(let foreCast):
            self.foreCast = foreCast
            tableView.reloadData()
        case .failure(let error):
            showErrorPopup(
                title: error.title,
                description: error.description) { [weak self] _ in
                    guard let self = self else { return }
                    self.router.navigateBack()
                }
        }
    }
}

extension ForeCastViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return foreCast.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ForeCastTableViewCell", for: indexPath) as? ForeCastTableViewCell else {
            return UITableViewCell()
        }
        cell.selectionStyle = .none
        cell.updateCell(with: .init(model: foreCast[indexPath.row]))
        return cell
    }
}

extension ForeCastViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}
