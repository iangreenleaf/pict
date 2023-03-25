defmodule PictWeb.EmailHTML do
  use PictWeb, :html
  import Pict.Prompts, only: [expects_drawing?: 1]
  embed_templates "../templates/email/*"
end
