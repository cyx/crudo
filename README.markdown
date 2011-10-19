# crudo

_n._ A light-weight CRUD generator for Cuba using Mote.

## Description

useful for quickly creating admin backends.

## Usage

    # Let's assume you have some kind of model
    class Article < Sequel::Model
    end

    # in your main cuba app file
    Cuba.send :include, Crudo

    Cuba.define do
      on "articles" do
        run(CRUD(Article, "/articles") do |config|
          config.textfield :title
          config.textarea  :description
          config.dropdown  :status, [["Draft", "draft"], ["Done", "done"]]
        end)
      end
    end
  
    # now in views/article/list.mote
  
    Listing all articles
  
    <a href="/articles/add">Add an Article</a>

    % records.each do |record|
      {{ record.title }}
    % end


