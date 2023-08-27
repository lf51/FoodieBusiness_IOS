//
//  CS_BoxContainer.swift
//  DishRevueBackIOS
//
//  Created by Calogero Friscia on 09/06/22.
//

import SwiftUI

struct CS_BoxContainer<Big,S1,S2,S3>: View where Big:View, S1:View, S2:View, S3:View {
    
    @ViewBuilder var bigBox: Big
    @ViewBuilder var smallBoxUp: S1
    @ViewBuilder let smallBoxMiddle: S2
    @ViewBuilder let smallBoxDown: S3
    
    var body: some View {
        
     //   CSZStackVB(title: "@lillofree", backgroundColorView: Color.seaTurtle_1) {
            
          //  VStack(alignment:.leading) {
          
                        HStack {
                                     
                            NavigationLink {
                                bigBox
                            } label: {
                                
                                Text("Piatti + Ingredienti")
                                    .fontWeight(.heavy)
                                    .font(.system(.largeTitle, design: .default))
                                    .shadow(radius: 1.0)
                                    .foregroundStyle(Color.seaTurtle_2)
                                    .padding()
                                    .frame(width: 250, height: 225,alignment: .bottomTrailing)
                                    .background(Color.seaTurtle_4.blur(radius: 4.0))
                                    .cornerRadius(20.0)
                                    .shadow(radius: 5.0)
                          
                            }
              
                            Spacer()
                            
                            VStack {
                                
                                NavigationLink {
                                   smallBoxUp
                                } label: {
                                    Text("Categorie")
                                        .fontWeight(.semibold)
                                        .font(.system(.caption, design: .default))
                                        .shadow(radius: 1.0)
                                        .foregroundStyle(Color.seaTurtle_2)
                                        .padding()
                                        .frame(width: 100, height: 70,alignment: .bottomTrailing)
                                        .background(Color.seaTurtle_4.blur(radius: 2.0))
                                        .cornerRadius(20.0)
                                        .shadow(radius: 5.0)
                                }

                                NavigationLink {
                                   smallBoxMiddle
                                } label: {
                                    Text("Categorie")
                                        .fontWeight(.semibold)
                                        .font(.system(.caption, design: .default))
                                        .shadow(radius: 1.0)
                                        .foregroundStyle(Color.seaTurtle_2)
                                        .padding()
                                        .frame(width: 100, height: 70,alignment: .bottomTrailing)
                                        .background(Color.seaTurtle_4.blur(radius: 2.0))
                                        .cornerRadius(20.0)
                                        .shadow(radius: 5.0)
                                }
                                
                                NavigationLink {
                                    smallBoxDown
                                } label: {
                                    Text("Categorie")
                                        .fontWeight(.semibold)
                                        .font(.system(.caption, design: .default))
                                        .shadow(radius: 1.0)
                                        .foregroundStyle(Color.seaTurtle_2)
                                        .padding()
                                        .frame(width: 100, height: 70,alignment: .bottomTrailing)
                                        .background(Color.seaTurtle_4.blur(radius: 2.0))
                                        .cornerRadius(20.0)
                                        .shadow(radius: 5.0)
                                }
                              
                            }
         
                        }
                        .padding(.horizontal)
                      //  .frame(maxWidth: 500, maxHeight: 225)
                      //  .background(Color.red)
          //  }//.padding(.horizontal)
          
       // }
    }
}

struct CS_BoxContainer_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            
            CS_BoxContainer {
                Text("BigOne")
            } smallBoxUp: {
                Color.red
            } smallBoxMiddle: {
                Circle()
                    .foregroundStyle(Color.yellow)
            } smallBoxDown: {
                Image(systemName: "circle")
            }

            
        }//.navigationViewStyle(StackNavigationViewStyle())
    }
}
