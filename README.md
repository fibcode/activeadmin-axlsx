# Active Admin Axlsx

Office Open XML Spreadsheet Export for [Active Admin]

The original gem is located here: [https://github.com/randym/activeadmin-axlsx](https://github.com/randym/activeadmin-axlsx)

[![Travis CI][travis_badge]][travis]
[![Quality][codeclimate_badge]][codeclimate]
[![Coverage][codecov_badge]][codecov]
[![Inch CI][inch_badge]][inch]

## Synopsis

This gem provides automatic OOXML (xlsx) downloads for Active Admin
resources. It lets you harness the full power of Axlsx when you want to
but for the most part just stays out of your way and adds a link next to
the csv download for xlsx (Excel/numbers/Libre Office/Google Docs)

![Screen 1](screen_capture.png)

## Usage

Simply add the following to your Gemfile and you are good to go.
All resource index views will now include a link for download directly
to xlsx.

```ruby
gem 'activeadmin-axlsx', git: 'https://github.com/thambley/activeadmin-axlsx.git'
```

For Active Admin 1.0, you will also have to update config/initializers/active_admin.rb.  Update the download\_links setting to include xls:

```ruby
config.download_links = %i[csv xml json xlsx]
```

## Examples

Here are a few quick examples of things you can easily tweak.
Axlsx supports A LOT of the specification so if you are looking to do
something adventurous please ping me on irc. (freenode#axlsx)

### localize column headers

```ruby
#app/admin/posts.rb
ActiveAdmin.register Post do
  config.xlsx_builder.i18n_scope = [:active_record, :models, :posts]
end
```

### Use blocks for adding computed fields

```ruby
#app/admin/posts.rb
ActiveAdmin.register Post do
  config.xlsx_builder.column('author_name') do |resource|
    resource.author.name
  end
end
```

### Change the column header style

```ruby
#app/admin/posts.rb
ActiveAdmin.register Post do
  config.xlsx_builder.header_style = { :bg_color => 'FF0000',
                                       :fg_color => 'FF' }
end
```

### Remove columns

```ruby
#app/admin/posts.rb
ActiveAdmin.register Post do
  config.xlsx_builder.delete_columns :id, :created_at, :updated_at
end
```

## Using the DSL

Everything that you do with the config'd default builder can be done via
the resource DSL.

Below is an example of the DSL

```ruby
ActiveAdmin.register Post do

  # i18n_scope and header style are set via options
  xlsx(:i18n_scope => [:active_admin, :axlsx, :post],
       :header_style => {:bg_color => 'FF0000', :fg_color => 'FF' }) do

    # Specify that you want to white list column output.
    # whitelist

    # Do not serialize the header, only output data.
    # skip_header

    # deleting columns from the report
    delete_columns :id, :created_at, :updated_at

    # adding a column to the report
    column(:author) { |resource| "#{resource.author.first_name} #{resource.author.last_name}" }

    # creating a chart and inserting additional data with after_filter
    after_filter { |sheet|
      sheet.add_row []
      sheet.add_row ['Author Name', 'Number of Posts']
      data = []
      labels = []
      User.all.each do |user|
        data << user.posts.size
        labels << "#{user.first_name} #{user.last_name}"
        sheet.add_row [labels.last, data.last]
      end
      chart_color =  %w(88F700 279CAC B2A200 FD66A3 F20062 C8BA2B 67E6F8 DFFDB9 FFE800 B6F0F8)
      sheet.add_chart(::Axlsx::Pie3DChart, :title => "post by author") do |chart|
        chart.add_series :data => data, :labels => labels, :colors => chart_color
        chart.start_at 4, 0
        chart.end_at 7, 20
      end
    }

    # iserting data with before_filter
    before_filter do |sheet|
      sheet.add_row ['Created', Time.zone.now]
      sheet.add_row []
    end
  end
end
```

## Testing

Running specs for this gem requires that you construct a rails application.

To execute the specs, navigate to the gem directory, run bundle install and run these to rake tasks:

### Rails 4.2

```text
bundle install --gemfile=gemfiles/rails_42.gemfile
```

```text
BUNDLE_GEMFILE=gemfiles/rails_42.gemfile bundle exec rake setup
```

```text
BUNDLE_GEMFILE=gemfiles/rails_42.gemfile bundle exec rake
```

### Rails 5.1

```text
bundle install --gemfile=gemfiles/rails_51.gemfile
```

```text
BUNDLE_GEMFILE=gemfiles/rails_51.gemfile bundle exec rake setup
```

```text
BUNDLE_GEMFILE=gemfiles/rails_51.gemfile bundle exec rake
```

## Copyright and License

activeadmin-axlsx &copy; 2012 ~ 2013 by [Randy Morgan](mailto:digial.ipseity@gmail.com).

activeadmin-axlsx is licensed under the MIT license. Please see the LICENSE document for more information.

[Active Admin]:https://www.activeadmin.info/
[activeadmin-axlsx]:https://github.com/randym/activeadmin-axlsx

[travis_badge]: https://img.shields.io/travis/thambley/activeadmin-axlsx/master.svg
[travis]: https://travis-ci.org/thambley/activeadmin-axlsx
[codeclimate_badge]: https://api.codeclimate.com/v1/badges/ea1b67b0133a34817f66/maintainability
[codeclimate]: https://codeclimate.com/github/thambley/activeadmin-axlsx/maintainability
[codecov_badge]: https://codecov.io/gh/thambley/activeadmin-axlsx/branch/master/graph/badge.svg
[codecov]: https://codecov.io/gh/thambley/activeadmin-axlsx
[inch_badge]: http://inch-ci.org/github/thambley/activeadmin-axlsx.svg?branch=master
[inch]: http://inch-ci.org/github/thambley/activeadmin-axlsx