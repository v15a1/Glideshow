//
//  ViewController.swift
//  GlideshowExample
//
//  Created by Visal Rajapakse on 2021-02-28.
//

import UIKit
import Glideshow

class ViewController: UIViewController {
    
    let glideshow = Glideshow()
    let button = UIButton(type: .system)
    var counter = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        glideshow.frame = CGRect(x: 0, y: 100, width:self.view.frame.width, height: 250)
        button.frame = CGRect(x: 0, y: 0, width:self.view.frame.width, height: 50)
        button.center = view.center
    }
    
    private func setupUI(){
        view.backgroundColor = .white
        glideshow.interval = 3
        
        glideshow.items = [
            GlideItem(caption : "WELCOME",title : "Hola Amigos", description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit."),
            GlideItem(caption : "Welcome", description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit.", backgroundImage: #imageLiteral(resourceName: "image5")),
            GlideItem(caption : "Welcome",title : "Hello", description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit.", backgroundImage: #imageLiteral(resourceName: "image2")),
            GlideItem(caption : "Welcome",title : "Hello", description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit.", backgroundImage: #imageLiteral(resourceName: "image3")),
            GlideItem(caption : "Welcome",title : "Hello", description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit.Lorem ipsum dolor sit amet, consectetur adipiscing elit.", backgroundImage: #imageLiteral(resourceName: "image4"))
        ]
        
        glideshow.isCircular = true
        glideshow.interval = 5
        glideshow.gradientColor =
            UIColor.black.withAlphaComponent(0.8)
        glideshow.captionFont = UIFont.systemFont(ofSize: 16, weight: .light)
        glideshow.titleFont = UIFont.systemFont(ofSize: 30, weight: .black)
        glideshow.gradientHeightFactor = 0.8
        glideshow.pageIndicatorPosition = .bottom
        
        button.setTitle("Go to item number 3", for: .normal)
        button.addTarget(self, action: #selector(goToSlide), for: .touchUpInside)
        
        view.addSubview(glideshow)
        view.addSubview(button)
    }
    
    
    @objc func goToSlide(){
        glideshow.jumpToSlide(3, true)
        
    }
}
