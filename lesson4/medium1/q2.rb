class InvoiceEntry
  attr_reader :quantity, :product_name

  def initialize(product_name, number_purchased)
    @quantity = number_purchased
    @product_name = product_name
  end

  def update_quantity(updated_count)
    # prevent negative quantities from being set
    quantity = updated_count if updated_count >= 0
  end
end

# This will fail when #update_quantity is called
# Can you spot the mistake and how to fix it?

# The expression `quantity = ` will initialize a local variable which is not
# the intended behavior. Either a setter method for @quantity should be defined,
# then it could be called in InvoiceEntry#update_quantity as `self.quantity`.
# Otherwise simly adding a @ would properly set the value to the quantity 
# instance variable.

# A side note, the update_quantity method may be better making use of a warning
# or exception in the case of negative input.
