//
//  ViewController.swift
//  Instafilter
//
//  Created by Giovanna Pezzini on 09/02/21.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    let backgroundView = UIView()
    let imageView = UIImageView()
    let label = UILabel()
    let slider = UISlider()
    let changeFilterButton = UIButton()
    let saveButton = UIButton()
    var currentImage = UIImage()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        title = "Instafilter 📸"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(importPicture))
        
        configureImageView()
        configureSlider()
        configureButtons()
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
    
    func configureButtons() {
        view.addSubview(changeFilterButton)
        changeFilterButton.translatesAutoresizingMaskIntoConstraints = false
        changeFilterButton.setTitle("Change Filter", for: .normal)
        changeFilterButton.setTitleColor(.systemBlue, for: .normal)
        changeFilterButton.addTarget(self, action: #selector(changeFilter), for: .touchUpInside)

        view.addSubview(saveButton)
        saveButton.translatesAutoresizingMaskIntoConstraints = false
        saveButton.setTitle("Save", for: .normal)
        saveButton.setTitleColor(.systemBlue, for: .normal)
        saveButton.addTarget(self, action: #selector(save), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            changeFilterButton.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 10),
            changeFilterButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            changeFilterButton.bottomAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 10),
            
            saveButton.topAnchor.constraint(equalTo: label.bottomAnchor, constant: 10),
            saveButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            saveButton.bottomAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 10)
        ])
    }
    
    @objc func changeFilter() {
        print("change filter tapped")
    }
    
    @objc func save() {
        print("save tapped")
    }
    
    @objc func importPicture() {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }
        dismiss(animated: true)
        currentImage = image
    }
}

