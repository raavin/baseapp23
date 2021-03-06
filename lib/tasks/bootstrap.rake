# To use the Bootstrap Rake task for you own application create
# yaml files in db/bootstrap containing your data.
#
# E.g. to fill the 'users' table, create the yaml file db/bootstrap/users.yml
#
# Next, run 'rake db:bootstrap' to re-initialize your database.
#
namespace :db do
  desc "Recreates the development database and loads the bootstrap data from db/boostrap."
  task :bootstrap do |task_args|
    mkdir_p File.join(RAILS_ROOT, 'log')
    require 'rubygems' unless Object.const_defined?(:Gem)
    %w(environment db:drop db:create db:migrate db:bootstrap:load tmp:create).each { |t| Rake::Task[t].execute task_args}
  end

  namespace :bootstrap do
    desc "Load default bootstrap data into the database"
    task :load => :environment do

      %w(admin user support).each { |r| Role.create(:name => r) }
      # Create admin role and user
      admin_role = Role.find_by_name('admin')
      user = User.create do |u|
        u.login = 'admin'
        u.password = u.password_confirmation = 'admin'
        u.email = 'nospan@example.com'
      end
      user.register!
      user.activate!
      user.roles << admin_role
      profile = user.profile
      profile.nick_name = "Administrator"
      profile.save!
    end
  end
end

