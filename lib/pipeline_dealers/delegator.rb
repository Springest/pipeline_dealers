# Copied from activesupport/lib/active_support/core_ext/module/delegation.rb

module PipelineDealers
  module Delegator
    def delegate(*methods)
      options = methods.pop
      unless options.is_a?(Hash) && to = options[:to]
        raise ArgumentError, 'Delegation needs a target. Supply an options hash with a :to key as the last argument (e.g. delegate :hello, to: :greeter).'
      end

      prefix, allow_nil = options.values_at(:prefix, :allow_nil)

      if prefix == true && to =~ /^[^a-z_]/
        raise ArgumentError, 'Can only automatically set the delegation prefix when delegating to a method.'
      end

      method_prefix = \
        if prefix
          "#{prefix == true ? to : prefix}_"
        else
          ''
        end

      file, line = caller.first.split(':', 2)
      line = line.to_i

      to = to.to_s
      to = 'self.class' if to == 'class'

      methods.each do |method|
        # Attribute writer methods only accept one argument. Makes sure []=
        # methods still accept two arguments.
        definition = (method =~ /[^\]]=$/) ? 'arg' : '*args, &block'

        if allow_nil
          module_eval(<<-EOS, file, line - 2)
            def #{method_prefix}#{method}(#{definition})        # def customer_name(*args, &block)
              if #{to} || #{to}.respond_to?(:#{method})         #   if client || client.respond_to?(:name)
                #{to}.#{method}(#{definition})                  #     client.name(*args, &block)
              end                                               #   end
            end                                                 # end
          EOS
        else
          exception = %(raise "#{self}##{method_prefix}#{method} delegated to #{to}.#{method}, but #{to} is nil: \#{self.inspect}")

          module_eval(<<-EOS, file, line - 1)
            def #{method_prefix}#{method}(#{definition})        # def customer_name(*args, &block)
              #{to}.#{method}(#{definition})                    #   client.name(*args, &block)
            rescue NoMethodError                                # rescue NoMethodError
              if #{to}.nil?                                     #   if client.nil?
                #{exception}                                    #     # add helpful message to the exception
              else                                              #   else
                raise                                           #     raise
              end                                               #   end
            end                                                 # end
          EOS
        end
      end
    end
  end
end
