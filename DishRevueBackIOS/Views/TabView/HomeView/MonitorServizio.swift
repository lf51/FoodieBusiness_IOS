//
//  MonitorModelView.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 02/10/22.
//

import SwiftUI
import MyPackView_L0
import MyFoodiePackage
import MyFilterPackage

struct MonitorServizio: View {
    
    @EnvironmentObject var viewModel:AccounterVM
    
    @State private var selected:String = LocalEtichette.defaultValue.rawValue

    var body: some View {

        VStack(alignment:.leading,spacing:0) {
            
            CSPickerClassificatore(
                etichette: LocalEtichette.allCases,
                etichettaDefault: $selected,
                labelColor: .black,
                backgroundColor: .white,
                shadowColor: .seaTurtle_1)
            
            CSZStackVB_Framed(/*frameWidth:500,*/backgroundOpacity: 0.05,shadowColor: .clear) {
                    
                   // vbServizioStat()
                     //       .padding(.horizontal,5)
                
                vbMainSwitch()
                    .padding(.horizontal,5)
                    .padding(.bottom,5)
                    
                }
        }
        
    }
    
    // Sub
    
    private enum LocalEtichette:String,Hashable {
        
        static var allCases:[String] = [LocalEtichette.adesso.rawValue,LocalEtichette.oggi.rawValue,LocalEtichette.generale.rawValue]
        
        static let defaultValue:LocalEtichette = .oggi
        
        case oggi,generale,adesso

    }
    
    // Method
    
    private func currentTime() -> (hour:String,day:String,date:String) {
        
        let date = Date.now
        let currentDate:String = csTimeFormatter().data.string(from: date)
        let currentHour:String = csTimeFormatter().ora.string(from: date)

        let giornoDelServizio = GiorniDelServizio.giornoServizioFromData(dataEsatta: date)
        let currentDay:String = giornoDelServizio.simpleDescription()
        
        return (currentHour,currentDay,currentDate)
    }
    
    @ViewBuilder private func vbMainSwitch() -> some View {
        
       let etichetta: LocalEtichette = LocalEtichette(rawValue: self.selected) ?? LocalEtichette.defaultValue
        
       let(currentHour,currentDay,currentDate) = currentTime()
        
        switch etichetta {
            
        case .adesso:
            
           //let allMenuToAnalize = self.viewModel.allMyMenu.filter({$0.isOnAir(checkTimeRange: true)})
            let allMenuToAnalize = self.viewModel.db.allMyMenu.filter({$0.isOnAirValue().now})
          /*  vbServizioStat("Menu Online:",
                           allMenuToAnalize: allMenuToAnalize) { serviceOff in
            vbTopStackNowOnline(
                serviceOff: serviceOff,
                currentHour: currentHour,
                currentDay: currentDay,
                currentDate: currentDate) } */
            
            MonitorServizio_SubLogic(
                viewModel: viewModel,
                menuOnLabel: "Menu Online Ora",
                allMenuToAnalize: allMenuToAnalize) { serviceOff in
                    
                    vbTopStackNowOnline(
                        serviceOff: serviceOff,
                        currentHour: currentHour,
                        currentDay: currentDay,
                        currentDate: currentDate)
                }
            
            
        case .oggi:
            
            let allMenuToAnalize = self.viewModel.db.allMyMenu.filter({$0.isOnAirValue().today})
            
            MonitorServizio_SubLogic(
                viewModel: self.viewModel,
                menuOnLabel: "Menu Online Oggi",
                allMenuToAnalize: allMenuToAnalize) { serviceOff in
                    vbTopStackTodayOnline(
                        serviceOff: serviceOff,
                        currentDay: currentDay,
                        currentDate: currentDate)
                }
            
        case .generale:
            
            let allMenuToAnalize = self.viewModel.db.allMyMenu.filter({
                $0.status.checkStatusTransition(check: .disponibile) ||
                $0.status.checkStatusTransition(check: .inPausa)
            })
            
            MonitorServizio_SubLogic(
                viewModel: viewModel,
                menuOnLabel: "Menu Attivi",
                allMenuToAnalize: allMenuToAnalize) { _ in
                    vbTopStackGenerale()
                }
            
           /* vbServizioStat("Menu Attivi:",
                           allMenuToAnalize: allMenuToAnalize) { _ in
                
            vbTopStackGenerale()
                
            } */
            
        }
    }
    
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
    
    private func checkStatoServizio(rifIngOrPrep:[String]) -> StatoServizio {
        
        let mapStatoScorte = rifIngOrPrep.map({self.viewModel.currentProperty.inventario.statoScorteIng(idIngredient: $0)})
        
        if mapStatoScorte.contains(.esaurito) { return .fareSpesa }
        else if mapStatoScorte.contains([.inEsaurimento,.inArrivo]) { return .controlloScorte}
        else { return .ok }
        
    }
    
