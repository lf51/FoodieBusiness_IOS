//
//  IngredientModel_SmallRowView.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 11/09/22.
//

import SwiftUI

struct IngredientModel_SmallRowView: View {

    @EnvironmentObject var viewModel: AccounterVM
    @State private var item:IngredientModel
    
    let model:IngredientModel
    let sostituto:IngredientModel?
    
    init(model:IngredientModel, sostituto:IngredientModel?) {
        
        self.model = model
        self.sostituto = sostituto
        _item = State(wrappedValue: model)
        
    }
    
    var body: some View {
        
        let isDisponibile = self.item.status.checkStatusTransition(check: .disponibile)
        let itemIsModel = self.item == self.model
        
        let value:(opacity:CGFloat,blur:CGFloat) = {
           
            if isDisponibile { return (1.0,0.0) }
            else { return (0.5,1.0) }
            
        }()

        CSZStackVB_Framed(frameWidth:300) {
 
            VStack(alignment:.leading,spacing:5) {
                
                    vbIntestazioneIngrediente(itemIsModel: itemIsModel)
                    vbAllergeneScrollRowView(listaAllergeni: self.item.allergeni)
                    .overlay(alignment: .trailing) {
                        
                        HStack(spacing:4) {
                            
                            if self.item.conservazione != .altro {
                                csVbSwitchImageText(string: self.item.conservazione.imageAssociated(), size: .large)
                                    .padding(2.0)
                                    .background(
                                        Color("SeaTurtlePalette_2")
                                            .cornerRadius(5.0)
                                            )
                            }

                            csVbSwitchImageText(string: self.item.associaImmagine(),size: .large)
                                .padding(2.0)
                                .background(
                                    Color("SeaTurtlePalette_1")
                                        .cornerRadius(5.0)
                                        .opacity(0.6))
                        }
                    }
                
               Spacer()
     
            } // chiuda VStack madre
            .padding(.top,5)
            .padding(.horizontal)
            
        } // chiusa Zstack Madre
        .opacity(value.opacity)
        .blur(radius: value.blur)
        .overlay {
            
            VStack {
                
                if !isDisponibile {
                    
                    Text("_: \(self.item.status.simpleDescription())")
                        .textCase(.uppercase)
                        .bold()
                        .font(.title3)
                }
                
                if sostituto != nil && itemIsModel {
                    
                    HStack {
                        Image(systemName: "eye")
                            .imageScale(.medium)
                        Text("Mostra Sostituto")
                            .font(.body)
                    }
                    
                }
            }.foregroundColor(sostituto != nil ? Color("SeaTurtlePalette_3") : Color.black)
        }
        .onTapGesture {
            if sostituto != nil {
                withAnimation {
                    self.item = itemIsModel ? sostituto! : model
                    }
                }
            }
    }
    
    // Method
            
    @ViewBuilder private func vbIntestazioneIngrediente(itemIsModel:Bool) -> some View {
        
        HStack(alignment:.lastTextBaseline) {
            
            Text(self.item.intestazione)
                .font(.title2)
                .fontWeight(.semibold)
                .lineLimit(1)
                .allowsTightening(true)
                .foregroundColor(Color.white)
                .overlay(alignment:.topTrailing) {
                    
                    if self.item.produzione == .biologico {
                        
                        Text("Bio")
                            .font(.system(.caption2, design: .monospaced, weight: .black))
                            .foregroundColor(Color.green)
                            .offset(x: 10, y: -4)
                    }
                }
            
          //  csVbSwitchImageText(string: self.item.associaImmagine(),size: .large)
            
            Spacer()
            
            if itemIsModel {
                vbEstrapolaStatusImage(itemModel: self.item)
            }
            
            else {
                Image(systemName: "arrow.left.arrow.right.circle.fill")
                    .imageScale(.large)
                    .foregroundColor(Color("SeaTurtlePalette_3"))
            }
            
            
        }
        
    }
    
    
    
}

/*
struct IngredientModel_SmallRowView_Previews: PreviewProvider {
    static var previews: some View {
        IngredientModel_SmallRowView()
    }
} */
