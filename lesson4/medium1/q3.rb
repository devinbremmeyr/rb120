class InvoiceEntry
  attr_reader :quantity, :product_name

  def initialize(product_name, number_purchased)
    @quantity = number_purchased
    @product_name = product_name
  end

  def update_quantity(updated_count)
    quantity = updated_count if updated_count >= 0
  end
end

# One way to fix InvoiceEntry#update_quantity is to change attr_reader to 
# attr_accessor and change quantity to self.quantity.
# Is there anything wrong with fixing it this way?

# It's good to be aware of weather having a setter method for either @quantity 
# or @produc_name available outside the class is desired.

# In the case of @quantity this could allow the instance variable to be set to 
# a negative number despite having the #update_quantity method in place to
# prevent that.
