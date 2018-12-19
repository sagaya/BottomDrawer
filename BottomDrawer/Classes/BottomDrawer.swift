//
//  BottomController.swift
//  BottomDrawer
//
//  Created by Sagaya Abdulhafeez on 19/12/2018.
//


import UIKit

open class BottomController: UIViewController,UIGestureRecognizerDelegate {
    
    open var sourceController: UIViewController?
    open var destinationController: BottomController?
    var containerViewTopConstraint:NSLayoutConstraint?
    open var startingHeight:CGFloat?
    var storedcontrollerView:UIView?
    public static var shared = BottomController()
    public var movable = true
    public var roundedCorner = true
    public var cornerRadius:CGFloat = 10
    var vu: UIView?
    @objc func openr(){
        guard  let controllerView = vu else {return}
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.9, animations: {
                self.containerViewTopConstraint?.constant = 50
                self.view.layoutIfNeeded()
                controllerView.layoutIfNeeded()
            })
        }
    }
    lazy var backgroundOverlay: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = UIColor.black.withAlphaComponent(0.45)
        v.alpha = 0
        return v
    }()
    internal var panGestureRecognizer: UIPanGestureRecognizer?
    lazy var topButton: UIImageView = {
        let image = UIImageView()
        image.image = UIImage(named: "Rectangle")
        image.contentMode = .scaleAspectFit
        return image
    }()
    override open func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.clear
        configure()
    }
    
    private func setupGestureRecognizers() {
        let panGestureRecognizer = UIPanGestureRecognizer(target: self,
                                                          action: #selector(panGestureDidMove(sender:)))
        panGestureRecognizer.cancelsTouchesInView = false
        panGestureRecognizer.delegate = self
        let controllerView = view.viewWithTag(64820)
        
        switch movable {
        case true:
            controllerView?.addGestureRecognizer(panGestureRecognizer)
        case false:
            break;
        default:
            break;
        }
        self.panGestureRecognizer = panGestureRecognizer
    }
    private func addGestureToView(){
        let gesture = UITapGestureRecognizer(target: self, action: #selector(dismissController))
        self.view.isUserInteractionEnabled = true
        self.view.addGestureRecognizer(gesture)
    }
    override open func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        view.addSubview(topButton)
        topButton.anchorTo(top: view.topAnchor, leading: nil, bottom: nil, trailing: nil, padding: .init(top: 5, left: 0, bottom: 0, right: 0), size: .init(width: 50, height: 13), centerX: view.centerXAnchor, centerY: nil)
    }
    
    @objc private func panGestureDidMove(sender: UIPanGestureRecognizer) {
        let translationPoint = sender.translation(in: view.superview)
        let velocity = sender.velocity(in: view.superview)
        let absValue = translationPoint.y
        _ = view.superview?.backgroundColor
        _ = abs((velocity.y) * 0.01)
        switch sender.state {
        case .began:
            self.didBeginMovemnet()
            break;
        case .changed:
            if velocity.y < -1000{
                //FULLY PRESNET
                self.fullPresentController()
                break;
            }
            if velocity.y > 2000{
                //FULLY DISMISS
                self.backgroundOverlay.alpha = 0
                self.dismissController()
                break;
            }
            topButton.image = UIImage(named: "down_arrow")
            self.didMoveController(value: absValue, velocity: velocity)
        case .ended:
            topButton.image = UIImage(named: "Rectangle")
            self.didEndMovemnt(value: absValue, velocity: velocity)
        default:
            return
        }
    }
    func fullPresentController() {
        let newConstant = 80
        UIView.animate(withDuration: 0.5) {
            self.containerViewTopConstraint?.constant = CGFloat(newConstant)
            self.view.layoutIfNeeded()
        }
    }
    
    @objc func dismissController() {
        UIView.animate(withDuration: 1.0, animations: {
            self.view.alpha = 0
            self.containerViewTopConstraint?.constant = self.view.frame.height
            self.view.layoutIfNeeded()
        }) { (_) in
            self.dismiss(animated: true, completion: nil)
        }
    }
    private func configure(){
        view.addSubview(backgroundOverlay)
        self.modalPresentationStyle = .overCurrentContext
        self.hidesBottomBarWhenPushed = true
        guard let controller = self.destinationController, let controllerView = controller.view else {return}
        #if swift(>=4.2)
        addChild(controller)
        #else
        addChildViewController(controller)
        #endif
        
        addGestureToView()
        self.view.addSubview(controllerView)
        controllerView.translatesAutoresizingMaskIntoConstraints = false
        if roundedCorner{
            controllerView.layer.cornerRadius = cornerRadius
            controllerView.layer.masksToBounds = true
            if #available(iOS 11.0, *) {
                controllerView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
            }
        }
        controllerView.layer.isOpaque = false
        controllerView.tag = 64820
        let currentConstant = startingHeight ?? 120
        containerViewTopConstraint = controllerView.topAnchor.constraint(equalTo: view.topAnchor, constant: view.frame.height - currentConstant)
        containerViewTopConstraint?.isActive = true
        #if swift(>=4.2)
        view.bringSubviewToFront(controllerView)
        #else
        view.bringSubview(toFront: controllerView)
        #endif
        
        NSLayoutConstraint.activate([
            backgroundOverlay.widthAnchor.constraint(equalTo: view.widthAnchor),
            backgroundOverlay.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            backgroundOverlay.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            backgroundOverlay.heightAnchor.constraint(equalTo: view.heightAnchor),
            
            controllerView.widthAnchor.constraint(equalTo: view.widthAnchor),
            controllerView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            controllerView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
            ])
        //Animate background color change
        setupGestureRecognizers()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            UIView.animate(withDuration: 0.5) {
                self.backgroundOverlay.alpha = 1
            }
        }
    }
    func didEndMovemnt(value: CGFloat, velocity: CGPoint) {
        let newConstant = self.previousContainerViewTopConstraint + value
        if(newConstant > 30){
            let currentConstant:CGFloat =  120
            if newConstant >= self.view.bounds.height - currentConstant{
                self.dismissController()
            }
        }else{
            UIView.animate(withDuration: 0.5, animations: {
                self.containerViewTopConstraint?.constant = self.view.frame.height / 5
                self.view.layoutIfNeeded()
            }, completion: nil)
            
        }
    }
    
    private var previousContainerViewTopConstraint: CGFloat = 0.0
    
    func didMoveController(value: CGFloat,velocity: CGPoint) {
        
        if self.containerViewTopConstraint == nil{
            print("This is nil")
        }
        
        let newConstant = self.previousContainerViewTopConstraint + value - 180
        UIView.animate(withDuration: 0.5) {
            self.containerViewTopConstraint?.constant = newConstant
            self.view.layoutIfNeeded()
        }
    }
    
    func didBeginMovemnet(){
        self.previousContainerViewTopConstraint = containerViewTopConstraint?.constant ?? 0
    }
    private func animateTopConstraint(constant: CGFloat, withVelocity velocity: CGPoint) {
        let previousConstraint = containerViewTopConstraint!.constant
        let distance = previousConstraint - constant
        let springVelocity = max(1 / (abs(velocity.y / distance)), 0.08)
        let springDampening = CGFloat(0.6)
        UIView.animate(withDuration: 0.5,
                       delay: 0.0,
                       usingSpringWithDamping: springDampening,
                       initialSpringVelocity: springVelocity,
                       options: [.curveLinear],
                       animations: {
                        self.containerViewTopConstraint!.constant = constant
                        self.view.layoutIfNeeded()
        },
                       completion: nil)
    }
}
protocol ChildDelegate {
    func didMoveController(value:CGFloat, velocity:CGPoint)
    func didEndMovemnt(value:CGFloat,velocity:CGPoint)
    func didBeginMovemnet()
    func fullPresentController()
    func dismissController()
}
