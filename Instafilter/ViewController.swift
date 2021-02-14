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
    
    let intensityLabel = UILabel()
    let radiusLabel = UILabel()
    let intensity = UISlider()
    let radius = UISlider()
    
    let changeFilterButton = UIButton()
    let saveButton = UIButton()
    
    var currentImage = UIImage()
    var context = CIContext()
    var currentFilter: CIFilter!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        title = "Instafilter 📸"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(importPicture))
        
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
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        
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
        view.addSubview(intensityLabel)
        intensityLabel.translatesAutoresizingMaskIntoConstraints = false
        intensityLabel.text = "Intensity:"
        
        view.addSubview(intensity)
        intensity.translatesAutoresizingMaskIntoConstraints = false
        intensity.addTarget(self, action: #selector(intensityChanged), for: .valueChanged)
        
        view.addSubview(radiusLabel)
        radiusLabel.translatesAutoresizingMaskIntoConstraints = false
        radiusLabel.text = "Radius:"
        
        view.addSubview(radius)
        radius.translatesAutoresizingMaskIntoConstraints = false
        radius.addTarget(self, action: #selector(radiusChanged), for: .valueChanged)
        
        NSLayoutConstraint.activate([
            intensityLabel.topAnchor.constraint(equalTo: backgroundView.bottomAnchor, constant: 20),
            intensityLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            intensityLabel.heightAnchor.constraint(equalToConstant: 44),
            
            intensity.topAnchor.constraint(equalTo: backgroundView.bottomAnchor, constant: 20),
            intensity.leadingAnchor.constraint(equalTo: intensityLabel.trailingAnchor, constant: 10),
            intensity.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            intensity.heightAnchor.constraint(equalToConstant: 44),
            
            radiusLabel.topAnchor.constraint(equalTo: intensity.bottomAnchor, constant: 0),
            radiusLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            radiusLabel.heightAnchor.constraint(equalToConstant: 44),
            
            radius.topAnchor.constraint(equalTo: intensity.bottomAnchor, constant: 0),
            radius.leadingAnchor.constraint(equalTo: intensityLabel.trailingAnchor, constant: 10),
            radius.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            radius.heightAnchor.constraint(equalToConstant: 44)
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
            changeFilterButton.topAnchor.constraint(equalTo: radiusLabel.bottomAnchor, constant: 10),
            changeFilterButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            changeFilterButton.bottomAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 10),
            
            saveButton.topAnchor.constraint(equalTo: radiusLabel.bottomAnchor, constant: 10),
            saveButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            saveButton.bottomAnchor.constraint(lessThanOrEqualTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 10)
        ])
    }
    
    // MARK:  - Filter methods
    
    @objc func changeFilter(_ sender: Any) {
        let ac = UIAlertController(title: "Choose filter", message: nil, preferredStyle: .actionSheet)
        ac.addAction(UIAlertAction(title: "CIBumpDistortion", style: .default, handler: setFilter))
        ac.addAction(UIAlertAction(title: "CIGaussianBlur", style: .default, handler: setFilter))
        ac.addAction(UIAlertAction(title: "CIPixellate", style: .default, handler: setFilter))
        ac.addAction(UIAlertAction(title: "CISepiaTone", style: .default, handler: setFilter))
        ac.addAction(UIAlertAction(title: "CITwirlDistortion", style: .default, handler: setFilter))
        ac.addAction(UIAlertAction(title: "CIUnsharpMask", style: .default, handler: setFilter))
        ac.addAction(UIAlertAction(title: "CIVignette", style: .default, handler: setFilter))
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(ac, animated: true)
    }
    
    func setFilter(action: UIAlertAction) -> Void {
        guard let filter = action.title else { return }
        currentFilter = CIFilter(name: filter)
        changeFilterButton.setTitle("Filter: " + filter, for: .normal)

        let beginImage = CIImage(image: currentImage)
        currentFilter.setValue(beginImage, forKey: kCIInputImageKey)
        
        applyProcessing()
    }
    
    @objc func intensityChanged(_ sender: Any) {
        applyProcessing()
    }
    
    @objc func radiusChanged(_ sender: Any) {
        applyProcessing()
    }
    
    // MARK:  - Image picker methods
    
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
    
    // MARK:  - Image processing method
    
    func applyProcessing() {
        let inputKeys = currentFilter.inputKeys
        
        if inputKeys.contains(kCIInputIntensityKey) { currentFilter.setValue(intensity.value, forKey: kCIInputIntensityKey) }
        if inputKeys.contains(kCIInputRadiusKey) { currentFilter.setValue(radius.value * 200, forKey: kCIInputRadiusKey) }
        if inputKeys.contains(kCIInputScaleKey) { currentFilter.setValue(intensity.value * 10, forKey: kCIInputScaleKey) }
        if inputKeys.contains(kCIInputCenterKey) { currentFilter.setValue(CIVector(x: currentImage.size.width / 2, y: currentImage.size.height / 2), forKey: kCIInputCenterKey) }
        
        guard let outputImage = currentFilter.outputImage else { return }
        
        if let cgimg = context.createCGImage(outputImage, from: outputImage.extent) {
            let processedImage = UIImage(cgImage: cgimg)
            self.imageView.image = processedImage
        }
    }
    
    // MARK:  - Image saving methods
    
    @objc func save() {
        guard let image = imageView.image else {
            let ac = UIAlertController(title: "Save error", message: "No image to save", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
            return
        }
        
        UIImageWriteToSavedPhotosAlbum(image, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
    }
    
    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            let ac = UIAlertController(title: "Save error", message: error.localizedDescription, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        } else {
            let ac = UIAlertController(title: "Saved!", message: "Your altered image has been saved to your photos.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        }
    }
}
