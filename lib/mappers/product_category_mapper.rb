class ProductCategoryMapper < ContentfulMiddleman::Mapper::Base
  def map(context, entry)
    super
    context.slug = entry.name.parameterize
  end
end
