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
    
    @State private var frames:[CGRect] = []
    
    var body: some View {
        
        CSZStackVB(
            title: "Monitor Recensioni",
            backgroundColorView: backgroundColorView) {
            
                VStack(alignment:.leading) {
                
                let element = mapValue().enumerated()
                
                CSDivider()
                
                ScrollView(showsIndicators:false) {
                    
                    VStack(spacing: .vStackBoxSpacing) {
                        
                        ForEach(Array(element),id:\.element) { position,element in
     
                        RevRowLocal(
                            mapDish: element,
                            position: position,
                            frames: $frames,
                            coordinateSpaceName: "MainScrollReview")
                              // .padding(.bottom,5)
                              /*  .overlay(alignment: .topLeading) {
                                    if position <= 2 {
                                        Text(csRatingMedalReward(position: position))
                                            .offset(x: -5)
                                    }
                                } */
                            
                        }
                    }
                    
                }
                .csCornerRadius(5.0, corners: [.topLeft,.topRight])
                .coordinateSpace(name: "MainScrollReview")
                .onPreferenceChange(FramePreference.self, perform: {
                                frames = $0.sorted(by: { $0.minY < $1.minY })
                            })
                
                CSDivider()
            }
            .csHpadding()
            //.padding(.horizontal)
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
        
        NavigationStack {
           VistaRecensioniEspansa(backgroundColorView: .seaTurtle_1)
        }
        .environmentObject(testAccount)
        
    }
}

private struct RevRowLocal:View {
    
    @EnvironmentObject var viewModel:AccounterVM
    
    let mapDish:DishModel
    let position:Int
   // @State private var showRev:Bool? = nil
    @State private var showStat:Bool = false
    @State private var showRev:Bool = false
    
    @Binding var frames:[CGRect]
    let coordinateSpaceName:String

    var body: some View {
        
        VStack(alignment:.leading,spacing: .vStackLabelBodySpacing) {
            
            let rifReviews = self.mapDish.rifReviews
            
            VStack(spacing:.vStackLabelBodySpacing) {
                
                HStack {
                    
                    DishModel_RowView(item: mapDish, rowSize: .sintetico)
                        .overlay(alignment: .topLeading) {
                            
                            if position <= 2 {
                                Text(csRatingMedalReward(position: position))
                                    .offset(x: -5)
                            }
                        }
                     
                    Spacer()
                    
                    HStack(spacing:10) {
                        
                        CSButton_image(
                            frontImage: "pencil.and.ruler",
                            imageScale: .medium,
                            frontColor: Color.white) {
                                withAnimation {
                                   // actionLogic(value: false)
                                    self.showStat.toggle()
                                }
                        }
                            ._tightPadding()
                            .background(
                                Circle()
                                    .fill(Color.seaTurtle_1.opacity(0.5))
                                    .shadow(radius: 5.0)
                        )
                        
                     //   Spacer()
                        
                        CSButton_image(
                            frontImage: "books.vertical",
                            imageScale: .medium,
                            frontColor: Color.white) {
                                withAnimation {
                                   // actionLogic(value: true)
                                    self.showRev.toggle()
                                }
                        }
                            ._tightPadding()
                            .background(
                                Circle()
                                    .fill(Color.seaTurtle_2.opacity(0.5))
                                    .shadow(radius: 5.0)
                        )
                    }
                }
                
                if self.showStat {
                    
                    ReviewStatMonitor(
                        singleDishRif: rifReviews) {
                       // Group {
                            Text("Statistica Recensioni")
                                  .font(.system(.headline, design: .monospaced, weight: .black))
                                  .foregroundColor(.seaTurtle_2)
                           // Spacer()
                       // }
                    } extraContent:{ EmptyView() }
                }
                
            }// vstack sticky
            .csSticky(frames,
                    coordinateSpace: coordinateSpaceName,
                    customBackground: Color.seaTurtle_1.opacity(0.90),
                    customBackgroundCornerRadius: 5.0 )
           
            if showRev {
                
               // let allDishrev = reviewValue(dish: mapDish)
                let allDishrev = self.viewModel.reviewValue(rifReviews: rifReviews)
                    
                    ScrollView(showsIndicators: false) {
                        
                        VStack(spacing:.vStackBoxSpacing) {
                            
                            ForEach(allDishrev) { review in

                                DishRating_RowView(
                                    rating: review,
                                    backgroundColorView: .seaTurtle_1)
                               
                            }
                        }
                        
                    }
 
            } //
  
        } // vstack madre
    }
    
    // Method
    
   /* private func actionLogic(value:Bool) {
        
        if self.showRev == nil || self.showRev != value { self.showRev = value }
        else { self.showRev = nil }
        
    } */
    
   /* private func reviewValue(dish:DishModel) -> [DishRatingModel] {
        
        let allRif = dish.rifReviews
        let allRev = self.viewModel.modelCollectionFromCollectionID(collectionId: allRif, modelPath: \.allMyReviews)
        let sortElement = allRev.sorted(by: {$0.dataRilascio > $1.dataRilascio})
        
        return sortElement
        
    } */ //25.02.23 Deprecata per upgrade a public
    
}

