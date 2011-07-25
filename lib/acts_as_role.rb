module ActsAsRole

  module Role
    
    extend ActiveSupport::Concern

    included do
      attr_accessor :rolez
    end

    module ClassMethods
      def acts_as_role column, options={}

        options.symbolize_keys!

        define_method "setup_roles_for_#{column}" do
          self.setup_roles self.send(column), options, column
        end

        define_method "save_roles" do
          self.send("#{column}=",@rolez.join("_")) if @rolez
        end

        options[:values].each do |role|
          define_method "is_#{role}?" do
            @rolez && @rolez.include?(role.to_sym)
          end
        end

        define_method "add_#{column.to_s.pluralize}" do |*roles|          
          roles.each {|x| @rolez << x if not @rolez.include?(x) }
          save_roles
        end  

        define_method "remove_#{column.to_s.pluralize}" do |*roles|
          roles.each {|x| @rolez.delete(x) }
          save_roles
        end

        define_method "has_#{column.to_s.pluralize}?" do |*roles|
          @rolez && roles.flatten.map { |r| r.to_sym }.all? { |r| @rolez.include?(r) }
        end

        define_method "has_#{column.to_s.singularize}?" do |role|
          @rolez && @rolez.include?(role)
        end

        define_method "list_#{column.to_s.pluralize}" do 
          @rolez
        end

        define_method "available_#{column.to_s.pluralize}" do 
          "#{options[:values].to_a}"
        end

        after_initialize "setup_roles_for_#{column}".to_sym

        validates "#{column}".to_sym, :roles => { :roles => options[:values], :message => options[:message] }

      end
    end 

    def setup_roles role, options, column
      role = setup_default_role role, options, column  
      @rolez = role.nil? ? [] : role.split("_").collect(&:to_sym)      
      save_roles
    end

    private
    
    def setup_default_role role, options, column
      if (role.nil? || role.empty?)  && options[:default]
        options[:default] = [options[:default].to_s] if options[:default].is_a?(Symbol)
        role = options[:default]*"_"
      else
        role
      end        
    end    
      
  end
end

ActiveRecord::Base.send(:include, ActsAsRole::Role)
