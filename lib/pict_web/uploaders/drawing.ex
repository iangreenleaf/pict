defmodule Pict.Drawing do
  use Waffle.Definition
  use Waffle.Ecto.Definition

  @versions [:original, :large, :thumb]
  @sizes [thumb: 250, large: 2000]

  def transform(:original, _) do
    {:convert, "-strip"}
  end

  def transform(type, _) do
    size = @sizes[type]
    {:convert, "-strip -resize #{size}x#{size} -quality 90 -define webp:auto-filter=true -define webp:use-sharp-yuv=1 -format webp", :webp}
  end

  def filename(version, {file, submission}) do
    "#{submission.id}_#{version}"
  end
end
