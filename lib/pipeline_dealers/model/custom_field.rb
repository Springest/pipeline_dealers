module PipelineDealers
  class Model
    class CustomField < Model
      attrs :name, 
            :field_type, 
            :is_required,
            :created_at,
            :updated_at,
        readonly: true

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
          return coder_klass.new(@client, model, self)
        end
      end

      class Coder
        def initialize(client, model, field)
          @client, @model, @field = client, model, field
        end

        class Identity < Coder
          def encode(value) value end
          def decode(value) value end
        end

        class Dropdown < Coder
          def encode value
            @client.custom_field_label_dropdown_entries.all.to_a.select { |opt| opt.custom_field_label_id == @field.id }.detect { |opt| opt.name == value }.id
          end

          def decode id
            @client.custom_field_label_dropdown_entries.all.to_a.detect { |opt| opt.id == id }.name
          end
        end

        class MultiSelect < Coder
          def encode values
            coder = Dropdown.new(@client, @model, @field)
            values.collect { |value| coder.encode(value) }
          end

          def decode ids
            coder = Dropdown.new(@client, @model, @field)
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
