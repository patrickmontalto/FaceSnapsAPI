task :delete_tmp_files do
	FileUtils.rm_rf Dir.glob("#{Rails.root}/public/uploads/tmp/*")
end

task :delete_public_files do
	FileUtils.rm_rf Dir.glob("#{Rails.root}/public/*")
end