//
//  BlogViewModel.swift
//  DenizVetMobile
//
//  Created by Deniz Özcan on 25.11.2025.
//

import Foundation

@MainActor
class BlogViewModel: ObservableObject {
    @Published var blogs: [BlogModels] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    func loadBlogs() async {
        isLoading = true
        errorMessage = nil
        
        do {
            let result = try await BlogService.shared.fetchBlogs()
            self.blogs = result
        } catch {
            print("Blog fetch error:", error)
            self.errorMessage = "Bloglar yüklenirken bir hata oluştu."
        }
        
        isLoading = false
    }
    
    func refresh() async {
        errorMessage = nil
        do {
            let result = try await BlogService.shared.fetchBlogs()
            self.blogs = result
        } catch {
            self.errorMessage = "Bloglar yüklenirken bir hata oluştu."
        }
    }

}
