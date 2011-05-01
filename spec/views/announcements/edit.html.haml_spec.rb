require 'spec_helper'

describe "announcements/edit.html.haml" do
  before(:each) do
    @announcement = assign(:announcement, stub_model(Announcement,
      :new_record? => false,
      :message => "MyText"
    ))
  end

  it "renders the edit announcement form" do
    render

    # Run the generator again with the --webrat-matchers flag if you want to use webrat matchers
    assert_select "form", :action => announcement_path(@announcement), :method => "post" do
      assert_select "textarea#announcement_message", :name => "announcement[message]"
    end
  end
end
