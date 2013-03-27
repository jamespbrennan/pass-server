class AddIndexesToApiKey < ActiveRecord::Migration
  def change
    add_index :api_tokens, [:api_consumer_id, :api_consumer_type]
    add_index :api_tokens, :token
  end
end
