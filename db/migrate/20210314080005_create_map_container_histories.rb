class CreateMapContainerHistories < ActiveRecord::Migration[6.0]
    def up
      create_table :map_container_histories do |t|
        t.string  :uuid
        t.string  :odoo_type
        t.string  :status
        t.string  :user_id
        t.integer :odoo_id
        t.string  :odoo_query
        t.string  :md5sum
        t.string  :description
        t.string  :return_url

        t.timestamps
      end
    end

    def down
      drop_table :map_container_histories
    end
end
