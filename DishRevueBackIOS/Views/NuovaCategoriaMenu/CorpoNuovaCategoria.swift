//
//  CorpoNuovaCategoria.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 15/09/23.
//

import SwiftUI
import MyFoodiePackage
import MyPackView_L0

struct CorpoNuovaCategoria:View {
    
    @Binding var nuovaCategoria: CategoriaMenu
    @Binding var editCase:SwitchCategoryEditCase?
    let categoriaArchiviata: CategoriaMenu
    let creAction: () -> Void
    
    // 17.02.23 Focus State
    @FocusState private var modelField:ModelField?
        
    var body: some View {
        
        let value:(isDisabled:Bool,opacity:CGFloat) = {
         
           // --> nuova
           // disabilita se manca intestazione ed emoji
            
            // --> modificata
            // disabilita se manca la descrizione
            
            guard self.nuovaCategoria.intestazione != "" else { return (true,0.6)}

            if self.nuovaCategoria == categoriaArchiviata { return (true,0.6)}
            else { return (false,1.0) }
      
        }() // vedi NotaVocale 14.09
        
        VStack(alignment:.leading) {
            
            ScrollView(.horizontal,showsIndicators: false) {
                
                HStack(spacing:15) {
                    
                    ForEach(csReturnEmojyCollection(),id:\.self) { emojy in
                        
                        Text(emojy)
                            .font(.title)
                            .onTapGesture {
                               // self.image = emojy
                                self.nuovaCategoria.image = emojy
                            }
    
                    }
                }
                
            }
            .padding(.vertical,5)
            .scrollDismissesKeyboard(.immediately)
            .opacity(editCase?.disableCreaField ?? false ? 0.6 : 1.0)
            .disabled(editCase?.disableCreaField ?? false)

                    CSTextField_4b(
                        textFieldItem: $nuovaCategoria.intestazione,
                        placeHolder: "Nome Categoria",
                        showDelete: true) {
                            csVbSwitchImageText(string: self.nuovaCategoria.image, size: .large)
                                .padding(.leading,10)
                        }
                        .focused($modelField,equals: .intestazione)
                        .opacity(editCase?.disableCreaField ?? false ? 0.6 : 1.0)
                        .disabled(editCase?.disableCreaField ?? false)
    
                BoxDescriptionModel_Generic(
                    itemModel: $nuovaCategoria,
                    labelString: "Descrizione (Optional)",
                    disabledCondition: false,
                    backgroundColor: .seaTurtle_3,
                    modelField: $modelField)
                .focused($modelField, equals: .descrizione)
                .fixedSize(horizontal: false, vertical:true)
                    
                    Button(action: {
                        
                        creAction()
                        
                    }, label: {
                        HStack {
                            
                           Spacer()
                            
                            Text(editCase?.addButton ?? "No_Action")
                                .fontWeight(.semibold)
                                .font(.system(.body, design: .rounded))
                                .padding(.vertical,10)
                                .foregroundStyle(Color.seaTurtle_4)
                            
                            Spacer()
                        }
                        .background(Color.seaTurtle_2)
                        .cornerRadius(5.0)
                    })
                        .opacity(value.opacity)
                        .disabled(value.isDisabled)
 
        }

    
    }

}
/*
#Preview {
    CorpoNuovaCategoria()
}*/
