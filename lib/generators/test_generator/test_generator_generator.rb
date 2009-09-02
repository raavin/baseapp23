class TestGeneratorGenerator < Rails::Generator::NamedBase
  
  attr_reader   :controller_name,
                :controller_class_path,
                :controller_file_path,
                :controller_class_nesting,
                :controller_class_nesting_depth,
                :controller_class_name,
                :controller_singular_name,
                :controller_plural_name,
                :controller_routing_name,                 # new_session_path
                :controller_routing_path,                 # /session/new
                :controller_controller_name,              # sessions
                :controller_file_name
  alias_method  :controller_table_name, :controller_plural_name
  attr_reader   :model_controller_name,
                :model_controller_class_path,
                :model_controller_file_path,
                :model_controller_class_nesting,
                :model_controller_class_nesting_depth,
                :model_controller_class_name,
                :model_controller_singular_name,
                :model_controller_plural_name,
                :model_controller_routing_name,           # new_user_path
                :model_controller_routing_path,           # /users/new
                :model_controller_controller_name         # users
  alias_method  :model_controller_file_name,  :model_controller_singular_name
  alias_method  :model_controller_table_name, :model_controller_plural_name

  def initialize(runtime_args, runtime_options = {})
    super

    @controller_name = (args.shift || 'sessions').pluralize
    @model_controller_name = @name.pluralize

    # sessions controller
    base_name, @controller_class_path, @controller_file_path, @controller_class_nesting, @controller_class_nesting_depth = extract_modules(@controller_name)
    @controller_class_name_without_nesting, @controller_file_name, @controller_plural_name = inflect_names(base_name)
    @controller_singular_name = @controller_file_name.singularize
    if @controller_class_nesting.empty?
      @controller_class_name = @controller_class_name_without_nesting
    else
      @controller_class_name = "#{@controller_class_nesting}::#{@controller_class_name_without_nesting}"
    end
    @controller_routing_name  = @controller_singular_name
    @controller_routing_path  = @controller_file_path.singularize
    @controller_controller_name = @controller_plural_name

    # model controller
    base_name, @model_controller_class_path, @model_controller_file_path, @model_controller_class_nesting, @model_controller_class_nesting_depth = extract_modules(@model_controller_name)
    @model_controller_class_name_without_nesting, @model_controller_singular_name, @model_controller_plural_name = inflect_names(base_name)

    if @model_controller_class_nesting.empty?
      @model_controller_class_name = @model_controller_class_name_without_nesting
    else
      @model_controller_class_name = "#{@model_controller_class_nesting}::#{@model_controller_class_name_without_nesting}"
    end
    @model_controller_routing_name    = @table_name
    @model_controller_routing_path    = @model_controller_file_path
    @model_controller_controller_name = @model_controller_plural_name

    
    if options[:dump_generator_attribute_names] 
      dump_generator_attribute_names
    end
  end
  
  def manifest
    record do |m|
      m.template "index.html.erb", "app/views/layouts/#{file_name}.html.erb"
    end
  end
end