    @ViewBuilder private func vbStatoServizio(
        statoIngredienti:StatoServizio,
        statoPreparati:StatoServizio) -> some View {
        // Nota 22.10
        HStack {
            
            Text("Stato:")
                .fontWeight(.semibold)
                .foregroundStyle(Color.black)
               
            HStack(spacing:0) {
                Image(systemName: "triangle.fill")
                    .imageScale(.small)
                    .foregroundStyle(statoIngredienti.coloreAssociato())
                    .rotationEffect(Angle(degrees: -90))
                
                Image(systemName: "triangle.fill")
                    .imageScale(.small)
                    .foregroundStyle(statoPreparati.coloreAssociato())
                    .rotationEffect(Angle(degrees: 90))
            }
            .shadow(radius: 10.0)
            .onTapGesture {
                self.viewModel.alertItem = AlertModel(
                    title: "Stato Servizio",
                    message: "Stato Ingredienti: \(statoIngredienti.rawValue)\nStato Prodotti terzi: \(statoPreparati.rawValue)")
            }

        }
      
    }
    
    @ViewBuilder private func monitorIngredientiEPreparati(rifIngOrPrep:[String],label:String) -> some View {
        
        let inCount = rifIngOrPrep.count
        let mapStatoScorte = rifIngOrPrep.map({self.viewModel.currentProperty.inventario.statoScorteIng(idIngredient: $0)})

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
                    .foregroundStyle(Color.seaTurtle_2)
              
                
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
                .foregroundStyle(valoreAssociato.coloreAssociato())
        }
        
    }
    
    @ViewBuilder private func vbTopStackGenerale() -> some View {
        
        HStack {
            
            Text("Quadro Generale")
                .font(.system(.headline, design: .monospaced, weight: .black))
                .foregroundStyle(Color.seaTurtle_4)
            
            CSInfoAlertView(
                title: "Info",
                message: .quadroGenerale)
            
        }
        .padding(.vertical,5)
    }
    
    @ViewBuilder private func vbTopStackNowOnline(serviceOff:Bool,currentHour:String,currentDay:String,currentDate:String) -> some View {
        
        HStack(alignment:.lastTextBaseline) {
            
          /*  let date = Date.now
            let currentDate:String = csTimeFormatter().data.string(from: date)
            let currentHour:String = csTimeFormatter().ora.string(from: date)

            let giornoDelServizio = GiorniDelServizio.giornoServizioFromData(dataEsatta: date)
            let currentDay:String = giornoDelServizio.simpleDescription() */
            
            HStack {
                PuntoLampeggiante(disableCondition: serviceOff)
                
                Text(serviceOff ? "Off" : "On")
                    .font(.system(.headline, design: .monospaced, weight: .black))
                    .foregroundStyle(Color.seaTurtle_4)
            }
            
            Text(currentHour)

               Spacer()
  
            Text("\(currentDay) \(currentDate)")
                    .fontWeight(.bold)
                    .foregroundStyle(Color.seaTurtle_2)
                    .minimumScaleFactor(0.75)

        }
        .lineLimit(1)
        .padding(.vertical,5)
    }
    
    @ViewBuilder private func vbTopStackTodayOnline(serviceOff:Bool,currentDay:String,currentDate:String) -> some View {
        
        HStack {
            
           /* let date = Date.now
            let currentDate:String = csTimeFormatter().data.string(from: date)

            let giornoDelServizio = GiorniDelServizio.giornoServizioFromData(dataEsatta: date)
            let currentDay:String = giornoDelServizio.simpleDescription() */
            
            Text(serviceOff ? "Chiuso" : "Aperto")
                .font(.system(.headline, design: .monospaced, weight: .black))
                .foregroundStyle(Color.seaTurtle_4)
                .opacity(serviceOff ? 0.7 : 1.0)

               Spacer()
            
            PuntoLampeggiante(disableCondition: serviceOff)
            
                Text("\(currentDay) \(currentDate)")
                    .fontWeight(.bold)
                    .foregroundStyle(Color.seaTurtle_2)
                    .minimumScaleFactor(0.75)

        }
        .lineLimit(1)
        .padding(.vertical,5)
    }
    
    /*
    @ViewBuilder private func vbInfoPreparazioni(prepOkPercent:Double,preparazioniOk:[String]) -> some View {
        
        let stringPrepOkPercent = String(format:"%.1f%%",(prepOkPercent * 100))
        
        VStack(alignment:.leading) {
            HStack {
                
                let arePrepAllEseguibili = prepOkPercent == 1.0
                let linkEseguibiliDisabled = preparazioniOk.isEmpty
        
                Text("F&B Eseguibili: \nsia inPausa che diponibili")
                    .fontWeight(.semibold)
                  //  .lineLimit(1)
                
                Text("\(preparazioniOk.count) (\(stringPrepOkPercent))")
                    .fontWeight(.bold)
               
                Image(systemName: arePrepAllEseguibili ? "arrowtriangle.up.fill" : "arrowtriangle.down" )
                        .imageScale(.medium)
                        .foregroundStyle(arePrepAllEseguibili ? .green : .red)
                
                NavigationLink(value: DestinationPathView.listaGenericaDish(_containerRif: preparazioniOk,_label: "F&B Eseguibili Oggi")) {
                    Image(systemName: "arrow.up.right")
                        .imageScale(.medium)
                        .bold()
                        .foregroundStyle(Color.seaTurtle_3)
                }
                .opacity(linkEseguibiliDisabled ? 0.6 : 1.0)
                .disabled(linkEseguibiliDisabled)
                
              //  Spacer()
            }
            
            HStack {
                Text("In Vendita: i disponibili\n DA CONFIGURARE 14.03.23")
                    .fontWeight(.semibold)
                   // .lineLimit(1)
                
                
            }
            
        }
        .foregroundStyle(Color.seaTurtle_3)
        
    } */
    /*
    @ViewBuilder private func vbInfoPF() -> some View { } //Deprecata 26.06.23 */
    
    /*@ViewBuilder private func vbInfoIngredienti() -> some View { } //Deprecata 26.06.23 */
 
}

