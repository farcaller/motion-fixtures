module Motion; module Project
  class Config
    alias :motion_fixtures_original_spec_files :spec_files
    def spec_files
      fixtures_loader = File.expand_path(fixtures_loader_config)
      return motion_fixtures_original_spec_files if motion_fixtures_original_spec_files.include? fixtures_loader

      index = motion_fixtures_original_spec_files.find_index do |file|
        file.include? "/lib/motion/spec.rb"
      end

      motion_fixtures_original_spec_files.insert(index + 1, fixtures_loader)
    end
    
    attr_accessor :fixtures
    
    def fixtures_loader_config
      loader_file = File.join(build_dir, 'fixtures_loader.rb')
      
      f = open(loader_file, 'wb')

      fixtures.each do |fn, dest|
        filename = File.basename(fn)
        f.write(
          "NSFileManager.defaultManager.createDirectoryAtPath(NSHomeDirectory+\"/#{dest}\"), " +
          "withIntermediateDirectories:true, attributes:nil, error:nil)\n" +

          "NSFileManager.defaultManager.copyItemAtPath(\"#{fn}\"), " +
          "toPath:NSHomeDirectory+\"/#{dest}/#{filename}\", error:nil"
        )

      end
      

      f.close
      loader_file
    end
  end
end ; end
