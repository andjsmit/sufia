describe "sufia/homepage/index.html.erb", type: :view do
  describe "hello world heading" do
    before do
      allow(view).to receive(:can?).and_return(false)
      stub_template "sufia/homepage/_home_header" => "<h1>Header</h1>"
      stub_template "sufia/homepage/_home_content" => "<p>Content</p>"
      stub_template "sufia/homepage/_featured_works" => "<h2>Featured</h2>"
      stub_template "sufia/homepage/_announcement" => "<h2>Announcement</h2>"
      render
    end
    context "when the index page is viewed" do
      it "displays" do
        expect(rendered).to have_selector 'h2', :text =>  "Hello World"
      end
    end
  end

end
