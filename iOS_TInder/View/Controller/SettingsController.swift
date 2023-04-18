//
//  SettingsController.swift
//  iOS_TInder
//
//  Created by Тагай Абдылдаев on 18/4/23.
//

import UIKit
import SnapKit

class CustomUIImagePickerController: UIImagePickerController {
    var imageButton: UIButton?
}


class SettingsController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    lazy var imageButton1 = createButton()
    lazy var imageButton2 = createButton()
    lazy var imageButton3 = createButton()
        
    override func viewDidLoad() {
        super .viewDidLoad()
        tableView.backgroundColor = UIColor(white: 0.9, alpha: 1)
        setupNavSettings()
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = UIView()
        header.addSubview(imageButton1)
        imageButton1.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.bottom.equalToSuperview().offset(-16)
            make.leading.equalToSuperview().offset(16)
            make.width.equalTo(200)

        }
        let imageStackView = UIStackView(arrangedSubviews: [imageButton2, imageButton3])
        imageStackView.axis = .vertical
        imageStackView.spacing = 16
        imageStackView.distribution = .fillEqually
        header.addSubview(imageStackView)
        imageStackView.snp.makeConstraints { make in
            make.top.equalTo(imageButton1.snp.top)
            make.leading.equalTo(imageButton1.snp.trailing).offset(16)
            make.trailing.equalToSuperview().offset(-16)
            make.bottom.equalToSuperview().offset(-16)
        }
        return header
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 300
    }
    
    fileprivate func createButton() -> UIButton {
        let button = UIButton(type: .system)
        button.setTitle("Select Photo", for: .normal)
        button.backgroundColor = .white
        button.layer.cornerRadius = 8
        button.imageView?.contentMode = .scaleAspectFill
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(handleSelectPhoto), for: .touchUpInside)
        return button
    }
    
    @objc fileprivate func handleSelectPhoto(sender: UIButton) {
        let imagePicker = CustomUIImagePickerController()
        imagePicker.delegate = self
        imagePicker.imageButton = sender
        present(imagePicker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let selectedImage = info[.originalImage] as? UIImage
        (picker as? CustomUIImagePickerController)?.imageButton?.setImage(selectedImage?.withRenderingMode(.alwaysOriginal), for: .normal)
        dismiss(animated: true)
    }
    
    fileprivate func setupNavSettings() {
        navigationItem.title = "Settings"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleCancel)),
            UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(handleCancel))
        ]
    }
    
    @objc fileprivate func handleCancel() {
        dismiss(animated: true)
    }
}
