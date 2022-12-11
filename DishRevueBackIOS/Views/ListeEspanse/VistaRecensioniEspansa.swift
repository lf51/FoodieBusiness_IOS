//
//  VistaRecensioniEspansa.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 21/10/22.
//

import SwiftUI
import MyPackView_L0
import MyFoodiePackage

struct VistaRecensioniEspansa: View {
    
    @EnvironmentObject var viewModel:AccounterVM
    let backgroundColorView:Color
    
    var body: some View {
        
        CSZStackVB(title: "Monitor Recensioni", backgroundColorView: backgroundColorView) {
            
            VStack(alignment:.leading) {
                
                let element = mapValue().enumerated()
                
                CSDivider()
                
                ScrollView(showsIndicators:false) {
                    
                    ForEach(Array(element),id:\.element) { position,element in
 
                    RevRowLocal(mapDish: element)
                            .padding(.bottom,5)
                            .overlay(alignment: .topLeading) {
                                if position <= 2 {
                                    Text(csRatingMedalReward(position: position))
                                        .offset(x: -5)
                                }
                            }
                        
                    }
                    
                }
                
                CSDivider()
            }
            .padding(.horizontal)
        }
        
        
    }
    
    // method
    
    private func mapValue() -> [DishModel] {
        
        let element = self.viewModel.allMyReviews
        
        let mapElement = element.map({$0.rifPiatto})
        let uniqueMapEl = Array(Set(mapElement))
        let allDishUsed = self.viewModel.modelCollectionFromCollectionID(collectionId: uniqueMapEl, modelPath: \.allMyDish)
        
        let sortElement = allDishUsed.sorted(by: {

            $0.topRatedValue(readOnlyVM: self.viewModel) > $1.topRatedValue(readOnlyVM: self.viewModel)
            
        })
        
        return sortElement
        
    }
    
}

struct VistaRecensioniEspansa_Previews: PreviewProvider {
    static var previews: some View {
        VistaRecensioniEspansa(backgroundColorView: Color("SeaTurtlePalette_1"))
    }
}

private struct RevRowLocal:View {
    
    @EnvironmentObject var viewModel:AccounterVM
    
    let mapDish:DishModel
    @State private var showRev:Bool? = nil
  
    
    var body: some View {
        
        VStack(alignment:.leading) {
            
            HStack {
                
                DishModel_RowView(item: mapDish, rowSize: .sintetico)
                
                Spacer()
                
                HStack {
                    
                    CSButton_image(
                        frontImage: "pencil.and.ruler",
                        imageScale: .medium,
                        frontColor: Color.white) {
                            withAnimation {
                                actionLogic(value: false)
                            }
                    }
                        ._tightPadding()
                        .background(
                            Circle()
                                .fill(Color("SeaTurtlePalette_1").opacity(0.5))
                                .shadow(radius: 5.0)
                    )
                    
                    Spacer()
                    
                    CSButton_image(
                        frontImage: "books.vertical",
                        imageScale: .medium,
                        frontColor: Color.white) {
                            withAnimation {
                                actionLogic(value: true)
                            }
                    }
                        ._tightPadding()
                        .background(
                            Circle()
                                .fill(Color("SeaTurtlePalette_2").opacity(0.5))
                                .shadow(radius: 5.0)
                    )
                
                    
                }
    
                
            }
            
            if showRev != nil {
                
                if showRev! {
                    
                    let allDishrev = reviewValue(dish: mapDish)
                    
                    ScrollView(.horizontal,showsIndicators: false) {
                        
                        HStack {
                            
                            ForEach(allDishrev) { review in
                                DishRating_RowView(rating: review)
                            }
                        }
                        
                    }
                    
                } else {
                    
                    ReviewStatMonitor(singleDishRif: mapDish.rifReviews) {
                        Group {
                            Text("Statistica Recensioni")
                                  .font(.system(.headline, design: .monospaced, weight: .black))
                                  .foregroundColor(Color("SeaTurtlePalette_2"))
                            Spacer()
                        }
                    } extraContent:{ EmptyView() }
                    
                }
                
            } //
            
            
            
        }
    }
    
    // Method
    
    private func actionLogic(value:Bool) {
        
        if self.showRev == nil || self.showRev != value { self.showRev = value }
        else { self.showRev = nil }
        
    }
    
    private func reviewValue(dish:DishModel) -> [DishRatingModel] {
        
        let allRif = dish.rifReviews
        let allRev = self.viewModel.modelCollectionFromCollectionID(collectionId: allRif, modelPath: \.allMyReviews)
        let sortElement = allRev.sorted(by: {$0.dataRilascio > $1.dataRilascio})
        
        return sortElement
        
    }
    
}


