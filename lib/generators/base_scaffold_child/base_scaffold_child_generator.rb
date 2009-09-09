#require File.dirname(__FILE__) + '/base_default_values'

class BaseScaffoldChildGenerator < Rails::Generator::NamedBase
  default_options :skip_timestamps => false, :skip_migration => false, :force_plural => false

  attr_reader   :controller_name,
                :controller_class_path,
                :controller_file_path,
                :controller_class_nesting,
                :controller_class_nesting_depth,
                :controller_class_name,
                :controller_underscore_name,
                :controller_singular_name,
                :controller_plural_name,
                :controller_routing_name,                 # new_session_path
                :controller_routing_path,                 # /session/new
                :controller_controller_name,              # sessions
                :controller_file_name
  alias_method  :controller_table_name, :controller_plural_name
  attr_reader   :parent_controller_name,
                :parent_controller_class_path,
                :parent_controller_file_path,
                :parent_controller_class_nesting,
                :parent_controller_class_nesting_depth,
                :parent_controller_class_name,
                :parent_controller_underscore_name,
                :parent_controller_singular_name,
                :parent_controller_plural_name,
                :parent_controller_routing_name,           # new_user_path
                :parent_controller_routing_path,           # /users/new
                :parent_controller_controller_name         # users
  alias_method  :parent_controller_file_name,  :parent_controller_singular_name
  alias_method  :parent_controller_table_name, :parent_controller_plural_name

  def initialize(runtime_args, runtime_options = {})
    super


    @controller_name = (args.shift || 'sessions').pluralize
    @parent_controller_name = @name.pluralize

    # sessions controller
    base_name, @controller_class_path, @controller_file_path, @controller_class_nesting, @controller_class_nesting_depth = extract_modules(@controller_name)
    @controller_class_name_without_nesting, @controller_underscore_name, @controller_file_name, @controller_plural_name = inflect_names(base_name)
    @controller_singular_name = @controller_file_name.singularize
    if @controller_class_nesting.empty?
      @controller_class_name = @controller_class_name_without_nesting.singularize
    else
      @controller_class_name = "#{@controller_class_nesting}::#{@controller_class_name_without_nesting}".singularize
    end
    @controller_routing_name  = @controller_singular_name
    @controller_routing_path  = @controller_file_path.singularize
    @controller_controller_name = @controller_plural_name

    # parent controller
    base_name, @parent_controller_class_path, @parent_controller_file_path, @parent_controller_class_nesting, @parent_controller_class_nesting_depth = extract_modules(@parent_controller_name)
    @parent_controller_class_name_without_nesting, @parent_controller_underscore_name,@parent_controller_singular_name, @parent_controller_plural_name = inflect_names(base_name)

    if @parent_controller_class_nesting.empty?
      @parent_controller_class_name = @parent_controller_class_name_without_nesting
    else
      @parent_controller_class_name = "#{@parent_controller_class_nesting}::#{@parent_controller_class_name_without_nesting}"
    end
    @parent_controller_routing_name    = @table_name
    @parent_controller_routing_path    = @parent_controller_file_path
    @parent_controller_controller_name = @parent_controller_plural_name

    
    if options[:dump_generator_attribute_names] 
      dump_generator_attribute_names
    end
  end

  def manifest
    record do |m|
      # Check for class naming collisions.
      m.class_collisions("#{controller_class_name}Controller", "#{controller_class_name}Helper")
      m.class_collisions(class_name)

      # Controller, helper, views, test and stylesheets directories.
      m.directory(File.join('app/models', class_path))
      m.directory(File.join('app/controllers', class_path))
      m.directory(File.join('app/helpers', class_path))
      m.directory(File.join('app/views', class_path, table_name))
      m.directory(File.join('app/views/layouts', class_path))
      #m.directory(File.join('test/functional', class_path))
      #m.directory(File.join('test/unit', class_path))
      #m.directory(File.join('test/unit/helpers', class_path))
      m.directory(File.join('spec/controllers', class_path))
      m.directory(File.join('spec/routing', class_path))
      m.directory(File.join('spec/models', class_path))
      m.directory(File.join('spec/helpers', class_path))
      m.directory File.join('spec/fixtures', class_path)
      m.directory File.join('spec/views', class_path, table_name)
      #m.directory(File.join('public/stylesheets', class_path))

      for action in scaffold_views
        m.template(
          "view_#{action}.html.erb",
          File.join('app/views', class_path, table_name, "#{action}.html.erb")
        )
      end

      # Layout and stylesheet.
      # m.template('layout.html.erb', File.join('app/views/layouts', controller_class_path, "#{controller_file_name}.html.erb"))
      # m.template('style.css', 'public/stylesheets/scaffold.css')

      m.template(
        'controller.rb', File.join('app/controllers', controller_class_path, "#{table_name}_controller.rb")
      )

      m.template 'helper.rb',         File.join('app/helpers',     controller_class_path, "#{table_name}_helper.rb")

      # Specs
      m.template 'routing_spec.rb',   File.join('spec/routing', controller_class_path, "#{table_name}_routing_spec.rb")
      m.template 'controller_spec.rb',File.join('spec/controllers', controller_class_path, "#{table_name}_controller_spec.rb")
      m.template 'model_spec.rb',     File.join('spec/models', class_path, "#{table_name}_spec.rb")
      m.template 'helper_spec.rb',    File.join('spec/helpers', class_path, "#{table_name}_helper_spec.rb")

      # View specs
      m.template "edit_erb_spec.rb",  File.join('spec/views', controller_class_path, table_name, "edit.html.erb_spec.rb")
      m.template "index_erb_spec.rb", File.join('spec/views', controller_class_path, table_name, "index.html.erb_spec.rb")
      m.template "new_erb_spec.rb",   File.join('spec/views', controller_class_path, table_name, "new.html.erb_spec.rb")
      m.template "show_erb_spec.rb",  File.join('spec/views', controller_class_path, table_name, "show.html.erb_spec.rb")

      m.route_resources table_name

      m.dependency 'model', [name] + @args, :collision => :skip
    end
  end

  protected
    # Override with your own usage banner.
    def banner
      "Usage: #{$0} base_scaffold_child ChildName ParentName [field:type, field:type]"
    end

    def add_options!(opt)
      opt.separator ''
      opt.separator 'Options:'
      opt.on("--skip-timestamps",
             "Don't add timestamps to the migration file for this model") { |v| options[:skip_timestamps] = v }
      opt.on("--skip-migration",
             "Don't generate a migration file for this model") { |v| options[:skip_migration] = v }
      opt.on("--force-plural",
             "Forces the generation of a plural ModelName") { |v| options[:force_plural] = v }
    end

    def scaffold_views
      %w[ index show new edit _form ]
    end

    def model_name
      class_name.demodulize
  end
    def dump_generator_attribute_names
    generator_attribute_names = [
      :table_name,
      :file_name,
      :class_name,
      :controller_name,
      :controller_class_path,
      :controller_file_path,
      :controller_class_nesting,
      :controller_class_nesting_depth,
      :controller_class_name,
      :controller_underscore_name,
      :controller_singular_name,
      :controller_plural_name,
      :controller_routing_name,                 # new_session_path
      :controller_routing_path,                 # /session/new
      :controller_controller_name,              # sessions
      :controller_file_name,
      :controller_table_name, :controller_plural_name,
      :parent_controller_name,
      :parent_controller_class_path,
      :parent_controller_file_path,
      :parent_controller_class_nesting,
      :parent_controller_class_nesting_depth,
      :parent_controller_class_name,
      :parent_controller_underscore_name,
      :parent_controller_singular_name,
      :parent_controller_plural_name,
      :parent_controller_routing_name,           # new_user_path
      :parent_controller_routing_path,           # /users/new
      :parent_controller_controller_name,        # users
      :parent_controller_file_name,  :parent_controller_singular_name,
      :parent_controller_table_name, :parent_controller_plural_name,
    ]
    generator_attribute_names.each do |attr|
      puts "%-40s %s" % ["#{attr}:", self.send(attr)]  # instance_variable_get("@#{attr.to_s}"
    end

  end
