class ChangeIdentIdToInt < ActiveRecord::Migration
  def up
    change_column :idents, :project_id, 'integer USING CAST(project_id AS integer)'
    rename_column :idents, :ident_id, :ident_code
  end
  def down
    change_column :idents, :project_id, :string, :limit => 255
    rename_column :idents, :ident_code, :ident_id
  end
end
