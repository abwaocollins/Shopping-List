defmodule ShoppingList do
  use GenServer

  # client side
  def start_link(cart) do
    GenServer.start_link(__MODULE__, cart, name: __MODULE__)
  end

  def add_product(product) do
    GenServer.cast(__MODULE__, {:add_product, product})
  end

  def remove_product(product) do
    GenServer.call(__MODULE__, {:remove_product, product})
  end

  def view_cart() do
    GenServer.call(__MODULE__, :view_cart)
  end

  # server side
  def init(cart) do
    # Initialize the cart by adding the necessary keys and values
    cart = Map.put(cart, :products, []) |> Map.put(:total_price, 0) |> IO.inspect()

    {:ok, cart}
  end

  def handle_cast({:add_product, product}, %{products: products, total_price: total_price} = cart) do
    IO.inspect(cart)

    # Add the new product to the list of products
    products = [product | products]

    # Update the total price by adding the price of the new product multiplied by its quantity
    total_price = total_price + product.price * product.quantity

    # Update the cart with the new products and total price
    cart = %{cart | products: products, total_price: total_price}

    {:noreply, cart}
  end

  def handle_call(:view_cart, _from, cart) do
    # Reply with the current cart
    {:reply, cart, cart}
  end

  def handle_call(
        {:remove_product, product},
        _from,
        %{products: products} = cart
      ) do
    # Find the product to be removed from the cart
    delete_product = Enum.find(products, fn prod -> prod.name == product.name end)

    if delete_product.quantity > 1 do
      # If the product quantity is greater than 1, decrease the quantity by 1
      update_quantity = %{delete_product | quantity: delete_product.quantity - 1}

      # Remove the product from the cart and update the total price
      with_rem_products = Enum.reject(products, fn prod -> prod.name == product.name end)
      new_products = [update_quantity | with_rem_products]
      total_price = Enum.map(new_products, fn product -> product.price end) |> Enum.sum()

      # Update the cart with the new products and total price
      new_cart = %{cart | products: new_products, total_price: total_price}
      {:reply, cart, new_cart}
    else
      # If the product quantity is 1, remove the product from the cart and update the total price
      new_products = Enum.reject(products, fn prod -> prod.name == product.name end)
      total_price = Enum.map(new_products, fn product -> product.price end) |> Enum.sum()
      new_cart = %{cart | products: new_products, total_price: total_price}
      {:reply, cart, new_cart}
    end
  end
end
