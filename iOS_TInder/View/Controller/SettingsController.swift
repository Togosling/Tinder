//
//  SettingsController.swift
//  iOS_TInder
//
//  Created by Тагай Абдылдаев on 18/4/23.
//

import UIKit
import SnapKit
import FirebaseFirestore
import FirebaseAuth
import FirebaseStorage
import JGProgressHUD
import SDWebImage

protocol SettingsControllerDelegate {
    func didSaveSettings()
}

class CustomUIImagePickerController: UIImagePickerController {
    var imageButton: UIButton?
}

class SettingsController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var delegate: SettingsControllerDelegate?
    
    lazy var imageButton1 = createButton()
    lazy var imageButton2 = createButton()
    lazy var imageButton3 = createButton()
    
    lazy var header: UIView = {
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
    }()
    
    var user: User?
    
    class HeaderLabel: UILabel {
        override func drawText(in rect: CGRect) {
            super.drawText(in: rect.insetBy(dx: 16, dy: 0))
        }
    }
            
    override func viewDidLoad() {
        super .viewDidLoad()
        tableView.backgroundColor = UIColor(white: 0.9, alpha: 1)
        setupNavSettings()
        tableView.keyboardDismissMode = .interactive
        fetchDataForUser()
    }
    
    fileprivate func fetchDataForUser() {
        guard let uid = Auth.auth().currentUser?.uid else {return}
        Firestore.firestore().collection("users").document(uid).getDocument { snapShot, err in
            if let err = err {
                print(err)
                return
            }
            guard let dictionary = snapShot?.data() else {return}
            self.user = User(documents: dictionary)
            self.loadUserPhotos()
            self.tableView.reloadData()
        }
    }
    
    fileprivate func loadUserPhotos() {
        if let imageUrl = user?.imageUrl1, let url = URL(string: imageUrl){
            SDWebImageManager.shared.loadImage(with: url, options: .continueInBackground, progress: nil) { (image, _, _, _, _, _) in
                self.imageButton1.setImage(image?.withRenderingMode(.alwaysOriginal), for: .normal)
            }
        }
        if let imageUrl = user?.imageUrl2, let url = URL(string: imageUrl){
            SDWebImageManager.shared.loadImage(with: url, options: .continueInBackground, progress: nil) { (image, _, _, _, _, _) in
                self.imageButton2.setImage(image?.withRenderingMode(.alwaysOriginal), for: .normal)
            }
        }
        if let imageUrl = user?.imageUrl3, let url = URL(string: imageUrl){
            SDWebImageManager.shared.loadImage(with: url, options: .continueInBackground, progress: nil) { (image, _, _, _, _, _) in
                self.imageButton3.setImage(image?.withRenderingMode(.alwaysOriginal), for: .normal)
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            return header
        }
        let headerLabel = HeaderLabel()
        switch section {
        case 1:
            headerLabel.text = "Name"
            return headerLabel
        case 2:
            headerLabel.text = "Profession"
            return headerLabel
        case 3:
            headerLabel.text = "Age"
            return headerLabel
        case 4:
            headerLabel.text = "Bio"
            return headerLabel
        default:
            headerLabel.text = "Seeking Age"
            return headerLabel
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 300
        }
        return 40
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 6
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? 0 : 1
    }
    
    static let minSeekingAge = 18
    static let maxSeekingAge = 50
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if indexPath.section == 5 {
            let cell = AgeSeekingCell(style: .default, reuseIdentifier: nil)
            cell.contentView.isUserInteractionEnabled = false
            cell.minSlider.addTarget(self, action: #selector(handleMinAgeChange), for: .valueChanged)
            cell.maxSlider.addTarget(self, action: #selector(handleMaxAgeChange), for: .valueChanged)
            cell.minLabel.text = "Min \(user?.minSeekingAge ?? SettingsController.minSeekingAge)"
            cell.maxLabel.text = "Max \(user?.maxSeekingAge ?? SettingsController.maxSeekingAge)"
            cell.minSlider.value = Float(user?.minSeekingAge ?? SettingsController.minSeekingAge)
            cell.maxSlider.value = Float(user?.maxSeekingAge ?? SettingsController.maxSeekingAge)
            return cell
        }
        let cell = SettingsCell(style: .default, reuseIdentifier: "cellId")
        cell.contentView.isUserInteractionEnabled = false
        switch indexPath.section {
        case 1:
            cell.textField.placeholder = "Enter Name"
            cell.textField.text = user?.name
            cell.textField.addTarget(self, action: #selector(handleNameEditing), for: .editingChanged)
        case 2:
            cell.textField.placeholder = "Enter Profession"
            cell.textField.text = user?.profession
            cell.textField.addTarget(self, action: #selector(handleProfessionEditing), for: .editingChanged)
        case 3:
            if let age = user?.age {
                cell.textField.text = String(Int(age))
            }
            cell.textField.placeholder = "Enter Age"
            cell.textField.addTarget(self, action: #selector(handleAgeEditing), for: .editingChanged)
        default:
            cell.textField.placeholder = "Enter Bio"
        }
        return cell
    }
    
    @objc fileprivate func handleMinAgeChange(slider: UISlider) {
        let indexPath = IndexPath(row: 0, section: 5)
        guard let ageRangeCell = tableView.cellForRow(at: indexPath) as? AgeSeekingCell else {return}
        ageRangeCell.minLabel.text = "Min \(Int(slider.value))"
        
        self.user?.minSeekingAge = Int(slider.value)
    }
    
    @objc fileprivate func handleMaxAgeChange(slider: UISlider) {
        let indexPath = IndexPath(row: 0, section: 5)
        guard let ageRangeCell = tableView.cellForRow(at: indexPath) as? AgeSeekingCell else {return}
        ageRangeCell.maxLabel.text = "Max \(Int(slider.value))"
        
        self.user?.maxSeekingAge = Int(slider.value)
    }
    
    @objc fileprivate func handleNameEditing(textField: UITextField) {
        self.user?.name = textField.text
    }
    @objc fileprivate func handleProfessionEditing(textField: UITextField) {
        self.user?.profession = textField.text
    }
    @objc fileprivate func handleAgeEditing(textField: UITextField) {
        self.user?.age = Int(textField.text ?? "")
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
        guard let imageButton =  (picker as? CustomUIImagePickerController)?.imageButton else {return}
        imageButton.setImage(selectedImage?.withRenderingMode(.alwaysOriginal), for: .normal)
        
        let fileName = UUID().uuidString
        let ref = Storage.storage().reference(withPath: "/images/\(fileName)")
        guard let uploadData = selectedImage?.jpegData(compressionQuality: 0.75) else {return}
        let hud = JGProgressHUD(style: .dark)
        hud.textLabel.text = "Uploading Image"
        hud.show(in: view)
        ref.putData(uploadData, metadata: nil, completion: { (_, err) in
            
            if let err = err {
                print(err)
                return
            }
            ref.downloadURL { url, err in
                hud.dismiss(animated: true)
                if let err = err {
                    print(err)
                    return
                }
                if imageButton == self.imageButton1 {
                    self.user?.imageUrl1 = url?.absoluteString
                } else if imageButton == self.imageButton2 {
                    self.user?.imageUrl2 = url?.absoluteString
                } else {
                    self.user?.imageUrl3 = url?.absoluteString
                }
            }
        })
    }
                    
    fileprivate func setupNavSettings() {
        navigationItem.title = "Settings"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(title: "Logout", style: .plain, target: self, action: #selector(handleLogout)),
            UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(handleSave))
        ]
    }
    
    @objc fileprivate func handleLogout() {
        try? Auth.auth().signOut()
        dismiss(animated: true)
    }
    
    @objc fileprivate func handleSave() {
        let hud = JGProgressHUD(style: .dark)
        hud.textLabel.text = "Saving Settings"
        hud.show(in: view)
        guard let uid = Auth.auth().currentUser?.uid else {return}
        let docData: [String:Any] = [
            "uid": user?.uid ?? "",
            "fullName": user?.name ?? "",
            "profession": user?.profession ?? "",
            "age": user?.age ?? "",
            "imageUrl1": user?.imageUrl1 ?? "",
            "imageUrl2": user?.imageUrl2 ?? "",
            "imageUrl3": user?.imageUrl3 ?? "",
            "minSeekingAge": user?.minSeekingAge ?? "",
            "maxSeekingAge": user?.maxSeekingAge ?? ""
        ]
        Firestore.firestore().collection("users").document(uid).setData(docData) { err in
            hud.dismiss(animated: true)
            if let err = err{
                print(err)
            }
            self.dismiss(animated: true) {
                self.delegate?.didSaveSettings()
            }
        }
    }
    
    @objc fileprivate func handleCancel() {
        dismiss(animated: true)
    }
}
