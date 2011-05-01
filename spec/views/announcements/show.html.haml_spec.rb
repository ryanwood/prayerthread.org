require 'spec_helper'

describe "announcements/show.html.haml" do
  before(:each) do
    @announcement = assign(:announcement, stub_model(Announcement,
      :message => "MyText"
    ))
  end

  it "renders attributes in <p>" do
    render
    # Run the generator again with the --webrat-matchers flag if you want to use webrat matchers
    rendered.should match(/MyText/)
  end
end
