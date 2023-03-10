//
//  ViewController.swift
//  codeChallenge_MarianPliatsko
//
//  Created by mac on 2022-12-10.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var errorLabel: UILabel!
    @IBOutlet private weak var progressView: UIActivityIndicatorView!
    
    private var tableController: TableViewController?
    
    var profileService: ProfileService = ProfileServiceImpl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "User Profile"
        navigationController?.navigationBar.prefersLargeTitles = true
        configUI()
        fetchProfile()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        if segue.identifier == "tableViewControllerSegue",
           let tableController = segue.destination as? TableViewController {
            self.tableController = tableController
            self.tableController?.delegate = self
        }
    }
    
    private func configUI() {
        progressView.startAnimating()
        containerView.isHidden = true
        errorLabel.isHidden = true
    }
    
    private func fetchProfile() {
        profileService.fetchMineProfile { [weak self] result in
            switch result {
            case .success(let profile):
                DispatchQueue.main.async {
                    self?.updateUI(profile: profile)
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self?.updateUI(error: error)
                }
            }
        }
    }
    
    private func updateUI(profile: Profile) {
        progressView.stopAnimating()
        containerView.isHidden = false
        errorLabel.isHidden = true
        
        tableController?.configProfile(profile)
    }
    
    private func updateUI(error: Error) {
        progressView.stopAnimating()
        containerView.isHidden = true
        errorLabel.isHidden = false
        errorLabel.text = error.localizedDescription
    }
}

extension ViewController: TableViewControllerDelegate {
    func tableViewController(_ tableViewController: TableViewController, didTapSaveProfile profile: User) {
        progressView.startAnimating()
        profileService.updateProfile(user: profile) { [weak self] result in
            switch result {
            case .success:
                DispatchQueue.main.async {
                    self?.progressView.stopAnimating()
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self?.updateUI(error: error)
                }
            }
        }
    }
    
    func tableViewController(_ tableViewController: TableViewController, didTapSavePassword password: String) {
        progressView.startAnimating()
        profileService.updateProfile(password: password) { [weak self] result in
            switch result {
            case .success(let response):
                DispatchQueue.main.async {
                    self?.progressView.stopAnimating()
                    let alertViewController = UIAlertController(title: "Success!", message: response.message, preferredStyle: .alert)
                    let okAction = UIAlertAction(title: "Ok", style: .default)
                    alertViewController.addAction(okAction)
                    self?.present(alertViewController, animated: true)
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self?.updateUI(error: error)
                }
            }
        }
    }
}
