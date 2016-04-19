class ProductMapper < ContentfulMiddleman::Mapper::Base
  def map(context, entry)
    super
    context.slug = entry.name.parameterize

    context.krass = context.images.map do |i|
      i.set(:slug, i.title.parameterize)
      i
    end
  end
end
