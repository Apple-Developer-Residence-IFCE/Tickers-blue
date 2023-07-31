//
//  TickersView.swift
//  Tickers
//
//  Created by Ian Pacini on 30/06/23.
//

import SwiftUI

struct TickersView: View {
    @ObservedObject var viewModel: TickerViewModel
    
    let columns = [
        GridItem(.fixed(170)),
        GridItem(.fixed(170)),
    ]
    
    var body: some View {
        NavigationView{
            VStack(alignment: .leading){
                Divider()
                Text("Seus Tickers")
                    .padding(.top, 10)
                    .padding(.leading, 38)
                    .font(.tickerFont(font: .bold, size: .extraLarge)).foregroundColor(.blue)
                ScrollView {
                    LazyVGrid(columns: columns, alignment: .center) {
                        ForEach(viewModel.data, id: \.id) { item in
                            CardView(ticker: item).padding(.top, 10)
                                .onTapGesture {
                                    TickerViewModel.shared.selectTicker(id: item.id)
                                }
                            .padding(.horizontal, 5)
                        }
                    }.padding(.horizontal)
                }.frame(minWidth: 440)
                Divider()
                    .padding(.top, -9).padding(.horizontal, -30)
            }
        }
        .navigationCustom(leadingText: "Escolha um ticker", trailingText: "")
    }
}

struct TickersView_Previews: PreviewProvider {
    static var previews: some View {
        TickersView(viewModel: TickerViewModel.shared)
    }
}
