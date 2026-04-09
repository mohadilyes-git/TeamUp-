//
//  GuideView.swift
//  TeamUp
//
//  Created by Ilyes Mo on 09/04/2026.
//

import SwiftUI

// Article model
struct GuideArticle: Identifiable {
    var id = UUID()
    var title: String
    var subtitle: String
    var icon: String
    var iconColor: Color
    var content: String
}

// Category model
struct GuideCategory: Identifiable {
    var id = UUID()
    var title: String
    var articles: [GuideArticle]
}

struct GuideView: View {
    
    let categories: [GuideCategory] = []
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(hex: "FDF6EC").ignoresSafeArea()
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 24) {
                        
                        Text("Everything you need to know about renting and living with roommates in the UK.")
                            .font(.system(size: 16))
                            .foregroundColor(.gray)
                            .padding(.horizontal)
                            .padding(.top, 8)
                        
                        ForEach(categories) { category in
                            VStack(alignment: .leading, spacing: 12) {
                                
                                Text(category.title)
                                    .font(.system(size: 13, weight: .semibold))
                                    .foregroundColor(.gray)
                                    .textCase(.uppercase)
                                    .tracking(1)
                                    .padding(.horizontal)
                                
                                VStack(spacing: 0) {
                                    ForEach(Array(category.articles.enumerated()), id: \.element.id) { index, article in
                                        NavigationLink(destination: ArticleView(article: article)) {
                                            ArticleCardView(article: article)
                                        }
                                        .buttonStyle(.plain)
                                        
                                        if index < category.articles.count - 1 {
                                            Divider()
                                                .padding(.leading, 70)
                                        }
                                    }
                                }
                                .background(Color.white)
                                .cornerRadius(16)
                                .padding(.horizontal)
                            }
                        }
                        
                        Spacer().frame(height: 100)
                    }
                    .padding(.top, 8)
                }
            }
            .navigationTitle("Guide")
            .navigationBarTitleDisplayMode(.large)
        }
    }
}

// Article card row
struct ArticleCardView: View {
    let article: GuideArticle
    
    var body: some View {
        HStack(spacing: 14) {
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .fill(article.iconColor)
                    .frame(width: 42, height: 42)
                Image(systemName: article.icon)
                    .font(.system(size: 18))
                    .foregroundColor(Color(red: 0.498, green: 0.467, blue: 0.867))
            }
            
            VStack(alignment: .leading, spacing: 3) {
                Text(article.title)
                    .font(.system(size: 15, weight: .medium))
                    .foregroundColor(.primary)
                Text(article.subtitle)
                    .font(.system(size: 13))
                    .foregroundColor(.gray)
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .font(.system(size: 13))
                .foregroundColor(.gray.opacity(0.5))
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
    }
}
// Full article screen
struct ArticleView: View {
    let article: GuideArticle
    
    var body: some View {
        ZStack {
            Color(hex: "FDF6EC").ignoresSafeArea()
            
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    
                    // Article header
                    HStack(spacing: 14) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 14)
                                .fill(article.iconColor)
                                .frame(width: 56, height: 56)
                            Image(systemName: article.icon)
                                .font(.system(size: 24))
                                .foregroundColor(Color(red: 0.498, green: 0.467, blue: 0.867))
                        }
                        VStack(alignment: .leading, spacing: 4) {
                            Text(article.title)
                                .font(.system(size: 22, weight: .bold))
                                .foregroundColor(.primary)
                            Text(article.subtitle)
                                .font(.system(size: 14))
                                .foregroundColor(.gray)
                        }
                    }
                    .padding(.top, 8)
                    
                    Divider()
                    
                    // Article content
                    Text(article.content)
                        .font(.system(size: 16))
                        .foregroundColor(.primary)
                        .lineSpacing(6)
                    
                    Spacer().frame(height: 40)
                }
                .padding(.horizontal)
            }
        }
        .navigationTitle(article.title)
        .navigationBarTitleDisplayMode(.inline)
    }
}
#Preview {
    GuideView()
}
