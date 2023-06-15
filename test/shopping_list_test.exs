defmodule ShoppingListTest do
  use ExUnit.Case
  alias ShoppingList

  test "add_product/1 adds a product to the cart" do
    # Add a product to the cart
    product = %{name: "Apples", price: 1.00, quantity: 3}
    ShoppingList.add_product(product)

    # Check that the product was added to the cart
    cart_with_product = ShoppingList.view_cart()
    assert cart_with_product.products == [product]
    assert cart_with_product.total_price == 3.00
  end

  test "remove_product/1 decreases quantity of the product from the cart if greater than 1" do
    product = %{name: "Apples", price: 1.00, quantity: 3}
    ShoppingList.add_product(product)
    ShoppingList.remove_product(%{name: "Apples"})
    cart_with_product = ShoppingList.view_cart()
    assert cart_with_product.total_price == 2.00
  end

  test "remove_product/1 removes the product if quantity is 1" do
    product = %{name: "Apples", price: 1.00, quantity: 1}
    ShoppingList.add_product(product)
    ShoppingList.remove_product(%{name: "Apples"})
    cart_with_product = ShoppingList.view_cart()
    assert cart_with_product.total_price == 0
    assert cart_with_product.products == []
  end

  test "view_cart/0 shows the current state of the cart" do
    product = %{name: "Apples", price: 1.00, quantity: 1}
    ShoppingList.add_product(product)

    assert ShoppingList.view_cart() == %{
             products: [%{name: "Apples", price: 1.0, quantity: 1}],
             total_price: 1.0
           }
  end

  test "terminate/0 ends the Genserver process" do
    ShoppingList.terminate()
  end
end
