//
//  ScheduleServizio.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 29/10/22.
//

import SwiftUI
import MyFoodiePackage
import MyPackView_L0

struct ScheduleServizio:View {
    
    @EnvironmentObject var viewModel:AccounterVM
    
    @State private var openAllDetail:Bool = false
    @State private var espandiAllDate:Bool = false
    
    var body: some View {
        
        VStack(alignment: .leading,spacing:.vStackBoxSpacing) {
            
            let (allMenuExactDate,menuByDay) = self.ricavaScheduleServizio()
        
            vbWeeklySchedule(menuByDay: menuByDay)
                .id(self.openAllDetail)
            vbMenuConDataSpecifica(allMenuExactDate: allMenuExactDate)
                .id(self.espandiAllDate)
            
        }
    
    }
    // Method
    
    private func ricavaScheduleServizio() -> (menuDataEsatta:[MenuModel],menuByDay:[GiorniDelServizio:[MenuModel]]) {
        
        // .1
        let allMenuAvaible = self.viewModel.currentProperty.db.allMyMenu.filter({
            $0.status.checkStatusTransition(check: .disponibile)})
        
        let allMenuDataEsatta = allMenuAvaible.filter({$0.isAvaibleWhen == .dataEsatta})
      /*  let allDataEsatta = allMenuAvaible.filter({$0.isAvaibleWhen == .dataEsatta}).sorted(by: {$0.dataInizio < $1.dataInizio}) */

       // let allExactDate = allDataEsatta.map({$0.id})
        
        // .2
        let allRange = allMenuAvaible.filter({
            $0.isAvaibleWhen == .intervalloAperto ||
            $0.isAvaibleWhen == .intervalloChiuso
        })
       
        let allRangeActive = allRange.filter({
            $0.dataInizio < Date.now
        })
        
        let menuByDay:[GiorniDelServizio:[MenuModel]] = {
            
            var mpDict:[GiorniDelServizio:[MenuModel]] = [:]
            
            for day in GiorniDelServizio.allCases {
                
                let filterByDay = allRangeActive.filter({$0.giorniDelServizio.contains(day)})
                
                mpDict.updateValue(filterByDay, forKey: day)
            }
            
            return mpDict
        }()
    
        return (allMenuDataEsatta,menuByDay)
    }
    
   /* private func ricavaScheduleServizio() -> (rifMenuDataEsatta:[String],menuByDay:[GiorniDelServizio:[MenuModel]]) {
        
        // .1
        let allMenuAvaible = self.viewModel.allMyMenu.filter({
            $0.status.checkStatusTransition(check: .disponibile)})
        
        let allDataEsatta = allMenuAvaible.filter({$0.isAvaibleWhen == .dataEsatta}).sorted(by: {$0.dataInizio < $1.dataInizio})

        let allExactDate = allDataEsatta.map({$0.id})
        
        // .2
        let allRange = allMenuAvaible.filter({
            $0.isAvaibleWhen == .intervalloAperto ||
            $0.isAvaibleWhen == .intervalloChiuso
        })
       
        let allRangeActive = allRange.filter({
            $0.dataInizio < Date.now
        })
        
        let menuByDay:[GiorniDelServizio:[MenuModel]] = {
            
            var mpDict:[GiorniDelServizio:[MenuModel]] = [:]
            
            for day in GiorniDelServizio.allCases {
                
                let filterByDay = allRangeActive.filter({$0.giorniDelServizio.contains(day)})
                
                mpDict.updateValue(filterByDay, forKey: day)
            }
            
            return mpDict
        }()
    
        return (allExactDate,menuByDay)
    } */ // backUp 03.03.23
    