struct MonitorServizio_SubLogic<TopStack:View>:View {
    
    @ObservedObject var viewModel:AccounterVM
    
    let menuOnLabel:String
    let allMenuToAnalize:[MenuModel]
    let vbTopStack: (_ serviceOff:Bool) -> TopStack
    
    let menuOn:[String]
    let foodB:[String]
    let readyProduct:[String]
    let ingredientsNeeded:[String]
    let preparazioniOk:[String]
    
    init(
        viewModel:AccounterVM,
        menuOnLabel: String,
        allMenuToAnalize: [MenuModel],
        vbTopStack: @escaping (_: Bool) -> TopStack) {
            
        self.viewModel = viewModel
        self.menuOnLabel = menuOnLabel
        self.allMenuToAnalize = allMenuToAnalize
        self.vbTopStack = vbTopStack
            
        (self.menuOn,self.foodB,self.readyProduct,self.ingredientsNeeded,self.preparazioniOk) = viewModel.monitorServizio(menuModelToAnalize: allMenuToAnalize)
            
    }
    
    var body: some View {
        
        VStack(alignment:.leading) {
            
            let serviceOff:Bool = {
                
                menuOn.isEmpty || (foodB.isEmpty && readyProduct.isEmpty)
                
            }()
            
            vbTopStack(serviceOff)
            vbInfoMenu(serviceOff,menuOnLabel: menuOnLabel)
              //  .padding(.bottom,2)
            Divider()
            vbInfoPreparazioni()
            Divider()
            vbInfoIngredienti()
            Divider()
            vbInfoPF()
            
            
            
            
            
        } // vstack Madre
        .font(.system(.subheadline, design: .monospaced))
    }
    
    // ViewBuilder
    
    @ViewBuilder private func vbInfoMenu(_ serviceOff:Bool,menuOnLabel:String) -> some View {
         
        let linkMenuDisabled:Bool = self.menuOn.isEmpty
        let allRifDishOn:[String] = {
            
            return foodB + readyProduct

        }() // Nota 14.03.23
        
        VStack(alignment:.leading) {
            
            HStack {
                
                HStack {
                    
                    Text("\(self.menuOnLabel):")
                        .fontWeight(.black)
                    Text("\(self.menuOn.count)")
                        .fontWeight(.bold)
                    // Nota 20.02.23 Anteprima Menu
                    
                    NavigationLink(value:
                                    
                                    DestinationPathView.listaMenuPerAnteprima(
                                       rifMenuOn: self.menuOn,
                                        rifDishOn: allRifDishOn,
                                        label: menuOnLabel)) {
                                            
                                            Image(systemName: "arrow.up.right")
                                                .imageScale(.medium)
                                                .bold()
                                                .foregroundStyle(Color.seaTurtle_3)
                                        }
                                        .opacity(linkMenuDisabled ? 0.6 : 1.0)
                                        .disabled(linkMenuDisabled)
                    
                }
                .foregroundStyle(Color.seaTurtle_3)
                
                Spacer()
                
            if serviceOff {
               
                HStack {
                    Text("Stato:")
                        .fontWeight(.semibold)
                        .foregroundStyle(Color.black)
                    
                    if linkMenuDisabled {
                        
                        Text("off")
                            .italic()
                          //  .font(.caption)
                        
                    } else {
                        
                        Image(systemName: "exclamationmark.triangle.fill")
                            .imageScale(.medium)
                            .foregroundStyle(Color.yellow)
                            .onTapGesture {
                                self.viewModel.alertItem = AlertModel(
                                    title: "Servizio Off",
                                    message: "Risultano Menu attivi ma vuoti.")
                            }
                        
                    }
                    
                }
               
                
            } else {
                
                let statoIng = checkStatoServizio(rifIngOrPrep: self.ingredientsNeeded)
                let statoPrep = checkStatoServizio(rifIngOrPrep: self.readyProduct)
                
                vbStatoServizio(
                    statoIngredienti: statoIng,
                    statoPreparati: statoPrep)
                
            }
                
            }



        }
        
        
     }
  
