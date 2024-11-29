@user = User.find_or_create_by(email: 'admin@mail.io')
@user.password = 'password'
@user.save

10.times do |i|
  @user = User.find_or_create_by(email: "user#{i}@mail.io")
  @user.password = 'password'
  @user.save
end