    @ViewBuilder private func vbWeeklySchedule(menuByDay:[GiorniDelServizio:[MenuModel]]) -> some View {
    
        VStack(alignment:.leading,spacing:.vStackLabelBodySpacing) {
            
            let disableExpand:Bool = {
                let map = menuByDay.flatMap({$0.value})
                return map.isEmpty
            }()
            
                HStack {

                  Text("Orario Settimanale:")
                        .font(.system(.headline, design: .monospaced, weight: .black))
                        .foregroundColor(.seaTurtle_2)
                   
                    //Espande e chiude Tutto
                
                  CSButton_image(
                    activationBool: self.openAllDetail,
                    frontImage: "arrow.down.and.line.horizontal.and.arrow.up",
                    backImage: "arrow.up.and.line.horizontal.and.arrow.down",
                    imageScale: .medium,
                    backColor: .seaTurtle_4,
                    frontColor: .seaTurtle_3) {
                        withAnimation {
                            self.openAllDetail.toggle()
                        }
                    }
                    .csModifier(disableExpand) { view in
                        view.opacity(0.6)
                            .disabled(true)
                    }
                   // .disabled(disableExpand)
                    
                    Spacer()
                    CSInfoAlertView(title: "Info", message: .infoScheduleServizio)
                }

                VStack(alignment:.leading,spacing:8) {
                    
                    let order = menuByDay.sorted { $0.key.orderAndStorageValue() < $1.key.orderAndStorageValue() }
                    
                    ForEach(order, id: \.key) { key, value in
                    
                        DayWeekTimeRow(
                            key: key,
                            value: value,
                            openDetail: self.openAllDetail)
                          
                    }
                }
            }
    }
    
    @ViewBuilder private func vbMenuConDataSpecifica(allMenuExactDate:[MenuModel]) -> some View {
        
        let allDate = allMenuExactDate.map({ $0.dataInizio })// .sorted(by: <)
        let allStringDate = Set( allDate.map({csTimeFormatter().data.string(from: $0)}) ) // per controllo
        let allStringDateArray = Array(allStringDate)
        let orderedStringDate = allStringDateArray.sorted(by: {
            csCompareDateString(lhs: $0, rhs: $1)
        })
        
        let disableExpand:Bool = orderedStringDate.isEmpty
        
      //  let cleaned = allStringDate.flatmap({ csTimeFormatter().data.date(from: $0) })
      //  let cleanedAndSorted = Array(cleaned.sorted(by: < ))
        
        VStack(alignment:.leading,spacing:.vStackLabelBodySpacing) {
                
            HStack {
                
                Text("Date con Menu Specifici:")
                    .font(.system(.headline, design: .monospaced, weight: .black))
                    .foregroundColor(.seaTurtle_2)
                
                CSButton_image(
                  activationBool: self.espandiAllDate,
                  frontImage: "arrow.down.and.line.horizontal.and.arrow.up",
                  backImage: "arrow.up.and.line.horizontal.and.arrow.down",
                  imageScale: .medium,
                  backColor: .seaTurtle_4,
                  frontColor: .seaTurtle_3) {
                      withAnimation {
                          self.espandiAllDate.toggle()
                      }
                  }
                  .csModifier(disableExpand) {view in
                      view
                          .opacity(0.6)
                          .disabled(true)
                  }
                
            }
            
            ForEach(orderedStringDate,id: \.self) { dataEsatta in
                
                let allMenuOfTheDay = allMenuExactDate.filter({
                    let stringDate = csTimeFormatter().data.string(from: $0.dataInizio)
                    return stringDate == dataEsatta
                    
                })
                
                ExactDateSchedule(
                    dataEsatta:dataEsatta,
                    allMenuOfTheDay: allMenuOfTheDay,
                    expandAll: self.espandiAllDate)
                
                
            }
            
            
            
            
          /*  ExactDateSchedule(
                allMenuExactDate: allMenuExactDate,
                orderedStringDate: orderedStringDate,
                expandAll: self.espandiAllDate) */
            
          /*  ForEach(orderedStringDate,id:\.self) { dataEsatta in
                
               // let exactDay = csTimeFormatter().data.string(from: dataEsatta)
               
               // let dataModel = csTimeFormatter().data.date(from: dataEsatta)
                let allMenuOfTheDay = allMenuExactDate.filter({
                    let stringDate = csTimeFormatter().data.string(from: $0.dataInizio)
                    return stringDate == dataEsatta
                    
                })
                
                Text(dataEsatta)
                    .font(.system(.body, design: .monospaced, weight: .semibold))
                    .foregroundColor(.seaTurtle_4)
                
                ForEach(allMenuOfTheDay) { menuModel in
                    
                    let disable = menuModel.tipologia.isDiSistema()
                    
                    VStack(alignment:.leading,spacing:3) {
                        
                        HStack {
                            
                            Text("\(menuModel.intestazione)")
                                .foregroundColor(.black)
                                .fontWeight(.semibold)
                                .font(.subheadline)
                            
                            NavigationLink(value: DestinationPathView.menu(menuModel)) {
                                Image(systemName: "arrow.up.forward.app")
                                    .foregroundColor(disable ? .seaTurtle_1 : .seaTurtle_3)
                            }
                           // .opacity(disable ? 0.5 : 1.0)
                            .disabled(disable)
                            
                        }
                        
                        Text("\(menuModel.descrizione)")
                            .italic()
                            .font(.subheadline)
                            .multilineTextAlignment(.leading)
                            .foregroundColor(Color.black)
                    }
                    
                }
                
                
                
            } */
                
              /* ForEach(allExactDate,id:\.self) { rif in
                    
                    if let model = self.viewModel.modelFromId(id: rif, modelPath: \.allMyMenu) {
                        
                       // let dataExact = csTimeFormatter().data.string(from: model.dataInizio)
                       // let disable = model.tipologia.isDiSistema()
                        
                        VStack(alignment:.leading,spacing:5) {
                            
                            HStack {

                                Text(dataExact)
                                    .font(.system(.body, design: .monospaced, weight: .semibold))
                                    .foregroundColor(.seaTurtle_4)
                                
                                NavigationLink(value: DestinationPathView.menu(model)) {
                                    Image(systemName: "arrow.up.forward.app")
                                        .foregroundColor(.seaTurtle_3)
                                }
                                .opacity(disable ? 0.5 : 1.0)
                                .disabled(disable)
                                
                            }
                            
                            VStack(alignment:.leading,spacing:3) {
                                
                                Text("\(model.intestazione)")
                                    .foregroundColor(.black)
                                    .fontWeight(.semibold)
                                    .font(.subheadline)
                                
                                Text("\(model.descrizione)")
                                    .italic()
                                    .font(.subheadline)
                                    .multilineTextAlignment(.leading)
                                    .foregroundColor(Color.black)
                            }
                        }
                    }
                } */
            }
        
    }
    
