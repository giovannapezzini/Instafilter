//
//  ViewController.swift
//  Instafilter
//
//  Created by Giovanna Pezzini on 09/02/21.
//

import UIKit

class ViewController: UIViewController {
    
    let backgroundView = UIView()
    let imageView = UIImageView()
    let label = UILabel()
    let slider = UISlider()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        configureImageView()
        configureSlider()
    }
    
    func configureImageView() {
        view.addSubview(backgroundView)
        backgroundView.backgroundColor = .systemGray5
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        
        backgroundView.addSubview(imageView)
        imageView.backgroundColor = .systemGray6
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            backgroundView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            backgroundView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            backgroundView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            backgroundView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.5),
            
            imageView.topAnchor.constraint(equalTo: backgroundView.topAnchor, constant: 10),
            imageView.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: 10),
            imageView.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor, constant: -10),
            imageView.bottomAnchor.constraint(equalTo: backgroundView.bottomAnchor, constant: -10)
        ])
    }
    
    func configureSlider() {
        view.addSubview(slider)
        view.addSubview(label)
        
        label.text = "Intensity:"
        label.translatesAutoresizingMaskIntoConstraints = false
        slider.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: backgroundView.bottomAnchor, constant: 20),
            label.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            label.heightAnchor.constraint(equalToConstant: 44),
            
            slider.topAnchor.constraint(equalTo: backgroundView.bottomAnchor, constant: 20),
            slider.leadingAnchor.constraint(equalTo: label.trailingAnchor, constant: 10),
            slider.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            slider.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
}

