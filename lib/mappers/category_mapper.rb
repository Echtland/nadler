class CategoryMapper < ContentfulMiddleman::Mapper::Base
  def map(context, entry)
    super
    context.slug = entry.name.parameterize

    if entry.categories
      context.categories.each do |c|
        c.set(:slug, c.name.parameterize)
        c
      end
    end

  end
end
