//
//  MonitorModelView.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 02/10/22.
//

import SwiftUI
import MyPackView_L0
import MyFoodiePackage

struct MonitorServizio: View {
    
    @EnvironmentObject var viewModel:AccounterVM

    
    var body: some View {
        
        CSZStackVB_Framed(frameWidth:500,backgroundOpacity: 0.05,shadowColor: .clear) {
            
            vbServizioStat()
              
                    .padding(.horizontal,5)
            
            
        }
       // .frame(height:120)
    }
    
    // Method
    
    private enum StatoServizio:String {
        case ok = "OK"
        case fareSpesa = "Spesa Necessaria"
        case controlloScorte = "Controllo Scorte"
        
        func coloreAssociato() -> Color {
            switch self {
            case .ok:
              return Color.green
            case .fareSpesa:
                return Color.red.opacity(0.8)
            case .controlloScorte:
               return Color.yellow
            }
        }
    }
    

    
    @ViewBuilder private func vbServizioStat() -> some View {
        
        let date = Date.now
        let currentDate:String = csTimeFormatter().data.string(from: date)

        let giornoDelServizio = GiorniDelServizio.giornoServizioFromData(dataEsatta: date)
        let currentDay:String = giornoDelServizio.simpleDescription()
        
        let(menuOn,foodB,readyProduct,ingredientsNeeded,preparazioniOk) = self.viewModel.monitorServizio()
        
        let prepOkPercent = Double(preparazioniOk.count) / Double(foodB.count)
        let stringPrepOkPercent = String(format:"%.1f%%",(prepOkPercent * 100))
        
        let linkMenuDisabled = menuOn.isEmpty
        
        VStack(alignment:.leading) {
            
            HStack {
                
                Text(linkMenuDisabled ? "Servizio Off" : "Servizio On")
                    .font(.system(.headline, design: .monospaced, weight: .black))
                    .foregroundColor(Color("SeaTurtlePalette_4"))

                   Spacer()
                
                PuntoLampeggiante(disableCondition: linkMenuDisabled)
                
                    Text("\(currentDay) \(currentDate)")
                        .fontWeight(.bold)
                        .foregroundColor(Color("SeaTurtlePalette_2"))
                
 
            }
            .lineLimit(1)
            .padding(.vertical,5)

            HStack {
                
                HStack {

                    Text("Menu On-Air:")
                        .fontWeight(.black)
                    Text("\(menuOn.count)")
                        .fontWeight(.bold)
            
                    NavigationLink(value: DestinationPathView.listaGenericaMenu(_containerRif: menuOn, _label: "I Menu di Oggi")) {
                        Image(systemName: "arrow.up.right")
                            .imageScale(.medium)
                            .bold()
                            .foregroundColor(Color("SeaTurtlePalette_3"))
                    }
                    .opacity(linkMenuDisabled ? 0.6 : 1.0)
                    .disabled(linkMenuDisabled)
                   
                }
                .foregroundColor(Color("SeaTurtlePalette_3"))
                Spacer()
                
               let statoIng = checkStatoServizio(rifIngOrPrep: ingredientsNeeded)
               let statoPrep = checkStatoServizio(rifIngOrPrep: readyProduct)
                
                vbStatoServizio(statoIngredienti: statoIng, statoPreparati: statoPrep)
                
            }
            .padding(.bottom,2)
            
            
            
            HStack {

                    VStack {
                        Text("Preparazioni(F&B)")
                            .minimumScaleFactor(0.6)
                     
                        HStack {
                            
                            let linkFBDisabled = foodB.isEmpty
                            
                            Text("\(foodB.count)")
                                .fontWeight(.bold)
                            
                            NavigationLink(value: DestinationPathView.listaGenericaDish(_containerRif: foodB,_label: "Le Preparazioni di Oggi")) {
                                Image(systemName: "arrow.up.right")
                                    .imageScale(.medium)
                                    .bold()
                                    .foregroundColor(Color("SeaTurtlePalette_3"))
                            }
                            .opacity(linkFBDisabled ? 0.6 : 1.0)
                            .disabled(linkFBDisabled)
                        }
                        
                    }
                   Spacer()
                
                VStack {
                    Text("Ingredienti")
                   
                    HStack {
                        
                        let linkIngredientDisabled = ingredientsNeeded.isEmpty
                        
                        Text("\(ingredientsNeeded.count)")
                            .fontWeight(.bold)
                        NavigationLink(value: DestinationPathView.listaGenericaIng(_containerRif: ingredientsNeeded,_label: "Gli Ingredienti di Oggi")) {
                            Image(systemName: "arrow.up.right")
                                .imageScale(.medium)
                                .bold()
                                .foregroundColor(Color("SeaTurtlePalette_3"))
                        }
                        .opacity(linkIngredientDisabled ? 0.6 : 1.0)
                        .disabled(linkIngredientDisabled)
                    }
                }
                
                Spacer()
                
                VStack {
                    
                    Text("Preparati")
                  
                    HStack {
                        
                        let linkPFDisabled = readyProduct.isEmpty
                        
                        Text("\(readyProduct.count)")
                            .fontWeight(.bold)
                        NavigationLink(value: DestinationPathView.listaGenericaDish(_containerRif: readyProduct,_label: "I Prodotti Finiti di Oggi")) {
                            Image(systemName: "arrow.up.right")
                                .imageScale(.medium)
                                .bold()
                                .foregroundColor(Color("SeaTurtlePalette_3"))
                        }
                        .opacity(linkPFDisabled ? 0.6 : 1.0)
                        .disabled(linkPFDisabled)
                        
                    }
                    
                }

            }
            .foregroundColor(Color.black)
            .lineLimit(1)
            .padding(.bottom,1)

            Divider()
            
            monitorIngredientiEPreparati(rifIngOrPrep: ingredientsNeeded, label: "Scorte Ingredienti:")
                .padding(.bottom,1)
            
            HStack {
                
                let arePrepAllEseguibili = prepOkPercent == 1.0
                let linkEseguibiliDisabled = preparazioniOk.isEmpty
        
                Text("F&B Eseguibili:")
                    .fontWeight(.semibold)
                    .lineLimit(1)
                
                Text("\(preparazioniOk.count) (\(stringPrepOkPercent))")
                    .fontWeight(.bold)
               
                Image(systemName: arePrepAllEseguibili ? "arrowtriangle.up.fill" : "arrowtriangle.down" )
                        .imageScale(.medium)
                        .foregroundColor(arePrepAllEseguibili ? .green : .red)
                
                NavigationLink(value: DestinationPathView.listaGenericaDish(_containerRif: preparazioniOk,_label: "F&B Eseguibili Oggi")) {
                    Image(systemName: "arrow.up.right")
                        .imageScale(.medium)
                        .bold()
                        .foregroundColor(Color("SeaTurtlePalette_3"))
                }
                .opacity(linkEseguibiliDisabled ? 0.6 : 1.0)
                .disabled(linkEseguibiliDisabled)
                
                Spacer()
            }
            .foregroundColor(Color("SeaTurtlePalette_3"))
            Divider()
            
            monitorIngredientiEPreparati(rifIngOrPrep: readyProduct, label: "Scorte Prodotti Finiti:")
                .padding(.bottom,5)
            
        }
        .font(.system(.subheadline, design: .monospaced))
    }
    