    /*
    @ViewBuilder private func vbMenuConDataSpecifica(allExactDate:[String]) -> some View {
        
        VStack(alignment:.leading,spacing:.vStackLabelBodySpacing) {
                
                Text("Date con Menu Specifici:")
                    .font(.system(.headline, design: .monospaced, weight: .black))
                    .foregroundColor(.seaTurtle_2)
                
                ForEach(allExactDate,id:\.self) { rif in
                    
                    if let model = self.viewModel.modelFromId(id: rif, modelPath: \.allMyMenu) {
                        
                        let dataExact = csTimeFormatter().data.string(from: model.dataInizio)
                        let disable = model.tipologia.isDiSistema()
                        
                        VStack(alignment:.leading,spacing:5) {
                            
                            HStack {

                                Text(dataExact)
                                    .font(.system(.body, design: .monospaced, weight: .semibold))
                                    .foregroundColor(.seaTurtle_4)
                                
                                NavigationLink(value: DestinationPathView.menu(model)) {
                                    Image(systemName: "arrow.up.forward.app")
                                        .foregroundColor(.seaTurtle_3)
                                }
                                .opacity(disable ? 0.5 : 1.0)
                                .disabled(disable)
                                
                            }
                            
                            VStack(alignment:.leading,spacing:3) {
                                
                                Text("\(model.intestazione)")
                                    .foregroundColor(.black)
                                    .fontWeight(.semibold)
                                    .font(.subheadline)
                                
                                Text("\(model.descrizione)")
                                    .italic()
                                    .font(.subheadline)
                                    .multilineTextAlignment(.leading)
                                    .foregroundColor(Color.black)
                            }
                        }
                    }
                }
            }
        
    }*/ // Backup 03.03.23
}

