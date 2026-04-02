class UserSerializer
  def initialize(user)
    @user = user
  end

  def as_json(*)
    {
      id: @user.id,
      name: @user.name,
      email: @user.email,
      user_type: @user.user_type,
      created_at: @user.created_at,
      updated_at: @user.updated_at
    }
  end
end
