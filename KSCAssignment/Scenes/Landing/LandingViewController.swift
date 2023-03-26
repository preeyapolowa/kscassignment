//
//  LandingViewController.swift
//  KSCAssignment
//
//  Created by Preeyapol Owatsuwan on 24/3/2566 BE.
//

import Foundation
import UIKit

protocol LandingViewControllerDisplayLogic: AnyObject {
    func displayCurrentLatLonWeather(viewModel: LandingModels.CurrentLatLonWeather.ViewModel)
    func displayCurrentLatLon(viewModel: LandingModels.CurrentLatLon.ViewModel)
    func displayConvertTempurature(viewModel: LandingModels.ConvertTempurature.ViewModel)
}

class LandingViewController: UIViewController {
    var interactor: LandingInteractorBusinessLogic!
    var router: LandingRouterRoutingLogic!
    
    @IBOutlet private weak var searchBar: UISearchBar!
    
    @IBOutlet private weak var weatherView: UIView!
    @IBOutlet private weak var weatherImage: UIImageView!
    
    @IBOutlet private weak var temperatureView: UIView!
    @IBOutlet private weak var temperatureLabel: UILabel!
    
    @IBOutlet private weak var humidityView: UIView!
    @IBOutlet private weak var humidityLabel: UILabel!

    // MARK: Configure ViewController
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        configureViewController()
    }
    
    private func configureViewController() {
        let interactor = LandingInteractor()
        let presenter = LandingPresenter()
        let router = LandingRouter()
        
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
        inquiryCurrentLatLonWeather(defaultCityName: "Bangkok")
    }
    
    // MARK: Configure Views
    
    private func configureViews() {
        configureNavigationBar()
        configureContent()
    }
    
    private func configureNavigationBar() {
        let image = UIImage(named: "weather-icon")?.withRenderingMode(.alwaysOriginal)
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: image,
            style: .plain,
            target: self,
            action: #selector(didTapWeatherIcon)
        )
    }
    
    private func configureContent() {
        searchBar.delegate = self
        
        weatherView.setRadiusCorners(radius: weatherImage.frame.height / 2)
        temperatureView.setRadiusCorners(radius: 24)
        humidityView.setRadiusCorners(radius: 24)
    }
    
    // MARK: Event Handler
    
    private func inquiryCurrentLatLonWeather(defaultCityName: String? = nil) {
        if let defaultCityName = defaultCityName {
            showLoading()
            interactor.inquiryCurrentLatLonWeather(request: .init(cityName: defaultCityName))
        } else if let text = searchBar.text, !text.isEmpty {
            showLoading()
            interactor.inquiryCurrentLatLonWeather(request: .init(cityName: text))
        } else {
            showPleaseInputCityNamePopup()
        }
    }
    
    private func inquiryCurrentLatLon() {
        if let text = searchBar.text, !text.isEmpty {
            showLoading()
            interactor.inquiryCurrentLatLon(request: .init(cityName: text))
        } else {
            showPleaseInputCityNamePopup()
        }
    }
    
    private func convertTempurature() {
        interactor.convertTempurature(request: .init())
    }
    
    // MARK: IBAction objc
    
    @IBAction private func didTapConvertTempButton() {
        convertTempurature()
    }
    
    @objc private func didTapWeatherIcon() {
        inquiryCurrentLatLon()
    }
}

// MARK: Common Function
extension LandingViewController {
    private func showPleaseInputCityNamePopup() {
        showErrorPopup(
            title: "Error",
            description: "Please input city name"
        )
    }
}

extension LandingViewController: LandingViewControllerDisplayLogic {
    func displayCurrentLatLonWeather(viewModel: LandingModels.CurrentLatLonWeather.ViewModel) {
        hideLoading()
        
        switch viewModel.dataSource {
        case .success(let weather):
            if let url = weather.currentWeatherURL {
                weatherImage.downloadImage(from: url)
            } else {
                weatherImage.image = UIImage(named: weather.defaultWeatherImagePath)
            }
            temperatureLabel.text = weather.tempCelcius
            humidityLabel.text = weather.humidity
        case .failure(let error):
            showErrorPopup(
                title: error.title,
                description: error.description
            )
        }
    }
    
    func displayCurrentLatLon(viewModel: LandingModels.CurrentLatLon.ViewModel) {
        hideLoading()
        
        switch viewModel.dataSource {
        case .success(let latlon):
            router.navigateToForeCast(
                lat: latlon.lat,
                lon: latlon.lon
            )
        case .failure(let error):
            showErrorPopup(
                title: error.title,
                description: error.description
            )
        }
    }
    
    func displayConvertTempurature(viewModel: LandingModels.ConvertTempurature.ViewModel) {
        temperatureLabel.text = viewModel.temperature
    }
}

extension LandingViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        inquiryCurrentLatLonWeather()
    }
}
