defmodule PictWeb.HouseComponents do
  @moduledoc """
  Provides "house" components for common patterns.

  Going with the theory that it will be easier to apply changes to CoreComponents
  if I leave that file mostly unmodified for the moment.
  """
  use Phoenix.Component

  @doc """
  A card component that we use as a page building block.
  """

  # Gotta be this way so the tailwind compiler catches the full class names
  attr :color, :string, default: "bg-teal-600 border-teal-600"

  slot :inner_block, required: true
  slot :title, required: true

  def card(assigns) do
    ~H"""
    <div class="drop-shadow-md">
      <div class={[
        "block border rounded-md border-b-0 rounded-b-none",
        "border-#{@color} #{@color}",
        "text-white p-1 text-lg font-medium text-center"
      ]}>
        <%= render_slot(@title) %>
      </div>
      <div class="p-4 border rounded-md border-t-0 rounded-t-none border-neutral-400 bg-white text-lg font-medium text-center">
        <%= render_slot(@inner_block) %>
      </div>
    </div>
    """
  end

  @doc """
  Lil' link-based button that can work with liveview
  """

  attr :type, :string, default: nil
  attr :class, :string, default: nil
  attr :rest, :global, include: ~w(disabled form name value)

  def small_button(assigns) do
    ~H"""
    <.link
      type={@type}
      class={[
        "phx-submit-loading:opacity-75 inline-flex items-center space-x-1 px-3",
        "border rounded-full border-teal-600 text-sm font-normal text-teal-600",
        "hover:bg-teal-600 hover:text-white",
        "focus:ring focus:ring-teal-600 focus:ring-offset-2",
        @class
      ]}
      {@rest}
    >
      <%= render_slot(@inner_block) %>
    </.link>
    """
  end
end