private struct ExactDateSchedule:View {
    
   // let allMenuExactDate:[MenuModel]
  // let orderedStringDate:[String]
    let dataEsatta:String
    let allMenuOfTheDay:[MenuModel]
    @State private var expand:Bool
    
    init(dataEsatta:String,allMenuOfTheDay:[MenuModel],expandAll:Bool) {
        
       // self.allMenuExactDate = allMenuExactDate
       // self.orderedStringDate = orderedStringDate
        self.dataEsatta = dataEsatta
        self.allMenuOfTheDay = allMenuOfTheDay
        _expand = State(wrappedValue: expandAll)
        
    }
   
    var body: some View {
        
      /* ForEach(orderedStringDate,id:\.self) { dataEsatta in

            let allMenuOfTheDay = allMenuExactDate.filter({
                let stringDate = csTimeFormatter().data.string(from: $0.dataInizio)
                return stringDate == dataEsatta
                
            })*/
            
            HStack {
                
                Text(dataEsatta)
                    .font(.system(.body, design: .monospaced, weight: .semibold))
                    .foregroundColor(.seaTurtle_4)
                
                CSButton_image(
                    activationBool: self.expand,
                    frontImage: "chevron.compact.up",
                    backImage: "chevron.compact.down",
                    imageScale: .medium,
                    backColor: .seaTurtle_4,
                    frontColor: .seaTurtle_3) {
                        withAnimation {
                            self.expand.toggle()
                        }
                    }
                
            }
            
            if expand {
                
                ForEach(allMenuOfTheDay) { menuModel in
                    
                    let disable = menuModel.tipologia.isDiSistema()
                    
                    VStack(alignment:.leading,spacing:3) {
                        
                        HStack {
                            
                            Text("\(menuModel.intestazione)")
                                .foregroundColor(.black)
                                .fontWeight(.semibold)
                                .font(.subheadline)
                            
                            NavigationLink(value: DestinationPathView.menu(menuModel, .ridotto)) {
                                Image(systemName: "arrow.up.forward.app")
                                    .foregroundColor(disable ? .seaTurtle_1 : .seaTurtle_3)
                            }
                           // .opacity(disable ? 0.5 : 1.0)
                            .disabled(disable)
                            
                        }
                        
                        Text("\(menuModel.descrizione)")
                            .italic()
                            .font(.subheadline)
                            .multilineTextAlignment(.leading)
                            .foregroundColor(Color.black)
                    }
                    
                }
            }
 
       // }
    }
    
}

private struct DayWeekTimeRow:View {
    
    let key:GiorniDelServizio
    let value:[MenuModel]
    
    @State private var openDetail:Bool
    
    init(key:GiorniDelServizio,value:[MenuModel],openDetail:Bool)  {
        
        self.key = key
        self.value = value
        _openDetail = State(wrappedValue: openDetail)
        
    }
    
    var body: some View {
        
            let (stringOpenTime,stringCloseTime) = weekTimeRow()
            let disableAction = value.isEmpty

        HStack {
            
            HStack(spacing:5) {
            
                Image(systemName: "\(key.imageAssociated()).fill")
                    .imageScale(.large)
                    .foregroundColor(.seaTurtle_2)
                    .opacity(disableAction ? 0.4 : 1.0)
        
                Text(key.simpleDescription())
                    .font(.system(.headline, design: .monospaced, weight: .semibold))
                    .foregroundColor(Color.black)

                    }
            
            Spacer()

            HStack(spacing:3) {
                
                Text("\(stringOpenTime)")
                    .foregroundColor(Color.green)
                    .fontWeight(.semibold)
                    .opacity(0.8)
        
                Text("-")
                    .font(.subheadline)
                    .foregroundColor(Color.gray)
                   
                Text("\(stringCloseTime)")
                    .foregroundColor(Color.red)
                    .brightness(0.05)
                    .fontWeight(.black)
                    .opacity(0.7)
            }
            .font(.headline)
            .lineLimit(1)
            .minimumScaleFactor(0.75)
    
                        CSButton_image(
                            activationBool: self.openDetail,
                            frontImage: "chevron.compact.up",
                            backImage: "chevron.compact.down",
                            imageScale: .medium,
                            backColor: .seaTurtle_4,
                            frontColor: .seaTurtle_3) {
                                withAnimation {
                                    self.openDetail.toggle()
                                }
                            }
                            .opacity(disableAction ? 0.6 : 1.0)
                            .disabled(disableAction)

                }
        
        if self.openDetail {
            
          vbDetail(open: stringOpenTime, close: stringCloseTime)
            
        }

    }
    // Method
    
