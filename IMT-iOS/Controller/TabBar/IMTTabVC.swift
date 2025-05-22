//
//  IMTTabVC.swift
//  IMT-iOS
//
//  Created by dev on 09/05/2023.
//

import UIKit

class IMTTabVC: BaseViewController {
    
    @IBOutlet weak var vHeader: UIView!
    @IBOutlet weak var vContent: UIView!
    @IBOutlet weak var btnBack: UIButton!
    @IBOutlet weak var btnVote: IMTButton!
    @IBOutlet weak var btnVoteQR: IMTButton!
    @IBOutlet weak var imvLogo: UIImageView!
    @IBOutlet weak var svParent: UIScrollView!
    
    
    @IBOutlet weak var cstWidthBack: NSLayoutConstraint!
    
    private var viewModel: IMTTabViewModelProtocol!
    private var contentVC: IMTContentActionProtocol!
    
    private var isDragging: Bool = false
    private var oldX: CGFloat! = 0
    private var oldY: CGFloat! = 0
    
    private var lastHidden: Bool = false
    private var swiping: Bool = false
    
    init(child childVC: IMTContentActionProtocol) {
        super.init(nibName: nil, bundle: nil)
        self.contentVC = childVC
        
        self.contentVC.onEnableParentScroll = { [weak self] enable in
//            self?.svParent.isScrollEnabled = enable
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupData()
        setupEvent()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if(!isFirstLoad) {
            contentVC.viewContentWillAppear(animated)
        } else {
            super.viewWillAppear(animated)
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    
    override func checkVersionBecomeForeground() -> Bool {
        return false
    }
    
    //MARK: Action
    @IBAction func actionBack(_ sender: Any) {
        self.contentVC.back()
    }
    
    @IBAction func actionVote(_ sender: Any) {
        viewModel.transitionVote(self)
    }
    
    @IBAction func actionVoteQR(_ sender: Any) {
        viewModel.createVotingQR(self)
    }
    
    static func getHeightHeader() -> CGFloat {
        var topPadding: CGFloat = 0
        
        if #available(iOS 11.0, *) {
            let window = UIApplication.shared.keyWindow
            topPadding = window?.safeAreaInsets.top ?? 0
        }
        
        let topSpace = 11.0 //distance button votting and safeArea
        let bottomSpace = 18.0
        let heightButton = Utils.scaleWithHeight(34.0)
        
        return topPadding + topSpace + bottomSpace + heightButton
    }
    
    //MARK: Public
    public func getContentVC() -> IMTContentActionProtocol {
        return self.contentVC
    }
    
    public func availableBack() -> Bool {
        return !self.btnBack.isHidden
    }
}

//MARK: Private
extension IMTTabVC {
    private func setupUI() {
        configHeader()
        
        contentVC.onHiddenBack = { [weak self] hidden in
            self?.btnBack.setImage(UIImage(named: "ic_arrowleft"), for: .normal)
            self?.btnVote.isHidden = true
            self?.btnVoteQR.isHidden = true
            self?.lastHidden = hidden
            
            if(hidden) {
                self?.startAnimateBack()
            } else {
                self?.stopAnimateBack()
            }
        }
        
        contentVC.onPrepareAnimateBack = { [weak self] in
            self?.stopAnimateBack()
        }
        
        contentVC.onRunAnimateVote = { [weak self] in
            //            self?.btnVote.rumShineAnimation()
        }
        
        contentVC.onStopAnimateVote = { [weak self] in
            self?.btnVote.stopShineAnimation()
        }
        
        contentVC.onWillResignActive = { [weak self] in
            guard let swiping = self?.swiping else { return }
            if(swiping) {
                Utils.postObserver(.killScroll, object: true)
                self?.contentVC.onSwipe(x: 0, alpha: 1, finish: false)
                UIApplication.shared.windows.first?.isUserInteractionEnabled = true
                self?.swiping = false
            }
        }
    }
    
    private func setupData() {
        viewModel = IMTTabViewModel(child: contentVC, parent: self)
        
        viewModel.onTransactionVote = { [weak self] path in
            self?.transitionFromSafari(path)
        }
    }
    
    private func setupEvent() {
        configEventDrag()
    }
    
    private func configEventDrag() {
        let vContent = contentVC.controller().view!
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(drag))
        panGesture.delegate = self
        vContent.isUserInteractionEnabled = true
        vContent.addGestureRecognizer(panGesture)
    }
    
    private func configHeader() {
        self.vHeader.backgroundColor = .main
    }
    
    private func startAnimateBack() {
        let xBack = self.btnBack.frame.origin.x
        let wBack = self.btnBack.bounds.width - 16
        let x = xBack + wBack
        
        self.btnBack.setImage(nil, for: .normal)
        DispatchQueue.main.async { [weak self] in
            UIView.animate(withDuration: Constants.System.durationBackAnimate) { [weak self] in
                guard let hidden = self?.lastHidden else { return }
                
                if(hidden) {
                    self?.btnBack.isHidden = true
                    self?.imvLogo.transform = CGAffineTransform(translationX: -x, y: 0)
                } else {
                    self?.stopAnimateBack()
                }
            }
        }
    }
    
    private func stopAnimateBack() {
        self.btnBack.isHidden = false
        self.imvLogo.transform = CGAffineTransform(translationX: 0, y: 0)
    }
}

//MARK: Objc
extension IMTTabVC {
    @objc private func drag(_ sender:UIPanGestureRecognizer) {
        /*--------------------------------------------------*/
        let viewDrag = contentVC.controller().view!
        let translation = sender.translation(in: viewDrag)
        let locationX = sender.location(in: viewDrag).x
        
        caculate()
        /*--------------------------------------------------*/
        
        func caculate() {
            switch sender.state {
            case .began:
                excuteBegan()
                break
            case .ended:
//                executeEndV2()
                executeEnd()
                break
            default:
                executeDraging()
                break
            }
        }
        
        func excuteBegan() {
            oldX = translation.x
            oldY = translation.y
            
            if viewDrag.bounds.contains(translation) && locationX <= Constants.System.touchXAllowWhenSwipe {
                isDragging = true
                Utils.postObserver(.killScroll, object: false)
                UIApplication.shared.windows.first?.isUserInteractionEnabled = false
                swiping = true
            }
        }
        
        //Discussion: Apply when App dont use animate. Use with executeDraging
        func executeEnd() {
            if isDragging == true {
                let xViewDrag = viewDrag.frame.origin.x
                let xLocation = ((viewDrag.frame.width) + xViewDrag + (self.oldX)!) * (1.0)
                let maxLocation = viewDrag.frame.width * contentVC.getSwipingRatio()
                let xRatio = 0.0
                let xMax = UIScreen.main.bounds.size.width
                
                UIView.animate(withDuration: 0.35) { [weak self] in
                    if(translation.x > maxLocation) {
                        self?.contentVC.onSwipe(x: xLocation, alpha: 0.0, finish: false)
                    } else {
                        self?.contentVC.onSwipe(x: 0.0, alpha: 1, finish: false)
                    }
                } completion: { [weak self] finsih in
                    if(finsih) {
                        Utils.postObserver(.killScroll, object: true)
                        if(translation.x > maxLocation) {
                            self?.contentVC.onSwipe(x: xMax, alpha: 1, finish: true)
                            self?.isDragging = false
                        } else {
                            self?.contentVC.onSwipe(x: 0.0, alpha: xRatio, finish: false)
                        }
                        
                        UIApplication.shared.windows.first?.isUserInteractionEnabled = true
                        self?.swiping = false
                    }
                }
            }
            
            self.oldY = translation.y
        }
        
        //Discussion: Apply when App dont use animate
        func executeEndV2() {
            if isDragging == true {
                let xLocation = translation.x - oldX
                let distanceY = abs(translation.y - oldY)
                let allowY = distanceY <= Constants.System.spaceYAllowWhenSwipe
                let maxLocation = viewDrag.frame.width * Constants.System.swipeRatio
                
                if(xLocation > maxLocation && allowY) {
                    let xRatio: CGFloat = 1 - (xLocation / viewDrag.frame.width)
                    contentVC.onSwipe(x: xLocation, alpha: xRatio, finish: true)
                } else {
                    isDragging = false
                    self.oldY = translation.y
                }
            }
            
            self.oldY = translation.y
            isDragging = false
        }
        
        //Discussion: Apply when App dont use animate. Use func executeEnd
        func executeDraging() {
            guard isDragging && swiping else { return }
            let xLocation = translation.x - oldX
            let distanceY = abs(translation.y - oldY)
            let allowY = distanceY <= Constants.System.spaceYAllowWhenSwipe
            
            if(xLocation > 0 && allowY) {
                let xRatio: CGFloat = 1 - (xLocation / viewDrag.frame.width)
                if(applicationState == .active) {
                    contentVC.onSwipe(x: xLocation, alpha: xRatio, finish: false)
                }
            } else {
//                isDragging = false
                self.oldY = translation.y
            }
        }
    }
}

extension IMTTabVC: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        if otherGestureRecognizer.isMember(of: UIScrollView.self) {
            return false
        }
        
        return true
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        let location = touch.location(in: self.view)
        let beganX = location.x
        let validX = UIScreen.main.bounds.size.width * Constants.System.ratioIsAllowedToDragWhenTouchedForTheFirstTime
        let allowX = beganX < validX
        
        return allowX
    }
}
