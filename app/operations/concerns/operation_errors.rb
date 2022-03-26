# frozen_string_literal: true

module OperationErrors
  extend ActiveSupport::Concern

  private

  def invalid_record_message(entity, e)
    [I18n.t(
      :record_invalid,
      scope: 'errors',
      entity: entity,
      messages: e.message
    )]
  end
end
