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
        
        glideshow.items = [
            GlideItem(caption : "Привет", description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit.", imageURL: "https://picsum.photos/1080/720"),
            GlideItem(caption : "Hello in Japanese",title : "こんにちは", description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit.", backgroundImage: #imageLiteral(resourceName: "image10")),
            GlideItem(caption : "Hello in Chinese",title : "你好", description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit.", backgroundImage: #imageLiteral(resourceName: "image7")),
            GlideItem(caption : "Hello in Thai",title : "สวัสดี", description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit.Lorem ipsum dolor sit amet, consectetur adipiscing elit.", backgroundImage: #imageLiteral(resourceName: "image9"))
        ]
        glideshow.delegate = self
        glideshow.isCircular = true
        glideshow.placeHolderImage = #imageLiteral(resourceName: "dish_default_image")
        glideshow.gradientColor =
            UIColor.black.withAlphaComponent(0.8)
        glideshow.captionFont = UIFont.systemFont(ofSize: 16, weight: .light)
        glideshow.titleFont = UIFont.systemFont(ofSize: 30, weight: .black)
        glideshow.gradientHeightFactor = 0.8
        glideshow.pageIndicatorPosition = .bottom
        glideshow.interval = 5
        
        button.setTitle("Go to item number 3", for: .normal)
        button.addTarget(self, action: #selector(goToSlide), for: .touchUpInside)
        
        view.addSubview(glideshow)
        view.addSubview(button)
    }
    
    
    @objc func goToSlide(){
        glideshow.jumpToSlide(3, true)
        
    }
}

extension ViewController : GlideshowProtocol {
    func glideshowDidSelecteRowAt(indexPath: IndexPath, _ glideshow: Glideshow) {
        print(indexPath)
    }
    
    func pageDidChange(_ glideshow: Glideshow, didChangePageTo page: Int) {
        print(page)
    }
}
