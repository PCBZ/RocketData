//
//  BatchListenViewController.swift
//  SampleApp
//
//  Created by zhouwenshuang on 2019/8/1.
//  Copyright © 2019 LinkedIn. All rights reserved.
//

import UIKit
import RocketData
import ConsistencyManager

class BatchListenViewController: UIViewController, UITextFieldDelegate, BatchDataProviderListenerDelegate, DataProviderDelegate {
    
    @IBOutlet weak var label1: UILabel!
    
    @IBOutlet weak var label2: UILabel!
    
    @IBOutlet weak var senderLabel: UILabel!
    
    fileprivate let userDataProvider1 = DataProvider<MessageModel>()
    
    fileprivate let userDataProvider2 = DataProvider<MessageModel>()
    
    var batchDataProvider : BatchDataProviderListener?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let data1 = [ "id" : 10212, "name" : "Tom", "online" : true ] as [String : Any]
        
        let sender = UserModel(data: data1)
        
        let message1 = MessageModel(id: 0x03941, text: "rinw😠", sender: sender!)
        let message2 = MessageModel(id: 0x05354, text: "iovw😃", sender: sender!)
        
        
        label1.text = String(format: "message:%@ from:%@", message1.text, message1.sender.name)
        label2.text = String(format: "message:%@ from:%@", message2.text, message2.sender.name)
        senderLabel.text = sender?.name
        
        batchDataProvider = BatchDataProviderListener(dataProviders: [userDataProvider1, userDataProvider2], dataModelManager: DataModelManager.sharedInstance);
        batchDataProvider?.delegate = self
        
        userDataProvider1.batchListener = batchDataProvider
        userDataProvider2.batchListener = batchDataProvider
        
        userDataProvider1.setData(message1)
        userDataProvider2.setData(message2)

        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        let data = [ "id" : 10212, "name" : textField.text ?? "anounymous", "online" : true] as [String : Any]
        let user = UserModel(data: data)
        
        DataModelManager.sharedInstance.updateModel(user!)
        return true
    }
    
    @IBAction func segmentSelected(_ sender: UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            userDataProvider1.delegate = self
            userDataProvider2.delegate = self
            batchDataProvider?.delegate = nil
        } else {
            userDataProvider1.delegate = nil
            userDataProvider2.delegate = nil
            batchDataProvider?.delegate = self
        }
    }
    
    
    func batchDataProviderListener(_ batchListener: BatchDataProviderListener, hasUpdatedDataProviders dataProviders: [ConsistencyManagerListener], context: Any?) {
        if let dataProvider = dataProviders[0] as? DataProvider<MessageModel> {
            label1.text = String(format: "message:%@ from:%@", dataProvider.data!.text, dataProvider.data!.sender.name)
            senderLabel.text = dataProvider.data!.sender.name
        }
        if let dataProvider = dataProviders[1] as? DataProvider<MessageModel> {
            label2.text = String(format: "message:%@ from:%@", dataProvider.data!.text, dataProvider.data!.sender.name)
        }
    }
    
    func dataProviderHasUpdatedData<T>(_ dataProvider: DataProvider<T>, context: Any?) where T : SimpleModel {
        
        if let data = dataProvider.data as? MessageModel  {
            senderLabel.text = data.sender.name
        }
        
        if dataProvider === userDataProvider1 {
            label1.text = String(format: "message:%@ from:%@", userDataProvider1.data!.text, userDataProvider1.data!.sender.name)
        }
        if dataProvider === userDataProvider2 {
            label2.text = String(format: "message:%@ from:%@", userDataProvider2.data!.text, userDataProvider2.data!.sender.name)
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
