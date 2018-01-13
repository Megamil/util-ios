import Foundation
import UIKit
import SystemConfiguration

extension UINavigationBar{
    /*
     ------------------------------------
     Adicionar transparencia a navigation
     ------------------------------------
     */
    func isTransparent(){
        
        let nav : UINavigationBar = self
        //Caso UINavigationController
        //let nav : UINavigationBar = self.navigationBar
        
        nav.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        nav.shadowImage = UIImage()
        nav.isTranslucent = true
        nav.backgroundColor = UIColor.clear
        
    }
    
    
} // Fim extensões - UINavigationController (Pode ser aplicada) / UINavigationBar

extension String{
    /*
     ------------------------------------
     formatar double ja adicionando R$ e adicionando casas apos a ","
     ------------------------------------
     */
    func formatCurrency() -> String{
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.maximumFractionDigits = 2
        formatter.locale = Locale(identifier: "pt_BR")
        
        let value : Double = Double(self)!
        
        let result = formatter.string(from: value as NSNumber)
        return result!
    }
    
    /*
     ------------------------------------
     função para validar o CPF.
     ------------------------------------
     */
    var isValidoCPF: Bool {
        
        let numbers = characters.flatMap({Int(String($0))})
        guard numbers.count == 11 && Set(numbers).count != 1 else { return false }
        
        let soma1 = 11 - ( numbers[0] * 10 +
            numbers[1] * 9 +
            numbers[2] * 8 +
            numbers[3] * 7 +
            numbers[4] * 6 +
            numbers[5] * 5 +
            numbers[6] * 4 +
            numbers[7] * 3 +
            numbers[8] * 2 ) % 11
        
        let dv1 = soma1 > 9 ? 0 : soma1
        
        let soma2 = 11 - ( numbers[0] * 11 +
            numbers[1] * 10 +
            numbers[2] * 9 +
            numbers[3] * 8 +
            numbers[4] * 7 +
            numbers[5] * 6 +
            numbers[6] * 5 +
            numbers[7] * 4 +
            numbers[8] * 3 +
            numbers[9] * 2 ) % 11
        
        let dv2 = soma2 > 9 ? 0 : soma2
        
        return dv1 == numbers[9] && dv2 == numbers[10]
    }
    
    /*
     ------------------------------------
     funcao para validar o E-mail.
     ------------------------------------
     */
    func isValidoEmail() -> Bool {
        
        let regex = try! NSRegularExpression(pattern: "(?:[a-z0-9!#$%\\&'+/=?\\^_`{|}~-]+(?:\\.[a-z0-9!#$%\\&'+/=?\\^_`{|}"+"~-]+)|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\"+"x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])\")@(?:(?:[a-z0-9](?:[a-"+"z0-9-][a-z0-9])?\\.)+[a-z0-9](?:[a-z0-9-][a-z0-9])?|\\[(?:(?:25[0-5"+"]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-"+"9][0-9]?|[a-z0-9-]*[a-z0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21"+"-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])", options: .caseInsensitive)
        return regex.firstMatch(in: self, options: [], range: NSRange(location: 0, length: self.count)) != nil
        
    }
    
}// Fim extensões - String


extension UIViewController{
    /*
     ------------------------------------
     funcao de fechar o teclado, devera ser chamada no didLoad
     ------------------------------------
     */
    func fecharTeclado(){
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(fechar))
        tap.numberOfTapsRequired = 1
        view.addGestureRecognizer(tap)
        
    }
    
    @objc func fechar(){
        view.endEditing(true)
    }
    
     /*
     ------------------------------------
        funcao para validar se existe conexão com a internet
     ------------------------------------
     */
    func ValidarConexao() -> Bool {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout.size(ofValue: zeroAddress))
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        let defaultRouteReachability = withUnsafePointer(to: &zeroAddress) {
            $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        
        var flags = SCNetworkReachabilityFlags()
        if !SCNetworkReachabilityGetFlags(defaultRouteReachability!, &flags) {
            return false
        }
        let isReachable = flags.contains(.reachable)
        let needsConnection = flags.contains(.connectionRequired)
        return (isReachable && !needsConnection)
    }
    
     /*
     ------------------------------------
     Aviso quando carrega, retorna uma UIAlertController para ser encerrado por lá (Mensagem com activity)
     ------------------------------------
     */
    func avisoCarregando(titulo:String,descricao:String) -> UIAlertController {
        
        let aviso = UIAlertController(title: titulo, message: descricao, preferredStyle: .alert)
        
        let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50))
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.gray
        loadingIndicator.startAnimating();
        
        aviso.view.addSubview(loadingIndicator)
        present(aviso, animated: true, completion: nil)
        
        return aviso
        
    }
    
     /*
     ------------------------------------
     Aviso parecido com o do android,
        Altura 1 rodapé, 2 centro, 3 topo
        Tipo 1 success, 2  info, 3 Warning, 4 Danger,
     ------------------------------------
     */
    
    func avisoToast(_ aviso: String, posicao: Int, altura: CGFloat, tipo: Int) {
        var toastLabel : UILabel!
        
        switch posicao {
        case 1:
            print("avisoToast Rodapé")
            toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - 150, y: 75, width: 300, height: altura))
            break
        case 2:
            print("avisoToast Centro")
            toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - 150, y: self.view.frame.size.height/2 - (altura/2), width: 300, height: altura))
            break
        default:
            print("avisoToast Topo")
            toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - 150, y: self.view.frame.size.height - 150, width: 300, height: altura))
        }
        
        toastLabel.textColor = UIColor.white
        
        switch tipo {
        case 1:
            print("avisoToast Sucesso")
            toastLabel.backgroundColor = UIColor.green
            toastLabel.textColor = UIColor.black
            break
        case 2:
            print("avisoToast Info")
            toastLabel.backgroundColor = UIColor.blue
            break
        case 3:
            print("avisoToast Warning")
            toastLabel.backgroundColor = UIColor.yellow
            toastLabel.textColor = UIColor.black
            break
        default:
            print("avisoToast Danger")
            toastLabel.backgroundColor = UIColor.red
            break
        }
        
        toastLabel.textAlignment = NSTextAlignment.center;
        self.view.addSubview(toastLabel)
        toastLabel.text = aviso
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10;
        toastLabel.adjustsFontSizeToFitWidth = true
        toastLabel.clipsToBounds  =  true
        UIView.animate(withDuration: 4, delay: 0.1, options: .curveEaseInOut, animations: {
            
            toastLabel.alpha = 0.0
            
        }, completion: nil)
        
    }
    
} // Fim extensões - UIViewController


/*
------------------------------------
    Mudando qualidade das imagens
------------------------------------
 TODO: Usar num exemplo
*/

extension UIImage {
    var qualidadeMaxima: NSData { print("Qualidade Máxima"); return UIImageJPEGRepresentation(self, 1.0)!  as NSData}
    var qualidadeAlta:   NSData { print("Qualidade Alta");   return UIImageJPEGRepresentation(self, 0.75)! as NSData}
    var qualidadeMedia:  NSData { print("Qualidade Média");  return UIImageJPEGRepresentation(self, 0.5)!  as NSData}
    var qualidadeBaixa:  NSData { print("Qualidade Baixa");  return UIImageJPEGRepresentation(self, 0.25)! as NSData}
    var qualidadeMinima: NSData { print("Qualidade Mínima"); return UIImageJPEGRepresentation(self, 0.0)!  as NSData}
} // Fim extensões - UIImage
