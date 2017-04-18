module Spree
  class Recurring < Spree::Base
    module ApiHandler
      extend ActiveSupport::Concern

      def get_plans
        provider.get_plans(self)
      end

      def provider
        recurring.present? ? recurring : (raise ActiveRecord::RecordNotFound.new("Provider not found."))
      end
    end
  end
end