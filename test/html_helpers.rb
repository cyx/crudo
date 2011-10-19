require_relative "helper"

class Article < Struct.new(:id, :title, :description, :secret, :when, :status)
  def new?
    id.nil?
  end
end

Cuba.use Rack::Session::Cookie

Cuba.define {
  on "articles" do
    run(CRUD(Article, "/articles") { |c|
      c.textfield :title
      c.textarea  :description
      c.password_field :secret
      c.datefield :when
      c.dropdown :status, [["Draft", "draft"], ["Done", "done"]]
    })
  end
}

scope do
  test do
    override(Article, :[] => Article.new(1, "Foo", "Bar", "s3cr3t", "1982-10-18"))
    visit "/articles/1"

    assert has_css?('input[type=text][name="article[title]"][value=Foo]')
    assert has_css?('textarea[name="article[description]"]', text: "Bar")
    assert has_css?('input.date[type=text][name="article[when]"][value="1982-10-18"]')

    assert has_css?('select[name="article[status]"] > option[value="draft"]', text: "Draft")
    assert has_css?('select[name="article[status]"] > option[value="done"]', text: "Done")
  end
end