    @ViewBuilder private func vbInfoPreparazioni() -> some View {
        
      //  let prepOkPercent = Double(self.preparazioniOk.count) / Double(self.foodB.count)
      //  let stringPrepOkPercent = String(format:"%.1f%%",(prepOkPercent * 100))
        let showMore = !self.foodB.isEmpty
        
        VStack(alignment:.leading,spacing:5) {
            
            VStack(alignment:.leading,spacing: 3) {
                
                HStack {
                    
                    Text("Preparazioni (F&B):")
                        .fontWeight(.heavy)
                      //  .foregroundStyle(Color.seaTurtle_3)
                        
                    Text("\(self.foodB.count)")
                        .fontWeight(.bold)
                    
                    NavigationLink(value: DestinationPathView.monitorServizio_vistaEspansaDish(
                        containerRif: self.foodB,
                        label: "Preparazioni in Menu")) {
                        Image(systemName: "arrow.up.right")
                            .imageScale(.medium)
                            .bold()
                            .foregroundStyle(showMore ? Color.seaTurtle_3 : Color.seaTurtle_1)
                    }
                    .disabled(!showMore)
                    
                    
                }
                .foregroundStyle(Color.seaTurtle_2)
               // .padding(.bottom,3)
                
                  //  VStack(alignment:.leading) {
                if showMore {
                    
                    Grid(alignment:.leading) {
                            
                            vbSingleStatusRow(
                                rifToCheck: foodB,
                                statusCheck: .disponibile,
                                path: \.db.allMyDish,
                                label: "in Vendita")
                            
                            vbSingleStatusRow(
                                rifToCheck: foodB,
                                statusCheck: .inPausa,
                                path: \.db.allMyDish)
                            
                        }
                }

            }
            
            if showMore {
                vbExecutionStateMonitor(ofRifDishes: self.foodB)
            }
               
            
        }
     //   .foregroundStyle(Color.seaTurtle_3)
        
    }
    
