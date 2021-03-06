require 'active_model/validations'

module ActiveModel
  module Validations
    extend ActiveSupport::Autoload
    
    autoload 'RolesValidator'
    
    class RolesValidator < ActiveModel::EachValidator 
      def initialize(options)
        @roles = options[:roles]
        super 
      end
      def validate_each(record, attribute, value) 
        unless value.split("_").all? {|x| @roles.include?(x) }
          record.errors[attribute] << (options[:message] || "contains an invalid role")
        end
      end
    end
  end
  module HelperMethods
  end
end