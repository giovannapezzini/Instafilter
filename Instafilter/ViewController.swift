//
//  ViewController.swift
//  Instafilter
//
//  Created by Giovanna Pezzini on 09/02/21.
//

import UIKit
import CoreImage

class ViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    let backgroundView = UIView()
    let imageView = UIImageView()
    let label = UILabel()
    let intensity = UISlider()
    let changeFilterButton = UIButton()
    let saveButton = UIButton()
    var currentImage = UIImage()
    
    var context: CIContext!
    var currentFilter: CIFilter!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        title = "Instafilter 📸"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(importPicture))
        
        context = CIContext()
        currentFilter = CIFilter(name: "CISepiaTone")
        
        configureImageView()
        configureSlider()
        configureButtons()
    }
    
    // MARK:  - Layout UI
    
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
        view.addSubview(intensity)
        view.addSubview(label)
        
        label.text = "Intensity:"
        label.translatesAutoresizingMaskIntoConstraints = false
        intensity.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: backgroundView.bottomAnchor, constant: 20),
            label.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            label.heightAnchor.constraint(equalToConstant: 44),
            
            intensity.topAnchor.constraint(equalTo: backgroundView.bottomAnchor, constant: 20),
            intensity.leadingAnchor.constraint(equalTo: label.trailingAnchor, constant: 10),
            intensity.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            intensity.heightAnchor.constraint(equalToConstant: 44)
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
    
    // MARK:  - Buttons Actions
    
    @objc func changeFilter(_ sender: UIButton) {
        let ac = UIAlertController(title: "Choose filter", message: nil, preferredStyle: .actionSheet)
        ac.addAction(UIAlertAction(title: "CIBumpDistortion", style: .default, handler: setFilter))
        ac.addAction(UIAlertAction(title: "CIGaussianBlur", style: .default, handler: setFilter))
        ac.addAction(UIAlertAction(title: "CIPixellate", style: .default, handler: setFilter))
        ac.addAction(UIAlertAction(title: "CISepiaTone", style: .default, handler: setFilter))
        ac.addAction(UIAlertAction(title: "CITwirlDistortion", style: .default, handler: setFilter))
        ac.addAction(UIAlertAction(title: "CIUnsharpMask", style: .default, handler: setFilter))
        ac.addAction(UIAlertAction(title: "CIVignette", style: .default, handler: setFilter))
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        if let popoverController = ac.popoverPresentationController  {
            popoverController.sourceView = sender
            popoverController.sourceRect = sender.bounds
        }
        
        present(ac, animated: true)
    }
    
    func setFilter(action: UIAlertAction) -> Void {
        print(action.title!)
    }
    
    @objc func save() {
        print("save tapped")
    }
    
    @objc func intensityChanged() {
        applyProcessing()
    }
    
    // MARK:  - Image Picker methods
    
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
        
        let beginImage = CIImage(image: currentImage)
        currentFilter.setValue(beginImage, forKey: kCIInputImageKey)
        applyProcessing()
    }
    
    func applyProcessing() {
        guard let outputImage = currentFilter.outputImage else { return }
        currentFilter.setValue(intensity.value, forKey: kCIInputIntensityKey)
        
        if let cgImage = context.createCGImage(outputImage, from: outputImage.extent) {
            let processedImage = UIImage(cgImage: cgImage)
            imageView.image = processedImage
        }
    }
}

