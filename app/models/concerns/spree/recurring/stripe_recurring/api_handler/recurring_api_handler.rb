module Spree
  class Recurring < Spree::Base
    class StripeRecurring < Spree::Recurring
      module ApiHandler
        module RecurringApiHandler
          def get_plans
            Stripe::Plan.all.each do |plan|
              if Spree::Plan.find_by(api_plan_id: plan.id).nil?
                Spree::Plan.create(
                    api_plan_id: plan.id,
                    amount: spree_amount(plan.amount),
                    interval: plan.interval,
                    interval_count: plan.interval_count,
                    name: plan.name,
                    currency: plan.currency,
                    recurring_id: self.id,
                    trial_period_days: plan.trial_period_days,
                    active: plan.livemode
                )
              end
            end
          end

          private

          def spree_amount(amount)
            (amount / 100).to_i
          end
        end
      end
    end
  end
end