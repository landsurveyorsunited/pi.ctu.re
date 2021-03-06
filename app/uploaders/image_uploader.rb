class ImageUploader < ApplicationUploader
  def path
    "/#{model.class.table_name}/#{model.token}"
  end

  # Example with a 600x400 picture: thumb_size('x200') -> '300x200'
  def thumb_size(geometry)
    w, _, h = geometry.partition("x")

    return unless h.present? || w.present?

    if h.present?
      h = h.to_i
      w = model.image_width * h / model.image_height
    else
      w = w.to_i
      h = model.image_height * w / model.image_width
    end

    [w, h].join("x")
  end

  process :store_dimensions

  private

  def store_dimensions
    return unless file && model

    model.image_width, model.image_height = FastImage.size(file.file)
  end
end
