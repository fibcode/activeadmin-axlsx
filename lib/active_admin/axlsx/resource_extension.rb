module ActiveAdmin
  # Provides xlsx functionality to ActiveAdmin resources
  module Axlsx
    # Extends ActiveAdmin Resource
    module ResourceExtension
      # Sets the XLSX Builder
      #
      # @param builder [Builder] the new builder object
      # @return [Builder] the builder for this resource
      def xlsx_builder=(builder)
        @xlsx_builder = builder
      end

      # Returns the XLSX Builder. Creates a new Builder if none exists.
      #
      # @return [Builder] the builder for this resource
      #
      # @example Localize column headers
      #   # app/admin/posts.rb
      #   ActiveAdmin.register Post do
      #     config.xls_builder.i18n_scope = [:active_record, :models, :posts]
      #   end
      def xlsx_builder
        @xlsx_builder ||= ActiveAdmin::Axlsx::Builder.new(resource_class)
      end
    end
  end
end