end


module Rails
  module Generator
    class GeneratedAttribute
      def input_type
        @input_type ||= case type
          when :text                        then "textarea"
          else
            "input"
        end
      end
      def default_value
        @default_value ||= case type
          when :int, :integer               then "1"
          when :float                       then "1.5"
          when :decimal                     then "9.99"
          when :datetime, :timestamp, :time then "Time.now"
          when :date                        then "Date.today"
          when :string, :text               then "\"value for #{@name}\""
          when :boolean                     then "false"
          else
            ""
        end
      end
    end
  end
end

# ./script/generate authenticated FoonParent::Foon SporkParent::Spork -p --force --rspec --dump-generator-attrs
# table_name:                              foon_parent_foons
# file_name:                               foon
# class_name:                              FoonParent::Foon
# controller_name:                         SporkParent::Sporks
# controller_class_path:                   spork_parent
# controller_file_path:                    spork_parent/sporks
# controller_class_nesting:                SporkParent
# controller_class_nesting_depth:          1
# controller_class_name:                   SporkParent::Sporks
# controller_singular_name:                spork
# controller_plural_name:                  sporks
# controller_routing_name:                 spork
# controller_routing_path:                 spork_parent/spork
# controller_controller_name:              sporks
# controller_file_name:                    sporks
# controller_table_name:                   sporks
# controller_plural_name:                  sporks
# model_controller_name:                   FoonParent::Foons
# model_controller_class_path:             foon_parent
# model_controller_file_path:              foon_parent/foons
# model_controller_class_nesting:          FoonParent
# model_controller_class_nesting_depth:    1
# model_controller_class_name:             FoonParent::Foons
# model_controller_singular_name:          foons
# model_controller_plural_name:            foons
# model_controller_routing_name:           foon_parent_foons
# model_controller_routing_path:           foon_parent/foons
# model_controller_controller_name:        foons
# model_controller_file_name:              foons
# model_controller_singular_name:          foons
# model_controller_table_name:             foons
# model_controller_plural_name:            foons
