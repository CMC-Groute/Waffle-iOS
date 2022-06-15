//
//  HomeCardView.swift
//  Waffle
//
//  Created by 조한빛 on 2022/06/15.
//

import SwiftUI

struct Post: Identifiable {
    var id = UUID().uuidString
    var postImage: String
}

struct HomeCardView: View {
    @State var currentIndex: Int = 0
    @State var post: [Post] = []
    var body: some View {
        VStack(spacing: 15) {
            SanpCarousel(index: $currentIndex, items: post) {
                post in
                GeometryReader{proxy in
                    let size = proxy.size
                    Image(post.postImage)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: size.width)
                        .cornerRadius(12)
                }
            }.background(Color.black)
            .padding(.vertical, 80)
            
        }.frame(maxHeight: .infinity, alignment: .top)
            .onAppear {
                for index in 1...5 {
                    post.append(Post(postImage: "post\(index)"))
                }
            }
            .background(Color.yellow)
    }
}

struct SanpCarousel<Content: View, T: Identifiable>: View {
    
    var content: (T) -> Content
    var list: [T]
    
    var spacing: CGFloat
    var trailingSpace: CGFloat
    @Binding var index: Int
    
    init(spacing: CGFloat = 15, trailingSpace: CGFloat = 100, index: Binding<Int>, items: [T], @ViewBuilder content: @escaping (T) -> Content) {
        self.list = items
        self.spacing = spacing
        self.trailingSpace = trailingSpace
        self._index = index
        self.content = content
    }
    @GestureState var offset: CGFloat = 0
    @State var currentIndex: Int = 0
    
    var body: some View {
        GeometryReader { proxy in
            //setting correct width for snap carousel
            
            let width = proxy.size.width - trailingSpace
            let adjustMentWidth = (trailingSpace / 2) - spacing
            HStack(spacing: spacing) {
                ForEach(list) {item in
                    content(item)
                        .frame(width: proxy.size.width - trailingSpace)
                }
            }.padding(.horizontal, spacing)
                //setting only after 0th index
                .offset(x: (CGFloat(currentIndex) * -width) + (currentIndex == 0 ? adjustMentWidth : 0) + offset)
                .gesture(
                 DragGesture()
                    .updating($offset, body: { value, out, _ in
                        out = value.translation.width
                    }).onEnded({ value in
                        // 손을 놨을때 index update
                        let offsetX = value.translation.width
                        let progress = -offsetX / width
                        let roundIndex = progress.rounded()
                        
                        currentIndex = max(min(currentIndex + Int(roundIndex), list.count - 1), 0)
                        
                        currentIndex = index
                    }).onChanged( { value in
                        let offsetX = value.translation.width
                        let progress = -offsetX / width
                        let roundIndex = progress.rounded()
                        index = max(min(currentIndex + Int(roundIndex), list.count - 1), 0)
                    })
                )
        }.background(Color.pink)
            .animation(.easeOut, value: offset == 0)
    }
    
}

struct HomeCardView_Previews: PreviewProvider {
    static var previews: some View {
        HomeCardView()
    }
}
