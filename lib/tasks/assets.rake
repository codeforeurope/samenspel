namespace :assets do
 
desc "Check that all assets have valid encoding"
  task :check => :environment do
    paths = ["app/javascripts"]
   
    paths.each do |path|
      dir_path = Rails.root + path
   
      if File.exists?(dir_path)
        dir_files = File.join(dir_path, "**")
   
        Dir.glob(dir_files + "/**.{js,css}").each do |file|
   
          # make sure we're not trying to process a directory
          unless File.directory?(file)
            # read the file and check its encoding
            data = File.read(file)
              unless data.valid_encoding?
                puts "#{ file } does not have valid encoding!"
              end
          end
   
        end # end Dir.glob
   
      end #end File.exists
    end # end paths.each
   
  end
 
end
