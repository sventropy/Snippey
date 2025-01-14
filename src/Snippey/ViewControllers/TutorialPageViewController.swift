//
//  TutorialPageViewController.swift
//  Snippey
//
//  Created by Hennessen, Sven on 23.06.19.
//  Copyright © 2019 Hennessen, Sven. All rights reserved.
//

import UIKit

/// View controller implementation managing the tutorial process accross all pages
class TutorialPageViewController: UIPageViewController {
    
    // MARK: - Properties

    var tutorialViewControllers = [UIViewController]()
    var dataAccess: DataAccessProtocol?
    
    // MARK: - UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()

        // Explicitly setup delegate & datasource relationship
        dataSource = self
        delegate = self
        
        guard dataAccess != nil else {
            assertionFailure("Data access instance required")
            return
        }

        // Fill list of view controllers with all instances to be presented
        for step in TutorialStep.allCases {
            tutorialViewControllers.append(TutorialViewController(step: step, pageViewController: self, dataAccess: dataAccess!))
        }

        // Set initial view controller for the tutorial
        setViewControllers([tutorialViewControllers.first!], direction: .forward, animated: true, completion: nil)

    }

    override func viewDidLayoutSubviews() {

        //corrects scrollview frame to allow for full-screen view controller pages
        // from https://stackoverflow.com/questions/28077869/uipageviewcontroller-displaying-a-black-bar
        for subView in self.view.subviews {
            if subView is UIScrollView {
                subView.frame = self.view.bounds
            }
            if let pageControl = subView as? UIPageControl {
                pageControl.pageIndicatorTintColor = Constants.darkColor
                pageControl.currentPageIndicatorTintColor = Constants.accentColor
            }
        }
        super.viewDidLayoutSubviews()
    }

    // MARK: - Actions

    func showNextWizardStep() {
        // Proceed to next view controller
        let currentViewController = tutorialViewControllers[presentationIndex(for: self)]
        if let nextViewController = pageViewController(self, viewControllerAfter: currentViewController) {
            setViewControllers([nextViewController], direction: .forward, animated: true, completion: nil)
        }
    }
}

/// UIPageViewController specific delegate implementation
extension TutorialPageViewController: UIPageViewControllerDelegate, UIPageViewControllerDataSource {
    
    func pageViewController(_: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        if let tutorialViewController = viewController as? TutorialViewController {
            if let index = TutorialStep.allCases.firstIndex(of: tutorialViewController.step) {
                // There is none before the first
                if index == 0 { return nil }
                return tutorialViewControllers[index-1]
            }
        }
        return nil
    }
    
    func pageViewController(_: UIPageViewController,
                            viewControllerAfter viewController: UIViewController) -> UIViewController? {
        if let tutorialViewController = viewController as? TutorialViewController {
            if let index = TutorialStep.allCases.firstIndex(of: tutorialViewController.step) {
                // There is none after the last
                if index == (tutorialViewControllers.count - 1) { return nil }
                return tutorialViewControllers[index + 1]
            }
        }
        return nil
    }
    
    func presentationCount(for _: UIPageViewController) -> Int {
        return TutorialStep.allCases.count
    }
    
    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        guard let firstViewController = viewControllers?.first,
            let firstViewControllerIndex = tutorialViewControllers.firstIndex(of: firstViewController) else {
                return 0
        }
        
        return firstViewControllerIndex
    }
}

/// Enumeration describing all steps to be completed in the tutorial
enum TutorialStep: CaseIterable {
    case welcome
    case add
    case delete
    case reorder
    case finish
}

/// View controller implementation depicting one page in the tutorial
class TutorialViewController: UIViewController {
    
    // MARK: - Properties

    var step: TutorialStep
    var tutorialPageViewController: TutorialPageViewController
    var dataAccess: DataAccessProtocol

    // MARK: - Initializers
    
    init(step: TutorialStep, pageViewController: TutorialPageViewController, dataAccess: DataAccessProtocol) {
        self.step = step
        self.tutorialPageViewController = pageViewController
        self.dataAccess = dataAccess
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Override default background color
        view.backgroundColor = Constants.lightColor

        let imageView = initializeImageView()
        let label = initializeLabel(imageView: imageView)
        initializeButton(label: label)
        
        // Override status bar behavior
        setNeedsStatusBarAppearanceUpdate()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    // MARK: - Actions

    @objc func nextButtonPressed() {
        
        if step == .finish {
            // Mark tutorial completed
            dataAccess.storeHasSeenTutorial(hasSeenTutorial: true)
            let viewController = ViewController()
            viewController.dataAccess = dataAccess
            UIWindow.animate(withDuration: 0.2) {
                UIApplication.shared.keyWindow?.rootViewController = UINavigationController(rootViewController: viewController)
            }
            tutorialPageViewController.dismiss(animated: true, completion: nil)
        } else {
            // Show next step in the tutorial
            tutorialPageViewController.showNextWizardStep()
        }
    }
    
    // MARK: - Private Functions
    
    fileprivate func initializeImageView() -> UIImageView {
        
        var imageName: String?
        
        // Determine icon for tutorial page based on step
        switch step {
        case .welcome:
            imageName = "appicon-167"
        case .add:
            imageName = "add"
        case .delete:
            imageName = "delete"
        case .reorder:
            imageName = "reorder"
        case .finish:
            imageName = "appicon-167"
        }
        let imageView = UIImageView(image: UIImage(named: imageName!))
        view.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -75).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 250).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 250).isActive = true
        imageView.layer.borderColor = Constants.darkColor.cgColor
        imageView.layer.borderWidth = 1
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 125
        
        return imageView
    }
    
    fileprivate func initializeLabel(imageView: UIImageView) -> UILabel {
        
        let label = UILabel()
        
        // Determine text for tutorial page based on step
        switch step {
        case .welcome:
            label.text = "tutorial-welcome".localized
        case .add:
            label.text = "tutorial-add".localized
        case .delete:
            label.text = "tutorial-delete".localized
        case .reorder:
            label.text = "tutorial-reorder".localized
        case .finish:
            label.text = "tutorial-finish".localized
        }
        label.lineBreakMode = .byWordWrapping
        label.numberOfLines = 0
        label.textAlignment = .center
        view.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        label.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: Constants.margin * 2).isActive = true
        label.widthAnchor.constraint(equalTo: imageView.widthAnchor, constant: Constants.margin * 2).isActive = true
        
        return label
    }
    
    fileprivate func initializeButton(label: UILabel) {
        let nextButton = UIButton()
        nextButton.setTitleColor(Constants.accentColor, for: .normal)
        nextButton.setTitleColor(Constants.lightColor, for: .selected)
        if step == .finish {
            nextButton.setTitle("tutorial-finish-button".localized, for: .normal)
        } else {
            nextButton.setTitle("tutorial-next-button".localized, for: .normal)
        }
        view.addSubview(nextButton)
        nextButton.translatesAutoresizingMaskIntoConstraints = false
        nextButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        nextButton.topAnchor.constraint(equalTo: label.bottomAnchor, constant: Constants.margin * 2).isActive = true
        nextButton.addTarget(self, action: #selector(nextButtonPressed), for: .touchUpInside)
    }
}
