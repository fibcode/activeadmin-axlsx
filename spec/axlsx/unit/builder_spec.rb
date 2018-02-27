require 'spec_helper'

module ActiveAdmin
  # tests for builder
  module Axlsx
    describe Builder do
      let(:builder) { Builder.new(Post) }
      let(:content_columns) { Post.content_columns }

      context 'the default builder' do
        it 'has no header style' do
          expect(builder.header_style).to eq({})
        end
        it 'has no i18n scope' do
          expect(builder.i18n_scope).to be_nil
        end
        it 'has default columns' do
          expect(builder.columns.size).to eq(content_columns.size + 1)
        end
      end

      context 'customizing a builder' do
        it 'deletes columns we tell it we dont want' do
          builder.delete_columns :id, :body
          expect(builder.columns.size).to eq(content_columns.size - 1)
        end

        it 'lets us use specific columns in a list' do
          builder.only_columns :title, :author
          expect(builder.columns.size).to eq(2)
        end

        it 'lets us say we dont want the header' do
          builder.skip_header
          expect(builder.instance_values['skip_header']).to be_truthy
        end

        it 'lets us add custom columns' do
          builder.column(:hoge)
          expect(builder.columns.size).to eq(content_columns.size + 2)
        end

        it 'lets us clear all columns' do
          builder.clear_columns
          expect(builder.columns.size).to eq(0)
        end

        context 'Using Procs for delayed content generation' do
          let(:post) { Post.new(title: 'Hot Dawg') }

          before do
            builder.column(:hoge) do |resource|
              "#{resource.title} - with cheese"
            end
          end

          it 'stores the block when defining a column for later execution.' do
            expect(builder.columns.last.data).to be_a(Proc)
          end

          it 'evaluates custom column blocks' do
            expect(builder.columns.last.data.call(post)).to eq(
              'Hot Dawg - with cheese'
            )
          end
        end
      end

      context 'sheet generation without headers' do
        let!(:users) { [User.new(first_name: 'bob', last_name: 'nancy')] }

        let!(:posts) do
          [Post.new(title: 'bob', body: 'is a swell guy', author: users.first)]
        end

        let!(:builder) do
          options = {
            header_style: { sz: 10, fg_color: 'FF0000' },
            i18n_scope: %i[axlsx post]
          }
          Builder.new(Post, options) do
            skip_header
          end
        end

        before do
          # disable clean up so we can get the package.
          allow(builder).to receive(:clean_up) { false }
          builder.serialize(posts)
          @package = builder.send(:package)
          @collection = builder.collection
        end

        it 'does not serialize the header' do
          not_header = @package.workbook.worksheets.first.rows.first
          expect(not_header.cells.first.value).not_to eq('Title')
        end
      end

      context 'whitelisted sheet generation' do
        let!(:users) { [User.new(first_name: 'bob', last_name: 'nancy')] }

        let!(:posts) do
          [Post.new(title: 'bob', body: 'is a swell guy', author: users.first)]
        end

        let!(:builder) do
          post_options = {
            header_style: { sz: 10, fg_color: 'FF0000' },
            i18n_scope: %i[axlsx post]
          }
          Builder.new(Post, post_options) do
            skip_header
            whitelist
            column :title
          end
        end

        before do
          allow(User).to receive(:all) { users }
          allow(Post).to receive(:all) { posts }
          # disable clean up so we can get the package.
          allow(builder).to receive(:clean_up) { false }
          builder.serialize(Post.all)
          @package = builder.send(:package)
          @collection = builder.collection
        end

        it 'does not serialize the header' do
          sheet = @package.workbook.worksheets.first
          cells = sheet.rows.first.cells
          expect(cells.size).to eq(1)
          expect(cells.first.value).to eq(@collection.first.title)
        end
      end

      context 'Sheet generation with a highly customized configuration' do
        let!(:builder) do
          options = {
            header_style: { sz: 10, fg_color: 'FF0000' },
            i18n_scope: %i[axlsx post]
          }
          Builder.new(Post, options) do
            delete_columns :id, :created_at, :updated_at
            column(:author) do |resource|
              "#{resource.author.first_name} #{resource.author.last_name}"
            end
            after_filter do |sheet|
              sheet.add_row []
              sheet.add_row ['Author Name', 'Number of Posts']
              data = []
              labels = []
              users = collection.map(&:author).uniq(&:id)
              users.each do |user|
                data << user.posts.size
                labels << "#{user.first_name} #{user.last_name}"
                sheet.add_row [labels.last, data.last]
              end
              chart_color = %w[88F700 279CAC B2A200 FD66A3 F20062 C8BA2B 67E6F8 DFFDB9 FFE800 B6F0F8]
              title_opt = { title: 'post by author' }
              sheet.add_chart(::Axlsx::Pie3DChart, title_opt) do |chart|
                chart.add_series data: data, labels: labels, colors: chart_color
                chart.start_at 4, 0
                chart.end_at 7, 20
              end
            end

            before_filter do |sheet|
              users = collection.map(&:author)
              users.each do |user|
                user.first_name = 'Set In Proc' if user.first_name == 'bob'
              end
              sheet.add_row ['Created', Time.zone.now]
              sheet.add_row []
            end
          end
        end

        before do
          Post.all.each(&:destroy)
          User.all.each(&:destroy)
          @user = User.create!(first_name: 'bob', last_name: 'nancy')
          @post = Post.create!(title: 'bob',
                               body: 'is a swell guy',
                               author: @user)
          # disable clean up so we can get the package.
          allow(builder).to receive(:clean_up) { false }
          builder.serialize(Post.all)
          @package = builder.send(:package)
          @collection = builder.collection
        end

        it 'provides the collection object' do
          expect(@collection.count).to eq(Post.all.count)
        end

        it 'merges our customizations with the default header style' do
          expect(builder.header_style[:sz]).to eq(10)
          expect(builder.header_style[:fg_color]).to eq('FF0000')
          expect(builder.header_style[:bg_color]).to be_nil
        end

        it 'uses the specified i18n_scope' do
          expect(builder.i18n_scope).to eq(%i[axlsx post])
        end

        it 'translates the header row based on our i18n scope' do
          header_row = @package.workbook.worksheets.first.rows[2]
          expect(header_row.cells.map(&:value)).to eq(
            ['Title', 'Content', 'Published On', 'Publisher']
          )
        end

        it 'processes the before filter' do
          created_header = @package.workbook.worksheets.first['A1'].value
          expect(created_header).to eq('Created')
        end

        it 'lets us work against the collection in the before filter' do
          name = @package.workbook.worksheets.first.rows.last.cells.first.value
          expect(name).to eq('Set In Proc nancy')
        end

        it 'processes the after filter' do
          expect(@package.workbook.charts.size).to eq(1)
        end

        it 'has no OOXML validation errors' do
          expect(@package.validate.size).to eq(0)
        end
      end
    end
  end
end
