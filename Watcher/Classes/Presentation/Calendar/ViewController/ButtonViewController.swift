//
//  ButtonViewController.swift
//  Watcher
//
//  Created by Петр Первухин on 06/03/2019.
//  Copyright © 2019 pperv. All rights reserved.
//

import apiClient
import UIKit

protocol ButtonViewControllerDelegate: class {
    func showAllert(errorMessage: String)
    func updateLoggedTime()
}

final class ButtonViewController: UIViewController {
    
    // MARK: - IBOutlet

    @IBOutlet weak var fillButton: UIButton!
    
    
    // MARK: - Private Properties

    private var requestIndex = 0
    private let service = ServiceLayer.shared.logTimeService
    private var spinerLayer: SpinerLayer!
    private var calendarSelectionType: CalendarSelectionType

    
    // MARK: - Public Properties
    
    public var requestArray = [String]()
    public weak var delegate: ButtonViewControllerDelegate?

    
    // MARK: - Initialization
    
    init(calendarSelectionType: CalendarSelectionType) {
        self.calendarSelectionType = calendarSelectionType
        super.init(nibName: nil, bundle: nil)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        spinerLayer = SpinerLayer(frame: fillButton.frame)
        fillButton.layer.addSublayer(spinerLayer)
        spinerLayer.isHidden = true
        spinerLayer.spinnerColor = .white
        view.backgroundColor = ColorThemeManager.shared.current.mainBackgroundColor
        setupFillRangeButton()
    }
    
    
    private func setupFillRangeButton() {
        self.fillButton.isHidden = true
        fillButton.layer.cornerRadius = 10
        fillButton.clipsToBounds = true
    }
    
    
    // MARK: - Public Methods
    
    public func showFillButton() {
        self.fillButton.center = self.view.center
        UIView.transition(with: self.fillButton,
                          duration: 0.33,
                          options: [.curveEaseOut, .transitionFlipFromTop], animations: { 
                            self.fillButton.isHidden = false
                            self.view.addSubview(self.fillButton)
        }, completion: nil)
    }
    
    
    // MARK: - IBAction

    @IBAction func fillButtonAction(_ sender: UIButton) {
        startButtonAnimation()
        logTimeRequest()
    }
    
    
    // MARK: - LogTimeRequest
    
    private func logTimeRequest() {
        let requestGroup = DispatchGroup()

        for index in 0..<requestArray.count {
            requestGroup.enter()
            let requestDate = requestArray[index]
            
            let logTimeRequest = calendarSelectionType == .vacation ? 
                createVacationLogTime(date: requestDate) : createIllnessLogTime(date: requestDate)
            
            self.service.logTime(logTimeRequest) {[weak self] (loggedTimeData, errorMessage) in
                guard let self = self else { return }
                requestGroup.leave()
                guard loggedTimeData != nil else { 
                    self.stopButtonAnimation()
                    self.delegate?.showAllert(errorMessage: errorMessage ?? "")
                    return
                }
            }
        }
        
        requestGroup.notify(queue: DispatchQueue.main) { 
            self.stopButtonAnimation()
            self.delegate?.updateLoggedTime()
        }
        
    }
    
    
    private func createVacationLogTime(date: String) -> LogTimeRequest {
        return LogTimeRequest(projectId: 18,
                              minutesSpent: 480, 
                              date: date, 
                              description: "Отпуск")
    }
    
    
    private func createIllnessLogTime(date: String) -> LogTimeRequest {
        return LogTimeRequest(projectId: 19,
                              minutesSpent: 480, 
                              date: date, 
                              description: "Болезнь")
    }
    
    
    // MARK: - Button Animation Methods

    private func startButtonAnimation() {
        UIApplication.shared.beginIgnoringInteractionEvents()
        fillButton.titleLabel?.text = ""
        fillButton.isUserInteractionEnabled = false
        
        let animaton = CABasicAnimation(keyPath: "bounds.size.width")
        animaton.fromValue = fillButton.frame.width
        animaton.toValue = fillButton.frame.height
        animaton.duration = 0.1
        animaton.fillMode = CAMediaTimingFillMode.forwards
        animaton.isRemovedOnCompletion = false
        
        fillButton.layer.add(animaton, forKey: animaton.keyPath)
        spinerLayer.isHidden = false
        spinerLayer.animation()
    }
    
    
    private func stopButtonAnimation() {  
        UIApplication.shared.endIgnoringInteractionEvents()
        spinerLayer.stopAnimation()
        
        fillButton.setTitle("Заполнить", for: .normal)
        fillButton.isUserInteractionEnabled = true
        
        let animaton = CABasicAnimation(keyPath: "bounds.size.width")
        animaton.fromValue = fillButton.frame.height
        animaton.toValue = fillButton.frame.width
        animaton.duration = 0.1
        animaton.fillMode = CAMediaTimingFillMode.forwards
        animaton.isRemovedOnCompletion = false
        
        fillButton.layer.add(animaton, forKey: animaton.keyPath)
        spinerLayer.isHidden = true
    }
    
}