    @ViewBuilder private func vbDetail(open:String,close:String) -> some View {

        let sortedValue = value.sorted(by: {
            csTimeConversione(data: $0.oraInizio) < csTimeConversione(data: $1.oraInizio)
        })
        let enumeratedValue = Array(sortedValue.enumerated())
        
        ForEach(enumeratedValue,id:\.element) { position,value in
            
            let openTime = csTimeFormatter().ora.string(from: value.oraInizio)
            let openThePlace:Color = {
                if openTime == open { return Color.green.opacity(0.7)}
                else { return Color.seaTurtle_4.opacity(0.1)}
            }()
            
            let closeTime = csTimeFormatter().ora.string(from: value.oraFine)
            let closeThePlace:Color = {
                if closeTime == close { return Color.red.opacity(0.7)}
                else { return Color.seaTurtle_4.opacity(0.2) }
            }()
            
            let posizione = position + 1
            
            VStack(alignment: .leading, spacing: 3) {

                        Text("\(posizione). \(value.intestazione)")
                            .foregroundColor(Color.seaTurtle_4)
                            .fontWeight(.semibold)
                            .font(.subheadline)
                            .lineLimit(1)

                HStack(spacing:20) {
                        
                        HStack(spacing:5) {
                            Text("Start:")
                            Text("\(openTime)")
                        }
                        .foregroundColor(Color.black)
                        .font(.subheadline)
                        .padding(.vertical,2)
                        .padding(.horizontal,4)
                        .background { openThePlace.cornerRadius(5.0) }

                        HStack(spacing:5) {
                            Text("End:")
                            Text("\(closeTime)")
                        }
                        .foregroundColor(Color.black)
                        .fontWeight(.semibold)
                        .font(.subheadline)
                        .padding(.vertical,2)
                        .padding(.horizontal,4)
                        .background { closeThePlace.cornerRadius(5.0) }
                        
                        Spacer()
                    
                    NavigationLink(value: DestinationPathView.menu(value,.ridotto)) {
               
                            Image(systemName: "arrow.up.forward.circle")
                                .imageScale(.medium)
                                .foregroundColor(.seaTurtle_3)
                        
                        }
                    
                    }

                if value.descrizione != "" {

                        Text(value.descrizione)
                            .italic()
                            .font(.caption)
                            .multilineTextAlignment(.leading)
                            .foregroundColor(Color.black)
                }
                
                Divider()
            }
        }
        
        
    }
    
    private func weekTimeRow() -> (openTime:String,closeTime:String) {
        
        let orario:[Int] = {
            
            self.value.map({csTimeConversione(data: $0.oraInizio)}) +
            self.value.map({csTimeConversione(data: $0.oraFine)})
            
        }()
        guard let oraApertura = orario.min() else { return ("","Chiuso")}
       
        let reverseOpenDate = csTimeReverse(value: oraApertura)
        let stringOpenTime = csTimeFormatter().ora.string(from: reverseOpenDate) //.1
        
        let oraChiusura = orario.max() ?? 0
        let reverseCloseDate = csTimeReverse(value: oraChiusura)
        let stringCloseTime = csTimeFormatter().ora.string(from: reverseCloseDate) // .2
 
        return (stringOpenTime,stringCloseTime)
    }
}
