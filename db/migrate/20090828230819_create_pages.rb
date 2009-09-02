class CreatePages < ActiveRecord::Migration
    create_table :pages do |t|
      t.string   :url
      t.string   :page_title
      t.text     :keywords
      t.text     :description
      t.string   :title
      t.text     :content
      t.boolean  :has_form
      t.text     :form_message

      t.timestamps
    end

  def self.down
    drop_table :pages
  end
end
