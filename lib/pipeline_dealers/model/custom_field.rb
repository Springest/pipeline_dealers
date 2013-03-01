module PipelineDealers
  class Model
    class CustomField < Model
      attr_reader :dropdown_entries

      attrs :name, 
            :field_type, 
            :is_required, 
            :custom_field_label_dropdown_entries,
        readonly: true

      def process_attributes
        @dropdown_entries = @attributes.delete(:custom_field_label_dropdown_entries)
      end

      def decode(model, value)
        coder_for(model).decode(value)
      end

      def encode(model, value)
        coder_for(model).encode(value)
      end

      protected

      def coder_for(model)
        coder_klass = Coder::Types[field_type.to_sym]
        if coder_klass.nil?
          raise "Unkown custom field type '#{field_type.inspect}'"
        else
          return coder_klass.new(model, self)
        end
      end

      class Coder
        def initialize(model, field)
          @model, @field = model, field
        end

        class Identity < Coder
          def encode(value) value end
          def decode(value) value end
        end

        class Dropdown < Coder
          def encode value
            find :value, of: value, and_return: :id
          end

          def decode id
            find :id, of: id, and_return: :value
          end

          protected

          def find key, options
            key        = key.to_s
            value      = options[:of]
            and_return = options[:and_return].to_s

            entry = @field.dropdown_entries.find { |entry| entry[key] == value }
            
            if entry
              return entry[and_return]
            else
              raise Error::InvalidAttributeValue.new(@model, @field.name, value)
            end
          end
        end

        class MultiSelect < Coder
          def encode values
            coder = Dropdown.new(@model, @field)
            values.collect { |value| coder.encode(value) }
          end

          def decode ids
            coder = Dropdown.new(@model, @field)
            ids.collect { |value| coder.decode(value) }
          end
        end

        Types = {
          numeric: Identity,
          text: Identity,
          currency: Identity,
          dropdown: Dropdown,
          multi_select: MultiSelect,
          multi_association: Identity # Does not work yet
        } 
      end
    end
  end
end
