//
//  ViewController.swift
//  RegisterForm_IOS
//
//  Created by Esteban Jiménez on 2023-08-16.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {
    
    
    @IBOutlet weak var dateTextField: UITextField!
    @IBOutlet weak var genderTextField: UITextField!
    @IBOutlet weak var cvTextField: UITextField!
    @IBOutlet weak var telTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var rucTextField: UITextField!
    
    let gender = ["Masculino", "Femenino"]
    let cv = ["Soltero/a", "Casado/a", "Viudo"]
    
    var genderPickerView = UIPickerView()
    var cvPickerView = UIPickerView()
    
    
    let datePicker = UIDatePicker()
    override func viewDidLoad() {
        super.viewDidLoad()
        createDatePicker()
      
        genderTextField.inputView = genderPickerView
        cvTextField.inputView = cvPickerView
        
        genderTextField.placeholder = "Seleccione una opcion"
        cvTextField.placeholder = "Seleccione una opcion"
        
        genderTextField.textAlignment = .left
        cvTextField.textAlignment = .left
        
        genderPickerView.delegate = self
        genderPickerView.dataSource = self
        cvPickerView.delegate = self
        cvPickerView.dataSource = self
        
        genderPickerView.tag = 1
        cvPickerView.tag = 2
    }
    
    func createToolbar() ->UIToolbar{
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneBtn = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePressed))
        toolbar.setItems([doneBtn], animated: true)
        
        return toolbar
    }
   
    func createDatePicker(){
        datePicker.preferredDatePickerStyle = .wheels
        datePicker.datePickerMode = .date
        
        datePicker.maximumDate = Date()
        
        dateTextField.textAlignment = .left
        dateTextField.inputView = datePicker
        dateTextField.inputAccessoryView = createToolbar()
    }
    
    @objc func donePressed(){
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        
        self.dateTextField.text = dateFormatter.string(from: datePicker.date)
        self.view.endEditing(true)
    }
    
    func todosLosCamposCompletos() -> Bool {
        // Verifica si todos los campos requeridos tienen texto
        let camposRequeridos: [UITextField] = [dateTextField, genderTextField, cvTextField, telTextField, emailTextField, rucTextField]
        return camposRequeridos.allSatisfy { !$0.text!.isEmpty }
    }

    func mostrarAlertaCamposFaltantes() {
        let alerta = UIAlertController(title: "Campos incompletos", message: "Por favor, completa todos los campos.", preferredStyle: .alert)
        let accionAceptar = UIAlertAction(title: "Aceptar", style: .default, handler: nil)
        alerta.addAction(accionAceptar)
        present(alerta, animated: true, completion: nil)
    }
    
    func mostrarAlertaExito() {
        let alerta = UIAlertController(title: "Éxito", message: "Los datos han sido enviados correctamente.", preferredStyle: .alert)
        let accionAceptar = UIAlertAction(title: "Aceptar", style: .default, handler: nil)
        alerta.addAction(accionAceptar)
        present(alerta, animated: true, completion: nil)
    }
    
    @IBAction func sendForm(_ sender: UIButton) {
        if todosLosCamposCompletos() {
                // Aquí puedes realizar el envío del formulario
                // por ejemplo, enviar datos a un servidor, etc.

                // Mostrar una alerta de éxito
                mostrarAlertaExito()
            } else {
                mostrarAlertaCamposFaltantes()
            }
    }
    
}

extension ViewController: UIPickerViewDataSource, UIPickerViewDelegate{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        switch pickerView.tag{
        case 1:
            return gender.count
        case 2:
            return cv.count
        default:
            return 1
        }
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        switch pickerView.tag{
        case 1:
            return gender[row]
        case 2:
            return cv[row]
        default:
            return "Datos no encontrados"
        }
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch pickerView.tag{
        case 1:
            genderTextField.text = gender[row]
            genderTextField.resignFirstResponder()
        case 2:
            cvTextField.text = gender[row]
            cvTextField.resignFirstResponder()
        default:
            break
        }
    }
}


