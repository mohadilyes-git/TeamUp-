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
    
    let categories: [GuideCategory] = [
        GuideCategory(title: "Renting in the UK", articles: [
            GuideArticle(
                title: "How renting works",
                subtitle: "Tenancy types, deposits, contracts",
                icon: "house.fill",
                iconColor: Color(hex: "EEEDFE"),
                content: """
                Renting in the UK involves signing a tenancy agreement with a landlord or letting agent. Here is what you need to know:

                Types of tenancy
                The most common type is an Assured Shorthold Tenancy (AST). This usually lasts 6 or 12 months and gives both you and the landlord certain rights and responsibilities.

                The tenancy agreement
                This is a legally binding contract. Read it carefully before signing. It should include the rent amount, payment date, deposit amount, notice period and any rules about pets or smoking.

                Deposits
                Landlords can ask for a deposit of up to 5 weeks rent. This must be protected in a government-approved scheme within 30 days of you paying it.

                Rent in advance
                Most landlords ask for one or two months rent in advance. Make sure you get a receipt for any payments you make.

                Inventory check
                When you move in, make sure an inventory is done. This lists the condition of the property and its contents. Take photos of any existing damage to protect yourself when you move out.

                Notice periods
                During a fixed term tenancy you usually cannot leave early unless the landlord agrees. After the fixed term ends, you need to give at least one months notice in writing.
                """
            ),
            GuideArticle(
                title: "Your tenant rights",
                subtitle: "What landlords can and cannot do",
                icon: "checkmark.shield.fill",
                iconColor: Color(hex: "E1F5EE"),
                content: """
                As a tenant in the UK you have important legal rights that protect you.

                Right to a safe home
                Your landlord must keep the property in a good state of repair. This includes the structure, heating, hot water and gas and electrical systems.

                Right to quiet enjoyment
                Your landlord cannot enter the property without giving you at least 24 hours written notice, except in an emergency.

                Protection from eviction
                Your landlord cannot evict you without following the correct legal process. They must give you proper written notice and in most cases get a court order.

                Right to information
                Before you move in your landlord must provide you with a copy of the Energy Performance Certificate, Gas Safety Certificate and the governments How to Rent guide.

                Protection from unfair charges
                Since the Tenant Fees Act 2019, landlords and agents can only charge you rent, a deposit, and certain permitted payments. They cannot charge admin fees, referencing fees or inventory fees.

                Deposit protection
                Your deposit must be protected in one of three government approved schemes: Deposit Protection Service, MyDeposits or Tenancy Deposit Scheme.

                What to do if your rights are violated
                Contact your local council housing department or Citizens Advice for free help and advice.
                """
            ),
            GuideArticle(
                title: "Guarantors explained",
                subtitle: "Who needs one and why",
                icon: "person.badge.shield.checkmark.fill",
                iconColor: Color(hex: "FAEEDA"),
                content: """
                A guarantor is someone who agrees to pay your rent if you cannot. Many landlords require a guarantor from students or people with no rental history.

                Who needs a guarantor?
                You may be asked for a guarantor if you are a student, have a low income, are renting for the first time, have a poor credit history or are not a UK citizen.

                Who can be a guarantor?
                A guarantor is usually a parent or close relative. They must be a UK homeowner, have a good credit history and earn enough to cover the rent if needed.

                What does a guarantor agree to?
                By signing the guarantor agreement, they agree to pay your rent and any damages if you cannot or do not pay. This is a serious legal commitment.

                Guarantor services
                If you do not have a suitable guarantor, there are professional guarantor services like Housing Hand or UK Guarantor that will act as your guarantor for a fee.

                International students
                If you are an international student, some landlords may ask for several months rent in advance instead of a UK guarantor.

                Protecting your guarantor
                Make sure you pay your rent on time every month. Missing payments affects not just your credit rating but also your guarantors.
                """
            )
        ]),
        
        GuideCategory(title: "Living Together", articles: [
            GuideArticle(
                title: "Shared responsibilities",
                subtitle: "Bills, chores and house rules",
                icon: "person.2.fill",
                iconColor: Color(hex: "FAECE7"),
                content: """
                Living with roommates requires clear communication and shared understanding of responsibilities.

                Bills and utilities
                Decide early how bills will be split. The easiest way is to divide everything equally. Use apps like Splitwise to track who owes what. Make sure all names are on the bills to share legal responsibility.

                Council tax
                Full time students are exempt from council tax. If even one housemate is not a full time student, the whole household may have to pay. Check with your local council.

                Chores
                Create a simple cleaning rota for shared areas like the kitchen, bathroom and living room. Be clear about expectations from the start to avoid tension later.

                House rules
                Agree on rules about guests, noise levels, overnight visitors, shared food and cleaning standards. Writing these down in a house agreement can prevent disputes.

                Shared food
                Decide whether you will share food or keep everything separate. Many housemates find it easier to keep basics like milk, washing up liquid and toilet roll as shared costs.

                Resolving issues early
                Small issues become big problems if ignored. Have regular house meetings to check in with each other and address any concerns before they escalate.
                """
            ),
            GuideArticle(
                title: "Resolving conflicts",
                subtitle: "Tips for living harmoniously",
                icon: "bubble.left.and.bubble.right.fill",
                iconColor: Color(hex: "E6F1FB"),
                content: """
                Conflict between roommates is common but manageable with the right approach.

                Talk early and calmly
                Address issues as soon as they arise rather than letting resentment build. Choose a calm moment to talk, not when you are already angry or upset.

                Use I statements
                Instead of saying you always leave the kitchen messy, try I feel stressed when the kitchen is left dirty. This is less confrontational and more likely to lead to a positive outcome.

                Listen actively
                Give your roommate a chance to explain their perspective. They may not be aware that their behaviour is affecting you.

                Find a compromise
                Most conflicts can be resolved with a small compromise. Be willing to give a little to get a little.

                Involve a mediator
                If you cannot resolve the issue yourselves, ask a neutral third party like a friend, your student union or a university housing advisor to help mediate.

                When things cannot be resolved
                If the situation becomes unbearable, contact your landlord or letting agent. In serious cases involving harassment or safety, contact your local council or the police.

                Prevention is better than cure
                The best way to avoid conflict is to use an app like TeamUp to find a roommate whose lifestyle and habits are compatible with yours from the start.
                """
            )
        ]),
        
        GuideCategory(title: "Financial Safety", articles: [
            GuideArticle(
                title: "Protecting your deposit",
                subtitle: "Deposit protection schemes",
                icon: "lock.shield.fill",
                iconColor: Color(hex: "EAF3DE"),
                content: """
                Your deposit is a significant amount of money. Here is how to make sure you get it back.

                Deposit protection schemes
                By law, your landlord must protect your deposit in one of three government approved schemes within 30 days:
                - Deposit Protection Service (DPS)
                - MyDeposits
                - Tenancy Deposit Scheme (TDS)

                Your landlord must give you the details of which scheme is being used.

                How to check your deposit is protected
                You can check on any of the three scheme websites by entering your details. If your deposit is not protected, you can take your landlord to court and claim up to three times the deposit amount.

                The inventory
                A detailed inventory at the start of the tenancy is your best protection. Take photos and videos of every room and note any existing damage. Keep a copy of the signed inventory.

                During the tenancy
                Report any repairs needed in writing and keep copies. Look after the property and keep it clean. Do not make changes like painting walls without permission.

                Moving out
                Clean the property thoroughly. Fix any damage you caused. Be present for the check-out inspection. Take photos of the clean property before you leave.

                If there is a dispute
                If your landlord tries to make unfair deductions, you can raise a dispute through the deposit protection scheme. The scheme provides free dispute resolution.

                Unfair deductions
                Landlords can only deduct for damage beyond fair wear and tear. Normal wear and tear like small marks on walls or worn carpets after a long tenancy cannot be charged to you.
                """
            ),
            GuideArticle(
                title: "Financial tips for renters",
                subtitle: "Budgeting and avoiding scams",
                icon: "sterlingsign.circle.fill",
                iconColor: Color(hex: "FCEBEB"),
                content: """
                Managing your finances well as a renter will reduce stress and protect you from exploitation.

                Budgeting for renting
                As a rule of thumb, your rent should not exceed 30 percent of your monthly income. Factor in bills, council tax, food and transport when working out what you can afford.

                Rental scams
                Be cautious of listings that seem too good to be true. Common scams include landlords asking for deposits before you have viewed the property, unusually low rents and landlords who claim to be abroad and cannot meet in person.

                Always view in person
                Never pay any money before viewing the property in person and verifying the landlord actually owns or manages it. Check the Land Registry if in doubt.

                Keep records
                Keep copies of all correspondence with your landlord, receipts for all payments and copies of all documents you sign.

                Universal Credit
                If you are on a low income you may be entitled to help with housing costs through Universal Credit. The housing element can help cover some or all of your rent.

                Student bursaries
                Many universities offer hardship funds and bursaries for students struggling with housing costs. Check with your student services department.

                Citizens Advice
                Citizens Advice offers free, confidential advice on housing, debt and benefits. Their website and local offices are a valuable resource.
                """
            )
        ])
    ]
    
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
            .navigationTitle("")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Text("Guide")
                        .font(.system(size: 26, weight: .bold))
                        .foregroundColor(Color(red: 0.498, green: 0.467, blue: 0.867))
                        .fixedSize()
                }
            }
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
