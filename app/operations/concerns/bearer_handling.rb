# frozen_string_literal: true

module BearerHandling
  extend ActiveSupport::Concern

  private

  def define_bearer
    return unless @bearer_attributes

    @bearer = find_bearer || create_bearer
  end

  def find_bearer
    Bearer.find_by(name: @bearer_attributes.name)
  end

  def create_bearer
    Bearer.create!(@bearer_attributes.to_h)
  rescue ActiveRecord::RecordInvalid => e
    interrupt_with_errors!(invalid_record_message('Stock', e))
  end
end
