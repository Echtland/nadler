###
# Page options, layouts, aliases and proxies
###

require 'lib/mappers/product_mapper'
require 'lib/mappers/category_mapper'
require 'lib/mappers/subcategory_mapper'

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
  f.space         = { nadler: 'n7kinjc9606g' }
  f.access_token  = '1b3e061742ab5777dd2fe39d360cd7c54a1e9c3fe1edadd8d16d3cabaa586cfd'
  # f.cda_query     = { content_type: 'category', include: 1 }
  f.content_types = {
    category: { mapper: SubcategoryMapper, id: 'category' },
    main_category: { mapper: CategoryMapper, id: 'main_category' },
    product: { mapper: ProductMapper, id: 'product' },
    product_properties: 'product_properties'
  }
end

# data.products.map { |p| p.last }.each do |product|
#   proxy "/products/#{product.name.parameterize}.html", "/products/template.html", locals: {
#     :product => product, 'title' => product.name
#   }
# end

data.nadler.product.map { |p| p.last }.each do |product|
  proxy "/products/#{product.slug}.html", "/products/template.html", locals: {
    :product => product, 'title' => product.name
  }
end

data.nadler.main_category.map { |p| p.last }.each do |category|
  proxy "/categories/#{category.slug}/index.html", "/categories/template.html", locals: {
    :category => category, 'title' => category.name
  }

  next unless category.categories
  category.categories.each do |sub|
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
