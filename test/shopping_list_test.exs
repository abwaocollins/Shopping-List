defmodule ShoppingListTest do
  use ExUnit.Case
  alias ShoppingList

  setup do
    initial_cart = %{
      products: [],
      total_price: 0.0
    }

    {:ok, %{initial_cart: initial_cart}}
  end

  test "add_product/1 adds a product to the cart", %{initial_cart: cart} do
    product = %{name: "Apples", price: 1.00, quantity: 3}
    ShoppingList.add_product(product)

    cart_with_product = ShoppingList.view_cart()
    expected_cart = %{cart | products: [product], total_price: 3.00}

    assert cart_with_product == expected_cart
  end

  test "remove_product/1 decreases the quantity of the product from the cart if greater than 1",
       %{initial_cart: cart} do
    product = %{name: "Apples", price: 1.00, quantity: 3}
    ShoppingList.add_product(product)
    ShoppingList.remove_product(%{name: "Apples"})

    cart_with_product = ShoppingList.view_cart()

    expected_cart = %{
      cart
      | products: [%{name: "Apples", price: 1.00, quantity: 2}],
        total_price: 2.00
    }

    assert cart_with_product == expected_cart
  end

  test "remove_product/1 removes the product if the quantity is 1", %{initial_cart: cart} do
    product = %{name: "Apples", price: 1.00, quantity: 1}
    ShoppingList.add_product(product)
    ShoppingList.remove_product(%{name: "Apples"})

    cart_with_product = ShoppingList.view_cart()
    expected_cart = %{cart | products: [], total_price: 0}

    assert cart_with_product == expected_cart
  end

  test "view_cart/0 shows the current state of the cart", %{initial_cart: cart} do
    product = %{name: "Apples", price: 1.00, quantity: 1}
    ShoppingList.add_product(product)

    expected_cart = %{cart | products: [product], total_price: 1.00}

    assert ShoppingList.view_cart() == expected_cart
  end

  test "terminate/0 ends the GenServer process" do
    assert :ok = ShoppingList.terminate()
  end
end
