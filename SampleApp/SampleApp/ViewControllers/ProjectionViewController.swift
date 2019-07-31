//
//  ProjectionViewController.swift
//  SampleApp
//
//  Created by zhouwenshuang on 2019/7/31.
//  Copyright © 2019 LinkedIn. All rights reserved.
//

import UIKit
import RocketData

class ProjectionViewController: UIViewController, UITextFieldDelegate, DataProviderDelegate {
    
    @IBOutlet weak var userLabel: UILabel!
    
    @IBOutlet weak var userTextField: UITextField!
    
    @IBOutlet weak var profileLabel: UILabel!
    
    @IBOutlet weak var profileTextField: UITextField!
    
    @IBOutlet weak var dataDescriptionLabel: UILabel!
    
    
    fileprivate let userDataProvider = DataProvider<UserModel>()
    
    fileprivate let profileDataProvider = DataProvider<ProfileModel>()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let data = [ "id" : 10212, "name" : "Tom", "online" : true, "age" : 20 ] as [String : Any]
        
        let userModel = UserModel(data: data)
        let profileModel = ProfileModel(data: data)
        
        
        userDataProvider.delegate = self
        profileDataProvider.delegate = self
        
        userDataProvider.setData(userModel)
        profileDataProvider.setData(profileModel)
        
        userLabel.text = userModel?.name
        profileLabel.text = String(format: "%@, %d", profileModel?.name ?? "DefaultName", profileModel?.age ?? 0)
        
        dataDescriptionLabel.text = data.description
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == userTextField {
            let userModel = UserModel(id: 10212, name: textField.text ?? "null", online: true)
            userDataProvider.setData(userModel)
            userLabel.text = textField.text
        } else if textField == profileTextField {
            let name = textField.text?.components(separatedBy: ",").first
            let age = (textField.text?.components(separatedBy: ",").last)!
            let profileModel = ProfileModel(id: 10212, name: name ?? "Tome", online: true, age: Int(age) ?? 0)
            profileDataProvider.setData(profileModel)
            profileLabel.text = textField.text
        }
        return true
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    func dataProviderHasUpdatedData<T>(_ dataProvider: DataProvider<T>, context: Any?) where T : SimpleModel {
        
        if let dataProvider = dataProvider as? DataProvider<UserModel> {
            userLabel.text = dataProvider.data?.name
            dataDescriptionLabel.text = dataProvider.data?.data().description
        }
        if let dataProvider = dataProvider as? DataProvider<ProfileModel> {
            profileLabel.text = String(format: "%@, %d", dataProvider.data?.name ?? "FOieirg", dataProvider.data?.age ?? 0)
            dataDescriptionLabel.text = dataProvider.data?.data().description
        }
    }
    
}
