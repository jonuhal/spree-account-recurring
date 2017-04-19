module Spree
  class Recurring < Spree::Base
    class StripeRecurring < Spree::Recurring
      module ApiHandler
        module PlanApiHandler
          def create_plan(plan)
            raise_invalid_object_error(plan, Spree::Plan)
            begin
              if retrieve_api_plan(plan).nil?
                Stripe::Plan.create(
                    amount: stripe_amount(plan.amount),
                    interval: plan.interval,
                    interval_count: plan.interval_count,
                    name: plan.name,
                    currency: plan.currency,
                    id: plan.api_plan_id,
                    trial_period_days: plan.trial_period_days
                )
              end
            rescue Stripe::InvalidRequestError => e
              # if retrieve_api_plan(plan) cannot find a plan, don't throw the error.
              # otherwise, rethrow the error.
              raise e unless e.http_status == 404
            end
          end

          def delete_plan(plan)
            raise_invalid_object_error(plan, Spree::Plan)
            stripe_plan = retrieve_api_plan(plan)
            stripe_plan.delete
          end

          def update_plan(plan)
            raise_invalid_object_error(plan, Spree::Plan)
            stripe_plan = retrieve_api_plan(plan)
            stripe_plan.name = plan.name
            stripe_plan.save
          end

          def set_api_plan_id(plan)
            plan.api_plan_id = "KS-Plan-#{Time.current.to_i}" if plan.api_plan_id.blank?
          end

          private

          def retrieve_api_plan(plan)
            Stripe::Plan.retrieve(plan.api_plan_id)
          end

          def stripe_amount(amount)
            (amount * 100).to_i
          end
        end
      end
    end
  end
end