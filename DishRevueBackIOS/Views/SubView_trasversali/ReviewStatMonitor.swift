//
//  ReviewStatMonitor.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 22/10/22.
//

import SwiftUI
import MyPackView_L0

/// Visualizza sul singolo piatto o sul comparto recensioni per intero, le statistiche, totali,24h,media,medial L10,recensioni complete, negative,positive,topRange. Se singleDishRif == nil analizza l'intero comparto
struct ReviewStatMonitor<Label:View,ExtraContent:View>: View {
    
    @EnvironmentObject var viewModel:AccounterVM
 
    var singleDishRif:[String]? = nil
    let labelPlus: () -> Label
    @ViewBuilder var extraContent: ExtraContent

    var body: some View {
        
        CSZStackVB_Framed(frameWidth:500,backgroundOpacity: 0.05,shadowColor: .clear) {
            
            VStack(alignment:.leading) {
                
                let(allRev,all24h,mediaGen,mL10) = self.viewModel.monitorRecensioni(rifReview: singleDishRif)

                HStack(spacing:2) {

                    labelPlus()

                }
                .padding(.vertical,5)

                vbFirstLine(allRev: allRev, all24h: all24h, mediaGen: mediaGen, mL10: mL10)
                           
                Divider()
  
                vbSecondLine(allRev: allRev)
                
                extraContent
                 
                Spacer()
            }
            .font(.system(.subheadline, design: .monospaced))
            .padding(.horizontal,5)

        }
    }
    
    // Method

    @ViewBuilder private func vbFirstLine(allRev:Int,all24h:Int,mediaGen:Double,mL10:Double) -> some View {
        
        let mediaGenString = String(format: "%.1f", mediaGen)
        let ml10String = String(format: "%.1f", mL10)
        
        HStack {
            
            VStack {
                Text("Totali")
                Text("\(allRev)")
                        .fontWeight(.bold)
                  
            }
                Spacer()
                VStack {
                    Text("24H")
                    Text("\(all24h)")
                        .fontWeight(.bold)
                    
                }
            Spacer()
            VStack {
                Text("Media")
                Text(mediaGenString)
                    .fontWeight(.bold)
                
            }
            Spacer()
            VStack {
                Text("Media-L10")
                HStack {
                    Text(ml10String)
                    vbMediaL10(mediaGen: mediaGen, mediaL10: mL10)
                        .imageScale(.medium)
            
                }.fontWeight(.bold)
                
            }
        }
        .foregroundColor(Color.black)
        .lineLimit(1)
        .padding(.bottom,1)
        
    }
    
    @ViewBuilder private func vbSecondLine(allRev:Int) -> some View {
        
        let(neg,pos,top,com,trend,trendComp) = self.viewModel.monitorRecensioniPlus(rifReview: singleDishRif)
        
        let allRevDouble = Double(allRev)
        let completPercent = Double(com) / allRevDouble
        let completPercentString = String(format:"%.1f%%",(completPercent * 100))
        let negPercente = Double(neg) / allRevDouble
        let negPercentString = String(format:"%.1f%%",(negPercente * 100))
        let posPercent = Double(pos) / allRevDouble
        let posPercentString = String(format:"%.1f%%",(posPercent * 100))
        let topPercent = Double(top) / allRevDouble
        let topPercentString = String(format:"%.1f%%",(topPercent * 100))
        
        Group {
            
            HStack {

                VStack {
                    Text("Complete (foto+tit+com)")
                    HStack {
                        Text("\(com) su \(allRev) (\(completPercentString)) ")
                       vbTrendCompletezzaRecensioni(trendValue: trendComp)
                            .imageScale(.medium)
                    }
                    .fontWeight(.bold)
                }
        
            }
            .foregroundColor(Color.black)
            .padding(.vertical,1)
            
            HStack {
                
                VStack {
                    Text("Negative(<6)")
                    
                    HStack {
                        Text("\(neg) (\(negPercentString))")
                                
                        vbIndicatoreTrendVotoRecensioni(valoreAssociato: 1, trend: trend, coloreAssociato: .red)
                            .imageScale(.medium)
                        
                    }.fontWeight(.bold)
                      
                }
                    Spacer()
                
                    VStack {
                        Text("Positive(>=6)")
                        HStack {
                            Text("\(pos) (\(posPercentString))")
                            vbIndicatoreTrendVotoRecensioni(valoreAssociato: 5, trend: trend, coloreAssociato: .green)
                                .imageScale(.medium)
                            
                        } .fontWeight(.bold)
                        
                    }
                Spacer()
                
                VStack {
                    
                    Text("Top(>=9)")
                    
                    HStack {
                        Text("\(top) (\(topPercentString))")
                        vbIndicatoreTrendVotoRecensioni(valoreAssociato: 10, trend: trend, coloreAssociato: .green)
                            .imageScale(.medium)
                    } .fontWeight(.bold)
                    
                }

            }
            .foregroundColor(Color.black)
            .padding(.bottom,1)
            
        }
    }
    
}
/*
struct ReviewStatMonitor_Previews: PreviewProvider {
    static var previews: some View {
        ReviewStatMonitor(labelPlus: () -> _, extraContent: () -> _)
    }
}*/
