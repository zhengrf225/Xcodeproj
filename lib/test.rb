require "xcodeproj"
def AddFileToProject(file_path,path,groupName)
  unless Pathname.new(path).exist?
    raise "[Xcodeproj] Unable to open `#{path}` because it doesn't exist."
  end
  file_path_array = file_path.split("/",-1)
  file_name = file_path_array[file_path_array.length-1]
  project = Xcodeproj::Project.new(path, true)
  project.send(:initialize_from_file)
  target = project.targets.first()
  project.files.find{|obj|
    if obj.display_name == file_name
      puts "改项目已含有 "+obj.display_name+" 文件"
      return
    end
  }
  return
  group = project.main_group.groups.find{|obj| obj.to_s == groupName}
  if group == nil
    group = project.new_group(groupName)
  end
  group.set_source_tree('SOURCE_ROOT')
  file_ref = group.new_reference(file_path)
  file_ref.set_path(file_path)
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
