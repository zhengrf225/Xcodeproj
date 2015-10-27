require "xcodeproj"
def AddFileToProject(file_path,path,groupName)
  unless Pathname.new(path).exist?
    raise "[Xcodeproj] Unable to open `#{path}` because it doesn't exist."
  end
  project = Xcodeproj::Project.new(path, true)
  project.send(:initialize_from_file)
  target = project.targets.first()
  group = project.main_group.groups.find{|obj| obj.display_name() == groupName}
  group.set_source_tree('SOURCE_ROOT')
  file_ref = group.new_reference(file_path)
  target.add_file_references([file_ref])
  project.save
end
def AddFrameworkToProject(path)
  unless Pathname.new(path).exist?
    raise "[Xcodeproj] Unable to open `#{path}` because it doesn't exist."
  end
  project = Xcodeproj::Project.new(path, true)
  project.send(:initialize_from_file)
  project.main_group.children.each do |child|
    p child.name
  end
end
filepath = ARGV.first
projectpath = ARGV[1]
groupName = ARGV[2]
AddFileToProject(filepath,projectpath,groupName)
