# frozen_string_literal: true

class BearerSerializer
  include FastJsonapi::ObjectSerializer
  attributes :name
end
