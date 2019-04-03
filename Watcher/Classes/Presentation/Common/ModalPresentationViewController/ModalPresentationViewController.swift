//
//  PresentationViewController.swift
//  Watcher
//
//  Created by Петр Первухин on 04/03/2019.
//  Copyright © 2019 pperv. All rights reserved.
//

import UIKit

class ModalPresentationViewController: UIViewController {
    
    // MARK: - Private Properties
    
    private lazy var contentViewMinimumHeightLayoutConstraint: NSLayoutConstraint = {
        whiteBackgroundView.heightAnchor.constraint(greaterThanOrEqualToConstant: minHeight)
    }()
    
    private lazy var contentViewMaximumHeightLayoutConstraint: NSLayoutConstraint = {
        whiteBackgroundView.heightAnchor.constraint(
            lessThanOrEqualToConstant: self.view.bounds.height - 50)
    }()
    
    private lazy var scrollViewHeightLayoutConstraint: NSLayoutConstraint = {
        scrollView.heightAnchor.constraint(equalToConstant: 0)
    }()
    
    private let scrollView: UIScrollView = {
        let view = UIScrollView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var whiteBackgroundView: UIView = {
        let view = UIView()
        view.clipsToBounds = true
        view.backgroundColor = ColorThemeManager.shared.current.mainBackgroundColor
        view.layer.cornerRadius = 10
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        view.clipsToBounds = true 
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var viewWillDismissHandler: ViewWillDismiss?

    private var interactor: ModalInteractiveTransition?
    
    // MARK: - PreferredStatusBarStyle
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    
    // MARK: - Public Properties
    
    typealias ViewWillDismiss = () -> Void
    
    
    public let stackView: UIStackView = {
        let view = UIStackView()
        view.axis = .vertical
        view.alignment = .fill
        view.distribution = .fill
        view.spacing = 6
        view.isUserInteractionEnabled = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    
    //Минимальная высота
    public var minHeight: CGFloat = 200 {
        didSet {
            contentViewMinimumHeightLayoutConstraint.constant = minHeight
        }
    }
    
    
    // MARK: - Initialization
    
    public init(interactor: ModalInteractiveTransition, 
                viewWillDismissHandler: @escaping ViewWillDismiss) {
        self.viewWillDismissHandler = viewWillDismissHandler
        self.interactor = interactor
        super.init(nibName: nil, bundle: nil)
        setupView()
        setupContentView()
        setupScrollView()
        setupStackView()
    }
    
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    // MARK: - LifeCycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.setNeedsStatusBarAppearanceUpdate()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = ColorThemeManager.shared.current.mainBackgroundColor
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        updateScrollViewHeightConstraint()
    }
    
    
    override func viewDidDisappear(_ animated: Bool) {
        guard let viewWillDismissHandler = viewWillDismissHandler else { return }
        viewWillDismissHandler()
    }
    
    
    // MARK: - Setup Methods
    
    private func setupView() {
        self.view.backgroundColor = .clear        
        view.addGestureRecognizer(UIPanGestureRecognizer(target: self,
                                                         action: #selector(handleGesture)))
    }
    
    private func setupContentView() {        
        view.addSubview(whiteBackgroundView)
        let leadingAnchorConstraint = whiteBackgroundView.leadingAnchor.constraint(
            equalTo: view.leadingAnchor, constant: 0)
        leadingAnchorConstraint.priority = .defaultHigh
        let trailingAnchorConstraint = whiteBackgroundView.trailingAnchor.constraint(
            equalTo: view.trailingAnchor, constant: 0)
        trailingAnchorConstraint.priority = .defaultHigh
        NSLayoutConstraint.activate([
            leadingAnchorConstraint,
            trailingAnchorConstraint,
            whiteBackgroundView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
            whiteBackgroundView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            contentViewMaximumHeightLayoutConstraint,
            contentViewMinimumHeightLayoutConstraint
            ])
    }
    
    
    private func setupScrollView() {
        whiteBackgroundView.addSubview(scrollView)        
        scrollViewHeightLayoutConstraint.priority = UILayoutPriority.defaultLow
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: whiteBackgroundView.topAnchor, constant: 10),
            scrollView.leadingAnchor.constraint(equalTo: whiteBackgroundView.leadingAnchor, constant: 0),
            scrollView.trailingAnchor.constraint(equalTo: whiteBackgroundView.trailingAnchor, constant: 0),
            scrollView.bottomAnchor.constraint(equalTo: whiteBackgroundView.bottomAnchor, constant: 0),
            scrollViewHeightLayoutConstraint
            ])
    }
    
    
    private func setupStackView() {
        scrollView.addSubview(stackView) 
        stackView.backgroundColor = ColorThemeManager.shared.current.mainBackgroundColor
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 0),
            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 0),
            stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: 0),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: 0),
            stackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
            ])
    }
    
    
    // MARK: - Public Methods
    
    public func updateScrollViewHeightConstraint() {
        let size = stackView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
        scrollViewHeightLayoutConstraint.constant = size.height
        scrollViewHeightLayoutConstraint.isActive = scrollViewHeightLayoutConstraint.constant > 0.0
        
        whiteBackgroundView.setNeedsUpdateConstraints()
        whiteBackgroundView.layoutIfNeeded()
        
        view.setNeedsUpdateConstraints()
        
        UIView.animate(withDuration: 0.25, animations: {
            self.view.layoutIfNeeded()
        })
    }
    
    
    //Добавление view в stackView
    public func addArrangedSubview(view: UIView) {
        stackView.addArrangedSubview(view)
    }
    
    
    //Добавление view с определенной высотой
    public func addArrangedSubview(view: UIView, height: CGFloat) {
        view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([view.heightAnchor.constraint(equalToConstant: height)])
        stackView.addArrangedSubview(view)
    }
    
    
    // MARK: - Handle Gesture
    
    @objc func handleGesture(_ sender: UIPanGestureRecognizer) {
        
        let percentThreshold: CGFloat = 0.3        
        let translation = sender.translation(in: view)

        guard let interactor = interactor else { return }
        
        switch sender.state {
        case .began:
            interactor.hasStarted = true
            dismiss(animated: true, completion: nil)
        case .changed:
            let screenHeight = UIScreen.main.bounds.size.height - 50
            let dragAmount = screenHeight
            var percent: Float = Float(translation.y) / Float(dragAmount)
            
            percent = fmaxf(percent, 0.0)
            percent = fminf(percent, 1.0)
            
            interactor.shouldFinish = CGFloat(percent) > percentThreshold
            interactor.update(CGFloat(percent))
        case .cancelled:
            interactor.cancel()
        case .ended:
            interactor.hasStarted = false
            interactor.shouldFinish
                ? interactor.finish()
                : interactor.cancel()
        default:
            break
        }
    }    
    
}
