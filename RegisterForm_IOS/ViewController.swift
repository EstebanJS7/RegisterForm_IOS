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
    
    var activeTextField: UITextField?
    
    let datePicker = UIDatePicker()
    override func viewDidLoad() {
            super.viewDidLoad()
            createDatePicker()
            
            genderTextField.inputView = genderPickerView
            cvTextField.inputView = cvPickerView
        
            genderTextField.inputAccessoryView = createToolbar()
            cvTextField.inputAccessoryView = createToolbar()
            
            genderTextField.placeholder = "Seleccione una opción"
            cvTextField.placeholder = "Seleccione una opción"
            
            genderTextField.textAlignment = .left
            cvTextField.textAlignment = .left
            
            genderPickerView.delegate = self
            genderPickerView.dataSource = self
            cvPickerView.delegate = self
            cvPickerView.dataSource = self
            
            dateTextField.delegate = self
            genderTextField.delegate = self 
            cvTextField.delegate = self
            
            genderPickerView.tag = 1
            cvPickerView.tag = 2
            
            telTextField.keyboardType = .numberPad
            rucTextField.keyboardType = .numbersAndPunctuation
        
        }
    
        func textFieldDidBeginEditing(_ textField: UITextField) {
            activeTextField = textField
        }
        
        func createToolbar() -> UIToolbar {
            let toolbar = UIToolbar()
            toolbar.sizeToFit()
            let doneBtn = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(donePressed))
            toolbar.setItems([doneBtn], animated: true)
            
            return toolbar
        }
        
        func createDatePicker() {
            datePicker.preferredDatePickerStyle = .wheels
            datePicker.datePickerMode = .date
            
            datePicker.maximumDate = Date()
            
            dateTextField.textAlignment = .left
            dateTextField.inputView = datePicker
            dateTextField.inputAccessoryView = createToolbar()
        }
        
        @objc func donePressed() {
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .medium
            dateFormatter.timeStyle = .none

            if activeTextField == dateTextField {
                dateTextField.text = dateFormatter.string(from: datePicker.date)
            } else if activeTextField == genderTextField {
                let selectedGenderRow = genderPickerView.selectedRow(inComponent: 0)
                genderTextField.text = gender[selectedGenderRow]
            } else if activeTextField == cvTextField {
                let selectedCvRow = cvPickerView.selectedRow(inComponent: 0)
                cvTextField.text = cv[selectedCvRow]
            }
            
            activeTextField?.resignFirstResponder()
        }
        
        func todosLosCamposCompletos() -> Bool {
            // Verifica si todos los campos requeridos tienen texto
            let camposRequeridos: [UITextField] = [dateTextField, genderTextField, cvTextField, telTextField, emailTextField, rucTextField]
            return camposRequeridos.allSatisfy { !$0.text!.isEmpty }
        }
    
        func isValidPhoneNumber(_ phoneNumber: String) -> Bool {
            let phoneNumberRegex = "^09[0-9]*$"
            let phoneNumberTest = NSPredicate(format: "SELF MATCHES %@", phoneNumberRegex)
            return phoneNumberTest.evaluate(with: phoneNumber)
        }
        
        func isValidEmail(_ email: String) -> Bool {
            let emailRegex = "^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$"
            let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegex)
            return emailTest.evaluate(with: email)
        }
        
        func isValidRUC(_ ruc: String) -> Bool {
            let rucRegex = "^[0-9]+-[0-9]$"
            let rucTest = NSPredicate(format: "SELF MATCHES %@", rucRegex)
            return rucTest.evaluate(with: ruc)
        }
        
        func mostrarAlerta(titulo: String, mensaje: String) {
            let alerta = UIAlertController(title: titulo, message: mensaje, preferredStyle: .alert)
            let accionAceptar = UIAlertAction(title: "Aceptar", style: .default, handler: nil)
            alerta.addAction(accionAceptar)
            present(alerta, animated: true, completion: nil)
        }
        
        func validarCampos() -> Bool {
            var camposValidos = true
            
            let telefono = telTextField.text ?? ""
            let email = emailTextField.text ?? ""
            let ruc = rucTextField.text ?? ""
            
            if !isValidPhoneNumber(telefono) {
                mostrarAlerta(titulo: "Teléfono inválido", mensaje: "El número de teléfono debe comenzar con '09' y contener solo dígitos.")
                camposValidos = false
            }
            
            if !isValidEmail(email) {
                mostrarAlerta(titulo: "Correo inválido", mensaje: "Por favor, ingresa un correo electrónico válido.")
                camposValidos = false
            }
            
            if !isValidRUC(ruc) {
                mostrarAlerta(titulo: "RUC inválido", mensaje: "El RUC debe tener el formato correcto, por ejemplo: 4648961-6.")
                camposValidos = false
            }
            
            return camposValidos
        }
        
    
    
    @IBAction func sendForm(_ sender: UIButton) {
        if todosLosCamposCompletos() {
                   if validarCampos() {
                       mostrarAlerta(titulo: "Éxito", mensaje: "Los datos han sido enviados correctamente.")
                   }
               } else {
                   mostrarAlerta(titulo: "Campos incompletos", mensaje: "Por favor, completa todos los campos.")
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
            cvTextField.text = cv[row]
            cvTextField.resignFirstResponder()
        default:
            break
        }
    }
}


