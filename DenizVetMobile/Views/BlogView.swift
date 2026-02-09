import SwiftUI

struct BlogView: View {
    @StateObject private var blogVM = BlogViewModel()

    var body: some View {
        ZStack {
            Color(red: 0.97, green: 0.95, blue: 0.89)
                .ignoresSafeArea()

            if blogVM.isLoading {
                ProgressView("Bloglar yükleniyor...")
            } else if let error = blogVM.errorMessage {
                VStack(spacing: 12) {
                    Text(error)
                        .foregroundColor(.red)
                    Button("Tekrar dene") {
                        Task { await blogVM.loadBlogs() }
                    }
                }
            } else {
                ScrollView {
                    VStack(alignment: .leading, spacing: 16) {

                        VStack(alignment: .leading, spacing: 4) {
                            Text("Bloglar")
                                .font(.system(size: 30, weight: .bold))

                            Text("Sağlık ve bakım ipuçları")
                                .font(.subheadline)
                                .foregroundColor(.secondary)

                            Divider()
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 12)

                        LazyVStack(spacing: 20) {
                            ForEach(blogVM.blogs) { blog in
                                NavigationLink {
                                    BlogDetailView(blog: blog)
                                } label: {
                                    BlogCardView(blog: blog)
                                        .padding(.horizontal, 16)
                                }
                                .buttonStyle(.plain)
                            }
                        }
                        .padding(.bottom, 24)
                    }
                }
                .refreshable {
                    await blogVM.refresh()
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .task {
            await blogVM.loadBlogs()
        }
    }
}



#Preview {
    BlogView()
}
