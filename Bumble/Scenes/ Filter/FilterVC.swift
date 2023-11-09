//
//  FilterVC.swift
//  Bumble
//
//  Created by Nguyễn Công Thư on 09/11/2023.
//

import UIKit

class FilterVC: BaseViewController {

    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var ageSlider: UISlider!
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    private func setupView () {
        setupAgeSlider()
    }
    
    private func setupAgeSlider () {
        ageSlider.minimumValue = 0
        ageSlider.maximumValue = 100
        ageSlider.value = 18
        ageSlider.addTarget(self, action: #selector(sliderValueChanged(_:)), for: .valueChanged)
        ageLabel.text = "Độ tuổi: \(Int(ageSlider.value))"
    }
    
    @objc func sliderValueChanged(_ sender: UISlider) {
        let selectedAge = Int(sender.value)
        ageLabel.text = "Độ tuổi: \(selectedAge)"
    }
    
    @IBAction func didSelectButtonClose(_ sender: Any) {
        self.dismiss(animated: true)
    }
}
