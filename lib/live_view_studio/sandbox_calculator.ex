defmodule LiveViewStudio.SandboxCalculator do
  def calculate_weight(length, width, depth) do
    [l, w, d] = Enum.map([length, width, depth], &to_integer/1)
    Float.round(l * w * d * 7.3, 2)
  end

  def calculate_price(weight), do: weight * 1.5

  defp to_integer(param) do
    case Integer.parse(param) do
      {value, ""} -> value
      :error -> 0
    end
  end
end
