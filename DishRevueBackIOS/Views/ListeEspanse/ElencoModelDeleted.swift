//
//  ElencoModelDeleted.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 02/12/22.
//

import SwiftUI
import MyPackView_L0

struct ElencoModelDeleted: View {
    
    @EnvironmentObject var viewModel:AccounterVM
    let backgroundColorView: Color
    
    var body: some View {
        
        CSZStackVB(title:"Trash", backgroundColorView: backgroundColorView) {
            
            VStack(alignment:.leading) {
                
              //  CSDivider()
                let today = csTimeFormatter().data.string(from: Date())
                let allValue = self.viewModel.remoteStorage.modelRif_deleted.enumerated()
                
                HStack {
                    Spacer()
                    Text(today)
                       // .italic()
                        .fontWeight(.black)
                        .font(.subheadline)
                        .foregroundColor(Color("SeaTurtlePalette_2"))
                  
                  //  Spacer()
                }
                
                ScrollView(showsIndicators:false) {
                    
                    ForEach(Array(allValue),id:\.element.key) { position, dictionary in
                        
                        VStack(alignment:.leading,spacing:5) {
                            
                            HStack(alignment:.bottom) {
                                Text("\(position + 1).")
                                    .font(.system(.headline, design: .monospaced, weight: .bold))
                                    .foregroundColor(Color.gray)

                                Text(dictionary.value)
                                    .font(.system(.headline, design: .monospaced, weight: .bold))
                                    .foregroundColor(Color.black.opacity(0.7))
                            
                                
                            }
                            
                            Text(dictionary.key)
                                .italic()
                                .font(.system(.caption2, design: .default, weight: .light))
                                .foregroundColor(Color.black.opacity(0.8))
                            
                            
                            Divider()
                        }
                        .overlay(alignment: .trailing) {
                            Button {
                                // Nota 02.12.22
                            } label: {
                                Text("Undo")
                                    .font(.system(.headline, design: .monospaced, weight: .black))
                                    .foregroundColor(Color.green)
                            }
                            .opacity(0.5)
                            .disabled(true)
                            

                        }
                    }
                }
            }
            .padding(.horizontal)
        }
    }
    
}

struct ElencoModelDeleted_Previews: PreviewProvider {
    static var previews: some View {
       
        NavigationStack {
            ElencoModelDeleted(backgroundColorView: Color("SeaTurtlePalette_1"))
        }
            .environmentObject(testAccount)
    }
}
