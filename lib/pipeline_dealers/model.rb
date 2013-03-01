require "json"
require "active_support/hash_with_indifferent_access"

module PipelineDealers
  class Model
    class << self
      attr_accessor :collection_url
      attr_accessor :attribute_name
      attr_reader :attributes

      def attrs *attrs
        if attrs.last.kind_of?(Hash)
          options = attrs.pop
        else
          options = {}
        end

        attrs.each do |attr|
          attr attr, options
        end
      end

      def attr name, options = {}
        @attributes ||= {}
        @attributes[name] = options

        # Getter
        define_method name do
          @attributes[name.to_s]
        end

        # Setter, only if not read only
        if options[:read_only] != true
          define_method "#{name}=".to_sym do |value|
            @attributes[name.to_s] = value
          end
        end
      end

      def inherited(klass)
        (@attributes || []).each do |name, options|
          klass.attr(name, options)
        end
      end
    end

    attr_accessor :attributes
    attr_reader :id

    def initialize(options = {})
      @options    = options
      @persisted  = options.delete(:persisted) == true
      @client     = options.delete(:client)
      @collection = options.delete(:collection)

      import_attributes! options.delete(:attributes)
    end

    def ==(other)
      if other.kind_of?(self.class)
        other.id == self.id && other.attributes == self.attributes
      else
        super(other)
      end
    end

    def persisted?
      @persisted == true
    end

    def new_record?
      @persisted == false
    end

    def save
      @collection.save(self)
      self
    end

    def destroy
      @collection.destroy(self)
      self
    end

    IGNORE_ATTRIBUTES_WHEN_SAVING = [:updated_at, :created_at]
    def save_attrs
      # Ignore some attributes
      save_attrs = @attributes.reject { |k, v| IGNORE_ATTRIBUTES_WHEN_SAVING.member?(k) }

      # And allow a model class to modify / edit attributes even further
      if respond_to?(:attributes_for_saving)
        save_attrs = attributes_for_saving(save_attrs)
      else
        save_attrs
      end
    end

    def to_s
      "<#{self.class}:#{self.object_id} @attibutes=#{@attributes.inspect}>"
    end

    protected

    def import_attributes! attributes
      @attributes    = stringify_keys(attributes || {})
      @id            = @attributes.delete(:id)

      # Give subclasses the opportunity to hook in here.
      process_attributes if respond_to?(:process_attributes)

      check_for_non_existent_attributes!
    end

    def check_for_non_existent_attributes!
      attribute_keys = @attributes.keys.collect(&:to_sym)

      invalid_attributes = attribute_keys - valid_attribute_names

      if invalid_attributes.any?
        raise Error::InvalidAttributeName.new(self.class, invalid_attributes.first)
      end
    end

    # Recursively converts a hash structure with symbol keys to a hash
    # with indifferent keys
    def stringify_keys original
      result = HashWithIndifferentAccess.new

      original.each do |key, value|
        result[key] = stringify_value(value)
      end

      result
    end

    def valid_attribute_names
      attrs = self.class.instance_variable_get(:@attributes)
      if attrs.nil?
        []
      else
        attrs.keys
      end
    end

    def stringify_value value
      case value
      when String, Fixnum, NilClass, FalseClass, TrueClass
        return value
      when Hash, HashWithIndifferentAccess
        return stringify_keys(value)
      when Array
        return value.collect { |item| stringify_value(item) }
      else
        raise "Unkown type: #{value.class}"
      end
    end
  end
end
