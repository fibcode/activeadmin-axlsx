require 'spec_helper'
describe Admin::CategoriesController, type: :controller do
  let(:mime) { Mime::Type.lookup_by_extension(:xlsx) }

  let(:filename) { "#{controller.resource_class.to_s.downcase.pluralize}-#{Time.now.strftime("%Y-%m-%d")}.xlsx" }

  it 'generates an xlsx filename' do
    expect(controller.xlsx_filename).to eq(filename)
  end

  context 'when making requests with the xlsx mime type' do
    it 'returns xlsx attachment when requested' do
      request.accept = mime
      get :index
      disposition = "attachment; filename=\"#{filename}\""
      expect(response.headers['Content-Disposition']).to eq(disposition)
      expect(response.headers['Content-Transfer-Encoding']).to eq('binary')
    end
  end
end
