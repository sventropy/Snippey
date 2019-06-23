//
//  TutorialPageViewController.swift
//  Snippey
//
//  Created by Hennessen, Sven on 23.06.19.
//  Copyright © 2019 Hennessen, Sven. All rights reserved.
//

import UIKit

class TutorialPageViewController: UIPageViewController, UIPageViewControllerDelegate, UIPageViewControllerDataSource {

    // Welcome to Snippey!\n\nSnippey allows you to store text snippets you frequently use and insert them in any app using the provided keyboard.\n//Snippets can be Text, Emojis or even a combination of both 😃😉.\n
    // Add new snippets in the app.
    // Delete the ones you don't longer like by swiping left.
    // Reorder snippets by dragging them.\n\nAnd now, enjoy using Snippey!"

    let tutorialSteps = ["Welcome", "Add", "Delete", "Reorder", "Finish"]
    var tutorialViewControllers = [UIViewController]()

    override func viewDidLoad() {
        super.viewDidLoad()

        dataSource = self
        delegate = self

        for step in tutorialSteps {
            tutorialViewControllers.append(TutorialViewController(text: step))
        }

        setViewControllers([tutorialViewControllers.first!], direction: .forward, animated: true, completion: nil)
    }

    override func viewDidLayoutSubviews() {
        //corrects scrollview frame to allow for full-screen view controller pages
        // from https://stackoverflow.com/questions/28077869/uipageviewcontroller-displaying-a-black-bar
        for subView in self.view.subviews {
            if subView is UIScrollView {
                subView.frame = self.view.bounds
            }
        }
        super.viewDidLayoutSubviews()
    }

    // MARK: - UIPageViewController protocol functions
    func pageViewController(_: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        if let tutorialViewController = viewController as? TutorialViewController {
            if let index = tutorialSteps.firstIndex(of: tutorialViewController.text) {
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
            if let index = tutorialSteps.firstIndex(of: tutorialViewController.text) {
                // There is none after the last
                if index == (tutorialViewControllers.count - 1) { return nil }
                return tutorialViewControllers[index + 1]
            }
        }
        return nil
    }

    func presentationCount(for _: UIPageViewController) -> Int {
        return tutorialSteps.count
    }

    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        guard let firstViewController = viewControllers?.first,
            let firstViewControllerIndex = tutorialViewControllers.firstIndex(of: firstViewController) else {
                return 0
            }

        return firstViewControllerIndex
    }
}

class TutorialViewController: UIViewController {
    var text = ""

    init(text: String) {
        super.init(nibName: nil, bundle: nil)
        self.text = text
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let imageView = UIImageView(image: UIImage(named: "8bit_cut_100"))
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
        
        let label = UILabel()
        label.text = text
        label.sizeToFit()
        view.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        label.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: Constants.margin).isActive = true
        view.backgroundColor = Constants.lightColor
    }
}
