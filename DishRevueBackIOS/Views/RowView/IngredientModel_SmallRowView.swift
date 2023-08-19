//
//  IngredientModel_SmallRowView.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 11/09/22.
//

import SwiftUI
import MyPackView_L0
import MyFoodiePackage

// 22.06.23 Deprecata in futuro - inserendola nell'ingredientModelRow con uno switch, come fatto per il dish e il menu
struct IngredientModel_SmallRowView: View {

    @EnvironmentObject var viewModel: AccounterVM
    @State private var currentModel:IngredientModel
    
    let titolare:IngredientModel
    let sostituto:IngredientModel?
    
    init(titolare:IngredientModel, sostituto:IngredientModel?) {
        
        self.titolare = titolare
        self.sostituto = sostituto
        _currentModel = State(wrappedValue: titolare)
        
    }
    
    var body: some View {
        
        let isDisponibile = self.currentModel.status.checkStatusTransition(check: .disponibile)
        let itemIsModel = self.currentModel == self.titolare
        
        let value:(opacity:CGFloat,blur:CGFloat) = {
           
            if isDisponibile { return (1.0,0.0) }
            else { return (0.5,1.0) }
            
        }()

        CSZStackVB_Framed(frameWidth:300) {
 
            VStack(alignment:.leading,spacing:5) {
                
                    vbIntestazioneIngrediente(itemIsModel: itemIsModel)
                
                    vbAllergeneScrollRowView(listaAllergeni: self.currentModel.allergeni)
                    .overlay(alignment: .trailing) {
                        
                        HStack(spacing:4) {
                            
                          //  if self.currentModel.conservazione != .altro {
                                
                                csVbSwitchImageText(string: self.currentModel.conservazione.imageAssociated(), size: .large)
                                   .padding(2.0)
                                   .background(
                                        Color.seaTurtle_2
                                            .cornerRadius(5.0)
                                            .opacity(0.4)
                                            )
                          //  }

                            let(image,size) = self.currentModel.associaImmagine()
                            
                            csVbSwitchImageText(string: image,size: size)
                                .padding(2.0)
                                .background(
                                    Color.seaTurtle_1
                                        .cornerRadius(5.0)
                                        .opacity(0.6))
                        }
                    }
                
            //   Spacer()
     
            } // chiuda VStack madre
            .padding(.vertical,5)
            .padding(.horizontal,10)
            
        } // chiusa Zstack Madre
        .opacity(value.opacity)
        .blur(radius: value.blur)
        .overlay {
            
            VStack {
                
                if !isDisponibile {
                    
                    Text("_: \(self.currentModel.status.simpleDescription())")
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
            }.foregroundColor(sostituto != nil ? Color.seaTurtle_3 : Color.black)
        }
        .onTapGesture {
            if sostituto != nil {
                withAnimation {
                    self.currentModel = itemIsModel ? sostituto! : titolare
                    }
                }
            }
    }
    
    // Method
            
    @ViewBuilder private func vbIntestazioneIngrediente(itemIsModel:Bool) -> some View {
        
        let dashedColor = self.viewModel.currentProperty.inventario.statoScorteIng(idIngredient: self.currentModel.id).coloreAssociato()
        
        HStack(alignment:.lastTextBaseline) {
            
            Text(self.currentModel.intestazione)
                .font(.title3)
                .fontWeight(.semibold)
                .lineLimit(1)
                .allowsTightening(true)
                .foregroundColor(Color.white)
                .overlay(alignment:.topTrailing) {
                    
                    if self.currentModel.produzione == .biologico {
                        
                        Text("Bio")
                            .font(.system(.caption2, design: .monospaced, weight: .black))
                            .foregroundColor(Color.green)
                            .offset(x: 10, y: -4)
                    }
                }
            
          //  csVbSwitchImageText(string: self.item.associaImmagine(),size: .large)
            
            Spacer()
            
            if itemIsModel {
                vbEstrapolaStatusImage(
                    itemModel: self.currentModel,
                    dashedColor: dashedColor)
            }
            
            else {
                Image(systemName: "arrow.left.arrow.right.circle.fill")
                    .imageScale(.large)
                    .foregroundColor(Color.seaTurtle_3)
            }
            
            
        }
        
    }
    
    
    
}


struct IngredientModel_SmallRowView_Previews: PreviewProvider {
   @State static var vm = {
       let user = UserRoleModel()
       var viewM = AccounterVM(from: initServiceObject)
       viewM.currentProperty.db.allMyIngredients = [ ing1]
        return viewM
    }()
    static var ing1 = {
        var ing = IngredientModel()
        ing.intestazione = "Guanciale"
        ing.status = .bozza(.disponibile)
        ing.conservazione = .congelato
        ing.allergeni = [ .arachidi_e_derivati ]
        ing.origine = .animale
        ing.produzione = .biologico
        ing.provenienza = .italia
        return ing
        
    }()
    
    static var previews: some View {
        
        CSZStackVB(title: "Test", backgroundColorView: Color.seaTurtle_1) {
            VStack {
                IngredientModel_SmallRowView(titolare: ing1, sostituto: nil)
             
            }.frame(height:150)
        }.environmentObject(vm)
    }
}

