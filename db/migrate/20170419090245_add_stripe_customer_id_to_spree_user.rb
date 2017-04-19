class AddStripeCustomerIdToSpreeUser < ActiveRecord::Migration[5.0]
  def change
    add_column Spree.user_class.to_s.pluralize.downcase.to_sym, :stripe_customer_id, :string
  end
end
