task :delete_tmp_files do
	FileUtils.rm_rf Dir.glob("#{Rails.root}/public/uploads/tmp/*")
end