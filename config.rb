###
# Page options, layouts, aliases and proxies
###

require 'lib/mappers/product_mapper'
require 'lib/mappers/problem_mapper'
require 'lib/mappers/main_category_mapper'
require 'lib/mappers/product_category_mapper'

activate :directory_indexes
activate :autoprefixer

set :relative_links, true

ignore 'javascripts/**/*.js'

# set :fonts_dir,  "fonts"

# Per-page layout changes:
#
# With no layout
page '/*.xml', layout: false
page '/*.json', layout: false
page '/*.txt', layout: false

# With alternative layout
# page "/path/to/file.html", layout: :otherlayout

# Proxy pages (http://middlemanapp.com/basics/dynamic-pages/)
# proxy "/this-page-has-no-template.html", "/template-file.html", locals: {
#  which_fake_page: "Rendering a fake page with a local variable" }

# General configuration

# Reload the browser automatically whenever files change
configure :development do
  activate :livereload
end

###
# Helpers
###

# Methods defined in the helpers block are available in templates
helpers do
  def page_title(title)
    out = ""
    out += title || current_page.data.title
    out += " &middot; " if out
    out += "Nadler Straßentechnik GmbH"
    out
  end
end

activate :contentful do |f|
  f.space         = { nadler: 'ij3nq99pxj5e' }
  f.access_token  =  'bc11370752da496c3f1384f6f5f930f04404d13559cac0d99f3b2079451df86c'
  # f.access_token  = '5348bd0d91059674bd9ad7dfe82eabbfbd13af1e7a4b59dd3d8e079929d56f0b'
  # f.use_preview_api = true
  # f.cda_query     = { content_type: ['main_categories', 'problems'], include: 1000 }
  f.all_entries = true
  f.content_types = {
    # category: { mapper: SubcategoryMapper, id: 'category' },
    # main_categories: { mapper: CategoryMapper, id: 'main_categories' },
    # product: { mapper: ProductMapper, id: 'products' },
    # main_categories: 'main_categories',
    main_categories: { mapper: MainCategoryMapper, id: 'main_categories' },
    problems: { mapper: ProblemMapper, id: 'problems' },
    product_categories: { mapper: ProductCategoryMapper, id: 'product_categories' },
    products: { mapper: ProductMapper, id: 'products' },
    product_properties: 'product_properties'
  }
end

# p data.nadler.inspect

# data.nadl.products.map { |p| p.last }.each do |product|
#   proxy "/products/#{product.name.parameterize}.html", "/products/template.html", locals: {
#     :product => product, 'title' => product.name
#   }
# end

data.nadler.products.map { |p| p.last }.each do |product|
  proxy "/products/#{product.slug}.html", "/products/template.html", locals: {
    :product => product, 'title' => product.name
  }
end

data.nadler.main_categories.map { |p| p.last }.each do |category|
  proxy "/categories/#{category.slug}/index.html", "/categories/template.html", locals: {
    :category => category, 'title' => category.name
  }

  next unless category.product_categories
  category.product_categories.each do |sub|
    p sub.slug
    proxy "/categories/#{category.slug}/#{sub.slug}/index.html",
          "/categories/sub.html",
          locals: {
            :category => sub, 'title' => sub.name
          }
  end
end

# Build-specific configuration
configure :build do
  # Minify CSS on build
  activate :minify_css

  # Minify Javascript on build
  activate :minify_javascript
  activate :relative_assets
end

activate :deploy do |deploy|
  deploy.build_before = true
  deploy.deploy_method = :git
end

activate :external_pipeline,
  name: :webpack,
  command: build? ? "npm run build" : "npm start",
  source: ".tmp/dist",
  latency: 1
