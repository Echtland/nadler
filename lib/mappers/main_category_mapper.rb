class MainCategoryMapper < ContentfulMiddleman::Mapper::Base
  def map(context, entry)
    super
    context.slug = entry.name.parameterize

    if entry.product_categories
      context.product_categories.each do |c|
        c.set(:slug, c.name.parameterize)
        c
      end
    end

  end
end
