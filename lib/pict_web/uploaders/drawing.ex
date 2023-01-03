defmodule Pict.Drawing do
  use Waffle.Definition
  use Waffle.Ecto.Definition

  @versions [:original, :large, :thumb]
  @sizes [thumb: 250, large: 1200]

  def transform(:original, _) do
    {:convert, "-strip"}
  end

  def transform(type, _) do
    size = @sizes[type]
    {:convert, "-strip -resize #{size}x#{size}^> -gravity center -crop 1:1 +repage -quality 90 -define webp:auto-filter=true -format webp", :webp}
  end
end
