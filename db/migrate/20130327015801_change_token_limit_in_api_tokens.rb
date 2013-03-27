class ChangeTokenLimitInApiTokens < ActiveRecord::Migration
  def change
    change_column :api_tokens, :token, :string, limit: 32
  end
end
