module ActiveAdmin
  module Axlsx
    # extends activeadmin dsl to include xlsx
    module DSL
      delegate(:after_filter,
               :before_filter,
               :column,
               :delete_columns,
               :header_style,
               :i18n_scope,
               :skip_header,
               :whitelist,
               to: :xlsx_builder,
               prefix: :config)

      def xlsx(options = {}, &block)
        config.xlsx_builder = ActiveAdmin::Axlsx::Builder.new(
          config.resource_class,
          options,
          &block
        )
      end
    end
  end
end
