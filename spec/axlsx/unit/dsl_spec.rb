require 'spec_helper'

module ActiveAdmin
  # tests for dsl
  module Axlsx
    describe ::ActiveAdmin::ResourceDSL do
      context 'in a registration block' do
        let(:builder) do
          config = ActiveAdmin.register(Post) do
            xlsx(i18n_scope: [:rspec], header_style: { sz: 20 }) do
              delete_columns :id, :created_at
              column(:author) { |post| post.author.first_name }
              before_filter { |sheet| sheet.add_row ['before_filter'] }
              after_filter { |sheet| sheet.add_row['after_filter'] }
              skip_header
            end
          end
          config.xlsx_builder
        end

        it 'uses our customized i18n scope' do
          expect(builder.i18n_scope).to eq([:rspec])
        end

        it 'removed the columns we told it to ignore' do
          %i[id create_at].each do |removed|
            column_index = builder.columns.index { |col| col.name == removed }
            expect(column_index).to be_nil
          end
        end

        it 'added the columns we declared' do
          added_index = builder.columns.index { |col| col.name == :author }
          expect(added_index).not_to be_nil
        end

        it 'has a before filter set' do
          expect(builder.instance_values['before_filter']).to be_a(Proc)
        end

        it 'has an after filter set' do
          expect(builder.instance_values['after_filter']).to be_a(Proc)
        end

        it 'indicates that the header should be excluded' do
          expect(builder.instance_values['skip_header']).to be_truthy
        end

        it 'updates the header style' do
          expect(builder.header_style[:sz]).to eq(20)
        end
      end
    end
  end
end
