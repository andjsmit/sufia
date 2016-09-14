describe "sufia/admin/admin_sets/index.html.erb", type: :view do
  let(:document) { SolrDocument.new }
  let(:ability) { double }
  let(:presenter) { Sufia::AdminSetPresenter(document, ability) }
  context "when no admin sets exists" do
    it "alerts users there are no admin sets" do
      render
      expect(rendered).to have_content("No administrative sets have been created.")
    end
  end

  context "when an admin set exists" do
    let(:presenter) { SolrDocument.new }
    before do
      admin_set = AdminSet.new
      @admin_sets = [admin_set]
      allow(view).to receive(:present?).and_return(true)
      allow(admin_set).to receive(:title).and_return(['Example Admin Set'])
      allow(admin_set).to receive(:creator).and_return(['jdoe@example.com'])
      allow(presenter).to receive(:total_items).and_return('42')
      assign(:presenter, presenter)
    end
    it "lists admin set" do
      render
      expect(rendered).to have_content('Example Admin Set')
      expect(rendered).to have_content('jdoe@example.com')
      expect(rendered).to have_content('42')
    end
  end
end
