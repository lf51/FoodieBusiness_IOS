//
//  InfoDishRaw.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 16/02/22.
//

import SwiftUI

struct InfoDishRow: View {
    
   // @ObservedObject var dishVM: DishVM
 //   let currentDishIndexPosition: Int
    let borderColor:Color
    let fillColor:Color
    
    @State var currentDish: DishModel // Se vogliamo effettuare modifiche sul piatto, dobbiamo recuperare il piatto dal ViewModel, cosa che facevamo passando l'index, ma che le modifiche alla View Madre hanno reso nonFattibile e per cui dobbiamo recuperarlo qui in stile FantaBid cercando però di essere più efficienti. AL MOMENTO NON MODIFICA I DATI MA LI MOSTRA
    @State private var showTagliaValue:Bool = false
    @State private var currentTaglia:DishSpecificValue = .defaultValue
    
  /*  init (dishVM:DishVM,currentDishIndexPosition:Int,borderColor:Color,fillColor:Color) {
        
        self.dishVM = dishVM
        self.currentDishIndexPosition = currentDishIndexPosition
        self.currentDish = dishVM.dishList[currentDishIndexPosition]
        self.borderColor = borderColor
        self.fillColor = fillColor
    } */
    
    // Modificare i valori Associati al DishSpecificValue
    @State private var peso: String = ""
    @State private var pax: String = ""
    @State private var price: String = ""
    
    var body: some View {

       // ZStack {
            
            VStack(alignment:.leading) {

                HStack {
                    
                    CSText_tightRectangle(testo: currentDish.name, fontWeight: .heavy, textColor: Color.blue, strokeColor: Color.blue, fillColor: Color.clear)

                    
                    Text("9.5")
                        .fontWeight(.heavy)
                        .foregroundColor(Color.yellow)
                        .padding()
                        .background(Circle().foregroundColor(Color.black.opacity(0.2)))
                        
                }
                
                
               
                
                if !self.showTagliaValue {
                    
                    HStack {
                        
                        ForEach(currentDish.tagliaPiatto) { taglia in

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
                        
                        CSText_RotatingRectangle(testo: "\(currentTaglia.iterateTaglie().peso) gr", fontWeight: .semibold, textColor: Color.white, scaleFactor: 1.0, strokeColor: Color.yellow, fillColor: Color.yellow, showDeleteImage: false)
                            .onTapGesture {
                                currentTaglia.changeAssociatedValue(currentDish: &currentDish, newValue: "2405")
                              // performare modifica Valori Associati alla tagliaPiatto
                            }
                
                        CSText_RotatingRectangle(testo: "\(currentTaglia.iterateTaglie().porzioni) pax", fontWeight: .semibold, textColor: Color.white, scaleFactor: 1.0, strokeColor: Color.brown, fillColor: Color.brown, showDeleteImage: false)
                        CSText_RotatingRectangle(testo: "\(currentTaglia.iterateTaglie().prezzo) euro", fontWeight: .semibold, textColor: Color.white, scaleFactor: 1.0, strokeColor: Color.orange, fillColor: Color.orange, showDeleteImage: false)
         
                    }
                }
         
            } // end VSTACK MADRE
                 .padding()
                 .background(fillColor.cornerRadius(5.0).opacity(0.8))
                /* .overlay(
                    Text("9.5")
                        .fontWeight(.heavy)
                        .foregroundColor(Color.yellow)
                        .padding()
                        .background(Circle().foregroundColor(Color.black.opacity(0.6)))
                        .position(x: 0, y: 0)
                 ) */
            
            
            
            
      //  } // end ZStack
       // .padding()
        //.background(fillColor.cornerRadius(5.0).opacity(0.8))
      //  ._tightPadding()
       // .background(borderColor.cornerRadius(5.0).opacity(0.8))
        
        
        
    }
}

struct InfoDishRow_Previews: PreviewProvider {
    
    static var dishVM:DishVM = {
        
        var dishViewModel = DishVM()
        dishViewModel.dishList.append(testDish)
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
        dish.name = "Bucatino alla Matriciana"
        dish.ingredientiPrincipali = ["Pasta di grano Duro","Guanciale","Pecorino Romano DOP", "Tuorlo d'Uovo BIO",]
        dish.ingredientiSecondari = ["Pepe Nero", "Prezzemolo"]
        dish.type = .primo
        dish.aBaseDi = .carne
        dish.metodoCottura = .padella
        dish.allergeni = [.latte_e_derivati,.uova_e_derivati]
        dish.category = [.milkFree,.glutenFree]
        dish.tagliaPiatto = [.unico("80", "1", "12.5"),.doppio("160", "2", "18.5")]
        
        return dish
    }()
    
    
}
