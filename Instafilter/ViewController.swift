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

    override func viewDidLoad() {
        super.viewDidLoad()      
        
        view.backgroundColor = .white
        configureView()
        configureImageView()
        configureLabel()
    }
    
    func configureView() {
        view.addSubview(backgroundView)
        backgroundView.backgroundColor = .systemGray5
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            backgroundView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            backgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            backgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            backgroundView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.5)
        ])
    }

    func configureImageView() {
        backgroundView.addSubview(imageView)
        imageView.backgroundColor = .systemGray6
        imageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: backgroundView.topAnchor, constant: 10),
            imageView.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: 10),
            imageView.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor, constant: -10),
            imageView.bottomAnchor.constraint(equalTo: backgroundView.bottomAnchor, constant: -10)
        ])
    }
    
    func configureLabel() {
        view.addSubview(label)
        label.text = "Intensity"
        label.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: backgroundView.bottomAnchor, constant: 20),
            label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            label.heightAnchor.constraint(equalToConstant: 44)
        ])
    }
}

