//
//  InfoDishRaw.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 16/02/22.
//

import SwiftUI

struct InfoDishRow: View { // DEPRECATED
    
    let borderColor:Color
    let fillColor:Color
    
    @State var currentDish: DishModel
    @State private var showTagliaValue:Bool = false
    @State private var currentTaglia:DishFormato = .defaultValue
 
    
    var body: some View {
          
            VStack(alignment:.leading) {

                HStack {
                    
                    CSText_tightRectangle(testo: currentDish.intestazione, fontWeight: .heavy, textColor: Color.blue, strokeColor: Color.blue, fillColor: Color.clear)
                // dal Nome Piatto accediamo all'Editing del Piatto
                    
                    Text("9.5")
                        .fontWeight(.heavy)
                        .foregroundColor(Color.yellow)
                        .padding()
                        .background(Circle().foregroundColor(Color.black.opacity(0.2)))
                 // dal Voto accediamo alle recensioni
                    
                }
           
                if !self.showTagliaValue {
                    
                    HStack {
                        
                        ForEach(currentDish.formatiDelPiatto) { taglia in

                            CSText_tightRectangle(testo: taglia.simpleDescription(), fontWeight: .bold, textColor: Color.green, strokeColor: Color.green, fillColor: Color.clear)
                                .onTapGesture {
                                    self.currentTaglia = taglia
                                    self.showTagliaValue = true
                                }
                        }
                    }
                    
                } else {

                
                    CSText_tightRectangle(testo: currentTaglia.simpleDescription(), fontWeight: .semibold, textColor: Color.white, strokeColor: Color.green, fillColor: Color.green)
                        .onTapGesture {
                            self.showTagliaValue = false
                        }
                    
                    HStack {
                        
                        CSText_RotatingRectangleDynamicDeletingFace(testo: "\(currentTaglia.showAssociatedValue().peso) gr", fontWeight: .semibold, textColor: Color.white, scaleFactor: 1.0, strokeColor: Color.yellow, fillColor: Color.yellow, showDeleteImage: false)
                            .onTapGesture {
                              /*  currentTaglia.changeAssociatedValue(currentDish: &currentDish, newValue: "2405") */ // metodo cancellato - DA RISCRIVERE
                              // performare modifica Valori Associati alla tagliaPiatto
                            }
                
                        CSText_RotatingRectangleDynamicDeletingFace(testo: "\(currentTaglia.showAssociatedValue().porzioni) pax", fontWeight: .semibold, textColor: Color.white, scaleFactor: 1.0, strokeColor: Color.brown, fillColor: Color.brown, showDeleteImage: false)
                        CSText_RotatingRectangleDynamicDeletingFace(testo: "\(currentTaglia.showAssociatedValue().prezzo) euro", fontWeight: .semibold, textColor: Color.white, scaleFactor: 1.0, strokeColor: Color.orange, fillColor: Color.orange, showDeleteImage: false)
         
                    }
                }
         
            } // end VSTACK MADRE
                 .padding()
                 .background(fillColor.cornerRadius(5.0).opacity(0.8))
    
    }
}

struct InfoDishRow_Previews: PreviewProvider {
    
    static var viewModel:AccounterVM = {
        
        var dishViewModel = AccounterVM()
        dishViewModel.allMyDish.append(testDish)
        return dishViewModel
    }()
    
    static var previews: some View {
        
        ZStack {
            Color.cyan.opacity(0.8)
            InfoDishRow(borderColor: Color.clear, fillColor: Color.black, currentDish: testDish)
        }
    }
    
   static var testDish:DishModel = {
        
        var dish = DishModel()
        dish.intestazione = "Bucatino alla Matriciana"
        dish.ingredientiPrincipali = []
        dish.ingredientiSecondari = []
        dish.categoria = .defaultValue
        dish.aBaseDi = .carneAnimale
        dish.metodoCottura = .padella
      //  dish.allergeni = [.latte_e_derivati,.uova_e_derivati]
        dish.avaibleFor = [.vegariano,.glutenFree]
        dish.formatiDelPiatto = [.unico("80", "1", "12.5"),.doppio("160", "2", "18.5")]
        
        return dish
    }()
    
    
}
