//
//  Home.swift
//  SmallFoodApp
//
//  Created by hazem smawy on 10/2/22.
//

import SwiftUI

struct Home: View {
    // MARK: - View Properties
    @State var currentIndex: Int = 0
    @State var currentTab :Tab = tabs[1]
    @Namespace var animation
    
    // MARK: - Detail View Property
    @State var selectedMilkShake:MilkShake?
    @State var showDetail:Bool = false
    // MARK: - Body
    var body: some View {
       
        VStack {
            headerView()
            // MARK: - Attributed Text's
            VStack(alignment: .leading, spacing: 8) {
                Text(attributedTitle)
                    .font(.largeTitle.bold())
                
                Text(attributedSubTitle)
                    .font(.largeTitle.bold())

            }
            .padding(.horizontal, 15)
            .frame(maxWidth: .infinity, alignment: .leading)
            .opacity(showDetail ? 0: 1)
            
            GeometryReader { proxy in
                let size = proxy.size
                CarouselView(size: size)
            }
            .zIndex(-10)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .overlay(content: {
            if showDetail {
                DetailView(animation: animation, milkShake: selectedMilkShake!, show: $showDetail)
            }
        })
        .background {
            Color("LightGreen")
                .ignoresSafeArea()
        }
    }
    // MARK: - Carousel View
    
    @ViewBuilder
    func CarouselView(size: CGSize) -> some View {
        VStack(spacing: -40) {
            CustomCarousel(index: $currentIndex, items: milkShakes, spacing: 0, cardPadding: size.width / 3, id: \.id) { milkShake, _ in
                
                VStack(spacing: 10){
                    // MARK: -  applying Matched Geometry
                    ZStack {
                        if showDetail && selectedMilkShake?.id == milkShake.id {
                            Image(milkShake.image)
                                .resizable()
                                .scaledToFill()
                                .rotationEffect(.init(degrees: -2))
                                .opacity(0)
                        }else {
                            Image(milkShake.image)
                                .resizable() 
                                .scaledToFit()
                                .rotationEffect(.init(degrees: -2))
                                .matchedGeometryEffect(id: milkShake.id, in: animation)
                        }
                    }
                    .background {
                        RoundedRectangle(cornerRadius: size.width / 10)
                            .fill(Color("Light"))
                            .padding(.top, 40)
                            .padding(.horizontal, -10)
                            .offset(y: -10)
                    }
                    
                    Text(milkShake.title)
                        .fontWeight(.semibold)
                        .multilineTextAlignment(.center)
                        .padding(.top, 8)
                    
                    Text(milkShake.price)
                        .font(.callout)
                        .fontWeight(.black)
                        .foregroundColor(Color("LightGreen"))
                }
                .contentShape(Rectangle())
                .onTapGesture {
                    withAnimation(.interactiveSpring(response: 0.5, dampingFraction: 0.8, blendDuration: 0.8)){
                        selectedMilkShake = milkShake
                        showDetail = true
                    }
                }
                
                
            }
            .frame( height: size.height * 0.8)
            
            indicators()
                .padding(.bottom, 8)
        }
        .frame(width: size.width, height: size.height, alignment: .bottom)
        .opacity(showDetail ? 0: 1)
        .background {
            CustomArcShape()
                .fill(.white)
                .scaleEffect(showDetail ? 1.8 : 1 , anchor: .bottomLeading)
                .ignoresSafeArea()
                .overlay(alignment: .top) {
                    TabMenu()
                        .opacity(showDetail ? 0: 1)
                }
                .padding(.top, 40)
               
        }
       
    }
    // MARK: - Tab Menus
    @ViewBuilder
    func TabMenu() -> some View {
        HStack(spacing: 30) {
            ForEach(tabs) { tab in
                Image(tab.tabImage)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 40, height: 50)
                    .padding(10)
                    .background {
                        Circle()
                            .fill(Color("Light"))
                    }
                    .offset(tab.tabOffset)
                    .scaleEffect(currentTab.id == tab.id ? 1.25 : 0.94, anchor: .bottom)
                    .onTapGesture {
                        withAnimation(.easeInOut){
                            currentTab = tab
                        }
                    }
            }
        }
    }
    // MARK: - Header View
    
    @ViewBuilder
    func headerView() -> some View {
        HStack {
            Button {
                //
            } label: {
                HStack(spacing: 10){
                    Image("download")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 35, height: 35)
                        .clipShape(Circle())
                    
                    Text("Hazem")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.black)
                    
                }
                .padding(.leading,8)
                .padding(.trailing, 12)
                .padding(.vertical, 6)
                .background {
                    Capsule()
                        .fill(Color("Light"))
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .opacity(showDetail ? 0: 1)
            Button {
                //
            } label: {
                Image(systemName: "cart")
                    .font(.title2)
                    .foregroundColor(.black)
                    .overlay(alignment: .topTrailing) {
                        Circle()
                            .fill(.red)
                            .frame(width: 10, height: 10)
                            .offset(x: 2, y: -5)
                    }
            }


        }
        .padding(15)
    }
    
