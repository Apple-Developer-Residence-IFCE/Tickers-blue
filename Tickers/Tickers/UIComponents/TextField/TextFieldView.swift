//
//  TextFieldView.swift
//  Tickers
//
//  Created by Caio de Almeida Pessoa on 06/06/23.
//

import SwiftUI




struct TextFieldView: View {
    let title: String = "Seu nome"
    let subtitle: String = "Define como os tickers chamarão você"
    @Binding var nome: String
    
    var body: some View {
        VStack(alignment: .leading){
            Text(title)
                .font(Font.tickerFont(font: .bold, size: .xxxl))
                .foregroundColor(.blue)
            
            Text(subtitle)
                .font(Font.tickerFont(font: .bold, size: .regular))
                .padding(.bottom)
            
            TextField("Escreva aqui seu nome", text: $nome)
                .padding(.leading, 10)
                .overlay {
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color.gray, lineWidth: 0.5)
                        .frame(height: 50)
                }
            
        }//.padding(10)
    }
}

fileprivate struct TextFieldToPreview: View {
    @AppStorage("text") var text: String = ""
    
    var body: some View {
        TextFieldView(nome: $text)

    }
}

struct TextFieldView_Previews: PreviewProvider {
    static var previews: some View {
        TextFieldToPreview()
    }
}