    @ViewBuilder private func vbInfoIngredienti() -> some View {
        
        let showMore = !self.ingredientsNeeded.isEmpty
        
        VStack(alignment:.leading,spacing:5) {
            
            VStack(alignment:.leading,spacing: 3) {
                
                HStack {
                    
                    Text("Ingredienti:")
                        .fontWeight(.heavy)
                    
                    Text("\(self.ingredientsNeeded.count)")
                        .fontWeight(.bold)
                    
                    NavigationLink(value: DestinationPathView.monitorServizio_vistaEspansaIng(containerRif: self.ingredientsNeeded, label: "Ingredienti Necessari")) {
                        Image(systemName: "arrow.up.right")
                            .imageScale(.medium)
                            .bold()
                            .foregroundStyle(showMore ? Color.seaTurtle_3 : Color.seaTurtle_1)
                    }
                    .disabled(!showMore)
                   /* NavigationLink(value: DestinationPathView.listaGenericaIng(_containerRif: self.ingredientsNeeded,_label: "Ingredienti Necessari")) {
                        Image(systemName: "arrow.up.right")
                            .imageScale(.medium)
                            .bold()
                            .foregroundStyle(showMore ? .seaTurtle_3 : .seaTurtle_1)
                    }
                    .disabled(!showMore) */ // deprecata 10.07.23
                }
                .foregroundStyle(Color.seaTurtle_2)
                
               // VStack(alignment:.leading) {
                if showMore {
                    Grid(alignment:.leading) {
                        
                        vbSingleStatusRow(
                            rifToCheck: self.ingredientsNeeded,
                            statusCheck: .disponibile,
                            path: \.db.allMyIngredients)
                        
                        vbSingleStatusRow(
                            rifToCheck: self.ingredientsNeeded,
                            statusCheck: .inPausa,
                            path: \.db.allMyIngredients)
                        
                    }
                }
                
              /*  if showMore {
                    
                  /*  HStack {
                        
                        let (count,rif) = csDispoCountAndRif(
                            rifToCheck: ingredientsNeeded,
                            statusCheck: .disponibile,
                            path: \.allMyIngredients)
                        let disableLink = count == 0
                        
                        Image(systemName: "circle.dashed.inset.filled")
                            .foregroundStyle(Color.green)
                        
                        Text("Disponibili:")
                            .fontWeight(.semibold)
                        Text("\(count)")
                        
                        NavigationLink(value: DestinationPathView.listaGenericaIng(_containerRif: rif,_label: "Ingredienti Disponibili")) {
                            Image(systemName: "arrow.up.right")
                                .imageScale(.medium)
                                .bold()
                                .foregroundStyle(disableLink ? .seaTurtle_1 : .seaTurtle_3)
                        }
                        .disabled(disableLink)
                        
                    } */
                    
                   /* HStack {
                        
                        let (count,rif) = csDispoCountAndRif(
                            rifToCheck: ingredientsNeeded,
                            statusCheck: .inPausa,
                            path: \.allMyIngredients)
                        let disableLink = count == 0
                        
                        Image(systemName: "circle.dashed.inset.filled")
                            .foregroundStyle(Color.yellow)
                        
                        Text("in Pausa:")
                            .fontWeight(.semibold)
                        Text("\(count)")
                        
                        NavigationLink(value: DestinationPathView.listaGenericaIng(_containerRif: rif,_label: "Ingredienti in Pausa")) {
                            Image(systemName: "arrow.up.right")
                                .imageScale(.medium)
                                .bold()
                                .foregroundStyle(disableLink ? .seaTurtle_1 : .seaTurtle_3)
                        }
                        .disabled(disableLink)
                        
                    } */
                    
                    
                    
                    
                } */
            }
            
            if showMore {
                monitorIngredientiEPreparati(
                    rifIngOrPrep: ingredientsNeeded,
                    label: "Livello Scorte:")
            }
           
               // .lineLimit(1)
               // .minimumScaleFactor(0.75)
               // .padding(.bottom,1)
               // .padding(.top,0)
            
            
        } // chiusa vstack madre
        
    }
    
    @ViewBuilder private func vbInfoPF() -> some View {
        
        let showMore = !self.readyProduct.isEmpty
        
        VStack(alignment:.leading,spacing:5) {
            
            VStack(alignment:.leading,spacing: 3) {
                
                HStack {
                    
                    Text("Prodotti di Terzi:")
                        .fontWeight(.heavy)
                    
                    Text("\(readyProduct.count)")
                        .bold()
                        
                    // update 09.07.23
                  /* NavigationLink(value: DestinationPathView.listaGenericaDish(_containerRif: readyProduct,_label: "In Menu Oggi (PF)")) {
                        Image(systemName: "arrow.up.right")
                            .imageScale(.medium)
                            .bold()
                            .foregroundStyle(showMore ? .seaTurtle_3 : .seaTurtle_1)
                    }
                    .disabled(!showMore) */
                    NavigationLink(
                        value: DestinationPathView.monitorServizio_vistaEspansaPF(containerRif: readyProduct, label: "Prodotti di Terzi")) {
                        Image(systemName: "arrow.up.right")
                            .imageScale(.medium)
                            .bold()
                            .foregroundStyle(showMore ? Color.seaTurtle_3 : Color.seaTurtle_1)
                    }
                    .disabled(!showMore)
                    // end update
                    
                }
                .foregroundStyle(Color.seaTurtle_2)
                
               // VStack(alignment:.leading) {
                if showMore {
                    Grid(alignment:.leading) {
                        
                        vbSingleStatusRow(
                            rifToCheck: self.readyProduct,
                            statusCheck: .disponibile,
                            path: \.db.allMyDish)
                        
                        vbSingleStatusRow(
                            rifToCheck: self.readyProduct,
                            statusCheck: .inPausa,
                            path: \.db.allMyDish)
                        
                        
                    }
                }
                
                
             /*   if showMore {
                    
                  /*  HStack {
                        
                        let (count,rif) = csDispoCountAndRif(
                            rifToCheck: self.readyProduct,
                            statusCheck: .disponibile,
                            path: \.allMyDish)
                        let disableLink = count == 0
                        
                        Image(systemName: "circle.dashed.inset.filled")
                            .foregroundStyle(Color.green)
                        
                        Text("in Vendita:")
                            .fontWeight(.semibold)
                        
                        Text("\(count)")
                            .bold()
                          
                        
                        NavigationLink(value: DestinationPathView.listaGenericaDish(_containerRif: rif,_label: "PF in Vendita")) {
                            
                            Image(systemName: "arrow.up.right")
                                .imageScale(.medium)
                                .bold()
                                .foregroundStyle(disableLink ? .seaTurtle_1 : .seaTurtle_3)
                        }
                        .disabled(disableLink)
                        
                    } */
                    
                   /* HStack {
                        
                        let (count,rif) = csDispoCountAndRif(
                            rifToCheck: self.readyProduct,
                            statusCheck: .inPausa,
                            path: \.allMyDish)
                        let disableLink = count == 0
                        
                        Image(systemName: "circle.dashed.inset.filled")
                            .foregroundStyle(Color.yellow)
                        
                        Text("in Pausa:")
                            .fontWeight(.semibold)
                        
                        Text("\(count)")
                            .bold()
                          
                        NavigationLink(value: DestinationPathView.listaGenericaDish(_containerRif: rif,_label: "PF in Pausa")) {
                            
                            Image(systemName: "arrow.up.right")
                                .imageScale(.medium)
                                .bold()
                                .foregroundStyle(disableLink ? .seaTurtle_1 : .seaTurtle_3)
                        }
                        .disabled(disableLink)
                        
                    } */

                    
                    
                   
                    
                } */
            }
            
            if showMore {
                monitorIngredientiEPreparati(rifIngOrPrep: readyProduct, label: "Livello Scorte (PF):")
            }
              //  .padding(.bottom,5)
        }// chiusa vstack Madre
        
        
    }
    
    @ViewBuilder private func vbSingleStatusRow<M:MyProStatusPack_L1>(
        rifToCheck:[String],
        statusCheck:StatusTransition,
        path:KeyPath<FoodieViewModel,[M]>,
        label:String? = nil) -> some View {
        
        let localLabel = label ?? statusCheck.simpleDescription()
            
       // HStack {
            GridRow {
            
            let (count,percent) = csDispoCountAndRif(
                rifToCheck: rifToCheck,
                statusCheck: statusCheck,
                path: path)

            csCircleDashed(
                internalColor: statusCheck.colorAssociated(),
                dashedColor: .gray)
            
            Text("\(localLabel):")
               // .fontWeight(.semibold)

            Text("\(count) (\(percent))")
                .fontWeight(.bold)

        }
    }
    
    
    @ViewBuilder private func vbExecutionStateMonitor(ofRifDishes rifDishes:[String]) -> some View {
        
       /* let prepOkPercent = Double(self.preparazioniOk.count) / Double(self.foodB.count)
        let stringPrepOkPercent = String(format:"%.1f%%",(prepOkPercent * 100))
        
        let arePrepAllEseguibili = prepOkPercent == 1.0
        let linkEseguibiliDisabled = self.preparazioniOk.isEmpty */
        
        
      /*  let foodB_Dcount = Double(self.foodB.count)
        
        let rif_Eseguibili = self.viewModel.checkDishStatusExecution(
            of: rifDishes,
            check: .eseguibile)
        let exePercent = Double(rif_Eseguibili.count) / foodB_Dcount
        let exePercent_string = String(format:"%.1f%%",(exePercent * 100))
        let exe_disable = rif_Eseguibili.isEmpty
        
        let rif_ExConRiserva = self.viewModel.checkDishStatusExecution(
            of: rifDishes,
            check: .eseguibileConRiserva)
        let conRisPercent = Double(rif_ExConRiserva.count) / foodB_Dcount
        let conRisPercent_string = String(format:"%.1f%%",(conRisPercent * 100))
        let conRis_disable = rif_ExConRiserva.isEmpty
        
        let rif_NonEseguibili = self.viewModel.checkDishStatusExecution(
            of: rifDishes,
            check: .nonEseguibile)
        let nonExePercent = Double(rif_NonEseguibili.count) / foodB_Dcount
        let nonExePercent_string = String(format:"%.1f%%",(nonExePercent * 100))
        let nonExe_disable = rif_NonEseguibili.isEmpty */
        
        
        VStack(alignment:.leading,spacing:3) {
            
            
            HStack {
                Text("Execution State:")
                    .fontWeight(.black)
                Text("da settare")
                    .italic()
                    .fontWeight(.bold)
                    .foregroundStyle(Color.seaTurtle_2)
            }
            
           // VStack(alignment:.leading) {
            
            Grid(alignment:.leading) {
                
                vbSubSingleStateExcecution(
                    rifDishes: rifDishes,
                    executionState: .eseguibile,
                    rowLabel: "Eseguibili:",
                    navLinkDestinationLabel: "F&B Eseguibili")
                
                vbSubSingleStateExcecution(
                    rifDishes: rifDishes,
                    executionState: .eseguibileConRiserva,
                    rowLabel: "con Riserva:",
                    navLinkDestinationLabel: "F&B Eseguibili con Riserva")
                
                vbSubSingleStateExcecution(
                    rifDishes: rifDishes,
                    executionState: .nonEseguibile,
                    rowLabel: "Non Eseguibili:",
                    navLinkDestinationLabel: "F&B Non Eseguibili")
            }
            
            
        }
    }
    
    @ViewBuilder private func vbSubSingleStateExcecution(
        rifDishes:[String],
        executionState:ProductModel.ExecutionState,
        rowLabel:String,
        navLinkDestinationLabel:String) -> some View {
        
        let foodB_Dcount = Double(self.foodB.count)
           
        let allRif = self.viewModel.checkDishStatusExecution(
            of: rifDishes,
            check: executionState)
        let percentValue = Double(allRif.count) / foodB_Dcount
        let percentValue_string = String(format:"%.1f%%",(percentValue * 100))
        let disableValue = allRif.isEmpty
        
       // HStack {
            GridRow {
           /* Image(systemName: "circle.dashed")
                .foregroundStyle(executionState.coloreAssociato()) */
            
            csCircleDashed(
                internalColor: .seaTurtle_1,
                dashedColor: executionState.coloreAssociato())
            
            Text(rowLabel)
               // .fontWeight(.semibold)
             
            Text("\(allRif.count) (\(percentValue_string))")
                 .fontWeight(.bold)
            
            /* Image(systemName: arePrepAllEseguibili ? "arrowtriangle.up.fill" : "arrowtriangle.down" )
                     .imageScale(.medium)
                     .foregroundStyle(arePrepAllEseguibili ? .green : .red) */
             
           /* NavigationLink(value: DestinationPathView.listaGenericaDish(
                _containerRif: allRif,
                _label: navLinkDestinationLabel)) {
                 Image(systemName: "arrow.up.right")
                     .imageScale(.medium)
                     .bold()
                     .foregroundStyle(disableValue ? .seaTurtle_1 : .seaTurtle_3)
             }
             .opacity(disableValue ? 0.6 : 1.0)
             .disabled(disableValue) */

         }
        
        
    }
    
    
    private func csDispoCountAndRif<M:MyProStatusPack_L1>(
        rifToCheck:[String],
        statusCheck:StatusTransition,
        path:KeyPath<FoodieViewModel,[M]>) -> (count:Int,percentage:String) {
        
        let active = self.viewModel.modelCollectionFromCollectionID(collectionId: rifToCheck, modelPath: path)
        let dispo = active.filter({$0.status.checkStatusTransition(check: statusCheck)})
            
       // let dispoRif = dispo.map({$0.id})
        let totRif = Double(rifToCheck.count)
        let dispoCount = dispo.count
        
        let valuePercent = Double(dispoCount) / totRif
        let stringValuePercent = String(format:"%.1f%%",(valuePercent * 100))
            
        return (dispoCount,stringValuePercent)
        
    }
    
    @ViewBuilder private func monitorIngredientiEPreparati(rifIngOrPrep:[String],label:String) -> some View {
        
      //  let inCount = rifIngOrPrep.count
        
        let mapStatoScorte = rifIngOrPrep.map({self.viewModel.currentProperty.inventario.statoScorteIng(idIngredient: $0)}) //

      /* let generalStock = mapStatoScorte.filter({
            $0 == .inStock ||
            $0 == .inArrivo
        }).count */
        
       // let doubleTotal = Double(inCount)
        
      //  let valuePercent = Double(generalStock) / doubleTotal
       // let stringValuePercent = String(format:"%.1f%%",(valuePercent * 100))
        
       // let inEsauriCount = mapStatoScorte.filter({$0 == .inEsaurimento}).count
       // let inEsauriPercent = Double(inEsauriCount) / doubleTotal
       // let stringInEsauriPercent = String(format:"%.1f%%",(inEsauriPercent * 100))
        
      //  let esauriteCount = mapStatoScorte.filter({$0 == .esaurito}).count
      //  let esauritePercent = Double(esauriteCount) / doubleTotal
      //  let stringEsauritePercent = String(format:"%.1f%%",(esauritePercent * 100))
 
        let statoServizio = checkStatoServizio(rifIngOrPrep: rifIngOrPrep) //
        
        VStack(alignment:.leading,spacing:3) {
            
            HStack {
                
                Text(label)
                    .fontWeight(.black)
              
                Text(statoServizio.simpleDescription())
                    .italic()
                    .fontWeight(.bold)
                    .foregroundStyle(Color.seaTurtle_2)
              
                
            }
           // .padding(.bottom,5)
            
          //  VStack(alignment:.leading) {
            
            Grid(alignment:.leading) {
                
              /*  HStack {
                    
                    csCircleDashed(
                        internalColor: .seaTurtle_1,
                        dashedColor: .green)
                    
                    Text("in-Stock:")
                    Text("\(generalStock) (\(stringValuePercent))")
                        .fontWeight(.bold)
                    vbAssociaIndicatoreVisivo(statoServizio: statoServizio, valoreAssociato: .ok)
                } */
                
                vbSingleRowInventario(
                    mapTransitoScorte: mapStatoScorte,
                    filtraPer: .inStock,
                    statoServizio: statoServizio,
                    confrontaCon: .ok)
                
                vbSingleRowInventario(
                    mapTransitoScorte: mapStatoScorte,
                    filtraPer: .inArrivo,
                    statoServizio: statoServizio,
                    confrontaCon: .controlloScorte(.inArrivo))
                
                vbSingleRowInventario(
                    mapTransitoScorte: mapStatoScorte,
                    filtraPer: .inEsaurimento,
                    statoServizio: statoServizio,
                    confrontaCon: .controlloScorte(.inEsaurimento))
                
                vbSingleRowInventario(
                    mapTransitoScorte: mapStatoScorte,
                    filtraPer: .esaurito,
                    statoServizio: statoServizio,
                    confrontaCon: .fareSpesa)
                
                
               // HStack {
                 
                 /*   HStack {
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
                        
                    } */
            }
            
              //  Spacer()
           // }
            
        }
        
    }
    
    @ViewBuilder private func vbSingleRowInventario(
        mapTransitoScorte:[Inventario.TransitoScorte],
        filtraPer transitoScorte:Inventario.TransitoScorte,
        statoServizio:StatoServizio,
        confrontaCon localStatoServizio:StatoServizio) -> some View {
        
        let doubleTotal = Double(mapTransitoScorte.count)
            
        let filterCount = mapTransitoScorte.filter({
            $0 == transitoScorte
        }).count
        
        let valuePercent = Double(filterCount) / doubleTotal
        let stringValuePercent = String(format:"%.1f%%",(valuePercent * 100))
            
        let transitoColor = transitoScorte.coloreAssociatoNotOpacity()
        
       // HStack {
            
            GridRow {
            
            csCircleDashed(
                internalColor: .seaTurtle_1,
                dashedColor: transitoColor)
            
            Text("\(transitoScorte.simpleDescription()):")
            
            Text("\(filterCount) (\(stringValuePercent))")
                .fontWeight(.bold)
            
            vbAssociaIndicatoreVisivo(
                statoServizio: statoServizio,
                valoreAssociato: localStatoServizio)
        }
        
        
    }
    
    @ViewBuilder private func vbAssociaIndicatoreVisivo(statoServizio:StatoServizio,valoreAssociato:StatoServizio) -> some View {
        
        if statoServizio == valoreAssociato {
            
            let image = valoreAssociato.imageAssociata()
            let color = valoreAssociato.coloreAssociato()
            
            Image(systemName: image)
                .foregroundStyle(color)
        }
        
    }
    
    @ViewBuilder private func vbStatoServizio(
        statoIngredienti:StatoServizio,
        statoPreparati:StatoServizio) -> some View {
        // Nota 22.10
        HStack {
            
            Text("Stato:")
                .fontWeight(.semibold)
                .foregroundStyle(Color.black)
               
            HStack(spacing:0) {
                Image(systemName: "triangle.fill")
                    .imageScale(.small)
                    .foregroundStyle(statoIngredienti.coloreAssociato())
                    .rotationEffect(Angle(degrees: -90))
                
                Image(systemName: "triangle.fill")
                    .imageScale(.small)
                    .foregroundStyle(statoPreparati.coloreAssociato())
                    .rotationEffect(Angle(degrees: 90))
            }
            .shadow(radius: 10.0)
            .onTapGesture {
                self.viewModel.alertItem = AlertModel(
                    title: "Stato Servizio",
                    message: "Stato Ingredienti: \(statoIngredienti.simpleDescription())\nStato dei Prodotti di Terzi: \(statoPreparati.simpleDescription())")
            }

        }
      
    }
    
    private func checkStatoServizio(rifIngOrPrep:[String]) -> StatoServizio {
        
        let mapStatoScorte = rifIngOrPrep.map({self.viewModel.currentProperty.inventario.statoScorteIng(idIngredient: $0)})
        
        if mapStatoScorte.contains(.esaurito) { return .fareSpesa }
        
        else if mapStatoScorte.contains(.inEsaurimento) { return .controlloScorte(.inEsaurimento) }
        
        else if mapStatoScorte.contains(.inArrivo) { return .controlloScorte(.inArrivo)}
        
        else { return .ok }
        
    }
    
    // end Method Space
    
    private enum StatoServizio:Equatable {
        
        case ok
        case fareSpesa
        case controlloScorte(_ transito:Inventario.TransitoScorte) // limitato a .inArrivo, .inEsaurimento
        
        func simpleDescription() -> String {
            
            switch self {
                
            case .ok:
                return "Ok"
            case .fareSpesa:
                return "Spesa Necessaria"
            case .controlloScorte:
               return "Controllare Scorte"
            }
        }
        
        func coloreAssociato() -> Color {
            switch self {
            case .ok:
              return Color.seaTurtle_3
            case .fareSpesa:
                return Color.red//.opacity(0.8)
            case .controlloScorte(let transito):
                return transito.coloreAssociatoNotOpacity()
            }
        }
        
        func imageAssociata() -> String {
            
            switch self {
            case .ok:
              return "arrowtriangle.up.fill"
            case .fareSpesa:
              return "arrowtriangle.down.fill"
            case .controlloScorte(let transito):
                return transito == .inEsaurimento ? "arrowtriangle.down" : "arrowtriangle.up"
            }
            
        }
    }
}

struct MonitorModelView_Previews: PreviewProvider {
    static let allDish = testAccount.db.allMyDish.map({$0.id})
    static var previews: some View {
        
       /* NavigationStack {
            CSZStackVB(title: "Monitor", backgroundColorView: Color.seaTurtle_1) {
                MonitorServizio()
            }.environmentObject(testAccount)
        } */
        
        VistaEspansaDish_MonitorServizio(
            container: allDish,
            label: "Test",
            backgroundColorView: .seaTurtle_1)
        .environmentObject(testAccount)
        
    }
}