    // MARK: - Indicators
    @ViewBuilder
    func indicators()-> some View {
        HStack(spacing: 2){
            ForEach(milkShakes.indices, id :\.self){ index in
                Circle()
                    .fill(Color("LightGreen"))
                    .frame(width: currentIndex == index ? 10: 6, height: currentIndex == index ? 10 : 6)
                    .padding(4)
                    .background {
                        if currentIndex == index {
                            Circle()
                                .stroke(Color("LightGreen"),lineWidth: 1)
                                .matchedGeometryEffect(id: "INDICATOR", in: animation)
                        }
                    }
            }
        }
        .animation(.easeInOut,value: currentIndex)
    }
    // MARK: - Attributed Text's
    var attributedTitle:AttributedString {
        var attString = AttributedString(stringLiteral: "Good Food,")
        
        if let range = attString.range(of: "Food,") {
            attString[range].foregroundColor = .white
        }
        return attString
    }
    
    var attributedSubTitle:AttributedString {
        var attString = AttributedString(stringLiteral: "Good Mood,")
        
        if let range = attString.range(of: "Good") {
            attString[range].foregroundColor = .white
        }
        return attString
    }
}

struct Home_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}

struct DetailView:View {
    // MARK: - Property
    var animation: Namespace.ID
    var milkShake :MilkShake
    @Binding var show:Bool
    @State var orderType:String = "Active Order"
    @State var showContent:Bool = false
    
    // MARK: - Body
    var body: some View {
        VStack {
            HStack {
                Button {
                    withAnimation(.easeInOut(duration: 0.35)){
                        showContent = false
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1){
                        withAnimation(.easeInOut(duration: 0.35)){
                            show = false
                        }
                    }
                } label: {
                    Image(systemName: "arrow.left")
                        .font(.title2)
                        .foregroundColor(.black)
                        .padding(15)
                }
                .frame(maxWidth: .infinity, alignment: .leading)

            }
            .overlay {
                Text("Details")
                    .font(.callout)
                    .fontWeight(.semibold)
            }
            .padding(.top, 7)
            .opacity(showContent ? 1: 0)
            
            HStack(spacing:0){
                ForEach(["Active Order","Past Order","Orders"], id: \.self){ order in
                   Text(order)
                        .font(.system(size:15, weight: .semibold))
                        .foregroundColor(orderType == order ? .black : .gray)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 10)
                        .background {
                            if orderType == order {
                                Capsule()
                                    .fill(Color("Light"))
                                    .matchedGeometryEffect(id: "ORDERTAB", in: animation)
                            }
                        }
                        .onTapGesture {
                            withAnimation(.easeInOut) {
                                orderType = order
                            }
                        }
                        
                }
            }
            .padding(.leading, 15)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.bottom)
            .opacity(showContent ? 1: 0)
            
            Image(milkShake.image)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .rotationEffect(.init(degrees: -2))
                .matchedGeometryEffect(id: milkShake.id, in: animation)
            
            GeometryReader { proxy in
                let size = proxy.size
                MilkShakeDetails()
                    .offset(y: showContent ? 0 : size.height + 50)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity , alignment: .top)
        .transition(.asymmetric(insertion: .identity, removal: .offset(y: 0.5)))
        .onAppear {
            withAnimation(.easeInOut.delay(0.1)){
                showContent = true
            }
        }
    }
    
    @ViewBuilder
    func MilkShakeDetails() -> some View {
        VStack {
            VStack(spacing: 12, content: {
                
                Text("#512D Code")
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundColor(.black)
                
                Text(milkShake.title)
                    .font(.title2)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.center)
                
                
                Text("\(milkShake.price)")
                    .font(.callout)
                    .fontWeight(.bold)
                    .foregroundColor(Color("LightGreen"))
                
                Text("20min delivery")
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundColor(.gray)
                
                HStack(spacing:20){
                    Text("Quantity: ")
                        .font(.callout.bold())
                       
                    Button {
                        //
                    } label: {
                        Image(systemName: "minus")
                            .font(.title3)
                    }
                    Text("2")
                        .font(.title)
                        
                    Button {
                        //
                    } label: {
                        Image(systemName: "plus")
                            .font(.title3)
                    }

                   

                }
                .foregroundColor(.gray)
                
                Button {
                    //
                } label: {
                    Text("Add to Cart")
                        .font(.callout)
                        .foregroundColor(.black)
                        .fontWeight(.semibold)
                        .padding(.horizontal, 25)
                        .padding(.vertical, 10)
                        .background{
                            Capsule()
                                .fill(Color("LightGreen"))
                        }
                }
                .padding(.top, 10)
            })
            .padding(.vertical, 20)
            .frame(maxWidth: .infinity)
            .background{
                RoundedRectangle(cornerRadius: 40)
                    .fill(Color("Light"))
            }
            .padding(.horizontal, 40)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}
