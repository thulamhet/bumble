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
    @IBOutlet weak var womenButton: UIButton!
    @IBOutlet weak var menButton: UIButton!
    @IBOutlet weak var datingSwitch: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    private func setupView () {
        datingSwitch.isOn = isAll()
        setupStatus()
        setupAgeSlider()
    }
    
    private func setupAgeSlider () {
        ageSlider.minimumValue = 18
        ageSlider.maximumValue = 100
        ageSlider.value = 100
        ageSlider.addTarget(self, action: #selector(sliderValueChanged(_:)), for: .valueChanged)
        ageLabel.text = "Between 18 and \(Int(ageSlider.value))"
    }
    
    private func setupStatus () {
        ageSlider.value = Float(SESSION.filterAge)
        if SESSION.filterStatus == 2 {
            menButton.isSelected = true
            womenButton.isSelected = true
            datingSwitch.isOn = true
        } else if SESSION.filterStatus == 1 {
            menButton.isSelected = true
            womenButton.isSelected = false
            datingSwitch.isOn = false
        } else if SESSION.filterStatus == 0 {
            menButton.isSelected = false
            womenButton.isSelected = true
            datingSwitch.isOn = false
        }
    }
    
    private func isAll () -> Bool {
        if !menButton.isSelected || !womenButton.isSelected {
            return false
        }
        return true
    }
    
    private func setFilterStatus () {
        SESSION.filterAge = Int(ageSlider.value)
        if menButton.isSelected && womenButton.isSelected {
            SESSION.filterStatus = 2
            return
        }
        if menButton.isSelected && !womenButton.isSelected {
            SESSION.filterStatus = 1//men
            return
        }
        if !menButton.isSelected && womenButton.isSelected {
            SESSION.filterStatus = 0
        }
    }
    
    @objc func sliderValueChanged(_ sender: UISlider) {
        let selectedAge = Int(sender.value)
        ageLabel.text = "Between 18 and \(selectedAge)"
    }
    
    @IBAction func didSelectButtonClose(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func didSelectMenButton(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        datingSwitch.isOn = isAll()
    }
    
    @IBAction func didSelectWomenButton(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        datingSwitch.isOn = isAll()
    }
    
    @IBAction func didSelectButtonApply(_ sender: Any) {
        setFilterStatus()
        self.navigationController?.popViewController(animated: true)
    }
}
