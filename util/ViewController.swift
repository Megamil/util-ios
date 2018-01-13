//
//  ViewController.swift
//  util
//
//  Created by Eduardo dos santos on 13/01/2018.
//  Copyright © 2018 Eduardo dos santos. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var nav: UINavigationBar!
    @IBOutlet weak var valor: UITextField!
    @IBOutlet weak var cpf: UITextField!
    @IBOutlet weak var email: UITextField!
    
    
    var aviso : UIAlertController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fecharTeclado()
    }

    @IBAction func deixarTransparente(_ sender: Any) {
        nav.isTransparent()
    }
    
    @IBAction func testarTudo(_ sender: Any) {
        
        aviso = avisoCarregando(titulo: "Aguarde", descricao: "Fazendo Café")
        
        var avisos : String! = ""
    
        //Verificando conexão com a Internet
        if(ValidarConexao()){
            avisos = "\(avisos!) Com conexão"
        } else {
            avisos = "\(avisos!) Sem conexão"
        }
        
        //Verificando o campo CPF
        if(cpf!.text?.isValidoCPF)! {
            avisos = "\(avisos!) CPF Válido"
        } else {
            avisos = "\(avisos!) CPF Inválido"
        }
        
        //Verificando o campo E-mail
        if(email!.text?.isValidoEmail())! {
            avisos = "\(avisos!) E-mail Válido"
        } else {
            avisos = "\(avisos!) E-mail Inválido"
        }
        
        //Aplicando mascara R$
        valor!.text = valor!.text?.formatCurrency()
        print("Aplicando mascara R$ \(valor!.text)")
        
        aviso.dismiss(animated: true, completion: {
            self.avisoToast(avisos!, posicao: 2, altura: 100, tipo: 1)
            
            print(avisos)
        })
        
    }
    
}

