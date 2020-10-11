defmodule LiveViewStudio.Sales do
  @spec new_orders() :: Integer
  def new_orders do
    Enum.random(5..20)
  end

  @spec sales_amount() :: Integer
  def sales_amount do
    Enum.random(100..1000)
  end

  @spec satisfaction() :: Integer
  def satisfaction do
    Enum.random(95..100)
  end
end
