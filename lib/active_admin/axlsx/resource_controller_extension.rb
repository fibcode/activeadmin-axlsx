module ActiveAdmin
  module Axlsx
    module ResourceControllerExtension
      def self.included(base)
        base.send :alias_method_chain, :per_page, :xlsx
        base.send :alias_method_chain, :index, :xlsx
        base.send :alias_method_chain, :rescue_active_admin_access_denied, :xlsx
        base.send :respond_to, :xlsx
      end

      def index_with_xlsx
        index_without_xlsx do |format|
          format.xlsx do
            xlsx_collection = if method(:find_collection).arity.zero?
                                collection
                              else
                                find_collection except: :pagination
                              end

            xlsx = active_admin_config.xlsx_builder.serialize(
              xlsx_collection,
              view_context
            )
            send_data(xlsx,
                      filename: xlsx_filename,
                      type: Mime::Type.lookup_by_extension(:xlsx))
          end

          yield(format) if block_given?
        end
      end

      def rescue_active_admin_access_denied_with_xlsx(exception)
        if request.format == Mime::Type.lookup_by_extension(:xlsx)
          respond_to do |format|
            format.xls do
              flash[:error] = "#{exception.message} Review download_links in initializers/active_admin.rb"
              redirect_backwards_or_to_root
            end
          end
        else
          rescue_active_admin_access_denied_without_xlsx(exception)
        end
      end

      # patching per_page to use the CSV record max for pagination
      # when the format is xlsx
      def per_page_with_xlsx
        if request.format == Mime::Type.lookup_by_extension(:xlsx)
          return max_per_page if respond_to?(:max_per_page, true)
          active_admin_config.max_per_page
        end

        per_page_without_xlsx
      end

      # Returns a filename for the xlsx file using the collection_name
      # and current date such as 'my-articles-2011-06-24.xlsx'.
      def xlsx_filename
        timestamp = Time.now.strftime('%Y-%m-%d')
        "#{resource_collection_name.to_s.tr('_', '-')}-#{timestamp}.xlsx"
      end
    end
  end
end
