module Motion
  module Project
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
    
      def fixtures
        @fixtures ||= Dir.glob('./spec/fixtures/*').map { |fn| [fn, :NSDocumentDirectory] }
      end
    
      def fixtures_loader_config
        loader_file = File.join(build_dir, 'fixtures_loader.rb')
      
        f = open(loader_file, 'wb')

        fixtures.each do |fn, dest|
          fn_ap = File.absolute_path(fn)
          base_fn = File.basename(fn)
          f.write(
            "NSFileManager.defaultManager.copyItemAtURL(NSURL.fileURLWithPath(\"#{fn_ap}\"),
              toURL:NSFileManager.defaultManager.URLForDirectory(#{dest.to_s}, inDomain:NSUserDomainMask, appropriateForURL:nil, create:true, error:nil).
              URLByAppendingPathComponent(\"#{base_fn}\"), error:nil)\n"
          )
        end

        f.close
        loader_file
      end
    end # Config
  end # Project
end # Motion
