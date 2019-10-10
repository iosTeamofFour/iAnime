//
//  DiscoveryViewController.swift
//  iAnime
//
//  Created by NemesissLin on 2019/10/9.
//  Copyright © 2019 NemesissLin. All rights reserved.
//

import UIKit

class DiscoveryViewController: UIViewController {
    @IBOutlet weak var segments: UISegmentedControl!
    
    @IBOutlet weak var fragments: FragmentViewContainer!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        segments.addTarget(self, action: #selector(OnSegmentSelectedValueChanged(_:)), for: .valueChanged)
        LoadFragmentsToContainer()
    }
    
    
    private func LoadFragmentsToContainer() {
        let storyboard = UIStoryboard(name: "Discovery", bundle: nil)
            let recommendation = storyboard.instantiateViewController(withIdentifier: "Recommendation") as! FragmentViewController // 推荐
            let ranking = storyboard.instantiateViewController(withIdentifier: "Ranking") as! FragmentViewController// 排行
            let search = storyboard.instantiateViewController(withIdentifier: "Search") as! FragmentViewController
            
            fragments.AddViewController(recommendation)
            fragments.AddViewController(ranking)
            fragments.AddViewController(search)
            
            fragments.PresentNewViewController(0)
        
    }
    
    @objc private func OnSegmentSelectedValueChanged(_ sender: UISegmentedControl) {
        fragments.PresentNewViewController(sender.selectedSegmentIndex)
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