   /* private func checkStatoServizio(ingredients:[IngredientModel],preparati:[DishModel]) -> (ing:StatoServizio,prep:StatoServizio) {
        
       let areIngEsauriti = ingredients.contains(where: {
            self.viewModel.inventarioScorte.statoScorteIng(idIngredient: $0.id) == .esaurito
        })
        
       let arePrepEsauriti = preparati.contains(where: {
            self.viewModel.inventarioScorte.statoScorteIng(idIngredient: $0.id) == .esaurito
        })
        
        guard !arePrepEsauriti else { return .fareSpesa}
        
        let areIngScarsi = ingredients.contains(where: {
        
        let stato =  self.viewModel.inventarioScorte.statoScorteIng(idIngredient: $0.id)
        
      return stato == .inEsaurimento || stato == .inArrivo
        
    })
       
        guard !areIngScarsi else { return .controlloScorte }
        
        let arePreparatiScarsi = preparati.contains(where: {
            
            let stato =  self.viewModel.inventarioScorte.statoScorteIng(idIngredient: $0.id)
            
          return stato == .inEsaurimento || stato == .inArrivo
            
        })
        
        guard !arePreparatiScarsi else { return .controlloScorte }
        
        return .ok
        
    } */
    
  
    
    private func checkStatoServizio(rifIngOrPrep:[String]) -> StatoServizio {
        
        let mapStatoScorte = rifIngOrPrep.map({self.viewModel.inventarioScorte.statoScorteIng(idIngredient: $0)})
        
        if mapStatoScorte.contains(.esaurito) { return .fareSpesa }
        else if mapStatoScorte.contains([.inEsaurimento,.inArrivo]) { return .controlloScorte}
        else { return .ok }
        
    }
    
