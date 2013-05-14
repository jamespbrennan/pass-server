object @session
attributes :id, :is_authenticated

child(:user) { attributes :id, :email } if :user