    @ViewBuilder private func vbStatoServizio(statoIngredienti:StatoServizio,statoPreparati:StatoServizio) -> some View {
        // Nota 22.10
        HStack {
            
            Text("Stato:")
                .fontWeight(.semibold)
                .foregroundColor(Color.black)
               
            
            HStack(spacing:0) {
                Image(systemName: "triangle.fill")
                    .imageScale(.small)
                    .foregroundColor(statoIngredienti.coloreAssociato())
                    .rotationEffect(Angle(degrees: -90))
                
                Image(systemName: "triangle.fill")
                    .imageScale(.small)
                    .foregroundColor(statoPreparati.coloreAssociato())
                    .rotationEffect(Angle(degrees: 90))
            }
            .shadow(radius: 10.0)
            .onTapGesture {
                self.viewModel.alertItem = AlertModel(
                    title: "Stato Servizio",
                    message: "Stato Ingredienti: \(statoIngredienti.rawValue)\nStato dei Preparati: \(statoPreparati.rawValue)")
            }

        }
      
    }
    
    
    @ViewBuilder private func monitorIngredientiEPreparati(rifIngOrPrep:[String],label:String) -> some View {
        
        let inCount = rifIngOrPrep.count
        let mapStatoScorte = rifIngOrPrep.map({self.viewModel.inventarioScorte.statoScorteIng(idIngredient: $0)})

        let generalStock = mapStatoScorte.filter({
            $0 == .inStock ||
            $0 == .inArrivo
        }).count
        
        let doubleTotal = Double(inCount)
        
        let valuePercent = Double(generalStock) / doubleTotal
        let stringValuePercent = String(format:"%.1f%%",(valuePercent * 100))
        
        let inEsauriCount = mapStatoScorte.filter({$0 == .inEsaurimento}).count
        let inEsauriPercent = Double(inEsauriCount) / doubleTotal
        let stringInEsauriPercent = String(format:"%.1f%%",(inEsauriPercent * 100))
        
        let esauriteCount = mapStatoScorte.filter({$0 == .esaurito}).count
        let esauritePercent = Double(esauriteCount) / doubleTotal
        let stringEsauritePercent = String(format:"%.1f%%",(esauritePercent * 100))
 
        let statoServizio = checkStatoServizio(rifIngOrPrep: rifIngOrPrep)
        
        VStack(alignment:.leading) {
            
            HStack {
                Text(label)
                    .fontWeight(.semibold)
              
                Text(statoServizio.rawValue)
                    .italic()
                    .fontWeight(.bold)
                    .foregroundColor(Color("SeaTurtlePalette_2"))
              
                
            }
            .padding(.bottom,5)
            
            HStack {
                Text("in-Stock:")
                Text("\(generalStock) (\(stringValuePercent))")
                    .fontWeight(.bold)
                vbAssociaIndicatoreVisivo(statoServizio: statoServizio, valoreAssociato: .ok)
            }
            
           // HStack {
             
                HStack {
                    Text("in-Esaurimento:")
                    Text("\(inEsauriCount) (\(stringInEsauriPercent))")
                        .fontWeight(.bold)
                    vbAssociaIndicatoreVisivo(statoServizio: statoServizio, valoreAssociato: .controlloScorte)
                    
                }
               // Spacer()
                HStack {
                    Text("Esaurite:")
                    Text("\(esauriteCount) (\(stringEsauritePercent))")
                        .fontWeight(.bold)
                    vbAssociaIndicatoreVisivo(statoServizio: statoServizio, valoreAssociato: .fareSpesa)
                    
                }
            
              //  Spacer()
           // }
            
        }
        
    }
    
    @ViewBuilder private func vbAssociaIndicatoreVisivo(statoServizio:StatoServizio,valoreAssociato:StatoServizio) -> some View {
        
        if statoServizio == valoreAssociato {
            Image(systemName: "arrowtriangle.up.fill")
                .foregroundColor(valoreAssociato.coloreAssociato())
        }
        
    }
    
}


struct MonitorModelView_Previews: PreviewProvider {
    static var previews: some View {
        CSZStackVB(title: "Monitor", backgroundColorView: Color("SeaTurtlePalette_1")) {
            MonitorServizio()
        }.environmentObject(testAccount)
    }
}
